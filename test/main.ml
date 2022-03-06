open OUnit2

let tasks_tests = []
let suite = "test suite for A2" >::: List.flatten [ tasks_tests ]
let _ = run_test_tt_main suite