import { IMediaObject, MediaObjectType } from './SendMessageToWX';
import { buffer, util } from '@kit.ArkTS';
import { image } from '@kit.ImageKit';

export class WXImageObject implements IMediaObject {
  /** 图片的uri
   * @note 支持jpeg/png类型的图片
   */
  uri?: string

  /** 图片的数据内容
   * @note 大小不能超过100KB，uri和imageData同时存在时忽略该字段
   */
  imageData?: string

  type = MediaObjectType.TYPE_IMAGE

  serializeTo(to: object) {
    to['imageBase64'] = this.imageData
    to['uri'] = this.uri
  }

  deserializeFrom(from: object) {
    this.imageData = from['imageBase64']
    this.uri = from['uri']
  }

  checkArgs(): boolean {
    if (this.uri === undefined) {
      return false
    }
    return true
  }
}