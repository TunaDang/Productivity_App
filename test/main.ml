open OUnit2
<<<<<<< HEAD
open TodoList
open Date
open Tasks

(* Date tests *)

(**[create_date_helper] exracts the date from a date option*)
let create_date_helper (date_opt : Date.t option) : Date.t =
  match date_opt with
  | None -> failwith "Invalid input"
  | Some date -> date

(** [create_date_test] tests the creation of a date given an input
    string and the conversion of a date back a readable string Tests
    [Date.create_date] and [Date.string]. Will also test [Date.day] and
    [Date.month_num] as those functions are called in [Date.to_string]*)
let create_date_test (name : string) (str : string) (expected : string)
    : test =
  name >:: fun _ ->
  assert_equal expected
    (str |> Date.create_date |> create_date_helper |> Date.to_string)
=======
open Command
>>>>>>> cc9be0be6fa72f437b177845229a3c345942ec69

let date_tests = []
let tasks_tests = []

let suite =
  "Test suite for everything"
  >::: List.flatten [ Command.command_suite; date_tests; tasks_tests ]

let _ = run_test_tt_main suite