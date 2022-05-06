(* This module is responsible for outputting the current state of the
   task list to the user*)

(* Currently the only supported printing is one task per line*)

val ascii_art : string
(** *)

(*Prints the tasks in the current list of the application. Tasks are
  printed in the same order as they appear in the list*)
val print_tasks : State.t -> unit

(*Prints the tasks in a week view of the current week from Monday to
  Sunday. For example, tasks due on Monday of the week will be printed
  under Monday. No tasks will be printed if no tasks are due on that day
  of the current week. *)
val print_week : State.t -> unit

(*Prints the settings in the current list of the application and their
  current values.*)
val print_settings : State.t -> unit

val input : unit -> unit
(** prints the input character: '>' *)

val quit : unit -> unit
(** prints the text for quitting the application *)

val empty : unit -> unit
(** prints the response to an empty input from user *)

val malformed : unit -> unit
(** prints the response to a malformed input from user *)

val print_ascii_art : unit -> unit
(** prints the camel ascii art *)

val help : unit -> unit
(** prints out help text to the user*)

val help_settings : unit -> unit
(** prints out help text to the user in the settings menu*)
