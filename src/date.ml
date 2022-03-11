exception InvalidDateFormat of string

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

(**[days m] equals the days in month [m]*)
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

(**[valid_date m d] is the date representation given 2 integers
   representing the month and day*)
let valid_date m d =
  if m > 12 || m < 1 then raise (InvalidDateFormat "Month Invalid")
  else if d < 1 || d > (m |> num_to_month |> days) then
    raise (InvalidDateFormat "Day Invalid")
  else Some { month = m |> num_to_month; day = d }

let create_date str =
  let str_lst = str |> String.split_on_char '\\' |> trim_str_lst in
  if str_lst = [] then None
  else if List.length str_lst != 2 then raise (InvalidDateFormat str)
  else
    let month = int_of_string (List.nth str_lst 0) in
    let day = int_of_string (List.nth str_lst 1) in
    valid_date month day

let to_string date =
  string_of_int (month_num date) ^ "/" ^ string_of_int (day date)
