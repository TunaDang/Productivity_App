(** This module is a representation of settings*)

exception InvalidOption
(** Raised when an invalid option is entered *)
exception ElementOutofBounds of int 

type t
(** The abstract type of values representing settings. *)

val from_file : string -> t
(** [from_file file] are the settings parsed from JSON file [file]*)

val to_file : string -> t -> unit
(** [to_file file sets] stores settings [sets] in JSON file [file]*)

val settings : t -> string list
(** [settings sets] is a list of all the setting names in settings [sets] *)

val setting : t -> int -> string
(** [setting sets n] is the [n]th setting name in settings [sets] Raises
    [Invalid_argument n] if [n] is negative Raise [Failure] if n is
    greater than the amount of settings *)