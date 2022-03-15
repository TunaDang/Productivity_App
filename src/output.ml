(* art from https://www.asciiart.eu/animals/camels and
   https://patorjk.com/software/taag/#p=display&f=Standard&t=OCaml%20TodoList *)

(* TODO: Print should display correctly for completed tasks. make
   something like () or (*) and completed is bold *)*)

(* Tasks with and without dates should print correctly. And
   differently! *)
(* numbers should start at 1, not 0. This means must subtract 1 from the
   number the user enters*)
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

(*Print them in the following way, where i is number of task i. <Name of
  Task> -- [<due date>] - <due date - current date> days remaining
  ... *)

(*helper function to go from string list * string list to string *
  string list*)
let pack_string_list l1 l2 = List.map2 (fun x y -> (x, y)) l1 l2
let no_date_format = "%d. %s"
let date_format = "%d. %s [%s] - <> days remaining"

(* helper function to format a single task into the right output*)
let format_task i task =
  let i = i + 1 in
  (*to display starting at 1*)
  let name = fst task in
  let date = snd task in
  let output =
    if date = "" then Printf.sprintf "%d. %s" i name
    else Printf.sprintf "%d. %s [%s] - <> days remaining" i name date
  in
  output

let print_ascii_art () =
  ANSITerminal.print_string [ ANSITerminal.yellow ] ascii_art

let print_tasks st =
  let open ANSITerminal in
  let tasks = State.get_tasks st in
  let dates = State.get_dates st in
  print_int (List.length tasks);
  print_int (List.length dates);
  let tasks_dates = pack_string_list tasks dates in
  let lines = List.mapi format_task tasks_dates in
  erase Screen;
  set_cursor 1 1;
  print_ascii_art ();
  List.iter (fun str -> print_endline str) lines;
  print_endline "\n\n\n\n\n";
  set_cursor 1 100

let input () = print_string "> "
let quit () = print_endline "Quitting..."
let empty () = print_endline "Empty input. Please re-enter valid entry."

let malformed () =
  print_endline "Malformed input. Please re-enter valid entry."

let help () = print_endline "help menu"
