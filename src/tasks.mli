(** This module is a representation of tasks*)

exception InvalidDate
(** Raised when an invalid date is entered *)

exception AlreadyComplete of int
(** Raised when trying to "complete" a completed task*)

exception ElementOutofBounds of int

type t
(** The abstract type of values representing tasks. *)

val empty : unit -> t
(** [empty] returns an empty task list*)

val from_file : string -> t
(** [from_file file] are the tasks parsed from JSON file [file]*)

val to_file : string -> t -> unit
(** [to_file file tsks] stores tasks [tsks] in JSON file [file]*)

val task_names : t -> string list
(** [task_names tsks] is a list of all the task names in tasks [tsks] *)

val task_name : t -> int -> string
(** [task_name tsks n] is the [n]th task name in tasks [tsks] Raises
    [Invalid_argument n] if [n] is negative Raise [Failure] if n is
    greater than the amount of tasks *)

val task_dates : t -> string list
(**[task_dates tsks] is a string list representing the dates of the
   tasks in [tsks]*)

val task_date_str : t -> int -> string
(** [task_date_str tsks n] is the [n]th task date in string-like format
    in tasks [tsks] Raises[Invalid_argument n] if [n] is negative. Raise
    [Failure] if n is greater than the amount of tasks*)

val task_date_opt : t -> int -> Date.t option
(** [task_date_opt tsks n] is the [n]th task date optional in tasks
    [tsks] Raises[Invalid_argument n] if [n] is negative. Raise
    [Failure] if n is greater than the amount of tasks*)

val completed : t -> int -> bool
(** [completed tsks n] is true if the [n]th task in tasks [tsks] is
    completed, false otherwise. Raises [Invalid_argument n] if [n] is
    negative. Raise [Failure] if n is greater than the amount of tasks.
    Raises [ElementOutOfBounds n] if [n] is greater than the number of
    tasks in [tsks] *)

val tasks_amount : t -> int
(** [tasks_amount tsks] is the number of tasks in [tsks].*)

val complete : t -> int -> t
(** [complete tsks n] is tasks [tsks] after completing the [n]th task
    Raises [Invalid_argument n] if [n] is negative. Raises [Failure] if
    n is greater than the amount of tasks. Raises [AlreadyComplete n] if
    the [n]th task is already completed. *)

val add : t -> string -> Date.t option -> t
(** [add tsks name date] is [tsks] after creating a new task with name
    [name] and the date that is extracted from the Date.t option [date].
    Raises [InvalidDate] if [date] is [None]*)
