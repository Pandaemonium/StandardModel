import Mathlib

/-!
# Protected flip modes from the chiral determinant sign

Paper C pillar 2 engine (overnight publication run 2026-07-11, Fable lane).

Context.  The project has a kernel-checked chiral determinant dichotomy: a
unitary `W` carrying a chiral involution (`Gamma * Gamma = 1`,
`Gamma * W * Gamma = Wᴴ`) has `det W = 1` or `det W = -1`
(`ChiralZeroModeParity.chiral_det_eq_pm_one`).  The module's honesty note
records that the eigenvalue-multiplicity reading ("the sign pins protected
`+-1` modes") is stated in prose only.  This job turns that prose into
kernel-checked existence theorems.  The determinant sign is a discrete
invariant of the whole chiral-unitary class, so mode existence proved from
`det = -1` alone is a protection statement: no perturbation that preserves
unitarity, the chiral symmetry, and the determinant sign can remove the
mode.

Mathematical route (suggested, not mandatory).  Over `Complex` the
characteristic polynomial splits; its root multiset is closed under complex
conjugation because `Gamma * W * Gamma = Wᴴ` makes `W` similar to `Wᴴ`,
whose roots are the conjugates of the roots of `W`.  Every root of a
unitary matrix is unimodular (eigenvector norm preservation, or the C*
spectrum-of-unitary lemma).  Nonreal roots therefore pair with their
conjugates, each pair contributing `1` to the determinant, and real
unimodular roots are `1` or `-1`; hence `det W = (-1) ^ mult(-1)`.
`det W = -1` forces `mult(-1)` odd, in particular an exact `-1`
eigenvector; in even dimension it also forces `mult(1)` odd, hence an
exact `+1` eigenvector.

Success = all five theorems below proved with no proof holes
(kernel-checked; expected axioms only `propext`, `Classical.choice`,
`Quot.sound`).

Prohibited weakenings:
- do not add a diagonalizability or Hermitian hypothesis;
- do not replace exact eigenvectors by approximate or numerical statements;
- do not restrict to `Fin 2` except in the witness/control section;
- do not assume `Gamma` is Hermitian or unitary beyond `Gamma * Gamma = 1`.
-/

noncomputable section

namespace ChiralFlipMode

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- A chiral involution for `W` (reproduced from the project; do not
modify): a self-inverse `Gamma` conjugating `W` to its adjoint. -/
structure ChiralInvolution (W Gamma : Matrix n n ℂ) : Prop where
  invol : Gamma * Gamma = 1
  chiral : Gamma * W * Gamma = Wᴴ

/-- **T1 (conjugation-closed spectrum).**  For unitary `W` with a chiral
involution, the root multiset of the characteristic polynomial is fixed by
complex conjugation. -/
theorem chiral_unitary_charpoly_roots_conj
    {W Gamma : Matrix n n ℂ} (h : ChiralInvolution W Gamma)
    (hU : Wᴴ * W = 1) :
    (W.charpoly.roots.map (starRingEnd ℂ)) = W.charpoly.roots := by
  sorry

/-- **T2 (unimodular roots).**  Every characteristic root of a unitary
matrix is unimodular. -/
theorem unitary_charpoly_root_unimodular
    {W : Matrix n n ℂ} (hU : Wᴴ * W = 1) {lam : ℂ}
    (hlam : lam ∈ W.charpoly.roots) :
    lam * (starRingEnd ℂ) lam = 1 := by
  sorry

/-- **T3 (determinant parity).**  For unitary `W` with a chiral involution,
the determinant is `(-1)` raised to the multiplicity of the root `-1`. -/
theorem chiral_unitary_det_eq_neg_one_pow
    {W Gamma : Matrix n n ℂ} (h : ChiralInvolution W Gamma)
    (hU : Wᴴ * W = 1) :
    W.det = (-1 : ℂ) ^ (W.charpoly.roots.count (-1)) := by
  sorry

/-- **T4 (protected flip mode).**  `det W = -1` forces an exact eigenvector
with eigenvalue `-1`.  Because the hypothesis mentions only the discrete
class data (unitarity, chiral involution, determinant sign), the mode
survives every in-class perturbation. -/
theorem chiral_det_neg_one_forces_flip_mode
    {W Gamma : Matrix n n ℂ} (h : ChiralInvolution W Gamma)
    (hU : Wᴴ * W = 1) (hdet : W.det = -1) :
    ∃ v : n → ℂ, v ≠ 0 ∧ W.mulVec v = -v := by
  sorry

/-- **T4b (even-dimension partner mode).**  In even dimension,
`det W = -1` additionally forces an exact eigenvector with eigenvalue
`+1`: the walk register (two channels per site) always has even dimension,
so the two pinned modes come together. -/
theorem chiral_det_neg_one_forces_fixed_mode_of_even
    {W Gamma : Matrix n n ℂ} (h : ChiralInvolution W Gamma)
    (hU : Wᴴ * W = 1) (hdet : W.det = -1)
    (heven : Even (Fintype.card n)) :
    ∃ v : n → ℂ, v ≠ 0 ∧ W.mulVec v = v := by
  sorry

/-- **T5 (witness and boundary control).**  The flip pair
`W = Gamma = sigma_x` is a genuine chiral-unitary witness with
`det = -1` and the explicit flip mode `(1, -1)`; the identity walk is the
`det = 1` boundary control with no flip mode. -/
theorem sigma_x_witness_and_identity_control :
    (ChiralInvolution (!![0, 1; 1, 0] : Matrix (Fin 2) (Fin 2) ℂ)
        !![0, 1; 1, 0] ∧
      (!![0, 1; 1, 0] : Matrix (Fin 2) (Fin 2) ℂ).det = -1 ∧
      (!![0, 1; 1, 0] : Matrix (Fin 2) (Fin 2) ℂ).mulVec ![1, -1] =
        -(![1, -1]) ∧ (![1, -1] : Fin 2 → ℂ) ≠ 0) ∧
    ((1 : Matrix (Fin 2) (Fin 2) ℂ).det = 1 ∧
      ∀ v : Fin 2 → ℂ, (1 : Matrix (Fin 2) (Fin 2) ℂ).mulVec v = -v →
        v = 0) := by
  sorry

end ChiralFlipMode
