(* This file is part of 'travesty'.

   Copyright (c) 2018, 2019 by Matt Windsor

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
open Stdio
open Travesty_base_exts.Alist

let print_str_int : (string, int) t -> unit =
  List.iter ~f:(fun (k, v) -> printf "%s -> %d\n" k v)

let%expect_test "bi_map example" =
  let sample = [("foo", 27); ("bar", 53); ("baz", 99)] in
  let sample' = bi_map sample ~left:String.capitalize ~right:Int.neg in
  print_str_int sample' ;
  [%expect {|
    Foo -> -27
    Bar -> -53
    Baz -> -99 |}]

let%expect_test "compose example" =
  let ab =
    [("foo", "FOO"); ("bar", "FOO"); ("baz", "BAR"); ("baz", "BAZ")]
  in
  let bc = [("FOO", 1); ("FOO", 2); ("BAZ", 3)] in
  let ac = compose ab bc ~equal:String.equal in
  print_str_int ac ;
  [%expect
    {|
    foo -> 1
    foo -> 2
    bar -> 1
    bar -> 2
    baz -> 3 |}]
