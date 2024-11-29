import { SendAuthReq, SendAuthResp } from './SendAuth'
import { Command } from './Constants'

export class SendTdiAuthReq extends SendAuthReq {

  get type() {
    return Command.kCommandSendTdiAuth
  }
}

export class SendTdiAuthResp extends SendAuthResp {
  tdiAuthBuffer?: Uint8Array

  serializeTo(to: object): void {
    super.serializeTo(to)
    to['tdiAuthBuffer'] = this.tdiAuthBuffer
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
    this.tdiAuthBuffer = from['tdiAuthBuffer']
  }

  get type() {
    return Command.kCommandSendTdiAuth
  }
}
