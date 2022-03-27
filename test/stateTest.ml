open OUnit2
open TodoList

(** [cmp_set_like_lists lst1 lst2] compares two lists to see whether
    they are equivalent set-like lists. That means checking two things.
    First, they must both be {i set-like}, meaning that they do not
    contain any duplicates. Second, they must contain the same elements,
    though not necessarily in the same order. *)
let cmp_set_like_lists lst1 lst2 =
  let uniq1 = List.sort_uniq compare lst1 in
  let uniq2 = List.sort_uniq compare lst2 in
  List.length lst1 = List.length uniq1
  && List.length lst2 = List.length uniq2
  && uniq1 = uniq2

(** [pp_string s] pretty-prints string [s]. *)
let pp_string s = "\"" ^ s ^ "\""

(** [pp_list pp_elt lst] pretty-prints list [lst], using [pp_elt] to
    pretty-print each element of [lst]. *)
let pp_list pp_elt lst =
  let pp_elts lst =
    let rec loop n acc = function
      | [] -> acc
      | [ h ] -> acc ^ pp_elt h
      | h1 :: (h2 :: t as t') ->
          if n = 100 then acc ^ "..." (* stop printing long list *)
          else loop (n + 1) (acc ^ pp_elt h1 ^ "; ") t'
    in
    loop 0 "" lst
  in
  "[" ^ pp_elts lst ^ "]"

let state_test_tasks
    (name : string)
    (expected_output : string list)
    (input_state : State.t) =
  name >:: fun _ ->
  assert_equal expected_output
    (State.get_task_names input_state)
    ~cmp:cmp_set_like_lists ~printer:(pp_list pp_string)

let state_test_dates
    (name : string)
    (expected_output : string list)
    (input_state : State.t) =
  name >:: fun _ ->
  assert_equal expected_output (State.get_dates input_state)

(* initializing an empty state *)
let empty_state = State.clear_state ()

let adding_one_item =
  State.update_state empty_state
    ("add Finish my homework. 1/1" |> Command.parse)

let adding_two_item =
  State.update_state adding_one_item
    ("add Complete my hw. 1/2" |> Command.parse)

let clearing_state = State.clear_state ()

let state_add_tasks_tests =
  [
    state_test_tasks "State Tasks TEST 1: Empty state" [] empty_state;
    state_test_tasks "State Tasks TEST 2: Adding one item"
      [ "Finish my homework" ]
      adding_one_item;
    state_test_tasks "State Tasks TEST 3: Adding two items"
      [ "Finish my homework"; "Complete my hw" ]
      adding_two_item;
    state_test_tasks
      "State Tasks TEST 4: Clearing after adding two items" []
      clearing_state;
  ]

let state_add_dates_tests =
  [
    state_test_dates "State Dates TEST 1: Empty state" [] empty_state;
    state_test_dates "State Dates TEST 2: Adding one item" [ "1/1" ]
      adding_one_item;
    state_test_dates "State Dates TEST 3: Adding two\n       items"
      [ "1/1"; "1/2" ] adding_two_item;
    state_test_dates
      "State\n       Dates TEST 4: Clearing after adding two items" []
      clearing_state;
  ]

let suite =
  List.flatten [ state_add_tasks_tests; state_add_dates_tests ]
