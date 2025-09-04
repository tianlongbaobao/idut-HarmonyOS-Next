import dataPreferences from '@ohos.data.preferences';
import deviceinfo from '@ohos.deviceInfo';
import { common, ConfigurationConstant } from '@kit.AbilityKit';
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
import { webpage } from './app/webpage';
import { getnoticehistory } from './backrequest/NoticeHistory';
import { relationalStore } from '@kit.ArkData';
import { taskpool } from '@kit.ArkTS';
import { queryall } from './utils/db';
import { NoticeContentBean } from './utils/NoticeContentbean';
import { appupdate } from './backrequest/galleryupdate';
import { DetailDialog } from './app/detaildia';


const  account:string = (router.getParams() as Record<string, string>)['id2'];
const  password:string = (router.getParams() as Record<string, string>)['id1'];
const  pasz:string = (router.getParams() as Record<string, string>)['id4'];
let gallery:string = (router.getParams() as Record<string, string>)['id6'];
let  isnoaccount:string = (router.getParams() as Record<string, string>)['id7'];

interface mnv {
  accounts: string
  passwords: string
  url:string
  name:string
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
  @State swiperData: string[] = []
  @State swiperurl:string[] = []
  @State idc: number = 0
  @State darkmode:boolean = false
  @State useragent:boolean = false
  @State nologin:boolean = false
  private Tabcontroller: TabsController = new TabsController();
  private swiperController: SwiperController = new SwiperController()
  private scroller: Scroller = new Scroller();
  @State noaccount:string = isnoaccount
  @State swiperindex:number = 0
  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentColorMode: number =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  @Provide('pathInfos') pathStack: NavPathStack = new NavPathStack();
  @StorageProp('currentBreakpoint') curBp: string = 'sm';
  @State nav:NavigationMode = NavigationMode.Auto
  private  servicetab:TabsController = new TabsController()
  @State ncs:mnv = {
    passwords:password,
    accounts:account,
    url:"",
    name:""
  }
  @State notice:Array<relationalStore.ValuesBucket> = []
  @State devicety:string = ""
  @StorageLink('currentWidthBreakpoint') windowWidth: number = 0;
  @StorageLink('currentHeightBreakpoint') windowHeight: number = 0;
  private searchcontroller: SearchController = new SearchController()
  @State changeValue:string = ""
  @State applist:number[] = []
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
  noticetrans(item:relationalStore.ValuesBucket):NoticeContentBean[]{
    console.log(decodeURIComponent(`${item.CONTENT}`))
    let noticecontent:NoticeContentBean[] = JSON.parse(decodeURIComponent(`${item.CONTENT}`))
    return noticecontent
  }
  timetrans(item:relationalStore.ValuesBucket):string{
    let noticecontentdate = new Date(Number(`${item.TIME}`)*1000)
    const year = noticecontentdate.getFullYear();
    const month = (noticecontentdate.getMonth() + 1).toString().padStart(2, '0');
    const day = noticecontentdate.getDate().toString().padStart(2, '0');
    const hours = noticecontentdate.getHours().toString().padStart(2, '0');
    const minutes = noticecontentdate.getMinutes().toString().padStart(2, '0');
    const seconds = noticecontentdate.getSeconds().toString().padStart(2, '0');
    let datestr:string=`${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
    return datestr
  }
  async aboutToAppear(): Promise<void> {
    let deviceTypeInfo: string = deviceinfo.deviceType;
    this.devicety = deviceTypeInfo
    let paszl = pasz.split(",")
    let mn = 0
    for (let index = 0; index < paszl.length; index++) {
      if (paszl[index]!=",") {
        this.appll[mn] = Number(paszl[index])
        mn=mn+1
      }
    }
    for (let index = 0;index < appList.length;index++){
      this.applist[index] = index
    }
    appupdate()
    dataPreferences.getPreferences(context, "information").then(preferences=>{
      preferences.putSync("noaccount",this.noaccount)
      preferences.get("data",'default').then((value)=>{
        let data_c:responsebean = JSON.parse(String(value))
        this.nickname = data_c.data.my_info.nick_name
        this.head = data_c.data.my_info.head
        if (this.nologin == false || this.noaccount == "1") {
          getnoticehistory(data_c.data.my_info.identity,data_c.data.my_info.student_number,data_c.data.verify,data_c.data.my_info.user_id)
        }

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
      preferences.flush()
    }).catch((err:Error)=>{

    })
    if (this.nologin == false && this.noaccount == "0") {
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
      this.notice = await taskpool.execute(queryall, context) as Array<relationalStore.ValuesBucket>
    }


  }
  @Builder
  PageMap(name: string) {
    if (name === "web"){
      webpage({darkmode:this.darkmode,vsf:this.ncs,useragent:this.useragent,noaccount:this.noaccount})
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
  @Builder
  deleteItemAction(value: relationalStore.ValuesBucket) {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center })  {
      Image($r("app.media.delete"))
          .height(25)
      .onClick(() => {
        this.notice = this.notice.filter(item => item !== value)
        const STORE_CONFIG: relationalStore.StoreConfig= {
          name: 'message.db', // 数据库文件名
          securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
          encrypt: false,
          isReadOnly: false
        };
        relationalStore.getRdbStore(context, STORE_CONFIG, (err, store) => {
          const valueBucket: relationalStore.ValuesBucket = {
            'MSGID': `${value.MSGID}`,
            'TIME': `${value.TIME}`,
            'APPID': `${value.APPID}`,
            'ISREAD': 1,
            'TITLE': `${value.TITLE}`,
            'CONTENT': `${value.CONTENT}`
          };
          let predicates = new relationalStore.RdbPredicates("NOTICE")
          predicates.equalTo("MSGID", `${value.MSGID}`)
          store.update(valueBucket, predicates, (err: BusinessError, rows: number) => {
            if (err) {
              console.info("Updated failed, err: " + err)
              return
            }
            console.log("Updated row count: " + rows)
          })
        })
      })
    }
  }


  build() {
    Navigation(this.pathStack) {
      Tabs({ barPosition: BarPosition.End, controller: this.Tabcontroller }) {
        TabContent() {
          Column() {
            RelativeContainer() {
              Row() {
                Text("我的服务")
                  .fontWeight(FontWeight.Bold)
                  .fontSize(20)
                  .fontColor($r('app.color.text'))
              }

              .alignRules({
                'center': { 'anchor': '__container__', 'align': VerticalAlign.Center },
                'middle': { 'anchor': '__container__', 'align': HorizontalAlign.Center }
              })
              if (this.devicety != "2in1" && this.devicety!="tv") {
                Row() {
                  Select([{ value: '扫一扫', icon: $rawfile("scancode.png") },
                    { value: '虚拟卡', icon: $rawfile("vcard.png") }])
                    .selected(this.index)
                    .value("+")
                    .fontColor($r('app.color.text'))
                    .width("15%")
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
                .padding({right:"3%"})
              }
            }
            .height("7%")
            .margin({top:"3%"})
            List({ space: 7 }) {
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
                      if (this.swiperurl[this.swiperindex] != "") {
                        this.ncs.accounts = account
                        this.ncs.passwords = password
                        this.ncs.name = "轮播图"
                        this.ncs.url = this.swiperurl[this.swiperindex]
                        this.pathStack.pushPathByName("web", this.ncs);
                      }

                    }

                  })
                }
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
                  .height(35)
                  .width("80%")
                  .margin({ top: "5%" })
                  .padding({left:"8%",right:"8%"})
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
            .backgroundColor($r('app.color.background')).padding({ top: 20, bottom: 20 })
            .layoutWeight(1)
          }
        }
        .tabBar(BottomTabBarStyle.of($rawfile("icon_service_life.png"),"我的服务").labelStyle({font:{size:13}}))
        .align(Alignment.Top)
        TabContent() {
          Column() {
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Text("消息通知")
                .fontWeight(FontWeight.Bold)
                .fontSize(20)
                .fontColor($r('app.color.text'))
            }
            .height("7%")
            .margin({top:"3%"})
            List({ initialIndex:this.notice.length , space: 7, scroller: this.scroller }) {
              ForEach(this.notice, (item: relationalStore.ValuesBucket) => {
                if (Number(`${item.ISREAD}`) == 0) {
                  ListItem() {
                    Column() {
                      Flex({
                        direction: FlexDirection.Row,
                        justifyContent: FlexAlign.Center,
                        alignItems: ItemAlign.Center
                      }) {
                        Text(this.timetrans(item))
                          .fontSize(12)
                      }.margin({ top: "8%" })

                      ForEach(this.noticetrans(item), (noticesi: NoticeContentBean) => {
                        Column() {
                          Flex({
                            direction: FlexDirection.Row,
                            alignItems: ItemAlign.Start
                          }) {
                            Text(noticesi.title)
                              .fontSize(15)
                              .fontColor($r('app.color.text'))
                          }
                          .margin({ top: "5%", right: "5%", left: "5%" })

                          if (noticesi.description.length != 0 && noticesi.description != "++") {
                            Flex({
                              direction: FlexDirection.Row,
                              alignItems: ItemAlign.Start
                            }) {
                              Text(noticesi.description)
                                .fontSize(10)
                                .fontColor($r('app.color.text'))
                            }
                            .margin({
                              top: "5%",
                              right: "5%",
                              left: "5%",
                              bottom: "2%"
                            })

                          }
                          if (noticesi.picurl != null) {
                            Image(noticesi.picurl)
                              .width("90%")
                              .constraintSize({ maxHeight: 200 })
                              .margin({
                                top: "2%",
                                right: "5%",
                                left: "5%",
                                bottom: "2%"
                              })
                          }
                        }
                        .backgroundColor($r("app.color.information"))
                        .borderWidth(1)
                        .borderRadius(15)
                        .borderColor($r("app.color.tab"))
                        .margin({ top: "2%", right: "2%", left: "2%" })
                        .onClick(() => {
                          if (noticesi.url != "") {
                            this.ncs.accounts = account
                            this.ncs.passwords = password
                            this.ncs.name = "消息通知"
                            this.ncs.url = noticesi.url
                            this.pathStack.pushPathByName("web", this.ncs);
                          }
                        })
                      })


                    }

                  }
                  .swipeAction({
                    end: {
                      builder: () => {
                        this.deleteItemAction(item)
                      },
                      actionAreaDistance: '56vp'
                    },
                    edgeEffect: SwipeEdgeEffect.None
                  })
                }
              })
            }
            .onAppear(()=>{
              this.scroller.scrollEdge(Edge.Bottom)
            })
            .listDirection(Axis.Vertical)
            .backgroundColor($r('app.color.background')).padding(20)
            .layoutWeight(1)
          }
        }.tabBar(BottomTabBarStyle.of($rawfile("icon_service_office.png"),"消息通知").labelStyle({font:{size:13}}))
        .align(Alignment.Top)
        TabContent(){
          Column(){
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Text("服务大厅")
                .fontWeight(FontWeight.Bold)
                .fontSize(20)
                .fontColor($r('app.color.text'))
            }
            .height("7%")
            .margin({top:"3%"})
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }){
              Search({ value: this.changeValue, placeholder: '搜索', controller: this.searchcontroller })
                .width('95%')
                .height(40)
                .placeholderFont({ size: 14, weight: 400 })
                .textFont({ size: 14, weight: 400 })
                .onChange((value: string) => {
                  this.changeValue = value.trim()
                })
                .margin({top:20})
            }
            .height("8%")
            Tabs({ barPosition: BarPosition.Start, controller: this.servicetab }) {
              TabContent() {
                  Column() {
                    Scroll(this.scroller) {
                      Flex({
                        justifyContent: FlexAlign.Start,
                        alignItems: ItemAlign.Start,
                        direction: FlexDirection.Column
                      }) {
                        ForEach(this.applist, (item: number) => {
                          if (appList[item].app_name.includes(this.changeValue)) {
                            APPItem({ item: item,pathStack: this.pathStack, ncs: this.ncs })
                              .margin({ top: 15 })
                              .width("100%")
                          }
                        })
                      }
                    }
                  }.height("100%")
              }.tabBar(SubTabBarStyle.of("全部"))

              TabContent() {
                Column() {
                  Scroll() {
                    Flex({
                      justifyContent: FlexAlign.Start,
                      alignItems: ItemAlign.Start,
                      direction: FlexDirection.Column
                    }) {
                      ForEach(this.applist, (item: number) => {
                        if (appList[item].category == "study") {
                          if (appList[item].app_name.includes(this.changeValue)) {
                            APPItem({ item: item , pathStack: this.pathStack, ncs: this.ncs})
                              .margin({ top: 15 })
                              .width("100%")
                          }
                        }

                      })

                    }
                  }
                }.height("100%")
              }.tabBar(SubTabBarStyle.of("学习"))
              TabContent() {
                Column() {
                  Scroll() {
                    Flex({
                      justifyContent: FlexAlign.Start,
                      alignItems: ItemAlign.Start,
                      direction: FlexDirection.Column
                    }) {
                      ForEach(this.applist, (item: number) => {
                        if (appList[item].category == "life") {
                          if (appList[item].app_name.includes(this.changeValue)) {
                            APPItem({ item: item, pathStack: this.pathStack, ncs: this.ncs })
                              .margin({ top: 15 })
                              .width("100%")
                          }
                        }

                      })

                    }
                  }
                }.height("100%")
              }.tabBar(SubTabBarStyle.of("生活"))
              TabContent() {
                Column() {
                  Scroll() {
                    Flex({
                      justifyContent: FlexAlign.Start,
                      alignItems: ItemAlign.Start,
                      direction: FlexDirection.Column
                    }) {
                      ForEach(this.applist, (item: number) => {
                        if (appList[item].category == "office") {
                          if (appList[item].app_name.includes(this.changeValue)) {
                            APPItem({ item: item , pathStack: this.pathStack, ncs: this.ncs})
                              .margin({ top: 15 })
                              .width("100%")
                          }
                        }

                      })

                    }
                  }
                }.height("100%")
              }.tabBar(SubTabBarStyle.of("工作"))
              TabContent() {
                Column() {
                  Scroll() {
                    Flex({
                      justifyContent: FlexAlign.Start,
                      alignItems: ItemAlign.Start,
                      direction: FlexDirection.Column
                    }) {
                      ForEach(this.applist, (item: number) => {
                        if (appList[item].category == "life") {
                          if (appList[item].app_name.includes(this.changeValue)) {
                            APPItem({ item: item, pathStack: this.pathStack, ncs: this.ncs })
                              .margin({ top: 15 })
                              .width("100%")
                          }
                        }

                      })

                    }
                  }
                }
                .height("100%")
              }.tabBar(SubTabBarStyle.of("生活"))
              TabContent() {
                Column() {
                  Scroll() {
                    Flex({
                      justifyContent: FlexAlign.Start,
                      alignItems: ItemAlign.Start,
                      direction: FlexDirection.Column
                    }) {
                      ForEach(this.applist, (item: number) => {
                        if (appList[item].category == "social") {
                          if (appList[item].app_name.includes(this.changeValue)) {
                            APPItem({ item: item, pathStack: this.pathStack, ncs: this.ncs })
                              .margin({ top: 15 })
                              .width("100%")
                          }
                        }

                      })

                    }
                    .constraintSize({ minHeight: '100%' })
                  }
                }.height("100%")
              }.tabBar(SubTabBarStyle.of("社交"))
              TabContent() {
                Column(){
                  Scroll() {
                    Flex({
                      justifyContent: FlexAlign.Start,
                      alignItems: ItemAlign.Start,
                      direction: FlexDirection.Column
                    }) {
                      ForEach(this.applist, (item: number) => {
                        if (appList[item].category == "fun") {
                          if (appList[item].app_name.includes(this.changeValue)) {
                            APPItem({ item: item , pathStack: this.pathStack, ncs: this.ncs})
                              .margin({ top: 15 })
                              .width("100%")
                          }
                        }

                      })

                    }
                  }
                }.height("100%")
              }.tabBar(SubTabBarStyle.of("游戏"))
              .height("100%")
            }
            .layoutWeight(1)
            .scrollable(true)

          }
          .padding(5)
        }.tabBar(BottomTabBarStyle.of($rawfile("icon_service_all.png"),"服务大厅").labelStyle({font:{size:13}}))
        .align(Alignment.Top)

        TabContent() {
          Column() {
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Text("工具箱")
                .fontWeight(FontWeight.Bold)
                .fontSize(20)
                .fontColor($r('app.color.text'))
            }
            .height("7%")
            .margin({top:"3%"})
            List({ space: 7 }) {
              ListItem() {
                Column() {
                  if (this.devicety == "2in1" || this.devicety == "tablet" || this.devicety == "tv") {
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
                      Text("关闭轮播图和消息通知")
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

                  if (this.devicety != "2in1"&& this.devicety!="tv") {
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
                            .syncLoad(true)
                        } else {
                          Image($rawfile("deleted.png"))
                            .height(20)
                            .syncLoad(true)
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
                    Text("校园门户")
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
                    Text("免验证码进入")
                      .margin({ right: "3%" })
                      .fontSize(16)
                      .fontColor($r('app.color.text'))
                    Button('打开', { type: ButtonType.Capsule, stateEffect: false })
                      .fontSize(13)
                      .height(25)
                      .margin({ left: "43%" })
                      .onClick((event) => {
                        this.ncs.accounts = account
                        this.ncs.passwords = password
                        this.ncs.name = "校园门户"
                        this.ncs.url = "https://portal.dlut.edu.cn/"
                        this.pathStack.pushPathByName("web", this.ncs);
                      })
                  }
                  .borderRadius(20)
                  .backgroundColor($r("app.color.information"))
                  .height(50)
                  .margin({ top: "5%" })
                  Row() {
                    Text("校园网（开发区校区）")
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
                    Text("监控面板")
                      .margin({ right: "3%" })
                      .fontSize(16)
                      .fontColor($r('app.color.text'))
                    Button('打开', { type: ButtonType.Capsule, stateEffect: false })
                      .fontSize(13)
                      .height(25)
                      .margin({ left: "50%" })
                      .onClick((event) => {
                        this.ncs.accounts = account
                        this.ncs.passwords = password
                        this.ncs.name = "校园网状态监控"
                        this.ncs.url = "http://172.20.30.3/"
                        this.pathStack.pushPathByName("web", this.ncs);
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

                  if (this.devicety == "2in1" || this.devicety == "tablet" || this.devicety == "tv") {
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
            .layoutWeight(1)
          }

        }.tabBar(BottomTabBarStyle.of($rawfile("icon_service_study.png"),"工具箱").labelStyle({font:{size:13}}))
        .align(Alignment.Top)
        TabContent() {
          Column(){
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Text("个人中心")
                .fontWeight(FontWeight.Bold)
                .fontSize(20)
                .fontColor($r('app.color.text'))
            }
            .height("7%")
            .margin({top:"3%"})
            List({ space: 7 }) {
              ListItem() {
                Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.End }) {
                  Column() {
                    if (this.noaccount == "0") {
                      Image(this.head)
                        .height(100)
                        .borderRadius(35)
                        .fillColor($r('app.color.background'))
                        .syncLoad(true)
                      Text(this.nickname)
                        .margin({ top: "3.5%" })
                        .fontWeight(FontWeight.Bold)
                        .fontSize(17)
                        .fontColor($r('app.color.text'))
                    }else {
                      Image($rawfile("login.jpg"))
                        .height(100)
                        .borderRadius(35)
                        .fillColor($r('app.color.background'))
                      Text("访客")
                        .margin({ top: "3.5%" })
                        .fontWeight(FontWeight.Bold)
                        .fontSize(17)
                        .fontColor($r('app.color.text'))
                    }
                  }
                  .margin({ top: "5%" })
                }
              }
              if (this.noaccount == "0") {
                ListItem() {
                  Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.End }) {
                    Column() {
                      Button({ type: ButtonType.Circle, stateEffect: true }) {
                        Image($rawfile("icon_mine_setting.png"))
                          .height("50%")

                      }
                      .onClick(() => {
                        this.ncs.name = "设置"
                        this.pathStack.pushPath({ name: "设置" })
                      })
                      .width(80).height(80).backgroundColor($r('app.color.background'))

                      Text("设置").margin({ top: "1%" })
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
                          .height("50%")
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
                    }
                  }.margin({ bottom: "3%" })

                }
              } else {

                ListItem() {
                  Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.End }) {
                    Column() {
                      Button({ type: ButtonType.Circle, stateEffect: true }) {
                        Image($rawfile("icon_mine_setting.png"))
                          .height("50%")

                      }
                      .onClick(() => {
                        this.ncs.name = "设置"
                        this.pathStack.pushPath({ name: "设置" })
                      })
                      .width(80).height(80).backgroundColor($r('app.color.background'))

                      Text("设置").margin({ top: "1%" })
                        .fontSize(15)
                        .fontColor($r('app.color.text'))
                    }
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
                    }.margin({left:"12%"})
                  }.margin({ bottom: "3%"})

                }
              }
            }
            .layoutWeight(1)
            .listDirection(Axis.Vertical)
            .backgroundColor($r('app.color.background')).padding(20)
          }
        }.tabBar(BottomTabBarStyle.of($rawfile("icon_service_social.png"),"个人中心").labelStyle({font:{size:13}}))
        .align(Alignment.Top)

      }
      .scrollable(false)
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


@Component
struct APPItem{
  @Prop item:number;
  @Link pathStack:NavPathStack;
  @Link ncs:mnv ;
  dialogController: CustomDialogController = new CustomDialogController({
    builder: DetailDialog({
      img:appList[this.item].icon,
      name:appList[this.item].app_name,
      de:appList[this.item].describe
    }),
    autoCancel:true,
    cancel: ()=> { this.onCancel()},
  })


  onCancel() {
  }
  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems:ItemAlign.Center,direction: FlexDirection.Row}) {
      Row() {
        Image(appList[this.item].icon)
          .borderRadius(25)
          .height(40)
        Text(appList[this.item].app_name)
          .margin({ left: "8%" })
          .onClick(() => {
            this.dialogController.open()
          })
      }
        Button('打开', { type: ButtonType.Capsule, stateEffect: false })
          .fontSize(13)
          .height(25)
          .onClick((event) => {
            this.ncs.accounts = account
            this.ncs.passwords = password
            this.ncs.name = appList[this.item].app_name
            this.ncs.url = appList[this.item].url
            this.pathStack.pushPathByName("web", this.ncs);
          })

    }
    .padding({left:"5%",right:"5%"})
  }

}