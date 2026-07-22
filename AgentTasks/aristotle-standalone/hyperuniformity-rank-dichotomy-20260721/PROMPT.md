# Job: WHICH symmetry groups admit hyperuniformity? A rank dichotomy.

Mathlib-only, finite, real. This is a classification job, and a kernel refutation of
any item is a first-class result.

## The question
A landed theorem shows an invariant PSD covariance cannot suppress one mode without
suppressing its whole orbit. The physics question behind it (everpresent-Lambda:
can long-wavelength number fluctuations be pushed below Poisson - "hyperuniformity" -
while staying frame-blind?) turns out to depend on HOW BIG the symmetry group is.
Make that precise.

## Setup
`G` a finite group acting TRANSITIVELY on `X = Fin N`. Work with real symmetric
matrices `C : Matrix (Fin N) (Fin N) R` that are `G`-invariant:
`C (g . x) (g . y) = C x y`. Let `r` = the number of `G`-orbits on `X x X`
(the RANK of the permutation group). Regional variance of `A : Finset (Fin N)` is
`V C A = 1_A dotProduct (C.mulVec 1_A)`.

## Targets

1. **The uniform mode is always an eigenvector.** For transitive `G` and invariant `C`,
   `C.mulVec 1 = lam . 1` for some `lam`. Define **hyperuniform** as `lam = 0`
   (the grand-total mode carries no variance).
2. **Dimension count.** The space of `G`-invariant symmetric matrices has dimension
   equal to the number of symmetrized pair-orbits; hyperuniformity `C.mulVec 1 = 0`
   is ONE linear condition on it. (State/prove as much of this as is clean; the
   dimension formula may be stated for the orbit-indicator basis.)
3. **RANK-2 RIGIDITY (the no-go).** Suppose `G` is 2-transitive, equivalently `r = 2`,
   equivalently every invariant symmetric matrix is `a . 1 + b . (J - 1)`. Prove:
   if additionally `C` is PSD and hyperuniform (`C.mulVec 1 = 0`), then
   `C = a . (1 - (1/N) . J)` with `a >= 0`, and consequently
   `V C A = a * |A| * (N - |A|) / (N - 1)` for EVERY region `A`.
   **So regional variance is exactly linear in `|A|` for small regions: Poisson-like,
   never sub-linear, unless `C = 0`.** Include the `C 0 0 = 0 -> C = 0` step.
4. **RANK >= 3 FREEDOM (the escape exists).** Exhibit a concrete transitive `G` and an
   invariant PSD hyperuniform `C` whose regional variance is NOT linear in `|A|` -
   the natural witness is the cyclic group `Z/N` acting by rotation with the discrete
   second-difference kernel `c(k)` whose symbol is `|1 - exp(i theta)|^2`, i.e.
   `C = 2 . 1 - S - S^T` where `S` is the cyclic shift. Prove for a concrete `N`
   (e.g. `N = 6` or `N = 8`): `C` is symmetric, PSD, `C.mulVec 1 = 0`, and there is a
   contiguous region `A` (an arc) with `V C A` BOUNDED independently of `|A|` -
   ideally `V C A = 2` for every proper nonempty arc, versus the rank-2 law which
   would give something growing with `|A|`. Compare the two numbers explicitly.
5. **The dichotomy as one statement.** Package 3 and 4: a transitive symmetry group
   admits a nonzero hyperuniform invariant PSD covariance ONLY IF its rank is at
   least 3 - 2-transitivity forbids it. State cleanly what is and is not proved (you
   are proving the rank-2 direction in general and the rank-3 direction by witness;
   do NOT claim a full iff unless you actually prove it).
6. If reachable: for the cyclic witness, prove the arc variance is exactly `2` for
   every arc that is neither empty nor all of `X` - the crispest possible contrast
   with the linear-in-`|A|` rank-2 law.

## Constraints
- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`
  (this is a hard requirement - use `decide`/`Finset` computation or explicit algebra).
- Standard axioms only; report `#print axioms` per main theorem.
- Keep docstrings scoped: this is finite linear algebra about invariant covariances.
  At most one careful sentence relating it to hyperuniformity/discreteness physics.
