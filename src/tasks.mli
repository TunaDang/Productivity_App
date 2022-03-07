(** This module is a representation of tasks*)


exception InvalidDate of (int * int)
(** Raised when an invalid date is entered *)
exception AlreadyComplete of int
(** Raised when trying to "complete" a completed task*)

type t
(** The abstract type of values representing tasks. *)

val task_names : t -> string list
(** [task_names tsks] is a list of all the task names in tasks [tsks] *)

val task_name : t -> int -> string
(** [task_name tsks n] is the [n]th task name in tasks [tsks] Raises
    [Invalid_argument n] if [n] is negative Raise [Failure] if n is
    greater than the amount of tasks *)

val task_date : t -> int -> string
(** [task_date tsks n] is the [n]th task date in string-like format in
    tasks [tsks] Raises[Invalid_argument n] if [n] is negative. 
    Raise [Failure] if n is greater than the amount of tasks*)

val completed : t -> int -> bool
(** [completed tsks n] is true if the [n]th task in tasks [tsks] is
    completed, false otherwise 
    Raises[Invalid_argument n] if [n] is negative.
    Raise [Failure] if n is greater than the amount of tasks. *)

val tasks_amount : t -> int
(** [tasks_amount tsks] is the number of tasks in tasks [tsks].*)

val complete : t -> int -> t
(** [complete tsks n] is tasks [tsks] after completing the [n]th task
    Raises [Invalid_argument n] if [n] is negative. 
    Raises [Failure] if n is greater than the amount of tasks.
    Raises [AlreadyComplete n] if the [n]th task is already completed. *)

(**TODO*)
(* val add : t -> ?month:int -> ?day:int -> string -> t *)
(* val add: t -> string -> string -> t *)
(** [add tsks d m str] is tasks [tsks] after creating a new task with
    name [str], day [d], and month [m] Raises: [InvalidDate m*d] if m/d
    is not a valid date in the format month/date *)