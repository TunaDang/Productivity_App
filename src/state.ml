type t = { current_tasks : Tasks.t }

let init_state (tsks : Tasks.t) : t = { current_tasks = tsks }
let update_tasks (cmd : Command.t) (st : t) = failwith "Unimplemented"
(* match cmd with | Add (phrase, date) -> Tasks.add t.current_tasks
   phrase date | Complete task -> Tasks.complete t.current_tasks task |
   Edit (phrase, date) -> Tasks.edit t.current_tasks phrase date | Quit
   -> Tasks.quit *)

let get_tasks (tasks : t) = Tasks.task_name tasks.current_tasks
let get_dates (tasks : t) = [ "" ]
