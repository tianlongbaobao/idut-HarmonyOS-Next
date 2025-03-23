import { webview } from "@kit.ArkWeb";
import { componentSnapshot } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import { BusinessError } from "@kit.BasicServicesKit";
import { systemShare,harmonyShare } from '@kit.ShareKit';
import { uniformTypeDescriptor as utd } from '@kit.ArkData';
import fileIo from "@ohos.file.fs";
import { common } from "@kit.AbilityKit";
import { fileUri } from "@kit.CoreFileKit";
import {startBrowser} from "../utils/browser"
import { cookiesync } from "../backrequest/cookiemanager";

interface mnv {
  accounts:string
  passwords:string
}
@Component
export struct pagebooklist {
  @State sso:Array<ScriptItem> = []
  @State api:Array<ScriptItem> = []
  @State URI:string = ""
  @Consume('pathInfos') pathStack: NavPathStack;
  private immersiveCallback(sharableTarget: harmonyShare.SharableTarget) {
    componentSnapshot.get("class1", {scale : 2, waitUntilRenderFinished : true})
      .then((pixmap: image.PixelMap) => {
        let imagePackerApi = image.createImagePacker();
        let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 98 };
        let context = getContext(this);
        let cacheDir:string = context.cacheDir;
        let dstUri:string = cacheDir + '/IMG_temp.jpg'; // 保存文件uri
        let file: fs.File = fs.openSync(dstUri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        imagePackerApi.packToFile(pixmap, file.fd, packOpts, (err: BusinessError) => {
          if (err) {
            console.error(`Failed to pack the image to file.code ${err.code},message is ${err.message}`);
          } else {
            console.info('Succeeded in packing the image to file.');
            imagePackerApi.release((err: BusinessError) => {
              if (err) {
                console.error(`Failed to release the image source instance.code ${err.code},message is ${err.message}`);
              } else {
                console.info('Succeeded in releasing the image source instance.');
                fileIo.close(file.fd);
                let utdTypeId = utd.getUniformDataTypeByFilenameExtension('.jpg', utd.UniformDataType.IMAGE);
                let shareData: systemShare.SharedData = new systemShare.SharedData({
                  utd: utdTypeId,
                  uri: fileUri.getUriFromPath(dstUri),
                  title: '我的课表', // 不传title字段时,显示图片文件名
                  description: '我的课表', // 不传description字段时,显示图片大小
                  // thumbnail: new Uint8Array() // 优先使用传递的缩略图预览  不传则默认使用原图做预览图
                });
                // 进行分享面板显示
                sharableTarget.share(shareData);
              }
            })
          }
        })
      }).catch((err:Error) => {
      console.log("error: " + err)
    })
  }
  private immersiveListening() {
    harmonyShare.on('knockShare', this.immersiveCallback);
  }

  private immersiveDisablingListening() {
    harmonyShare.off('knockShare', this.immersiveCallback);
  }

