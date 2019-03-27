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

(** Signatures for monadic traversal. *)

open Base

(** {2:generic The generic signature}

    As with {{!Mappable}Mappable}, we define the signature of
    traversable structures in an arity-generic way, then specialise
    it for arity-0 and arity-1 types.
*)

(** [Generic] describes monadic traversal on either an arity-0 or
   arity-1 type.

    - For arity-0 types, use {{!S0}S0}: ['a t] becomes [t], and
      ['a elt] becomes [elt];
    - For arity-1 types, use {{!S1}S1}: ['a t] becomes ['a t],
      and ['a elt] becomes ['a].
*)
module type Generic = sig
  (** [Generic] refers to the container type as ['a t], and the element type
      as ['a elt]; substitute [t]/[elt] (arity-0) or ['a t]/['a] (arity-1)
      accordingly below. *)
  include Types_intf.Generic

  (** [M] is the monad over which we're fold-mapping. *)
  module M : Monad.S

  val map_m : 'a t -> f:('a elt -> 'b elt M.t) -> 'b t M.t
  (** [map_m c ~f] maps [f] over every [t] in [c], threading through
      monadic state.

      Example:

      {[
        (* T_list adds monadic traversals to a list;
           With_errors (in S1_container) implements them on the On_error
           monad. *)

        let f x =
          Or_error.(if 0 < x then error_string "negative!" else ok x)
        in
        T_list.With_errors.map_m integers ~f
      ]}
*)
end

(** {2:sigs Basic signatures} *)

(** [S0] is the signature of a monadic traversal over arity-0
   types. *)
module type S0 = sig
  include Types_intf.S0

  include Generic with type 'a t := t and type 'a elt := elt
end

(** [S1] is the signature of a monadic traversal over arity-1
   types. *)
module type S1 = sig
  (** The type of the container to map over. *)
  type 'a t

  (** [S1]s can traverse: when the container type is ['a t],
      the element type is ['a]. *)
  include Generic with type 'a t := 'a t and type 'a elt := 'a
end

(** {2:build Building containers from traversable types}

    Any traversable type can be turned into a Core container, using the monadic
    fold to implement all container functionality.  The unified signature of a
    Core container with monadic traversals is {{!S0_container}S0_container}
    (arity 0) or {{!S1_container}S1_container} (arity 1).

    To satisfy these signatures for new types, implement {{!Basic0}Basic0} or
    {{!Basic1}Basic1}, and use the corresponding [Make] functor in
    {{!Traversable}Traversable}.

    For types that are _already_ Core containers, or types where custom
    implementation of the Core signature are desired, implement
    {{!Basic_container0}Basic_container0} or
    {{!Basic_container1}Basic_container1}, and use the [Extend] functors. *)

(** {3 Input signatures} *)

(** [Basic0] is the minimal signature that traversable containers of
   arity 0 must implement to be extensible into
   {{!S0_container}S0_container}. *)
module type Basic0 = sig
  (** The container type. *)
  type t

  (** [Elt] contains the element type, which must have equality. *)
  module Elt : Equal.S

  (** [On_monad] implements monadic traversal for a given monad [M]. *)
  module On_monad (M : Monad.S) :
    S0 with type t := t and type elt := Elt.t and module M := M
end

(** [Basic_container0] combines {{!Basic0}Basic0} and the Core container
   signature, and is used for extending existing containers into
   {{!S0_container}S0_container}s. *)
module type Basic_container0 = sig
  include Basic0

  include Container.S0 with type t := t and type elt := Elt.t
end

(** [Basic1] is the minimal signature that traversable containers of arity 1
    must implement to be extensible into. *)
module type Basic1 = sig
  (** The container type. *)
  type 'a t

  (** [On_monad] implements monadic traversal for a given monad. *)
  module On_monad (M : Monad.S) : S1 with type 'a t := 'a t and module M := M
end

(** [Basic_container1] combines {{!Basic1}Basic1} and the Core container
   signature, and is used for extending existing containers into
   {{!S1_container}S1_container}s. *)
module type Basic_container1 = sig
  include Basic1

  include Container.S1 with type 'a t := 'a t
end

(** {3 Helper signatures} *)

(** [Generic_on_monad] extends [Generic] to contain various derived
   operators; we use it to derive the signatures of the various
   [On_monad] modules. *)
module type Generic_on_monad = sig
  include Generic

  val fold_map_m :
       'a t
    -> f:('acc -> 'a elt -> ('acc * 'b elt) M.t)
    -> init:'acc
    -> ('acc * 'b t) M.t
  (** [fold_map_m c ~f ~init] folds [f] monadically over every [t] in
     [c], threading through an accumulator with initial value
     [init]. *)

  val fold_m : 'a t -> init:'acc -> f:('acc -> 'a elt -> 'acc M.t) -> 'acc M.t
  (** [fold_m x ~init ~f] folds the monadic computation [f] over [x],
      starting with initial value [init], and returning the final
      value inside the monadic effect. *)

  val iter_m : 'a t -> f:('a elt -> unit M.t) -> unit M.t
  (** [iter_m x ~f] iterates the monadic computation [f] over [x],
      returning the final monadic effect. *)

  val mapi_m : f:(int -> 'a elt -> 'b elt M.t) -> 'a t -> 'b t M.t
  (** [mapi_m ~f x] behaves as [mapM], but also supplies [f] with the
      index of the element.  This index should match the actual
      position of the element in the container [x]. *)
end

(** [On_monad1] extends [Generic_on_monad] with functionality that
    only works on arity-1 containers. *)
module type On_monad1 = sig
  type 'a t

  include Generic_on_monad with type 'a t := 'a t and type 'a elt := 'a

  val sequence_m : 'a M.t t -> 'a t M.t
  (** [sequence_m x] lifts a container of monads [x] to a monad
      containing a container, by sequencing the monadic effects from
      left to right. *)
end

(** [Generic_container] is a generic interface for traversable
   containers, used to build [Container0] (arity-0) and [Container1]
   (arity-1). *)
module type Generic_container = sig
  include Types_intf.Generic

  (** [On_monad] implements monadic traversal operators for
      a given monad [M]. *)
  module On_monad (M : Monad.S) :
    Generic_on_monad
    with type 'a t := 'a t
     and type 'a elt := 'a elt
     and module M := M

  (** We can do generic container operations. *)
  include Container.Generic with type 'a t := 'a t and type 'a elt := 'a elt

  (** We can do non-monadic mapping operations. *)
  include Mappable.Generic with type 'a t := 'a t and type 'a elt := 'a elt

  val fold_map :
    'a t -> f:('acc -> 'a elt -> 'acc * 'b elt) -> init:'acc -> 'acc * 'b t
  (** [fold_map c ~f ~init] folds [f] over every [t] in [c], threading
     through an accumulator with initial value [init]. *)

  val mapi : f:(int -> 'a elt -> 'b elt) -> 'a t -> 'b t
  (** [mapi ~f t] maps [f] across [t], passing in an increasing
      position counter. *)

  (** [With_errors] specialises [On_monad] to the error monad. *)
  module With_errors :
    Generic_on_monad
    with type 'a t := 'a t
     and type 'a elt := 'a elt
     and module M := Or_error
end

(** {3 Signatures for traversable containers} *)

(** [S0_container] is a generic interface for arity-0 traversable
    containers. *)
module type S0_container = sig
  (** Elements must have equality.  While this is an extra
      restriction on top of the Core equivalent, it is required
      by {{!Traversable.Make_container0}Make_container0}, and helps
      us define chaining operations. *)
  module Elt : Equal.S

  (** We export [Elt.t] as [elt] for compatibility with Core-style
      containers. *)
  include Types_intf.S0 with type elt = Elt.t

  include Generic_container with type 'a t := t and type 'a elt := Elt.t

  include Mappable.S0_container with type t := t and type elt := Elt.t
end

(** [S1_container] is a generic interface for arity-1 traversable
    containers.  It also includes the extensions from {{!Mappable}Mappable}. *)
module type S1_container = sig
  (** ['a t] is the type of the container, parametrised over the
      element type ['a]. *)
  type 'a t

  (** [On_monad] implements monadic folding and mapping operators for
      a given monad [M], including arity-1 specific operators. *)
  module On_monad (M : Monad.S) :
    On_monad1 with type 'a t := 'a t and module M := M

  (** [With_errors] is shorthand for [On_monad (Or_error)]. *)
  module With_errors :
    On_monad1 with type 'a t := 'a t and module M := Or_error

  include
    Generic_container
    with type 'a t := 'a t
     and type 'a elt := 'a
     and module On_monad := On_monad
     and module With_errors := With_errors

  include Mappable.S1_container with type 'a t := 'a t

  include Mappable.Extensions1 with type 'a t := 'a t

  (** [With_elt (Elt)] demotes this [S1_container] to a
      {{!S0_container}S0_container} by fixing the element type to that mentioned
      in [Elt]. *)
  module With_elt (Elt : Equal.S) :
    S0_container with type t := Elt.t t and module Elt = Elt
end
