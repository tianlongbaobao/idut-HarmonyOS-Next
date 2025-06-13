import dataPreferences from '@ohos.data.preferences';
import {responsebean} from "../utils/ResponseBean"
import { changeNickName } from '../backrequest/changenickname';
import { getgallery } from '../backrequest/gallery';

let context = getContext(this)
// CustomDialogComponent.ets
// 自定义弹窗
@CustomDialog
struct PrivacyDialog {
  @Link nickname:string
  controller: CustomDialogController = new CustomDialogController({'builder': ''});

  cancel: Function = () => {

  };

  confirm: Function = () => {
    return this.nickname
  };
  build() {
    Column() {
      // 弹窗标题
      Row(){
        Text("请输入更改后昵称")
          .fontWeight(FontWeight.Bold)
          .fontSize(20)
          .fontColor($r('app.color.text'))

      }.margin({top:"5%"})
      Row(){
        TextInput({ placeholder: '昵称' }).margin({ top: "10%" })
          .onChange((value: string) => {
            this.nickname = value
          })
      }.margin({left:"10%",right:"10%"})



      Row() {
        // 取消按钮
        Text("取消")
          .fancy()
          .fontColor("red")
          .onClick(() => {
            this.controller.close();
            this.cancel()
          })
        Blank()
          .width("10%")
          .height("5%")
        // 同意按钮
        Text("确定")
          .fancy()
          .fontColor("blue")
          .onClick(() => {
            this.controller.close();
            this.confirm()
          })
      }
      .margin({top:"10%", bottom: "8%"})
      .backgroundColor($r('app.color.background'))
    }
    .backgroundColor($r('app.color.background'))
  }
}

// 按钮公共样式抽取
@Extend(Text) function fancy () {
  .fontSize(18)
  .textAlign(TextAlign.Center)
  .fontWeight(FontWeight.Medium)
  .layoutWeight(12)
}
@Component
export struct pageselfinformation {
  @State id_photo:string = ""
  @State username:string = ""
  @State name:string = ""
  @State org:string = ""
  @Link nickname:string
  @State identity:string = ""
  @State cellphone:string = ""
  @State email:string = ""
  @State verify:string = ""
  @State user_id:string = ""
  @State idc:string = ""

