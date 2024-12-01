import router from '@ohos.router';
import {CodeRequest} from "./backrequest/verifycode"


const  img:string = (router.getParams() as Record<string, string>)['id3'];
const  account:string = (router.getParams() as Record<string, string>)['id2'];
const  password:string = (router.getParams() as Record<string, string>)['id1'];

@Entry
@Component
struct Security {
  @State code:string = ""
  build() {
    Column() {
      Image($rawfile('login.jpg'))
        .syncLoad(true)
        .width(150)
        .margin({ top: 100 })
      Text('安全验证').fontSize(26)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10 })
      Image(img)
        .syncLoad(true)
        .width(250)
        .margin({ top: 20 })
      TextInput({ placeholder: '验证码' }).margin({ top: 20 })
        .onChange((value:string)=>{
          this.code = value
        })

      Button('确认').width(150).margin({ top: 20 })
        .onClick(() =>{
          CodeRequest(password,account,this.code.trim())
        })
    }.padding(20)

  }
}