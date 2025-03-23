import { webview } from "@kit.ArkWeb";
import { Pay } from '@cashier_alipay/cashiersdk'
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { browserProxy } from "../utils/Browserproxy"
import {cookiesync} from "../backrequest/cookiemanager"

interface mnv {
  accounts: string
  passwords: string
}

@Component
export struct pagecard {
  @State sso: Array<ScriptItem> = []
  @State api: Array<ScriptItem> = []
  @State h5Height:number = 4
  @Consume('pathInfos') pathStack: NavPathStack;
  controller: webview.WebviewController = new webview.WebviewController();
  responseResource: WebResourceResponse = new WebResourceResponse();
  @State BrowserProxy: browserProxy = new browserProxy(this.controller)
  private menuItems: Array<NavigationMenuItem> = [
    {
      value:"refresh",
      icon:"/resources/rawfile/refresh.svg",
      action:() =>{
        this.controller.refresh()
      }
    }]
  aboutToAppear(): void {
    let vsf: mnv = JSON.parse(JSON.stringify(this.pathStack.getParamByName('玉兰卡')[0]))
    this.sso = [{
      script: "$(\"#un\").val('" + vsf.accounts + "');$(\"#pd\").val('" + vsf.passwords + "');login()",
      scriptRules: ["*"]
    }]
    this.api = [{
      script: "username.value='" + vsf.accounts + "';password.value='" + vsf.passwords +
        "';submit.disabled='';submit.click()",
      scriptRules: ["*"]
    }]
    cookiesync()
  }

  build() {
    NavDestination() {
      Column() {
        Web({
          src: "https://api.m.dlut.edu.cn/oauth/authorize?client_id=19b32196decf419a&redirect_uri=https%3A%2F%2Fcard.m.dlut.edu.cn%2Fhomerj%2FopenRjOAuthPage&response_type=code&scope=base_api&state=weishao",
          controller: this.controller
        })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(this.api)
          .javaScriptProxy({
            object: this.BrowserProxy,
            name: "__nativeWhistleProxy",
            methodList: ["issueCommand", "configApp", "debugOut"],
            controller: this.controller,
          })
          .cacheMode(CacheMode.Online)
          .onControllerAttached(() => {
            let userAgent =
              "Mozilla/ 5.0 (Linux; Android 10; EBG Build/ HUAWEIEBG; wv) AppleWebKit/ 537.36 (KHTML, like Gecko) Version/ 4.0 Chrome/ 88.0.4324.93 Mobile Safari/ 537.36 weishao(3.3.0.74633)";
            this.controller.setCustomUserAgent(userAgent);
          })
          .onLoadIntercept((event) => {
            let data = event.data;
            let url:string = data.getRequestUrl();
            console.log(url)
            if (url.startsWith("weixin://")) {
              (getContext() as common.UIAbilityContext).openLink(url)
                .then(() => {
                }).catch((err: BusinessError) => {
              });
              return true;
            }
            if (url.startsWith("upwrp://")) {
              console.log("uppaywallet://uppay" + url.substring(20))
              let  newStr = "uppaywallet://uppay" + url.substring(20);
              (getContext() as common.UIAbilityContext).openLink(newStr)
                .then(() => {
                }).catch((err: BusinessError) => {
              });
              return true;
            }
            if (!(url.startsWith("http") || url.startsWith("https"))) {
              return false;
            }
            let result = new Pay().payInterceptorWithUrl(url, true, (result) => {
              let resultCode = result.get("resultCode");
              let returnUrl = result.get("returnUrl");
              this.controller.loadUrl(returnUrl);
            });
            return result;
          })
      }
    }
    .title("玉兰卡")
    .menus(this.menuItems)
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}