open Yojson.Basic.Util
open Date

exception InvalidDate of (int * int)
exception ElementOutofBounds of int

type t = {
  display_completed : bool;
  due_before : Date.t option;
}
(* unimplemented color_palate : Color *)

let setting_of_json json = ()
(* unimplemented { name = json |> member "name" |> to_string; due_date =
   json |> member "due_date" |> to_string |> create_date; completed =
   json |> member "completed" |> to_bool; } *)

let from_file file = ()
(* let json = Yojson.Basic.from_file file in json |> to_list |> List.map
   setting_of_json *)

let format tsk = ()
(* let { name; due_date; completed } = tsk in `Assoc [ ("name", `String
   name); ( "due_date", match due_date with | None -> `String "" | Some
   date -> `String (Date.to_string date) ); ("completed", `Bool
   completed); ] *)

let to_file file sets = ()
(* Yojson.Basic.to_file file (`List (List.map format sets)) *)

let rec settings sets = ()
(* match sets with | [] -> [] | { name; due_date; completed } :: t ->
   name :: setting_names t *)

let setting sets n = ()
(* (List.nth sets n).name *)

let set_display_completed = ()
let set_due_before = ()
