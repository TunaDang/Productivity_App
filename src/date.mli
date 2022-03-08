(** This module is a representation of a Date*)

exception InvalidFormat of string
(**Raised if an input string is invalid format*)

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

type t
(** The abstract type of values representing a date *)

val abbrv_name : t -> string
(** get abbreviated month name of date*)

val day : t -> int
(** [day d] is the day of date [t] *)

val month_num : t -> int
(**[month_num d] is the number corresponding to the month of date [d]*)

val num_to_month : int -> month
(**[num_to_month n] is the month abbreivation corresponding to number
   [n] Requires: [n] is in 1..12 *)

val compare : t -> t -> int
(**[compare d1 d2] is -1 if [d1] is calendrically before [d2], 1 if [d1]
   is calendrically after [d2], and 0 if [d1] and [d2] are the same date *)

val create_date : string -> t option
(** [create_date str] creates an optional date given a string formatted
    in the form month/day where month is an integer between 1..12 and
    day is a valid integer within the number of days of the month. If
    [str] is empty, [None] is returned, else [Some] date is returned
    Raises: [InvalidFormat str] if str is not a string represeting a
    valid date. Raises[Failure "int_of_string"] if the month or day are
    not integers.*)
