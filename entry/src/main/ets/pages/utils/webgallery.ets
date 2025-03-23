import { webview } from "@kit.ArkWeb";
import {startBrowser} from "../utils/browser"
import {common} from "@kit.AbilityKit"


let url:string = ""
@Component
export struct pagewebgallery {
  @State sso:Array<ScriptItem> = []
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
    console.log(JSON.stringify(this.pathStack.getParamByName('轮播图')[0]))
    url =(JSON.stringify(this.pathStack.getParamByName('轮播图')[0])).replace(/^["']|["']$/g, '')
  }
  build() {
    NavDestination() {
      Column() {
        Web({ src: url, controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(this.sso)
          .onLoadIntercept((event) => {
            let data = event.data;
            this.URI = data.getRequestUrl();
            return false
          })
      }
    }.title("轮播图")
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