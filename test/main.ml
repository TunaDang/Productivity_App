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

let date_tests =
  [
    create_date_test "Basic test" "1/2" "1/2";
    create_date_test "Feb edge" "2/28" "2/28";
    create_date_test "Jan edge" "3/31" "3/31";
    create_date_test "April edge" "4/30" "4/30";
    ( "InvalidDateFormat day" >:: fun _ ->
      assert_raises (InvalidDateFormat "2/29") (fun () ->
          Date.create_date "2/29") );
    ( "InvalidDateFormat month" >:: fun _ ->
      assert_raises (InvalidDateFormat "13/2") (fun () ->
          Date.create_date "13/2") );
    ( "non int input exc" >:: fun _ ->
      assert_raises (Failure "int_of_string") (fun () ->
          Date.create_date "apple/2") );
  ]

let tasks_tests = []

let suite =
  "test suite for A2" >::: List.flatten [ date_tests; tasks_tests ]

let _ = run_test_tt_main suite