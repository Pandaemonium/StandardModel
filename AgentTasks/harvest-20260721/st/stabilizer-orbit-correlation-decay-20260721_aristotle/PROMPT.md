# Job: large stabilizer orbits force correlation decay - the finite shadow of
# "Poisson is the only Lorentz-invariant sprinkling"

Mathlib-only, finite, real. Kernel refutation of any item is a first-class result.

## The mechanism this job formalizes
Why is Poisson apparently the only Poincare-invariant point process? Not because
invariance forbids correlations in general - homogeneous ISOTROPIC hyperuniform
processes exist and are well studied (Torquato). The actual mechanism is the size of
the orbits of the POINT STABILIZER:

* For lattice translations on `Z`, the stabilizer of a point is trivial, so each
  "separation class" contains exactly one partner point, and summable correlations are
  fine - hyperuniform invariant processes exist.
* For the Lorentz group, the stabilizer of a point is the whole Lorentz group, and its
  orbits on the remaining points are entire hyperboloids - INFINITELY many partners all
  carrying the SAME correlation value. Finite total correlation then forces that value
  to vanish, leaving only the diagonal: white noise, i.e. Poisson.

This job proves the finite, quantitative version: **correlation at a separation class
is suppressed by the size of that class.**

## Setup
`G` a finite group acting transitively on `X = Fin N`. Fix a base point `x0`. The
stabilizer `G_x0` partitions `X \ {x0}` into suborbits `O_1, ..., O_(r-1)` of sizes
`n_1, ..., n_(r-1)` (`r` = rank of the permutation group). Let
`C : Matrix (Fin N) (Fin N) R` be symmetric, `G`-invariant, PSD. Invariance makes
`C x0 y` constant on each suborbit; call the common values `c_1, ..., c_(r-1)`, and let
`a = C x0 x0`.

You may formalize the suborbit structure however is cleanest in Lean - if the full
orbit machinery is heavy, it is ACCEPTABLE to take as hypotheses that `X \ {x0}` is
partitioned into finsets `O_j` with `C x0 y = c_j` for `y` in `O_j`, plus symmetry and
PSD. State clearly which route you took.

## Targets

1. **Row-sum identity.** `∑ y, C x0 y = a + ∑ j, (n_j : R) * c_j`, and for a transitive
   action this equals the eigenvalue of `C` on the all-ones vector.
2. **The fixed-total (unimodular) constraint.** If `C.mulVec 1 = 0` then
   `a + ∑ j, n_j * c_j = 0`, i.e. `∑ j, n_j * c_j = -a`.
3. **MAIN THEOREM - decay from orbit size, under nonnegative correlations.** Assume in
   addition that all `c_j >= 0` (positively correlated / attractive case, the physically
   natural one) and `C.mulVec 1 = 0`. Then for every `j`,
   `(n_j : R) * c_j <= a`, hence `c_j <= a / n_j`.
   **Interpretation to state carefully in the docstring: correlation at a separation
   class is bounded by the base variance divided by the size of that class. A
   separation class of size `n` can carry at most `a/n` of correlation.**
   Wait - check the sign conventions before asserting: with `c_j >= 0` and
   `∑ n_j c_j = -a` one needs `a <= 0`, so state the correct version. If the honest
   conclusion is instead about `c_j <= 0` (anticorrelation forced) or about
   `|c_j| <= a / n_j` under a different hypothesis, PROVE THE CORRECT ONE and say so
   explicitly - do not force the stated form. Getting this sign right is a required
   part of the job.
4. **The white-noise limit, stated finitely.** Conclude: if some suborbit has size
   `n_j >= K`, then `|c_j| <= a / K`. So as stabilizer orbits grow, the invariant
   covariance converges to a multiple of the identity - **white noise**. State this as
   the finite shadow of "the only invariant process with finite variance is Poisson",
   and be explicit that it is a finite statement about covariances, not a theorem about
   point processes or about Lorentz invariance.
5. **The contrast that makes it content, not tautology.** Exhibit the cyclic group
   `Z/N` acting on itself: the stabilizer of a point is TRIVIAL, every suborbit has size
   `1` (or `2` for the unoriented case), the bound in 3/4 is vacuous, and there is an
   invariant PSD hyperuniform covariance with `C.mulVec 1 = 0` and NONZERO off-diagonal
   correlation - the second-difference kernel `2*1 - S - S^T` for the cyclic shift `S`.
   **This is the whole point: small stabilizer means correlation is allowed, large
   stabilizer means it is suppressed.** Prove it for a concrete `N` (e.g. `6` or `8`).
6. If reachable: for a 2-transitive `G` the stabilizer has a SINGLE orbit of size
   `N - 1`, so 3/4 give `|c| <= a/(N-1)` - recovering the maximal-symmetry rigidity as
   the extreme case of the same bound.

## Constraints
- No new `a x i o m` / `o p a q u e` / `u n s a f e`; **no `n a t i v e _ d e c i d e`**.
- Standard axioms only; report `#print axioms` per main theorem.
- Docstrings: this is finite linear algebra about invariant covariance matrices. At most
  two sentences of physical motivation, and they must NOT claim anything about Lorentz
  invariance, sprinklings, or the cosmological constant being derived.
