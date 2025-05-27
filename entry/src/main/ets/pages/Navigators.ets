import dataPreferences from '@ohos.data.preferences';
import deviceinfo from '@ohos.deviceInfo';
import { common, ConfigurationConstant } from '@kit.AbilityKit';
import { NavigationModifier } from "@kit.ArkUI";
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
import {pageinformation} from "./app/information"
import {pagesettings} from "./app/settiing"
import { pageselfinformation } from './app/selfinformation';
import { galleryres } from './utils/gallerybean';
import { connection } from '@kit.NetworkKit';
import { webpage } from './app/webpage';
import { webview } from '@kit.ArkWeb';


const  account:string = (router.getParams() as Record<string, string>)['id2'];
const  password:string = (router.getParams() as Record<string, string>)['id1'];
const  pasz:string = (router.getParams() as Record<string, string>)['id4'];
let gallery:string = (router.getParams() as Record<string, string>)['id6'];

interface mnv {
  accounts: string
  passwords: string
  url:string
  name:string
}


let context = getContext(this)


class NavigationMainModifier implements AttributeModifier<NavigationModifier> {
  navigationMode: NavigationMode = NavigationMode.Auto;

  // 成员变量navigationMode的值改变时，会自动调用此方法
  applyNormalAttribute(instance: NavigationModifier): void {
    instance.mode(this.navigationMode)
  }
}

@Entry
@Component
struct  Navigators {
  @State appll:number[] = []
  @State selectIndex:number = 0
  @State nickname:string = ""
  @State head:string = ""
  @State index:number = -1
  @State doorlink:number = 0
  @State swiperData: string[] = []
  @State swiperurl:string[] = []
  @State idc: number = 0
  @State darkmode:boolean = false
  @State useragent:boolean = false
  @State nologin:boolean = false
  private Tabcontroller: TabsController = new TabsController();
  controller: webview.WebviewController = new webview.WebviewController();
  private netCon: connection.NetConnection = connection.createNetConnection();
  private swiperController: SwiperController = new SwiperController()
  @State swiperindex:number = 0
  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentColorMode: number =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  @Provide('pathInfos') pathStack: NavPathStack = new NavPathStack();
  @StorageProp('currentBreakpoint') curBp: string = 'sm';
  @State nav:NavigationMode = NavigationMode.Auto
  @State ncs:mnv = {
    passwords:password,
    accounts:account,
    url:"",
    name:""
  }
  @State devicety:string = ""
  @StorageLink('currentWidthBreakpoint') windowWidth: number = 0;
  @StorageLink('currentHeightBreakpoint') windowHeight: number = 0;
  onColorModeChange() {
    if (this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.darkmode = true
    } else {
      this.darkmode = false
    }
    if (this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      window.getLastWindow(getContext()).then(win => {
        win.setWindowLayoutFullScreen(false);
        win.setWindowSystemBarProperties({
          statusBarContentColor: '#FFFFFF'
        });

      })
    } else  {
      window.getLastWindow(getContext()).then(win => {
        win.setWindowLayoutFullScreen(false);
        win.setWindowSystemBarProperties({
          statusBarContentColor: '#000000'
        });

      })
    }
  }
  private setImmersive() {
    window.getLastWindow(getContext()).then(win => {
      win.setWindowLayoutFullScreen(false);
      win.setWindowSystemBarProperties({
        statusBarContentColor: '#000000'
      });
    });
  }
  aboutToAppear(): void {
    let deviceTypeInfo: string = deviceinfo.deviceType;
    this.devicety = deviceTypeInfo
    if (this.nologin == false) {
    if (gallery == "null") {
      AlertDialog.show(
        {
          message: '无法获取轮播图',
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
    } else {
      let gaj: galleryres = JSON.parse(gallery)
      if (gaj.errcode == 0) {
        for (let index = 0; index < gaj.data.carousel_gallery.length; index++) {
          this.swiperurl.push(gaj.data.carousel_gallery[index].url)
          this.swiperData.push(gaj.data.carousel_gallery[index].pic_uri)
        }

      }
    }
  }
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
      preferences.get("pcmode",'default').then((value)=>{
        if (value=="default") {
          this.useragent = false
        } else if (value == "1"){
          this.useragent = true
        } else {
          this.useragent = false
        }

      })
      preferences.get("nologin",'default').then((value)=>{
        if (value=="default") {
          this.nologin = false
        } else if (value == "1"){
          this.nologin = true
        } else {
          this.nologin = false
        }

      })
    }).catch((err:Error)=>{

    })


  }

