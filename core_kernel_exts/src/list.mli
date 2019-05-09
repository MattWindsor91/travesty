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

(** List extensions for [Core_kernel].

    This module expands and merges [Core_kernel.List] with
    {{!Travesty_base_exts.List} Travesty_base_exts.List}. *)

(** We replace [Core_kernel.List.Assoc] with our own
    {{!Alist} extended version}. *)
module Assoc = Alist

(** We then re-export the rest of [Core_kernel.List] for convenience. *)
include module type of Core_kernel.List with module Assoc := Assoc

(** We also include all of the extensions in
    {{!Travesty_base_exts.List} Travesty_base_exts.List}. *)
include module type of Travesty_base_exts.List.Extensions