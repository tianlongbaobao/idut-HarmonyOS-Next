import { webview } from "@kit.ArkWeb";
import dataPreferences from '@ohos.data.preferences';
import { common } from '@kit.AbilityKit';
import {responsebean} from "./utils/ResponseBean"
import router from '@ohos.router';
import window from '@ohos.window';
import { scanCore, scanBarcode } from '@kit.ScanKit';
import { BusinessError } from '@kit.BasicServicesKit';
import {appList} from "./app/applist"
import {pushclass} from "./utils/pushservice"
import {PermissionsUtil} from "./utils/permission"
import axios, { AxiosResponse } from "@ohos/axios";
import {pageself} from "./app/self"
import {pagepe} from "./app/sports"
import {pageclass} from "./app/classes"
import {pagecard} from "./app/vcard"
import {pagelib} from "./app/lib"
import {pagetest} from "./app/test"
import {pagecar} from "./app/car"
import {pageweb} from "./app/web"
import {pagesports} from "./app/sportsm"
import {pageout} from "./app/out"
import {pageticket} from "./app/tickets"
import {pagepys} from "./app/pys"
import {pageclassroom} from "./app/classroom"
import {pagemap} from "./app/map"
import {pageteacher} from "./app/teacher"
import {pagebooking} from "./app/booking"
import {pagemedia} from "./app/media"
import {pagespeed} from "./app/speed"
import {pageteach} from "./app/teach"
import {pageinformation} from "./app/information"
import {pagesettings} from "./app/settiing"
import {pagewebeda} from "./app/webeda"
import {pagesportseda} from "./app/sportseda"
import {pagevcard} from "./app/card"
import {pagegrade} from "./app/grade"
import {pagenew} from "./app/new"
import {pagehandle} from "./app/handle"
import {pagestudent} from "./app/student"
import {pageinvestigate} from "./app/investigate"
import {pagepostgraduate} from "./app/postgraduate"
import {pagebooklist} from "./app/booklist"
import {pagefee} from "./app/fee"
import {pagenotice} from "./app/notice"
import {pagecalendar} from "./app/calendar";
import {pagepublicnotice} from "./app/publicnotice"
import { pagerunschool } from "./app/runschool";
import { pagenews } from "./app/news";
import { pageprint } from "./app/print";
import { pagephoto } from "./app/photo";
import { pagelife } from "./app/life";
import { pagefood } from "./app/food";
import { pageoa } from "./app/OA";
import { pagegroup } from "./app/group";
import { pagespeak } from "./app/speak";
import { pagechemistry } from "./app/chemistry";
import { pagegraduate } from "./app/graduate";
import { pagerepair } from "./app/repair";
import { pagesafetest } from "./app/safetest";
import { pageassistant } from "./app/assistant";
import { pagestudentnew } from "./app/studentnew";
import { pagechooseclass } from "./app/chooseclass";
import { pageteachsys } from "./app/teachsys";
import { pagecomment } from "./app/comment";
import { pagepan } from "./app/pan";
import { pageai } from "./app/ai";

const  account:string = (router.getParams() as Record<string, string>)['id2'];
const  password:string = (router.getParams() as Record<string, string>)['id1'];
const  pasz:string = (router.getParams() as Record<string, string>)['id4'];
const  verifys:string = (router.getParams() as Record<string, string>)['id5'];

interface mnv {
  accounts:string
  passwords:string
  verify:string
}

let ncs:mnv ={
  accounts:account,
  passwords:password,
  verify:verifys
}
let context = getContext(this)
@Entry
@Component
struct  Navigators {
  @State appll:number[] = []
  @State selectIndex:number = 0
  @State nickname:string = ""
  @State head:string = ""
  @State index:number = -1
  @State doorlink:number = 0
  @Provide('pathInfos') pathStack: NavPathStack = new NavPathStack();

