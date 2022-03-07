type phrase = string list

type t =
  | Add of phrase * Date.t
  | Complete of phrase * Date.t
  | Edit of phrase * Date.t
  | Quit

exception Empty
exception Malformed

let parse = failwith "Unimplemented"