import Mathlib

/-!
# Sylvester's law of inertia for complex Hermitian matrices (eigenvalue-count form)

PROOF TARGET for Aristotle. Self-contained (Mathlib only). This fills a genuine
Mathlib gap: Mathlib has Sylvester's law of inertia for QUADRATIC FORMS
(`QuadraticForm.equivalent_signType_weighted_sum_squared`,
`QuadraticForm.sigPos_of_equiv_weightedSumSquares`,
`QuadraticForm.sigNeg_of_equiv_weightedSumSquares`,
`QuadraticForm.sigPos_add_sigNeg_add_radical`), but NOT the complex-Hermitian
MATRIX form in terms of `Matrix.IsHermitian.eigenvalues`.

## The target

`congruence_preserves_inertia`: if `A`, `B` are complex Hermitian matrices,
`S` is invertible, and `B = Sᴴ A S` (a `*`-congruence), then `A` and `B` have the
SAME number of positive eigenvalues and the SAME number of negative eigenvalues
(counted with `Matrix.IsHermitian.eigenvalues`). Do NOT change the statement.

## Why it matters (context, not needed for the proof)

It is the connective lemma for a finite lattice chiral-index computation: the
overlap/GW index of a gapped Hermitian gauge operator `H` equals
`-(1/2)(n_+ - n_-)` (its inertia), and inertia is computed in practice from an
explicit rational `*`-congruence `Sᴴ H S = D` to a real diagonal `D` (Sylvester),
NOT from the eigenvalues (which are irrational). This lemma is what turns a
verified rational congruence into the eigenvalue-sign counts the index formula
consumes.

## Strategy leads (Aristotle: pick what works; all standard)

1. **Min-max / subspace dimension (cleanest).** The number of positive
   eigenvalues of a Hermitian `A` equals the maximal dimension of a subspace on
   which the Hermitian form `x ↦ xᴴ A x` is positive definite (a Courant-Fischer /
   Sylvester subspace characterization). An invertible `S` maps such subspaces for
   `A` bijectively to such subspaces for `B = Sᴴ A S` (since `xᴴ B x = (Sx)ᴴ A
   (Sx)` and `S` is a linear iso), so the maximal dimensions agree; likewise for
   negative eigenvalues.
2. **Homotopy invariance.** `GL_n(ℂ)` is path-connected, so `S` is connected to
   `1` by a path `S(t)`; if `A` is nonsingular then `S(t)ᴴ A S(t)` stays
   nonsingular Hermitian along the path, so no eigenvalue crosses `0` and the sign
   counts are constant (continuity of Hermitian eigenvalues). (Handles the gapped
   case, which is the intended use; the general case may need care at `0`.)
3. **Via the quadratic-form Sylvester** already in Mathlib: transport the complex
   Hermitian form to the associated real symmetric form on `ℂ^n ≅ ℝ^{2n}` and use
   `QuadraticForm.*` Sylvester, then relate the doubled signature back to the
   Hermitian eigenvalue counts (each complex eigenvalue contributes a real pair).

Useful Mathlib: `Matrix.IsHermitian.eigenvalues`, `.spectral_theorem`,
`.eigenvalues_eq`, `Matrix.PosSemidef` / `PosDef` and their eigenvalue
characterizations (`posDef_iff_eigenvalues_pos`,
`posSemidef_iff_eigenvalues_nonneg`), `Matrix.det_mul`, `isUnit` of `det` for
invertibility, `Matrix.toEuclideanLin` / the associated bilinear/sesquilinear
form.

Deliver: no `sorry`, no `native_decide`; axiom footprint
`[propext, Classical.choice, Quot.sound]`. Do not change the statement.
A helper specialization to a real-diagonal `B` (its eigenvalue-sign counts equal
the sign counts of its diagonal) is a welcome bonus but not required.
-/

open Matrix

namespace HermitianSylvester

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **Sylvester's law of inertia (Hermitian matrix / eigenvalue-count form).**
A `*`-congruence `B = Sᴴ A S` by an invertible `S` preserves the number of
positive eigenvalues and the number of negative eigenvalues of a complex Hermitian
matrix. -/
theorem congruence_preserves_inertia
    (A B S : Matrix n n ℂ) (hA : A.IsHermitian) (hB : B.IsHermitian)
    (hS : IsUnit S.det) (hcongr : B = Sᴴ * A * S) :
    (Finset.univ.filter (fun i => 0 < hA.eigenvalues i)).card
        = (Finset.univ.filter (fun i => 0 < hB.eigenvalues i)).card
    ∧ (Finset.univ.filter (fun i => hA.eigenvalues i < 0)).card
        = (Finset.univ.filter (fun i => hB.eigenvalues i < 0)).card := by
  sorry

end HermitianSylvester
