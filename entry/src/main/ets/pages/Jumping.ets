import { router, window } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import {responsebean} from "./utils/ResponseBean"
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
        .size({ width: '100%', height: '100%' })
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
    this.setImmersive();
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
      router.pushUrl({
        url: 'pages/Navigators',
        params:{
          id1:password,
          id2:account,
          id4:mnvc,
          id5:dcz.data.verify
        }
      },router.RouterMode.Standard,
      ).then(() => {
      }).catch((err: BusinessError) => {
        console.error(`无法跳转到第二页。错误码为${err.code}, 错误消息 ${err.message}`);
      });
    })

  }

  /**
   * 页面销毁时，清除定时器
   */
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