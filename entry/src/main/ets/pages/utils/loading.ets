@Component
export struct loaddialog {
  @Prop dialogID: string
  @State title: string = '加载中...'

  build() {
    Stack() {
      Column() {
        LoadingProgress()
          .color(Color.White).width(100).height(100)
        Text(this.title)
          .fontSize(18).fontColor(0xffffff).margin({ top: 8 })
          .visibility(this.title ? Visibility.Visible : Visibility.None)
      }
    }
    .onClick(() => {
      getContext(this).eventHub.emit(this.dialogID, "关闭弹窗")
    })
    .width(180)
    .height(180)
    .backgroundColor(0x88000000)
    .borderRadius(10)
    .shadow({
      radius: 10,
      color: Color.Gray,
      offsetX: 3,
      offsetY: 3
    })
  }
}