  private setImmersive() {
    window.getLastWindow(getContext()).then(win => {
      win.setWindowLayoutFullScreen(false);
      win.setWindowSystemBarProperties({ statusBarContentColor: "#000000" });
    });
  }
  aboutToAppear(): void {
    let paszl = pasz.split(",")
    let mn = 0
    for (let index = 0; index < paszl.length; index++) {
      if (paszl[index]!=",") {
        this.appll[mn] = Number(paszl[index])
        mn=mn+1
      }
    }
    dataPreferences.getPreferences(context, "information").then(preferences=>{
      preferences.get("data",'default').then((value)=>{
        let data_c:responsebean = JSON.parse(String(value))
        this.nickname = data_c.data.my_info.nick_name
        this.head = data_c.data.my_info.head
      })
      preferences.get("door",'default').then((value)=>{
        if (value!="default") {
          this.doorlink = 1
        } else {
          this.doorlink = 0
        }
      })
    }).catch((err:Error)=>{

    })
  }
  @Builder
  tabBuilder(){
    Flex({direction:FlexDirection.Row,justifyContent:FlexAlign.Center}) {
        Column() {
          Image($rawfile("icon_service_all.png"))
            .width("10%")
            .height("53%")
            .margin("2.5%")
          Text("我的服务")
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
        }
        .onClick(() => {
          this.selectIndex = 0;
        })
        .margin({right:"20%"})
      Column() {
        Image($rawfile("icon_service_study.png"))
          .width("8%")
          .height("53%")
          .margin("2.5%")
        Text("工具箱")
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
      }
      .margin({right:"20%"})
      .onClick(() => {
        this.selectIndex = 2;
      })
      Column() {
        Image($rawfile("icon_service_social.png"))
          .width("8%")
          .height("53%")
          .margin("2.5%")
        Text("个人中心")
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
      }

      .onClick(() => {
        this.selectIndex = 1;
      })

    }
    .height("100%")
  }
  @Builder
  PageMap(name: string) {
    if (name == "体质测评") {
      pagepe()
    } else if (name === "我的课表") {
      pageclass()
    } else if (name === "图书馆预约") {
      pagelib()
    } else if (name === "考试安排") {
      pagetest()
    } else if (name == "玉兰卡") {
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
    } else if (name === "活动报名") {
      pageticket()
    }else if (name === "校园网测速") {
      pagespeed()
    }else if (name === "作者信息") {
      pageinformation()
    }else if (name === "大工教务") {
      pageteach()
    }else if (name === "设置") {
      pagesettings()
    }else if (name === "个人证件") {
      pageself()
    }else if (name === "校园网（开发区校区）") {
      pagewebeda()
    }else if (name === "开发区体育场馆预约") {
      pagesportseda()
    }else if (name === "虚拟卡") {
      pagevcard()
    }else if (name === "我的成绩") {
      pagegrade()
    }else if (name === "迎新系统") {
      pagenew()
    }else if (name === "办事大厅") {
      pagehandle()
    }else if (name === "学工系统（原）") {
      pagestudent()
    }else if (name === "调查问卷") {
      pageinvestigate()
    }else if (name === "研究生系统") {
      pagepostgraduate()
    }else if (name === "图书借阅") {
      pagebooklist()
    }else if (name === "校园缴费") {
      pagefee()
    }else if (name === "校内通知") {
      pagenotice()
    }else if (name === "校历") {
      pagecalendar()
    }else if (name === "公共通知") {
      pagepublicnotice()
    }else if (name === "离校系统") {
      pagerunschool()
    }else if (name === "学校新闻") {
      pagenews()
    }else if (name === "自助打印") {
      pageprint()
    }else if (name === "照片采集") {
      pagephoto()
    }else if (name === "校内生活") {
      pagelife()
    }else if (name === "点餐系统") {
      pagefood()
    }else if (name === "移动OA") {
      pageoa()
    }else if (name === "组工平台") {
      pagegroup()
    }else if (name === "DUTer建言") {
      pagespeak()
    }else if (name === "试剂耗材采购") {
      pagechemistry()
    }else if (name === "毕业生档案服务") {
      pagegraduate()
    }else if (name === "后勤报修系统") {
      pagerepair()
    }else if (name === "安全准入考试") {
      pagesafetest()
    }else if (name === "智能助手") {
      pageassistant()
    }else if (name === "智慧学工") {
      pagestudentnew()
    }else if (name === "教务主页") {
      pageteachsys()
    }else if (name === "选课系统") {
      pagechooseclass()
    }else if (name === "评教系统") {
      pagecomment()
    }else if (name === "大工云盘") {
      pagepan()
    }else if (name === "AI助手") {
      pageai()
    }
  }

