import { webview } from "@kit.ArkWeb";
import router from '@ohos.router';
import window from '@ohos.window';
import { Pay } from '@cashier_alipay/cashiersdk'
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { PermissionsUtil } from './utils/permission';
import dataPreferences from '@ohos.data.preferences';

let context = getContext(this)
const  account:string = (router.getParams() as Record<string, string>)['id2'];
const  password:string = (router.getParams() as Record<string, string>)['id1'];
const  api: Array<ScriptItem> = [{ script: "username.value='" + account + "';password.value='" + password + "';submit.disabled='';submit.click()", scriptRules: ["*"] }]
const  sso: Array<ScriptItem> = [{ script: "$(\"#un\").val('" + account + "');$(\"#pd\").val('" + password + "');login()", scriptRules: ["*"] }]
const  vpn: Array<ScriptItem> = [{ script: "document.getElementById('cas-login').click()", scriptRules: ["*"] }]

@Entry
@Component
struct  Navigators {

  pathStack: NavPathStack = new NavPathStack();
  private setImmersive() {
    window.getLastWindow(getContext()).then(win => {
      win.setWindowLayoutFullScreen(false);
      let area = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      let height = area.topRect.height;
      let vpheight = px2vp(height);
      AppStorage.setOrCreate('topHeight', vpheight);
      win.setWindowSystemBarProperties({ statusBarContentColor: "#000000" }); // 设置状态栏字体颜色
    });
  }
  @Builder
  PageMap(name: string) {
    if (name === "体质测评") {
      pageemail()
    } else if (name === "我的课表") {
      pageclass()
    } else if (name === "图书馆预约") {
      pagelib()
    } else if (name === "考试安排") {
      pagetest()
    } else if (name === "玉兰卡") {
      pagecard()
    } else if (name === "校车定位") {
      pagecar()
    }  else if (name === "网络自助") {
      pageweb()
    } else if (name === "体育场馆预定") {
      pagesports()
    } else if (name === "读者入馆培训") {
      pageout()
    } else if (name === "空闲教室") {
      pageclassroom()
    } else if (name === "校园地图") {
      pagemap()
    }  else if (name === "教师主页") {
      pageteacher()
    } else if (name === "资源预约") {
      pagebooking()
    } else if (name === "多媒体教室管理") {
      pagemedia()
    } else if (name === "心理测评") {
      pagepys()
    } else if (name === "图书馆系统") {
      pagelibma()
    } else if (name === "活动报名") {
      pageticket()
    }else if (name === "校园网测速") {
      pagespeed()
    }else if (name === "教务主页") {
      pageteach()
    }else if (name === "作者信息") {
      pageinformation()
    }else if (name === "教务主页") {
      pageteach()
    }else if (name === "设置") {
      pagesettings()
    }
  }
  build() {

    Navigation(this.pathStack) {
      List({ space: 7 }) {
        ListItem() {
          Text("1.生活服务").margin({left:20,top:15,bottom:10})
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        ListItem() {
          Row() {
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/00/08/ynZM2VlLGmmAb9t7AAAj67t6MTY8968130")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "玉兰卡" })
              })
              .width(80).height(80).backgroundColor("white")
              Text("玉兰卡").margin({ top: 5 })
            }.margin({left:20})
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/02/31/ynZM2V9Mt0SAE0SFAABPvJJ1-9A273.png")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "校车定位" })
              })
              .width(80).height(80).backgroundColor("white")
              Text("校车定位").margin({ top: 5 })
            }.margin({left:20})
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/00/01/ynZM2VkVANOAaHFwAAAhBvGkHdU6252034")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "校园地图" })
              })
              .width(80).height(80).backgroundColor("white")
              Text("校园地图").margin({ top: 5 })
            }.margin({left:20})
          }
        }


        ListItem() {
          Text("2.校园生活").margin({left:20,top:15,bottom:10})
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        ListItem() {
          Row()
          {
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/01/25/ynZM2VwAqXuAfK3HAAAQNK-baPo920.png")
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "体质测评" })
              })
              .width(80).height(80).backgroundColor("white")
              Text("体质测评").margin({ top: 5 })
            }.margin({left:20})
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/02/03/ynZM2V8hIHuAakGbAABHogF7lj8252.png")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "图书馆预约" })
              })
              .width(80).height(80).backgroundColor("white")
              Text("图书馆预约").margin({ top: 5 })
            }.margin({left:20})
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/02/30/ynZM2V9Mj2GAXxRpAAAZEquDC1U035.png")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "体育场馆预定" })
              })
              .width(80).height(80).backgroundColor("white")
              Text("体育场馆预定").margin({ top: 5 })
            }.margin({left:15})
          }
        }

        ListItem() {
          Row() {
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/02/A1/ynZM2WBYEe-ALSxiAAA-gtcEwFw355.png")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "心理测评" })
              })
              .width(80).height(80).backgroundColor("white")

              Text("心理测评").margin({ top: 5 })
            }.margin({ left: 20 })
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://ehall.dlut.edu.cn/fp/uploadfiles/uw_service/2019/06/20/1561004260430.png")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "读者入馆培训"})
              })
              .width(80).height(80).backgroundColor("white")

              Text("读者入馆培训").margin({ top: 5 })
            }.margin({ left: 10 })
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/01/0B/ynZM2VuPucOAG2EUAAAijVD0PLU792.png")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "活动报名" })
              })
              .width(80).height(80).backgroundColor("white")

              Text("活动报名").margin({ top: 5 })
            }.margin({ left: 18 })
          }
        }
        ListItem() {
          Text("3.教学与资源").margin({left:20,top:15,bottom:10})
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        ListItem() {
          Row() {
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/00/01/ynZM2VkU-IiAPBCnAAAamt9Ip481490708")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "我的课表" })
              })
              .width(80).height(80).backgroundColor("white")
              Text("我的课表").margin({ top: 5 })
            }.margin({ left: 22 })
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/00/7B/ynZM2Vn7QI6AOQVDAAAZa-V0lMA6705172")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "考试安排"})
              })
              .width(80).height(80).backgroundColor("white")

              Text("考试安排").margin({ top: 5 })
            }.margin({ left: 20 })
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/00/08/ynZM2VkeVL2AGt4BAAAYlzvpSVo6550599")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "空闲教室" })
              })
              .width(80).height(80).backgroundColor("white")

              Text("空闲教室").margin({ top: 5 })
            }.margin({ left: 20 })
          }
        }
        ListItem() {
          Row() {
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/02/83/ynZM2V_N3euAAn5PAAAZ46zJWmQ263.png")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "资源预约" })
              })
              .width(80).height(80).backgroundColor("white")
              Text("资源预约").margin({ top: 5 })
            }.margin({ left: 22 })
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/03/4A/ynZM2WGOE1KAbZSmAAAKzt9dyGg960.png")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "多媒体教室管理"})
              })
              .width(80).height(80).backgroundColor("white")

              Text("多媒体教室管理").margin({ top: 5 })
            }.margin({ left: 8 })
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/00/01/ynZM2VkU_9iAdpatAAAcFW_puS88241415")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "教师主页"})
              })
              .width(80).height(80).backgroundColor("white")

              Text("教师主页").margin({ top: 5 })
            }.margin({ left: 0 })
          }
        }
        ListItem() {
          Row() {
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/00/08/ynZM2VkeVL2AGt4BAAAYlzvpSVo6550599")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "教务主页" })
              })
              .width(80).height(80).backgroundColor("white")
              Text("教务主页").margin({ top: 5 })
            }.margin({ left: 20 })

          }
        }
        ListItem() {
          Text("4.网信服务").margin({left:20,top:15,bottom:10})
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }

        ListItem() {
          Row() {
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/00/5B/ynZM2VmyW9mAGzv_AAAXfJXYcgw8899921")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "网络自助" })
              })
              .width(80).height(80).backgroundColor("white")
              Text("网络自助").margin({ top: 5 })
            }.margin({ left: 20 })
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image("https://store.m.dlut.edu.cn/group1/M00/01/45/ynZM2Vzjo7-AEl7QAAAv69n_AZs158.png")
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "校园网测速"})
              })
              .width(80).height(80).backgroundColor("white")
              Text("校园网测速").margin({ top: 5 })
            }.margin({ left: 18 })
          }
        }
        ListItem() {
          Text("5.设置").margin({left:20,top:15,bottom:10})
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        ListItem() {
          Row() {
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image($rawfile("settings.png"))
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "设置"})
              })
              .width(80).height(80).backgroundColor("white")

              Text("设置").margin({ top: 5 })
            }.margin({ left: 18 })
            Column() {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image($rawfile("contact.png"))
                  .borderRadius(35)
              }
              .onClick(() => {
                this.pathStack.pushPath({ name: "作者信息"})
              })
              .width(80).height(80).backgroundColor("white")

              Text("联系我们").margin({ top: 5 })
            }.margin({ left: 20 })
          }
        }
      }
      .listDirection(Axis.Vertical)
      .backgroundColor("white").padding(20)
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.PageMap)
  }
  onPageShow() {
    this.setImmersive();
  }
}

