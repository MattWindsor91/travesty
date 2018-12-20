(* This file is part of 'travesty'.

   Copyright (c) 2018 by Matt Windsor

   Permission is hereby granted, free of charge, to any person
   obtaining a copy of this software and associated documentation
   files (the "Software"), to deal in the Software without
   restriction, including without limitation the rights to use, copy,
   modify, merge, publish, distribute, sublicense, and/or sell copies
   of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be
   included in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
   BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
   ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
   CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE. *)

(** Extensions for containers. *)

open Core_kernel

(** {2:a1 Arity-1 container extensions}

    These extensions target arity-1 containers (implementations of
    [Container.S1]).
*)

(** [Extensions1] contains extensions for a [Container.S1]. *)
module type Extensions1 = sig
  type 'a t
  (** The type of the container to extend. *)

  val max_measure : measure:('a -> int) -> ?default:int -> 'a t -> int
  (** [max_measure ~measure ~default xs] measures each item in [xs]
      according to [measure], and returns the highest measure reported.
      If [xs] is empty, return [default] if given, and [0]
      otherwise. *)

  val any : predicates:('a -> bool) t -> 'a -> bool
  (** [any ~predicates x] tests [x] against [predicates] until one
      returns [true], or all return [false]. *)

  val at_most_one : 'a t -> 'a option Or_error.t
  (** [at_most_one xs] returns [Ok None] if [xs] is empty;
      [Ok Some(x)] if it contains only [x];
      and an error otherwise.

      Examples:

      {[
        T_list.at_most_one []     (* ok None *)
               at_most_one [1]    (* ok (Some 1) *)
               at_most_one [1; 2] (* error -- too many *)
      ]}
  *)

  val one : 'a t -> 'a Or_error.t
  (** [one xs] returns [Ok x] if [xs] contains only [x],
      and an error otherwise.

      Examples:

      {[
        T_list.one []     (* error -- not enough *)
               one [1]    (* ok 1 *)
               one [1; 2] (* error -- too many *)
      ]}
  *)

  val two : 'a t -> ('a * 'a) Or_error.t
  (** [two xs] returns [Ok (x, y)] if [xs] is a list containing only [x]
      and [y] in that order, and an error otherwise.

      Examples:

      {[
        T_list.two []        (* error -- not enough *)
               two [1]       (* error -- not enough *)
               two [1; 2]    (* ok (1, 2) *)
               two [1; 2; 3] (* error -- too many *)
      ]}
  *)
end

module Extend1 (C : Container.S1) : Extensions1 with type 'a t := 'a C.t
(** [Extend1] creates {{!Extensions}Extensions} for a [Container.S1]. *)
