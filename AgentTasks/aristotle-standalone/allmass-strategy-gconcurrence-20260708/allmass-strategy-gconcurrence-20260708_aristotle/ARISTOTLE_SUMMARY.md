# Summary of changes for run adcb35e8-3ca4-4515-9504-6494575ba453
Generalized `det P = concurrence²` from two edges to `n`. All three deliverables landed, kernel-checked, `sorry`-free, Mathlib-only, each guarded in-file with `#print axioms` pinning the footprint to `[propext, Classical.choice, Quot.sound]`. The original two-edge files are unchanged and recovered as special cases. See `ARISTOTLE_SUMMARY.md`.

New files:
- `src/NEdgeMassConcurrence.lean` (Deliverables 1 & 3, square case `n = d`):
  • `det_gram_eq_normSq_wedge`: `det(M Mᴴ) = normSq(det M)` for general `n` (the `n`-edge mass = `|ψ₁ ∧ … ∧ ψₙ|²`), plus reality/nonnegativity.
  • `gConcurrence`: Gour's G-concurrence `G(M) = n·(det ρ)^{1/n}` = `n·(normSq(det M))^{1/n}` — the correct multi-party generalization of the Wootters concurrence.
  • `gConcurrence_pow_eq_det_gram`: `det P = (G/n)ⁿ`.
  • `gConcurrence_two_eq` and `four_mul_det_gram_eq_gConcurrence_two_sq`: at `n = 2`, `G = 2‖det M‖ = C` and the identity collapses to the original `4·det P = C²`.
- `src/NEdgeCauchyBinet.lean` (Deliverable 2, rectangular `d ≠ n`):
  • `det_gram_eq_sum_normSq_minors`: `det(M Mᴴ) = ∑_{f : Fin d ↪o Fin n} normSq(det(M.submatrix id f))` — the Cauchy–Binet/Gram form (mass = sum of squared `d`-wise Plücker wedges), proved from scratch (not in Mathlib), recovering Deliverable 1 at `d = n`.

Honest finding: "mass = concurrence²" is NOT a two-edge coincidence. It generalizes cleanly once the correct multi-party measure is used: with the G-concurrence, the exact statement is `det P = (G/n)ⁿ`, and the two-edge `det P = (C/2)²` is precisely its `n = 2` instance. The fixed factor `2`/square that the two-edge case shows is just the `n = 2` shadow of the general `n`/`n`-th-power normalization.

Verification: full project builds successfully; all axiom-pin `#guard_msgs` checks pass; a scan confirms no `sorry`/`admit`/`native_decide`/new `axiom`/`@[implemented_by]`. One heavy proof uses a raised `maxHeartbeats` (sound). Some cosmetic unused-`simp`-argument warnings remain in the auto-generated Cauchy–Binet proof; they do not affect correctness or the axiom footprint.

# Generalizing `det P = concurrence²` from two edges to `n`

This work generalizes the two-edge identification in `src/TwoEdgeMassConcurrence.lean`
(`4 · det(M Mᴴ) = C²`) to a bundle of `n` null spinors. All results are
kernel-checked, `sorry`-free, and Mathlib-only, with in-file `#print axioms`
guards pinning the footprint to `[propext, Classical.choice, Quot.sound]`. The
existing two-edge theorems are unchanged and are recovered as special cases.

## What landed

All three deliverables landed cleanly.

### Deliverable 1 — `det(M Mᴴ) = normSq(det M)` for general `n = d`
File `src/NEdgeMassConcurrence.lean`, `det_gram_eq_normSq_wedge`:
for `M : Matrix (Fin n) (Fin n) ℂ` (columns = the `n` null spinors),
`(M * Mᴴ).det = normSq (M.det)`. The `n`-edge Plücker mass is the squared
magnitude of the top wedge `|ψ₁ ∧ … ∧ ψₙ|²` (real, nonnegative:
`det_gram_im_zero`, `det_gram_re_nonneg`). This is the verbatim generalization of
the two-edge proof (`det_mul` + `det_conjTranspose` + `mul_conj`) to any `n`.

### Deliverable 3 — the G-concurrence identification (the multi-party measure)
File `src/NEdgeMassConcurrence.lean`.

The correct multi-party measure is **Gour's G-concurrence** (`G_N` in the
program's notes). For the null bundle read as a bipartite `n × n` pure state with
amplitude matrix `M` and reduced density data `ρ = P = M Mᴴ`, the convention used
is the standard one:

    gConcurrence M  =  n · (det ρ)^{1/n}  =  n · (normSq (det M))^{1/n}      (Real.rpow)

- `gConcurrence_pow_eq_det_gram`: for `0 < n`,
  `(gConcurrence M / n) ^ n = (M * Mᴴ).det.re`.
  i.e. **`det P = (G / n)ⁿ`** — the `n`-edge Plücker mass is exactly the `n`-th
  normalized power of the G-concurrence.
- `gConcurrence_two_eq`: at `n = 2`, `gConcurrence M = 2‖det M‖`, which is exactly
  the Wootters concurrence `C` of `TwoEdgeMassConcurrence`.
- `four_mul_det_gram_eq_gConcurrence_two_sq`: at `n = 2` the general identity
  collapses to `4 · det P = C²`, recovering the original two-edge theorem.

**Conclusion (honest):** "mass = concurrence²" is **not** a two-edge coincidence.
It generalizes cleanly, provided one uses the correct multi-party measure: the
Wootters concurrence's natural `n`-party successor is the G-concurrence, and the
exact statement is `det P = (G/n)ⁿ`. The two-edge `det P = (C/2)²` is precisely
the `n = 2` instance of this (`(G/n)ⁿ` with `n = 2`). The factor `n` and the `n`-th
power (rather than the fixed `2` and square) are the honest normalization that the
two-edge case hides because `2² = 4` and `n = 2` coincide there.

### Deliverable 2 — Cauchy–Binet / Gram form for `d ≠ n`
File `src/NEdgeCauchyBinet.lean`, `det_gram_eq_sum_normSq_minors`:
for a rectangular `M : Matrix (Fin d) (Fin n) ℂ`,

    (M * Mᴴ).det = ∑_{f : Fin d ↪o Fin n} normSq (det (M.submatrix id f)).

The sum ranges over all order embeddings `f : Fin d ↪o Fin n`, i.e. all
`d`-element ordered subsets of the `n` columns; `det (M.submatrix id f)` is the
`d`-wedge (Plücker minor) of that sub-bundle. So the mass `det P` is the **sum of
the squared magnitudes of all `d`-wise wedges** — the honest "mass = total `d`-wise
disagreement" at `n` edges. This is the Cauchy–Binet formula specialized to
`B = Mᴴ` (Gram determinant = sum of squared minors); it is not in Mathlib, so it
is proved from scratch here (expansion over index functions, vanishing of
non-injective terms, regrouping injective functions by order embedding times
permutation). At `d = n` there is a single embedding (the identity), recovering
Deliverable 1.

## Files
- `src/NEdgeMassConcurrence.lean` — Deliverables 1 and 3 (`n = d` square case).
- `src/NEdgeCauchyBinet.lean` — Deliverable 2 (Cauchy–Binet, `d ≠ n`).
- `src/TwoEdgeMassConcurrence.lean`, `src/NullEdgeP6Concurrence.lean` — original
  two-edge files, unchanged.

## Axiom footprint
Every headline theorem is guarded in-file with `#guard_msgs … #print axioms` and
depends only on `[propext, Classical.choice, Quot.sound]`. No
`sorry`/`admit`/`native_decide`/new `axiom`/`@[implemented_by]`.