  build() {
    Navigation(this.pathStack) {
      if (this.selectIndex === 1) {
        List({ space: 7 }) {
          ListItem(){
            Flex({direction:FlexDirection.Row,justifyContent:FlexAlign.Center,alignItems:ItemAlign.End}) {
              Text("个人中心")
                .fontWeight(FontWeight.Bold)
                .fontSize(20)
            }
          }
          ListItem(){
            Flex({direction:FlexDirection.Row,justifyContent:FlexAlign.Center,alignItems:ItemAlign.End}) {
              Column() {
                Image(this.head)
                  .height("12%")
                  .borderRadius(35)
                Text(this.nickname)
                  .margin({top:"3.5%"})
                  .fontWeight(FontWeight.Bold)
                  .fontSize(17)
              }
              .margin({top:"5%"})
            }
          }
          ListItem(){
            Flex({direction:FlexDirection.Row,justifyContent:FlexAlign.Center,alignItems:ItemAlign.End}){
              Column(){
                Button({ type: ButtonType.Circle, stateEffect: true }) {
                  Image($rawfile("settings.png"))
                    .borderRadius(35)
                    .height("50%")
                    .width("50%")
                }
                .onClick(() => {
                  this.pathStack.pushPath({ name: "设置"})
                })
                .width(80).height(80).backgroundColor("white")
                Text("设置").margin({ top: "1%" })
                  .fontSize(15)
              }
              Column() {
                Button({ type: ButtonType.Circle, stateEffect: true }) {
                  Image($rawfile("self.png"))
                    .height("50%")
                }
                .onClick(() => {
                  this.pathStack.pushPath({ name: "个人证件"})
                })
                .width(80).height(80).backgroundColor("white")
                Text("个人证件").margin({ top: "1%" })
                  .fontSize(15)
              }.margin({ left: "8%" })
              Column() {
                Button({ type: ButtonType.Circle, stateEffect: true }) {
                  Image($rawfile("contact.png"))
                    .borderRadius(35)
                    .height("50%")
                }
                .onClick(() => {
                  this.pathStack.pushPath({ name: "作者信息"})
                })
                .width(80).height(80).backgroundColor("white")

                Text("联系我们").margin({ top: "1%" })
                  .fontSize(15)
              }.margin({ left: "8%" })
            }.margin({bottom:"3%"})
          }
        }
        .listDirection(Axis.Vertical)
        .backgroundColor("white").padding(20)
      } else if (this.selectIndex == 2){
        List({space:7}) {
          ListItem(){
            Flex({direction:FlexDirection.Row,justifyContent:FlexAlign.Center,alignItems:ItemAlign.End}) {
              Text("工具箱")
                .fontWeight(FontWeight.Bold)
                .fontSize(20)
            }
          }
          ListItem(){
            Column() {
              Row() {
                Text("课表事项提醒")
                  .height(50)
                  .fontSize(16)
              }
              Row() {
                Text("PushKit提醒")
                  .height(50)
                  .padding({left: 10})
                  .fontSize(16)
                  .textAlign(TextAlign.Start)
                  .backgroundColor(0xFFFFFF)
                Toggle({ type: ToggleType.Switch })
                  .margin({left: 200, right: 10})
                  .onChange((isOn: boolean) => {
                    pushclass(isOn)
                    PermissionsUtil.requestCameraPermission()
                  })
              }
              Row() {
                Text("开电子房门")
                  .height(50)
                  .fontSize(16)
              }
              Row(){
                Text("配置房门信息")
                  .height(50)
                  .padding({left: 10})
                  .fontSize(16)
                  .textAlign(TextAlign.Start)
                  .backgroundColor(0xFFFFFF)
                Button(){
                  if (this.doorlink == 0) {
                    Image($rawfile("add.png"))
                      .height("3.5%")
                  } else {
                    Image($rawfile("deleted.png"))
                      .height("3.5%")
                  }
                }
                .backgroundColor("white")
                .margin({left: 200, right: 10})
                .onClick(()=>{
                    let options: scanBarcode.ScanOptions = {
                      scanTypes: [scanCore.ScanType.ALL],
                      enableMultiMode: true,
                      enableAlbum: true
                    };
                    interface ResponseBean {
                      scanType: number;
                      originalValue: string
                    }
                    scanBarcode.startScanForResult(getContext(this), options)
                      .then(async (result: scanBarcode.ScanResult) => {
                        const responseBean: ResponseBean = JSON.parse(JSON.stringify(result))
                        let value: string = responseBean.originalValue
                        if (value.includes("https://lock")) {
                          const response: AxiosResponse = await axios.get(value, {
                            headers: {
                              'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36',
                              'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8'
                            }
                          });
                          let cvbn: string = response.data + ""
                          const regex = /window\.location\.href\s*=\s*['"]([^'"]+)['"]/;
                          let match = cvbn.match(regex);
                          if (match && match[1]) {
                            const extractedUrl = match[1];
                            dataPreferences.getPreferences(context, "information").then(preferences => {
                              preferences.putSync("door", extractedUrl)
                              preferences.flush()
                              this.doorlink = 1
                            })
                          } else {
                            AlertDialog.show(
                              {
                                message: '未知错误',
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
                          }
                        }

                      })
                })
              }
              Row(){
                Text("开房门")
                  .height(50)
                  .padding({left: 10})
                  .fontSize(16)
                  .textAlign(TextAlign.Start)
                  .backgroundColor(0xFFFFFF)
                Button('点击开门', { type: ButtonType.Capsule, stateEffect: false })
                  .fontSize(13)
                  .margin({left: 180, right: 10})
                  .height("3.5%")
                  .onClick(()=>{
                    dataPreferences.getPreferences(context, "information").then(preferences=>{
                      preferences.get("door",'default').then((value)=>{
                        console.log(value+"")
                        if (value == "default") {
                          AlertDialog.show(
                            {
                              message: '未配置',
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
                        } else {
                          (getContext() as common.UIAbilityContext).openLink(value+"")
                            .then(() => {
                            }).catch((err: BusinessError) => {
                          });
                        }
                      })
                    }).catch((err:Error)=>{

                    })
                  })
              }
            }
            .width('100%')
            .height('100%')
          }
          }
        .listDirection(Axis.Vertical)
        .backgroundColor("white").padding(20)

      }
      else {
        List({ space: 7 }) {
          ListItem(){
            Flex({direction:FlexDirection.Row,justifyContent:FlexAlign.End,alignItems:ItemAlign.End}) {
              Text("我的服务")
                .fontWeight(FontWeight.Bold)
                .fontSize(20)
                .margin({right:"20%"})
              Select([{ value: '扫一扫', icon:$rawfile("scancode.png")  },
                { value: '虚拟卡', icon: $rawfile("vcard.png") }])
                .selected(this.index)
                .value("+")
                .controlSize(ControlSize.SMALL)
                .onSelect((index:number, text?: string | undefined)=>{
                  this.index = index;
                  if (this.index == 1){
                    this.pathStack.pushPathByName("虚拟卡", ncs);
                  } else if (this.index == 0){
                    let options: scanBarcode.ScanOptions = {
                      scanTypes: [scanCore.ScanType.ALL],
                      enableMultiMode: true,
                      enableAlbum: true
                    };
                    interface ResponseBean {
                      scanType: number;
                      originalValue:string
                    }
                    scanBarcode.startScanForResult(getContext(this), options).then((result: scanBarcode.ScanResult) => {
                      const responseBean: ResponseBean = JSON.parse(JSON.stringify(result))
                      let value: string = responseBean.originalValue
                      if (value.includes("qrLogin")){
                        router.pushUrl({
                          url: 'pages/SSO',
                          params:{
                            id1:value}
                        })
                      }
                    })
                  }
                  this.index = -1
                })

            }
          }
          ListItem() {
            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.appll, (item: number) => {
                ChildItem({ item: item, pathStack: this.pathStack })
                  .margin({ top: 20 })
              })
            }
          }

          ListItem() {
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }) {
              Button() {
                Text("编辑我的常用服务")
                  .fontWeight(FontWeight.Bold)
                  .fontColor("white")
                  .fontSize(15)
              }
              .height("5%")
              .width("80%")
              .margin({ top: "5%" })
              .onClick(() => {
                router.pushUrl(
                  {
                    url: "pages/app/appdia",
                    params: {
                      id3: this.appll.toString()
                    }
                  }
                )
              })
            }
          }
        }
        .listDirection(Axis.Vertical)
        .backgroundColor("white").padding(20)
      }
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.PageMap)
    .toolbarConfiguration(this.tabBuilder)
    .hideTitleBar(true)
    .hideNavBar(false)
    .navBarWidth('50%')
  }
  onPageShow() {
    this.setImmersive();
  }
}

