open OUnit2
open TodoList
open Command
open Date

let parse_test
    (name : string)
    (expected_output : Command.t)
    (input : string) =
  name >:: fun _ -> assert_equal expected_output (Command.parse input)

let parse_tests =
  [
    parse_test "Command TEST 1: Parsing the add command"
      (Add ([ "Complete"; "CS"; "homework" ], Date.create_date "1/2"))
      "add Complete CS homework 1/2";
    parse_test "Command TEST 2: Parsing the edit command"
      (Edit ([ "Complete"; "CS"; "homework" ], Date.create_date "2/1"))
      "edit Complete CS homework 2/1";
    parse_test "Command TEST 3: Parsing the complete command"
      (Complete
         ([ "Complete"; "CS"; "homework" ], Date.create_date "11/23"))
      "complete Complete CS homework 11/23";
    ( "Command TEST 4: Assert Command raises Malformed for wrong verb"
    >:: fun _ ->
      assert_raises Malformed (fun () ->
          Command.parse "finish my homework please") );
    ( "Command TEST 5: Assert Command raises Empty for an empty command"
    >:: fun _ -> assert_raises Empty (fun () -> Command.parse "") );
    ( "Command TEST 6: Assert Command raises Empty for command with \
       spaces"
    >:: fun _ ->
      assert_raises Malformed (fun () ->
          Command.parse "                     ") );
    parse_test "Command TEST 7: Parsing the quitcommand" Quit "quit";
    parse_test
      "Command TEST 8: Parsing the add command with spaces in the \
       command"
      (Add ([ "Complete"; "CS"; "homework" ], Date.create_date "11/23"))
      "add             Complete        CS       homework    11/23      ";
    parse_test "Command TEST 3: Parsing the complete command"
      (Complete
         ([ "Complete"; "CS"; "homework" ], Date.create_date "11/23"))
      "complete Complete CS homework 11/23";
  ]

let suite =
  "test suite for the Command module" >::: List.flatten [ parse_tests ]

let _ = run_test_tt_main suite