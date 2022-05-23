(lang dune 3.2)
(name travesty)
(implicit_transitive_deps false)

(generate_opam_files true)
(source (github MattWindsor91/travesty))
(license MIT)
(authors "Matt Windsor <mattwindsor91@gmail.com>")
(maintainers "Matt Windsor <mattwindsor91@gmail.com>")
(homepage "https://MattWindsor91.github.io/travesty/")
(documentation "https://MattWindsor91.github.io/travesty/")

(package
 (name travesty)
 (synopsis "Traversable containers, monad extensions, and more")
 (description "'Travesty' is a library for defining containers with applicative
or monadic traversals, inspired by Haskell's Traversable typeclass; it also
contains various helpers for monadic code, such as state transformers and
extension functions for common monads and containers.  It sits on top of Jane
Street's Base library and ecosystem.")
 (depends
  (ocaml (>= 4.14))
  (ppx_jane (and (>= v0.15.0)))
  (ppx_expect (and :with-test (>= v0.15.0)))
  (base (>= v0.15.0))))
