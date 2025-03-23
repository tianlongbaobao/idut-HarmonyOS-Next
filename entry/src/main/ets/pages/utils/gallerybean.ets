export interface galleryres {
  data:carga
  errcode:number
  ret:number
  errmsg:string
}

interface carga {
  carousel_gallery:gallerys[]
}
interface gallerys {
  id:string
  pic_uri:string
  url:string
  title:string
  type:string
  status:string
  num:string
}