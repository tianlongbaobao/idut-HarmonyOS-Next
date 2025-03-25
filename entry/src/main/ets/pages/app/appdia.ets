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
  private searchcontroller: SearchController = new SearchController()
  @State changeValue:string = ""
  @Builder tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontSize(16)
        .fontWeight(this.selectedIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
      Divider()
        .strokeWidth(2)
        .opacity(this.selectedIndex === index ? 1 : 0)
    }.width('100%')
  }
  build() {
    Scroll() {
      Column() {
        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }){
          Text("编辑我的常用服务")
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
        }
        .height("8%")
        .width("100%")
        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }){
          Search({ value: this.changeValue, placeholder: '搜索', controller: this.searchcontroller })
            .width('95%')
            .height(40)
            .placeholderFont({ size: 14, weight: 400 })
            .textFont({ size: 14, weight: 400 })
            .onChange((value: string) => {
              this.changeValue = value.trim()
            })
            .margin(20)
        }
        .height("8%")
        .width("100%")
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
          Column() {
            ForEach(this.appll, (item: number) => {
              if (appList[item].app_name.includes(this.changeValue)) {
                ChildItem({ item: item })
                  .margin({ top: 15 })
              }

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
              let gallery = preferences.getSync("gallery","null")+""
              router.pushUrl({
                url: 'pages/Navigators',
                params:{
                  id1:password,
                  id2:account,
                  id4:jksc.toString(),
                  id6:gallery
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
          })
          .margin({ right: "5%" })
      } else {
        Checkbox({ group: 'checkboxGroup' })
          .select(true)
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
          })
          .margin({ right: "5%" })
      }
        Image(appList[this.item].icon)
          .borderRadius(25)
          .height("100%")
          .width("13.5%")
      Text(appList[this.item].app_name)
        .margin({left:"8%"})
    }
    .height("5%")
    .width("80%")
  }

}