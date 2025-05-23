import { updatedata } from "../backrequest/Update"

@CustomDialog
export struct UpdateDialog {
  @Prop name: string
  @Prop body: string
  @Prop download:string
  @Prop versionname:string
  controller: CustomDialogController = new CustomDialogController({ 'builder': ''});
  @State showFlag: Visibility = Visibility.Visible;
  build() {
    Column() {
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center,direction:FlexDirection.Row }) {
          Text("检查更新")
            .margin({ left: "7%" })
            .fontSize(20)
            .fontColor($r("app.color.text"))
            .fontWeight(FontWeight.Bold)
        }
        .margin({ top: 20, left: "5%" })

      Flex({ justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center,direction:FlexDirection.Row }) {
        Image($r('app.media.start'))
          .syncLoad(true)
          .width(40)
        Text("i大工社区版")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r("app.color.text"))
        Text(this.name)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r("app.color.text"))
      }
      .margin({ top: 30, left: "5%", right: "5%" })
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center,direction:FlexDirection.Row }) {
        Text(this.body)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor($r("app.color.text"))
      }
      .margin({ top: 30, left: "10%", right: "10%" })
      if (this.versionname!=this.name) {

        Row() {
          Button("下载")
            .onClick(() => {
              updatedata(this.download)
              this.cancel()
            })
            .width("50%")
        }
        .margin({ top: 30 })
      }else {
        Row() {
          Button("已是最新版本")
            .onClick(() => {
              this.cancel()
            })
            .width("50%")
            .backgroundColor("red")
        }
        .margin({ top: 30 })
      }
      Blank()
        .height(16)
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

