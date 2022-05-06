(** This module is a representation of a Date*)

exception InvalidDateFormat of string
(**Raised if an input string is invalid format*)

type t
(** The abstract type of values representing a date *)

val abbrv_name : t -> string
(** [abbrv_name date] is the abbreviated name of the month in date
    [date]. Example: the abbreivated name of Janurary is Jan.*)

val day : t -> int
(** [day d] is the day of date [t] *)

val month_num : t -> int
(**[month_num d] is the number corresponding to the month of date [d].
   Example: The number corresponding to the month March is 3*)

val compare : t -> t -> int
(**[compare d1 d2] is -1 if [d1] is calendrically before [d2], 1 if [d1]
   is calendrically after [d2], and 0 if [d1] and [d2] are the same date *)

val incr_month : t -> t
(**[incr_month d] is date [d] incremented by 1 month. Accounts for going
   from December to January. Note: if the current day of the current
   month is greater than the number of days in the next month, the date
   is set to the last day of the next month Example: Incrementing 1/31
   by a month would be the date 2/28*)

val incr_day : t -> t
(**[incr_day d] is date [d] incremented 1 day. Ensures that if
   incremented to next month, the month updates correspondingly*)

val incr_week : t -> t
(**[incr_week d] is date [d] incremented by 7 days, or 1 week*)

val create_date : string -> t option
(** [create_date str] creates an optional date given a string formatted
    in the form month/day where month is an integer between 1..12 and
    day is a valid integer within the number of days of the month. Also
    creates a relative date for certain keywords: ["tomorrow"],
    ["next week"], ["next month"]. If [str] is empty, [None] is
    returned, else [Some] date is returned Raises:
    [InvalidDateFormat str] if str is not a string represeting a valid
    date nor relative date. Raises [Failure "int_of_string"] if the
    month or day are not integers.*)

val get_today : unit -> t

val to_string : t -> string
(** [to_string date] converts [date] to a month/day format*)

val to_string_opt : t option -> string
(** [to_string_opt date] is [to_string date] but takes in an option. If
    date is None, it will return "None" as the string.*)

val date_diff : t -> t -> int
(**[date_diff d1 d2] is the days between date [d1] and date [d2] if [d1]
   comes calendrically before [d2]. Equals -1 if [d1] comes after [d2]*)

val days_remaining : t -> int
(** [days_remaning date] is the days left between the current time and
    the date provided. Returns 0 if today is the due date and -1 if the
    due date has passed*)
