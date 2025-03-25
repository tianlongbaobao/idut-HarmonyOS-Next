import { IMediaObject, MediaObjectType } from './SendMessageToWX';
import { Log } from '../../log/Log'

const TAG = "wxopensdk::WXMiniProgramObject"

/**
 * 小程序版本
 */
export enum WXMiniProgramType {
  RELEASE = 0,
  TEST = 1,
  PREVIEW = 2
}

/**
 * 描述一个小程序对象
 */
export class WXMiniProgramObject implements IMediaObject {

  type: number = MediaObjectType.TYPE_OPENSDK_APPBRAND

  /**
   * html 链接
   * @note: 长度大于0且不超过10KB<
   */
  webpageUrl?: string

  /**
   * 小程序的原始id
   */
  userName?: string

  /**
   * 小程序的path
   */
  path?: string

  /**
   * 是否使用带shareTicket的分享
   */
  withShareTicket?: boolean

  /**
   * 小程序的类型，默认正式版
   */
  miniprogramType?: WXMiniProgramType

  /**
   * 是否禁止转发
   */
  disableForward: boolean = false

  /**
   * 是否是动态消息
   */
  isUpdatableMessage: boolean = false

  /**
   * 是否是私密消息
   */
  isSecretMessage: boolean = false

  /**
   * 业务所需的额外信息
   */
  extraInfoMap?: Map<string, string>

  serializeTo(to: object): void {
    to["wx_miniprogram_wepageurl"] = this.webpageUrl
    to["wx_miniprogram_username"] = this.userName
    to["wx_miniprogram_path"] = this.path
    to["wx_miniprogram_withshareticket"] = this.withShareTicket
    to["wx_miniprogram_type"] = this.miniprogramType
    to["wx_miniprogram_disableforward"] = this.disableForward
    to["wx_miniprogram_isupdatablemsg"] = this.isUpdatableMessage
    to["wx_miniprogram_issecretmsg"] = this.isSecretMessage
    if (this.extraInfoMap != undefined) {
      const extraInfoObject: Record<string, string> = {}
      this.extraInfoMap.forEach((value, key) => {
        extraInfoObject[key] = value
      })
      to["wx_miniprogram_extrainfo"] = extraInfoObject
    }
  }

  deserializeFrom(from: object): void {
    this.webpageUrl = from["wx_miniprogram_wepageurl"]
    this.userName = from["wx_miniprogram_username"]
    this.path = from["wx_miniprogram_path"]
    this.withShareTicket = from["wx_miniprogram_withshareticket"]
    this.miniprogramType = from["wx_miniprogram_type"]
    this.disableForward = from["wx_miniprogram_disableforward"]
    this.isUpdatableMessage = from["wx_miniprogram_isupdatablemsg"]
    this.isSecretMessage = from["wx_miniprogram_issecretmsg"]
    if (from["wx_miniprogram_extrainfo"] != undefined) {
      const extraInfoObject: Record<string, string> = from["wx_miniprogram_extrainfo"]
      this.extraInfoMap = new Map(Object.entries(extraInfoObject))
    }
  }

  checkArgs(): boolean {
    if (this.userName == undefined || this.userName.length == 0) {
      Log.i(TAG, `checkArgs, userName is null`)
      return false
    }

    if (this.miniprogramType == undefined || this.miniprogramType < WXMiniProgramType.RELEASE || this.miniprogramType > WXMiniProgramType.PREVIEW) {
      Log.i(TAG, `checkArgs, miniprogramType is invalid`)
      return false
    }

    return true
  }

  putExtra(key: string, value: string): void {
    if (this.extraInfoMap == undefined) {
      this.extraInfoMap = new Map()
    }
    this.extraInfoMap!.set(key, value)
  }

  getExtra(key: string, defaultValue: string): string {
    return this.extraInfoMap?.get(key) ?? defaultValue
  }
}