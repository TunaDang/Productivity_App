type page =
  | Main
  | Settings

type t = {
  current_tasks : Tasks.t;
  current_settings : Settings.t;
  current_page : page;
}

let pack_state (tsks : Tasks.t) (settings : Settings.t) (page : page) :
    t =
  {
    current_tasks = tsks;
    current_settings = settings;
    current_page = page;
  }

let clear_state () =
  pack_state (Tasks.empty ())
    (Settings.from_file "../data/settings.json")
    Main

let update_state (st : t) (cmd : Command.t) =
  match cmd with
  | Add (phrase, date) ->
      let new_tasks =
        Tasks.add st.current_tasks (Command.get_phrase cmd) date
      in
      pack_state new_tasks st.current_settings Main
  | Complete task -> (
      try
        let new_tasks = Tasks.complete st.current_tasks task in
        pack_state new_tasks st.current_settings Main
      with Tasks.ElementOutofBounds n -> st)
  | Edit (phrase, date) -> failwith "Unsupported"
  | Clear -> clear_state ()
  | Settings -> pack_state st.current_tasks st.current_settings Settings
  | Select setting_id -> st
  | Date date ->
      pack_state st.current_tasks
        (Settings.set_due_before st.current_settings date)
        Settings
  | Help -> failwith "Unsupported"
  | Quit -> failwith "Unsupported"

let get_task_names (tasks : t) = Tasks.task_names tasks.current_tasks
let get_dates (tasks : t) = Tasks.task_dates tasks.current_tasks
let get_tasks state = state.current_tasks

let write_state (file_name : string) (st : t) =
  Tasks.to_file file_name st.current_tasks
