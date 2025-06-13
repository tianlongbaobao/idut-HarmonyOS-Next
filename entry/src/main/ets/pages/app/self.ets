import dataPreferences from '@ohos.data.preferences';
import {responsebean} from "../utils/ResponseBean"
import {MsgResult} from "../utils/MSG"

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
        let value_in = preferences.getSync("photo",'default')+""
        console.log(value_in)
        let photo_in:MsgResult = JSON.parse(String(value_in))
        this.id_photo = "data:image/png;base64," + photo_in.data.id_photo.replace(/\\\//g, "/")
      })
    }).catch((err:Error)=>{

    })
  }
  @Builder OverlayNode() {
    Row() {
      Image(this.id_photo)
        .height("40%")
        .syncLoad(true)
      Column(){
        Text("姓名:"+ this.name)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor("black")
        Blank()
          .height("7%")
        Text("学号:"+ this.username)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor("black")
        Blank()
          .height("7%")
        Text("院系:"+ this.org)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor("black")
      }
      .alignItems(HorizontalAlign.Start)
      .margin({left:10})
    }.margin({left:23,top:"1%"})
  }
  build() {
    NavDestination() {
      Column() {
        Row() {
          Image(this.backgroundurl)
            .height(200)
            .borderRadius(20)
            .overlay(this.OverlayNode(), { align: Alignment.Center })
            .objectFit(ImageFit.Contain)
            .margin({top:"8%"})
        }
      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM])
    .title("个人证件")
    .backgroundColor($r('app.color.background'))
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }

}