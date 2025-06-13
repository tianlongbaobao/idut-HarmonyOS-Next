import { webview } from "@kit.ArkWeb";
import { componentSnapshot } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import { BusinessError } from "@kit.BasicServicesKit";
import { systemShare,harmonyShare } from '@kit.ShareKit';
import { uniformTypeDescriptor as utd } from '@kit.ArkData';
import fileIo from "@ohos.file.fs";
import { common, ConfigurationConstant, Want } from "@kit.AbilityKit";
import { fileUri } from "@kit.CoreFileKit";
import mediaQuery from '@ohos.mediaquery'
import {UPPayment,UPPayResult,UPPayResultCallback} from "libuppayment"
import { cookiesync } from "../backrequest/cookiemanager";
import { browserProxy } from "../utils/Browserproxy"
import { util } from "@kit.ArkTS";
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
  @State webagent:string =  "Mozilla/ 5.0 (Linux; Android 10; EBG Build/ HUAWEIEBG; wv) AppleWebKit/ 537.36 (KHTML, like Gecko) Version/ 4.0 Chrome/ 88.0.4324.93 Mobile Safari/ 537.36 weishao(3.3.0.74633)"
  @State dark:boolean = false
  @State URI:string = ""
  @State url:string = ""
  @State name:string = "";
  @State js: Array<ScriptItem> = []
  @Link @Watch("change") darkmode:boolean
  @Link vsf:mnv
  @Link @Watch("useragents")useragent:boolean;
  @State vpn:Array<ScriptItem> = [{script:"document.getElementById('cas-login').click()",scriptRules:["*"]}]
  @Consume('pathInfos') pathStack: NavPathStack;
  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentColorMode: number =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  @State progressvalue:number = 0
  useragents(){
    if (this.useragent) {
        this.webagent = "Mozilla/5.0 (PC; OpenHarmony 5.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36  ArkWeb/4.1.6.1"
      
    }else {
      this.webagent = "Mozilla/ 5.0 (Linux; Android 10; EBG Build/ HUAWEIEBG; wv) AppleWebKit/ 537.36 (KHTML, like Gecko) Version/ 4.0 Chrome/ 88.0.4324.93 Mobile Safari/ 537.36 weishao(3.3.0.74633)"
    }
    this.controller.refresh()
  }
  change(){
    if (this.darkmode) {
      this.dark = true
      this.DarkMode = WebDarkMode.On
    } else {
      this.dark = false
      this.DarkMode = WebDarkMode.Off
    }
  }
  onColorModeChange(){
    if (this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK){
      this.dark = true
      this.DarkMode = WebDarkMode.On
    } else {
      this.dark = false
      this.DarkMode = WebDarkMode.Off
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
                  title: this.name, // 不传title字段时,显示图片文件名
                  description: this.name, // 不传description字段时,显示图片大小
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
      icon:$r("app.media.browser"),
      action:() =>{
        let context = getContext(this) as common.UIAbilityContext;
        let want: Want = {
          action: "ohos.want.action.viewData",
          bundleName: 'com.huawei.hmos.browser',
          abilityName: 'MainAbility',
          uri: this.URI,
        };
        context.startAbility(want)
      },

    },
    {
      value:"refresh",
      icon:$r("app.media.refresh"),
      action:() =>{
        this.controller.refresh()
      }
    },
    {
      value: "share",
      icon: $r("app.media.share"),
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
                      title: this.name, // 不传title字段时,显示图片文件名
                      description: this.name, // 不传description字段时,显示图片大小
                      thumbnailUri:fileUri.getUriFromPath(dstUri)
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
    } else {
      this.dark = false
      this.DarkMode = WebDarkMode.Off
    }
  }
  aboutToAppear(): void {
    if (this.useragent) {
      if (this.name!="玉兰卡") {
        this.webagent = "Mozilla/5.0 (PC; OpenHarmony 5.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36  ArkWeb/4.1.6.1"
      }

    }else {
      this.webagent = "Mozilla/ 5.0 (Linux; Android 10; EBG Build/ HUAWEIEBG; wv) AppleWebKit/ 537.36 (KHTML, like Gecko) Version/ 4.0 Chrome/ 88.0.4324.93 Mobile Safari/ 537.36 weishao(3.3.0.74633)"
    }
    if (canIUse('SystemCapability.Collaboration.HarmonyShare')) {
      this.immersiveListening();
    }
    let context = getContext(this);
    context.eventHub.on('onBackGround', this.onBackGround);
    if (this.darkmode) {
      this.dark = true
      this.DarkMode = WebDarkMode.On

    } else {
      this.dark = false
      this.DarkMode = WebDarkMode.Off
    }
    this.listener.on('change', (mediaQueryResult: mediaQuery.MediaQueryResult) => {
      this.onDarkMode(mediaQueryResult)
    });

    this.name = this.vsf.name
    this.url = this.vsf.url
    this.sso = [{
      script: "$(\"#un\").val('" + this.vsf.accounts + "');$(\"#pd\").val('" + this.vsf.passwords + "');login()",
      scriptRules: ["*"]
    }]
    this.api = [{
      script: "username.value='" + this.vsf.accounts + "';password.value='" + this.vsf.passwords +
        "';submit.disabled='';submit.click()",
      scriptRules: ["*"]
    }]
    if (this.vsf.url.includes("sso.dlut.edu.cn/cas/login?service=") || this.vsf.url.includes("webvpn.dlut.edu.cn%2Flogin%3Fcas_login%3Dtrue")){
      this.js = this.sso
    } else {
      this.js = this.api
    }
    cookiesync()
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
        if (this.progressvalue<100) {
          Progress({ value: 0, total: 100, type: ProgressType.Linear })
            .value(this.progressvalue)
        }
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
          .password(false)
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
            this.controller.setCustomUserAgent(this.webagent);
          })
          .onProgressChange((event) => {
            if (event) {
              this.progressvalue = event.newProgress
            }
          })
          .onLoadIntercept((event) => {
            let data = event.data;
            let url:string = data.getRequestUrl();
            if (url.startsWith("https://card.m.dlut.edu.cn/cardpay/autoRecharge?")){
              AlertDialog.show(
                {
                  message: '自动充值请打开微信小程序i大工',
                  autoCancel: false,
                  alignment: DialogAlignment.Bottom,
                  gridCount: 5,
                  offset: { dx: 0, dy: -20 },
                  primaryButton: {
                    value: '确认',
                    action: () => {
                    },
                    fontColor: "red"
                  },
                  backgroundColor: $r('app.color.background')
                }
              )
            }
            if (url.includes("sso.dlut.edu.cn/cas/login?service=") || url.includes("webvpn.dlut.edu.cn%2Flogin%3Fcas_login%3Dtrue")){
              this.js = this.sso
            } else if (url.includes("webvpn.dlut.edu.cn/login")) {
              this.js = this.vpn
            }
            else if (url.includes("api.m.dlut.edu.cn/login?client_id=")){
              this.js = this.api
            }
            this.URI = url
            if (url.startsWith("weixin://")) {
              (getContext() as common.UIAbilityContext).openLink(url)
                .then(() => {
                }).catch((err: BusinessError) => {
              });
              return true;
            }
            if (url.startsWith("upwrp://")) {
              const  match  = url.match(/paydata=([^&]*)/);
              let tn:string = match ? match[1] : ""
              const helper = new util.Base64Helper()
              const  textDecoder: util.TextDecoder = util.TextDecoder.create();
              const tn_s:string = textDecoder.decodeToString(helper.decodeSync(tn))
              const matches = tn_s.match(/tn=(\d+)/);
              const tnValue = matches ? matches[1] : null;
              let context = getContext() as common.UIAbilityContext;
              let upPayment = new UPPayment();
              upPayment.startPay(tnValue,"00",'idut',context,'04')
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
    .title(this.name)
    .backgroundColor($r('app.color.background'))
    .menus(this.menuItems)
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.clear()
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}