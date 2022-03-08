open Date

exception InvalidDate of (int * int)
exception AlreadyComplete of int

type task = {
  name : string;
  due_date : Date.t option;
  completed : bool;
}

type t = task list

let rec task_names tsks =
  match tsks with
  | [] -> []
  | { name; due_date; completed } :: t -> name :: task_names t

let task_name tsks n = (List.nth tsks n).name

let task_date tsks n =
  match (List.nth tsks n).due_date with
  | None -> "This Task has no due date"
  | Some date ->
      Date.abbrv_name date ^ " " ^ (Date.day date |> string_of_int)

let completed tsks n = (List.nth tsks n).completed
let tasks_amount tsks = List.length tsks

(**[rec update_tasks tsks n] equals tasks [tsks] with the [n]th
   element's completed field being true*)
let rec complete_task_aux tsks n =
  let old_tsk = List.nth tsks n in
  let new_task =
    {
      name = old_tsk.name;
      due_date = old_tsk.due_date;
      completed = true;
    }
  in
  List.map (fun x -> if x == old_tsk then new_task else x) tsks

let complete tsks n =
  if (List.nth tsks n).completed then raise (AlreadyComplete n)
  else complete_task_aux tsks n

(****************NEED TO IMPLEMENT ADD STILL. COMMENTED AWAY FOR NOW SO
  BUILD IS SUCCESFUL**************************)
(** [check_date m d] is a date option with month [m] and day [d] Raises
    [InvalidDate m,d] if month/day [m]/[d] is not a valid date*)
(* let check_date m d = if m = 1 || m = 3 || m = 5 || m = 7 || m = 8 ||
   m = 10 || m = 12 then if d > 31 then raise (InvalidDate (m, d)) else
   Some { day = d; month = m } else if m = 4 || m = 6 || m = 9 || m = 11
   then if d > 30 then raise (InvalidDate (m, d)) else Some { day = d;
   month = m } else if m = 2 then if d > 28 then raise (InvalidDate (m,
   d)) else Some { day = d; month = m } else raise (InvalidDate (m, d))

   let add tsks ?month:(m = 0) ?day:(d = 0) str = let date = match (m,
   d) with | 0, 0 -> None | x, y -> check_date x y in tsks @ [ { name =
   str; due_date = date; completed = false } ] *)

(* let add tsks str *)
