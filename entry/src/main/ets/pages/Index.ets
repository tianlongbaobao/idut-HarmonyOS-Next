import { webview } from "@kit.ArkWeb";
import { common } from '@kit.AbilityKit';
import {PrivacyDialog} from "./Privacy"
import {LoginRequest} from "./backrequest/Login"


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
          .margin({top:"15%"})
        TextInput({ placeholder: '职工号/学号' }).margin({ top: "5%" })
          .onChange((value: string) => {
            this.account = value
          })
        TextInput({ placeholder: '密码' }).type(InputType.Password).margin({ top: "5%" })
          .onChange((value: string) => {
            this.password = value
          })
        Button('登录').width(150).margin({ top: "5%" })
          .onClick(() => {
            console.log(this.password.trim())
            console.log(this.account.trim())
            this.dialogController.open()
          })
        Text() {
          Span('找回密码').fontColor("blue").onClick(() => {
            this.pathStack.pushPath({ name: "找回密码" })
          })

        }
        .margin({ top: "3%" })
      }
      .expandSafeArea([SafeAreaType.SYSTEM])
      .margin({ left: "8%", right: "8%" })
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
    .navDestination(this.PageMap)
  }
  onBackPress() {
    let context   = getContext(this) as common.UIAbilityContext
    context.terminateSelf()
    return true
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

