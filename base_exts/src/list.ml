(* This file is part of 'travesty'.

   Copyright (c) 2018 by Matt Windsor

   Permission is hereby granted, free of charge, to any person obtaining a
   copy of this software and associated documentation files (the
   "Software"), to deal in the Software without restriction, including
   without limitation the rights to use, copy, modify, merge, publish,
   distribute, sublicense, and/or sell copies of the Software, and to permit
   persons to whom the Software is furnished to do so, subject to the
   following conditions:

   The above copyright notice and this permission notice shall be included
   in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
   NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
   DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
   OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
   USE OR OTHER DEALINGS IN THE SOFTWARE. *)

open Base
open Travesty
include List

module Extensions = struct
  include Traversable.Extend_container1 (struct
    include List

    module On_monad (M : Monad.S) = struct
      let map_m xs ~f =
        let open M.Let_syntax in
        let%map xs_final =
          List.fold_left xs ~init:(return []) ~f:(fun state x ->
              let%bind xs' = state in
              let%map x' = f x in
              x' :: xs' )
        in
        List.rev xs_final
    end
  end)

  include Filter_mappable.Make1 (struct
    type 'a t = 'a list

    let filter_map = List.filter_map
  end)

  let prefixes xs = List.mapi ~f:(fun i _ -> List.take xs (i + 1)) xs
end

include Extensions

let%expect_test "generated list map behaves properly" =
  Stdio.print_s [%sexp (map ~f:(fun x -> x * x) [1; 3; 5; 7] : int list)] ;
  [%expect {| (1 9 25 49) |}]

let%expect_test "generated list count behaves properly" =
  Stdio.print_s
    [%sexp (count ~f:Int.is_positive [-7; -5; -3; -1; 1; 3; 5; 7] : int)] ;
  [%expect {| 4 |}]

let%expect_test "mapi_m: returning identity on list/option" =
  let module M = On_monad (Option) in
  Stdio.print_s
    [%sexp
      ( M.mapi_m ~f:(Fn.const Option.some) ["a"; "b"; "c"; "d"; "e"]
        : string list option )] ;
  [%expect {| ((a b c d e)) |}]

let%expect_test "mapi_m: counting upwards on list/option" =
  let module M = On_monad (Option) in
  Stdio.print_s
    [%sexp
      (M.mapi_m ~f:(Fn.const Option.some) [3; 7; 2; 4; 42] : int list option)] ;
  [%expect {| ((3 7 2 4 42)) |}]

let%expect_test "max_measure on empty list" =
  Stdio.print_s [%sexp (max_measure ~default:1066 ~measure:Fn.id [] : int)] ;
  [%expect {| 1066 |}]

let%expect_test "exclude -ve numbers" =
  let excluded = exclude ~f:Int.is_negative [1; -1; 2; 10; -49; 0; 64] in
  Stdio.print_s [%sexp (excluded : int list)] ;
  [%expect {| (1 2 10 0 64) |}]

let%expect_test "right_pad empty list" =
  Stdio.print_s [%sexp (right_pad ~padding:2 [] : int list list)] ;
  [%expect {| () |}]

let%expect_test "right_pad example list" =
  Stdio.print_s
    [%sexp
      ( right_pad ~padding:6
          [ [0; 8; 0; 0]
          ; [9; 9; 9]
          ; [8; 8; 1; 9; 9]
          ; [9; 1; 1; 9]
          ; [7; 2; 5]
          ; [3] ]
        : int list list )] ;
  [%expect
    {|
                ((0 8 0 0 6) (9 9 9 6 6) (8 8 1 9 9) (9 1 1 9 6) (7 2 5 6 6) (3 6 6 6 6)) |}]

let%expect_test "map_m: list" =
  let module M = On_monad (List) in
  Stdio.print_s
    [%sexp
      ( List.bind ~f:(M.map_m ~f:(fun k -> [k; 0])) [[1; 2; 3]]
        : int list list )] ;
  [%expect
    {|
              ((1 2 3) (1 2 0) (1 0 3) (1 0 0) (0 2 3) (0 2 0) (0 0 3) (0 0 0)) |}]

let%expect_test "prefixes: empty list" =
  Stdio.print_s [%sexp (prefixes [] : int list list)] ;
  [%expect {| () |}]

let%expect_test "prefixes: sample list" =
  Stdio.print_s [%sexp (prefixes [1; 2; 3] : int list list)] ;
  [%expect {|
              ((1) (1 2) (1 2 3)) |}]

