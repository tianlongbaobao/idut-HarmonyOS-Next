import { AbilityConstant, common, Configuration, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { display, Router, window } from '@kit.ArkUI';
import deviceinfo from '@ohos.deviceInfo';
import { UIContext } from '@kit.ArkUI'
import { router } from '@kit.ArkUI';
import dataPreferences from '@ohos.data.preferences';
import { scanCore, scanBarcode } from '@kit.ScanKit';
import { BusinessError } from '@kit.BasicServicesKit';
import {ApiLogin} from "../pages/backrequest/apiqr"
import { UPPayment, UPPayResult, UPPayResultStatus } from 'libuppayment';
import PushManager, { GTCmdMessage, GTNotificationMessage, GTTransmitMessage } from '@getui/push';
import { notificationManager } from '@kit.NotificationKit';
import { setclientid } from '../pages/backrequest/SetClientid';
import {responsebean} from "../pages/utils/ResponseBean"
import { NotificationPayload} from "../pages/utils/NoticeficationBean"
import { relationalStore } from '@kit.ArkData'

export default class EntryAbility extends UIAbility {
  funcAbilityWant: Want | undefined = undefined;
  uiContext: UIContext | undefined = undefined;
  private selectPage: string = '';
  private currentWindowStage: window.WindowStage | null = null;
  private  upPayment = new UPPayment();
  private curBp: string = '';
  private updateBreakpoint(windowWidth: number) :void{
    // 将长度的单位由px换算为vp
    let windowWidthVp = windowWidth / display.getDefaultDisplaySync().densityPixels;
    let newBp: string = '';
    if (windowWidthVp < 320) {
      newBp = 'xs';
    } else if (windowWidthVp < 600) {
      newBp = 'sm';
    } else if (windowWidthVp < 840) {
      newBp = 'md';
    } else {
      newBp = 'lg';
    }
    if (this.curBp !== newBp) {
      this.curBp = newBp;
      // 使用状态变量记录当前断点值
      AppStorage.setOrCreate('currentBreakpoint', this.curBp);
    }
  }
  goToSpecifyPage(want: Want) {
    let shortCutKey = want.parameters?.shortCutKey;
    if (this.uiContext && shortCutKey && shortCutKey === 'CompanyPage') {
       shortCutKey = ""
      let router: Router = this.uiContext.getRouter();
      dataPreferences.getPreferences(this.context, "information").then(preferences=> {
        preferences.get("account", 'default').then((value) => {
          preferences.get("password","default").then((ljc) => {
            router.pushUrl({
              url: 'pages/Vcard',
              params:{
                id1:ljc,
                id2:value}
            })
          })
        })
      })

    } else  if (this.selectPage =="class"){
      this.selectPage=""
      dataPreferences.getPreferences(this.context, "information").then(preferences=> {
        preferences.get("account", 'default').then((value) => {
          preferences.get("password","default").then((ljc) => {
            router.pushUrl({
              url: 'pages/Classes',
              params:{
                id1:ljc,
                id2:value}
            })
          })
        })
      })

    }else  if (this.selectPage =="check"){
      this.selectPage=""
      dataPreferences.getPreferences(this.context, "information").then(preferences=> {
        preferences.get("account", 'default').then((value) => {
          preferences.get("password","default").then((ljc) => {
            router.pushUrl({
              url: 'pages/Card',
              params:{
                id1:ljc,
                id2:value}
            })
          })
        })
      })

    } else if (this.uiContext && shortCutKey && shortCutKey === 'Scan'){
      shortCutKey = ""
      let options: scanBarcode.ScanOptions = {
        scanTypes: [scanCore.ScanType.ALL],
        enableMultiMode: true,
        enableAlbum: true
      };
      interface ResponseBean {
        scanType: number;
        originalValue:string
      }
      let deviceTypeInfo: string = deviceinfo.deviceType;
      if (deviceTypeInfo=="2in1"){
        AlertDialog.show(
          {
            message: '2in1设备不支持扫一扫',
            autoCancel: false,
            alignment: DialogAlignment.Bottom,
            gridCount: 5,
            offset: { dx: 0, dy: -20 },
            primaryButton: {
              value: '确认',
              action: () => {
              }
            },
          }
        )
      }else {
        scanBarcode.startScanForResult(getContext(this), options).then((result: scanBarcode.ScanResult) => {
          const responseBean: ResponseBean = JSON.parse(JSON.stringify(result))
          let value: string = responseBean.originalValue
          if (value.includes("whistle_info")) {
            let url: string = "";
            try {
              const parts = value.split("whistle_info=");
              if (parts.length > 1) {
                url = parts[1];
                ApiLogin(url)
              } else {
                AlertDialog.show(
                  {
                    message: '无效的二维码',
                    autoCancel: false,
                    alignment: DialogAlignment.Bottom,
                    gridCount: 5,
                    offset: { dx: 0, dy: -20 },
                    primaryButton: {
                      value: '确认',
                      fontColor: "red",
                      action: () => {
                      }
                    },
                  }
                )
              }
            } catch (e) {
              AlertDialog.show(
                {
                  message: '无效的二维码',
                  autoCancel: false,
                  alignment: DialogAlignment.Bottom,
                  gridCount: 5,
                  offset: { dx: 0, dy: -20 },
                  primaryButton: {
                    value: '确认',
                    fontColor: "red",
                    action: () => {
                    }
                  },
                }
              )
            }

            if (url.length < 5) {
              AlertDialog.show(
                {
                  message: '无效的二维码',
                  autoCancel: false,
                  alignment: DialogAlignment.Bottom,
                  gridCount: 5,
                  offset: { dx: 0, dy: -20 },
                  primaryButton: {
                    value: '确认',
                    fontColor: "red",
                    action: () => {
                    }
                  },
                }
              )
            } else {
            }
          } else if (value.includes("qrLogin")) {
            router.pushUrl({
              url: 'pages/SSO',
              params: {
                id1: value
              }
            })

          }

        }).catch((error: BusinessError) => {
          hilog.error(0x0001, '[Scan CPSample]',
            `Failed to get ScanResult by promise with options. Code:${error.code}, message: ${error.message}`);
        });
      }

    }
  }
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // Receive the parameters passed by UIAbility from the caller
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onNewWant');
    if (want?.parameters?.params) {
      // want.parameters.params 对应 postCardAction() 中 params 内容
      let params: Record<string, Object> = JSON.parse(want.parameters.params as string);
      this.selectPage = params.targetPage as string;
    }
    this.goToSpecifyPage(want);
    if (want?.uri && want.uri.includes('uppayresult') && this.uiContext) {
      this.upPayment.handlePaymentResult(want.uri,(data: UPPayResult) => {
        switch (data.code) {
          case UPPayResultStatus.CANCEL:
            this.uiContext?.showAlertDialog({
              title: '支付结果',
              message: '取消！',
              alignment:DialogAlignment.Center
            });
            break;
          case UPPayResultStatus.FAIL:
            this.uiContext?.showAlertDialog({
              title: '支付结果',
              message: '失败！',
              alignment:DialogAlignment.Center
            });
            break;
          case UPPayResultStatus.SUCCESS:
            this.uiContext?.showAlertDialog({
              title: '支付结果',
              message: '成功！',
              alignment:DialogAlignment.Center
            });
            break;
          default:
            this.uiContext?.showAlertDialog({
              title: '支付结果',
              message: '取消！',
              alignment:DialogAlignment.Center
            });
            break;
        }
        console.log('支付结果：' + JSON.stringify(data));
      });
    }
  }
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    if (want?.parameters?.params) {
      // want.parameters.params 对应 postCardAction() 中 params 内容
      let params: Record<string, Object> = JSON.parse(want.parameters.params as string);
      this.selectPage = params.targetPage as string;
    }
    let shortCutKey = want.parameters?.shortCutKey;
    if (shortCutKey === 'CompanyPage'){
      this.selectPage = "vcard"
    }
    PushManager.initialize({
      context: this.context as common.UIAbilityContext,
      onSuccess: (cid:string) => {
        hilog.debug(0x0000, "EntryAbility", '%{public}s', "个推SDK初始化成功，cid = " + cid);
      },
      onFailed: (error:string) => {
        hilog.debug(0x0000, "EntryAbility", '%{public}s', "个推SDK初始化失败，error = " + error);
      }
    })
    notificationManager.requestEnableNotification(this.context).then(() => {
      hilog.debug(0x0000, "EntryAbility", '%{public}s', 'requestEnableNotification success');
    }).catch((err: BusinessError) => {
      hilog.debug(0x0000, "EntryAbility", '%{public}s', "error = " + err);
    })
    PushManager.setPushCallback({
      // 接收 cid
      onReceiveClientId: (clientId:string) => {
        dataPreferences.getPreferences(this.context, "information").then(preferences=> {
          preferences.get("data", 'default').then((value) => {
            let into:responsebean = JSON.parse(value.toString())
            setclientid(into.data.my_info.identity,into.data.my_info.student_number,into.data.verify,into.data.my_info.user_id,clientId)
          })
        })
    },
      //接收厂商token
      onReceiveDeviceToken: (token:string) => {
      hilog.debug(0x0000, 'EntryAbility', '%{public}s', "token = " + token);
    },
    // cid 离线上线通知
    onReceiveOnlineState: (onLine:boolean) => {
      hilog.debug(0x0000, 'EntryAbility', '%{public}s', "onLine = " + onLine);
    },
    //命令相应回复
    onReceiveCommandResult: (result: GTCmdMessage) => {
      hilog.debug(0x0000, 'EntryAbility', '%{public}s', "cmd = " + JSON.stringify(result));
    },
    //sdk 收到透传消息
    onReceiveMessageData: (message: GTTransmitMessage) => {
      if (message.payload!=null) {
        const STORE_CONFIG: relationalStore.StoreConfig= {
          name: 'message.db', // 数据库文件名
          securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
          encrypt: false,
          isReadOnly: false
        };
        relationalStore.getRdbStore(this.context, STORE_CONFIG, (err, store) => {
          let msg: NotificationPayload = JSON.parse(message.payload)
          let contentin:string = ""
          if (JSON.stringify(msg.payload.body.custom.content).startsWith("[")&&JSON.stringify(msg.payload.body.custom.content).endsWith("]")) {
            contentin = JSON.stringify(msg.payload.body.custom.content)
          } else {
            contentin = "["+JSON.stringify(msg.payload.body.custom.content)+"]"
          }
          const valueBucket1: relationalStore.ValuesBucket = {
            'MSGID': msg.payload.body.custom.msg_id,
            'TIME': msg.timestamp,
            'APPID': msg.appkey,
            'ISREAD': 0,
            'TITLE': msg.payload.body.title,
            'CONTENT': contentin
          };
          if (store !== undefined) {
            (store as relationalStore.RdbStore).insert('NOTICE', valueBucket1,2,
              (err: BusinessError, rowId: number) => {
                if (err) {
                  console.error(`Failed to insert data. Code:${err.code}, message:${err.message}`);
                  return;
                }
                console.info(`Succeeded in inserting data. rowId:${rowId}`);
              })
          }
        })

      }else {

      }

      hilog.debug(0x0000, 'EntryAbility', '%{public}s', "message = " + JSON.stringify(message));
    },
    //通知到达回调
    onNotificationMessageArrived: (message: GTNotificationMessage)  => {
      hilog.debug(0x0000, 'EntryAbility', '%{public}s', "message = " + JSON.stringify(message));
    },
    //通知点击回调, 需要配合PushManager.setClickWant(want)使用
    onNotificationMessageClicked: (message: GTNotificationMessage) => {
      hilog.debug(0x0000, 'EntryAbility', '%{public}s', "message = " + JSON.stringify(message));
    },
    })

  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    const STORE_CONFIG: relationalStore.StoreConfig= {
      name: 'message.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
      encrypt: false,
      isReadOnly: false
    };
    const SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS NOTICE (MSGID TEXT NOT NULL,TIME TEXT NOT NULL,APPID TEXT NOT NULL, ISREAD INTEGER, TITLE TEXT NOT NULL,CONTENT TEXT NOT NULL,UNIQUE(TIME))'

    relationalStore.getRdbStore(this.context, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info('Succeeded in getting RdbStore.');
      store.executeSql(SQL_CREATE_TABLE) // 创建数据表，以便后续调用insert接口插入数据
        .then(() => {
          // 设置数据库的版本，入参为大于0的整数
          store.version = 1;
        })
        .catch((err: BusinessError) => {
          console.error(`Failed to executeSql. Code:${err.code}, message:${err.message}`);
        });
    });
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    dataPreferences.getPreferences(this.context, "information").then(preferences=>{
      preferences.get("account",'default').then((value)=>{
        let path: string | undefined = 'page/Index';
        if (this.funcAbilityWant?.parameters?.shortCutKey === 'CompanyPage') {
          path = 'pages/Vcard';
        }
        if (value == 'default') {
          path = "pages/Index"
        } else  {
          switch (this.selectPage) {
            case 'class':
              path = 'pages/Classes';
              this.selectPage = ""
              break;
            case 'vcard':
              path = 'pages/Vcard';
              this.selectPage = ""
              break;
            case 'check':
              path = 'pages/Card';
              this.selectPage = ""
              break;
            default :
              path = 'pages/Jumping'
          }
        }
        windowStage.loadContent(path, (err) => {
          if (err.code) {
            hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
            return;
          }
          hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');

          let windowClass: window.Window;
          windowStage.getMainWindow((err, data) => {
            this.uiContext = data.getUIContext();
            let widthBp: WidthBreakpoint = this.uiContext.getWindowWidthBreakpoint();
            let heightBp: HeightBreakpoint = this.uiContext.getWindowHeightBreakpoint();
            AppStorage.setOrCreate('currentWidthBreakpoint', widthBp);
            AppStorage.setOrCreate('currentHeightBreakpoint', heightBp);
            data.on('windowSizeChange', (windowSize)=>{
              this.updateBreakpoint(windowSize.width);
            });
            if (err.code) {
              hilog.error(0x0000, 'testTag',
                `Failed to obtain the main window. Code is ${err.code},message is ${err.message}`);
            }
            windowClass = data;
            this.uiContext = windowClass.getUIContext();
          })
        });
      })
    })


  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  onConfigurationUpdate(newConfig: Configuration): void {

    let newColorMode = newConfig.colorMode;
    let currentColorMode = AppStorage.get<ConfigurationConstant.ColorMode>('currentColorMode');
    if (newColorMode === currentColorMode) {
      return;
    }
    // 更新缓存中的颜色模式
    AppStorage.setOrCreate('currentColorMode', newConfig.colorMode);
  }
}