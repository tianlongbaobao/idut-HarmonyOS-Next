import { IMediaObject, MediaObjectType } from './SendMessageToWX';

export class WXWebpageObject implements IMediaObject {

  type: number = MediaObjectType.TYPE_URL

  /**
   * html 链接
   * @note 长度大于0且不超过10KB
   */
  webpageUrl?: string

  serializeTo(to: object): void {
    to['wx_webpage_url'] = this.webpageUrl
  }

  deserializeFrom (from: object): void {
    this.webpageUrl = from["wx_webpage_url"]
  }

  checkArgs(): boolean {
    if (this.webpageUrl == undefined || this.webpageUrl.length == 0) {
      return false
    }
    return true
  }
}