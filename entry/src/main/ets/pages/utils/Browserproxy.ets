import { scanCore, scanBarcode } from '@kit.ScanKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { webview } from "@kit.ArkWeb";
import router from '@ohos.router';
import {ApiLogin} from "../backrequest/apiqr"


export class browserProxy{
  controller: webview.WebviewController;
  constructor(controller: webview.WebviewController) {
    this.controller = controller
  }
  issueCommand(cmdId:string, cmdName:string, paras:string) {
    let options: scanBarcode.ScanOptions = {
      scanTypes: [scanCore.ScanType.ALL],
      enableMultiMode: true,
      enableAlbum: true
    };
    interface ResponseBean {
      scanType: number;
      originalValue:string
    }
    interface SendBean {
      resultStr: string;
      type:string;
      errMsg:string
    }
    scanBarcode.startScanForResult(getContext(this), options).then((result: scanBarcode.ScanResult) => {
      const responseBean:ResponseBean = JSON.parse(JSON.stringify(result))
      let value:string = responseBean.originalValue
      console.log(value)
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
                  fontColor:"red",
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
                fontColor:"red",
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
                fontColor:"red",
                action: () => {
                }
              },
            }
          )
        } else {
          console.log("有效的 URL:", url);
        }
      } else if (value.includes("qrLogin")){
        router.pushUrl({
          url: 'pages/SSO',
          params:{
            id1:value}
        })

      } else {
        let encodedResult = encodeURIComponent(value.replace(/\n/g, "%5cn").replace(/\r/g, "%5cr").replace(/\t/g, "%5ct").replace(/\\/g, "%5c"));
        let sendbean:SendBean = {
            resultStr:encodedResult,
          type:"raw",
          errMsg:cmdName+":ok"
        }
        let b:string = `Whistle.__onCommandSuccessCallback('${cmdId}', '${JSON.stringify(sendbean)}');`;
        this.controller.runJavaScript(b)

      }
    }).catch((error: BusinessError) => {
      hilog.error(0x0001, '[Scan CPSample]',
        `Failed to get ScanResult by promise with options. Code:${error.code}, message: ${error.message}`);
    });
      console.log("命令接收", "命令ID: " + cmdId + ", 名称: " + cmdName + ", 参数: " + paras);
  }
  configApp(){
    return true
  }
  debugOut(sb:string){
    console.info(sb)
  }

}