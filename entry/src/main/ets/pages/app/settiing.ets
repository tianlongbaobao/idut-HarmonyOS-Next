import router from '@ohos.router';
import dataPreferences from '@ohos.data.preferences';
import {updatedata} from "../backrequest/Update"

let context = getContext(this)
@Component
export struct pagesettings {
  pathStack: NavPathStack = new NavPathStack();
  build() {
    NavDestination() {
      Column() {
        Image($r('app.media.start'))
          .syncLoad(true)
          .width(100)
          .margin({ top: "30%" })
        Text("i大工社区版").margin({ top: "5%" })
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
        Text("版本号:5.0.0").margin({ top: "5%" })
          .fontSize(15)
        Hyperlink('https://github.com/tianlongbaobao/idut-HarmonyOS-Next', 'Github源码') {
        }
        .color(Color.Blue)
        .margin({ top: "5%" })
        Hyperlink('https://luzhiyidut.cn/', '作者主页(校园网环境无法访问)') {
        }
        .color(Color.Blue)
        .margin({ top: "5%" })
        Button("检查更新")
          .margin({ top: "8%" })
          .backgroundColor("blue")
          .onClick(() => {
            updatedata()
          })
          .width('80%')
        Button("退出登录")
          .margin({ top: "8%" })
          .backgroundColor("red")
          .onClick(() => {
            dataPreferences.getPreferences(context, "information").then(preferences=>{
              preferences.delete("account")
              preferences.delete("password")
              preferences.delete("data")
              preferences.delete("photo")
              preferences.flush()
              router.pushUrl({
                url: 'pages/Index',
              })
            }).catch((err:Error)=>{

            })

          })
          .width('80%')
        Text("此与i大工官方版无关，由校内独立开发者开发，方便在鸿蒙Next上使用相关服务，仅供交流！").margin({top:"80%",left:"10%",right:"10%"})
          .fontSize(13)

      }
    }.title("设置")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}