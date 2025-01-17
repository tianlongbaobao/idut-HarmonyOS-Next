import { pushService } from '@kit.PushKit'
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import dataPreferences from '@ohos.data.preferences';
import axios, { AxiosResponse } from '@ohos/axios';
import {GetwhistleVersion,GetHeaderValueFora,GetHeaderForVersion,GetHeaderForNonce,GetHeaderForSign,GetHeaderForTimeStamp} from "../backrequest/c"

let context = getContext(this)
interface courseres{
  errcode:string
  errmsg:string
  data:course[]
  con:string
  pushtoken:string
  account:string
}

interface course {
  typeid:number
  lesson_times:number
  succession:number
  week_times:string
  event_begintime:string
  event_endtime:string
  course_name:string
  course_address:string
}
export async function pushclass(con:boolean):Promise<void>{
  try {
    const pushToken: string = await pushService.getToken();
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
        dataPreferences.getPreferences(context, "information").then(preferences => {
          preferences.get("account", 'default').then((value) => {
            let jsc: resp = JSON.parse(JSON.stringify(response.data))
            let url = "https://api.m.dlut.edu.cn/lightappapi/course/get_today_course?access_token=" + jsc.access_token +
              "&app_version=" + GetwhistleVersion() + "&domain=dlut&identity=" + "student" +
              "&platform=android&student_number=" + value;
            axios<string, AxiosResponse<string>, null>({
              method: "get",
              url: url
            }).then((res: AxiosResponse) => {
              let bb: courseres = JSON.parse(JSON.stringify(res.data))
              bb.pushtoken = pushToken
              bb.account = value+""
              if (con) {
                bb.con = "0"
              } else {
                bb.con = "1"
              }
              axios.post("http://www.luzhiyidut.cn:443/push",bb,{
                headers:{
                  'Content-Type': 'application/json'
                }
              })
                .then((rmn: AxiosResponse) =>{
                  console.log(rmn.data)
                })
            })
          })
        })
      })
  } catch (err) {
    let e: BusinessError = err as BusinessError;
    hilog.error(0x0000, 'testTag', 'Failed to get push token: %{public}d %{public}s', e.code, e.message);
    AlertDialog.show(
      {
        message: '无法启用pushkit，请检查签名',
        autoCancel: false,
        alignment: DialogAlignment.Bottom,
        gridCount: 5,
        offset: { dx: 0, dy: -20 },
        primaryButton: {
          value: '确认',
          action: () => {
          }
        },
      }
    )
  }


}