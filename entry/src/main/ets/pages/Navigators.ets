import { webview } from "@kit.ArkWeb";

@Entry
@Component
struct  Navigators {
  pathStack: NavPathStack = new NavPathStack();

  @Builder
  PageMap(name: string) {
    if (name === "我的邮箱") {
      pageemail()
    } else if (name === "我的课表") {
      pageclass()
    } else if (name === "图书馆预约") {
      pagelib()
    } else if (name === "文献检索") {
      pagelibmanagement()
    } else if (name === "玉兰卡") {
      pagecard()
    } else if (name === "公共资源预约") {
      pagepublic()
    } else if (name === "学工系统（原）") {
      pagest()
    } else if (name === "校园网自助服务") {
      pageweb()
    } else if (name === "缴电费") {
      pageelecfee()
    } else if (name === "缴网费") {
      pagewebfee()
    } else if (name === "体育场馆预定") {
      pagesports()
    } else if (name === "校外人员预约") {
      pageout()
    } else if (name === "玉兰卡充值") {
      pagecardin()
    }  else if (name === "学工系统（新）") {
      pagestnew()
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
          Button("玉兰卡(仅能查余额流水，校园网环境)").onClick(() => {
            this.pathStack.pushPath({ name: "玉兰卡"})
          })
            .width('100%')
        }

        ListItem() {
          Button("缴网费(校园网环境)").onClick(() => {
            this.pathStack.pushPath({ name: "缴网费"})
          })
            .width('100%')
        }

        ListItem() {
          Button("缴电费(校园网环境)").onClick(() => {
            this.pathStack.pushPath({ name: "缴电费"})
          })
            .width('100%')
        }

        ListItem() {
          Button("玉兰卡充值(校园网环境)").onClick(() => {
            this.pathStack.pushPath({ name: "玉兰卡充值"})
          })
            .width('100%')
        }
        ListItem() {
          Text("2.校园生活").margin({left:20,top:15,bottom:10})
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
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
          Button("公共资源预约(校园网环境)").onClick(() => {
            this.pathStack.pushPath({ name: "公共资源预约"})
          })
            .width('100%')
        }
        ListItem() {
          Button("学工系统（原）(校园网环境)").onClick(() => {
            this.pathStack.pushPath({ name: "学工系统（原）"})
          })
            .width('100%')
        }
        ListItem() {
          Button("智慧学工(校园网环境)").onClick(() => {
            this.pathStack.pushPath({ name: "智慧学工"})
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
          Button("文献检索(校园网环境)").onClick(() => {
            this.pathStack.pushPath({ name: "文献检索"})
          })
            .width('100%')
        }
        ListItem() {
          Text("4.网信服务").margin({left:20,top:15,bottom:10})
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        ListItem() {
          Button("我的邮箱").onClick(() => {
            this.pathStack.pushPath({ name: "我的邮箱"})
          })
            .width('100%')
        }
        ListItem() {
          Button("校园网自助服务(校园网环境)").onClick(() => {
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
}

// 我的邮箱
@Component
export struct pageemail {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: 'https://mail.dlut.edu.cn/', controller: this.controller })
      }
    }.title("我的邮箱")
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

// 我的课表
@Component
export struct pageclass {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: 'http://jxgl.dlut.edu.cn/student/for-std/course-table', controller: this.controller })
      }
    }.title("我的课表")
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

// 图书馆预约
@Component
export struct pagelib {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: 'https://seat.lib.dlut.edu.cn/yanxiujian/client/', controller: this.controller })
      }
    }.title("图书馆预约")
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

// 文献检索
@Component
export struct pagelibmanagement {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "https://opac.lib.dlut.edu.cn/space/index", controller: this.controller })
      }
    }.title("文献检索")
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
        Web({ src: 'https://opac.lib.dlut.edu.cn/space/reader/readerHome', controller: this.controller })
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
export struct pagepublic {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://resource.dlut.edu.cn/#/app/booking-types", controller: this.controller })
      }
    }.title("公共资源预约")
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

// 学工系统（原）
@Component
export struct pagest {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://dutsa.dlut.edu.cn/userhall/Sec/page/index", controller: this.controller })
      }
    }.title("学工系统（原）")
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
        Web({ src: "http://tulip.dlut.edu.cn/index.html;#/user.useroverview.useroverview", controller: this.controller })
      }
    }.title("校园网自助服务")
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

// 缴电费
@Component
export struct pageelecfee {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://ecardpayment.dlut.edu.cn/#/project/pay/eleCostOfDlutPay", controller: this.controller })
      }
    }.title("缴电费")
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

// 缴网费
@Component
export struct pagewebfee {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://ecardpayment.dlut.edu.cn/#/project/pay/netCostOfSlPay", controller: this.controller })
      }
    }.title("缴网费")
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
        Web({ src: "https://ehall.dlut.edu.cn/fp/view?m=fp#act=fp/serveapply&from=hall&serveID=0899d261-6e57-4c83-8b50-7975221591f9", controller: this.controller })
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

// 玉兰卡充值
@Component
export struct pagecardin {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://ecardpayment.dlut.edu.cn/#/project/pay/eCardRechargePay", controller: this.controller })
      }
    }.title("玉兰卡充值")
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

// 学工系统（新）
@Component
export struct pagestnew {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  build() {
    NavDestination() {
      Column() {
        Web({ src: "http://dutxg.dlut.edu.cn/#/index", controller: this.controller })
      }
    }.title("学工系统新")
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
