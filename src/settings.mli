(** This module is a representation of settings*)

exception InvalidDate of (int * int)
(** Raised when an invalid date is entered *)

type t
(** The abstract type of values representing settings. *)

val from_file : string -> t
(** [from_file file] are the settings parsed from JSON file [file] *)

val to_file : string -> t -> unit
(** [to_file file sets] stores settings [sets] in JSON file [file] *)

val settings : t -> string list
(** [settings sets] is a list of all the setting names in settings
    [sets] *)

val setting : t -> int -> string
(** [setting sets n] is the [n]th setting name in settings [sets] Raises
    [Invalid_argument n] if [n] is negative Raise [Failure] if n is
    greater than the amount of settings *)

val set_display_completed : t -> bool -> t
(** [set_display_complete sets b] is settings [sets] after setting
    [display_completed] to bool [b]*)

val set_due_before : t -> Date.t option -> t
(** [set_due_before sets d] is settings [sets] after setting
    [due_before] to [Date.t option] [d]. Raises: [InvalidDate int * int]
    for invalid date entered *)
