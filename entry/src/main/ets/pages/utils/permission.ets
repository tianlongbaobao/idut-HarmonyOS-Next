import { abilityAccessCtrl, common } from '@kit.AbilityKit';

/**
 * 权限工具
 */
export class PermissionsUtil{

  static async reqPermissionsFromUser(): Promise<number[]> {
    let context = getContext() as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();
    let grantStatus = await atManager.requestPermissionsFromUser(context, ['ohos.permission.CAMERA']);
    return grantStatus.authResults;
  }

  /**
   * 申请相机权限
   * @returns
   */
  static async requestCameraPermission() {
    let grantStatus = await PermissionsUtil.reqPermissionsFromUser()
    for (let i = 0; i < grantStatus.length; i++) {
      if (grantStatus[i] === 0) {
        // 用户授权，可以继续访问目标操作
        return true;
      }
    }
    return false;
  }
}
