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
      "add Complete CS homework. 1/2";
    parse_test
      "Add TEST 2: Parsing the add command with spaces in the command"
      (Add ([ "Complete"; "CS"; "homework" ], Date.create_date "11/23"))
      "add             Complete        CS       homework .   \
       11/23      ";
  ]

let parse_edit_tests =
  [
    parse_test "Edit TEST 1: Parsing the edit command"
      (Edit ([ "Complete"; "CS"; "homework." ], Date.create_date "2/1"))
      "edit Complete CS homework. 2/1";
  ]

let parse_complete_tests =
  [
    parse_test "Complete TEST 1: Parsing the complete command"
      (Complete 1) "complete 1";
    parse_test
      "Command TEST 2: Parsing the complete command with spaces"
      (Complete 10) "              complete    10   ";
    ( "Command TEST 3: Parsing the complete command with invalid date"
    >:: fun _ ->
      assert_raises Malformed (fun () ->
          Command.parse "              complete    what   ") );
  ]

let parse_quit_test =
  [
    parse_test "Quit TEST 1: Parsing the quitcommand" Quit "quit";
    parse_test "Quit TEST 2: Parsing quit with a period" Quit "quit.";
  ]

let get_phrase_test
    (name : string)
    (expected_output : string)
    (input : string) =
  name >:: fun _ ->
  assert_equal expected_output
    (input |> Command.parse |> Command.get_phrase)

let get_phrase_tests =
  [
    get_phrase_test
      "Get phrase TEST 1: Getting a valid input's phrase with a date"
      "finish my homework" "add finish my homework. 3/1";
    get_phrase_test
      "Get phrase TEST 2: Getting a valid input's phrase without a date"
      "finish my homework" "add finish my homework.";
    get_phrase_test
      "Get phrase TEST 3: Getting a valid input's phrase with spaces"
      "finish my homework" "add        finish   my       homework.";
    get_phrase_test
      "Get phrase TEST 4: Getting a valid input's phrase with spaces \
       and a date"
      "finish my homework"
      "add        finish   my       homework.      3/2";
  ]

let assertion_tests =
  [
    ( "Assertion TEST 1: Assert Command raises Malformed for wrong verb"
    >:: fun _ ->
      assert_raises Malformed (fun () ->
          Command.parse "finish my homework please") );
    ( "Assertion TEST 2: Assert Command raises Empty for an empty \
       command"
    >:: fun _ -> assert_raises Empty (fun () -> Command.parse "") );
    ( "Assertion TEST 3: Assert Command raises Empty for command with \
       spaces"
    >:: fun _ ->
      assert_raises Empty (fun () ->
          Command.parse "                     ") );
    ( "Assertion TEST 4: Assert quit raises Malformed for including \
       extra things"
    >:: fun _ ->
      assert_raises Malformed (fun () -> Command.parse "quit hello yes")
    );
    ( "Assertion TEST 5: Assert add raises Empty for not including any \
       phrase"
    >:: fun _ -> assert_raises Empty (fun () -> Command.parse "add") );
    ( "Assertion TEST 6: Assert add raises Empty for not including any \
       phrase with a period"
    >:: fun _ -> assert_raises Empty (fun () -> Command.parse "add .")
    );
    ( "Assertion TEST 7: Assert get phrase raises Invalid for using \
       complete"
    >:: fun _ ->
      assert_raises Invalid (fun () ->
          "complete 10" |> Command.parse |> Command.get_phrase) );
    ( "Assertion TEST 8: Assert get phrase raises Invalid for using quit"
    >:: fun _ ->
      assert_raises Invalid (fun () ->
          "quit" |> Command.parse |> Command.get_phrase) );
  ]

let command_suite =
  List.flatten
    [
      parse_add_tests;
      parse_complete_tests;
      parse_quit_test;
      get_phrase_tests;
      assertion_tests;
    ]
