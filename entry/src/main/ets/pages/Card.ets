import { webview } from "@kit.ArkWeb";
import router from '@ohos.router';
import dataPreferences from '@ohos.data.preferences';

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
struct Vcard {
  controller: webview.WebviewController = new webview.WebviewController()
  aboutToAppear(): void {
    dataPreferences.getPreferences(context, "information").then(preferences=> {
      preferences.get("account", 'default').then((value) => {
        preferences.get("password", "default").then((ljc) => {
          account = String(value)
          password = String(ljc)
          api =  [{ script: "username.value='" + account + "';password.value='" + password + "';submit.disabled='';submit.click()", scriptRules: ["*"] }]
        })
      })
    })

  }
  build() {
    Column() {
      Web({ src: "https://api.m.dlut.edu.cn/oauth/authorize?client_id=19b32196decf419a&redirect_uri=https%3A%2F%2Fcard.m.dlut.edu.cn%2Fhomerj%2FopenRjOAuthPage&response_type=code&scope=base_api&state=weishao", controller: this.controller })
        .javaScriptAccess(true)
        .fileAccess(true)
        .imageAccess(true)
        .onlineImageAccess(true)
        .domStorageAccess(true)
        .javaScriptOnDocumentEnd(api)
        .cacheMode(CacheMode.Online)
        .onControllerAttached(() => {
          let userAgent = "Mozilla/ 5.0 (Linux; Android 10; EBG Build/ HUAWEIEBG; wv) AppleWebKit/ 537.36 (KHTML, like Gecko) Version/ 4.0 Chrome/ 88.0.4324.93 Mobile Safari/ 537.36 weishao(3.3.0.74633)";
          this.controller.setCustomUserAgent(userAgent);
        })
    }

  }
}