# Travesty

![Main workflow](https://github.com/MattWindsor91/travesty/workflows/Main%20workflow/badge.svg)

_Travesty_ is a library for defining containers with applicative traversals,
inspired by Haskell's
[Traversable](http://hackage.haskell.org/package/base/docs/Data-Traversable.html)
typeclass.  It sits on top of Jane Street's
[Base](https://opensource.janestreet.com/base/) library.

Travesty also contains several other bits of Haskell-style applicative
functor and monad functionality:

- state monads (`Travesty.State`);
- state transformers (`Travesty.State_transform`);
- miscellaneous extensions on monads (`Travesty.Monad_exts`) and containers (`Travesty.Containers_exts`);
- extensions and implementations of Travesty signatures for `Base`
  (`Travesty_base_exts`);
- extra function combinators (`Travesty_base_exts.Fn`).

Note: the `Travesty_base_exts` modules form a separate subpackage
(`travesty.base_exts`).

Travesty is licenced under the MIT licence, and is a spin-off from the
[c4f](https://github.com/c4-project/c4f) project.

**NOTE:** I (@MattWindsor91) am no longer _actively_ working on `travesty`.  As
such, it will receive infrequent updates to keep it aligned with `Base` and
OCaml, but not many more new features.  Please feel free to file issues and
pull requests, but be patient when waiting for responses!

## Usage

See the [API documentation](https://MattWindsor91.github.io/travesty).

Travesty tries not to shadow existing modules except in the various
`exts` subpackages.

## Contributions

Any and all contributions (pull requests, issues, etc.) are welcome.
