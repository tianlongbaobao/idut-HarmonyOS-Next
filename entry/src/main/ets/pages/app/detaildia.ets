@CustomDialog
export  struct DetailDialog {
  @Prop img:string
  @Prop name:string
  @Prop de:string
  controller: CustomDialogController = new CustomDialogController({'builder': ''});
  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }){
          Image(this.img)
            .height(40)
            .borderRadius(35)

          Text(this.name)
            .margin({left:"7%"})
            .fontSize(20)
            .fontColor($r("app.color.text"))
            .fontWeight(FontWeight.Bold)
        }
        .margin({top:"5%",left:"5%"})
      }
      Row(){
        Text(this.de)
          .fontSize(14)
          .fontColor($r("app.color.text"))
      }
      .margin({top:"5%",left:"5%",right:"5%"})

      Row() {
        Text("确定")
          .fontColor("blue")
          .onClick(() => {
            this.controller.close();
          })
      }
      .margin({top:"10%", bottom: "8%"})
    }
  }
}
