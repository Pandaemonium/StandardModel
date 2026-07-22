# Summary of changes for run 332b1262-edbe-4a06-9b75-90834702f127
Completed the Mathlib-only Lean formalization in `RequestProject/Main.lean`.

Proved:
- Full permutation invariance is equivalent, for `N ≥ 2`, to constant diagonal `a` and constant off-diagonal `b`.
- Exact regional law:
  `V C A = |A| * a + |A| * (|A| - 1) * b`.
- Fixed total forces `b = -a/(N-1)` and therefore
  `V C A = a * |A| * (N - |A|)/(N-1)`.
- PSD forces `a ≥ 0` and `a + (N-1)b ≥ 0`.
- For `2|A| ≤ N`, the clean lower bound
  `a * |A| / 2 ≤ V C A`.
- A PSD matrix with zero diagonal everywhere is zero; consequently, an invariant PSD covariance with `a = 0` is identically zero.
- The full frame-blind dichotomy: either `C = 0`, or every nonempty region of size at most `N/2` has strictly positive variance with the stated linear lower bound.
- Direct versions of the fixed-total law, lower bound, and dichotomy using the `PermutationInvariant` hypothesis rather than the exchangeable normal form.
- Variance is constant along a permutation orbit of regions (`numberVariance_image_eq`).
- A sharp `N = 4` non-invariant rank-one PSD example based on `v = (1,-1,1,-1)`, with fixed total, positive `C 0 0`, and zero variance on `{0,1}`. An existential theorem collects all these properties, including failure of permutation invariance.

The file includes `#print axioms` reports for all principal and supporting theorems. They use only the standard permitted axioms `propext`, `Classical.choice`, and `Quot.sound`.

Added `RequestProject.lean` and configured the library as the default Lake target. The full project builds successfully, and the source contains no `sorry`, `admit`, new axioms, `opaque`, `unsafe`, or `native_decide`.
