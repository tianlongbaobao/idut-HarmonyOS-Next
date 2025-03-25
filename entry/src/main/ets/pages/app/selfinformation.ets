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
      Column() {
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }){
          Text("头像")
            .margin({left:"10%",top:"4%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))
          Image(this.id_photo)
            .height("7%")
            .margin({left:"50%"})

        }
        .margin({top:"5%"})
        .backgroundColor($r('app.color.background'))
        .onClick(()=>{
          getgallery(this.username,this.idc,this.verify,this.user_id)
        })
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
          Divider()
            .strokeWidth(1)
            .lineCap(LineCapStyle.Square)
            .margin({ top: "3%" })
            .color($r('app.color.text'))
        }.margin({right:"8%",left:"8%"})
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }){
          Text("姓名")
            .margin({left:"10%",top:"4%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))
          Text(this.name)
            .height("7%")
            .margin({left:"50%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))

        }
        .margin({top:"5%"})
        .backgroundColor($r('app.color.background'))

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
          Divider()
            .strokeWidth(1)
            .lineCap(LineCapStyle.Square)
            .margin({ top: "3%" })
            .color($r('app.color.text'))
        }.margin({right:"8%",left:"8%"})
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }){
          Text("昵称")
            .margin({left:"10%",top:"4%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))
          Text(this.nickname)
            .height("7%")
            .margin({left:"50%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))

        }
        .margin({top:"5%"})
        .onClick(()=>{
          this.dialogController.open()

        })
        .backgroundColor($r('app.color.background'))

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
          Divider()
            .strokeWidth(1)
            .lineCap(LineCapStyle.Square)
            .margin({ top: "3%" })
            .color($r('app.color.text'))
        }.margin({right:"8%",left:"8%"})
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }){
          Text("职工号/学号")
            .margin({left:"10%",top:"4%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))
          Text(this.username)
            .height("7%")
            .margin({left:"30%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))

        }
        .margin({top:"5%"})
        .backgroundColor($r('app.color.background'))
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
          Divider()
            .strokeWidth(1)
            .lineCap(LineCapStyle.Square)
            .margin({ top: "3%" })
            .color($r('app.color.text'))
        }.margin({right:"8%",left:"8%"})
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }){
          Text("单位名称")
            .margin({left:"10%",top:"4%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))
          Text(this.org)
            .height("7%")
            .margin({left:"25%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))
        }
        .margin({top:"5%"})
        .backgroundColor($r('app.color.background'))
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
          Divider()
            .strokeWidth(1)
            .lineCap(LineCapStyle.Square)
            .margin({ top: "3%" })
            .color($r('app.color.text'))
        }.margin({right:"8%",left:"8%"})
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }){
          Text("身份类型")
            .margin({left:"10%",top:"4%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))
          Text(this.identity)
            .height("7%")
            .margin({left:"45%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))
        }
        .margin({top:"5%"})
        .backgroundColor($r('app.color.background'))

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
          Divider()
            .strokeWidth(1)
            .lineCap(LineCapStyle.Square)
            .margin({ top: "3%" })
            .color($r('app.color.text'))
        }.margin({right:"8%",left:"8%"})
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }){
          Text("手机号")
            .margin({left:"10%",top:"4%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))
          Text(this.cellphone)
            .height("7%")
            .margin({left:"40%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))
        }
        .margin({top:"5%"})
        .backgroundColor($r('app.color.background'))

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
          Divider()
            .strokeWidth(1)
            .lineCap(LineCapStyle.Square)
            .margin({ top: "3%" })
            .color($r('app.color.text'))
        }.margin({right:"8%",left:"8%"})
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }){
          Text("邮箱")
            .margin({left:"10%",top:"4%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))
          Text(this.email)
            .height("7%")
            .margin({left:"20%"})
            .fontSize(14)
            .fontColor($r('app.color.text'))
        }
        .margin({top:"5%"})
        .backgroundColor($r('app.color.background'))

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
          Divider()
            .strokeWidth(1)
            .lineCap(LineCapStyle.Square)
            .margin({ top: "3%" })
            .color($r('app.color.text'))
        }.margin({right:"8%",left:"8%"})

      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM])
    .title(this.TitleBuilder,{backgroundColor:$r('app.color.background')})
    .backgroundColor($r('app.color.background'))
    .backButtonIcon($r('app.media.button'))
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
    Text("个人资料")
      .fontColor($r('app.color.text'))
      .fontSize(20)
      .margin({top:"4.5%",left:"3%"})
      .fontWeight(FontWeight.Bold)
  }
}