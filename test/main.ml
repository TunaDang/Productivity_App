open OUnit2
open TodoList
open Tasks
open Date

let sample_tasks = Tasks.from_file "src/data/sample.json"

(* DATE TESTS*)

(**[create_date_helper date_opt] extracts the date from a date option*)
let create_date_helper (date_opt : Date.t option) : Date.t =
  match date_opt with
  | None -> failwith "Invalid input"
  | Some date -> date

let create_date_test (name : string) (str : string) (expected : string)
    : test =
  name >:: fun _ ->
  assert_equal expected
    (str |> Date.create_date |> create_date_helper |> Date.to_string)
    ~printer:String.escaped

let abbrv_name_test (name : string) (str : string) (expected : string) :
    test =
  name >:: fun _ ->
  assert_equal expected
    (str |> Date.create_date |> create_date_helper |> Date.abbrv_name)
    ~printer:String.escaped

let compare_test
    (name : string)
    (d1 : string)
    (d2 : string)
    (expected : int) =
  name >:: fun _ ->
  assert_equal expected
    (compare
       (d1 |> Date.create_date |> create_date_helper)
       (d2 |> Date.create_date |> create_date_helper))

(*TASKS TESTS*)

let task_names_test
    (name : string)
    (input_t : Tasks.t)
    (expected : string list) : test =
  failwith "not impl"

let task_name_test
    (name : string)
    (input_t : Tasks.t)
    (input_int : int)
    (expected : string) : test =
  failwith "not impl"

let task_date_test
    (name : string)
    (input_t : Tasks.t)
    (input_int : int)
    (expected : string) : test =
  failwith "not impl"

let completed_test
    (name : string)
    (input_t : Tasks.t)
    (input_int : int)
    (expected : bool) : test =
  failwith "not impl"

let tasks_amount_test
    (name : string)
    (input_t : Tasks.t)
    (expected : int) : test =
  failwith "not impl"

(*[complete_test_aux input_t] returns the completed value of the [n]th
  task of [input_t]*)
let complete_test_aux (input_t : Tasks.t) (n : int) : bool =
  Tasks.completed input_t n

let complete_test
    (name : string)
    (input_t : Tasks.t)
    (input_int : int)
    (expected : bool) : test =
  failwith "not impl"

(*TODO STILL: What should expected be?*)
let add_test
    (name : string)
    (input_t : Tasks.t)
    (input_name : string)
    (input_date : string)
    (expected : string) : test =
  failwith "not impl"

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
    abbrv_name_test "January" "1/3" "Jan.";
    abbrv_name_test "December" "12/3" "Dec.";
    compare_test "earlier month" "1/1" "2/1" ~-1;
    compare_test "later month" "3/1" "2/1" 1;
    compare_test "same date" "3/1" "3/1" 0;
    compare_test "later day" "3/2" "3/1" 1;
    compare_test "earlier day" "3/2" "3/3" ~-1;
  ]

let tasks_tests =
  [
    ( {|Rooms from "ho plaza" is
      ["Ho Plaza"; "northeast"; "north east"]|}
    >:: fun _ -> assert_equal "Buy Milk" (task_name sample_tasks 0) );
  ]

let suite =
  "test suite for A2" >::: List.flatten [ date_tests; tasks_tests ]

let _ = run_test_tt_main suite