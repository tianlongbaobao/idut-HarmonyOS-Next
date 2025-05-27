import router from '@ohos.router';
import dataPreferences from '@ohos.data.preferences';
import {updatedata} from "../backrequest/Update"
import { UpdateDialog } from './Update';
import axios, { AxiosError, AxiosResponse } from '@ohos/axios';
import { GitHubRelease } from '../utils/githubbean';
import { http } from '@kit.NetworkKit';
import { bundleManager } from '@kit.AbilityKit';

let context = getContext(this)
@Component
export struct pagesettings {
  @State name:string = ""
  @State body:string = ""
  @State version:string = ""
  @State downurl:string = ""
  @State release:boolean = false
  @State name_re:string = ""
  @State body_re:string = ""
  @State version_re:string = ""
  @State downurl_re:string = ""
  @State release_re:boolean = false
  pathStack: NavPathStack = new NavPathStack();
  commonSettingDialogController: CustomDialogController = new CustomDialogController({
    builder: UpdateDialog({
      name:this.name,
      body:this.body,
      download:this.downurl,
      versionname:this.version,
      release:this.release,
      name_re:this.name_re,
      body_re:this.body_re,
      download_re:this.downurl_re,
      release_re:this.release_re
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    autoCancel: false,
    cornerRadius:20,

  });
  aboutToAppear(): void {
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT
    bundleManager.getBundleInfoForSelf(bundleFlags).then((data) => {
      this.version = data.versionName
    })
  }
  build() {
    NavDestination() {
      Scroll(){
      Column() {
        Image($r('app.media.start'))
          .syncLoad(true)
          .width(100)
          .margin({ top: "15%" })
        Text("i大工社区版").margin({ top: "5%" })
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r("app.color.text"))
        Text("版本号:"+this.version).margin({ top: "5%" })
          .fontSize(15)
          .fontColor($r("app.color.text"))
        Text("ArkTS版").margin({ top: "5%" })
          .fontSize(15)
          .fontColor($r("app.color.text"))
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
            const httpRequest = http.createHttp();
            let promises = httpRequest.request(
              "https://api.github.com/repos/tianlongbaobao/idut-HarmonyOS-Next/releases?per_page=1",
              {
                method: http.RequestMethod.GET,
                connectTimeout: 60000,
                readTimeout: 60000,
              });
            promises.then((res) => {
              let details:GitHubRelease[] = JSON.parse(res.result.toString())
              this.name = details[0].name
              this.body = details[0].body
              this.downurl = details[0].assets[0].browser_download_url
              this.release = details[0].prerelease
              let cda = httpRequest.request(
                "https://api.github.com/repos/tianlongbaobao/idut-HarmonyOS-Next/releases/latest",
                {
                  method: http.RequestMethod.GET,
                  connectTimeout: 60000,
                  readTimeout: 60000,
                }
              )
              cda.then((res)=>{
                let details:GitHubRelease = JSON.parse(res.result.toString())
                this.name_re = details.name
                this.body_re = details.body
                this.downurl_re = details.assets[0].browser_download_url
                this.release_re = details.prerelease
                this.commonSettingDialogController.open()
              })

            }).catch(() => {
              AlertDialog.show(
                {
                  message: '连接GitHub失败',
                  autoCancel: false,
                  alignment: DialogAlignment.Bottom,
                  gridCount: 5,
                  offset: { dx: 0, dy: -20 },
                  primaryButton: {
                    value: '确认',
                    action: () => {
                    },
                    fontColor:"red"
                  },
                }
              )
            })
          })
          .width('80%')
        Button("退出登录")
          .margin({ top: "8%" })
          .backgroundColor("red")
          .onClick(() => {
            dataPreferences.getPreferences(context, "information").then(preferences => {
              preferences.delete("account")
              preferences.delete("password")
              preferences.delete("data")
              preferences.delete("photo")
              preferences.delete("gallery")
              preferences.delete("nowdata")
              preferences.delete("door")
              preferences.delete("pcmode")
              preferences.delete("nologin")
              preferences.flush()
              router.pushUrl({
                url: 'pages/Index',
              })
            }).catch((err: Error) => {

            })

          })
          .width('80%')

      }
      .width("100%")
      .backgroundColor($r("app.color.background"))
    }
    }
    .expandSafeArea([SafeAreaType.SYSTEM])
    .title("设置")
    .backgroundColor($r("app.color.background"))
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}