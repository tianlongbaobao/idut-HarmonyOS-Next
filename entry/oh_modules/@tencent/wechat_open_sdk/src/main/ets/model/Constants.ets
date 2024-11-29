
export const kWechatBundleName = 'com.tencent.wechat'
export const kWechatEntryAbility = 'EntryAbility'

export enum Command {
  kCommandSendAuth = 1,
  kCommandSendMessageToWX = 2,

  kCommandPay = 5,
  kCommandLaunchMiniProgram = 19,
  kCommandJointPay = 27,

  kCommandSendTdiAuth = 31,
}