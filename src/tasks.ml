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

let add tsks tsk_name date =
  { name = tsk_name; due_date = Some date; completed = false } :: tsks