// 体质测评
@Component
export struct pageemail {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://webvpn.dlut.edu.cn/http-8081/57787a7876706e323032336b657940242a485056ad52cb00fc19b469c2e3/cas/mobileCheckJump?from=rj&filter=app", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
      }
    }.title("体质测评")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}
// 体质测评
@Component
export struct pagelibma {
  pathStack: NavPathStack = new NavPathStack();
  scroller: Scroller = new Scroller()
  contentScroller: Scroller = new Scroller()
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://webvpn.dlut.edu.cn/https/57787a7876706e323032336b657940247708031bb20f9a4ce448f62d85f580230796e3c6/meta-local/opac/cas/rosetta?filter=app&from=rj", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
      }
    }.title("图书馆系统")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

// 我的课表
@Component
export struct pageclass {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://api.m.dlut.edu.cn/oauth/authorize?client_id=9qXqHnRQuhhViycC&redirect_uri=https%3a%2f%2flightapp.m.dlut.edu.cn%2fcheck%2fcourseschedule&response_type=code&scope=base_api&state=dlut", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(api)
      }
    }.title("我的课表")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

// 图书馆预约
@Component
export struct pagelib {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://sso.dlut.edu.cn/cas/login?from=rj&service=https%3A%2F%2Fsso.dlut.edu.cn%2Fcas%2Flogin%3Fservice%3Dhttp%253A%252F%252Fseat.lib.dlut.edu.cn%252Fyanxiujian%252Fclient%252Flogin.php%253Fredirect%253Dindex.php", controller: this.controller })
          .javaScriptAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(sso)
      }
    }.title("图书馆预约")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