@Component
struct ChildItem {
  @Prop item: number;
  @Link pathStack:NavPathStack;
  build() {
    Column() {
      Button({ type: ButtonType.Circle, stateEffect: true }) {
        if (appList[this.item].name == "AI助手"){
          Image($rawfile("ai.jpg"))
            .borderRadius(25)
            .height("105%")
            .width("95%")
        } else if (appList[this.item].name == "智慧学工"){
          Image($rawfile("newstudent.jpg"))
            .borderRadius(25)
            .height("105%")
            .width("95%")
        } else {
          Image(appList[this.item].url)
            .borderRadius(25)
            .height("105%")
            .width("95%")
        }
      }
      .onClick(() => {
        this.pathStack.pushPathByName(appList[this.item].name, ncs);
      })
      .width("80%").height("70%").backgroundColor("white")
      Text(appList[this.item].name).margin({ top: "10%" })
        .fontSize(11)
        .fontWeight(FontWeight.Bold)
    }.margin({ left: "2.5%" ,right:"2.5%"})
    .height("10.5%")
    .width("20%")
  }
}







@Component
export struct pagescan {
  pathStack: NavPathStack = new NavPathStack();
  controller: webview.WebviewController = new webview.WebviewController()
  aboutToAppear(): void {
    console.log("1")
  }
  build() {
    NavDestination() {
      Button('loadUrl')
        .onClick(() => {
          try {
                // 点击按钮时，通过loadUrl，跳转到www.example1.com
            this.controller.loadUrl('www.example1.com');
          } catch (error) {
            console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        })
          // 组件创建时，加载www.example.com
          Web({ src: 'www.example.com', controller: this.controller })

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


