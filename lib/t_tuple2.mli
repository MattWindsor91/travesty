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

(** An expanded version of Core's pair (2-tuple) module.

    This expanded overlay contains a {{!Bi_mappable} bi-mappable}
    implementation for pairs. *)

include module type of Core_kernel.Tuple2

(** Pairs are trivially bi-mappable; the left type is [fst], and the right
    type is [snd]. For example:

    {[
      bi_map ("foo", 27) ~left:String.capitalize ~right:Int.neg
      (* returns: ("Foo", -27) *)
    ]} *)
include Bi_mappable.S2_with_extensions with type ('l, 'r) t := ('l, 'r) t
