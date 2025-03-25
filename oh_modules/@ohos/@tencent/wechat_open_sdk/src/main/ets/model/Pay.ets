import { BaseReq, BaseResp, Log } from '../../../../Index'
import { Command } from './Constants'

const EXTDATA_MAX_LENGTH = 1024

export class PayReq extends BaseReq {
  protected get TAG() {
    return "PaySdk.PayReq"
  }

  appId?: string
  partnerId?: string
  prepayId?: string
  nonceStr?: string
  timeStamp?: string
  packageValue?: string
  sign?: string
  extData?: string
  signType?: string

  checkArgs(): boolean {
    if (this.appId?.length === 0) {
      Log.e(this.TAG, "checkArgs fail, invalid appId")
      return false
    }

    if (this.partnerId?.length === 0) {
      Log.e(this.TAG, "checkArgs fail, invalid partnerId")
      return false
    }

    if (this.prepayId?.length === 0) {
      Log.e(this.TAG, "checkArgs fail, invalid prepayId")
      return false
    }

    if (this.nonceStr?.length === 0) {
      Log.e(this.TAG, "checkArgs fail, invalid nonceStr")
      return false
    }

    if (this.timeStamp?.length === 0) {
      Log.e(this.TAG, "checkArgs fail, invalid timeStamp")
      return false
    }

    if (this.packageValue?.length === 0) {
      Log.e(this.TAG, "checkArgs fail, invalid packageValue")
      return false
    }

    if (this.sign?.length === 0) {
      Log.e(this.TAG, "checkArgs fail, invalid sign")
      return false
    }

    if (this.extData && this.extData.length > EXTDATA_MAX_LENGTH) {
      Log.e(this.TAG, "checkArgs fail, extData length too long")
      return false
    }

    return true
  }

  serializeTo(to: object): void {
    super.serializeTo(to)
    to['appId'] = this.appId
    to['partnerId'] = this.partnerId
    to['prepayId'] = this.prepayId
    to['nonceStr'] = this.nonceStr
    to['timeStamp'] = this.timeStamp
    to['packageValue'] = this.packageValue
    to['sign'] = this.sign
    to['extData'] = this.extData
    to['signType'] = this.signType
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
    this.appId = from['appId']
    this.partnerId = from['partnerId']
    this.prepayId = from['prepayId']
    this.nonceStr = from['nonceStr']
    this.timeStamp = from['timeStamp']
    this.packageValue = from['packageValue']
    this.sign = from['sign']
    this.extData = from['extData']
    this.signType = from['signType']
  }

  get type(): number {
    return Command.kCommandPay
  }
}

export class PayResp extends BaseResp {
  prepayId?: string
  returnKey?: string
  extData?: string

  serializeTo(to: object): void {
    super.serializeTo(to)
    to['prepayId'] = this.prepayId
    to['returnKey'] = this.returnKey
    to['extData'] = this.extData
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
    this.prepayId = from['prepayId']
    this.returnKey = from['returnKey']
    this.extData = from['extData']
  }

  get type(): number {
    return Command.kCommandPay
  }
}

export class JointPayReq extends PayReq {
  protected get TAG() {
    return "PaySdk.JointPayReq"
  }

  get type(): number {
    return Command.kCommandJointPay
  }
}

export class JointPayResp extends PayResp {

  get type(): number {
    return Command.kCommandJointPay
  }
}