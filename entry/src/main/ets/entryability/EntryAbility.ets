import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Router, window } from '@kit.ArkUI';
import { UIContext } from '@kit.ArkUI'
import { router } from '@kit.ArkUI';
import dataPreferences from '@ohos.data.preferences';

export default class EntryAbility extends UIAbility {
  funcAbilityWant: Want | undefined = undefined;
  uiContext: UIContext | undefined = undefined;
  private selectPage: string = '';
  private currentWindowStage: window.WindowStage | null = null;

  goToSpecifyPage(want: Want) {
    let shortCutKey = want.parameters?.shortCutKey;
    if (this.uiContext && shortCutKey && shortCutKey === 'CompanyPage') {
       shortCutKey = ""
      let router: Router = this.uiContext.getRouter();
      dataPreferences.getPreferences(this.context, "information").then(preferences=> {
        preferences.get("account", 'default').then((value) => {
          preferences.get("password","default").then((ljc) => {
            router.pushUrl({
              url: 'pages/Vcard',
              params:{
                id1:ljc,
                id2:value}
            })
          })
        })
      })

    } else  if (this.selectPage =="class"){
      this.selectPage=""
      dataPreferences.getPreferences(this.context, "information").then(preferences=> {
        preferences.get("account", 'default').then((value) => {
          preferences.get("password","default").then((ljc) => {
            router.pushUrl({
              url: 'pages/Classes',
              params:{
                id1:ljc,
                id2:value}
            })
          })
        })
      })

    }
  }
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // Receive the parameters passed by UIAbility from the caller
    console.log("1")
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onNewWant');
    if (want?.parameters?.params) {
      // want.parameters.params 对应 postCardAction() 中 params 内容
      let params: Record<string, Object> = JSON.parse(want.parameters.params as string);
      this.selectPage = params.targetPage as string;
    }
    this.goToSpecifyPage(want);
  }
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    if (want?.parameters?.params) {
      // want.parameters.params 对应 postCardAction() 中 params 内容
      let params: Record<string, Object> = JSON.parse(want.parameters.params as string);
      this.selectPage = params.targetPage as string;
    }
    let shortCutKey = want.parameters?.shortCutKey;
    if (shortCutKey === 'CompanyPage'){
      this.selectPage = "vcard"
    }

  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    dataPreferences.getPreferences(this.context, "information").then(preferences=>{
      preferences.get("account",'default').then((value)=>{
        let path: string | undefined = 'page/Index';
        if (this.funcAbilityWant?.parameters?.shortCutKey === 'CompanyPage') {
          path = 'pages/Vcard';
        }
        if (value == 'default') {
          path = "pages/Index"
        } else  {
          switch (this.selectPage) {
            case 'class':
              path = 'pages/Classes';
              this.selectPage = ""
              break;
            case 'vcard':
              path = 'pages/Vcard';
              this.selectPage = ""
              break;
            default:
              path = 'pages/Jumping';
          }
        }
        console.log(this.selectPage)
        windowStage.loadContent(path, (err) => {
          if (err.code) {
            hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
            return;
          }
          hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');

          let windowClass: window.Window;
          windowStage.getMainWindow((err, data) => {
            if (err.code) {
              hilog.error(0x0000, 'testTag',
                `Failed to obtain the main window. Code is ${err.code},message is ${err.message}`);
            }
            windowClass = data;
            this.uiContext = windowClass.getUIContext();
          })
        });
      })
    })


  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

}