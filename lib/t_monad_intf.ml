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

(** [Extensions] contains extensions for a [Monad.S].

    To create an instance of [Extensions], use {{!Extend} Extend}. *)
module type Extensions = sig
  (** The type of the extended monad. *)
  type 'a t

  val when_m : bool -> f:(unit -> unit t) -> unit t
  (** [when_m predicate ~f] returns [f ()] when [predicate] is true, and
      [return ()] otherwise. *)

  val unless_m : bool -> f:(unit -> unit t) -> unit t
  (** [unless_m predicate ~f] returns [f ()] when [predicate] is false, and
      [return ()] otherwise. *)

  val tee_m : 'a -> f:('a -> unit t) -> 'a t
  (** [tee_m val ~f] executes [f val] for its monadic action, then returns
      [val].

      Example:

      {[
        let fail_if_negative x =
          T_on_error.when_m (Int.is_negative x)
            ~f:(fun () -> Or_error.error_string "value is negative!")
        in
        Or_error.(
          42 |> T_on_error.tee_m ~f:fail_if_negative >>| (fun x -> x * x)
        ) (* Ok (1764) *)
      ]} *)

  val tee : 'a -> f:('a -> unit) -> 'a t
  (** [tee val ~f] behaves as {{!tee_m} tee}, but takes a non-monadic [f].

      Example:

      {[
        let print_if_negative x =
          if Int.negative x then Stdio.print_string "value is negative!"
        in
        Or_error.(
          try_get_value ()
          >>= T_on_error.tee ~f:print_if_negative
          >>= try_use_value ()
        )
      ]} *)
end
