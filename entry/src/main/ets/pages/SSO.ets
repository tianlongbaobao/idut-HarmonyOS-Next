import webview from '@ohos.web.webview';
import router from '@ohos.router';
import {QRLogin} from "./backrequest/qrlogin"
let url = (router.getParams() as Record<string, string>)['id1']
@Entry
@Component
struct SSO {
  controller: webview.WebviewController = new webview.WebviewController();
  build() {
    Column(){
      Web({ src: url, controller: this.controller })
        .height("20%")
        .javaScriptAccess(true)
        .fileAccess(true)
        .imageAccess(true)
        .onlineImageAccess(true)
        .domStorageAccess(true)
        .mixedMode(0)
        .zoomAccess(true)
        .overviewModeAccess(true)
        .geolocationAccess(true)
        .onlineImageAccess(true)
        .multiWindowAccess(true)
        .cacheMode(CacheMode.Default)
        .onControllerAttached(() => {
          let userAgent = "Mozilla/ 5.0 (Linux; Android 10; EBG Build/ HUAWEIEBG; wv) AppleWebKit/ 537.36 (KHTML, like Gecko) Version/ 4.0 Chrome/ 88.0.4324.93 Mobile Safari/ 537.36 weishao(3.3.0.74633)";
          this.controller.setCustomUserAgent(userAgent);
        })
      Image($rawfile("computer.svg"))
        .width("40%")
        .backgroundColor("white")
      Text("校园门户电脑端登录")
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({top:"10%"})
      Button() {
        Text("确认登录")
          .fontWeight(FontWeight.Bold)
          .fontColor("white")
          .fontSize(15)
      }
      .height("5%")
      .width("80%")
      .margin({ top: "35%" })
      .onClick(()=>{
        QRLogin(url)
      })
      Button({ buttonStyle: ButtonStyleMode.EMPHASIZED, role: ButtonRole.ERROR}) {
        Text("取消登录")
          .fontWeight(FontWeight.Bold)
          .fontColor("white")
          .fontSize(15)
      }
      .height("5%")
      .width("80%")
      .margin({ top: "10%" })
      .onClick(()=>{
        router.back()
      })
    }
  }
}