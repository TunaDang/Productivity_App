(* art from https://www.asciiart.eu/animals/camels and
   https://patorjk.com/software/taag/#p=display&f=Standard&t=OCaml%20TodoList *)

(* End of file should exit gracefully*)

let ascii_art =
  {|
                ,,__
      ..  ..   / o._)    ___   ____                _   _____         _       _     _     _                  
      /--'/--\  \-'||   / _ \ / ___|__ _ _ __ ___ | | |_   _|__   __| | ___ | |   (_)___| |_     
    /        \_/ / |   | | | | |   / _` | '_ ` _ \| |   | |/ _ \ / _` |/ _ \| |   | / __| __|                      
  .'\  \__\  __.'.'    | |_| | |__| (_| | | | | | | |   | | (_) | (_| | (_) | |___| \__ \ |_  
    )\ |  )\ |          \___/ \____\__,_|_| |_| |_|_|   |_|\___/ \__,_|\___/|_____|_|___/\__|
    // \\ // \\
  ||_  \\|_  \\_
  '--' '--'' '--'
|}

let camel =
  {|
                  ,,__
        ..  ..   / o._)
       /--'/--\  \-'||
      /        \_/ / |     
    .'\  \__\  __.'.'    
      )\ |  )\ |      
     // \\ // \\
    ||_  \\|_  \\_
    '--' '--'' '--'
  |}

let settings_page =
  {|
   _____      _   _   _                 
  / ____|    | | | | (_)                
 | (___   ___| |_| |_ _ _ __   __ _ ___ 
  \___ \ / _ \ __| __| | '_ \ / _` / __|
  ____) |  __/ |_| |_| | | | | (_| \__ \
 |_____/ \___|\__|\__|_|_| |_|\__, |___/
                               __/ |    
                              |___/     
|}

(*Print them in the following way, where i is number of task i. <Name of
  Task> -- [<due date>] - <due date - current date> days remaining
  ... *)

(*helper function to go from string list * string list to string *
  string list*)
let pack_string_list l1 l2 = List.map2 (fun x y -> (x, y)) l1 l2
let no_date_format = "%d. %s"
let date_format = "%d. %s [%s] - <> days remaining"

let unpack_some = function
  | Some x -> x
  | None -> failwith "Cannot be none"

(* helper function to format a single task into the right output*)
let format_task tasks i =
  (*to display starting at 1*)
  (*TODO: factor this out into different functions based on complete or
    date*)
  let name = Tasks.task_name tasks i in
  let date_opt = Tasks.task_date_opt tasks i in
  let complete = Tasks.completed tasks i in
  let print_i = i + 1 in
  let star = if complete then "( * )" else "(   )" in
  let mods = ref (if complete then [ ANSITerminal.Bold ] else []) in
  let output =
    if date_opt = None then
      Printf.sprintf "%s   %d. %s" star print_i name
    else
      let date_str = Tasks.task_date_str tasks i in
      let days_left = Date.days_remaining (unpack_some date_opt) in
      if days_left < 0 then
        let () =
          if complete then () else mods := ANSITerminal.red :: !mods
        in
        Printf.sprintf "%s   %d. %s [%s] - OVERDUE" star print_i name
          date_str
      else
        Printf.sprintf "%s   %d. %s [%s] - <%d> days remaining" star
          print_i name date_str days_left
  in
  (output, complete, !mods)

let format_settings (sets : Settings.t) i =
  let toggle = Settings.toggle sets i in
  let change_printer = Settings.is_view sets i in
  let name = Settings.setting sets i |> String.capitalize_ascii in
  let print_i = i + 1 in
  if toggle then
    if Settings.get_display_completed sets then
      Printf.sprintf "%d. %s: ON" print_i name
    else Printf.sprintf "%d. %s: OFF" print_i name
  else if change_printer then
    match Settings.get_printer sets with
    | Settings.Week -> Printf.sprintf "%d. %s: Week" print_i name
    | Settings.Tasks -> Printf.sprintf "%d. %s: Tasks" print_i name
  else
    let due_before = Settings.get_due_before sets in
    if due_before = None then Printf.sprintf "%d. %s: None" print_i name
    else
      Printf.sprintf "%d. %s: %s" print_i name
        (Date.to_string_opt due_before)

let print_ascii_art () =
  ANSITerminal.print_string [ ANSITerminal.yellow ] ascii_art

let print_camel () =
  ANSITerminal.print_string [ ANSITerminal.yellow ] camel

let print_settings_menu () =
  ANSITerminal.print_string [ ANSITerminal.yellow ] settings_page

