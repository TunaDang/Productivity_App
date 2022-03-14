open TodoList

exception Exit

let todo_file = "data" ^ Filename.dir_sep ^ "todolist.json"

let get_command () =
  Output.input ();
  (* > character for input*)
  match Command.parse (read_line ()) with
  | Command.Empty ->
      Output.empty ();
      get_command ()
  | Command.Malformed ->
      Output.malformed ();
      get_command ()
  | x -> x

let evaluate state command =
  match command with
  | Command.Quit ->
      Output.quit;
      exit 0
  | Command.Add | Command.Complete -> State.update_tasks state command

let repl state =
  while true do
    let command = get_command in
    let state = evaluate state command in
    State.write_state todo_file;
    Output.print_tasks state
  done

(** [main ()] prompts for the game to play, then starts it. *)
let main () =
  let open TodoList in
  ANSITerminal.print_string [ ANSITerminal.red ]
    "\n\nWelcome to The Ocaml Todo List.\n";
  let tasks =
    try Tasks.from_file todo_file with e -> Tasks.empty ()
  in
  (* create new file if none exists*)
  let state = State.pack_state tasks in
  repl state

(* Execute the game engine. *)
let () = main ()
