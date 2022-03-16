type phrase = string list

type t =
  | Add of phrase * Date.t option
  | Complete of int
  | Edit of phrase * Date.t option
  | Clear
  | Help
  | Quit

exception Empty
exception Malformed
exception Invalid

(* Helper functions *)
let is_empty str = String.trim str = ""

let convert_to_array (str : string) =
  let string_char = String.split_on_char ' ' str in
  List.filter (fun x -> x <> "") string_char

let parse_date (str : string) = String.split_on_char '.' str

let get_first = function
  | [] -> raise Empty
  | h :: t -> h

let get_last = function
  | [] -> raise Empty
  | list -> list |> List.rev |> List.hd

let get_rest = function
  | [] -> raise Empty
  | h :: t -> t

let parse_command phrase date =
  let phrase = convert_to_array phrase in
  let rest = get_rest phrase in
  let trimmed_date = String.trim date in
  match get_first phrase with
  | "add" ->
      if rest <> [] then Add (rest, Date.create_date trimmed_date)
      else raise Empty
  | "edit" -> Edit (rest, Date.create_date trimmed_date)
  | "complete" -> (
      try Complete (rest |> get_first |> int_of_string)
      with _ -> raise Malformed)
  | "clear" ->
      if trimmed_date == "" && rest = [] then Clear else raise Malformed
  | "help" ->
      if trimmed_date = "" && rest = [] then Help else raise Malformed
  | "quit" ->
      if trimmed_date = "" && rest = [] then Quit else raise Malformed
  | _ -> raise Malformed

(* Interface Functions*)
let parse str =
  if is_empty str then raise Empty
  else
    let period_parse = parse_date str in
    match period_parse with
    | [ phrase; date ] -> parse_command phrase date
    | [ phrase ] -> parse_command phrase ""
    | _ -> raise Malformed

let get_phrase t =
  match t with
  | Add (phrase, date) -> String.concat " " phrase
  | Edit (phrase, date) -> String.concat " " phrase
  | _ -> raise Invalid
