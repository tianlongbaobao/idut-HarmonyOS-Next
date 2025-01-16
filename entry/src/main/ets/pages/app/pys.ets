import { webview } from "@kit.ArkWeb";

interface mnv {
  accounts:string
  passwords:string
}

@Component
export struct pagepys {
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
    let vsf:mnv =JSON.parse(JSON.stringify(this.pathStack.getParamByName('心理测评')[0]))
    this.sso = [{ script: "$(\"#un\").val('" + vsf.accounts + "');$(\"#pd\").val('" + vsf.passwords + "');login()", scriptRules: ["*"] }]
    this.api = [{ script: "username.value='" + vsf.accounts + "';password.value='" + vsf.passwords + "';submit.disabled='';submit.click()", scriptRules: ["*"] }]
  }

  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://webvpn.dlut.edu.cn/http/57787a7876706e323032336b65794024680b1b56f80f865ae449fe2ddfb88b/psym/Default/Index?from=rj&filter=app", controller: this.controller })
          .javaScriptAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(this.api)
      }
    }.title("心理测评")
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