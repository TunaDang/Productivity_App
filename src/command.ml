type phrase = string list

type t =
  | Add of phrase * Date.t option
  | Complete of int
  | Edit of phrase * Date.t option
  | Quit

exception Empty
exception Malformed

let is_empty str = String.trim str = ""

let convert_to_array (str : string) =
  let string_char = String.split_on_char ' ' str in
  List.filter (fun x -> x <> "") string_char

let parse str = failwith "Unimplemented"
(* if is_empty str then raise Empty else match convert_to_array str with
   | [] -> raise Empty | string_list -> let date = *)
