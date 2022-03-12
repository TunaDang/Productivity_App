open OUnit2

let suite =
  "Test suite for everything"
  >::: List.flatten [ Command.command_suite ]

let _ = run_test_tt_main suite