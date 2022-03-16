type t = { current_tasks : Tasks.t }

let pack_state (tsks : Tasks.t) : t =
  print_int (Tasks.tasks_amount tsks);
  { current_tasks = tsks }

let clear_state () = pack_state (Tasks.empty ())

let update_tasks (st : t) (cmd : Command.t) =
  match cmd with
  | Add (phrase, date) ->
      Tasks.add st.current_tasks (Command.get_phrase cmd) date
      |> pack_state
  | Complete task -> Tasks.complete st.current_tasks task |> pack_state
  | Edit (phrase, date) -> failwith "Unsupported"
  | Clear -> clear_state ()
  | Help -> failwith "Unsupported"
  | Quit -> failwith "Unsupported"

let get_task_names (tasks : t) = Tasks.task_names tasks.current_tasks
let get_dates (tasks : t) = Tasks.task_dates tasks.current_tasks
let get_tasks state = state.current_tasks

let write_state (file_name : string) (st : t) =
  Tasks.to_file file_name st.current_tasks
