open OUnit2

(* Every module (Command, Date, Settings, State, Tasks. Output has to be
   tested functionally) has a complementary test file which tests most,
   if not every, function that is possible using OUnit, using both their
   respective mli files for glass box testing. For the especially
   complicated functions with multiple paths, we tried our best to cover
   them using black box testing with multiple test cases. For the parts
   that would be difficult/cannot be tested using OUnit (functionalities
   that requires collaboration of multiple modules such as adding a to
   do item first requires parsing from Command which passes off to State
   and Date before finally handled and stored by Task) we test run the
   application by trying and entering hundreds of combinations of to dos
   with and without due date, in different chronological orders. Another
   good example of the functional testing we carried out is for the
   current time which cannot be accomplished with unit testing. In
   addition to code inspection, pair programming, debugging, hundreds of
   test cases and good documentation, we believe our program has been
   thoroughly validated. *)
let suite =
  "test suite for everything"
  >::: List.flatten
         [
           DateTest.suite;
           TasksTest.suite;
           CommandTest.suite;
           StateTest.suite;
           SettingsTest.suite;
         ]

let _ = run_test_tt_main suite