export interface NotificationPayload {
  appkey: string;
  deviceToken: string;
  payload: PayloadBean;
  production_mode: boolean;
  timestamp: string;
  type: string;
}

interface PayloadBean {
  body: Body;
  display_type: string;
}

interface Body {
  after_open: string;
  custom: Custom;
  msg_type: string;
  play_lights: boolean;
  play_sound: boolean;
  play_vibrate: boolean;
  ticker: string;
  title: string;
}

interface Custom {
  content: PushContent;
  domain: string;
  msg_id: string;
  user_id: string;
}
interface PushContent {
  title: string;
  description: string;
  picurl: string;
  url: string;
}