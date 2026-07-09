# Strategy + proof: generalize `det P = concurrence²` from two edges to `n`

## Context (you are blind to the wider repo)

`src/` has two self-contained Lean 4 files (Mathlib only) from a finite
mathematical-physics program in which the invariant **mass** of a bundle of `n`
light-like ("null") degrees of freedom is a Gram/Plücker determinant.

- `TwoEdgeMassConcurrence.lean` (kernel-checked, no `sorry`) proves the **two-edge**
  identification. For a `2×2` complex amplitude matrix `M` (columns = the two null
  2-spinors `ψ₁, ψ₂`), the momentum matrix is `P = M * Mᴴ`, the two-edge Plücker
  mass is `det P`, and:
  - `det_gram_eq_normSq_wedge`: `det(M * Mᴴ) = normSq(det M)` (`= |ψ₁ ∧ ψ₂|²`);
  - `four_mul_det_gram_eq_concurrence_sq`: `4 · det(M * Mᴴ) = C²` where the Wootters
    concurrence is `C = 2‖det M‖`. So `det P = (C/2)²`.
- `NullEdgeP6Concurrence.lean` has the Wootters two-qubit concurrence
  `concurrence a b c d = 2|ad − bc|` and `concurrence² = 4 · det ρ`.

## The target

Generalize `det P = concurrence²` (up to normalization) from **two** edges to a
bundle of **`n`** null spinors. Concretely:

- Let `M : Matrix (Fin d) (Fin n) ℂ` have columns `ψ₁,…,ψ_n ∈ ℂ^d` (the null
  spinors); the momentum/Gram matrix is `P = M * Mᴴ : Matrix (Fin d) (Fin d) ℂ`
  and the Plücker mass is `det P` (for `d = n`; for `d < n`, `det(Mᴴ M)` /
  Cauchy–Binet — you choose the cleanest square case first, `d = n`).
- **Find the correct multi-party entanglement measure** whose square equals
  `det P` (up to an explicit normalization constant). The natural candidate is the
  **G-concurrence** (Gour; "Nandi's G-concurrence" in the program's notes): for an
  `n`-party state the G-concurrence is built from `det` of the Gram/reduced-density
  data, so `det P` should be its `n`-th power / square in the right convention.
  Determine the exact statement, then **prove it**.

Deliverables, in priority order (land as many as cleanly hold):

1. `det (M * Mᴴ) = normSq (det M)` for `n = d` general (the clean generalization of
   `det_gram_eq_normSq_wedge`; `det(M Mᴴ) = |det M|²` — a one-line
   `det_mul` + `det_conjTranspose` + `mul_conj` proof).
2. The Cauchy–Binet form for `d ≠ n`: `det(Mᴴ M) = ∑` over `d`-subsets of squared
   Plücker minors (`= Σ|ψ_S ∧ …|²`), tying `det P` to the *sum of pairwise/­k-wise
   wedges* — this is the honest "mass = total disagreement" at `n` edges.
3. The G-concurrence identification: state the measure precisely and prove
   `det P = (G-concurrence)^{power}` up to the normalization constant, OR report
   precisely why no clean `n`-party concurrence squares to `det P` (also a genuine
   finding — it would mean the two-edge Wootters bridge is special).

## Constraints

Kernel-checked only: no `sorry`/`admit`/`native_decide`/new `axiom`; target axiom
footprint `[propext, Classical.choice, Quot.sound]`, enforced with in-file
`#guard_msgs … #print axioms`. Self-contained (Mathlib only). Use the pinned
toolchain you scaffold. Do not weaken the existing two-edge theorems.

## Deliverable format

The completed Lean file(s), `#print axioms` output, and `ARISTOTLE_SUMMARY.md`
stating: the final `n`-edge statement(s), which of (1)–(3) landed, the exact
G-concurrence convention used, and — honestly — whether "mass = concurrence²"
generalizes cleanly or is genuinely a two-edge coincidence.
