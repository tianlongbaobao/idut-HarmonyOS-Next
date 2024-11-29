import common from '@ohos.app.ability.common';
import { Command, kWechatBundleName, kWechatEntryAbility } from '../model/Constants';
import { bundleManager, Want, wantConstant } from '@kit.AbilityKit';
import { BaseReq, BaseResp, SendReqResult, SendReqResultWrap } from '../model/Base';
import { SendAuthReq, SendAuthResp } from '../model/SendAuth';
import { JointPayReq, JointPayResp, PayReq, PayResp } from '../model/Pay';
import { Log } from '../log/Log';
import { SendTdiAuthReq, SendTdiAuthResp } from '../model/SendTdiAuth';
import { MediaObjectType, SendMessageToWXReq, SendMessageToWXResp } from '../model/message/SendMessageToWX';
import { WXImageObject } from '../model/message/WXImageObject';
import { LaunchMiniProgramReq, LaunchMiniProgramResp } from '../model/LaunchMiniProgram';
import { BusinessError } from '@kit.BasicServicesKit';

type RespWrap = BaseResp | PromiseLike<BaseResp>
type RespCallback = (resp: RespWrap) => void

const kTag = 'wxopensdk::WXApi'

const kWantCallerBundleNameKey = "ohos.aafwk.param.callerBundleName"
const kWantRequestKey = "wxopensdk_request"
const kWantResponseKey = "wxopensdk_response"
const kWantAppidKey = "wxopensdk_appid"

const kWechatBundleNameCandidates = [
  "com.tencent.wechat.debug",
  "com.tencent.wechat.red",
  "com.tencent.wechat.purple",
  "com.tencent.wechat.blue",
  "com.tencent.wechat.yellow"
]

export interface WXApi {
  sendReq(context: common.UIAbilityContext, req: BaseReq): SendReqResultWrap

  openWechat(context: common.UIAbilityContext): SendReqResultWrap

  handleWant(want: Want, eventHandler: WXApiEventHandler): boolean

  isWXAppInstalled(): boolean

  /*
  sendReqHelper(context: common.UIAbilityContext, req: Base.BaseReq): Base.BaseResp | Promise<Base.BaseResp>

  onResult(response: Base.BaseResp): void
  */
}

export interface WXApiEventHandler {
  onReq(req: BaseReq): void

  onResp(req: BaseResp): void
}

export class WXAPIFactory {
  static createWXAPI(appId: string): WXApi {
    return new WXApiImpl(appId)
  }

  static createReq(wantParameters: object): BaseReq | undefined {
    let type: number = wantParameters['__type__'] ?? -1
    let req =
      ((): BaseReq | undefined => {
        switch (type) {
          case Command.kCommandSendAuth: return new SendAuthReq
          case Command.kCommandSendTdiAuth: return new SendTdiAuthReq
          case Command.kCommandSendMessageToWX: return new SendMessageToWXReq
          case Command.kCommandPay: return new PayReq()
          case Command.kCommandJointPay: return new JointPayReq()
          case Command.kCommandLaunchMiniProgram: return new LaunchMiniProgramReq
          default: return
        }
      })()
    req?.deserializeFrom(wantParameters)
    return req
  }

  static createResp(wantParameters: object): BaseResp | undefined {
    let type: number = wantParameters['__type__'] ?? -1
    let resp =
      ((): BaseResp | undefined => {
        switch (type) {
          case Command.kCommandSendAuth: return new SendAuthResp
          case Command.kCommandSendTdiAuth: return new SendTdiAuthResp
          case Command.kCommandSendMessageToWX: return new SendMessageToWXResp
          case Command.kCommandPay: return new PayResp
          case Command.kCommandJointPay: return new JointPayResp
          case Command.kCommandLaunchMiniProgram: return new LaunchMiniProgramResp
          default: return
        }
      })()
    resp?.deserializeFrom(wantParameters)
    return resp
  }
}

class WXApiImpl implements WXApi {
  private readonly appId: string
  constructor(appId: string) {
    this.appId = appId;
  }

  private static NextId = 0;
  private resolves = new Map<number, RespCallback>();

  static reqToWantObject(req?: BaseReq): object | undefined {
    if (req) {
      let obj: ESObject = {}
      req.serializeTo(obj)
      if (obj['__type__'] !== req.type) {
        Log.e(kTag, 'super.serializedTo must be called')
      }
      return obj
    } else {
      return undefined
    }
  }

