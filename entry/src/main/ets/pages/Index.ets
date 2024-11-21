import { router } from '@kit.ArkUI';

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
        .onSubmit((EnterKeyType)=>{
          console.info(EnterKeyType+'输入法回车键的类型值')
        })
      TextInput({ placeholder: '密码' }).type(InputType.Password).margin({ top: 20 })
        .onSubmit((EnterKeyType)=>{
          console.info(EnterKeyType+'输入法回车键的类型值')
        })
      Button('登录').width(150).margin({ top: 20 })
        .onClick(() =>{
          router.pushUrl({
            url: 'pages/Navigators'
            //返回账密（待开发）
          })
        })
    }.padding(20)
  }
}