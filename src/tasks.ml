exception InvalidDate of int * int
exception InvalidTask of int
exception AlreadyComplete of int

type date = {
  day : int;
  month : int;
}

type task = {
  name : string;
  due_date : date option;
  completed : bool;
}

type t = task list

let add tsks str m d = Failure "Unimplemented"
let task_names tsks = Failure "Unimplemented"
let task_name tsks n = Failure "Unimplemented"
let task_date tsks n = Failure "Unimplemented"
let completed tsks n = Failure "Unimplemented"
let tasks_amount tsks = Failure "Unimplemented"
let complete tsks n = Failure "Unimplemented"
