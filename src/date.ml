exception InvalidDateFormat of string
exception InvalidDayOfWeek of string

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

(*[days m] equals the days in month [m]*)
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

(**[num_to_month n] is the month abbreivation corresponding to number
   [n] Requires: [n] is in 1..12 *)
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
  if m > 12 || m < 1 then
    raise (InvalidDateFormat (string_of_int m ^ "/" ^ string_of_int d))
  else if d < 1 || d > (m |> num_to_month |> days) then
    raise (InvalidDateFormat (string_of_int m ^ "/" ^ string_of_int d))
  else Some { month = m |> num_to_month; day = d }

let incr_month date =
  let day, month = (date.day, date.month) in
  let new_month_num = date |> month_num |> ( + ) 1 in
  if new_month_num = 13 then { month = January; day }
  else if new_month_num = 2 && day > 28 then
    { month = February; day = 28 }
  else if day = 31 then
    { month = new_month_num |> num_to_month; day = 30 }
  else { month = new_month_num |> num_to_month; day }

let incr_day date =
  let day, month = (date.day, date.month) in
  let new_day = day + 1 in
  if new_day > (month |> days) then
    let new_date = incr_month date in
    { new_date with day = 1 }
  else { month; day = new_day }

let incr_week date =
  let day, month = (date.day, date.month) in
  let new_day = day + 7 in
  if new_day > (month |> days) then
    let rem_days = (month |> days) - day in
    let new_date = incr_month date in
    { new_date with day = 7 - rem_days }
  else { month; day = new_day }

let rec create_date str =
  let lower_str = String.lowercase_ascii str in
  if lower_str = "tomorrow" then Some (get_today () |> incr_day)
  else if lower_str = "next week" then Some (get_today () |> incr_week)
  else if lower_str = "next month" then Some (get_today () |> incr_month)
  else
    let str_lst = str |> String.split_on_char '/' |> trim_str_lst in
    if str_lst = [] then None
    else if List.length str_lst != 2 then raise (InvalidDateFormat str)
    else
      let month = int_of_string (List.nth str_lst 0) in
      let day = int_of_string (List.nth str_lst 1) in
      valid_date month day

and get_today () =
  let open Unix in
  let time = time () |> localtime in
  match time with
  | { tm_mday; tm_mon } ->
      let current_date =
        match
          create_date (Printf.sprintf "%d/%d" (tm_mon + 1) tm_mday)
        with
        | Some x -> x
        | None -> failwith "current date must be a valid date"
      in
      current_date

let to_string date =
  string_of_int (month_num date) ^ "/" ^ string_of_int (day date)

let to_string_opt date_opt =
  match date_opt with
  | None -> "None"
  | Some date ->
      string_of_int (month_num date) ^ "/" ^ string_of_int (day date)

(* Returns number of days in months between [m1] and [m2]*)
let rec days_in_months_help m1 m2 =
  match (m1, m2) with
  | x, y when x = y -> 0
  | x, y -> (x |> num_to_month |> days) + days_in_months_help (x + 1) y

let date_diff d1 d2 =
  let comp = compare d1 d2 in
  if comp = 0 then comp
  else if comp = 1 then -1
  else if d1.month = d2.month then d2.day - d1.day
  else
    let days_left_in_m1 = days d1.month - d1.day in
    let days_in_months_bw =
      days_in_months_help (month_num d1 + 1) (month_num d2)
    in
    let days_in_m2 = d2.day in
    days_left_in_m1 + days_in_months_bw + days_in_m2

let days_remaining date =
  let open Unix in
  let time = time () |> localtime in
  match time with
  | { tm_mday; tm_mon } ->
      let current_date =
        match
          create_date (Printf.sprintf "%d/%d" (tm_mon + 1) tm_mday)
        with
        | Some x -> x
        | None -> failwith "current date must be a valid date"
      in
      date_diff current_date date

let day_of_week () =
  let open Unix in
  let t = Unix.localtime (Unix.time ()) in
  match t.tm_yday mod 7 with
  | 0 -> "Saturday"
  | 1 -> "Sunday"
  | 2 -> "Monday"
  | 3 -> "Tuesday"
  | 4 -> "Wednesday"
  | 5 -> "Thursday"
  | 6 -> "Friday"
  | _ -> failwith "Impossible"

let next_day_of_week s =
  match String.lowercase_ascii s with
  | "sunday" -> "Monday"
  | "monday" -> "Tuesday"
  | "tuesday" -> "Wednesday"
  | "wednesday" -> "Thursday"
  | "thursday" -> "Friday"
  | "friday" -> "Saturday"
  | "saturday" -> "Sunday"
  | _ -> raise (InvalidDayOfWeek s)