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
include Bi_mappable_intf

module Extend0 (S : S0) :
  Extensions0
  with type t := S.t
   and type left := S.left
   and type right := S.right = struct
  let map_left c ~f = S.bi_map c ~left:f ~right:Fn.id

  let map_right c ~f = S.bi_map c ~left:Fn.id ~right:f
end

module Extend1_left (S : S1_left) :
  Extensions1_left with type 'l t := 'l S.t and type right := S.right =
struct
  let map_left c ~f = S.bi_map c ~left:f ~right:Fn.id

  let map_right c ~f = S.bi_map c ~left:Fn.id ~right:f
end

module Extend1_right (S : S1_right) :
  Extensions1_right with type 'r t := 'r S.t and type left := S.left =
struct
  let map_left c ~f = S.bi_map c ~left:f ~right:Fn.id

  let map_right c ~f = S.bi_map c ~left:Fn.id ~right:f
end

module Extend2 (S : S2) : Extensions2 with type ('l, 'r) t := ('l, 'r) S.t =
struct
  let map_left c ~f = S.bi_map c ~left:f ~right:Fn.id

  let map_right c ~f = S.bi_map c ~left:Fn.id ~right:f
end

module Fix2_left (S : S2) (Left : T) :
  S1_right with type 'r t = (Left.t, 'r) S.t and type left = Left.t = struct
  type 'r t = (Left.t, 'r) S.t

  type left = Left.t

  let bi_map = S.bi_map
end

module Fix2_right (S : S2) (Right : T) :
  S1_left with type 'l t = ('l, Right.t) S.t and type right = Right.t =
struct
  type 'l t = ('l, Right.t) S.t

  type right = Right.t

  let bi_map = S.bi_map
end

module Fix2_both (S : S2) (Left : T) (Right : T) :
  S0
  with type t = (Left.t, Right.t) S.t
   and type left = Left.t
   and type right = Right.t = struct
  type t = (Left.t, Right.t) S.t

  type left = Left.t

  type right = Right.t

  let bi_map = S.bi_map
end

module Fix1_left (S : S1_left) (Left : T) :
  S0
  with type t = Left.t S.t
   and type left = Left.t
   and type right = S.right = struct
  type t = Left.t S.t

  type left = Left.t

  type right = S.right

  let bi_map = S.bi_map
end

module Fix1_right (S : S1_right) (Right : T) :
  S0
  with type t = Right.t S.t
   and type left = S.left
   and type right = Right.t = struct
  type t = Right.t S.t

  type left = S.left

  type right = Right.t

  let bi_map = S.bi_map
end

module Map1_left (S : S1_left) : Mappable.S1 with type 'l t = 'l S.t =
struct
  type 'l t = 'l S.t

  module ES = Extend1_left (S)

  let map = ES.map_left
end

module Map1_right (S : S1_right) : Mappable.S1 with type 'r t = 'r S.t =
struct
  type 'r t = 'r S.t

  module ES = Extend1_right (S)

  let map = ES.map_right
end

module Map0_left (S : S0) :
  Mappable.S0 with type t = S.t and type elt = S.left = struct
  type t = S.t

  type elt = S.left

  module ES = Extend0 (S)

  let map = ES.map_left
end

module Map0_right (S : S0) :
  Mappable.S0 with type t = S.t and type elt = S.right = struct
  type t = S.t

  type elt = S.right

  module ES = Extend0 (S)

  let map = ES.map_right
end

module Chain_Bi2_Map1 (Bi : S2) (Map : Mappable.S1) :
  S2 with type ('l, 'r) t = ('l, 'r) Bi.t Map.t = struct
  type ('l, 'r) t = ('l, 'r) Bi.t Map.t

  let bi_map (x : ('l1, 'r1) t) ~(left : 'l1 -> 'l2) ~(right : 'r1 -> 'r2) :
      ('l2, 'r2) t =
    Map.map x ~f:(Bi.bi_map ~left ~right)
end

module Chain_Bi1_left_Map1 (Bi : S1_left) (Map : Mappable.S1) :
  S1_left with type 'l t = 'l Bi.t Map.t = struct
  type 'l t = 'l Bi.t Map.t

  type right = Bi.right

  let bi_map (x : 'l1 t) ~(left : 'l1 -> 'l2) ~(right : right -> right) :
      'l2 t =
    Map.map x ~f:(Bi.bi_map ~left ~right)
end

module Chain_Bi1_right_Map1 (Bi : S1_right) (Map : Mappable.S1) :
  S1_right with type 'r t = 'r Bi.t Map.t = struct
  type 'r t = 'r Bi.t Map.t

  type left = Bi.left

  let bi_map (x : 'r1 t) ~(left : left -> left) ~(right : 'r1 -> 'r2) :
      'r2 t =
    Map.map x ~f:(Bi.bi_map ~left ~right)
end

module Chain_Bi0_Map1 (Bi : S0) (Map : Mappable.S1) :
  S0
  with type t = Bi.t Map.t
   and type left = Bi.left
   and type right = Bi.right = struct
  type t = Bi.t Map.t

  type left = Bi.left

  type right = Bi.right

  let bi_map (x : t) ~(left : left -> left) ~(right : right -> right) : t =
    Map.map x ~f:(Bi.bi_map ~left ~right)
end
