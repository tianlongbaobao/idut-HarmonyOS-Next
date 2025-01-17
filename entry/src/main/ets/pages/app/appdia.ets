import router from '@ohos.router';
import dataPreferences from '@ohos.data.preferences';
import {appList} from "./applist"

let  nowdata = (router.getParams() as Record<string, string>)['id3'];
let jksc:number[] = []

let context = getContext(this)
@Entry
@Component
struct appdia {
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
  private controller: TabsController = new TabsController()
  @Builder tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor("black")
        .fontSize(16)
        .fontWeight(this.selectedIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.selectedIndex === index ? 1 : 0)
    }.width('100%')
  }
  build() {
    Scroll() {
      Column() {
        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }){
          Text("编辑我的常用服务")
            .fontColor("black")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .height("8%")
        .width("100%")
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
          Column() {
            ForEach(this.appll, (item: number) => {
              ChildItem({ item: item })
                .margin({ top: 15 })
            })
          }
        }
        .margin({ left: "5%" })
        Button("确定")
          .width("80%")
          .margin({
            top:"5%"
          })
          .onClick(()=>{
            console.log(jksc.toString())
            dataPreferences.getPreferences(context, "information").then(preferences=> {
              preferences.put("nowdata", jksc.toString())
              preferences.flush()
              let value= preferences.getSync('password', 'default');
              let password = ""+value
              let values = preferences.getSync('account', 'default');
              let account = ""+values
              router.pushUrl({
                url: 'pages/Navigators',
                params:{
                  id1:password,
                  id2:account,
                  id4:jksc.toString()
                }
              })
            })
          })
      }
    }
  }
}

@Component
struct ChildItem{
  @Prop item:number;
  @State numberc:number = jksc.indexOf(this.item)
  build() {
    Row() {
      if (this.numberc== -1) {
        Checkbox({group: 'checkboxGroup' })
          .selectedColor('#007DFF')
          .shape(CheckBoxShape.ROUNDED_SQUARE)
          .onChange((value: boolean) => {
            if (value) {
              jksc.push(this.item)
            } else {
              for (let index = jksc.indexOf(this.item); index < jksc.length-1; index++) {
                jksc[index] = jksc[index+1]
              }
              jksc.pop()
            }
            console.log(jksc.toString())
          })
          .margin({ right: "5%" })
      } else {
        Checkbox({ group: 'checkboxGroup' })
          .select(true)
          .selectedColor('#007DFF')
          .shape(CheckBoxShape.ROUNDED_SQUARE)
          .onChange((value: boolean) => {
            if (value) {
              jksc.push(this.item)
            } else {
              for (let index = jksc.indexOf(this.item); index < jksc.length-1; index++) {
                jksc[index] = jksc[index+1]
              }
              jksc.pop()
            }
            console.log(jksc.toString())
          })
          .margin({ right: "5%" })
      }
      Image(appList[this.item].url)
        .height("100%")
        .width("13.5%")
        .borderRadius(25)
      Text(appList[this.item].name)
        .margin({left:"8%"})
    }
    .height("5%")
    .width("80%")
  }

}