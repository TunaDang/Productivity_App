(** Module to represent the current state of the to do list.*)

type t
(** Abstract type representing the current state of the to do list*)

val init_state : Tasks.t -> t
(** [init_state tsks] is the initial state of the to do list based on a
    given tasks.*)

(** The type representing the result of a command on a state. *)
type result =
  | Valid of t
  | Invalid

val update_tasks : Command.t -> t -> result
(** [update_task cmd st] will update the current state [st] with the
    given command [cmd]. Possible commands are add, edit, complete, and
    quit. *)

val current_tasks : t -> string list
(** [current_tasks st] is the list of all task names in the state [st]*)

(* QUESTION: What happens when we quit? I guess we need to call the
   persistence module*)
