exception InvalidDate of int * int
exception InvalidTask of int
exception AlreadyComplete of int

type t
(** The abstract type of values representing a tasks. *)

val add : t -> string -> int -> int -> t
(** [add t str d m] is tasks [t] after creating a new task with name
    [str], day [d], and month [m] Raises: [InvalidDate m*d] if m/d is
    not a valid date in the format month/date *)

val task_names : t -> string list
(** [task_names t] is a list of all the task names in tasks [t] *)

val task_name : t -> int -> string
(** [task_name t n] is the [n]th task name in tasks [t] Raises
    [InvalidTask n] if [n] is not a task of tasks. *)

val task_date : t -> int -> string
(** [task_date] is the [n]th task date in string-like format in tasks
    Raises [InvalidTask n] if [n] is not a task of tasks [t].*)

val completed : t -> int -> bool
(** [completed t n] is true if the [n]th task in tasks [t] is completed,
    false otherwise Raises [InvalidTask n] if [n] is not a task of
    tasks.*)

val tasks_amount : t -> int
(** [tasks_amount t] is the number of tasks in tasks [t].*)

val complete : t -> int -> t
(** [complete t n] is tasks [t] after completing the [n]th task Raises
    Raises [InvalidTask n] if [n] is not a task of tasks.
    [AlreadyComplete n] if the [n]th task is already completed. *)
