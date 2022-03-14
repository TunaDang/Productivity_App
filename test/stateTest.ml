open OUnit2
open TodoList

let state_test
    (name : string)
    (expected_output : string list)
    (input_cmd : Command.t)
    (input_state : State.t) =
  name >:: fun _ ->
  assert_equal expected_output
    (State.get_tasks (State.update_tasks input_cmd input_state))

let state_add_tests =
  [
    state_test "State TEST 1: Adding a task" [ "Complete cs hw." ]
      (Add ([ "Complete"; "cs"; "hw." ], Date.create_date "1/2"));
  ]

let state_suite = []
