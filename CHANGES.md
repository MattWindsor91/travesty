# v0.4.0 (TBA)

Planned major release with incompatible name and library division changes.

## Breaking changes

The main change in this release is that all 'extension' modules (`T_xyz`)
have been renamed or moved into subpackages of `Travesty`:

- `T_monad` and `T_container` have changed to `Monad_exts` and `Container_exts`;
- Every other `T_` module now lives in either `Travesty.Base_exts` or
  `Travesty.Core_kernel_exts`, and no longer has the `T_` suffix.
- Modules in `Base_exts` depend on, and extend, the `Base` version of their
  namesake module.
- Modules in `Core_kernel_exts` depend on, and extend, the `Core_kernel` version
  of their namesake module.  Usually, they do so by importing the extensions from
  the `Base_exts` version on top of an import of the `Core_kernel` baseline module.

Other breaking changes:

- `Fn.on` now takes its second argument with the label `~f`.

## New features

- Add `Monad_exts.tee`, which is a counterpart to `tee_m` that accepts a
  non-monadic function.  (This is somewhat less useful, but still helps in
  terms of slotting, say, debug printing into a monadic pipeline.)
- Extensions: add `Or_error.combine_map[_unit]`, which are shorthand for
  mapping followed by `combine_errors[_unit]`, and are recommended for use
  instead of `map_m` and `iter_m` when using lists and `Or_error`.
- Extensions: add `Tuple2`, an extended `Core_kernel.Tuple2` adding bi-mappability.
- Add chaining for arity-2 bi-mappable containers across arity-1 mappable
  containers.  We now implement `Alist`'s bi-mappable interface using
  this and `Tuple2`.
- `Fn`: add `always`, which behaves like `const true`; and `never`, which
  behaves as `const false`.

## Other

- `Bi_mappable`: `Fix_left` and `Fix_right`'s signatures no longer destructively
  substitute `t`, so  `Alist.Fix_left(String).t` should now work.

# v0.3.0 (2019-03-03)

Major release with incompatible dependency and name changes.

## Breaking changes

- Now targeting v0.12 of Jane Street's upstream libraries.  This release of
  travesty no longer supports v0.11.
- As a result, travesty no longer supports OCaml 4.06; please use 4.07+.
- Traversable signature names have changed: `Basic_container0` is now `Basic0`,
  and `Basic_container1` is now `Basic1`.  The original names are now used for
  stronger interfaces that include implementations of `Container.S*`; see
  'new features' below for information.

## New features

- Add `T_container.Extensions0` and `Extend0`, which generalise most
  of `Extensions1`/`Extend1` to arity-0 containers.
- Generalise `T_container`'s predicate extensions (`any`/`all`/`none`)
  over arity-0 containers, provided that their `elt` is `x -> bool` for
  some `x`.
- Add `Bi_mappable`, an implementation of bifunctors.
- Add `T_alist`, an extended form of `List.Assoc`.
- Split the Traversable container functors into two kinds: the
  `Make_container*` functors now take `Basic*` signatures (but are otherwise
  the same---they still produce their own `Container.S*` instances); the new
  `Extend_container*` functors take the now-stronger `Basic_container*`
  signatures, which include custom implementations of `Container.S*`, and
  use those instead.  The idea is that `Make` is for building new containers
  from traversals, and `Extend` is for adding traversals to existing containers.

## Other

- `T_list` and `T_option` now use `Extend_container1` internally: the upshot
  of this is that they re-use the existing Core implementations of container
  operations where possible, rather than (slowly) re-building them using
  `fold_m`.

# v0.2.0 (2018-12-23)

Major release.

## Breaking changes

- _Potentially breaking change:_ `Traversable.S0_container` now
  contains `module Elt : Equal.S`, and constrains `type elt` to be
  equal to `Elt.t`.  This reflects the situation in
  `Basic_container0`, and shouldn't break any code using
  `Make_container0`, but may cause custom-built modules to fail to
  type-check.
- `T_container.any`'s arguments have swapped order, to be more
  in line with `Core` idioms.

## New features

- Add `Traversable.Chain0`, a functor for combining two
  `S0_container` instances together for nested traversal.
- Add `T_fn.disj` to go with `T_fn.conj`.
- Add `Filter_mappable`, which generalises `List.filter_map`.
- Add `tee_m` to monad extensions.  This is a small wrapper over
  `f x >>| fun () -> x` that allows unit-returning monadic
  side-effects to be treated as part of a monad pipeline.
- Add `T_or_error`: monad extensions for `Core.Or_error`.
- `one` and `two` are now implemented on `T_container`, not just
  `T_list`.  The errors are slightly less precise, but otherwise
  nothing has changed.
- Add `T_container.at_most_one` to complement `one` and `two`.
- Add `Monad.To_mappable`, which makes sure that monads can be
  converted to mappables.
- Add `T_container.all` and `none`, to complement `any`.

## Other

- Improve API documentation.

# v0.1.3 (2018-12-13)

Bugfix release.

- Fix incorrect module name (was `Lib`, not `Travesty`).
- Restrict to OCaml v4.06+ (this was the case in the final v0.1.2
  OPAM release, but not upstream).

# v0.1.2 (2018-12-12)

Bugfix and minor improvement release.

- Improve API documentation.
- Move functors and concrete modules out of `Intf` files.
- Generally rationalise the interface ready for a public release.
- Add various container modules from `act`: `Singleton`, `T_list`, and
  `T_option`.

# v0.1.1 (2018-12-10)

Bugfix release.

- Move API documentation, in an attempt to get `dune-release` to work.

# v0.1 (2018-12-10)

Initial release.

Existing functionality migrated from `act`'s utils directory.
