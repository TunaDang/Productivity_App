open OUnit2
open Command

let date_tests = []
let tasks_tests = []

let suite =
  "Test suite for everything"
  >::: List.flatten [ Command.command_suite; date_tests; tasks_tests ]

let _ = run_test_tt_main suite