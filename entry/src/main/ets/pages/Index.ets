import {LoginRequest} from "./backrequest/Login"
import preferences from '@ohos.data.preferences'
@Entry
@Component
struct Index {
  @State account: string = "";
  @State password: string = ""
  build() {
    Column() {
      Image($rawfile('login.jpg'))
        .syncLoad(true)
        .width(150)
        .margin({ top: 100 })
      TextInput({ placeholder: '学工号' }).margin({ top: 20 })
        .onChange((value:string)=>{
          this.account = value
        })
      TextInput({ placeholder: '密码' }).type(InputType.Password).margin({ top: 20 })
        .onChange((value:string)=>{
          this.password = value
        })
      Button('登录').width(150).margin({ top: 20 })
        .onClick(() =>{
          LoginRequest(this.password.trim(),this.account.trim())
        })
    }.padding(20)
  }
}