(** Module to represent the current state of the to do list.*)

type t
(** Abstract type representing the current state of the to do list*)

val init_state : Tasks.t -> t
(** [init_state tsks] is the initial state of the to do list based on a
    given tasks.*)

val current_tasks : t -> string list
(** [current_tasks st] are the tasks that the user has yet completed
    during state [st]*)

type result =
  | Valid of t
  | Invalid

(* val complete val add val edit *)
