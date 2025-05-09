@Component
export struct pageinformation {
  pathStack: NavPathStack = new NavPathStack();
  build() {
    NavDestination() {
      Scroll(){
      Row() {
        Column() {
          Text("作者:").margin({ top: "2.5%", right: "70%" })
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
          Flex({ justifyContent: FlexAlign.SpaceBetween})  {
            Image($rawfile('self.png'))
              .syncLoad(true)
              .width("15%")
              .borderRadius(35)
              .margin({ left: "10%" })

            Text("天龙宝宝").margin({ top: "5%" })
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
            Hyperlink('https://github.com/tianlongbaobao', 'Github主页') {
            }.margin({ top: "5%", right: "10%" })
          }.margin({ top: "5%"})

          Text("特别鸣谢:").margin({ top: "10%", right: "60%" })
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
          Flex({ justifyContent: FlexAlign.SpaceBetween}) {
            Image($rawfile('thank.png'))
              .syncLoad(true)
              .width("15%")
              .borderRadius(35)
              .margin({ left: "10%" })

            Text("Shirai_Kuroko").margin({ top: "5%" })
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
            Hyperlink('https://github.com/IShiraiKurokoI', 'Github主页') {
            }.margin({ top: "5%", right: "10%" })
          }.margin({ top: "5%"})

          Flex({ justifyContent: FlexAlign.SpaceBetween})  {
            Image($rawfile('naosi.png'))
              .syncLoad(true)
              .width("20%")
              .borderRadius(35)
              .margin({ left: "10%" })
            Hyperlink('https://naosi.org/', "开发区网络与开源软件协会") {
            }.margin({ top: "5%", right: "10%" })
          }.margin({ top: "10%" })

          Text("版本运维:").margin({ top: "10%", right: "60%" })
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
          Flex({ justifyContent: FlexAlign.SpaceBetween})  {
            Image($rawfile('self.png'))
              .syncLoad(true)
              .width("15%")
              .borderRadius(35)
              .margin({ left: "10%" })

            Hyperlink("luzhiyi@mail.dlut.edu.cn").margin({ top: "5%", right: "10%" })
          }.margin({ top: "5%" })

          Flex({ justifyContent: FlexAlign.SpaceBetween})  {
            Image($rawfile('hmos.png'))
              .syncLoad(true)
              .width("15%")
              .borderRadius(35)
              .margin({ left: "10%" })
            Text("Q群：541832482").margin({ top: "5%", right: "10%" })
              .fontSize(18)

          }.margin({ top: "10%" })
        }
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