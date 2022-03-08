exception InvalidFormat of string
exception EmptyString

type month =
  | January
  | February
  | March
  | April
  | May
  | June
  | July
  | August
  | September
  | October
  | November
  | December

type t = {
  month : month;
  day : int;
}

(**number of days in month m*)
let days m =
  match m with
  | January | March | May | July | August | October | December -> 31
  | April | June | September | November -> 30
  | February -> 28

let abbrv_name t =
  match t.month with
  | January -> "Jan."
  | February -> "Feb."
  | March -> "Mar."
  | April -> "Apr."
  | May -> "May"
  | June -> "Jun."
  | July -> "Jul."
  | August -> "Aug."
  | September -> "Sep."
  | October -> "Oct."
  | November -> "Nov."
  | December -> "Dec."

let day t = t.day

let month_num t =
  match t.month with
  | January -> 1
  | February -> 2
  | March -> 3
  | April -> 4
  | May -> 5
  | June -> 6
  | July -> 7
  | August -> 8
  | September -> 9
  | October -> 10
  | November -> 11
  | December -> 12

let num_to_month = function
  | 1 -> January
  | 2 -> February
  | 3 -> March
  | 4 -> April
  | 5 -> May
  | 6 -> June
  | 7 -> July
  | 8 -> August
  | 9 -> September
  | 10 -> October
  | 11 -> November
  | 12 -> December
  | _ -> raise (invalid_arg "Number should be 1-12")

let compare t1 t2 =
  if month_num t1 < month_num t2 then -1
  else if month_num t1 > month_num t2 then 1
  else if day t1 < day t2 then -1
  else if day t1 > day t2 then 1
  else 0

(** [rec trim_str_lst str_lst] equals [str_lst] without empty strings*)
let rec trim_str_lst (str_list : string list) =
  match str_list with
  | [] -> []
  | "" :: t -> trim_str_lst t
  | h :: t -> h :: trim_str_lst t

let is_valid_date m d = Failure "Not implemented"

(**STILL NEED TODO*)
let create_date str =
  let str_lst = str |> String.split_on_char '\\' |> trim_str_lst in
  if str_lst = [] then raise EmptyString
  else if List.length str_lst != 2 then raise (InvalidFormat str)
    (* There must only be 2 elements in this list, representing
       [month;day]*)
  else
    let month = int_of_string (List.nth str_lst 0) in
    (*Will throw error if the input is not a number; int_of_string
      requires number input*)
    let day = int_of_string (List.nth str_lst 1) in
    if month > 12 || month < 1 || day < 1 || day > 31 then
      raise (InvalidFormat str) (*Do this part in Is_valid_date*)
    else { month = num_to_month month; day }
