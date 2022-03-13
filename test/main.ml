open OUnit2

let suite =
  "test suite for A2"
  >::: List.flatten [ DateTest.suite; TasksTest.suite ]

let _ = run_test_tt_main suite