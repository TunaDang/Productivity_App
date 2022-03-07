exception InvalidFormat of string

type t
(** *)

val abbrv_name: t -> string
(** get abbreviated month name of date*)

val day: t -> int
(** get day of date *)

val month_num: t -> int
(** get number of month corresponding to date month*)

val num_to_month: int -> t
(** *)

val compare: t -> t -> int
(** *)

val create_date: string -> t
(** format num/num, dissect here *)