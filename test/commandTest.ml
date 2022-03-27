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

let parse_clear_test =
  [
    parse_test "Clear TEST 1: Parsing the clear command" Clear "clear";
    parse_test "Clear TEST 2: Parsing the clear command" Clear "clear.";
  ]

let parse_settings_test =
  [
    parse_test "Settings TEST 1: Parsing regular settings command"
      Settings "settings";
    parse_test "Settings TEST 2: Parsing regular settings command"
      Settings "settings.";
  ]

let parse_select_test =
  [
    parse_test "Select TEST 1: Parsing a regular number" (Select 1) "1";
    parse_test "Select TEST 2: Parsing a regular two digit number"
      (Select 29457394852) "29457394852";
    parse_test "Select TEST 3: Parsing a regular number with spaces"
      (Select 123) "         123";
  ]

let parse_date_test =
  [
    parse_test "Parse date TEST 1: Parsing a regular date"
      (Date (Date.create_date "1/2"))
      "1/2";
    parse_test "Parse date TEST 2: Parsing a different date"
      (Date (Date.create_date "3/30"))
      "3/30";
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

let assertion_test (name : string) expected_exception input_command =
  name >:: fun _ ->
  assert_raises expected_exception (fun () ->
      Command.parse input_command)

let assertion_tests =
  [
    assertion_test
      "Assertion TEST 1: Assert Command raises Malformed for wrong verb"
      Malformed "finish my homework please";
    assertion_test
      "Assertion TEST 2: Assert Command raises Empty for an empty \
       command"
      Empty "";
    assertion_test
      "Assertion TEST 3: Assert Command raises Empty for command with \
       spaces"
      Empty "                     ";
    assertion_test
      "Assertion TEST 4: Assert quit raises Malformed for including \
       extra things"
      Malformed "quit hello yes";
    assertion_test
      "Assertion TEST 5: Assert add raises Empty for not including any \
       phrase"
      Empty "add";
    assertion_test
      "Assertion TEST 6: Assert add raises Empty for not including any \
       phrase with a period"
      Empty "add .";
    ( "Assertion TEST 7: Assert get phrase raises Invalid for using \
       complete"
    >:: fun _ ->
      assert_raises Invalid (fun () ->
          "complete 10" |> Command.parse |> Command.get_phrase) );
    ( "Assertion TEST 8: Assert get phrase raises Invalid for using quit"
    >:: fun _ ->
      assert_raises Invalid (fun () ->
          "quit" |> Command.parse |> Command.get_phrase) );
    ( "Assertion TEST 9: Assert get phrase raises Invalid for clear"
    >:: fun _ ->
      assert_raises Invalid (fun () ->
          "clear" |> Command.parse |> Command.get_phrase) );
    assertion_test
      "Assertion TEST 10: Assert raises Malformed for clear with extra \
       stuff"
      Malformed "clear stuff";
    assertion_test
      "Assertion TEST 11: Assert select raises Malformed for multiple \
       numbers"
      Malformed "1 2 3 4";
    assertion_test
      "Assertion TEST 12: Assert date raises invalid date for an \
       invalid date"
      (Date.InvalidDateFormat "4/40") "4/40";
    assertion_test
      "Assertion TEST 13: Assert select raises Malformed for different \
       dates"
      (Date.InvalidDateFormat "4/40/404/04") "4/40/404/04";
  ]

let suite =
  List.flatten
    [
      parse_add_tests;
      parse_complete_tests;
      parse_quit_test;
      get_phrase_tests;
      parse_settings_test;
      parse_date_test;
      assertion_tests;
    ]