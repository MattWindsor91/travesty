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
open Travesty

module BT : Bi_traversable_types.S1_left with type 'l t = 'l Or_error.t and type right = Error.t
  = Bi_traversable.Make1_left (struct
  type 'l t = 'l Or_error.t

  type right = Error.t

  module On_monad (M : Monad.S) = struct
    let bi_map_m (e : 'l1 Or_error.t) ~(left : 'l1 -> 'l2 M.t)
        ~(right : Error.t -> Error.t M.t) : 'l2 Or_error.t M.t =
      match e with
      | Ok x -> M.(left x >>| Result.return)
      | Error y -> M.(right y >>| Result.fail)
  end
end)
include BT

module On_ok : Traversable_types.S1 with type 'a t = 'a Or_error.t = Bi_traversable.Traverse1_left (BT)

include Monad_exts.Extend (Base.Or_error)

let combine_map (xs : 'a list) ~(f : 'a -> 'b t) : 'b list t =
  xs |> Base.List.map ~f |> Base.Or_error.combine_errors

let combine_map_unit (xs : 'a list) ~(f : 'a -> unit t) : unit t =
  xs |> Base.List.map ~f |> Base.Or_error.combine_errors_unit
