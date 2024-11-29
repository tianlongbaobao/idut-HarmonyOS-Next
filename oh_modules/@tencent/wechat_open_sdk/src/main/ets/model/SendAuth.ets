import { BaseReq, BaseResp } from './Base'
import { Command } from './Constants'

export class SendAuthReq extends BaseReq {
  scope?: string
  state?: string
  extData?: string
  isOption1: boolean = false
  nonAutomatic: boolean = false

  checkArgs(): boolean {
    this.scope = this.scope?.trim()
    if ((this.scope?.length ?? 0) === 0) {
      return false
    }
    return true
  }

  serializeTo(to: object): void {
    super.serializeTo(to)
    to['scope'] = this.scope
    to['state'] = this.state
    to['extData'] = this.extData
    to['isOption1'] = this.isOption1
    to['nonAutomatic'] = this.nonAutomatic
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
    this.scope = from['scope']
    this.state = from['state']
    this.extData = from['extData']
    this.isOption1 = from['isOption1'] ?? false
    this.nonAutomatic = from['nonAutomatic'] ?? false
  }

  get type(): number {
    return Command.kCommandSendAuth
  }
}

export class SendAuthResp extends BaseResp {
  code?: string
  state?: string
  authResult: boolean = false
  url?: string
  lang?: string
  country?: string

  serializeTo(to: object): void {
    super.serializeTo(to)
    to['code'] = this.code
    to['state'] = this.state
    to['authResult'] = this.authResult
    to['url'] = this.url
    to['lang'] = this.lang
    to['country'] = this.country
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
    this.code = from['code']
    this.state = from['state']
    this.authResult = from['authResult']
    this.url = from['url']
    this.lang = from['lang']
    this.country = from['country']
  }

  get type(): number {
    return Command.kCommandSendAuth
  }
}

