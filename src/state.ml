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
  {
    current_tasks = Tasks.empty ();
    current_settings =
      Settings.from_file "data/attributes/settings.json";
    current_page = Main;
  }

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
  | Help -> failwith "Unsupported"
  | Quit -> failwith "Unsupported"

let update_settings_state (st : t) (settings_cmd : Command.setting_t) =
  match settings_cmd with
  | Toggle on_off ->
      pack_state st.current_tasks
        (Settings.set_display_completed st.current_settings on_off)
        Settings
  | Date date ->
      pack_state st.current_tasks
        (Settings.set_due_before st.current_settings date)
        Settings
  | SetsHelp -> st
  | Exit -> pack_state st.current_tasks st.current_settings Main

let get_task_names (state : t) =
  Tasks.tasks_names_with_filter state.current_tasks
    state.current_settings

let get_dates (state : t) =
  Tasks.tasks_dates_with_filter state.current_tasks
    state.current_settings

let get_tasks state =
  let completed =
    Settings.get_display_completed state.current_settings
  in
  let due_before = Settings.get_due_before state.current_settings in
  Tasks.tasks_filter state.current_tasks completed due_before

let current_page st = st.current_page
let current_settings st = st.current_settings

let write_state (file_name : string) (st : t) =
  Tasks.to_file file_name st.current_tasks
