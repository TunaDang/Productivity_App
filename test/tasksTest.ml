open OUnit2
open TodoList
open Tasks
open Date

let sample_tasks = Tasks.from_file "test/data/sample_tasks.json"
let grocery_tasks = Tasks.from_file "test/data/grocery_tasks.json"

(**[create_date_helper date_opt] extracts the date from a date option*)
let create_date_helper (date_opt : Date.t option) : Date.t =
  match date_opt with
  | None -> failwith "Invalid input"
  | Some date -> date

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
    (Tasks.task_date_str input_t input_int)
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

let task_dates_test
    (name : string)
    (input_t : Tasks.t)
    (expected : string list) : test =
  name >:: fun _ ->
  assert_equal expected
    (Tasks.task_dates input_t)
    ~printer:(String.concat " ")

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
       (Some (input_date |> Date.create_date |> create_date_helper))
    |> Tasks.task_names)
    ~printer:(String.concat " ")

let task_names_tests =
  [
    task_names_test "sample tasks test" sample_tasks
      [ "Buy Milk"; "A3"; "Get that bread" ];
    task_names_test "Grocery tasks test" grocery_tasks
      [ "Oranges"; "Apples"; "Steak" ];
    task_names_test "Grocery tasks after adding"
      (Tasks.add grocery_tasks "Pears" None)
      [ "Oranges"; "Apples"; "Steak"; "Pears" ];
  ]

let task_name_tests =
  [
    task_name_test "get 1st task name from sample tasks" sample_tasks 0
      "Buy Milk";
    task_name_test "get 3rd task name from sample tasks" sample_tasks 2
      "Get that bread";
    task_name_test "1st task from grocery" grocery_tasks 0 "Oranges";
    task_name_test "2nd task from grocery" grocery_tasks 1 "Apples";
    task_name_test "3rd task from grocery" grocery_tasks 2 "Steak";
  ]

let task_date_tests =
  [
    task_date_test "get 2nd task date from sample tasks" sample_tasks 1
      "3/23";
    task_date_test "get 1st task date from grocery tasks" grocery_tasks
      0 "3/15";
    task_date_test "get 2nd task date from grocery tasks" grocery_tasks
      1 "4/16";
    task_date_test "get 3rd task date from grocery tasks" grocery_tasks
      2 "9/21";
  ]

let completed_tests =
  [
    completed_test "get 1st task completed status from sample tasks"
      sample_tasks 0 true;
    completed_test "get 3rd task completed status from grocery list"
      grocery_tasks 2 true;
    completed_test "get 2nd task not completed status from grocery list"
      grocery_tasks 1 false;
    completed_test "get 1st task not completed status from grocery list"
      grocery_tasks 0 false;
  ]

let tasks_amount_tests =
  [
    tasks_amount_test "sample tasks amount" sample_tasks 3;
    tasks_amount_test "grocery tasks amount" grocery_tasks 3;
    tasks_amount_test "Grocery tasks after adding"
      (Tasks.add grocery_tasks "Pears" None)
      4;
  ]

let complete_tests =
  [
    complete_test "complete 2nd task from sample tasks" sample_tasks 1
      true;
    ( "Already Complete task" >:: fun _ ->
      assert_raises (AlreadyComplete 0) (fun () ->
          Tasks.complete sample_tasks 0) );
  ]

let task_dates_tests =
  [
    task_dates_test "sample data dates" sample_tasks
      [ "3/15"; "3/23"; "4/20" ];
    task_dates_test "grocery data dates" grocery_tasks
      [ "3/15"; "4/16"; "9/21" ];
  ]

let add_tests =
  [
    add_test "Add new task" sample_tasks "Finish testing" "3/25"
      [ "Buy Milk"; "A3"; "Finish testing"; "Get that bread" ];
    add_test "Add new task to grocery" grocery_tasks "Mac N Cheese"
      "2/11"
      [ "Mac N Cheese"; "Oranges"; "Apples"; "Steak" ];
  ]

let suite =
  List.flatten
    [
      task_names_tests;
      task_name_tests;
      task_date_tests;
      completed_tests;
      tasks_amount_tests;
      complete_tests;
      task_dates_tests;
      add_tests;
    ]
