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
  name >:: fun _ ->
  assert_equal expected
    (Tasks.task_names input_t)
    ~printer:(String.concat " ")

let task_name_test
    (name : string)
    (input_t : Tasks.t)
    (input_int : int)
    (expected : string) : test =
  name >:: fun _ ->
  assert_equal expected
    (Tasks.task_name input_t input_int)
    ~printer:String.escaped

let task_date_test
    (name : string)
    (input_t : Tasks.t)
    (input_int : int)
    (expected : string) : test =
  name >:: fun _ ->
  assert_equal expected
    (Tasks.task_date input_t input_int)
    ~printer:String.escaped

let completed_test
    (name : string)
    (input_t : Tasks.t)
    (input_int : int)
    (expected : bool) : test =
  name >:: fun _ ->
  assert_equal expected
    (Tasks.completed input_t input_int)
    ~printer:string_of_bool

let tasks_amount_test
    (name : string)
    (input_t : Tasks.t)
    (expected : int) : test =
  name >:: fun _ ->
  assert_equal expected
    (Tasks.tasks_amount input_t)
    ~printer:string_of_int

let complete_test
    (name : string)
    (input_t : Tasks.t)
    (input_int : int)
    (expected : bool) : test =
  name >:: fun _ ->
  assert_equal expected
    (Tasks.completed (Tasks.complete input_t input_int) input_int)
    ~printer:string_of_bool

(* Check new tasks by checking against take name list*)
let add_test
    (name : string)
    (input_t : Tasks.t)
    (input_name : string)
    (input_date : string)
    (expected : string list) : test =
  name >:: fun _ ->
  assert_equal expected
    (Tasks.add input_t input_name
       (input_date |> Date.create_date |> create_date_helper)
    |> Tasks.task_names)
    ~printer:(String.concat " ")

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
    task_names_test "sample tasks test" sample_tasks
      [ "Buy Milk"; "A3"; "Get that bread" ];
    task_name_test "get 1st task name from sample tasks" sample_tasks 0
      "Buy Milk";
    task_name_test "get 3rd task name from sample tasks" sample_tasks 2
      "Get that bread";
    task_date_test "get 2nd task date from sample tasks" sample_tasks 1
      "3/23";
    completed_test "get 1st task completed status from sample tasks"
      sample_tasks 0 true;
    tasks_amount_test "sample tasks amount" sample_tasks 3;
    complete_test "complete 2nd task from sample tasks" sample_tasks 1
      true;
    ( "Already Complete task" >:: fun _ ->
      assert_raises (AlreadyComplete 0) (fun () ->
          Tasks.complete sample_tasks 0) );
    add_test "Add new task" sample_tasks "Finish testing" "3/13"
      [ "Finish testing"; "Buy Milk"; "A3"; "Get that bread" ];
  ]

let suite =
  "test suite for A2" >::: List.flatten [ date_tests; tasks_tests ]

let _ = run_test_tt_main suite