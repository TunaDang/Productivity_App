open OUnit2
open TodoList
open Tasks
open Date

let sample_tasks = Tasks.from_file "test/data/sample_tasks.json"

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
    add_test "Add new task" sample_tasks "Finish testing" "3/25"
      [ "Buy Milk"; "A3"; "Finish testing"; "Get that bread" ];
    task_dates_test "sample data dates" sample_tasks
      [ "3/15"; "3/23"; "4/20" ];
  ]

let suite = tasks_tests
