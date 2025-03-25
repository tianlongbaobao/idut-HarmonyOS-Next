import { http } from '@kit.NetworkKit'
import { Log } from '../log/Log'

const kTag = 'wxopensdk::DiffDevOAuth'

export enum OAuthErrCode {
  WechatAuth_Err_OK = 0,
  WechatAuth_Err_NormalErr = -1,
  WechatAuth_Err_NetworkErr = -2,
  WechatAuth_Err_JsonDecodeErr = -3,
  WechatAuth_Err_Cancel = -4,
  WechatAuth_Err_Timeout = -5,
  WechatAuth_Err_Auth_Stopped = -6,
  WechatAuth_Err_Param_Err = -7
}

export interface OAuthCallback {
  onGotQRCode: (base64JpegImageBuffer: string) => void
  onQRCodeScanned: () => void
  onAuthFinish: (authCode: string) => void
  onAuthError: (errCode: OAuthErrCode, errMsg: string) => void
}

export interface IDiffDevOAuth {
  /**
   * 发起OAuth
   *
   * @param appId 待授权appid
   * @param scope 权限
   * @param noncestr
   * @param timestamp
   * @param signature
   * @return 是否成功发起OAuth
   */
  startOAuth(appId: string, scope: string, noncestr: string, timestamp: string, signature: string, callback: OAuthCallback): void

  stopOAuth(): void
}

export class DiffDevOAuthFactory {
  public static readonly VERSION_1 = 1
  /**
   * 最大支持的IDiffDevOAuth实现版本
   */
  public static readonly MAX_SUPPORTED_VERSION = DiffDevOAuthFactory.VERSION_1

  private constructor() {
  }

  /**
   * 获取IDiffDevOAuth指定版本的实现
   *
   * @param version
   */
  public static getDiffDevOAuth(version: number = DiffDevOAuthFactory.MAX_SUPPORTED_VERSION): IDiffDevOAuth | null {
    if (version > DiffDevOAuthFactory.MAX_SUPPORTED_VERSION) {
      return null
    }

    switch (version) {
      case DiffDevOAuthFactory.VERSION_1:
        return new DiffDevOAuthImplV1()

      default:
        return null
    }
  }
}

enum UUIDStatusCodeEnum {
  UUID_EXPIRED = 402,
  UUID_CANCELED = 403,
  UUID_SCANNED = 404,
  UUID_CONFIRM = 405,
  UUID_KEEP_CONNECT = 408,
  UUID_SERVER_ERROR = 500
}

class DiffDevOAuthImplV1 implements IDiffDevOAuth {
  private started: boolean = false
  private callback: OAuthCallback | null = null
  private isCanceled: boolean = false
  private lastUUIDStatusCode: number = 0

  startOAuth(appId: string, scope: string, noncestr: string, timestamp: string, signature: string, callback: OAuthCallback) {
    this.callback = callback
    this.startOAuthInner(appId, scope, noncestr, timestamp, signature)
  }

