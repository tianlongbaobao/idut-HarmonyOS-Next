// CustomDialogComponent.ets
// 自定义弹窗
@CustomDialog
export  struct PrivacyDialog {
  controller: CustomDialogController = new CustomDialogController({'builder': ''});
  // 不同意按钮回调
  cancel: Function = () => {};
  // 同意按钮回调
  confirm: Function = () => {};
  build() {
    Column() {
      // 弹窗标题
      Text("欢迎使用i大工社区版")
        .width("80%")
        .fontColor("black")
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .margin({
          top: "10%",
        })
      Text("i大工官方版隐私政策与服务协议：")
        .width("80%")
        .fontColor("black")
        .fontSize(15)
        .margin({
          top: "5%",
        })
      Row() {
        Hyperlink("https://its.dlut.edu.cn/upload/app/agreements/index.html", '服务协议') {
        }
        .color(Color.Blue)
        Blank()
          .width("15%")
          .height("3%")
        Hyperlink("https://its.dlut.edu.cn/upload/app/privacy/index.html", '隐私政策') {
        }
        .color(Color.Blue)
      }.margin({ top: "5%" })
      Text("请详细阅读以上协议政策并完全知晓")
        .width("80%")
        .fontColor("black")
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Bold)
        .fontSize(15)
        .margin({
          top: "5%",
        })
      Text("i大工社区版隐私政策和服务协议：")
        .width("80%")
        .fontColor("black")
        .fontSize(15)
        .margin({
          top: "7%",
        })
      Text("      i大工社区版是由校内独立开发者开发，方便师生在鸿蒙Next设备上使用相关服务的App，开发者承诺：")
        .width("80%")
        .fontColor("black")
        .fontWeight(FontWeight.Bold)
        .fontSize(15)
        .margin({
          top: "3%",
        })
      Text("1.该软件遵守Apache-2.0协议开源，但是服务器加密算法不会开源，保证不会对i大工服务器安全造成威胁")
        .width("80%")
        .fontColor("black")
        .fontSize(15)
        .margin({
          top: "3%",
        })
      Text("2.该软件不会将用户数据泄露到个人或其他机构的服务器，用户数据只会保留在用户本机，该软件申请联网权限目的只是与i大工服务器端建立联系")
        .width("80%")
        .fontColor("black")
        .fontSize(15)
      Text("3.该软件申请的相机和图库权限只用于玉兰卡扫一扫和照片采集")
        .width("80%")
        .fontColor("black")
        .fontSize(15)

      Text("请用户承诺：")
        .width("80%")
        .fontColor("black")
        .fontSize(15)
        .margin({
          top: "3%",
        })
      Text("     不泄露加密算法，不将软件商业使用。如果i大工官方版正式上架App Gallery请下载官方版使用服务")
        .width("80%")
        .fontColor("black")
        .fontWeight(FontWeight.Bold)
        .fontSize(15)
        .margin({
          top: "3%",
        })

      Row() {
        // 取消按钮
        Text("不同意")
          .fancy()
          .fontColor("red")
          .onClick(() => {
            this.controller.close();
            this.cancel()
          })
        Blank()
          .width("10%")
          .height("5%")
        // 同意按钮
        Text("同意")
          .fancy()
          .fontColor("blue")
          .onClick(() => {
            this.controller.close();
            this.confirm()
          })
      }
      .margin({top:"10%", bottom: "8%"})
    }
  }
}

// 按钮公共样式抽取
@Extend(Text) function fancy () {
  .fontSize(18)
  .textAlign(TextAlign.Center)
  .fontWeight(FontWeight.Medium)
  .layoutWeight(12)
}