  private menuItems: Array<NavigationMenuItem> = [
    {
      value:"browser",
      icon:"/resources/rawfile/browser.png",
      action:() =>{
        const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
        startBrowser(context,this.URI)
      }
    },
    {
      value:"refresh",
      icon:"/resources/rawfile/refresh.svg",
      action:() =>{
        this.controller.refresh()
      }
    },
    {
      value: "share",
      icon: "/resources/rawfile/share.svg",
      action: async () => {
        componentSnapshot.get("class1", {scale : 2, waitUntilRenderFinished : true})
          .then((pixmap: image.PixelMap) => {
            let imagePackerApi = image.createImagePacker();
            let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 98 };
            let context = getContext(this);
            let cacheDir:string = context.cacheDir;
            let dstUri:string = cacheDir + '/IMG_temp.jpg'; // 保存文件uri
            let file: fs.File = fs.openSync(dstUri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
            imagePackerApi.packToFile(pixmap, file.fd, packOpts, (err: BusinessError) => {
              if (err) {
                console.error(`Failed to pack the image to file.code ${err.code},message is ${err.message}`);
              } else {
                console.info('Succeeded in packing the image to file.');
                imagePackerApi.release((err: BusinessError) => {
                  if (err) {
                    console.error(`Failed to release the image source instance.code ${err.code},message is ${err.message}`);
                  } else {
                    console.info('Succeeded in releasing the image source instance.');
                    fileIo.close(file.fd);
                    let utdTypeId = utd.getUniformDataTypeByFilenameExtension('.jpg', utd.UniformDataType.IMAGE);
                    let shareData: systemShare.SharedData = new systemShare.SharedData({
                      utd: utdTypeId,
                      uri: fileUri.getUriFromPath(dstUri),
                      title: '我的课表', // 不传title字段时,显示图片文件名
                      description: '我的课表', // 不传description字段时,显示图片大小
                      // thumbnail: new Uint8Array() // 优先使用传递的缩略图预览  不传则默认使用原图做预览图
                    });
                    // 进行分享面板显示
                    let controller: systemShare.ShareController = new systemShare.ShareController(shareData);
                    let context = getContext(this) as common.UIAbilityContext;
                    controller.show(context, {
                      selectionMode: systemShare.SelectionMode.SINGLE,
                      previewMode: systemShare.SharePreviewMode.DETAIL,
                    }).then(() => {
                      console.info('ShareController show success.');
                    }).catch((error: BusinessError) => {
                      console.error(`ShareController show error. code: ${error.code}, message: ${error.message}`);
                    });
                  }
                })
              }
            })
          }).catch((err:Error) => {
          console.log("error: " + err)
        })
      }
    }
  ]

  controller: webview.WebviewController = new webview.WebviewController()
  aboutToAppear(): void {
    let vsf:mnv =JSON.parse(JSON.stringify(this.pathStack.getParamByName('图书借阅')[0]))
    this.sso = [{ script: "$(\"#un\").val('" + vsf.accounts + "');$(\"#pd\").val('" + vsf.passwords + "');login()", scriptRules: ["*"] }]
    this.api = [{ script: "username.value='" + vsf.accounts + "';password.value='" + vsf.passwords + "';submit.disabled='';submit.click()", scriptRules: ["*"] }]
    cookiesync()
    if (canIUse('SystemCapability.Collaboration.HarmonyShare')) {
      this.immersiveListening();
    }
    let context = getContext(this);
    context.eventHub.on('onBackGround', this.onBackGround);
  }
  onPageHide(): void {
    let context = getContext(this);
    context.eventHub.emit('onBackGround');
  }

  aboutToDisappear(): void {
    if (canIUse('SystemCapability.Collaboration.HarmonyShare')) {
      this.immersiveDisablingListening();
    }
    let context = getContext(this);
    context.eventHub.on('onBackGround', this.onBackGround);
  }

  private onBackGround() {
    if (canIUse('SystemCapability.Collaboration.HarmonyShare')) {
      this.immersiveDisablingListening();
    }
  }
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://sso.dlut.edu.cn/cas/login?service=https%3A%2F%2Fopac.lib.dlut.edu.cn%3A443%2Fmeta-local%2Fopac%2Fcas%2Frosetta&from=rj", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(this.api)
          .onControllerAttached(() => {
            let userAgent =
              "Mozilla/ 5.0 (Linux; Android 10; EBG Build/ HUAWEIEBG; wv) AppleWebKit/ 537.36 (KHTML, like Gecko) Version/ 4.0 Chrome/ 88.0.4324.93 Mobile Safari/ 537.36 weishao(3.3.0.74633)";
            this.controller.setCustomUserAgent(userAgent);
          })
          .onLoadIntercept((event) => {
            let data = event.data;
            this.URI = data.getRequestUrl();
            return false
          })
      }
    }.title("图书借阅")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .menus(this.menuItems)
  }

}