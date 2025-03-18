import { webview } from "@kit.ArkWeb";
import {startBrowser} from "../utils/browser"
import {common} from "@kit.AbilityKit"
interface mnv {
  accounts:string
  passwords:string
}
@Component
export struct pagenew {
  @State sso:Array<ScriptItem> = []
  @State api:Array<ScriptItem> = []
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
  aboutToAppear(): void {
    let vsf:mnv =JSON.parse(JSON.stringify(this.pathStack.getParamByName('迎新系统')[0]))
    this.sso = [{ script: "$(\"#un\").val('" + vsf.accounts + "');$(\"#pd\").val('" + vsf.passwords + "');login()", scriptRules: ["*"] }]
    this.api = [{ script: "username.value='" + vsf.accounts + "';password.value='" + vsf.passwords + "';submit.disabled='';submit.click()", scriptRules: ["*"] }]
  }
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://yxxt.dlut.edu.cn:8080/yx/login/app/sso?from=rj", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(this.api)
          .onLoadIntercept((event) => {
            let data = event.data;
            this.URI = data.getRequestUrl();
            return false
          })
      }
    }.title("迎新系统")
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