  private async startOAuthInner(appId: string, scope: string, noncestr: string, timestamp: string, signature: string) {
    if (this.started) {
      this.callback?.onAuthError(OAuthErrCode.WechatAuth_Err_Auth_Stopped, 'OAuth is already started')
      return
    }
    this.started = true
    if (appId.length === 0 || scope.length === 0) {
      this.callback?.onAuthError(OAuthErrCode.WechatAuth_Err_Param_Err, 'appId or scope is empty')
      return
    }
    const url = `https://open.weixin.qq.com/connect/sdk/qrconnect?appid=${appId}&noncestr=${noncestr}&timestamp=${timestamp}&scope=${scope}&signature=${signature}`
    const httpRequest = http.createHttp()
    try {
      const response = await httpRequest.request(url)
      const data = response.result as string
      if (data.length === 0) {
        this.callback?.onAuthError(OAuthErrCode.WechatAuth_Err_NetworkErr, 'response data is empty')
        return
      }
      Log.i(kTag, `qrconect get data ${data}`)
      const qrResponse: Record<string, Object> = JSON.parse(data)
      if (qrResponse['errcode'] !== 0) {
        this.callback?.onAuthError(OAuthErrCode.WechatAuth_Err_NormalErr, `response errcode: ${qrResponse["errcode"]} errmsg: ${qrResponse["errmsg"]}`)
        return
      }
      const uuid = qrResponse['uuid'] as string
      if (uuid.length === 0) {
        this.callback?.onAuthError(OAuthErrCode.WechatAuth_Err_JsonDecodeErr, 'uuid is empty')
        return
      }
      const qrCodeBase64Record = qrResponse.qrcode as Record<string, Object>
      const qrCodeBase64 = qrCodeBase64Record['qrcodebase64'] as string
      const qrCodeLength = qrCodeBase64Record['qrcodelength'] as number
      if (qrCodeBase64.length === 0 || qrCodeLength === 0) {
        this.callback?.onAuthError(OAuthErrCode.WechatAuth_Err_JsonDecodeErr, 'qrcodebase64 or qrcodelength is empty')
        return
      }
      this.callback?.onGotQRCode(qrCodeBase64)
      this.startLongPolling(uuid)
    } catch (e) {
      this.callback?.onAuthError(OAuthErrCode.WechatAuth_Err_NetworkErr, e.message)
    }
  }

  private async startLongPolling(uuid: string) {
    if (uuid.length === 0) {
      this.callback?.onAuthError(OAuthErrCode.WechatAuth_Err_NormalErr, 'uuid is empty')
      return
    }
    while (!this.isCanceled) {
      let url = `https://long.open.weixin.qq.com/connect/l/qrconnect?f=json&uuid=${uuid}`
      if (this.lastUUIDStatusCode !== 0) {
        url += `&last=${this.lastUUIDStatusCode}`
      }
      const httpRequest = http.createHttp()
      const response = await httpRequest.request(url)
      const data = response.result as string
      if (data.length === 0) {
        this.callback?.onAuthError(OAuthErrCode.WechatAuth_Err_NetworkErr, 'response data is empty')
        return
      }
      const pollingResponse: Record<string, Object> = JSON.parse(data)
      let uuidStatusCode = pollingResponse['wx_errcode'] as number
      Log.d(kTag, `lastUUIDStatusCode: ${this.lastUUIDStatusCode}`)
      let errCode = OAuthErrCode.WechatAuth_Err_OK
      let wxCode = 0
      switch (uuidStatusCode) {
        case UUIDStatusCodeEnum.UUID_CONFIRM:
          wxCode = pollingResponse['wx_code'] as number
          break
        case UUIDStatusCodeEnum.UUID_SCANNED:
          break
        case UUIDStatusCodeEnum.UUID_KEEP_CONNECT:
          break
        case UUIDStatusCodeEnum.UUID_EXPIRED:
          errCode = OAuthErrCode.WechatAuth_Err_Timeout
          break
        case UUIDStatusCodeEnum.UUID_CANCELED:
          errCode = OAuthErrCode.WechatAuth_Err_Cancel
          break
        case UUIDStatusCodeEnum.UUID_SERVER_ERROR:
          errCode = OAuthErrCode.WechatAuth_Err_NormalErr
          break
        default:
          errCode = OAuthErrCode.WechatAuth_Err_NormalErr
          break
      }
      if (errCode === OAuthErrCode.WechatAuth_Err_OK) {
        this.lastUUIDStatusCode = uuidStatusCode
        if (uuidStatusCode === UUIDStatusCodeEnum.UUID_SCANNED) {
          this.callback?.onQRCodeScanned()
        } else if (uuidStatusCode === UUIDStatusCodeEnum.UUID_CONFIRM) {
          this.callback?.onAuthFinish(wxCode.toString())
          break
        }
      } else {
        this.callback?.onAuthError(errCode, 'polling error')
        break
      }
    }
  }

  stopOAuth() {
    this.callback = null
    this.isCanceled = true
  }
}
