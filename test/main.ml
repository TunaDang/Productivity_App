open OUnit2

let suite =
  "Test suite for everything" >::: List.flatten [ CommandTest.suite ]

let _ = run_test_tt_main suite