// 考试安排
@Component
export struct pagetest {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://api.m.dlut.edu.cn/oauth/authorize?client_id=9qXqHnRQuhhViycC&redirect_uri=https%3a%2f%2flightapp.m.dlut.edu.cn%2fcheck%2fexamplan&response_type=code&scope=base_api&state=dlut", controller: this.controller })
          .javaScriptAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(api)
      }
    }.title("考试安排")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

// 玉兰卡
@Component
export struct pagecard {
  private TAG: string = "permissionPage";

  private showToast(content: string){
    try {
      promptAction.showToast({
        message: content,
        duration: 2000
      });
    } catch (error) {
      let message = (error as BusinessError).message
      let code = (error as BusinessError).code
      console.error(this.TAG, `showToast args error code is ${code}, message is ${message}`);
    };
  }

  onClickCamera = async ()=>{
    console.log(this.TAG, " onClickCamera");
    let isUserGrant: boolean = await PermissionsUtil.requestCameraPermission();
    if(isUserGrant){
      this.showToast("用户同意授权");
    }else{
      this.showToast("用户拒绝授权");
    }
  }
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController();
  responseResource: WebResourceResponse = new WebResourceResponse();
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://api.m.dlut.edu.cn/oauth/authorize?client_id=19b32196decf419a&redirect_uri=https%3A%2F%2Fcard.m.dlut.edu.cn%2Fhomerj%2FopenRjOAuthPage&response_type=code&scope=base_api&state=weishao", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(api)
          .onPageBegin((event) => {
            if (event) {
              console.log(this.TAG, " onClickCamera");
              PermissionsUtil.requestCameraPermission()
                .then((isUserGrant)=> {
                  if (isUserGrant) {
                  } else {
                    this.showToast("用户拒绝授权");
                  }
                })
            }
          })
          .onControllerAttached(() => {
            console.log("onControllerAttached");
            try {
              let userAgent = "Mozilla/ 5.0 (Linux; Android 10; EBG Build/ HUAWEIEBG; wv) AppleWebKit/ 537.36 (KHTML, like Gecko) Version/ 4.0 Chrome/ 88.0.4324.93 Mobile Safari/ 537.36 weishao(3.3.0.74633)";
              this.controller.setCustomUserAgent(userAgent);
            } catch (error) {
            }
          })
          .onLoadIntercept((event) => {
            let data = event.data;
            let url = data.getRequestUrl();
            if (url.startsWith("weixin://")) {
              (getContext() as common.UIAbilityContext).openLink(url)
                .then(() => {
                  console.log('openLink success');
                }).catch((err: BusinessError) => {
                console.error('openLink failed, err:' + JSON.stringify(err));
              });
              return true;
            }
            if (!(url.startsWith("http") || url.startsWith("https"))) {
              return false;
            }
            console.log(`alipay: url: ${url}`);
            let result = new Pay().payInterceptorWithUrl(url, true, (result) => {
              let resultCode = result.get("resultCode");
              let returnUrl = result.get("returnUrl");
              console.log(`resultCode: ${resultCode}, returnUrl: ${returnUrl}`);
              this.controller.loadUrl(returnUrl);
            });
            return result;
          })
      }
    }.title("玉兰卡")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