  @Builder
  PageMap(name: string) {
    if (name === "web"){
      webpage({darkmode:this.darkmode,vsf:this.ncs,useragent:this.useragent})
    }else if (name === "作者信息") {
      pageinformation()
    }else if (name === "设置") {
      pagesettings()
    }else if (name === "个人资料") {
      pageselfinformation({nickname:this.nickname})
    }else if (name === "个人证件") {
      pageself()
    }
  }


  build() {
    Navigation(this.pathStack) {
      Tabs({ barPosition: BarPosition.End, controller: this.Tabcontroller }) {
        TabContent() {
          List({ space: 7 }) {
            ListItem() {
              RelativeContainer() {
                Row() {
                  Text("我的服务")
                    .fontWeight(FontWeight.Bold)
                    .fontSize(20)
                    .fontColor($r('app.color.text'))
                    .margin({ top: "4%" })
                }.justifyContent(FlexAlign.Center)

                .alignRules({
                  'center': { 'anchor': '__container__', 'align': VerticalAlign.Center },
                  'middle': { 'anchor': '__container__', 'align': HorizontalAlign.Center }
                })

                if (this.devicety != "2in1") {
                  Row() {
                    Select([{ value: '扫一扫', icon: $rawfile("scancode.png") },
                      { value: '虚拟卡', icon: $rawfile("vcard.png") }])
                      .selected(this.index)
                      .value("+")
                      .fontColor($r('app.color.text'))
                      .width("15%")
                      .height("4%")
                      .align(Alignment.End)
                      .onSelect(async (index: number, text?: string | undefined) => {
                        this.index = index;
                        if (this.index == 1) {
                          this.ncs.url = "https://card.m.dlut.edu.cn/virtualcardrj/openRjQrcodePage"
                          this.ncs.name = "虚拟卡"
                          this.pathStack.pushPathByName("web", this.ncs);
                        } else if (this.index == 0) {
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
                            .then((result: scanBarcode.ScanResult) => {
                              const responseBean: ResponseBean = JSON.parse(JSON.stringify(result))
                              let value: string = responseBean.originalValue
                              if (value.includes("qrLogin")) {
                                router.pushUrl({
                                  url: 'pages/SSO',
                                  params: {
                                    id1: value
                                  }
                                })
                              }
                            })
                        }
                        this.index = -1
                      })
                  }.alignRules({
                    'right': { 'anchor': '__container__', 'align': HorizontalAlign.End }
                  })
                }
              }
              .height("5%")

            }

            ListItem() {
              Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly }) {
                ForEach(this.appll, (item: number) => {
                  ChildItem({ item: item, pathStack: this.pathStack, ncs: this.ncs })
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
                .height(30)
                .width("80%")
                .margin({ top: "5%" })
                .onClick(() => {
                  router.pushUrl(
                    {
                      url: "pages/app/appdia",
                      params: {
                        id3: this.appll.toString(),
                      }
                    }
                  )
                })
              }
            }
          }
          .listDirection(Axis.Vertical)
          .backgroundColor($r('app.color.background')).padding(20)
        }
        .tabBar(BottomTabBarStyle.of($rawfile("icon_service_all.png"),"我的服务").labelStyle({font:{size:13}}))
        .align(Alignment.Top)
        TabContent() {
          List({ space: 7 }) {
            ListItem() {
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.End }) {
                Text("消息通知")
                  .fontWeight(FontWeight.Bold)
                  .fontSize(20)
                  .fontColor($r('app.color.text'))
                  .margin({ top: "4%" })
              }

            }

            ListItem() {
              Column() {
                Swiper(this.swiperController) {
                  ForEach(this.swiperData, (item: string) => {
                    Image(item)
                      .width('100%')
                      .objectFit(ImageFit.Cover)
                  })
                }
                .width('100%')
                .loop(true) // 循环播放
                .autoPlay(true) // 自动播放
                .interval(3000) // 3秒间隔
                .indicator(true) // 显示分页指示器
                .onChange((index: number) => {
                  this.swiperindex = index
                })
                .onClick(() => {
                  if (gallery != "null") {
                    this.ncs.accounts = account
                    this.ncs.passwords = password
                    this.ncs.name = "轮播图"
                    this.ncs.url = this.swiperurl[this.swiperindex]
                    this.pathStack.pushPathByName("web", this.ncs);
                  }

                })
                .margin({ top: "5%" })
              }
            }

            ListItem() {
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.End }) {
                Text("推送消息后端服务器未适配")
                  .fontWeight(FontWeight.Bold)
                  .fontSize(20)
                  .fontColor($r('app.color.text'))
              }.margin({ top: "30%" })

            }

            ListItem() {
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.End }) {
                Text("敬请期待")
                  .fontWeight(FontWeight.Bold)
                  .fontSize(20)
                  .fontColor($r('app.color.text'))
              }.margin({ top: "8%" })
            }

            ListItem() {
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.End }) {
                Text("适配后预计支持pushkit")
                  .fontWeight(FontWeight.Bold)
                  .fontSize(20)
                  .fontColor($r('app.color.text'))
              }.margin({ top: "6%" })
            }

          }
          .listDirection(Axis.Vertical)
          .backgroundColor($r('app.color.background')).padding(20)

        }.tabBar(BottomTabBarStyle.of($rawfile("icon_service_office.png"),"消息通知").labelStyle({font:{size:13}}))
        .align(Alignment.Top)

        TabContent() {
          Scroll() {
            List({ space: 7 }) {

              ListItem() {
                Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.End }) {
                  Text("工具箱")
                    .fontWeight(FontWeight.Bold)
                    .fontSize(20)
                    .fontColor($r('app.color.text'))
                    .margin({ top: "4%" })
                }

              }

              ListItem() {
                Column() {
                  if (this.devicety == "2in1" || this.devicety == "tablet") {
                    Row() {
                      Text("免登录验证")
                        .height(50)
                        .fontSize(16)
                        .fontColor($r('app.color.text'))
                    }
                    .margin({ top: "2%" })

                    Flex({
                      direction: FlexDirection.Row,
                      justifyContent: FlexAlign.SpaceEvenly,
                      alignItems: ItemAlign.Center
                    }) {
                      Text("关闭轮播图")
                        .margin({ right: "3%" })
                        .fontSize(16)
                        .fontColor($r('app.color.text'))
                      Toggle({ type: ToggleType.Switch, isOn: this.nologin })
                        .margin({ left: "55%" })
                        .onChange((isOn: boolean) => {
                          this.nologin = isOn
                          dataPreferences.getPreferences(context, "information").then(preferences => {
                            if (this.nologin) {
                              preferences.putSync("nologin", "1")
                            } else {
                              preferences.putSync("nologin", "0")
                            }
                            preferences.flush()
                          }).catch((err: Error) => {

                          })
                        })

                    }
                    .borderRadius(20)
                    .backgroundColor($r("app.color.information"))
                    .height(50)
                    .margin({ top: "5%" })
                  }
                  Row() {
                    Text("课表事项提醒")
                      .fontSize(16)
                      .height(50)
                      .fontColor($r('app.color.text'))
                  }
                  .margin({ top: "2%" })


                  Flex({
                    direction: FlexDirection.Row,
                    justifyContent: FlexAlign.SpaceEvenly,
                    alignItems: ItemAlign.Center
                  }) {
                    Text("PushKit提醒")
                      .margin({ right: "3%" })
                      .fontSize(16)
                      .fontColor($r('app.color.text'))
                    Toggle({ type: ToggleType.Switch })
                      .margin({ left: "55%" })
                      .onChange((isOn: boolean) => {
                        pushclass(isOn)
                        PermissionsUtil.requestCameraPermission()
                      })
                  }
                  .borderRadius(20)
                  .backgroundColor($r("app.color.information"))
                  .height(50)
                  .margin({ top: "5%" })

                  if (this.devicety != "2in1") {
                    Row() {
                      Text("开电子房门")
                        .height(50)
                        .fontSize(16)
                        .fontColor($r('app.color.text'))
                    }.margin({ top: "2%" })

                    Flex({
                      direction: FlexDirection.Row,
                      justifyContent: FlexAlign.SpaceEvenly,
                      alignItems: ItemAlign.Center
                    }) {
                      Text("配置房门信息")
                        .margin({ right: "3%" })
                        .fontSize(16)
                        .fontColor($r('app.color.text'))
                      Button() {
                        if (this.doorlink == 0) {
                          Image($rawfile("add.png"))
                            .height(20)
                        } else {
                          Image($rawfile("deleted.png"))
                            .height(20)
                        }
                      }
                      .backgroundColor($r('app.color.background'))
                      .margin({ left: "55%" })
                      .onClick(() => {
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
                                      fontColor: "red"
                                    },
                                  }
                                )
                              }
                            }

                          })
                      })
                    }
                    .borderRadius(20)
                    .backgroundColor($r("app.color.information"))
                    .height(50)
                    .margin({ top: "5%" })

                    Flex({
                      direction: FlexDirection.Row,
                      justifyContent: FlexAlign.SpaceEvenly,
                      alignItems: ItemAlign.Center
                    }) {
                      Text("开房门")
                        .margin({ right: "3%" })
                        .fontSize(16)
                        .fontColor($r('app.color.text'))

                      Button('点击开门', { type: ButtonType.Capsule, stateEffect: false })
                        .fontSize(13)
                        .margin({ left: '45%' })
                        .height(25)
                        .onClick(() => {
                          dataPreferences.getPreferences(context, "information").then(preferences => {
                            preferences.get("door", 'default').then((value) => {
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
                                      fontColor: "red"
                                    },
                                  }
                                )
                              } else {
                                (getContext() as common.UIAbilityContext).openLink(value + "")
                                  .then(() => {
                                  }).catch((err: BusinessError) => {
                                });
                              }
                            })
                          }).catch((err: Error) => {

                          })
                        })
                    }.borderRadius(20)
                    .backgroundColor($r("app.color.information"))
                    .height(50)
                    .margin({ top: "5%" })
                  }

                  Row() {
                    Text("校园网提醒（开发区校区）（敬请期待）")
                      .height(50)
                      .fontSize(16)
                      .fontColor($r('app.color.text'))
                  }
                  .margin({ top: "2%" })

                  Flex({
                    direction: FlexDirection.Row,
                    justifyContent: FlexAlign.SpaceEvenly,
                    alignItems: ItemAlign.Center
                  }) {
                    Text("实况窗提醒")
                      .margin({ right: "3%" })
                      .fontSize(16)
                      .fontColor($r('app.color.text'))
                    Toggle({ type: ToggleType.Switch })
                      .margin({ left: "55%" })
                      .onChange((isOn: boolean) => {
                      })
                  }
                  .borderRadius(20)
                  .backgroundColor($r("app.color.information"))
                  .height(50)
                  .margin({ top: "5%" })

                  Row() {
                    Text("深色模式")
                      .height(50)
                      .fontSize(16)
                      .fontColor($r('app.color.text'))
                  }
                  .margin({ top: "2%" })

                  Flex({
                    direction: FlexDirection.Row,
                    justifyContent: FlexAlign.SpaceEvenly,
                    alignItems: ItemAlign.Center
                  }) {
                    Text("强制深色模式")
                      .margin({ right: "3%" })
                      .fontSize(16)
                      .fontColor($r('app.color.text'))
                    Toggle({ type: ToggleType.Switch, isOn: this.darkmode })
                      .margin({ left: "50%" })
                      .onChange((isOn: boolean) => {
                        let applicationContext = context.getApplicationContext();
                        if (isOn) {
                          applicationContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
                        } else {
                          applicationContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
                        }
                      })

                  }
                  .borderRadius(20)
                  .backgroundColor($r("app.color.information"))
                  .height(50)
                  .margin({ top: "5%" })

                  if (this.devicety == "2in1" || this.devicety == "tablet") {
                    Row() {
                      Text("PC模式")
                        .height(50)
                        .fontSize(16)
                        .fontColor($r('app.color.text'))
                    }
                    .margin({ top: "2%" })

                    Flex({
                      direction: FlexDirection.Row,
                      justifyContent: FlexAlign.SpaceEvenly,
                      alignItems: ItemAlign.Center
                    }) {
                      Text("扩屏及UA标识符替换")
                        .margin({ right: "3%" })
                        .fontSize(16)
                        .fontColor($r('app.color.text'))
                      Toggle({ type: ToggleType.Switch, isOn: this.useragent })
                        .margin({ left: "42%" })
                        .onChange((isOn: boolean) => {
                          this.pathStack.clear()
                          this.useragent = isOn
                          dataPreferences.getPreferences(context, "information").then(preferences => {
                            if (this.useragent) {
                              preferences.putSync("pcmode", "1")
                            } else {
                              preferences.putSync("pcmode", "0")
                            }
                            preferences.flush()
                          }).catch((err: Error) => {

                          })


                        })

                    }
                    .borderRadius(20)
                    .backgroundColor($r("app.color.information"))
                    .height(50)
                    .margin({ top: "5%" })
                  }

                }
              }
            }
            .listDirection(Axis.Vertical)
            .backgroundColor($r('app.color.background')).padding(20)

          }
        }.tabBar(BottomTabBarStyle.of($rawfile("icon_service_study.png"),"工具箱").labelStyle({font:{size:13}}))
        .align(Alignment.Top)
        TabContent() {
          Scroll() {
            List({ space: 7 }) {
              ListItem() {
                Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.End }) {
                  Text("个人中心")
                    .fontWeight(FontWeight.Bold)
                    .fontSize(20)
                    .fontColor($r('app.color.text'))
                    .margin({ top: "4%" })
                }
              }

              ListItem() {
                Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.End }) {
                  Column() {
                    Image(this.head)
                      .height(100)
                      .borderRadius(35)
                      .fillColor($r('app.color.background'))
                    Text(this.nickname)
                      .margin({ top: "3.5%" })
                      .fontWeight(FontWeight.Bold)
                      .fontSize(17)
                      .fontColor($r('app.color.text'))
                  }
                  .margin({ top: "5%" })
                }
              }

              ListItem() {
                Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.End }) {
                  Column() {
                    Button({ type: ButtonType.Circle, stateEffect: true }) {
                      Image($rawfile("icon_mine_account_safe.png"))
                        .height("65%")

                    }
                    .onClick(() => {
                      this.ncs.url =
                        "https://portal.dlut.edu.cn/tp_core/h5?act=sys/uacm/profileResetPwd&filter=app&from=rj"
                      this.ncs.name = "修改密码"
                      this.pathStack.pushPathByName("web", this.ncs);
                    })
                    .width(80).height(80).backgroundColor($r('app.color.background'))

                    Text("修改密码").margin({ top: "1%" })
                      .fontSize(15)
                      .fontColor($r('app.color.text'))
                  }

                  Column() {
                    Button({ type: ButtonType.Circle, stateEffect: true }) {
                      Image($rawfile("icon_mine_card.png"))
                        .height("50%")
                    }
                    .onClick(() => {
                      this.pathStack.pushPath({ name: "个人证件" })
                    })
                    .width(80).height(80).backgroundColor($r('app.color.background'))

                    Text("个人证件").margin({ top: "1%" })
                      .fontSize(15)
                      .fontColor($r('app.color.text'))
                  }.margin({ left: "8%" })

                  Column() {
                    Button({ type: ButtonType.Circle, stateEffect: true }) {
                      Image($rawfile("icon_mine_user_info.png"))
                        .borderRadius(35)
                        .height("70%")
                    }
                    .onClick(() => {
                      this.pathStack.pushPath({ name: "个人资料" })
                    })
                    .width(80).height(80).backgroundColor($r('app.color.background'))

                    Text("个人资料").margin({ top: "1%" })
                      .fontSize(15)
                      .fontColor($r('app.color.text'))
                  }.margin({ left: "8%" })
                }.margin({ bottom: "3%" })

              }

              ListItem() {
                Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.End }) {
                  Column() {
                    Button({ type: ButtonType.Circle, stateEffect: true }) {
                      Image($rawfile("icon_mine_setting.png"))
                        .borderRadius(35)
                        .height("50%")
                        .width("50%")
                    }
                    .onClick(() => {
                      this.pathStack.pushPath({ name: "设置" })
                    })
                    .width(80).height(80).backgroundColor($r('app.color.background'))

                    Text("设置").margin({ top: "1%" })
                      .fontSize(15)
                      .fontColor($r('app.color.text'))
                  }

                  Column() {
                    Button({ type: ButtonType.Circle, stateEffect: true }) {
                      Image($rawfile("icon_mine_school_c_parent.png"))
                        .height("50%")
                    }
                    .onClick(() => {
                      this.ncs.url = "https://apps-xiaoyuan.m.dlut.edu.cn/explain"
                      this.ncs.name = "家校通"
                      this.pathStack.pushPathByName("web", this.ncs);
                    })
                    .width(80).height(80).backgroundColor($r('app.color.background'))

                    Text("家校通").margin({ top: "1%" })
                      .fontSize(15)
                      .fontColor($r('app.color.text'))
                  }.margin({ left: "8%" })

                  Column() {
                    Button({ type: ButtonType.Circle, stateEffect: true }) {
                      Image($rawfile("icon_mine_about.png"))
                        .borderRadius(35)
                        .height("50%")
                    }
                    .onClick(() => {
                      this.pathStack.pushPath({ name: "作者信息" })
                    })
                    .width(80).height(80).backgroundColor($r('app.color.background'))

                    Text("联系我们").margin({ top: "1%" })
                      .fontSize(15)
                      .fontColor($r('app.color.text'))
                  }.margin({ left: "8%" })
                }.margin({ bottom: "3%" })

              }
            }
            .listDirection(Axis.Vertical)
            .backgroundColor($r('app.color.background')).padding(20)
          }
        }.tabBar(BottomTabBarStyle.of($rawfile("icon_service_social.png"),"个人中心").labelStyle({font:{size:13}}))
        .align(Alignment.Top)

      }
      .vertical(this.curBp === 'lg' && this.useragent == true)
    }
    .mode(this.useragent?NavigationMode.Stack:NavigationMode.Auto)
    .navDestination(this.PageMap)
    .hideToolBar(true)
    .hideTitleBar(true)
    .hideNavBar(false)
    .navBarWidth('50%')
    .backgroundColor($r('app.color.background'))
  }
  onBackPress() {
    let context   = getContext(this) as common.UIAbilityContext
    context.terminateSelf()
    return true
  }
  onPageShow() {

    this.setImmersive();

  }
}

@Component
struct ChildItem {
  @Prop item: number;
  @Link pathStack:NavPathStack;
  @Link ncs:mnv ;

  build() {
    Column() {
      Button({ type: ButtonType.Circle, stateEffect: true }) {
          Image(appList[this.item].icon)
            .borderRadius(25)
            .height(45)
            .width(45)
      }
      .onClick(() => {
        this.ncs.accounts = account
        this.ncs.passwords = password
        this.ncs.name = appList[this.item].app_name
        this.ncs.url = appList[this.item].url
        this.pathStack.pushPathByName("web", this.ncs);

      })
      .backgroundColor($r('app.color.background'))
      Text(appList[this.item].app_name).margin({ top: "10%" })
        .fontSize(11)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text'))

    }.margin({ left: "2%" ,right:"2%"})
    .height(70)
    .width(70)
  }

}


