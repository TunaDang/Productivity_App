open OUnit2
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
    Date.create_date and Date.string*)
let create_date_test (name : string) (str : string) (expected : string)
    : test =
  name >:: fun _ ->
  assert_equal expected
    (str |> Date.create_date |> create_date_helper |> Date.to_string)

let date_tests = []
let tasks_tests = []

let suite =
  "test suite for A2" >::: List.flatten [ date_tests; tasks_tests ]

let _ = run_test_tt_main suite