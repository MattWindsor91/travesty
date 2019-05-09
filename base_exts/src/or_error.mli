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

(** Or-error monad extensions.

    This module contains various extensions for [Base]'s [Or_error] monad,
    including monadic traversal over successful values and
    {{!Monad_exts} monad extensions}. *)

(** Defined to let this module be used directly in chaining operations etc. *)
type 'a t = 'a Base.Or_error.t

(** {2 Travesty signatures} *)

(** [On_ok] treats an [Or_error] value as a traversable container,
    containing one value when it is [Ok] and none otherwise. *)
module On_ok : Travesty.Traversable.S1 with type 'a t = 'a t

(** Monad extensions for [Or_error]. *)
include Travesty.Monad_exts.S with type 'a t := 'a t

(** {2 Shortcuts for combining errors}

    These functions are just shorthand for mapping over a list, then using
    the various [combine_errors] functions in Base.

    Prefer using these, where possible, over the analogous functions in
    {{!T_list.With_errors} T_list.With_errors}; these ones correctly merge
    errors. *)

val combine_map : 'a list -> f:('a -> 'b t) -> 'b list t
(** [combine_map xs ~f] is short for [map xs ~f] followed by
    [combine_errors]. *)

val combine_map_unit : 'a list -> f:('a -> unit t) -> unit t
(** [combine_map_unit xs ~f] is short for [map xs ~f] followed by
    [combine_errors_unit]. *)
