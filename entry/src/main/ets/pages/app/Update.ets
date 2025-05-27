import { updatedata } from "../backrequest/Update"
import { MdPreview, PreviewOption } from '@rv/markdown-preview';

@CustomDialog
export struct UpdateDialog {
  @Prop name: string
  @Prop body: string
  @Prop download:string
  @Prop versionname:string
  @Prop release:boolean
  @Prop name_re: string
  @Prop body_re: string
  @Prop download_re:string
  @Prop release_re:boolean
  controller: CustomDialogController = new CustomDialogController({ 'builder': ''});
  @State showFlag: Visibility = Visibility.Visible;
  build() {
    Scroll() {
      Column() {
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, direction: FlexDirection.Row }) {
          Text("检查更新")
            .margin({ left: "7%" })
            .fontSize(20)
            .fontColor($r("app.color.text"))
            .fontWeight(FontWeight.Bold)
        }
        .margin({ top: 20, left: "5%" })

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, direction: FlexDirection.Row }) {
          Text("稳定版")
            .margin({ left: "10%" })
            .fontSize(18)
            .fontColor($r("app.color.text"))
            .fontWeight(FontWeight.Bold)
        }
        .margin({ top: 20, left: "5%" })

        Flex({ justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center, direction: FlexDirection.Row }) {
          Image($r('app.media.start'))
            .syncLoad(true)
            .width(40)
          Text("i大工社区版")
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r("app.color.text"))
          Text(this.name_re)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r("app.color.text"))
        }
        .margin({ top: 30, left: "5%", right: "5%" })

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, direction: FlexDirection.Row }) {
          MdPreview({ md: this.body_re })
        }
        .margin({ top: 30, left: "10%", right: "10%" })

        if (this.name != this.name_re) {
          Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, direction: FlexDirection.Row }) {
            Text("测试版")
              .margin({ left: "10%" })
              .fontSize(18)
              .fontColor($r("app.color.text"))
              .fontWeight(FontWeight.Bold)
          }
          .margin({ top: 20, left: "5%" })

          Flex({ justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center, direction: FlexDirection.Row }) {
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

          Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, direction: FlexDirection.Row }) {
            MdPreview({ md: this.body })
          }
          .margin({ top: 30, left: "10%", right: "10%" })
        }
        if (this.versionname != this.name) {
          if (this.release == false) {
            Row() {
              Button("下载")
                .onClick(() => {
                  updatedata(this.download)
                  this.cancel()
                })
                .width("50%")
            }
            .margin({ top: 30 })
          } else {
            Flex({
              justifyContent: FlexAlign.SpaceBetween,
              direction: FlexDirection.Row,
              alignItems: ItemAlign.Center
            }) {
              Button("下载测试版")
                .onClick(() => {
                  updatedata(this.download)
                  this.cancel()
                })
                .width("35%")
                .margin({ left: "10%" })
              Button("使用稳定版")
                .onClick(() => {
                  this.cancel()
                })
                .width("35%")
                .backgroundColor("red")
                .margin({ right: "10%" })
            }.margin({ top: 30 })
          }
        } else {
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
  }
  cancel() {
    this.showFlag = Visibility.Hidden;
    setTimeout(() => {
      this.controller.close();
    }, 200)
  }
}

