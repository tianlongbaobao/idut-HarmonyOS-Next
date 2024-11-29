## **原生鸿蒙i大工社区版**

### **1.0.0版：**

**鸿蒙原生i大工社区版1.0.0来了！**

主要功能：

访问日常校内常用服务项目

目前已支持：

玉兰卡/网/电费充值，玉兰卡余额查看

图书馆/体育场馆/公共资源/校外人员预约

查看课表/图书馆文献检索

技术栈：webapp，将各个项目包装成webview的形式进行app内部访问。

注意：大部分服务需要校园网环境！！！

### **1.2.0版**

支持登录联网验证

未支持登录验证码二次验证和服务自登录（后续实现）

再次感谢@Shirai_Kuroko:https://github.com/IShiraiKurokoI    大佬贡献的源码！！！

另，部分加密算法和服务器端口信息已经隐去，编译时会缺失文件而无法自行编译。希望自行编译和进行二次开发的请用邮箱联系我（luzhiyi@mail.dlut.edu.cn），并提供dut在读证明（
android的java源码请联系@Shirai_Kuroko，鸿蒙的arkts源码可以联系我！）

### **1.6.0版**
**此版已经可以正常使用**

1.重新引入i大工的app服务模块

2.各个app支持自动认证登录（会有登录填充账密动画，页面渲染后js脚本注入实现）

3.bug:登录联网验证有bug，概率较大账密正确不能通过验证，概率性存储账密错误（后续无法完成自动登录），目前正在多侧排查，系统端arkts已经发现bug，暂时无法解决（13API，107，110和111版本），请等待后续版本更新。

建议:
多登录几次，同时在登录错误次数>3时会有验证码二次验证，请打开安卓模拟器安装i大工进行验证归零次数。为规避bug影响，不设立退出账号功能，一旦登录成功，除非卸载重装，只会有一个账号。

#### **1.6.2版**
修复了玉兰卡模块打不开的bug（i大工未能正确识别arkweb），但无法扫一扫（和andriod和ios机制差异过大），无法跳转微信支付宝充值（后续会接入微信支付宝的openharmonysdk）

### **1.6.0版后记**

目前i大工社区版已经能满足生活使用，鉴于后期会有i大工的官方正式版，之后的开发将在这个版本上小修小改。

### **1.8.0版**

玉兰卡模块接入支付宝/微信的openharmonysdk，扫一扫功能确认服务器没有端口，需等正式版

### **社区版相对于正式版的区别：**

1.上述bug问题

2.目前只有app服务模块，积分/消息/家校/更新均无

3.UI界面简陋，主界面只有一列服务app的button

**由于作者的能力和知识水平有限，3，4均无法开发。欢迎各位大佬进行二次开发！**

## **使用方法：**
1.下载DevEco Studio

2.Project Structure进行自签名

3.有线调试，无线调试或hap包自签名

**此与i大工正式版无关，由校内独立开发者开发，方便在鸿蒙NEXT上使用相关服务，仅供交流！**
