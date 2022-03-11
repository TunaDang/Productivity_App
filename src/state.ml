type t = { current_tasks : Tasks.t }

let init_state (tsks : Tasks.t) : t = { current_tasks = tsks }

type result =
  | Valid of t
  | Invalid

let update_tasks (cmd : Command.t) (st : t) : result =
  failwith "Unimplemented"
