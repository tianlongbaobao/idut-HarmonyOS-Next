export interface card{
  data:yue[]
}
export interface elec{
  data:ele[]
}
export interface yue{
  title:string
  value:string
}

export interface ele{
  columns:string
  data:df[]
}

interface df{
  span:string
  text:string
}