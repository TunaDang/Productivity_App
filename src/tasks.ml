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

let add tsks ?month:(m = 0) ?day:(d = 0) str =
  let date =
    match (m, d) with
    | 0, 0 -> None (* check if only enter month or only enter day*)
    | x, y -> Some { day = d; month = m }
  in
  tsks @ [ { name = str; due_date = date; completed = false } ]

let task_names tsks = Failure "Unimplemented"
let task_name tsks n = Failure "Unimplemented"
let task_date tsks n = Failure "Unimplemented"
let completed tsks n = Failure "Unimplemented"
let tasks_amount tsks = Failure "Unimplemented"
let complete tsks n = Failure "Unimplemented"
