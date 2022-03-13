(* This module is responsible for outputting the current state of the
   task list to the user*)

  (* Currently the only supported printing is one task per line*)


  val ascii_art : string

  (*Prints the tasks in the current list of the application. 
  Tasks are printed in the same order as they appear in the list*)
  val print_tasks : State.t