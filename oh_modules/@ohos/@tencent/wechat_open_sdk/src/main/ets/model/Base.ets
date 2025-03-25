
export abstract class BaseReq {
  id: number = 0;
  readonly name: string = this.constructor.name

  transaction?: string
  openId?: string

  /**
   * 微信跳回宿主App时拉起的ability名字，如果不填则默认是'EntryAbility'
   */
  callbackAbility?: string

  abstract checkArgs(): boolean
  abstract get type(): number

  serializeTo(to: object): void {
    to['__type__'] = this.type
    to['transaction'] = this.transaction
    to['openId'] = this.openId
    to['callbackAbility'] = this.callbackAbility
  }
  deserializeFrom(from: object): void {
    this.transaction = from['transaction']
    this.openId = from['openId']
    this.callbackAbility = from['callbackAbility']
  }
}

export enum ErrCode {
  ERR_OK = 0,
  ERR_COMM = -1,
  ERR_USER_CANCEL = -2,
  ERR_SENT_FAILED = -3,
  ERR_AUTH_DENIED = -4,
  ERR_UNSUPPORTED = -5,
  ERR_BAN = -6,

  ERR_SCOPE_SNSAPI_WXAAPP_INFO_CAN_ONLY_AUTHORIZED_SEPARATELY = -1000,
}

export abstract class BaseResp {
  id: number = 0;
  readonly name: string = this.constructor.name

  errCode: number = ErrCode.ERR_OK
  errStr?: string
  transaction?: string
  openId?: string

  abstract get type(): number

  serializeTo(to: object): void {
    to['__type__'] = this.type
    to['errCode'] = this.errCode
    to['errStr'] = this.errStr
    to['transaction'] = this.transaction
    to['openId'] = this.openId
  }
  deserializeFrom(from: object): void {
    this.errCode = from['errCode'] ?? ErrCode.ERR_COMM
    this.errStr = from['errStr']
    this.transaction = from['transaction']
    this.openId = from['openId']
  }
}

export type SendReqResult = boolean
export type SendReqResultWrap = SendReqResult | Promise<SendReqResult>

