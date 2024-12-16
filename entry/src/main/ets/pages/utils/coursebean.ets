export interface courseres{
  errcode:string
  errmsg:string
  data:course[]
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