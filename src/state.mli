(** Module to represent the current state of the to do list.*)

type t
(** Abstract type representing the current state of the to do list*)

val init_state : Tasks.t -> t
(** [init_state tsks] is the initial state of the to do list based on a
    given tasks.*)

val update_tasks : Command.t -> t -> t
(** [update_task cmd st] will update the current state [st] with the
    given command [cmd]. Possible commands are add, edit, complete, and
    quit. *)

val get_tasks : t -> string list
(** [current_tasks st] is the list of all task names in the state [st].*)

val get_dates : t -> string list
(** [current_tasks_dates st] is the string list of all dates of state
    [st].*)
