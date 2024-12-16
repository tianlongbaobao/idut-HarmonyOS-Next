import { webview } from "@kit.ArkWeb";
import {PrivacyDialog} from "./Privacy"
import {LoginRequest} from "./backrequest/Login"
const TAG = 'PrivacySubscribe';



@Entry
@Component
struct Index {
  @State account: string = "";
  @State password: string = ""
  pathStack: NavPathStack = new NavPathStack();

  @Builder
  PageMap(name: string) {
    if (name === "找回密码") {
      pageemail()
    }
  }
  dialogController: CustomDialogController = new CustomDialogController({
    builder: PrivacyDialog({
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() },
    }),
    autoCancel:true,
    cancel: ()=> { this.onCancel()},
  })


  onCancel() {
    console.info('Callback when the first button is clicked')
  }
  onAccept() {
    LoginRequest(this.password.trim(), this.account.trim())
    console.info('Callback when the second button is clicked')

  }
  build() {
    Navigation(this.pathStack) {
      Column() {
        Image($rawfile('login.jpg'))
          .syncLoad(true)
          .width(150)
          .margin({ top: "30%" })
        TextInput({ placeholder: '职工号/学号' }).margin({ top: "10%" })
          .onChange((value: string) => {
            this.account = value
          })
        TextInput({ placeholder: '密码' }).type(InputType.Password).margin({ top: "10%" })
          .onChange((value: string) => {
            this.password = value
          })
        Button('登录').width(150).margin({ top: "10%" })
          .onClick(() => {
            console.log(this.password.trim())
            console.log(this.account.trim())
            this.dialogController.open()
          })
        Text() {
          Span('找回密码').fontColor("blue").onClick(() => {
            console.log("1")
            this.pathStack.pushPath({ name: "找回密码" })
          })
        }.padding(20)
      }
      .margin({ left: "8%", right: "8%" })
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.PageMap)
  }
}

@Component
export struct pageemail {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://sso.dlut.edu.cn/cas/pwd?ip=service.m.dlut.edu.cn&verify=null", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
      }
    }.title("找回密码")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

