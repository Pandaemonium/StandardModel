# Job: the EXACT repair of the gap-to-pole obstruction - which datum makes the mass readout well-posed?

Mathlib-only, finite dimensional, complex or real (your choice, state it).

## Background (landed, do not redo)
It is proved here that in EVERY finite dimension there exist two Hermitian operators
with the SAME spectrum whose physical-sector weight takes the extreme values `1` and
`0`. So a `spectrum -> mass readout` map is ill-posed. That is the negative half.

**This job is the positive half: identify exactly what datum restores well-posedness,
and prove it is the Kaellen-Lehmann/moment data.** The pair (obstruction + exact
repair) is what makes this a theorem about physics rather than a curiosity.

## Setup
`H : Matrix (Fin n) (Fin n) C` Hermitian with eigenvalues `lam : Fin n -> R` and an
orthonormal eigenbasis `e`. Fix a source vector `v`. Define spectral weights
`w j = |<e j, v>|^2 >= 0`, and the response
`R z = sum j, w j / (z - lam j)` for `z` off the spectrum.

## Targets

1. **Weights are a probability-like datum.** `w j >= 0` and `sum j, w j = ||v||^2`.
2. **(spectrum, weights) determines the response**: the map is well defined, and
   conversely two families `(lam, w)` and `(lam', w')` with DISTINCT atoms giving the
   same `R` on an infinite subset of the resolvent set are equal as measures
   (partial fractions / linear independence of `z |-> 1/(z - lam j)`). If the fully
   general uniqueness is heavy, prove it for distinct `lam j` and nonzero weights.
3. **Moments determine the weights when the spectrum is known.** With distinct `lam j`,
   the moments `m k = <v, H^k v> = sum j, w j * (lam j)^k` for `k = 0, ..., n-1`
   determine `w` uniquely - a Vandermonde invertibility argument. State it as: the
   linear map `w |-> (m 0, ..., m (n-1))` is INJECTIVE.
4. **Moments determine spectrum AND weights.** If reachable: `2n` moments determine
   both (Hankel/Prony). If heavy, state and prove the `n = 2` case explicitly and
   report precisely what blocks the general case.
5. **The dichotomy, stated as one theorem.** Package: (a) there exist same-spectrum
   pairs with different readouts (restate a minimal witness in this file so the
   dichotomy is self-contained); (b) the moment sequence determines the readout.
   Conclusion: **the physically correct input is the moment / spectral-measure data,
   not the spectrum.**
6. **Sharpness of 3**: exhibit that `n - 1` moments do NOT suffice (two distinct weight
   vectors with the same `m 0, ..., m (n-2)`), for a concrete small `n`.

## Constraints
- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only; report `#print axioms` per main theorem.
- A KERNEL REFUTATION of any item is a first-class result; report it explicitly.
- Do not overclaim in docstrings: this is about a finite spectral-measure readout, not
  about physical mass. One careful sentence of physics context is enough.
