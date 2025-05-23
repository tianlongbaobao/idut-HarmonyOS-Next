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
    password:this.password,account:this.account
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    autoCancel: false,
    cornerRadius:20,
  })
  build() {
    Navigation(this.pathStack) {
      RelativeContainer() {
        Column() {
          Image($rawfile('login.jpg'))
            .syncLoad(true)
            .width(150)
          TextInput({ placeholder: '职工号/学号' }).margin({ top: 30,left: "8%", right: "8%"  })
            .onChange((value: string) => {
              this.account = value
            })
            .constraintSize({
              maxWidth:500
            })
          TextInput({ placeholder: '密码' }).type(InputType.Password).margin({ top: 50,left: "8%", right: "8%"  })
            .onChange((value: string) => {
              this.password = value
            })
            .constraintSize({
              maxWidth:500
            })
          Button('登录').width(150).margin({ top: 50  })
            .onClick(() => {
              this.dialogController.open()
            })
          Text() {
            Span('找回密码').fontColor("blue").onClick(() => {
              this.pathStack.pushPath({ name: "找回密码" })
            })

          }
          .margin({ top: 30,left: "8%", right: "8%"  })
        }
        .alignRules({center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }})
      }

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

