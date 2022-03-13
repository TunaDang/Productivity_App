open Date
open Yojson.Basic.Util

exception InvalidDate of (int * int)
exception AlreadyComplete of int

type task = {
  name : string;
  due_date : Date.t option;
  completed : bool;
}

type t = task list

let task_of_json json =
  {
    name = json |> member "name" |> to_string;
    due_date = json |> member "due_date" |> to_string |> create_date;
    completed = json |> member "completed" |> to_bool;
  }

let from_file file =
  let json = Yojson.Basic.from_file file in
  json |> to_list |> List.map task_of_json

let format tsk =
  let { name; due_date; completed } = tsk in
  `Assoc
    [
      ("name", `String name);
      ( "due_date",
        match due_date with
        | None -> `String ""
        | Some date -> `String (Date.to_string date) );
      ("completed", `Bool completed);
    ]

let to_file file tsks =
  Yojson.Basic.to_file file (`List (List.map format tsks))

let rec task_names tsks =
  match tsks with
  | [] -> []
  | { name; due_date; completed } :: t -> name :: task_names t

let task_name tsks n = (List.nth tsks n).name

let task_date tsks n =
  match (List.nth tsks n).due_date with
  | None -> ""
  | Some date -> Date.to_string date

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

(** extract date from date option*)
let extract_date_helper (date_opt : Date.t option) : Date.t =
  match date_opt with
  | None -> failwith "Invalid input"
  | Some date -> date

let rec add tsks tsk_name date =
  let new_task =
    { name = tsk_name; due_date = date; completed = false }
  in
  if date = None then tsks @ [ new_task ]
  else
    match tsks with
    | [] -> [ new_task ]
    | h :: t ->
        if
          Date.compare
            (extract_date_helper date)
            (extract_date_helper h.due_date)
          = ~-1
          || Date.compare
               (extract_date_helper date)
               (extract_date_helper h.due_date)
             = 0
        then new_task :: h :: t
        else h :: add t tsk_name date

let rec task_dates tsks =
  match tsks with
  | [] -> []
  | { name; due_date; completed } :: t ->
      (due_date |> extract_date_helper |> Date.to_string)
      :: task_dates t
