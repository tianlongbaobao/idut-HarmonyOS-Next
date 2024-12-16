# **原生鸿蒙i大工社区版**

## **目前版本2.4.0**

**效果图展示**

<img src="https://github.com/tianlongbaobao/idut-HarmonyOS-Next/blob/2.0.0/demo/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20241130182420.jpg" width="210px"><img src="https://github.com/tianlongbaobao/idut-HarmonyOS-Next/blob/2.0.0/demo/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20241130182436.jpg" width="210px"><img src="https://github.com/tianlongbaobao/idut-HarmonyOS-Next/blob/2.0.0/demo/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20241130182452.jpg" width="210px"><img src="https://github.com/tianlongbaobao/idut-HarmonyOS-Next/blob/2.1.0/demo/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20241201154854.jpg" width="210px"><img src="https://github.com/tianlongbaobao/idut-HarmonyOS-Next/blob/2.1.0/demo/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20241201155120.jpg" width="210px"><img src="https://github.com/tianlongbaobao/idut-HarmonyOS-Next/blob/2.4.0/demo/screenshot_20241213_091940.jpg" width="210px"><img src="https://github.com/tianlongbaobao/idut-HarmonyOS-Next/blob/2.4.0/demo/screenshot_20241213_090733.jpg" width="210px"><img src="https://github.com/tianlongbaobao/idut-HarmonyOS-Next/blob/3.0.0/demo/screenshot_20241216_145643.jpg" width="210px"><img src="https://github.com/tianlongbaobao/idut-HarmonyOS-Next/blob/3.0.0/demo/screenshot_20241216_145807.png" width="210px"><img src="https://github.com/tianlongbaobao/idut-HarmonyOS-Next/blob/3.0.0/demo/screenshot_20241216_152236.jpg" width="210px">


## **致谢&后续版本维护**
<img src="https://github.com/tianlongbaobao/idut-HarmonyOS-Next/blob/2.0.0/demo/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20241130183925.jpg" width="210px">

## **版本历史**
### **1.0.0版：**

**鸿蒙原生i大工社区版1.0.0来了！**

主要功能：访问日常校内常用服务项目

目前已支持：

1.玉兰卡/网/电费充值，玉兰卡余额查看

2.图书馆/体育场馆/公共资源/校外人员预约

3.查看课表/图书馆文献检索

技术栈：webapp，将各个项目包装成webview的形式进行app内部访问。

注意：大部分服务需要校园网环境！！！

### **1.2.0版**

1.支持登录联网验证

2.未支持登录验证码二次验证和服务自登录（后续实现）

**再次感谢[@Shirai_Kuroko](https://github.com/IShiraiKurokoI)大佬贡献的源码！！！**

另，部分加密算法和服务器端口信息已经隐去，编译时会缺失文件而无法自行编译。希望自行编译和进行二次开发的请用邮箱联系我(luzhiyi@mail.dlut.edu.cn)，并提供dut在读证明(android的java源码请联系[@Shirai_Kuroko](https://github.com/IShiraiKurokoI)，鸿蒙的arkts源码可以联系我！)

### **1.6.0版**
**此版已经可以正常使用**

1.重新引入i大工的app服务模块

2.各个app支持自动认证登录（会有登录填充账密动画，页面渲染后js脚本注入实现）

3.bug:登录联网验证有bug，概率较大账密正确不能通过验证，概率性存储账密错误（后续无法完成自动登录），目前正在多侧排查，系统端arkts已经发现bug，暂时无法解决（13API，107，110和111版本），请等待后续版本更新。

建议:多登录几次，同时在登录错误次数>3时会有验证码二次验证，请打开安卓模拟器安装i大工进行验证归零次数。为规避bug影响，不设立退出账号功能，一旦登录成功，除非卸载重装，只会有一个账号。

#### **1.6.2版**

修复了玉兰卡模块打不开的bug（i大工服务未能正确识别arkweb），但无法扫一扫（和andriod和ios机制差异过大），无法跳转微信支付宝充值（后续会接入微信支付宝的openharmonysdk）

#### **1.6.0版后记**

目前i大工社区版已经能满足日常使用，鉴于后期会有i大工的官方正式版，之后的开发将在这个版本上小修小改。

### **1.8.0版**

1.玉兰卡模块充值部分接入支付宝/微信的openharmonysdk，实现方法，url拦截，支付宝接Pay端口，微信通过Deep linking拉起url scheme

2.增加和优化部分app服务

3.bug：app功能不适配

  原因：i大工目前app实现方法均为webview，这些webview均仅以android和ios接口设计，错拉起或无法拉起鸿蒙api

  目前排查到app服务不适配如下：

  (1)图书馆系统无法打开(未知)

  (2)玉兰卡->照片采集->上传照片->拍摄：提示i大工版本过低，而在选择同个界面的相册的时候可以拉起鸿蒙的拍摄，相册这两个功能。

#### **1.8.2版**

1.修复了图书馆预约的bug，同时已经为今后的扫一扫接入了相机权限。

2.查证了登录联网验证的bug，初步判定是请求次数过多，请求间隔过短导致的认证失败（i大工服务器肯定没有想到会有1s发2~3次请求），其次加密算法arkts可能会存在问题（此为cryptojs和cryptoFramework适配的问题，无法解决，请等待版本更新）

### **2.0.0版**

UI界面大改动，增加退出账号功能

### **2.1.0版**

1.修复了网络自助的bug

2.支持验证码二次验证，但是bug(登录联网验证有bug，概率较大账密正确不能通过验证，概率性存储账密错误)仍存在未能解决，**只是现在不需要一台安卓设备了。使用方法：如果你确定你的账密没问题而提示账号或密码错误时请重新输入，直到验证成功**

bug:玉兰卡虚拟卡支付未知错误(一直存在，刚发现)
#### **2.1.2版**

修复了已知的bug，目前已经定位到扫一扫的问题。**由于作者已到期末周，且这部分比较多需要重构代码，请耐心等待**，详情请看Discussion

### **2.4.0版**

1.支持扫一扫。实现方法：jsbridge，原生鸿蒙javascriptproxy和runjavascript，借用i大工安卓端的jsbridge，拉起原生鸿蒙系统级scan kit

2.修复虚拟卡无法支付的bug

3.照片采集的拍摄提示版本过低为i大工服务器后端的未适配鸿蒙next，目前鸿蒙next不允许app接管相机权限，i大工后端仍选择向系统接管相机权限

#### **2.4.0版后记**

此版所有服务均可正常使用，如果有其它app服务需求请提Issue，i大工社区版正式进入运维阶段。

## **运维阶段**

1.优化代码逻辑，规范代码格式。由于作者不是专业软件开发者，代码逻辑几乎没有，后期会优化且规范代码，减少耗电量，优化进程。

2.UI界面优化，目前UI界面的开发只在作者开发机pura70pro+测试，不清楚其它设备的UI适配情况 也请使用的其它机型提Issue

3.app服务的增加，后期将添加更多app服务

## **社区版相对于正式版的区别：**

1.上述bug问题

2.目前只有app服务模块，积分/消息/家校/更新均无

3.UI界面

**作者的能力和知识水平有限，欢迎各位大佬进行二次开发！**

## **使用方法：**
1.下载DevEco Studio

2.Project Structure进行自签名

3.有线调试，无线调试或hap包自签名

**此与i大工官方版无关，由校内独立开发者开发，方便在鸿蒙NEXT上使用相关服务，仅供交流！**


