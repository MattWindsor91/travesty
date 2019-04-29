# Travesty

[![Build Status](https://travis-ci.com/MattWindsor91/travesty.svg?branch=master)](https://travis-ci.com/MattWindsor91/travesty)

_Travesty_ is a library for defining containers with monadic traversals,
inspired by Haskell's
[Traversable](http://hackage.haskell.org/package/base/docs/Data-Traversable.html)
typeclass.  It sits on top of Jane Street's
[Core](https://opensource.janestreet.com/core/) library ecosystem.

Travesty also contains several other bits of Haskell-style monad functionality:

- state monads (`State`);
- state transformers (`State_transform`);
- miscellaneous extensions on monads (`Monad_exts`) and containers (`Containers_exts`);
- pre-extended forms of various `Base` (`Base_exts`) and `Core_kernel` (`Core_kernel_exts`)
  containers;
- extra function combinators (`Base_exts.Fn` and `Core_kernel_exts.Fn`).

Travesty is licenced under the MIT licence, and is a spin-off from the
[act](https://github.com/MattWindsor91/act) project.

## Usage

See the [API documentation](https://MattWindsor91.github.io/travesty).

Travesty tries to shadow existing modules only within `Base_exts` and
`Core_kernel_exts`.

## Contributions

Any and all contributions (pull requests, issues, etc.) are welcome.