let%expect_test "any: short-circuit on true" =
  Stdio.print_s
    [%sexp
      (any ~predicates:[Int.is_positive; (fun _ -> assert false)] 10 : bool)] ;
  [%expect {| true |}]

let%expect_test "any: positive result" =
  Stdio.print_s
    [%sexp (any ~predicates:[Int.is_positive; Int.is_negative] 10 : bool)] ;
  [%expect {| true |}]

let%expect_test "any: negative result" =
  Stdio.print_s
    [%sexp (any ~predicates:[Int.is_positive; Int.is_negative] 0 : bool)] ;
  [%expect {| false |}]

let%expect_test "all: short-circuit on false" =
  Stdio.print_s
    [%sexp
      (all ~predicates:[Int.is_negative; (fun _ -> assert false)] 10 : bool)] ;
  [%expect {| false |}]

let%expect_test "all: positive result" =
  Stdio.print_s
    [%sexp
      (all ~predicates:[Int.is_positive; Int.is_non_negative] 10 : bool)] ;
  [%expect {| true |}]

let%expect_test "all: negative result" =
  Stdio.print_s
    [%sexp (all ~predicates:[Int.is_positive; Int.is_negative] 10 : bool)] ;
  [%expect {| false |}]

let%expect_test "none: short-circuit on true" =
  Stdio.print_s
    [%sexp
      (none ~predicates:[Int.is_positive; (fun _ -> assert false)] 10 : bool)] ;
  [%expect {| false |}]

let%expect_test "none: positive result" =
  Stdio.print_s
    [%sexp (none ~predicates:[Int.is_positive; Int.is_negative] 0 : bool)] ;
  [%expect {| true |}]

let%expect_test "none: negative result" =
  Stdio.print_s
    [%sexp (none ~predicates:[Int.is_positive; Int.is_negative] 10 : bool)] ;
  [%expect {| false |}]

let%expect_test "at_most_one: zero elements" =
  Stdio.print_s [%sexp (at_most_one [] : int option Or_error.t)] ;
  [%expect {| (Ok ()) |}]

let%expect_test "at_most_one: one element" =
  Stdio.print_s [%sexp (at_most_one [42] : int option Or_error.t)] ;
  [%expect {| (Ok (42)) |}]

let%expect_test "at_most_one: two elements" =
  Stdio.print_s [%sexp (one [27; 53] : int Or_error.t)] ;
  [%expect {| (Error "Expected one element; got too many") |}]

let%expect_test "one: zero elements" =
  Stdio.print_s [%sexp (one [] : int Or_error.t)] ;
  [%expect {| (Error "Expected one element; got none") |}]

let%expect_test "one: one element" =
  Stdio.print_s [%sexp (one [42] : int Or_error.t)] ;
  [%expect {| (Ok 42) |}]

let%expect_test "one: two elements" =
  Stdio.print_s [%sexp (one [27; 53] : int Or_error.t)] ;
  [%expect {| (Error "Expected one element; got too many") |}]

let%expect_test "one: one element" =
  Stdio.print_s [%sexp (two [42] : (int * int) Or_error.t)] ;
  [%expect {| (Error "Expected one element; got none") |}]

let%expect_test "one: two elements" =
  Stdio.print_s [%sexp (two [27; 53] : (int * int) Or_error.t)] ;
  [%expect {| (Ok (27 53)) |}]

let%expect_test "one: three elements" =
  Stdio.print_s
    [%sexp (two ["veni"; "vidi"; "vici"] : (string * string) Or_error.t)] ;
  [%expect {| (Error "Expected one element; got too many") |}]

let%expect_test "chained list/list traversal example" =
  let module C =
    Traversable.Chain0 (struct
        type t = int list list

        include With_elt (struct
          type t = int list [@@deriving eq]
        end)
      end)
      (With_elt (struct
        type t = int [@@deriving eq]
      end))
  in
  let result =
    C.to_list
      [ [0; 1; 1; 8]
      ; [9; 9; 9]
      ; [8; 8; 1; 9; 9]
      ; [9; 1; 1]
      ; [9]
      ; [7; 2; 5]
      ; [3] ]
  in
  Stdio.print_s [%sexp (result : int list)] ;
  [%expect {| (0 1 1 8 9 9 9 8 8 1 9 9 9 1 1 9 7 2 5 3) |}]