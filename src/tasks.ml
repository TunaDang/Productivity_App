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

(** [check_date m d] is a date option with month [m] and day [d] Raises
    [InvalidDate m,d] if month/day [m]/[d] is not a valid date*)
let check_date m d =
  if m = 1 || m = 3 || m = 5 || m = 7 || m = 8 || m = 10 || m = 12 then
    if d > 31 then raise (InvalidDate (m, d))
    else Some { day = d; month = m }
  else if m = 4 || m = 6 || m = 9 || m = 11 then
    if d > 30 then raise (InvalidDate (m, d))
    else Some { day = d; month = m }
  else if m = 2 then
    if d > 28 then raise (InvalidDate (m, d))
    else Some { day = d; month = m }
  else raise (InvalidDate (m, d))

let add tsks ?month:(m = 0) ?day:(d = 0) str =
  let date =
    match (m, d) with
    | 0, 0 -> None (* check if only enter month or only enter day*)
    | x, y -> check_date x y
  in
  tsks @ [ { name = str; due_date = date; completed = false } ]

let rec task_names tsks =
  match tsks with
  | [] -> []
  | { name; due_date; completed } :: t -> name :: task_names t

let task_name tsks n = (List.nth tsks n).name

let months =
  [
    "January";
    "February";
    "March";
    "April";
    "May";
    "June";
    "July";
    "August";
    "September";
    "October";
    "November";
    "December";
  ]

let task_date tsks n =
  match (List.nth tsks n).due_date with
  | None -> "This Task has no due date"
  | Some { day; month } ->
      List.nth months (month - 1) ^ string_of_int day

let completed tsks n = Failure "Unimplemented"
let tasks_amount tsks = Failure "Unimplemented"
let complete tsks n = Failure "Unimplemented"
