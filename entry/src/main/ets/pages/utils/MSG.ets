export interface MsgResult {
  data: DataDTO;
  ret: number;
  errcode: number;
  errmsg: string;
}

interface DataDTO {
  msg_id: string[];
  conver_msg_id: string[];
  app_msg_id: string[];
  id_photo: string;
}
