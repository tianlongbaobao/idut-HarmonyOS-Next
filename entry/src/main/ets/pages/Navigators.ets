import { webview } from "@kit.ArkWeb";
import router from '@ohos.router';
import window from '@ohos.window';


const  account:string = (router.getParams() as Record<string, string>)['id2']; // 获取id属性的值
const  password:string = (router.getParams() as Record<string, string>)['id1'];
const  api: Array<ScriptItem> = [{ script: "username.value='" + account + "';password.value='" + password + "';submit.disabled='';submit.click()", scriptRules: ["*"] }]
const  sso: Array<ScriptItem> = [{ script: "$(\"#un\").val('" + account + "');$(\"#pd\").val('" + password + "');login()", scriptRules: ["*"] }]
const  vpn: Array<ScriptItem> = [{ script: "document.getElementById('cas-login').click()", scriptRules: ["*"] }]
const  card: Array<ScriptItem> = [{ script: "document.getElementsByClassName('top gradient2')[0].outerHTML=''", scriptRules: ["*"] }]
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
      win.setWindowSystemBarProperties({ statusBarContentColor: '#ffffff' }); // 设置状态栏字体颜色
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
    }  else if (name === "校园网自助服务") {
      pageweb()
    } else if (name === "体育场馆预定") {
      pagesports()
    } else if (name === "校外人员预约") {
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
          Button("玉兰卡").onClick(() => {
            this.pathStack.pushPath({ name: "玉兰卡"})
          })
            .width('100%')
        }
        ListItem() {
          Button("校车定位").onClick(() => {
            this.pathStack.pushPath({ name: "校车定位"})
          })
            .width('100%')
        }
        ListItem() {
          Button("校园地图").onClick(() => {
            this.pathStack.pushPath({ name: "校园地图"})
          })
            .width('100%')
        }


        ListItem() {
          Text("2.校园生活").margin({left:20,top:15,bottom:10})
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        ListItem() {
          Button("体质测评").onClick(() => {
            this.pathStack.pushPath({ name: "体质测评"})
          })
            .width('100%')
        }
        ListItem() {
          Button("图书馆预约").onClick(() => {
            this.pathStack.pushPath({ name: "图书馆预约"})
          })
            .width('100%')
        }
        ListItem() {
          Button("体育场馆预定").onClick(() => {
            this.pathStack.pushPath({ name: "体育场馆预定"})
          })
            .width('100%')
        }

        ListItem() {
          Button("校外人员预约").onClick(() => {
            this.pathStack.pushPath({ name: "校外人员预约"})
          })
            .width('100%')
        }
        ListItem() {
          Text("3.教学与资源").margin({left:20,top:15,bottom:10})
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        ListItem() {
          Button("我的课表").onClick(() => {
            this.pathStack.pushPath({ name: "我的课表"})
          })
            .width('100%')
        }
        ListItem() {
          Button("考试安排").onClick(() => {
            this.pathStack.pushPath({ name: "考试安排"})
          })
            .width('100%')
        }
        ListItem() {
          Button("空闲教室").onClick(() => {
            this.pathStack.pushPath({ name: "空闲教室"})
          })
            .width('100%')
        }
        ListItem() {
          Button("资源预约").onClick(() => {
            this.pathStack.pushPath({ name: "资源预约"})
          })
            .width('100%')
        }
        ListItem() {
          Button("多媒体教室管理").onClick(() => {
            this.pathStack.pushPath({ name: "多媒体教室管理"})
          })
            .width('100%')
        }
        ListItem() {
          Button("教师主页").onClick(() => {
            this.pathStack.pushPath({ name: "教师主页"})
          })
            .width('100%')
        }
        ListItem() {
          Text("4.网信服务").margin({left:20,top:15,bottom:10})
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }

        ListItem() {
          Button("网络自助").onClick(() => {
            this.pathStack.pushPath({ name: "校园网自助服务"})
          })
            .width('100%')
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
  scroller: Scroller = new Scroller()
  contentScroller: Scroller = new Scroller()
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
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
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
          .onControllerAttached(() => {
            console.log("onControllerAttached");
            try {
              let userAgent = "Mozilla/ 5.0 (Linux; Android 10; EBG Build/ HUAWEIEBG; wv) AppleWebKit/ 537.36 (KHTML, like Gecko) Version/ 4.0 Chrome/ 88.0.4324.93 Mobile Safari/ 537.36 weishao(3.3.0.74633)";
              this.controller.setCustomUserAgent(userAgent);
            } catch (error) {
            }
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
        Web({ src: "https://ehall.dlut.edu.cn/fp/view?m=fp#act=fp/serveapply&from=hall&serveID=7573037038055424", controller: this.controller })
      }
    }.title("校外人员预约")
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

  @State  api: Array<ScriptItem> = [{ script: "username.value='" + account + "';password.value='" + password + "';submit.disabled='';submit.click()", scriptRules: ["*"] }]
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