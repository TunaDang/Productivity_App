open OUnit2
open TodoList
open Tasks
open Date

(* JSON TESTS *)
let sample_tasks = Tasks.from_file "test/data/sample_tasks.json"
let test_write = to_file "test/data/write_test.json" sample_tasks

(* [create_date_helper date_opt] extracts the date from a date option*)
let create_date_helper (date_opt : Date.t option) : Date.t =
  match date_opt with
  | None -> failwith "Invalid input"
  | Some date -> date

(*BEGIN HELPER FUNCTIONS*)
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

let date_diff_test
    (name : string)
    (d1 : string)
    (d2 : string)
    (expected : int) =
  name >:: fun _ ->
  assert_equal expected
    (date_diff
       (d1 |> Date.create_date |> create_date_helper)
       (d2 |> Date.create_date |> create_date_helper))
    ~printer:string_of_int

let to_string_test (name : string) (d1 : string) (expected : string) =
  name >:: fun _ ->
  assert_equal expected
    (to_string (d1 |> Date.create_date |> create_date_helper))

let incr_day_test (name : string) (d : string) (expected : string) =
  name >:: fun _ ->
  assert_equal expected
    (d |> Date.create_date |> create_date_helper |> Date.incr_day
   |> Date.to_string)

let incr_month_test (name : string) (d : string) (expected : string) =
  name >:: fun _ ->
  assert_equal expected
    (d |> Date.create_date |> create_date_helper |> Date.incr_month
   |> Date.to_string)

let incr_week_test (name : string) (d : string) (expected : string) =
  name >:: fun _ ->
  assert_equal expected
    (d |> Date.create_date |> create_date_helper |> Date.incr_week
   |> Date.to_string)
(*END HELPER FUNCTIONS*)

let incr_day_tests =
  [
    incr_day_test "basic test" "2/2" "2/3";
    incr_day_test "new month" "1/31" "2/1";
    incr_day_test "new month feb" "2/28" "3/1";
    incr_day_test "new year" "12/31" "1/1";
    incr_day_test "new month for 30 days" "4/30" "5/1";
  ]

let incr_month_tests =
  [
    incr_month_test "basic test" "1/4" "2/4";
    incr_month_test "new year" "12/31" "1/31";
    incr_month_test "more days than next month feb" "1/30" "2/28";
    incr_month_test "more days than next month" "3/31" "4/30";
    incr_month_test "simple test" "5/4" "6/4";
    incr_month_test "to december" "11/30" "12/30";
  ]

let incr_week_tests =
  [
    incr_week_test "basic test" "" "";
    incr_week_test "" "" "";
    incr_week_test "" "" "";
    incr_week_test "" "" "";
    incr_week_test "" "" "";
  ]

let create_date_tests =
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

let abbrv_name_tests =
  [
    abbrv_name_test "January" "1/3" "Jan.";
    abbrv_name_test "February" "2/3" "Feb.";
    abbrv_name_test "March" "3/1" "Mar.";
    abbrv_name_test "April" "4/1" "Apr.";
    abbrv_name_test "May" "5/1" "May";
    abbrv_name_test "June" "6/1" "Jun.";
    abbrv_name_test "July" "7/1" "Jul.";
    abbrv_name_test "August" "8/1" "Aug.";
    abbrv_name_test "September" "9/1" "Sep.";
    abbrv_name_test "October" "10/1" "Oct.";
    abbrv_name_test "November" "11/1" "Nov.";
    abbrv_name_test "December" "12/3" "Dec.";
  ]

let compare_tests =
  [
    compare_test "earlier month" "1/1" "2/1" ~-1;
    compare_test "later month" "3/1" "2/1" 1;
    compare_test "same date" "3/1" "3/1" 0;
    compare_test "later day" "3/2" "3/1" 1;
    compare_test "earlier day" "3/2" "3/3" ~-1;
    date_diff_test "same date" "3/2" "3/2" 0;
    date_diff_test "1st date is later" "3/3" "3/2" ~-1;
    date_diff_test "same month" "2/2" "2/25" 23;
    date_diff_test "Different Month" "2/2" "12/12" 313;
    date_diff_test "1 month apart" "3/25" "4/21" 27;
  ]

let to_string_tests =
  [
    to_string_test "Basic test Feb 2" "2/12" "2/12";
    to_string_test "edge test Jan 11" "1/1" "1/1";
    to_string_test "edge test Dec 31" "12/31" "12/31";
  ]

let suite =
  List.flatten
    [
      create_date_tests;
      abbrv_name_tests;
      compare_tests;
      to_string_tests;
      incr_day_tests;
      incr_month_tests;
      incr_week_tests;
    ]
