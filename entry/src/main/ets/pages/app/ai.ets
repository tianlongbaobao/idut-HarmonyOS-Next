import { webview } from "@kit.ArkWeb";

interface mnv {
  accounts:string
  passwords:string
  verify:string
}

@Component
export struct pageai {
  @State verify:string = ""
  @Consume('pathInfos') pathStack: NavPathStack;
  controller: webview.WebviewController = new webview.WebviewController()
  private menuItems: Array<NavigationMenuItem> = [
    {
      value:"refresh",
      icon:"/resources/rawfile/refresh.svg",
      action:() =>{
        this.controller.refresh()
      }
    }]
  aboutToAppear(): void {
    console.log(JSON.stringify(this.pathStack.getParamByName('AI助手')))
    let vsf:mnv =JSON.parse(JSON.stringify(this.pathStack.getParamByName('AI助手')[0]))
    this.verify = vsf.verify
  }
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://chat.dlut.edu.cn/page/site/?ip=service.m.dlut.edu.cn&verify="+this.verify, controller: this.controller })
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
      }
    }.title("AI助手（校园网）")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .menus(this.menuItems)
  }
}