(* Helper function to get a range list*)
let rec range i j = if i > j then [] else i :: range (i + 1) j

let print_tasks st =
  let open ANSITerminal in
  let tasks = State.get_tasks st in
  let length = Tasks.tasks_amount tasks in
  let formatted_tasks =
    List.map (format_task tasks) (range 0 (length - 1))
  in
  ignore (Sys.command "clear");
  set_cursor 1 1;
  print_ascii_art ();
  List.iter
    (fun (str, com, mods) -> print_string mods (str ^ "\n"))
    formatted_tasks;
  print_endline "\n\n\n\n\n";
  set_cursor 1 100

let format_task_week tasks counter i =
  counter := !counter + 1;
  let name = Tasks.task_name tasks i in
  let complete = Tasks.completed tasks i in
  let print_i = !counter in
  let star = if complete then "( * )" else "(   )" in
  let mods = ref (if complete then [ ANSITerminal.Bold ] else []) in
  let output = Printf.sprintf "%s   %d. %s" star print_i name in
  (output, !mods)

(* helper function that prints a string with the day and then the tasks
   associated with that day *)
let print_week_str day date tsks counter =
  let open ANSITerminal in
  match Tasks.tasks_on_date tsks date with
  | None ->
      print_string [ ANSITerminal.yellow ] day;
      print_string [] ": \n<No Tasks>\n"
  | Some tasks ->
      let length = Tasks.tasks_amount tasks in
      let formatted_tasks =
        List.map (format_task_week tasks counter) (range 0 (length - 1))
      in
      print_string [ ANSITerminal.yellow ] (day ^ ":\n");
      List.iter
        (fun (str, mods) -> print_string mods (str ^ "\n"))
        formatted_tasks;
      print_string [] "\n"

let get_next_week_str () =
  let rec add_days c days =
    if c = 0 then days
    else
      match days with
      | h :: t -> Date.next_day_of_week h :: h :: t |> add_days (c - 1)
      | _ -> failwith "other patterns not possible"
  in
  let day = Date.day_of_week () in
  let v = List.rev (add_days 6 [ day ]) in
  v

let get_next_week_date () =
  let rec add_days c days =
    if c = 0 then days
    else
      match days with
      | h :: t -> Date.incr_day h :: h :: t |> add_days (c - 1)
      | _ -> failwith "other patterns not possible"
  in
  let day = Date.get_today () in
  let v = List.rev (add_days 6 [ day ]) in
  v

let print_week st =
  let open ANSITerminal in
  ignore (Sys.command "clear");
  set_cursor 1 1;
  print_ascii_art ();
  let tasks = State.get_tasks st in
  let next_week_str = get_next_week_str () in
  let next_week_date = get_next_week_date () in
  let counter = ref 0 in
  List.iter2
    (fun x y -> print_week_str x y tasks counter)
    next_week_str next_week_date;
  print_endline "";
  set_cursor 1 100

let print_settings st =
  let open ANSITerminal in
  let length = 3 in
  let formatted_settings =
    List.map
      (format_settings (State.current_settings st))
      (range 0 (length - 1))
  in
  ignore (Sys.command "clear");
  set_cursor 1 1;
  print_settings_menu ();
  List.iter (fun str -> print_endline str) formatted_settings;
  print_endline "\n\n\n\n\n";
  set_cursor 1 100

let input () = print_string "> "
let quit () = print_endline "Quitting..."
let empty () = print_endline "Empty input. Please re-enter valid entry."

let malformed () =
  print_endline "Malformed input. Please re-enter valid entry."

let settings () = "Here's the settings page"

let help () =
  print_endline
    "Ocaml_Todo_List is a terminal-based productivity application that \
     utilizes ASCII art to display your goals in a pretty and fun way: \n\
     * To add a task to your todo list type the following in the \
     command line: “add [task_name]. (optional) [date]”. Note: the \
     period is required. \n\
     * Relative date input is also supported for phrases such as \
     “tomorrow”, “next week”, and “next month.” Ex: add buy milk. \
     tomorrow\n\
    \     * To mark a task completed, type “complete [index]”\n\
     * To clear the list, type “clear”\n\
     * To leave the todo list, type: “quit”\n\
     * To enter the settings menu, type “settings”"

let help_settings () =
  print_endline
    "Here are some the settings currently supported: \n\
     * To toggle display completed items on or off, type show-complete \
     on/off”\n\
     * To set the due date, type “date ##/##”.\n\
     * To set the due date to None, type “date”\n\
     * To change the view of the todo-list type printer Week/Tasks\n\
     * To exit the settings menu, type “exit”."
