import { webview } from "@kit.ArkWeb";

interface mnv {
  accounts:string
  passwords:string
}
@Component
export struct pageteach {
  @State sso:Array<ScriptItem> = []
  @State api:Array<ScriptItem> = []
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
    let vsf:mnv =JSON.parse(JSON.stringify(this.pathStack.getParamByName('大工教务')[0]))
    this.sso = [{ script: "$(\"#un\").val('" + vsf.accounts + "');$(\"#pd\").val('" + vsf.passwords + "');login()", scriptRules: ["*"] }]
    this.api = [{ script: "username.value='" + vsf.accounts + "';password.value='" + vsf.passwords + "';submit.disabled='';submit.click()", scriptRules: ["*"] }]
  }
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://jxgl.dlut.edu.cn/cas-auth/jasig/cas/login?from=rj", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(this.api)
      }
    }.title("大工教务")
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