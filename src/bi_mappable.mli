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

(** Mapping for containers with two element types.

    [Bi_mappable] implements the Haskell notion of a bifunctor: a container
    that contains two distinct element types, both of which can be
    non-monadically, covariantly mapped over.

    Common examples include:

    - associative lists, where the two types are keys and values;
    - result types, where the two types are success and failure. *)

(** {2 Signatures} *)

(** {{!Bi_mappable_intf} Bi_mappable_intf} contains the signatures for
    [Bi_mappable]. *)
include module type of Bi_mappable_intf

(** {2 Extending bi-mappable containers}

    We define several derived functions for bi-mappable containers in
    {{!Bi_mappable_intf} Bi_mappable_intf}---here, we define functors to
    generate them. *)

(** [Extend2] implements [Extensions2] for an arity-2 bi-mappable container. *)
module Extend2 (S : S2) : Extensions2 with type ('l, 'r) t := ('l, 'r) S.t

(** [Extend1_left] implements [Extensions1_left] for an arity-1 bi-mappable
    container with floating left type. *)
module Extend1_left (S : S1_left) :
  Extensions1_left with type 'l t := 'l S.t and type right := S.right

(** [Extend1_right] implements [Extensions1_right] for an arity-1
    bi-mappable container with floating right type. *)
module Extend1_right (S : S1_right) :
  Extensions1_right with type 'r t := 'r S.t and type left := S.left

(** [Extend0] implements [Extensions0] for an arity-0 bi-mappable container. *)
module Extend0 (S : S0) :
  Extensions0
  with type t := S.t
   and type left := S.left
   and type right := S.right

(** {2 Chaining containers} *)

(** [Chain_Bi2_Map1 (Bi) (Map)] composes a bi-map [Bi] on an inner arity-2
    container with an ordinary map [Map] on an outer arity-1 container,
    producing an arity-2 bi-map across the whole container. For example, we
    can make {{!T_alist} associative lists} bi-mappable by composing a
    bi-map over {{!T_tuple2} pairs} [(a * b)] with ordinary
    {{!T_list} list}, creating a bi-map over associative lists
    [(a, b) List.Assoc.t]. *)
module Chain_Bi2_Map1 (Bi : S2) (Map : Mappable.S1) :
  S2 with type ('l, 'r) t = ('l, 'r) Bi.t Map.t
