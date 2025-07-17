import router from '@ohos.router';
import dataPreferences from '@ohos.data.preferences';
import {appList} from "./applist"
import { DetailDialog } from './detaildia';

let  nowdata = (router.getParams() as Record<string, string>)['id3'];
let jksc:number[] = []

let context = getContext(this)
@Entry
@Component
struct appdia {
  private Tabcontroller: TabsController = new TabsController();
  private scroller: Scroller = new Scroller();
  @StorageProp('currentBreakpoint') curBp: string = 'sm';
  aboutToAppear(): void {
    let mn = 0
    let nowdatas = nowdata.split(",")
    for (let index = 0; index < nowdatas.length; index++) {
      if (nowdatas[index]!=",") {
        jksc[mn] = Number(nowdatas[index])
        mn=mn+1
      }
    }
    for (let index = 0;index < appList.length;index++){
      this.appll[index] = index
    }
  }
  @State appll:number[] = []
  @State currentIndex: number = 0
  @State selectedIndex: number = 0
  private searchcontroller: SearchController = new SearchController()
  @State changeValue:string = ""
  build() {
      Column() {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center,direction: FlexDirection.Row }) {
          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Image($r("app.media.button"))
              .height(30)
              .borderRadius(35)
          }
          .margin({ left: "3%",top:"3%" })
          .backgroundColor($r('app.color.background'))
          .onClick(()=>{
            router.back()
          })
          Text("编辑我的常用服务")
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .margin({top:"3%"})
          Button("完成")
          .backgroundColor("red")
            .margin({
              top:"3%",right:"3%"
            })
            .onClick(()=>{
              dataPreferences.getPreferences(context, "information").then(preferences=> {
                preferences.put("nowdata", jksc.toString())
                preferences.flush()
                let value= preferences.getSync('password', 'default');
                let password = ""+value
                let values = preferences.getSync('account', 'default');
                let account = ""+values
                let gallery = preferences.getSync("gallery","null")+""
                let noaccount = preferences.getSync("noaccount","default")+""
                router.pushUrl({
                  url: 'pages/Navigators',
                  params:{
                    id1:password,
                    id2:account,
                    id4:jksc.toString(),
                    id6:gallery,
                    id7:noaccount
                  }
                })
              })
            })
        }
        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }){
          Search({ value: this.changeValue, placeholder: '搜索', controller: this.searchcontroller })
            .width('95%')
            .height(40)
            .placeholderFont({ size: 14, weight: 400 })
            .textFont({ size: 14, weight: 400 })
            .onChange((value: string) => {
              this.changeValue = value.trim()
            })
            .margin({top:20})
        }
        .height("8%")
        Tabs({ barPosition: BarPosition.Start, controller: this.Tabcontroller }) {
            TabContent() {
                Stack({ alignContent: Alignment.BottomEnd }) {
                  Column() {
                    Scroll(this.scroller) {
                      Flex({
                        justifyContent: FlexAlign.Start,
                        alignItems: ItemAlign.Start,
                        direction: FlexDirection.Column
                      }) {
                        ForEach(this.appll, (item: number) => {
                          if (appList[item].app_name.includes(this.changeValue)) {
                            ChildItem({ item: item })
                              .margin({ top: 15 })
                              .width("100%")
                          }
                        })
                      }
                    }
                  }.height("100%")

                  Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.End, alignItems: ItemAlign.End }) {
                    Button('回到顶部')
                      .height('5%')
                      .onClick(() => { // 点击后回到顶部
                        this.scroller.scrollEdge(Edge.Top)
                      })
                      .margin({ right: "3%", bottom: "3%" })
                  }

                }

            }.tabBar(SubTabBarStyle.of("全部"))

            TabContent() {
              Column() {
                Scroll() {
                  Flex({
                    justifyContent: FlexAlign.Start,
                    alignItems: ItemAlign.Start,
                    direction: FlexDirection.Column
                  }) {
                    ForEach(this.appll, (item: number) => {
                      if (appList[item].category == "study") {
                        if (appList[item].app_name.includes(this.changeValue)) {
                          ChildItem({ item: item })
                            .margin({ top: 15 })
                            .width("100%")
                        }
                      }

                    })

                  }
                }
              }.height("100%")
            }.tabBar(SubTabBarStyle.of("学习"))
            TabContent() {
              Column() {
                Scroll() {
                  Flex({
                    justifyContent: FlexAlign.Start,
                    alignItems: ItemAlign.Start,
                    direction: FlexDirection.Column
                  }) {
                    ForEach(this.appll, (item: number) => {
                      if (appList[item].category == "life") {
                        if (appList[item].app_name.includes(this.changeValue)) {
                          ChildItem({ item: item })
                            .margin({ top: 15 })
                            .width("100%")
                        }
                      }

                    })

                  }
                }
              }.height("100%")
            }.tabBar(SubTabBarStyle.of("生活"))
            TabContent() {
              Column() {
                Scroll() {
                  Flex({
                    justifyContent: FlexAlign.Start,
                    alignItems: ItemAlign.Start,
                    direction: FlexDirection.Column
                  }) {
                    ForEach(this.appll, (item: number) => {
                      if (appList[item].category == "office") {
                        if (appList[item].app_name.includes(this.changeValue)) {
                          ChildItem({ item: item })
                            .margin({ top: 15 })
                            .width("100%")
                        }
                      }

                    })

                  }
                }
              }.height("100%")
            }.tabBar(SubTabBarStyle.of("工作"))
            TabContent() {
              Column() {
                Scroll() {
                  Flex({
                    justifyContent: FlexAlign.Start,
                    alignItems: ItemAlign.Start,
                    direction: FlexDirection.Column
                  }) {
                    ForEach(this.appll, (item: number) => {
                      if (appList[item].category == "life") {
                        if (appList[item].app_name.includes(this.changeValue)) {
                          ChildItem({ item: item })
                            .margin({ top: 15 })
                            .width("100%")
                        }
                      }

                    })

                  }
                }
              }
              .height("100%")
            }.tabBar(SubTabBarStyle.of("生活"))
            TabContent() {
              Column() {
                Scroll() {
                  Flex({
                    justifyContent: FlexAlign.Start,
                    alignItems: ItemAlign.Start,
                    direction: FlexDirection.Column
                  }) {
                    ForEach(this.appll, (item: number) => {
                      if (appList[item].category == "social") {
                        if (appList[item].app_name.includes(this.changeValue)) {
                          ChildItem({ item: item })
                            .margin({ top: 15 })
                            .width("100%")
                        }
                      }

                    })

                  }
                  .constraintSize({ minHeight: '100%' })
                }
              }.height("100%")
            }.tabBar(SubTabBarStyle.of("社交"))
            TabContent() {
              Column(){
              Scroll() {
                Flex({
                  justifyContent: FlexAlign.Start,
                  alignItems: ItemAlign.Start,
                  direction: FlexDirection.Column
                }) {
                  ForEach(this.appll, (item: number) => {
                    if (appList[item].category == "fun") {
                      if (appList[item].app_name.includes(this.changeValue)) {
                        ChildItem({ item: item })
                          .margin({ top: 15 })
                          .width("100%")
                      }
                    }

                  })

                }
              }
              }.height("100%")
            }.tabBar(SubTabBarStyle.of("游戏"))
            .height("100%")
            }
            .barMode(BarMode.Scrollable)
            .layoutWeight(1)
        .vertical(this.curBp === 'lg')

      }

  }
}

