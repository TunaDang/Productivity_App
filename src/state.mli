(** Module to represent the current state of the to do list.*)

type t
(** Abstract type representing the current state of the to do list.*)

(** Type representing the current page the user is on.*)
type page =
  | Main
  | Settings

val pack_state : Tasks.t -> Settings.t -> page -> t
(** [pack_state tsks] packs a state of the to do list based on a given
    tasks, settings, and current page.*)

val update_state : t -> Command.t -> t
(** [update_state st cmd] will update the current state [st] with the
    given command [cmd]. Possible commands are add, edit, complete,
    settings, select, date, and quit. *)

val update_settings_state : t -> Command.setting_t -> t
(** [update_setting_state st setting_cmd] will update the setting of the
    current state [st] with the given [setting_cmd].*)

val get_task_names : t -> string list
(** [current_tasks st] is the list of all task names in the state [st].*)

val get_dates : t -> string list
(** [current_tasks_dates st] is the string list of all dates of state
    [st].*)

val write_state : string -> t -> unit
(** [write_state file_name st] will write the current state [st] to a
    JSON file with name [file_name].*)

val current_page : t -> page
(** [current_page st] will return the page of the current state [st].*)

val get_tasks : t -> Tasks.t
(** [get_tasks st] will get the Tasks.t for state [st]*)

val clear_state : unit -> t
(** [clear_state st] will reset the state [st] of the calendar. *)