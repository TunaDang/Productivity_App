open TodoList

exception Exit

(* let todo_file = "data" ^ Filename.dir_sep ^ "todolist.json" *)

let rec get_settings_command () =
  Output.input ();
  match Command.parse_settings (read_line ()) with
  | exception Command.Empty ->
      Output.empty ();
      get_settings_command ()
  | exception Command.Malformed ->
      Output.malformed ();
      get_settings_command ()
  | SetsHelp ->
      Output.help_settings ();
      get_settings_command ()
  | x -> x

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
  | Command.Add (_, _) | Clear | Settings ->
      State.update_state state command
  | Command.Complete i ->
      State.update_state state (Command.Complete (i - 1))
  | Edit (_, _) -> failwith "unsupported"
  | Help -> failwith "Help should not end up here"

let evaluate_settings state command =
  match command with
  | Command.Completed _ | Command.Date _ | Command.Exit
  | Command.SetsHelp | Command.Printer _ ->
      State.update_settings_state state command

let match_printer = function
  | Settings.Week -> Output.print_week
  | Settings.Tasks -> Output.print_tasks

let rec repl state file =
  match State.current_page state with
  | Main ->
      let command = get_command () in
      let state = evaluate state command in
      let print =
        match_printer
          (Settings.get_printer (State.current_settings state))
      in
      State.write_state file state;
      if command = Command.Settings then Output.print_settings state
      else print state;
      repl state file
  | Settings ->
      let sets_command = get_settings_command () in
      let state = evaluate_settings state sets_command in
      let print =
        match_printer
          (Settings.get_printer (State.current_settings state))
      in
      State.write_state file state;
      if sets_command = Command.Exit then print state
      else Output.print_settings state;
      repl state file

(** [main ()] prompts for the game to play, then starts it. *)
let main () =
  let open TodoList in
  let open ANSITerminal in
  (*RIGHT NOW THESE LINES GET OVERWRITTEN*)
  ignore (Sys.command "clear");
  move_cursor 1 1;
  print_string [ ANSITerminal.red ]
    "\n\nWelcome to The Ocaml Todo List.\n";
  print_endline "What todo list would you like to open";
  print_string [ ANSITerminal.Bold ] "> ";
  match read_line () with
  | exception End_of_file -> ()
  | file ->
      let todo_file = "data" ^ Filename.dir_sep ^ file ^ ".json" in
      let tasks =
        try Tasks.from_file todo_file
        with e ->
          ignore (open_out todo_file);
          Tasks.empty ()
      in
      let settings =
        Settings.from_file "data/attributes/settings.json"
      in
      (* create new file if none exists*)
      let state = State.pack_state tasks settings State.Main in
      (match Settings.get_printer (State.current_settings state) with
      | Week -> Output.print_week state
      | Tasks -> Output.print_tasks state);

      repl state todo_file

(* Execute the game engine. *)
let () = main ()