@Component
struct ChildItem{
  @Prop item:number;
  @State numberc:number = jksc.indexOf(this.item)
  dialogController: CustomDialogController = new CustomDialogController({
    builder: DetailDialog({
      img:appList[this.item].icon,
      name:appList[this.item].app_name,
      de:appList[this.item].describe
    }),
    autoCancel:true,
    cancel: ()=> { this.onCancel()},
  })


  onCancel() {
    console.info('Callback when the first button is clicked')
  }
  build() {
      Row() {
        if (this.numberc == -1) {
          Checkbox({ group: 'checkboxGroup' })
            .shape(CheckBoxShape.ROUNDED_SQUARE)
            .onChange((value: boolean) => {
              if (value) {
                jksc.push(this.item)
              } else {
                for (let index = jksc.indexOf(this.item); index < jksc.length - 1; index++) {
                  jksc[index] = jksc[index+1]
                }
                jksc.pop()
              }
            })
            .margin({right:"5%",left:"5%"})
        } else {
          Checkbox({ group: 'checkboxGroup' })
            .select(true)
            .shape(CheckBoxShape.ROUNDED_SQUARE)
            .onChange((value: boolean) => {
              if (value) {
                jksc.push(this.item)
              } else {
                for (let index = jksc.indexOf(this.item); index < jksc.length - 1; index++) {
                  jksc[index] = jksc[index+1]
                }
                jksc.pop()
              }
            })
            .margin({right:"5%",left:"5%"})
        }
        Image(appList[this.item].icon)
          .borderRadius(25)
          .height(40)
        Text(appList[this.item].app_name)
          .margin({ left: "8%" })
          .onClick(()=>{
            this.dialogController.open()
          })
      }
      .width("80%")
  }

}