  private makeWant(request?: BaseReq, wechatBundleName?: string): Want {
    let parameters: Record<string, Object> = {}
    parameters[kWantRequestKey] = WXApiImpl.reqToWantObject(request) ?? ""
    parameters[kWantAppidKey] = this.appId
    parameters["from"] = "_wechat_open_sdk"
    
    let uri: string | undefined = undefined
    let action: string | undefined = undefined
    let flags: number | undefined = undefined

    if (request && request.type === Command.kCommandSendMessageToWX) {
      let sendMessageReq = request as SendMessageToWXReq
      if (sendMessageReq.checkArgs() && sendMessageReq.message?.mediaObject?.type === MediaObjectType.TYPE_IMAGE) {
        let imageObject = sendMessageReq.message?.mediaObject as WXImageObject
        if (imageObject!.uri && imageObject!.uri!.length > 0) {
          uri = imageObject.uri
          action = 'ohos.want.action.sendData'
          flags = wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION | wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION
        }
      }
    }
    
    return {
      bundleName: wechatBundleName ?? kWechatBundleName,
      abilityName:kWechatEntryAbility,
      parameters: parameters,
      action: action,
      uri: uri,
      flags: flags,
    }
  }

  private openWechatWithWant(context: common.UIAbilityContext, req?: BaseReq): SendReqResultWrap {
    return new Promise<SendReqResult>((resolve) => {
      let bundleNames: Array<string> = []
      bundleNames.push(kWechatBundleName)
      bundleNames.push(...kWechatBundleNameCandidates)

      ;(async () => {
        let openSucceed = false
        for (let name of bundleNames) {
          let want = this.makeWant(req, name)
          try {
            await context.startAbility(want)
            openSucceed = true
            resolve(true)
            return
          } catch (e) {
            Log.e(kTag, 'openWechat fail by err:%s', JSON.stringify(e))
          }
        }
        resolve(openSucceed)
      })()
    })
  }

  sendReq(context: common.UIAbilityContext, req: BaseReq): SendReqResultWrap {
    return this.openWechatWithWant(context, req)
  }

  openWechat(context: common.UIAbilityContext): SendReqResultWrap {
    return this.openWechatWithWant(context, undefined)
  }

  handleWant(want: Want, eventHandler: WXApiEventHandler): boolean {
    if (want.parameters && typeof want.parameters[kWantCallerBundleNameKey] === 'string') {
      let callerBundleName = want.parameters[kWantCallerBundleNameKey]
      if (callerBundleName !== kWechatBundleName && !kWechatBundleNameCandidates.includes(callerBundleName)) {
        return false
      }
      let reqWrap = want.parameters[kWantRequestKey]
      if (reqWrap) {
        let req = WXAPIFactory.createReq(reqWrap)
        if (req) {
          eventHandler.onReq(req)
        }
      }

      let respWrap = want.parameters[kWantResponseKey]
      if (respWrap) {
        let resp = WXAPIFactory.createResp(respWrap)
        if (resp) {
          eventHandler.onResp(resp)
        }
      }
      return true
    } else {
      return false
    }
  }

  isWXAppInstalled(): boolean {
    try {
      return bundleManager.canOpenLink("weixin://")
    } catch (e) {
      let code = (e as BusinessError)?.code
      let msg = (e as BusinessError)?.message ?? ''
      if (code !== undefined) {
        if (code === 17700056) {
          msg += ` Please include "weixin" inside the "querySchemes" element of module.json5 in your app module.`
        }
        Log.e(kTag, `isWXAppInstalled get error ${msg}`)
      } else {
        Log.e(kTag, `isWXAppInstalled get error ${e}`)
      }
      return false
    }
  }

  /*
  sendReqHelper(context: common.UIAbilityContext, request: Base.BaseReq): Promise<Base.BaseResp> {
    let id = this.id++;
    request.id = id;
    return new Promise<Base.BaseResp>((resolve) => {
      context.startAbility(this.makeWant(request)).then(() => {
        this.resolves.set(this.id, resolve);
        setTimeout(() => {
          let response = new Base.BaseResp()
          response.errCode = ErrorCode.TIMEOUT
          response.errMsg = 'timeout'
          resolve(response)
          this.resolves.delete(id)
        }, 5000)
      }).catch((err: BusinessError) => {
        Log.Logw.e(kTag, 'sendReq fail by err:%s', JSON.stringify(err))
        let response = new BaseResponse()
        response.errCode = ErrorCode.REQUEST_FAILED
        response.errMsg = err.message
        resolve(response)
        this.resolves.delete(id)
      });
    });
  }
  */

}

