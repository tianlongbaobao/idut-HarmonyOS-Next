// CustomDialogComponent.ets
import { LoginRequest } from "./backrequest/Login";

// 自定义弹窗
@CustomDialog
export  struct PrivacyDialog {
  controller: CustomDialogController = new CustomDialogController({'builder': ''});
  @State showFlag: Visibility = Visibility.Visible;
  @Prop password:string
  @Prop account:string
  // 同意按钮回调
  confirm(){
    this.showFlag = Visibility.Hidden
    setTimeout(() => {
      this.controller.close();
    }, 200)
    LoginRequest(this.password.trim(), this.account.trim())
  };
  build() {
    Column() {
      // 弹窗标题
      Text("欢迎使用i大工社区版")
        .fontColor($r("app.color.text"))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .margin({
          top: 30,
        })
      Flex({justifyContent: FlexAlign.Start}) {
        Text("i大工官方版隐私政策与服务协议：")
          .fontColor($r("app.color.text"))
          .fontSize(15)
          .margin({
            top: 30, right: "8%", left: "8%"
          })
      }
      Row() {
        Hyperlink("https://its.dlut.edu.cn/upload/app/agreements/index.html", '服务协议') {
        }
        .color(Color.Blue)
        Blank()
          .height(15)
        Hyperlink("https://its.dlut.edu.cn/upload/app/privacy/index.html", '隐私政策') {
        }
        .color(Color.Blue)
      }.margin({ top: 30 })
      Flex({justifyContent: FlexAlign.Start}) {
        Text("i大工社区版隐私政策和服务协议：")
          .fontColor($r("app.color.text"))
          .fontSize(15)
          .margin({
            top: 15, right: "8%", left: "8%"
          })
      }
      Flex({justifyContent: FlexAlign.Start}) {
        Text("i大工社区版是由校内独立开发者开发，方便师生在鸿蒙Next设备上使用相关服务的App，开发者承诺：")
          .fontColor($r("app.color.text"))
          .fontWeight(FontWeight.Bold)
          .fontSize(15)
          .margin({
            top: 15, right: "8%", left: "8%"
          })
      }
      Flex({justifyContent: FlexAlign.Start}) {
        Text("1.该软件遵守Apache-2.0协议开源，但是服务器加密算法不会开源，保证不会对i大工服务器安全造成威胁")
          .fontColor($r("app.color.text"))
          .fontSize(15)
          .margin({
            top: 15, right: "8%", left: "8%"
          })
      }
      Flex({justifyContent: FlexAlign.Start}) {
        Text("2.该软件不会将用户数据泄露到个人或其他机构的服务器，用户数据只会保留在用户本机，该软件申请联网权限目的只是与i大工服务器端建立联系")
          .fontColor($r("app.color.text"))
          .fontSize(15)
          .margin({
            right: "8%", left: "8%"
          })
      }

      Flex({justifyContent: FlexAlign.Start}) {
        Text("请用户承诺：")
          .fontColor($r("app.color.text"))
          .fontSize(15)
          .margin({
            top: 15, right: "8%", left: "8%"
          })
      }
      Text("     不泄露加密算法，不将软件商业使用。如果i大工官方版正式上架App Gallery请下载官方版使用服务")
        .fontColor($r("app.color.text"))
        .fontWeight(FontWeight.Bold)
        .fontSize(15)
        .margin({
          top: 15,right:"8%",left:"8%"
        })
      Flex({justifyContent: FlexAlign.SpaceBetween,direction:FlexDirection.Row,alignItems:ItemAlign.Center}) {
        // 取消按钮
        Button("不同意")
          .backgroundColor("red")
          .onClick(() => {
            this.cancel()
          })
          .margin({left:"15%"})
          .width("30%")
          .constraintSize({
            maxWidth:250
          })

        Button("同意")
          .backgroundColor("blue")
          .onClick(() => {
            this.confirm()
          })
          .width("30%")
          .constraintSize({
            maxWidth:250
          })
          .margin({right:"15%"})
      }
      .margin({top:30, bottom: "8%"})
    }
    .backgroundColor($r("app.color.tab"))
    .borderRadius(30)
    .visibility(this.showFlag)
    .transition(TransitionEffect.OPACITY.animation({ duration: 200 }).combine(TransitionEffect.translate({ y: 100 })))
  }
  cancel() {
    this.showFlag = Visibility.Hidden;
    setTimeout(() => {
      this.controller.close();
    }, 200)
  }
}

