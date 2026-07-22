# Flagship job: frame-blindness FORCES Poisson-like number variance (no hyperuniformity)

Mathlib-only, finite dimensional, real. This is the quantitative sharpening of a
landed no-go and is the single highest-value target in the program.

## Background (already proved, do not redo)
For a finite group `G` acting transitively on a finite set `X` and a `G`-invariant PSD
covariance `C`, suppression of one mode propagates to its whole orbit. That is
qualitative. The physics (everpresent-Lambda: `Lambda ~ 1/sqrt(V)` from Poisson number
fluctuations) needs the QUANTITATIVE statement: can an invariant covariance make
REGIONAL number fluctuations grow slower than the region size (hyperuniformity)?

## Setup
`X = Fin N`. A covariance is `C : Matrix (Fin N) (Fin N) R`, symmetric PSD. For a
region `A : Finset (Fin N)` with indicator `1_A`, the **number variance** is
`V C A = (1_A) dotProduct (C.mulVec 1_A)`.

## Targets

1. **Two-transitive frame-blindness forces the exact Poisson-like law.**
   Suppose `C` is invariant under the full symmetric group action by permutation
   conjugation (`P C Pᵀ = C` for every permutation matrix `P`) - equivalently `C` is
   constant-diagonal `a` and constant-off-diagonal `b`, i.e. `C = (a - b) • 1 + b • J`.
   Prove `V C A = |A| * a + |A| * (|A| - 1) * b` for EVERY region `A`.

2. **Add the unimodular / fixed-total constraint** `1ᵀ C 1 = 0` (the total number does
   not fluctuate - this is exactly the unimodular condition in the Lambda argument).
   Prove it forces `b = -a/(N-1)` (for `N >= 2`) and hence
   `V C A = a * |A| * (N - |A|) / (N - 1)`.
   So the variance is COMPLETELY DETERMINED by the single scalar `a = C 0 0` and the
   region size. In particular for `|A| <= N/2`, `V C A >= a * |A| / 2`: **variance is
   bounded BELOW linearly in the region size** - Poisson-like, never hyperuniform,
   unless `a = 0`.

3. **Total suppression is the only escape.** Prove: if `a = 0` (i.e. `C 0 0 = 0`) and
   `C` is PSD then `C = 0`. Conclude the dichotomy: an `S_N`-invariant PSD covariance
   with fixed total either has strictly linear-in-`|A|` regional variance, or is
   identically zero. **There is no hyperuniform frame-blind option.**

4. **PSD forces the sign.** Prove `a >= 0` and `a + (N-1) b >= 0` from PSD, so the law
   in 2 has a nonneg constant, and state the resulting inequality cleanly.

5. **Sharpness / the escape route made explicit.** Exhibit for some concrete small `N`
   (e.g. `N = 4`) a NON-invariant PSD `C` with `1ᵀ C 1 = 0`, `C 0 0 > 0`, and a region
   `A` with `V C A = 0` - i.e. hyperuniform suppression of a region IS available once
   invariance is dropped. This is the sharp companion showing invariance is exactly
   what is being traded.

6. If cheap, state the general-transitive-`G` version of 1: `V C A` depends only on the
   pair-orbit counts of `A x A`, and is constant along the `G`-orbit of `A`.

## Constraints
- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only; report `#print axioms` for each main theorem.
- A KERNEL REFUTATION of any numbered item is a first-class result - report it with the
  counterexample rather than weakening silently.
- Prefer clean `Matrix`/`Finset` statements over heavy representation theory.

## Why this matters (for statement design, not for the docstring)
Item 2 is the finite machine-checked form of "you cannot beat Poisson while staying
frame-blind", which is the escape route the everpresent-Lambda magnitude argument
would need. Keep the statement about covariances and regions; do not editorialize
about Lambda in the Lean file beyond one careful sentence.
