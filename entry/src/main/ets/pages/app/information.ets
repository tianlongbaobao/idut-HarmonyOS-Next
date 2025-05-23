@Component
export struct pageinformation {
  pathStack: NavPathStack = new NavPathStack();
  build() {
    NavDestination() {
      Scroll(){
        Column()
        {
          Flex({ alignItems:ItemAlign.Start}){
          Text("作者:").margin({ top: "2.5%" })
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            }
          Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems:ItemAlign.Center,direction: FlexDirection.Row})  {
            Image($rawfile('self.png'))
              .syncLoad(true)
              .width(60)
              .borderRadius(35)
              .margin({left:"5%"})
            Text("天龙宝宝")
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
            Hyperlink('https://github.com/tianlongbaobao', 'Github主页') {
            }
            .margin({right:"4%"})
          }.margin({ top: "5%"})
          .borderRadius(20)
          .backgroundColor($r("app.color.information"))
          .height(90)
          Flex({ alignItems:ItemAlign.Start}) {
            Text("特别鸣谢:").margin({ top: "10%" })
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
          }
          Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems:ItemAlign.Center,direction: FlexDirection.Row}) {
            Image($rawfile('thank.png'))
              .syncLoad(true)
              .width(60)
              .borderRadius(35)
              .margin({left:"5%"})

            Text("Shirai_Kuroko")
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
            Hyperlink('https://github.com/IShiraiKurokoI', 'Github主页') {
            }.margin({right:"4%"})
          }.margin({ top: "5%"})
          .borderRadius(20)
          .backgroundColor($r("app.color.information"))
          .height(90)

          Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems:ItemAlign.Center,direction: FlexDirection.Row})  {
            Image($rawfile('naosi.png'))
              .syncLoad(true)
              .height(40)
              .borderRadius(35)
              .margin({ left: "4%" })
            Hyperlink('https://naosi.org/', "开发区网络与开源软件协会") {
            }.margin({ right: "5%" })
          }.margin({ top: "5%"})
          .borderRadius(20)
          .backgroundColor($r("app.color.information"))
          .height(90)
          Flex({ alignItems:ItemAlign.Start}) {
            Text("版本运维:").margin({ top: "10%"})
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
          }
          Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems:ItemAlign.Center,direction: FlexDirection.Row})  {
            Image($rawfile('self.png'))
              .syncLoad(true)
              .width(60)
              .borderRadius(35)
              .margin({ left: "5%" })

            Hyperlink("luzhiyi@mail.dlut.edu.cn").margin({right: "4%" })
          }
          .margin({ top: "5%"})
          .borderRadius(20)
          .backgroundColor($r("app.color.information"))
          .height(90)

          Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems:ItemAlign.Center,direction: FlexDirection.Row})  {
            Image($rawfile('hmos.png'))
              .syncLoad(true)
              .width(60)
              .borderRadius(35)
              .margin({ left: "4%" })
            Text("Q群：541832482").margin({ right: "5%" })
              .fontSize(18)

          }.margin({ top: "5%"})
          .borderRadius(20)
          .backgroundColor($r("app.color.information"))
          .height(90)
        }.margin({right:"5%",left:"5%",top:"5%"})
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