import { Log } from '../log/Log';
import { BaseReq, BaseResp } from './Base';
import { Command } from './Constants';

export class LaunchMiniProgramReq extends BaseReq {
  private kTag = 'wxopensdk::LaunchMiniProgramReq'

  /**
   * 小程序的原始id，必填
   */
  userName?: string

  /**
   * 小程序的启动路径，可不填
   */
  path?: string

  /**
   * 小程序的类型，0-正式版 1-开发版 2-体验版，
   * 可不填，不填则默认为0
   */
  miniprogramType?: number

  extraData?: string

  checkArgs(): boolean {
    if (!this.userName || this.userName.length === 0) {
      Log.e(this.kTag, "userName is invalid")
      return false
    }
    return true
  }

  serializeTo(to: object): void {
    super.serializeTo(to)
    to['userName'] = this.userName
    to['path'] = this.path
    to['miniprogramType'] = this.miniprogramType
    to['extraData'] = this.extraData
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
    this.userName = from['userName']
    this.path = from['path']
    this.miniprogramType = from['miniprogramType']
    this.extraData = from['extraData']
  }

  get type() {
    return Command.kCommandLaunchMiniProgram
  }
}

export class LaunchMiniProgramResp extends BaseResp {

  extMsg?: string

  serializeTo(to: object): void {
    super.serializeTo(to)
    to['extMsg'] = this.extMsg
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
    this.extMsg = from['extMsg']
  }

  get type() {
    return Command.kCommandLaunchMiniProgram
  }
}