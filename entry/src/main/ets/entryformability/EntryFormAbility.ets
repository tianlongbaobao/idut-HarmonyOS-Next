import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import axios, { AxiosResponse } from '@ohos/axios';
import dataPreferences from '@ohos.data.preferences';
import {GetwhistleVersion,GetHeaderValueFora,GetHeaderForVersion,GetHeaderForNonce,GetHeaderForSign,GetHeaderForTimeStamp} from "../pages/backrequest/c"
import {courseres,course} from "../pages/utils/coursebean"
import {responsebean} from "../pages/utils/ResponseBean"
import {card,elec} from "../pages/utils/cardbean"

function removestr(str: string): string {
  let result: string = "";

  for (let i = 0; i < str.length; i++) {
    const c: string = str.charAt(i);

    // 检查字符首次和末次出现的位置
    if (str.indexOf(c) === str.lastIndexOf(c)) {
      result += c;
    } else {
      // 如果是字符的第一次出现，添加到结果中
      if (str.indexOf(c) === i) {
        result += c;
      }
    }
  }

  return result;
}

export default class EntryFormAbility extends FormExtensionAbility {
  onCreate(want: Want): formBindingData.FormBindingData {
    // Called to return a FormBindingData object.
    let formData = new Object();
    return formBindingData.createFormBindingData(formData);
  }
  async onFormEvent(formId: string, message: string): Promise<void> {
    const  a = GetHeaderValueFora();
    const  timestamps = GetHeaderForTimeStamp()
    const  Timestamp = timestamps[0];
    const  LocalTimestamp = timestamps[1];
    const  Nonce = GetHeaderForNonce();
    const requestbodystring = "app_key=20460cbb2ccf1c97&app_secret=1dcc14a227a6f8d9b37792b7b053f671&app_version=" + GetwhistleVersion() + "&grant_type=client_credentials&platform=android&scope=all";
    const  Sign = GetHeaderForSign(requestbodystring, Timestamp, Nonce, a)
    interface resp {
      access_token:string
      expires_in:string
      scope:string
      refresh_token:string
      token_type:string
    }

    axios.post('https://api.m.dlut.edu.cn/oauth/token', requestbodystring, {
      headers: {
        'a': a,
        'sign': Sign,
        'local_timestamp': LocalTimestamp,
        'nonce': Nonce,
        'version': GetHeaderForVersion(),
        'timestamp': Timestamp,
        'Host': 'service.m.dlut.edu.cn',
        'Connection': 'Keep-Alive',
        'Cookie2': '$Version=1',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    }).then((response: AxiosResponse<string>) => {
      dataPreferences.getPreferences(this.context, "information").then(preferences => {
        preferences.get("account", 'default').then((value) => {
          let jsc: resp = JSON.parse(JSON.stringify(response.data))
          let url = "https://api.m.dlut.edu.cn/lightappapi/course/get_today_course?access_token=" + jsc.access_token +
            "&app_version=" + GetwhistleVersion() + "&domain=dlut&identity=" + "student" +
            "&platform=android&student_number=" + value;
          axios<string, AxiosResponse<string>, null>({
            method: "get",
            url: url
          }).then((res: AxiosResponse) => {
            let bb :courseres = JSON.parse(JSON.stringify(res.data))
            const now: Date = new Date();
            const hours: number = now.getHours();
            let cc:course[] =[];
            let  i = 0;
            for (let index = 0; index < bb.data.length; index++) {
              if (Number(bb.data[index].event_begintime.split(":")[0])>=hours) {
                cc[i] = bb.data[index]
                i++
              }
            }
            let classes1name:string =  '1'
            try {
              classes1name =  JSON.stringify(cc[0].course_name)
            } catch (e){
              classes1name =  "暂无课程"
            }
            let classes1time:string =  '1'
            try {
              classes1time =  JSON.stringify(cc[0].event_begintime+"--"+cc[0].event_endtime)
            } catch (e){
              classes1time =  "-"
            }
            let classes1add:string =  '1'
            try {
              classes1add =  removestr(JSON.stringify(cc[0].course_address))
            } catch (e){
              classes1add =  "-"
            }
            let classes2name:string =  '1'
            try {
              classes2name =  JSON.stringify(cc[1].course_name)
            } catch (e){
              classes2name =  "暂无课程"
            }
            let classes2time:string =  '1'
            try {
              classes2time =  JSON.stringify(cc[1].event_begintime+"--"+cc[1].event_endtime)
            } catch (e){
              classes2time =  "-"
            }
            let classes2add:string =  '1'
            try {
              classes2add =  removestr(JSON.stringify(cc[1].course_address))
            } catch (e){
              classes2add =  "-"
            }
            let param: Record<string, string> = {
              'classes1name': classes1name,
              'classes1time': classes1time,
              "classes1add": classes1add,
              'classes2name': classes2name,
              'classes2time': classes2time,
              "classes2add": classes2add,
            };

            let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
            formProvider.updateForm(formId, formInfo);
          })
        })

      })
    })
  }

  onAddForm(want:Want) {
    let formData:Record<string, string> = {
      "classes":"12"
    };
    let formId: string = want.parameters![formInfo.FormParam.IDENTITY_KEY].toString()
    const  a = GetHeaderValueFora();
    const  timestamps = GetHeaderForTimeStamp()
    const  Timestamp = timestamps[0];
    const  LocalTimestamp = timestamps[1];
    const  Nonce = GetHeaderForNonce();
    const requestbodystring = "app_key=20460cbb2ccf1c97&app_secret=1dcc14a227a6f8d9b37792b7b053f671&app_version=" + GetwhistleVersion() + "&grant_type=client_credentials&platform=android&scope=all";
    const  Sign = GetHeaderForSign(requestbodystring, Timestamp, Nonce, a)
    interface resp {
      access_token:string
      expires_in:string
      scope:string
      refresh_token:string
      token_type:string
    }
    axios.post('https://api.m.dlut.edu.cn/oauth/token', requestbodystring, {
      headers: {
        'a': a,
        'sign': Sign,
        'local_timestamp': LocalTimestamp,
        'nonce': Nonce,
        'version': GetHeaderForVersion(),
        'timestamp': Timestamp,
        'Host': 'service.m.dlut.edu.cn',
        'Connection': 'Keep-Alive',
        'Cookie2': '$Version=1',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    })
      .then((response: AxiosResponse<string>) => {
        dataPreferences.getPreferences(this.context, "information").then(preferences => {
          preferences.get("account", 'default').then((value) => {
            let jsc: resp = JSON.parse(JSON.stringify(response.data))
            let url = "https://api.m.dlut.edu.cn/lightappapi/course/get_today_course?access_token=" + jsc.access_token +
              "&app_version=" + GetwhistleVersion() + "&domain=dlut&identity=" + "student" +
              "&platform=android&student_number=" + value;
            axios<string, AxiosResponse<string>, null>({
              method: "get",
              url: url
            }).then((res: AxiosResponse) => {
              let bb :courseres = JSON.parse(JSON.stringify(res.data))
              const now: Date = new Date();
              const hours: number = now.getHours();
              let cc:course[] =[];
              let  i = 0;
              for (let index = 0; index < bb.data.length; index++) {
                if (Number(bb.data[index].event_begintime.split(":")[0])>=hours) {
                  cc[i] = bb.data[index]
                  i++
                }
              }
              let classes1name:string =  '1'
              try {
                classes1name =  JSON.stringify(cc[0].course_name)
              } catch (e){
                classes1name =  "暂无课程"
              }
              let classes1time:string =  '1'
              try {
                classes1time =  JSON.stringify(cc[0].event_begintime+"--"+cc[0].event_endtime)
              } catch (e){
                classes1time =  "-"
              }
              let classes1add:string =  '1'
              try {
                classes1add =  JSON.stringify(cc[0].course_address)
              } catch (e){
                classes1add =  "-"
              }
              let classes2name:string =  '1'
              try {
                classes2name =  JSON.stringify(cc[1].course_name)
              } catch (e){
                classes2name =  "暂无课程"
              }
              let classes2time:string =  '1'
              try {
                classes2time =  JSON.stringify(cc[1].event_begintime+"--"+cc[1].event_endtime)
              } catch (e){
                classes2time =  "-"
              }
              let classes2add:string =  '1'
              try {
                classes2add =  JSON.stringify(cc[1].course_address)
              } catch (e){
                classes2add =  "-"
              }
              let param: Record<string, string> = {
                'classes1name': classes1name,
                'classes1time': classes1time,
                "classes1add": classes1add,
                'classes2name': classes2name,
                'classes2time': classes2time,
                "classes2add": classes2add,

              };
              let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
              formProvider.updateForm(formId, formInfo);
            })
          })

        })
      })
    dataPreferences.getPreferences(this.context, "information").then(preferences=> {
      preferences.get("data", 'default').then((value) => {
        let op:responsebean = JSON.parse(value.toString())
        axios<string, AxiosResponse<string>, null>({
          method: "get",
          url: "https://lightapp.m.dlut.edu.cn/api/library/library/ecard?verify="+op.data.verify
        }).then((res: AxiosResponse) => {
          axios<string, AxiosResponse<string>, null>({
            method: "get",
            url: "https://lightapp.m.dlut.edu.cn/api/courseschedule/dorm/get_dorm_info?verify="+op.data.verify
          }).then((rca: AxiosResponse) => {
            let mm: card = JSON.parse(JSON.stringify(res.data))
            let kk:elec = JSON.parse(JSON.stringify(rca.data))
            let pacv: Record<string, string> = {
              "cardmoney": mm.data[0].value,
              "room":kk.data[0].data[0].text.split("：")[1],
              "elec":kk.data[1].data[0].text.split("：")[1]
            }
            let formmn: formBindingData.FormBindingData = formBindingData.createFormBindingData(pacv);
            formProvider.updateForm(formId, formmn);
          })
        })
      })
    })
    // 当异步更新时，onAddForm方法最后可以返回 null
    return formBindingData.createFormBindingData(formData);
  }


  onCastToNormal(formId: string): void {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdate(formId: string): void {
    // Called to notify the form provider to update a specified form.
  }

  onVisibilityChange(newStatus: string): void {
    // Called when the form provider receives form events from the system.
  }

  onEvent(formId: string, message: string): void {
    // Called when a specified message event defined by the form provider is triggered.
  }

  onDestroy(formId: string): void {
    // Called to notify the form provider that a specified form has been destroyed.
  }

  onAcquireFormState(want: Want): formInfo.FormState {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
}