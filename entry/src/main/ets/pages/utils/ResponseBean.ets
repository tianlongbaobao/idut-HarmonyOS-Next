export interface responsebean {
  data: DataDTO;
  ret: number;
  errcode: number;
  errmsg: string;
}

export interface DataDTO {
  my_info: MyInfoDTO;
  verify: string;
  easep: string;
  score: ScoreDTO;
  rsa_key: string;
  tgtinfo: TgtinfoDTO[];
  pword: string;
  expires_skey: string;
  img:string
}

export interface MyInfoDTO {
  authority_identity: string;
  celphone: string;
  email: string;
  head: string;
  idType: string;
  identity: string;
  identity_photo: string;
  isLogin: string;
  isVisitors: string;
  landline: string;
  mood_words: string;
  name: string;
  nick_name: string;
  org: OrgDTO[];
  org_id: string[];
  parent_active: string;
  parent_activetime: string;
  parent_bind: string;
  parent_passwd: string;
  path: string;
  pycc: string;
  qqcode: string;
  sex: string;
  status: string;
  student_number: string;
  tittle: string;
  user_id: string;
  verify_phone: string;
  wechatcode: string;
  zzmm: string;
  jid: string;
  skey: string;
  expires_skey: string;
  orgPath: OrgPathDTO[];
}

export interface OrgDTO {
  end_time: string;
  flag_class: string;
  id: string;
  last_time: string;
  name: string;
  organization_id: string;
  parent: string;
  path: string;
  role: string;
  sort_string: string;
  start_time: string;
  status: string;
  type: string;
}

export interface OrgPathDTO {
  name: string;
  organization_id: string;
}

export interface ScoreDTO {
  sum: number;
  add_score: number;
}

export interface TgtinfoDTO {
  name: string;
  value: string;
  domain: string;
  path: string;
  expires: number;
  hours: number;
}
