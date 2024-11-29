import { BaseResp } from '../../../../../Index';
import { BaseReq } from '../../../../../Index';
import { Command } from '../Constants';
import { WXMediaObjectFactory } from './WXMediaObjectFactory';

export class SendMessageToWXReq extends BaseReq {
  /**
   * 表示发送到会话
   */
  static readonly WXSceneSession: number = 0

  /** 发送消息的多媒体内容
   * @see WXMediaMessage
   */
  message?: WXMediaMessage

  /** 发送的目标场景。 默认发送到会话。
   * @see WXScene
   */
  scene: number = SendMessageToWXReq.WXSceneSession

  serializeTo(to: object): void {
    super.serializeTo(to)
    if (this.message !== undefined) {
      let messageDict: ESObject = {}
      this.message.serializeTo(messageDict)
      to['message'] = messageDict
    }
    to['scene'] = this.scene
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
    if (typeof from['message'] !== 'undefined') {
      this.message = new WXMediaMessage
      this.message.deserializeFrom(from['message'])
    }
    this.scene = from['scene']
  }

  checkArgs(): boolean {
    if (this.message === undefined) {
      return false
    }
    return this.message.checkArgs()
  }

  get type() {
    return Command.kCommandSendMessageToWX
  }
}

export class SendMessageToWXResp extends BaseResp {

  serializeTo(to: object): void {
    super.serializeTo(to)
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
  }

  get type() {
    return Command.kCommandSendMessageToWX
  }
}

export enum MediaObjectType {
  TYPE_TEXT = 1,
  TYPE_IMAGE = 2,
}

export interface IMediaObject {
  serializeTo: (to: object) => void
  deserializeFrom: (from: object) => void

  type: number

  checkArgs: () => boolean
}

export class WXMediaMessage {
  /** 标题
   * @note 长度不能超过512字节
   */
  title?: string = ''

  mediaObject?: IMediaObject

  /** 缩略图数据
   * @note 大小不能超过64K
   */
  thumbData?: Uint8Array

  // 统计使用，客户端不做解析
  mediaTagName?: string

  // 第三方和微信开放平台约定
  messageAction?: string
  // 第三方自定义，微信不做解析
  messageExt?: string

  serializeTo(to: object) {
    to['wx_media_message_title'] = this.title
    if (this.mediaObject !== undefined) {
      to['wx_media_message_media_object_type'] = this.mediaObject.type
      let mediaObjectDict: ESObject = {}
      this.mediaObject.serializeTo(mediaObjectDict)
      to['wx_media_message_media_object'] = mediaObjectDict
    }
    to['wx_media_message_media_tag_name'] = this.mediaTagName
    to['wx_media_message_message_action'] = this.messageAction
    to['wx_media_message_message_ext'] = this.messageExt
  }

  deserializeFrom(from: object) {
    this.title = from['wx_media_message_title']
    if (typeof from['wx_media_message_media_object_type'] === 'number' &&
        typeof from['wx_media_message_media_object'] === 'object') {
      let mediaObject: IMediaObject | undefined = WXMediaObjectFactory.createMediaObject(from['wx_media_message_media_object_type'])
      if (mediaObject !== undefined) {
        mediaObject.deserializeFrom(from['wx_media_message_media_object'])
      }
      this.mediaObject = mediaObject
    }
    this.mediaTagName = from['wx_media_message_media_tag_name']
    this.messageAction = from['wx_media_message_message_action']
    this.messageExt = from['wx_media_message_message_ext']
  }

  checkArgs(): boolean {
    if (this.mediaObject === undefined) {
      return false
    }
    return this.mediaObject.checkArgs()
  }
}