# Aristotle proof job: Euclidean gamma matrices + finite Clifford algebra (QMF4a)

Prove the six `s o r r y`s in `Qmf4aGamma/EuclideanGamma.lean`. Pure Mathlib,
concrete `4 x 4` complex matrices - mechanical but finicky computation. The
whole point is to keep the proofs BUILD-EFFICIENT (this file will be wired into
a large aggregate), so prefer a slick uniform tactic over 256 hand cases if you
can find one.

Formatting: ASCII only, LF. Spaced escape-hatch tokens in prose.

BUILD: run `lake env lean Qmf4aGamma/EuclideanGamma.lean` first.

## Targets (all currently `s o r r y`)

Concrete Euclidean gamma matrices `γ1..γ4 : Matrix (Fin 4) (Fin 4) ℂ` are given
(chiral basis), `γ5 = γ1*γ2*γ3*γ4`, and `γ : Fin 4 → ...` indexes them. Prove:

1. `γ_sq (μ) : γ μ * γ μ = 1`
2. `γ_anticomm (μ ν) : γ μ * γ ν + γ ν * γ μ = (2 * if μ = ν then 1 else 0) • 1`
   (the Euclidean Clifford relation `{γ_μ, γ_ν} = 2 δ_{μν} I`)
3. `γ_herm (μ) : (γ μ)ᴴ = γ μ`  (each gamma is Hermitian)
4. `γ5_sq : γ5 * γ5 = 1`
5. `γ5_herm : (γ5)ᴴ = γ5`
6. `γ5_anticomm (μ) : γ5 * γ μ + γ μ * γ5 = 0`

## Convention is ground-truth-pinned - do NOT change the matrices

The gamma matrices are pinned by an external oracle (a from-scratch
Wilson-Dirac / Clifford check, 21/21) and MUST NOT be modified. If any target
appears false, that means a transcription error to DEBUG against the oracle
facts (all six ARE true for these matrices), not a reason to change a matrix or
weaken a statement.

## Proof hints (verified working per-case)

The single case `γ1 * γ1 = 1` closes with
`simp only [γ1]; ext i j; fin_cases i <;> fin_cases j <;>
  simp [Matrix.mul_apply, Fin.sum_univ_four, Matrix.one_apply] <;>
  norm_num [Complex.ext_iff]`
under the raised `maxHeartbeats` already set in the file. For the indexed
versions, `fin_cases μ` (and `fin_cases ν`) then `simp only [γ]` reduces
`γ 0`..`γ 3` to the concrete matrices; `simp only [γ5]` unfolds gamma5. For
Hermiticity use `Matrix.conjTranspose_apply` + `Complex.ext_iff`. `Fin.isValue`
/ `Matrix.cons_val` lemmas may help the entry extraction. If a uniform
`decide`-free normal-form tactic (e.g. `Matrix.ext` + `Finset.sum` normalization,
or `norm_num [Matrix.mul_apply, ...]`) proves several at once with a smaller
heartbeat footprint, prefer it - build efficiency matters.

`Matrix.mul_fin_four` does NOT exist in this Mathlib; use `Matrix.mul_apply` +
`Fin.sum_univ_four`.

## Guardrails

No `a x i o m` / `n a t i v e _ d e c i d e` / `s o r r y` in the final file
(`decide` is acceptable here only if it genuinely closes a concrete
finite complex-matrix goal WITHOUT `native_decide` and stays fast - but these
are over `ℂ`, so `decide` will not apply; expect `simp`/`norm_num`). Keep the
matrix definitions and all six statement shapes UNCHANGED.

## Output

1. The complete proved `Qmf4aGamma/EuclideanGamma.lean`.
2. Confirm `#print axioms` on each of the six is `[propext, Classical.choice,
   Quot.sound]` and `lake env lean` is clean.
3. One line on the tactic you settled on and its build cost (so the parent can
   judge aggregate-build impact).
