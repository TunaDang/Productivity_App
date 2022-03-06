exception InvalidDate of int * int
exception InvalidTask of int
exception AlreadyComplete of int

type t
(** The abstract type of values representing a tasks. *)

val add : t -> string -> int -> int -> t
(** [add tsks str d m] is tasks [tsks] after creating a new task with
    name [str], day [d], and month [m] Raises: [InvalidDate m*d] if m/d
    is not a valid date in the format month/date *)

val task_names : t -> string list
(** [task_names tsks] is a list of all the task names in tasks [tsks] *)

val task_name : t -> int -> string
(** [task_name tsks n] is the [n]th task name in tasks [tsks] Raises
    [InvalidTask n] if [n] is not a task of tasks. *)

val task_date : t -> int -> string
(** [task_date tsks n] is the [n]th task date in string-like format in
    tasks [tsks] Raises [InvalidTask n] if [n] is not a task of tasks
    [ts].*)

val completed : t -> int -> bool
(** [completed tsks n] is true if the [n]th task in tasks [tsks] is
    completed, false otherwise Raises [InvalidTask n] if [n] is not a
    task of tasks.*)

val tasks_amount : t -> int
(** [tasks_amount tsks] is the number of tasks in tasks [tsks].*)

val complete : t -> int -> t
(** [complete tsks n] is tasks [tsks] after completing the [n]th task
    Raises Raises [InvalidTask n] if [n] is not a task of tasks.
    [AlreadyComplete n] if the [n]th task is already completed. *)
