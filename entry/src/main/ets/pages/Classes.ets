import webview from '@ohos.web.webview';
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
struct Classes {
  controller: webview.WebviewController = new webview.WebviewController()
  aboutToAppear(): void {
    dataPreferences.getPreferences(context, "information").then(preferences=> {
      preferences.get("account", 'default').then((value) => {
        preferences.get("password", "default").then((ljc) => {
          account = String(value)
          password = String(ljc)
          console.log(account)
          console.log("account")
          api = [{ script: "username.value='" + account + "';password.value='" + password + "';submit.disabled='';submit.click()", scriptRules: ["*"] }]
        })
      })
    })

  }
  build() {
    Column() {
      Web({
        src: "https://api.m.dlut.edu.cn/oauth/authorize?client_id=9qXqHnRQuhhViycC&redirect_uri=https%3a%2f%2flightapp.m.dlut.edu.cn%2fcheck%2fcourseschedule&response_type=code&scope=base_api&state=dlut",
        controller: this.controller
      })
        .javaScriptAccess(true)
        .fileAccess(true)
        .imageAccess(true)
        .onlineImageAccess(true)
        .domStorageAccess(true)
        .javaScriptOnDocumentEnd(api)
    }
  }
}