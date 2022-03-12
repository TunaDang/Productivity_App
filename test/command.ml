open OUnit2
open TodoList
open Command

let parse_test
    (name : string)
    (expected_output : Command.t)
    (input : string) =
  name >:: fun _ -> assert_equal expected_output (Command.parse input)

let parse_add_tests =
  [
    parse_test "Add TEST 1: Parsing the add command"
      (Add ([ "Complete"; "CS"; "homework" ], Date.create_date "1/2"))
      "add Complete CS homework 1/2";
    parse_test
      "Command TEST 8: Parsing the add command with spaces in the \
       command"
      (Add ([ "Complete"; "CS"; "homework" ], Date.create_date "11/23"))
      "add             Complete        CS       homework    11/23      ";
  ]

let parse_edit_tests =
  [
    parse_test "Edit TEST 1: Parsing the edit command"
      (Edit ([ "Complete"; "CS"; "homework" ], Date.create_date "2/1"))
      "edit Complete CS homework 2/1";
  ]

let parse_complete_tests =
  [
    parse_test "Complete TEST 1: Parsing the complete command"
      (Complete 1) "complete 1";
    parse_test
      "Command TEST 2: Parsing the complete command with spaces"
      (Complete 10) "              complete    10   ";
  ]

let parse_quit_test =
  [ parse_test "Quit TEST 1: Parsing the quitcommand" Quit "quit" ]

let assertion_tests =
  [
    ( "Command TEST 1: Assert Command raises Malformed for wrong verb"
    >:: fun _ ->
      assert_raises Malformed (fun () ->
          Command.parse "finish my homework please") );
    ( "Command TEST 1: Assert Command raises Empty for an empty command"
    >:: fun _ -> assert_raises Empty (fun () -> Command.parse "") );
    ( "Command TEST 1: Assert Command raises Empty for command with \
       spaces"
    >:: fun _ ->
      assert_raises Malformed (fun () ->
          Command.parse "                     ") );
  ]

let command_suite =
  List.flatten
    [
      parse_add_tests;
      parse_complete_tests;
      parse_edit_tests;
      parse_quit_test;
      assertion_tests;
    ]
