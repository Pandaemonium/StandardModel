# Lemma job: sharpen the two-factor Lie-Trotter constant

Mathlib-only, abstract, scoped L2 operator norm on `Matrix (Fin 4) (Fin 4) C`.

A landed bridge bounds the Lie-Trotter defect by
`8 (1+E)^2 exp(2E) E^2 * eps^2` with `E = ||A|| + ||B||`. That constant is explicit
but generous; it was flagged as "fit for a rate theorem, not a sharp-constant claim".
Improve it, honestly.

Prove the SHARPER classical bound:
```
|| exp(eps.A) * exp(eps.B) - exp(eps.(A+B)) || <= (eps^2 / 2) * ||A*B - B*A|| * exp(eps*(||A||+||B||))
```
or, if the commutator form is out of reach, the weaker-but-still-better
```
|| ... || <= eps^2 * ||A|| * ||B|| * exp(eps*(||A||+||B||)).
```
Key point: the leading behaviour should be governed by the COMMUTATOR (or at least
by `||A||*||B||`), NOT by `(||A||+||B||)^2` with an extra factor 8 - so that COMMUTING
generators give defect 0 (or the bound degrades gracefully toward 0 as the
commutator vanishes).

Also prove the sanity corollary: if `A*B = B*A` then
`exp(eps.A) * exp(eps.B) = exp(eps.(A+B))` exactly (defect zero) - and check whether
your bound actually reproduces that (the current constant does NOT, since it stays
positive for commuting A,B; that is the concrete sense in which it is not sharp).
Report which form you achieved. No new axioms/native_decide; standard axioms.
