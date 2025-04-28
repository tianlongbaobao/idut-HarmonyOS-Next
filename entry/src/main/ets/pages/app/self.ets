import dataPreferences from '@ohos.data.preferences';
import {responsebean} from "../utils/ResponseBean"
import {PhotoBean} from "../utils/photobean"

let context = getContext(this)
@Component
export struct pageself {
  @State id_photo:string = ""
  @State backgroundurl:string = ""
  @State username:string = ""
  @State name:string = ""
  @State org:string = ""

  pathStack: NavPathStack = new NavPathStack();
  aboutToAppear(): void {
    dataPreferences.getPreferences(context, "information").then(preferences=>{
      preferences.get("data",'default').then((value)=>{
        let data_c:responsebean = JSON.parse(String(value))
        this.name = data_c.data.my_info.name
        this.username = data_c.data.my_info.student_number
        this.org = data_c.data.my_info.org[0].name
        if (data_c.data.my_info.authority_identity == "teacher"){
          this.backgroundurl="https://store.m.dlut.edu.cn/group1/M00/00/08/ynZM2VkeWmaAM-KOAADN7zRo2AM2844791"
        } else if (data_c.data.my_info.authority_identity == "master"){
          this.backgroundurl= "https://store.m.dlut.edu.cn/group1/M00/00/08/ynZM2VkeWmiASfbLAAKB81vLQoA7280918"
        }else {
          this.backgroundurl= "https://store.m.dlut.edu.cn/group1/M00/00/08/ynZM2VkeWmeATT1oAAJ416V6N7k0520839"
        }
        preferences.get("photo",'default').then((value)=>{
          let photo_in:PhotoBean = JSON.parse(String(value))
          this.id_photo = "data:image/png;base64," + photo_in.data.id_photo.replace(/\\\//g, "/")
        })
      })
    }).catch((err:Error)=>{

    })
  }
  @Builder OverlayNode() {
    Row() {
      Image(this.id_photo)
        .width("30%").height("40%")
      Column(){
        Text("姓名:"+ this.name)
          .fontSize(10)
          .fontWeight(FontWeight.Bold)
          .fontColor("black")
        Blank()
          .height("7%")
        Text("学号:"+ this.username)
          .fontSize(10)
          .fontWeight(FontWeight.Bold)
          .fontColor("black")
        Blank()
          .height("7%")
        Text("院系:"+ this.org)
          .fontSize(10)
          .fontWeight(FontWeight.Bold)
          .fontColor("black")
      }
      .alignItems(HorizontalAlign.Start)
      .margin({left:"5%"})
    }.margin({left:"10%",top:"1%"})
  }
  build() {
    NavDestination() {
      Column() {
        Row() {
          Image(this.backgroundurl)
            .height("25%")
            .width("80%")
            .borderRadius(20)
            .overlay(this.OverlayNode(), { align: Alignment.Center })
            .objectFit(ImageFit.Contain)
            .margin({top:"8%"})
        }
      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM])
    .title(this.TitleBuilder,{backgroundColor:$r('app.color.background')})
    .backgroundColor($r('app.color.background'))
    .backButtonIcon($r("app.media.button"))
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
  @Builder
  TitleBuilder() {
    Text("个人证件")
      .fontColor($r('app.color.text'))
      .fontSize(20)
      .margin({top:"4.5%",left:"3%"})
      .fontWeight(FontWeight.Bold)
  }
}