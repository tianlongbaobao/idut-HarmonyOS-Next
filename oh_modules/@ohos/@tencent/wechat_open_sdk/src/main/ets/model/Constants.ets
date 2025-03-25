
export const kWechatBundleName = 'com.tencent.wechat'
export const kWechatEntryAbility = 'EntryAbility'

export enum Command {
  kCommandSendAuth = 1,
  kCommandSendMessageToWX = 2,

  kCommandPay = 5,
  kCommandLaunchFromWX = 6,
  kCommandLaunchMiniProgram = 19,
  kCommandOpenBusinessView = 26,
  kCommandJointPay = 27,

  kCommandSendTdiAuth = 31,
}

export namespace WXMiniProgramConstants {
  export const KEY_ACTIVITY_ID = "wx_miniprogram_key_activity_id"
  export const KEY_PARAMETER_INFO_LIST = "wx_miniprogram_key_parameter_info_list"
}