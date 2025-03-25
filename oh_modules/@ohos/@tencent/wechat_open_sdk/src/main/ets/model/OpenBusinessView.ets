import { Log } from '../log/Log';
import { BaseReq, BaseResp } from "./Base";
import { Command } from "./Constants";

export class OpenBusinessViewReq extends BaseReq {
  private kTag = 'wxopensdk::OpenBusinessView'
  businessType?: string
  query?: string
  extInfo?: string

  checkArgs(): boolean {
    if (!this.businessType || this.businessType.length === 0) {
      Log.e(this.kTag, 'businessType is invalid')
      return false
    }
    return true
  }

  serializeTo(to: object): void {
    super.serializeTo(to)
    to['businessType'] = this.businessType
    to['query'] = this.query
    to['extInfo'] = this.extInfo
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
    this.businessType = from['businessType']
    this.query = from['query']
    this.extInfo = from['extInfo']
  }

  get type() {
    return Command.kCommandOpenBusinessView
  }
}

export class OpenBusinessViewResp extends BaseResp {
  extMsg?: string
  businessType?: string

  serializeTo(to: object): void {
    super.serializeTo(to)
    to['extMsg'] = this.extMsg
    to['businessType'] = this.businessType
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
    this.extMsg = from['extMsg']
    this.businessType = from['businessType']
  }

  get type() {
    return Command.kCommandOpenBusinessView
  }
}