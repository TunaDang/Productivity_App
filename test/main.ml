open OUnit2



let date_tests = []
let tasks_tests = []

let suite =
  "test suite for A2" >::: List.flatten [ date_tests; tasks_tests ]

let _ = run_test_tt_main suite