// 公共资源预约
@Component
export struct pagecar {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://webvpn.dlut.edu.cn/http/57787a7876706e323032336b6579402468171111e80a9c40e448f62d85f580232d28ff0e/dlutBus/ssoAuth?from=rj&filter=app", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(api)
      }
    }.title("校车定位")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}



// 校园网自助服务
@Component
export struct pageweb {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://api.m.dlut.edu.cn/oauth/authorize?client_id=9qXqHnRQuhhViycC&redirect_uri=https%3a%2f%2flightapp.m.dlut.edu.cn%2fcheck%2fnethelp&response_type=code&scope=base_api&state=dlut", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(api)
      }
    }.title("网络自助")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}




// 体育场馆预定
@Component
export struct pagesports {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://webvpn.dlut.edu.cn/http/57787a7876706e323032336b65794024791c0f55e81a9049e448f62d85f58023f6c217c3/api/login/login?from=rj&filter=app", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
      }
    }.title("体育场馆预定")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

// 校外人员预约
@Component
export struct pageout {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://webvpn.dlut.edu.cn/https/57787a7876706e323032336b657940246c0a0311f24d9f47a802fe3484afcb22ec20bb291d/?filter=app&from=rj", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(sso)
      }
    }.title("读者入馆培训")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

// 校外人员预约
@Component
export struct pageticket {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://api.m.dlut.edu.cn/oauth/authorize?client_id=9qXqHnRQuhhViycC&redirect_uri=https%3a%2f%2flightapp.m.dlut.edu.cn%2fcheck%2fticketonline&response_type=code&scope=base_api&state=dlut", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(api)
      }
    }.title("活动报名")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

// 空闲教室
@Component
export struct pageclassroom {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()

  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://api.m.dlut.edu.cn/oauth/authorize?client_id=9qXqHnRQuhhViycC&redirect_uri=https%3a%2f%2flightapp.m.dlut.edu.cn%2fcheck%2femptyclassroom&response_type=code&scope=base_api&state=dlut", controller: this.controller })
          .javaScriptAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(api)
      }
    }.title("空闲教室")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

// 空闲教室
@Component
export struct pagepys {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()

  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://webvpn.dlut.edu.cn/http/57787a7876706e323032336b65794024680b1b56f80f865ae449fe2ddfb88b/psym/Default/Index?from=rj&filter=app", controller: this.controller })
          .javaScriptAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(api)
      }
    }.title("心理测评")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

// 校园地图
@Component
export struct pagemap {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://map.dlut.edu.cn/", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
      }
    }.title("校园地图")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}


@Component
export struct pageteacher {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://faculty.dlut.edu.cn/", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
      }
    }.title("教师主页")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

@Component
export struct pagebooking {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://webvpn.dlut.edu.cn/http/57787a7876706e323032336b657940247f1f1801b2079f5bbe02ff3c84f58629/InteAuth/Account/IntegratedAuth", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(sso)
      }
    }.title("资源预约")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log(password)
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}
@Component
export struct pagemedia {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://webvpn.dlut.edu.cn/http/57787a7876706e323032336b6579402475154f1bf002805db843f535c0f5812ba27e2bdcf2f7b44596/h5/cas-authorizations?from=rj&filter=app", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(api)
      }
    }.title("多媒体教室管理")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}
