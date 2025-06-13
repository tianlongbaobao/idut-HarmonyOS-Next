export interface NewMsgInfo {
  data: NewMsgInfo.DataDTO;
  ret: number;
  errcode: number;
  errmsg: string;
}

export namespace NewMsgInfo {
  export interface DataDTO {
    msg_info: MsgInfoDTO[];
  }

 interface MsgInfoDTO {
    is_receipt: string;
    is_authoritative: string;
    msg_content: string;
    title: string;
    send_time: string;
    create_time: string;
    msg_type: string;
    send_uid: string;
    msg_id: string;
    app_id: string;
    isCancel: string;
  }
}
