import { webview } from "@kit.ArkWeb";
import router from '@ohos.router';
import preferences from '@ohos.data.preferences';

let account:string
let password:string
try {
  account = (router.getParams() as Record<string, string>)['id2'];
  password = (router.getParams() as Record<string, string>)['id1'];
} catch (e) {
  account = ""
  password = ""
}

let context = getContext(this)
let  api: Array<ScriptItem> = [{ script: "username.value='" + account + "';password.value='" + password + "';submit.disabled='';submit.click()", scriptRules: ["*"] }]
@Entry
@Component
export struct Vcard {
  controller: webview.WebviewController = new webview.WebviewController()
  @State jsapi:Array<ScriptItem> = api
  aboutToAppear(): void {
    let options: preferences.Options = { name: 'information' };
    let dataPreferences: preferences.Preferences = preferences.getPreferencesSync(context, options)
      account = dataPreferences.getSync("account", 'default')+""
      password = dataPreferences.getSync("password", "default")+""
      api =  [{ script: "username.value='" + account + "';password.value='" + password + "';submit.disabled='';submit.click()", scriptRules: ["*"] }]
  }
  build() {
    Column() {
      Web({ src: "https://card.m.dlut.edu.cn/virtualcardrj/openRjQrcodePage", controller: this.controller })
        .javaScriptAccess(true)
        .fileAccess(true)
        .imageAccess(true)
        .onlineImageAccess(true)
        .domStorageAccess(true)
        .javaScriptOnDocumentEnd(this.jsapi)
        .cacheMode(CacheMode.Online)
        .onControllerAttached(() => {
          let userAgent = "Mozilla/ 5.0 (Linux; Android 10; EBG Build/ HUAWEIEBG; wv) AppleWebKit/ 537.36 (KHTML, like Gecko) Version/ 4.0 Chrome/ 88.0.4324.93 Mobile Safari/ 537.36 weishao(3.3.0.74633)";
          this.controller.setCustomUserAgent(userAgent);
        })
        .onLoadIntercept((event)=>{
          let data = event.data;
          let url:string = data.getRequestUrl();
          if (url.includes("api.m.dlut.edu.cn/login?client_id=")){
            this.jsapi = api
          } else if (url.includes("https://card.m.dlut.edu.cn/virtualcard/openVirtualcard?")){
            this.jsapi = [{script:"document.getElementsByClassName('top gradient2')[0].outerHTML=''",scriptRules: ["*"]}]
          }
          return false
        })
    }

  }
}