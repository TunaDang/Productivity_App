open OUnit2

let suite =
  "test suite for everything"
  >::: List.flatten
         [ DateTest.suite; TasksTest.suite; CommandTest.suite ]

let _ = run_test_tt_main suite