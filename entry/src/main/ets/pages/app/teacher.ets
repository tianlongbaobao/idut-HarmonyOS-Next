import { webview } from "@kit.ArkWeb";
import {common} from "@kit.AbilityKit"
import {startBrowser} from "../utils/browser"

@Component
export struct pageteacher {
  @State URI:string = ""
  @Consume('pathInfos') pathStack: NavPathStack;
  controller: webview.WebviewController = new webview.WebviewController()
  private menuItems: Array<NavigationMenuItem> = [
    {
      value:"browser",
      icon:"/resources/rawfile/browser.png",
      action:() =>{
        const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
        startBrowser(context,this.URI)
      }
    },
    {
      value:"refresh",
      icon:"/resources/rawfile/refresh.svg",
      action:() =>{
        this.controller.refresh()
      }
    }
  ]
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://faculty.dlut.edu.cn/", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .onControllerAttached(() => {
            let userAgent =
              "Mozilla/ 5.0 (Linux; Android 10; EBG Build/ HUAWEIEBG; wv) AppleWebKit/ 537.36 (KHTML, like Gecko) Version/ 4.0 Chrome/ 88.0.4324.93 Mobile Safari/ 537.36 weishao(3.3.0.74633)";
            this.controller.setCustomUserAgent(userAgent);
          })
          .onLoadIntercept((event) => {
            let data = event.data;
            this.URI = data.getRequestUrl();
            return false
          })
      }
    }.title("教师主页")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })

    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .menus(this.menuItems)
  }
}