export interface PhotoBean {
  data: DataDTO;
  ret: number;
  errcode: number;
  errmsg: string;
}

export interface DataDTO {
  id_photo: string;
}
