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

let settings_test =
  [
    settings_test "sample settings test" sample_settings
      [ "display_completed"; "due_before" ];
    setting_test "get 1st setting name from sample settings"
      sample_settings 0 "display_completed";
  ]

let toggle_display_completed_test = []
let suite = List.flatten []