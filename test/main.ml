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
    [Date.create_date] and [Date.string]. Will also test [Date.day] and
    [Date.month_num] as those functions are called in [Date.to_string]*)
let create_date_test (name : string) (str : string) (expected : string)
    : test =
  name >:: fun _ ->
  assert_equal expected
    (str |> Date.create_date |> create_date_helper |> Date.to_string)
    ~printer:String.escaped

(*TODO: Add test cases for create_date_test Make sure to add tests for
  if InvalidFormat being raised, not date input, Failure
  "int_of_string"*)
let date_tests = [ 
  create_date_test "Basic test" "1/2" "1/2";
  create_date_test "Another basic test" "12/12" "12/12";
  
  ]
let tasks_tests = []

let suite =
  "test suite for A2" >::: List.flatten [ date_tests; tasks_tests ]

let _ = run_test_tt_main suite