open TodoList

exception Exit

let todo_file = "data" ^ Filename.dir_sep ^ "todolist.json"

let rec get_command () =
  Output.input ();
  (* > character for input*)
  match Command.parse (read_line ()) with
  | exception Command.Empty ->
      Output.empty ();
      get_command ()
  | exception Command.Malformed ->
      Output.malformed ();
      get_command ()
  | Help ->
      Output.help ();
      get_command ()
  | x -> x

let evaluate state command =
  match command with
  | Command.Quit ->
      Output.quit ();
      exit 0
  | Command.Add (_, _) | Clear -> State.update_state state command
  | Command.Complete i ->
      State.update_state state (Command.Complete (i - 1))
  | Edit (_, _) -> failwith "unsupported"
  | Help -> failwith "Help should not end up here"

let rec repl state =
  let command = get_command () in
  let state = evaluate state command in
  State.write_state todo_file state;
  Output.print_tasks state;
  repl state

(** [main ()] prompts for the game to play, then starts it. *)
let main () =
  let open TodoList in
  let open ANSITerminal in
  (*RIGHT NOW THESE LINES GET OVERWRITTEN*)
  erase Screen;
  move_cursor 1 1;
  print_string [ ANSITerminal.red ]
    "\n\nWelcome to The Ocaml Todo List.\n";
  let tasks =
    try Tasks.from_file todo_file
    with e ->
      ignore (open_out todo_file);
      Tasks.empty ()
  in
  (* create new file if none exists*)
  let state = State.pack_state tasks in
  Output.print_tasks state;
  repl state

(* Execute the game engine. *)
let () = main ()
