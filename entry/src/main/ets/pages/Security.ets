import router from '@ohos.router';
import {CodeRequest} from "./backrequest/verifycode"


const  img:string = (router.getParams() as Record<string, string>)['id3'];
const  account:string = (router.getParams() as Record<string, string>)['id2'];
const  password:string = (router.getParams() as Record<string, string>)['id1'];

@Entry
@Component
struct Security {
  aboutToAppear(): void {
  }
  @State code:string = ""
  build() {
    RelativeContainer() {
      Column() {
        Image($r("app.media.alticon"))
          .syncLoad(true)
          .height(150)
        Text('安全验证').fontSize(25)
          .fontWeight(FontWeight.Bold)
          .margin({ top: "5%" })
        Image(img)
          .syncLoad(true)
          .width(200)
          .margin({ top: "8%" })
        TextInput({ placeholder: '验证码' }).margin({ top: "10%" })
          .onChange((value: string) => {
            this.code = value
          })
          .constraintSize({
            maxWidth:350
          })

        Button('确认').width(150).margin({ top: "10%" })
          .onClick(() => {
            CodeRequest(password, account, this.code.trim())
          })
      }.margin({ left: "8%", right: "8%" })
      .alignRules({center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }})
    }
  }
}