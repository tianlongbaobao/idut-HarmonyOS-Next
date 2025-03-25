@Component
export struct pageinformation {
  pathStack: NavPathStack = new NavPathStack();
  build() {
    NavDestination() {
      Row(){
        Column() {
          Text("作者:").margin({ top: 25, right: "70%" })
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
          Row() {
            Image($rawfile('self.jpg'))
              .syncLoad(true)
              .width(90)
              .borderRadius(35)
              .margin({ left: "10%" })

            Text("天龙宝宝").margin({ top: "5%" ,left: "20%"})
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
            Hyperlink('https://github.com/tianlongbaobao', 'Github主页') {
            }.margin({ top: "5%" ,left: "20%"})
          }.margin({ top: "5%" ,right: "40%"})
          Text("特别鸣谢:").margin({ top: "10%", right: "60%" })
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
          Row() {
            Image($rawfile('thank.png'))
              .syncLoad(true)
              .width(90)
              .borderRadius(35)
              .margin({ left: "10%" })

            Text("Shirai_Kuroko").margin({ top: "5%" ,left: "10%"})
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
            Hyperlink('https://github.com/IShiraiKurokoI', 'Github主页') {
            }.margin({ top: "5%" ,left: "10%"})
          }.margin({ top: "5%" ,right: "40%"})
          Row() {
            Image($rawfile('naosi.png'))
              .syncLoad(true)
              .width(120)
              .borderRadius(35)
              .margin({ left: "10%" })
            Hyperlink('https://naosi.org/', "开发区网络与开源软件协会") {
            }.margin({ top: "5%" ,left: "10%"})
          }.margin({ top: "10%" ,right: "40%"})
          Text("版本运维:").margin({ top: "10%", right: "60%" })
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
          Row() {
            Image($rawfile('self.jpg'))
              .syncLoad(true)
              .width(90)
              .borderRadius(35)
              .margin({ left: "10%" })

            Text("luzhiyi@mail.dlut.edu.cnGithub源码提Issue").margin({ top: "5%" ,left: "7%"})
              .fontSize(18)
          }.margin({ top: "5%" ,right: "40%"})
          Row() {
            Image($rawfile('naosi.png'))
              .syncLoad(true)
              .width(120)
              .borderRadius(35)
              .margin({ left: "10%" })
            Text("Q群:724021138").margin({ top: "5%" ,left: "10%"})
              .fontSize(18)
          }.margin({ top: "10%" ,right: "40%"})
        }
      }
    }.title("联系我们")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}