# Travesty

_Travesty_ is a library for defining containers with monadic traversals,
inspired by Haskell's
[Traversable](http://hackage.haskell.org/package/base/docs/Data-Traversable.html)
typeclass.  It sits on top of Jane Street's
[Core](https://opensource.janestreet.com/core/) library ecosystem.

Travesty also contains several other bits of Haskell-style monad functionality:

- state monads (`state`)
- state transformers
- miscellaneous extensions on monads (`t_monad`), containers (`t_containers`),
  and functions (`t_fn`).

Travesty is licenced under the MIT licence, and is a spin-off from the
[act](https://github.com/MattWindsor91/act) project.

## Usage

Travesty shouldn't shadow any existing Core modules (any modules containing
extensions on them are prefixed by `t_`), so `open Travesty` should work.

## Contributions

Any and all contributions (pull requests, issues, etc.) are welcome.
