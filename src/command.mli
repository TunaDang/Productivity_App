open Date
(** Module to parse the player's commands*)

type phrase = string list
(** The type [phrase] represents the information that the user wants to
    store as a to do list item. Each element of the list represents a
    word of the phrase, and a word is defined as a consecutive sequence
    of non-space characters.

    For example:

    - If the user command is ["add Finish the cs homework 1/20"], then
      the phrase is [\["Finish"; "the" ; "cs"; "homework" \]] .

    - If the user command is
      ["edit    Finish the       cs   homework 1/21"], then the object
      phrase is [\["Finish"; "the" ; "cs"; "homework" \]].

    For Add and Edit commands, the phrase cannot be empty. *)

(** Type [command] represents the user's commands. Add and edit requires
    the user to include a phrase and date. Phrase is the description of
    a task, which can be whatever the user inputs. The date represents
    the deadline of the task, which is optional. *)
type t =
  | Add of phrase * Date.t
  | Complete of phrase * Date.t
  | Edit of phrase * Date.t
  | Quit

exception Malformed
(** Raised when the command does not include the necessary components.
    This is when you don't include phrase for Add, Complete *)

exception Empty
(** Raised when an empty command is inputed.*)

val parse : string -> t
(** [parse str] parses the user's input into a [command]. The first word
    of the command is the verb, and the last word represents the date,
    which is separated by a "/".

    Requires: [str] contains only alphanumeric (A-Z, a-z, 0-9) and space
    characters and /, (only ASCII character code 32; not tabs or
    newlines, etc.).

    Raises: [Empty] if [str] contains only spaces or is the empty
    string.

    Raises; [Malformed] if the verb is not one of Add, Edit, Complete,
    Save, or Quit. *)