  constructor() {
    super();
    this.nickname = ""
  }
  pathStack: NavPathStack = new NavPathStack();
  dialogController: CustomDialogController = new CustomDialogController({
    builder: PrivacyDialog({
      nickname: $nickname,
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() },
    }),
    autoCancel:true,
    cancel: ()=> { this.onCancel()},
  })
  onCancel() {
    dataPreferences.getPreferences(context, "information").then(preferences=> {
      preferences.get("data", 'default').then((value) => {
        let data_c:responsebean = JSON.parse(String(value))
        this.nickname = data_c.data.my_info.nick_name
      })
    })
  }
  onAccept() {
    changeNickName(this.nickname,this.username,this.idc,this.verify,this.user_id)

  }
  aboutToAppear(): void {
    dataPreferences.getPreferences(context, "information").then(preferences=>{
      preferences.get("data",'default').then((value)=>{
        let data_c:responsebean = JSON.parse(String(value))
        this.name = data_c.data.my_info.name
        this.username = data_c.data.my_info.student_number
        this.org = data_c.data.my_info.org[0].name
        this.id_photo = data_c.data.my_info.head
        this.nickname = data_c.data.my_info.nick_name
        this.cellphone = data_c.data.my_info.celphone
        this.email = data_c.data.my_info.email
        this.verify = data_c.data.verify
        this.user_id = data_c.data.my_info.user_id
        this.idc = data_c.data.my_info.identity
        if (data_c.data.my_info.authority_identity == "teacher"){
          this.identity = "教职工"
        } else if (data_c.data.my_info.authority_identity == "master"){
          this.identity = "硕士生"
        }else if (data_c.data.my_info.authority_identity == "bachelor"){
          this.identity = "本科生"
        }else {
          this.identity = "其他"
        }
      })
    }).catch((err:Error)=>{

    })
  }
  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween ,alignItems:ItemAlign.Center,direction: FlexDirection.Row}) {
            Text("头像")
              .margin({ left: "5%"})
              .fontSize(14)
              .fontColor($r('app.color.text'))
            Image(this.id_photo)
              .height(50)
              .margin({ right: "4%" })
          }
          .backgroundColor($r('app.color.background'))
          .borderRadius(20)
          .backgroundColor($r("app.color.information"))
          .height(70)
          .margin({right:"5%",left:"5%",top:"5%"})


          Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems:ItemAlign.Center,direction: FlexDirection.Row }) {
            Text("姓名")
              .margin({ left: "5%"})
              .fontSize(14)
              .fontColor($r('app.color.text'))
            Text(this.name)
              .margin({ right: "4%" })
              .fontSize(14)
              .fontColor($r('app.color.text'))

          }
          .borderRadius(20)
          .backgroundColor($r("app.color.information"))
          .height(70)
          .margin({right:"5%",left:"5%",top:"5%"})


          Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems:ItemAlign.Center,direction: FlexDirection.Row }) {
            Text("昵称")
              .margin({ left: "5%" })
              .fontSize(14)
              .fontColor($r('app.color.text'))
            Text(this.nickname)
              .margin({ right: "4%" })
              .fontSize(14)
              .fontColor("blue")

          }
          .onClick(() => {
            this.dialogController.open()

          })
          .borderRadius(20)
          .backgroundColor($r("app.color.information"))
          .height(70)
          .margin({right:"5%",left:"5%",top:"5%"})

          Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems:ItemAlign.Center,direction: FlexDirection.Row }) {
            Text("职工号/学号")
              .margin({ left: "5%"})
              .fontSize(14)
              .fontColor($r('app.color.text'))
            Text(this.username)
              .margin({ right: "4%" })
              .fontSize(14)
              .fontColor($r('app.color.text'))

          }
          .borderRadius(20)
          .backgroundColor($r("app.color.information"))
          .height(70)
          .margin({right:"5%",left:"5%",top:"5%"})

          Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems:ItemAlign.Center,direction: FlexDirection.Row }) {
            Text("单位名称")
              .margin({ left: "5%" })
              .fontSize(14)
              .fontColor($r('app.color.text'))
            Text(this.org)
              .margin({ right: "4%" })
              .fontSize(14)
              .fontColor($r('app.color.text'))
          }
          .borderRadius(20)
          .backgroundColor($r("app.color.information"))
          .height(70)
          .margin({right:"5%",left:"5%",top:"5%"})


          Flex({ justifyContent: FlexAlign.SpaceBetween ,alignItems:ItemAlign.Center,direction: FlexDirection.Row}) {
            Text("身份类型")
              .margin({ left: "5%" })
              .fontSize(14)
              .fontColor($r('app.color.text'))
            Text(this.identity)
              .margin({ right: "4%" })
              .fontSize(14)
              .fontColor($r('app.color.text'))
          }
          .borderRadius(20)
          .backgroundColor($r("app.color.information"))
          .height(70)
          .margin({right:"5%",left:"5%",top:"5%"})

          Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems:ItemAlign.Center,direction: FlexDirection.Row }) {
            Text("手机号")
              .margin({ left: "5%"})
              .fontSize(14)
              .fontColor($r('app.color.text'))
            Text(this.cellphone)
              .margin({ right: "4%" })
              .fontSize(14)
              .fontColor($r('app.color.text'))
          }
          .borderRadius(20)
          .backgroundColor($r("app.color.information"))
          .height(70)
          .margin({right:"5%",left:"5%",top:"5%"})

          Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems:ItemAlign.Center,direction: FlexDirection.Row }) {
            Text("邮箱")
              .margin({ left: "5%" })
              .fontSize(14)
              .fontColor($r('app.color.text'))
            Text(this.email)
              .fontSize(14)
              .margin({ right: "4%" })
              .fontColor($r('app.color.text'))
          }
          .borderRadius(20)
          .backgroundColor($r("app.color.information"))
          .height(70)
          .margin({right:"5%",left:"5%",top:"5%"})
        }
      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM])
    .title("个人资料")
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