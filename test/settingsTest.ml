open OUnit2
open TodoList

let sample_settings =
  Settings.from_file "test/data/sample_settings.json"

let settings_test
    (name : string)
    (input_t : Settings.t)
    (expected : string list) : test =
  name >:: fun _ ->
  assert_equal expected
    (Settings.settings input_t)
    ~printer:(String.concat " ")

let setting_test
    (name : string)
    (input_t : Settings.t)
    (input_int : int)
    (expected : string) : test =
  name >:: fun _ ->
  assert_equal expected
    (Settings.setting input_t input_int)
    ~printer:String.escaped

let get_display_completed_test
    (name : string)
    (input_t : Settings.t)
    (expected : bool) : test =
  name >:: fun _ ->
  assert_equal expected (Settings.get_display_completed input_t)

let get_printer_test
    (name : string)
    (input_t : Settings.t)
    (expected : Settings.printer) : test =
  name >:: fun _ -> assert_equal expected (Settings.get_printer input_t)

let get_due_before_test
    (name : string)
    (input_t : Settings.t)
    (expected : Date.t option) : test =
  name >:: fun _ ->
  assert_equal expected (Settings.get_due_before input_t)

let set_display_test
    (name : string)
    (input_t : Settings.t)
    (display : bool)
    (expected : bool) : test =
  name >:: fun _ ->
  assert_equal expected
    (Settings.get_display_completed
       (Settings.set_display_completed input_t display))

let set_printer_test
    (name : string)
    (input_t : Settings.t)
    (printer : Settings.printer)
    (expected : Settings.printer) : test =
  name >:: fun _ ->
  assert_equal expected
    (Settings.get_printer (Settings.set_printer input_t printer))

let set_due_before_test
    (name : string)
    (input_t : Settings.t)
    (date : Date.t option)
    (expected : Date.t option) : test =
  name >:: fun _ ->
  assert_equal expected
    (Settings.get_due_before (Settings.set_due_before input_t date))

let toggle_test
    (name : string)
    (input_t : Settings.t)
    (input_int : int)
    (expected : bool) : test =
  name >:: fun _ ->
  assert_equal expected (Settings.toggle input_t input_int)

let is_view_test
    (name : string)
    (input_t : Settings.t)
    (input_int : int)
    (expected : bool) : test =
  name >:: fun _ ->
  assert_equal expected (Settings.is_view input_t input_int)

let settings_tests =
  [
    settings_test "sample settings test" sample_settings
      [ "display_completed"; "printer"; "due_before" ];
  ]

let setting_tests =
  [
    setting_test "1st setting name from sample settings" sample_settings
      0 "display_completed";
    setting_test "2nd setting name from sample settings" sample_settings
      1 "printer";
    setting_test "3rd setting name from sample settings" sample_settings
      2 "due_before";
  ]

let get_tests =
  [
    get_display_completed_test
      "Get the current state of display_completed" sample_settings true;
    get_printer_test "Get the current state of printer" sample_settings
      Tasks;
    get_due_before_test "Get the current state of printer"
      sample_settings
      (Date.create_date "3/27");
  ]

let set_display_tests =
  [
    set_display_test "Set display_completed setting to false"
      sample_settings false false;
    set_display_test "Set display_completed setting back to true"
      sample_settings true true;
  ]

let set_printer_tests =
  [
    set_printer_test "Set printer setting to Week" sample_settings Week
      Week;
    set_printer_test "Set printer setting back to Tasks" sample_settings
      Tasks Tasks;
  ]

let set_due_before_tests =
  [
    set_due_before_test "Set due_before setting to 6/21" sample_settings
      (Date.create_date "6/21")
      (Date.create_date "6/21");
    set_due_before_test "Set due_before setting to None" sample_settings
      None None;
    set_due_before_test "Set display_completed setting back to 3/37"
      sample_settings
      (Date.create_date "3/27")
      (Date.create_date "3/27");
  ]

let toggle_test =
  [
    toggle_test "Check if the first setting is a toggle" sample_settings
      0 true;
    toggle_test "Check if the first setting is a toggle" sample_settings
      1 false;
    toggle_test "Check if the first setting is a toggle" sample_settings
      2 false;
  ]

let is_view_test =
  [
    is_view_test "Check if the first setting is a toggle"
      sample_settings 0 false;
    is_view_test "Check if the first setting is a toggle"
      sample_settings 1 true;
    is_view_test "Check if the first setting is a toggle"
      sample_settings 2 false;
  ]

let suite =
  List.flatten
    [
      settings_tests;
      setting_tests;
      get_tests;
      toggle_test;
      set_display_tests;
      set_printer_tests;
      set_due_before_tests;
    ]
