import { webview } from "@kit.ArkWeb";
import { componentSnapshot } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import { BusinessError } from "@kit.BasicServicesKit";
import { systemShare,harmonyShare } from '@kit.ShareKit';
import { uniformTypeDescriptor as utd } from '@kit.ArkData';
import fileIo from "@ohos.file.fs";
import { common, ConfigurationConstant } from "@kit.AbilityKit";
import { fileUri } from "@kit.CoreFileKit";
import mediaQuery from '@ohos.mediaquery'
import {startBrowser} from "../utils/browser"
import { cookiesync } from "../backrequest/cookiemanager";
import { browserProxy } from "../utils/Browserproxy"
import { Pay } from "@cashier_alipay/cashiersdk";

interface mnv {
  accounts: string
  passwords: string
  url:string
  name:string
}

@Component
export struct webpage {
  @State sso: Array<ScriptItem> = []
  @State api: Array<ScriptItem> = []
  @State DarkMode:WebDarkMode = WebDarkMode.Auto
  @State dark:boolean = false
  @State darkbutton:string = ""
  @State URI:string = ""
  @State url:string = ""
  @State name:string = ""
  @State js: Array<ScriptItem> = []
  @Link @Watch("change") darkmode:boolean
  @Consume('pathInfos') pathStack: NavPathStack;
  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentColorMode: number =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  change(){
    if (this.darkmode) {
      this.dark = true
      this.DarkMode = WebDarkMode.On
      this.darkbutton = "whitebutton.png"
      this.menuItems[1].icon = "/resources/rawfile/whiterefresh.png"
      this.menuItems[2].icon  = "/resources/rawfile/whiteshare.png"
      this.menuItems[0].icon  = "/resources/rawfile/whitebrowser.png"
    } else {
      this.dark = false
      this.DarkMode = WebDarkMode.Off
      this.darkbutton = "blackbutton.svg"
      this.menuItems[1].icon = "/resources/rawfile/blackrefresh.png"
      this.menuItems[2].icon = "/resources/rawfile/blackshare.svg"
      this.menuItems[0].icon  = "/resources/rawfile/blackbrowser.png"
    }
  }
  onColorModeChange(){
    if (this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK){
      this.dark = true
      this.DarkMode = WebDarkMode.On
      this.darkbutton = "whitebutton.png"
      this.menuItems[1].icon = "/resources/rawfile/whiterefresh.png"
      this.menuItems[2].icon  = "/resources/rawfile/whiteshare.png"
      this.menuItems[0].icon  = "/resources/rawfile/whitebrowser.png"
    } else {
      this.dark = false
      this.DarkMode = WebDarkMode.Off
      this.darkbutton = "blackbutton.svg"
      this.menuItems[1].icon = "/resources/rawfile/blackrefresh.png"
      this.menuItems[2].icon = "/resources/rawfile/blackshare.svg"
      this.menuItems[0].icon  = "/resources/rawfile/blackbrowser.png"
    }
  }
  listener: mediaQuery.MediaQueryListener = mediaQuery.matchMediaSync('(dark-mode: true)')
  controller: webview.WebviewController = new webview.WebviewController();
  responseResource: WebResourceResponse = new WebResourceResponse();
  @State BrowserProxy: browserProxy = new browserProxy(this.controller)
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
      icon:"/resources/rawfile/blackbrowser.png",
      action:() =>{
        const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
        startBrowser(context,this.URI)
      },

    },
    {
      value:"refresh",
      icon:"/resources/rawfile/blackrefresh.png",
      action:() =>{
        this.controller.refresh()
      }
    },
    {
      value: "share",
      icon: "/resources/rawfile/blackshare.svg",
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
  onDarkMode(mediaQueryResult: mediaQuery.MediaQueryResult) {
    if (mediaQueryResult.matches as boolean) { // /系统为深色模式时为true，否则为false。
      this.dark = true
      this.DarkMode = WebDarkMode.On
      this.darkbutton = "whitebutton.png"
      this.menuItems[1].icon = "/resources/rawfile/whiterefresh.png"
      this.menuItems[2].icon  = "/resources/rawfile/whiteshare.png"
      this.menuItems[0].icon  = "/resources/rawfile/whitebrowser.png"
    } else {
      this.dark = false
      this.DarkMode = WebDarkMode.Off
      this.darkbutton = "blackbutton.svg"
      this.menuItems[1].icon = "/resources/rawfile/blackrefresh.png"
      this.menuItems[2].icon = "/resources/rawfile/blackshare.svg"
      this.menuItems[0].icon  = "/resources/rawfile/blackbrowser.png"
    }
  }
  aboutToAppear(): void {
    if (this.darkmode) {
      this.dark = true
      this.DarkMode = WebDarkMode.On
      this.darkbutton = "whitebutton.png"
      this.menuItems[1].icon = "/resources/rawfile/whiterefresh.png"
      this.menuItems[2].icon  = "/resources/rawfile/whiteshare.png"
      this.menuItems[0].icon  = "/resources/rawfile/whitebrowser.png"
    } else {
      this.dark = false
      this.DarkMode = WebDarkMode.Off
      this.darkbutton = "blackbutton.svg"
      this.menuItems[1].icon = "/resources/rawfile/blackrefresh.png"
      this.menuItems[2].icon = "/resources/rawfile/blackshare.svg"
      this.menuItems[0].icon  = "/resources/rawfile/blackbrowser.png"
    }
    this.listener.on('change', (mediaQueryResult: mediaQuery.MediaQueryResult) => {
      this.onDarkMode(mediaQueryResult)
    });
    let vsf: mnv = JSON.parse(JSON.stringify(this.pathStack.getParamByName("web")[0]))
    this.name = vsf.name
    this.url = vsf.url
    this.sso = [{
      script: "$(\"#un\").val('" + vsf.accounts + "');$(\"#pd\").val('" + vsf.passwords + "');login()",
      scriptRules: ["*"]
    }]
    this.api = [{
      script: "username.value='" + vsf.accounts + "';password.value='" + vsf.passwords +
        "';submit.disabled='';submit.click()",
      scriptRules: ["*"]
    }]
    if (vsf.url.includes("sso")){
      this.js = this.sso
    } else {
      this.js = this.api
    }
    cookiesync()
  }

  build() {
    NavDestination() {
      Column() {
        Web({
          src: this.url,
          controller: this.controller
        })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .darkMode(this.DarkMode)
          .forceDarkAccess(this.dark)
          .javaScriptOnDocumentEnd(this.js)
          .id("class1")
          .layoutMode(0)
          .javaScriptProxy({
            object: this.BrowserProxy,
            name: "__nativeWhistleProxy",
            methodList: ["issueCommand", "configApp", "debugOut"],
            controller: this.controller,
          })
          .cacheMode(CacheMode.Online)
          .onControllerAttached(() => {
            let userAgent =
              "Mozilla/ 5.0 (Linux; Android 10; EBG Build/ HUAWEIEBG; wv) AppleWebKit/ 537.36 (KHTML, like Gecko) Version/ 4.0 Chrome/ 88.0.4324.93 Mobile Safari/ 537.36 weishao(3.3.0.74633)";
            this.controller.setCustomUserAgent(userAgent);
          })
          .onLoadIntercept((event) => {
            let data = event.data;
            this.URI = data.getRequestUrl();
            let url:string = data.getRequestUrl();
            if (url.includes("sso")){
              this.js = this.sso
            } else {
              this.js = this.api
            }
            console.log(url)
            if (url.startsWith("weixin://")) {
              (getContext() as common.UIAbilityContext).openLink(url)
                .then(() => {
                }).catch((err: BusinessError) => {
              });
              return true;
            }
            if (url.startsWith("upwrp://")) {
              console.log("uppaywallet://uppay" + url.substring(20))
              let  newStr = "uppaywallet://uppay" + url.substring(20);
              (getContext() as common.UIAbilityContext).openLink(newStr)
                .then(() => {
                }).catch((err: BusinessError) => {
              });
              return true;
            }
            if (!(url.startsWith("http") || url.startsWith("https"))) {
              return false;
            }
            let result = new Pay().payInterceptorWithUrl(url, true, (result) => {
              let resultCode = result.get("resultCode");
              let returnUrl = result.get("returnUrl");
              this.controller.loadUrl(returnUrl);
            });
            return result;
          })
      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM])
    .title(this.TitleBuilder,{backgroundColor:$r('app.color.background')})
    .backgroundColor($r('app.color.background'))
    .backButtonIcon($r("app.media.button"))
    .menus(this.menuItems)
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
  @Builder
  TitleBuilder() {
    Text(this.name)
      .fontColor($r('app.color.text'))
      .fontSize(20)
      .margin({top:"4.5%",left:"3%"})
      .fontWeight(FontWeight.Bold)
  }
}