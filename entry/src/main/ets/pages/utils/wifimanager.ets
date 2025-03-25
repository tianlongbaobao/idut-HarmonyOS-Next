import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';
import { wifiManager } from '@kit.ConnectivityKit'
import { connection } from '@kit.NetworkKit';

const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;

export function noticerequire(){
  let context = getContext() as common.UIAbilityContext;
  notificationManager.isNotificationEnabled().then((data: boolean) => {
    hilog.info(DOMAIN_NUMBER, TAG, "isNotificationEnabled success, data: " + JSON.stringify(data));
    if(!data){
      notificationManager.requestEnableNotification(context).then(() => {
        hilog.info(DOMAIN_NUMBER, TAG, `[ANS] requestEnableNotification success`);
      }).catch((err : BusinessError) => {
        if(1600004 == err.code){
          hilog.error(DOMAIN_NUMBER, TAG, `[ANS] requestEnableNotification refused, code is ${err.code}, message is ${err.message}`);
        } else {
          hilog.error(DOMAIN_NUMBER, TAG, `[ANS] requestEnableNotification failed, code is ${err.code}, message is ${err.message}`);
        }
      });
    }
  }).catch((err : BusinessError) => {
    hilog.error(DOMAIN_NUMBER, TAG, `isNotificationEnabled fail, code is ${err.code}, message is ${err.message}`);
  });

}

export async function wifimanager(id:number){

  let downLoadTemplate: notificationManager.NotificationTemplate = {
    name: 'downloadTemplate', // 当前只支持downloadTemplate，保持不变
    data: {
      title: '文件下载：music.mp4', // 必填。
      fileName: 'senTemplate', // 必填。
      progressValue: "100%", // 应用更新进度值，自定义。
    }
  };
  let request: notificationManager.NotificationRequest = {
    content: {
      // 系统实况类型，保持不变
      notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW,
      systemLiveView: {
        typeCode: 8, // 上传下载类型需要填写 8，当前仅支持此类型。保持不变
        title: "test", // 应用自定义
        text: "test", // 应用自定义
      }
    },
    id: id, // 必须是申请长时任务返回的id，否则应用更新通知失败。
    notificationSlotType: notificationManager.SlotType.LIVE_VIEW, // 实况窗类型，保持不变
    template: downLoadTemplate // 应用需要设置的模版名称
  };

  try {
    notificationManager.publish(request).then(() => {
      console.info("publish success, id= " + id);
    }).catch((err: BusinessError) => {
      console.error(`publish fail: ${JSON.stringify(err)}`);
    });
  } catch (err) {
    console.error(`publish fail: ${JSON.stringify(err)}`);
  }
}

