exception InvalidFormat of string

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
  | 1 -> "Jan."
  | 2 -> "Feb."
  | 3 -> "Mar."
  | 4 -> "Apr."
  | 5 -> "May"
  | 6 -> "Jun."
  | 7 -> "Jul."
  | 8 -> "Aug."
  | 9 -> "Sep."
  | 10 -> "Oct."
  | 11 -> "Nov."
  | 12 -> "Dec."
  | _ -> raise (invalid_arg "Number should be 1-12")

let compare t1 t2 =
  if month_num t1 < month_num t2 then -1
  else if month_num t1 > month_num t2 then 1
  else if day t1 < day t2 then -1
  else if day t1 > day t2 then 1
  else 0

(**STILL NEED TODO*)
let create_date str = { month = January; day = 1 }