@Component
export struct pagespeed {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://speedtest.dlut.edu.cn/", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
      }
    }.title("校园网测速")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}
@Component
export struct pageteach {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://webvpn.dlut.edu.cn/http/57787a7876706e323032336b6579402472000514b2079f5bbe02ff3c84f58629/student/ucas-sso/login?filter=app&from=rj", controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .domStorageAccess(true)
          .javaScriptOnDocumentEnd(sso)
      }
    }.title("教务主页")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

@Component
export struct pageinformation {
  pathStack: NavPathStack = new NavPathStack();
  build() {
    NavDestination() {
      Row(){
      Column() {
          Text("作者:").margin({ top: 25, right: "70%" })
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
        Row() {
          Image($rawfile('self.jpg'))
            .syncLoad(true)
            .width(90)
            .borderRadius(35)
            .margin({ left: 20 })

          Text("天龙宝宝").margin({ top: 10 ,left: "20%"})
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
          Hyperlink('https://github.com/tianlongbaobao', 'Github主页') {
          }.margin({ top: 10 ,left: "20%"})
        }.margin({ top: 10 ,right: "40%"})
        Text("特别鸣谢:").margin({ top: 30, right: "60%" })
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
        Row() {
          Image($rawfile('thank.png'))
            .syncLoad(true)
            .width(90)
            .borderRadius(35)
            .margin({ left: 20 })

          Text("Shirai_Kuroko").margin({ top: 10 ,left: "10%"})
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
          Hyperlink('https://github.com/IShiraiKurokoI', 'Github主页') {
          }.margin({ top: 10 ,left: "10%"})
        }.margin({ top: 10 ,right: "40%"})
        Row() {
          Image($rawfile('naosi.png'))
            .syncLoad(true)
            .width(120)
            .borderRadius(35)
            .margin({ left: 20 })
          Hyperlink('https://naosi.org/', "开发区网络与开源软件协会") {
          }.margin({ top: 10 ,left: "10%"})
        }.margin({ top: 40 ,right: "40%"})
        Text("版本运维:").margin({ top: 50, right: "60%" })
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
        Row() {
          Image($rawfile('self.jpg'))
            .syncLoad(true)
            .width(90)
            .borderRadius(35)
            .margin({ left: 20 })

          Text("luzhiyi@mail.dlut.edu.cnGithub源码提Issue").margin({ top: 10 ,left: "7%"})
            .fontSize(18)
        }.margin({ top: 15 ,right: "40%"})
        Row() {
          Image($rawfile('naosi.png'))
            .syncLoad(true)
            .width(120)
            .borderRadius(35)
            .margin({ left: 20 })
          Text("Q群:724021138").margin({ top: 10 ,left: "10%"})
            .fontSize(18)
        }.margin({ top: 50 ,right: "40%"})
      }
      }
    }.title("联系我们")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

@Component
export struct pagesettings {
  pathStack: NavPathStack = new NavPathStack();
  build() {
    NavDestination() {
      Column() {
        Image($r('app.media.start'))
          .syncLoad(true)
          .width(100)
          .margin({ top: 120 })
        Text("i大工社区版").margin({top:18})
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
        Text("版本号:2.1.0").margin({top:15})
          .fontSize(15)
        Hyperlink('https://github.com/tianlongbaobao/idut-HarmonyOS-Next', 'Github源码') {
        }
        .color(Color.Blue)
        .margin({top:15})
        Button("退出登录")
          .margin({top:20})
          .backgroundColor("red")
          .onClick(() => {
          dataPreferences.getPreferences(context, "information").then(preferences=>{
            preferences.delete("account")
            preferences.delete("password")
            preferences.flush()
            router.pushUrl({
              url: 'pages/Index',
            })
          }).catch((err:Error)=>{

          })

        })
          .width('80%')
        Text("此与i大工官方版无关，由校内独立开发者开发，方便在鸿蒙Next上使用相关服务，仅供交流！").margin({top:290,left:45,right:45})
          .fontSize(13)

      }
    }.title("设置")
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}