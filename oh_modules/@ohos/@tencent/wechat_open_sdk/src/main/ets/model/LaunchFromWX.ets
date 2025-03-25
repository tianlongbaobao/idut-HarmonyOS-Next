import { BaseReq, BaseResp } from "./Base";
import { Command } from "./Constants";
import { WXMediaMessage } from "./message/SendMessageToWX";

export class LaunchFromWXReq extends BaseReq {

  /** 发送消息的多媒体内容
   * @see WXMediaMessage
   */
  message?: WXMediaMessage

  lang?: string
  country?: string

  serializeTo(to: object): void {
    super.serializeTo(to)
    if (this.message) {
      let messageDict: Record<string, ESObject> = {}
      this.message.serializeTo(messageDict)
      to['message'] = messageDict
    }
    to['lang'] = this.lang
    to['country'] = this.country
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
    if (typeof from['message'] !== 'undefined') {
      this.message = new WXMediaMessage
      this.message.deserializeFrom(from['message'])
    }
    this.lang = from['lang']
    this.country = from['country']
  }

  checkArgs(): boolean {
    return true
  }

  get type() {
    return Command.kCommandLaunchFromWX
  }
}