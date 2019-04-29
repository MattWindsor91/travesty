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

include Base.Fn

module Extensions = struct
  let on (type a b c) (lift : a -> b) (x : a) (y : a) ~(f : b -> b -> c) : c
      =
    f (lift x) (lift y)

  let conj (type a) (f : a -> bool) (g : a -> bool) (x : a) : bool =
    f x && g x

  let ( &&& ) (type a) (f : a -> bool) (g : a -> bool) : a -> bool =
    conj f g

  let disj (type a) (f : a -> bool) (g : a -> bool) (x : a) : bool =
    f x || g x

  let ( ||| ) (type a) (f : a -> bool) (g : a -> bool) : a -> bool =
    disj f g
end

include Extensions

let%expect_test "on: equality" =
  let ints = on fst ~f:Base.Int.equal (42, "banana") (42, "apple") in
  let strs = on snd ~f:Base.String.equal (42, "banana") (42, "apple") in
  Stdio.printf "(%b, %b)\n" ints strs ;
  [%expect {| (true, false) |}]

let%expect_test "conj example" =
  Stdio.printf "%b\n" Base.Int.(conj is_non_negative is_non_positive 0) ;
  [%expect {| true |}]

let%expect_test "&&& example" =
  Stdio.printf "%b\n" Base.Int.((is_non_negative &&& is_non_positive) 6) ;
  [%expect {| false |}]

let%expect_test "conj short-circuits" =
  Stdio.printf "%b\n"
    (conj (fun () -> false) (fun () -> failwith "oops") ()) ;
  [%expect {| false |}]

let%expect_test "&&& short-circuits" =
  Stdio.printf "%b\n" (((fun () -> false) &&& fun () -> failwith "oops") ()) ;
  [%expect {| false |}]

let%expect_test "disj example" =
  Stdio.printf "%b\n" Base.Int.(disj is_negative is_positive 0) ;
  [%expect {| false |}]

let%expect_test "||| example" =
  Stdio.printf "%b\n" Base.Int.((is_non_negative ||| is_non_positive) 6) ;
  [%expect {| true |}]

let%expect_test "disj short-circuits" =
  Stdio.printf "%b\n" (disj (fun () -> true) (fun () -> failwith "oops") ()) ;
  [%expect {| true |}]

let%expect_test "||| short-circuits" =
  Stdio.printf "%b\n" (((fun () -> true) ||| fun () -> failwith "oops") ()) ;
  [%expect {| true |}]
