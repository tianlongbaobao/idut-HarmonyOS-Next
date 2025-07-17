import { router, window } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import {responsebean} from "./utils/ResponseBean"
import {GetwhistleVersion,GetHeaderValueFora,GetHeaderForVersion,GetHeaderForNonce,GetHeaderForSign,GetHeaderForTimeStamp} from "./backrequest/c"
import { http } from '@kit.NetworkKit';
let context = getContext(this)
@Component
@Entry
struct Splash {
  timeId?: number; // 定时器
  @State num: number = 3; // 倒计时

  build() {
    Stack() {
      // 背景图片
      Image($rawfile('jump.png'))
        .size({ height: '100%' })
        .zIndex(-1); // 确保背景图片在最底层
      Column() {
        // 最右边显示

      }.size({ width: '100%', height: '100%' });
    }.size({ width: '100%', height: '100%' });
  }

  /**
   * 页面显示时，开始倒计时
   */
  onPageShow() {
    this.setImmersive()
    this.countDown();
  }

  /**
   * 沉浸式状态栏
   */
  private setImmersive() {
    window.getLastWindow(getContext()).then(win => {
      win.setWindowLayoutFullScreen(true);
      let area = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      let height = area.topRect.height;
      let vpheight = px2vp(height);
      AppStorage.setOrCreate('topHeight', vpheight);
      win.setWindowSystemBarProperties({ statusBarContentColor: '#ffffff' }); // 设置状态栏字体颜色
    });
  }

  /**
   * 把倒计时封装方法
   */
  private countDown() {
    let timeId = setInterval(() => {
      this.num--;
      if (this.num === 0) {
        clearInterval(this.timeId);
        this.navigateToNextPage(); // 跳转到下一页
      }
    }, 1000);
    this.timeId = timeId;
  }

  /**
   * 清除定时器并跳转下一页
   */
  private clearTimerAndNavigate() {
    clearInterval(this.timeId);
    this.navigateToNextPage();
  }

  /**
   * 跳转下一页
   */
  private navigateToNextPage() {
    preferences.getPreferences(context, 'information', (err: BusinessError, val: preferences.Preferences) => {
      if (err) {
        console.error("Failed to get preferences. code =" + err.code + ", message =" + err.message);
        return;
      }
      let dataPreferences = val;
      let value: preferences.ValueType = dataPreferences.getSync('password', 'default');
      let password = ""+value
      let values: preferences.ValueType = dataPreferences.getSync('account', 'default');
      let bvx:preferences.ValueType = dataPreferences.getSync("nowdata","default")
      let axzc:preferences.ValueType = dataPreferences.getSync("data","default")
      axzc = axzc+""
      let dcz:responsebean = JSON.parse(axzc)
      let account = ""+values
      let mnvc = ""+bvx
      if (mnvc == "default") {
        mnvc = "0"
      }
      let  url = "https://service.m.dlut.edu.cn/whistlenew/index.php?m=orginfo&a=getGallery&uid=0&student_number=" + dcz.data.my_info.student_number + "&app_version=" + GetwhistleVersion() + "&school=dlut&stu_identity=&identity=" + dcz.data.my_info.identity + "&verify=" +dcz.data.verify.replace(":", "%3A") + "&device_type=android&aid=" + dcz.data.my_info.user_id + "&platform=android&city_id=10";
      const  a = GetHeaderValueFora();
      const  timestamps = GetHeaderForTimeStamp()
      const  Timestamp = timestamps[0];
      const  LocalTimestamp = timestamps[1];
      const  Nonce = GetHeaderForNonce();
      GetHeaderForSign((url.split(/\?/))[1], Timestamp, Nonce, a)
        .then((Sign)=> {
          const httpRequest = http.createHttp();
          let promises = httpRequest.request(
            url,
            {
              method: http.RequestMethod.GET,
              connectTimeout: 60000,
              readTimeout: 60000,
              header: {
                'a': a,
                "sign": Sign,
                "local_timestamp": LocalTimestamp,
                "nonce": Nonce,
                "version": GetHeaderForVersion(),
                "timestamp": Timestamp,
                "Host": "service.m.dlut.edu.cn",
                "Connection": "Keep-Alive",
                "Cookie2": "$Version=1",
              }
            });
          promises.then((datas) => {
            if (datas.responseCode = http.ResponseCode.OK) {
              if ((datas.result).toString().includes("{\"ret\":-1,\"")) {
                dataPreferences.putSync("gallery", "null")
                router.pushUrl({
                  url: 'pages/Navigators',
                  params: {
                    id1: password,
                    id2: account,
                    id4: mnvc,
                    id5: dcz.data.verify,
                    id6: "null",
                    id7:"0"
                  }
                }, router.RouterMode.Standard,
                ).then(() => {
                }).catch((err: BusinessError) => {
                  console.error(`无法跳转到第二页。错误码为${err.code}, 错误消息 ${err.message}`);
                });

              } else {
                dataPreferences.putSync("gallery", (datas.result).toString())
                router.pushUrl({
                  url: 'pages/Navigators',
                  params: {
                    id1: password,
                    id2: account,
                    id4: mnvc,
                    id5: dcz.data.verify,
                    id6: (datas.result).toString(),
                    id7:"0"
                  }
                }, router.RouterMode.Standard,
                ).then(() => {
                }).catch((err: BusinessError) => {
                  console.error(`无法跳转到第二页。错误码为${err.code}, 错误消息 ${err.message}`);
                });
              }
            }
            else {
              AlertDialog.show(
                {
                  message: '后端服务器异常',
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
          })
        })
        .catch(()=>{
          AlertDialog.show(
            {
              message: '后端服务器未响应，请检查网络连接',
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

  }

  onDestroy() {
    this.num = 1;
    clearInterval(this.timeId);
  }
  onBackPress() {
    let context   = getContext(this) as common.UIAbilityContext
    context.terminateSelf()
    return true
  }
}