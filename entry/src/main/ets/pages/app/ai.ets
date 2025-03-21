import { webview } from "@kit.ArkWeb";
import {startBrowser} from "../utils/browser"
import {common} from "@kit.AbilityKit"
interface mnv {
  accounts:string
  passwords:string
  verify:string
}

@Component
export struct pageai {
  @State verify:string = ""
  @State sso:Array<ScriptItem> = []
  @State api:Array<ScriptItem> = []
  @State vpn:Array<ScriptItem> = [{script:"document.getElementById('cas-login').click()", scriptRules: ["*"] }]
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
    console.log(JSON.stringify(this.pathStack.getParamByName('AI助手')))
    let vsf:mnv =JSON.parse(JSON.stringify(this.pathStack.getParamByName('AI助手')[0]))
    this.verify = vsf.verify
    this.sso = [{ script: "$(\"#un\").val('" + vsf.accounts + "');$(\"#pd\").val('" + vsf.passwords + "');login()", scriptRules: ["*"] }]
    this.api = [{ script: "username.value='" + vsf.accounts + "';password.value='" + vsf.passwords + "';submit.disabled='';submit.click()", scriptRules: ["*"] }]
  }
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://webvpn.dlut.edu.cn/http/57787a7876706e323032336b657940247b10030cb2079f5bbe02ff3c84f58629/page/site/newPc?app=1", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(this.vpn)
          .javaScriptOnDocumentEnd(this.sso)
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
    }.title("AI助手")
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