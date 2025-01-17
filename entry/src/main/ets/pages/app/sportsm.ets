import { webview } from "@kit.ArkWeb";
interface mnv {
  accounts:string
  passwords:string
}

@Component
export struct pagesports {
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
    let vsf:mnv =JSON.parse(JSON.stringify(this.pathStack.getParamByName('体育场馆预定')[0]))
    this.sso = [{ script: "$(\"#un\").val('" + vsf.accounts + "');$(\"#pd\").val('" + vsf.passwords + "');login()", scriptRules: ["*"] }]
    this.api = [{ script: "username.value='" + vsf.accounts + "';password.value='" + vsf.passwords + "';submit.disabled='';submit.click()", scriptRules: ["*"] }]
  }
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://webvpn.dlut.edu.cn/http/57787a7876706e323032336b65794024791c0f55e81a9049e448f62d85f58023f6c217c3/api/login/login?from=rj&filter=app", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(this.api)
      }
    }.title("体育场馆预定")
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