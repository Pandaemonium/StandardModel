import Mathlib
import PhysicsSM.Draft.TetrahedralHighMomentumNullBranch

/-!
# Massive branch lifting for `det(i D_+(q) + Γ_s Φ_H)` (Gate C / C20)

This module is the Aristotle deliverable for the **C20 massive branch-lifting
audit** (see `PROMPT.md`,
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` §23.6 step 6 and §25.3).

Gate C's massless work (`TetrahedralHighMomentumNullBranch`,
`NullEdgeFlavoredChirality`) classifies *determinant-level* null branches of the
flat retarded dual-soldered symbol: corners where the Clifford symbol `p(q)` is
nonzero but `p(q)² = 0`, so `det c(p(q)) = 0`.  The next physical test is whether
adding a constant mass block `Φ_H` (scalar `m` or matrix) **lifts**, **preserves**,
or **destabilizes** those determinant zeros.

## The finite algebra at the heart of the test

Everything reduces to one clean Clifford identity.  Model the massless symbol by
an abstract Clifford element `Dp = c(p(q))` together with the spacetime
chirality `Gs = Γ_s` satisfying the standard relations
```text
Gs² = 1,        {Gs, Dp} = 0,        Dp² = p² · 1,
```
where `p² : ℂ` is the (mostly-minus Lorentzian) symbol square — exactly the
`TetrahedralNullBranch.qform` of the corner.  These are the Gate A spacetime
relations (`NullEdgeSuperDiracSignAudit`): the vector Clifford symbol
anticommutes with chirality, and squares to the quadratic form.

For a **scalar** mass `m` the full operator is `M = i Dp + m Gs` and the square
collapses to a scalar:
```text
M² = (m² - p²) · 1.
```
Hence on a determinant-zero null branch (`p² = 0`) we get `M² = m² · 1`, so `M`
is invertible — the branch is **lifted** — exactly when `m ≠ 0`.

For a **matrix** mass block `Φ_H` in the Gate A convention (`[Γ_s, Φ_H] = 0`,
`[Dp, Φ_H] = 0`) the operator is `M = i Dp + Γ_s Φ_H` and the square is the
positive Gate A mass block minus the kinetic square:
```text
M² = Φ_H² - p² · 1.
```
On a null branch (`p² = 0`) this is `M² = Φ_H²`, so the branch is lifted exactly
when `Φ_H` is invertible: a **zero mode of `Φ_H` survives as a branch
singularity**.

## Determinant-level verdicts

Because `M² = c · 1` (scalar case) or `M² = Φ_H² - p²·1` (matrix case), taking
determinants gives
```text
(det M)² = (m² - p²)^N            (scalar, N = matrix size),
(det M)² = det(Φ_H² - p²·1)       (matrix).
```
Over `ℂ` (an integral domain) this yields exact iff-criteria:

* **Scalar:** `det M = 0 ↔ m² = p²`.  On a null branch: `det M = 0 ↔ m = 0`.
* **Matrix:** `det M = 0 ↔ det(Φ_H² - p²·1) = 0`.  On a null branch:
  `det M = 0 ↔ det Φ_H = 0`.

## Classification table (proved here)

| branch `p²` | mass            | `M²`            | `det M = 0 ⇔`        | verdict          |
|-------------|-----------------|-----------------|----------------------|------------------|
| `0` (null)  | scalar `m ≠ 0`  | `m²·1`          | never                | **lifted**       |
| `0` (null)  | scalar `m = 0`  | `0`             | always               | **preserved**    |
| `0` (null)  | matrix `Φ_H`    | `Φ_H²`          | `det Φ_H = 0`        | lifted iff invertible |
| `≠ 0`       | scalar `m`      | `(m²-p²)·1`     | `m² = p²`            | conditional      |

`complex/unstable` and `not-decidable-from-current-data` rows are recorded in the
companion note `AgentTasks/null-edge-massive-branch-lifting-audit.md`: this module
proves the *algebraic lifting* facts, which are necessary but not sufficient for a
full physical (Krein-signature, energy-slice, stability) release.

## Scope and honesty

* This is **finite algebra**.  It does not by itself prove positivity, real
  spectrum, Krein stability, or absence of complex branches; see the guardrails
  in `TetrahedralHighMomentumNullBranch` and §23.6 / §25.3 of the working plan.
* The Clifford relations `Gs² = 1`, `{Gs, Dp} = 0`, `Dp² = p²·1` are *model
  inputs* realizing a genuine gamma representation; an explicit `2×2` witness
  (`nullSymbol`, `chiralZ`) shows they are non-vacuous, with `p² = 0`, `Dp ≠ 0`.
* The link to the proven four three-`π` corners is `TetrahedralNullBranch`:
  those corners have `qform (cornerU s) = 0`, so they are exactly the `p² = 0`
  null branches of the classification.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdgeMassiveBranchLifting

open scoped Matrix
open Complex

/-! ## 1. The Clifford square identities (abstract `ℂ`-algebra) -/

section Algebra

variable {A : Type*} [Ring A] [Algebra ℂ A]

/-
**Scalar-mass super-Dirac square.**  With the Gate A spacetime relations
`Gs² = 1`, `{Gs, Dp} = 0`, `Dp² = p² · 1`, the massive operator
`M = i Dp + m Gs` squares to the scalar `(m² - p²) · 1`.

This is the finite algebra core of the C20 lifting test.
-/
theorem massive_square_scalar (Dp Gs : A) (psq m : ℂ)
    (hGs2 : Gs * Gs = 1)
    (hAnti : Gs * Dp = -(Dp * Gs))
    (hDp2 : Dp * Dp = psq • (1 : A)) :
    (Complex.I • Dp + m • Gs) * (Complex.I • Dp + m • Gs)
      = (m ^ 2 - psq) • (1 : A) := by
  have hI : (Complex.I : ℂ) ^ 2 = -1 := Complex.I_sq
  simp only [mul_add, add_mul, mul_smul_comm, smul_mul_assoc, smul_smul, hGs2, hDp2, hAnti]
  match_scalars
  · ring_nf; rw [hI]; ring
  · ring

/-
**Matrix-mass super-Dirac square (Gate A convention).**  With `Gs² = 1`,
`{Gs, Dp} = 0`, `Dp² = p² · 1`, and the mass block `Ph = Φ_H` commuting with
both `Gs` (Gate A: `[Γ_s, Φ_H] = 0`) and `Dp` (`[Dp, Φ_H] = 0`), the massive
operator `M = i Dp + Gs Ph` squares to `Ph² - p² · 1`.

The cross term cancels by `{Gs, Dp} = 0` together with `[Dp, Ph] = 0`, and the
mass block appears with the physical `+Φ_H²` Gate A sign because `[Gs, Ph] = 0`.
-/
theorem massive_square_matrix (Dp Gs Ph : A) (psq : ℂ)
    (hGs2 : Gs * Gs = 1)
    (hAnti : Gs * Dp = -(Dp * Gs))
    (hDp2 : Dp * Dp = psq • (1 : A))
    (hGsPh : Gs * Ph = Ph * Gs)
    (hDpPh : Dp * Ph = Ph * Dp) :
    (Complex.I • Dp + Gs * Ph) * (Complex.I • Dp + Gs * Ph)
      = Ph * Ph - psq • (1 : A) := by
  simp_all +decide [ mul_add, add_mul, mul_assoc, add_assoc ];
  simp_all +decide [ ← mul_assoc, ← smul_assoc ];
  simp_all +decide [ mul_assoc, sub_eq_neg_add ]

end Algebra

/-! ## 2. Determinant-level criteria (matrices over `ℂ`) -/

section Determinant

variable {n : Type*} [Fintype n] [DecidableEq n]

/-
The squared determinant of the scalar-mass operator is `(m² - p²)^N`.
-/
theorem massive_det_sq_scalar (Dp Gs : Matrix n n ℂ) (psq m : ℂ)
    (hGs2 : Gs * Gs = 1)
    (hAnti : Gs * Dp = -(Dp * Gs))
    (hDp2 : Dp * Dp = psq • (1 : Matrix n n ℂ)) :
    (Matrix.det (Complex.I • Dp + m • Gs)) ^ 2
      = (m ^ 2 - psq) ^ Fintype.card n := by
  convert congr_arg Matrix.det ( massive_square_scalar Dp Gs psq m hGs2 hAnti hDp2 ) using 1;
  · rw [ sq, Matrix.det_mul ];
  · simp +decide

/-
**Scalar-mass determinant criterion.**  For a nonempty matrix index, the massive
operator is singular iff the mass-shell condition `m² = p²` holds.
-/
theorem massive_det_zero_iff_scalar [Nonempty n] (Dp Gs : Matrix n n ℂ) (psq m : ℂ)
    (hGs2 : Gs * Gs = 1)
    (hAnti : Gs * Dp = -(Dp * Gs))
    (hDp2 : Dp * Dp = psq • (1 : Matrix n n ℂ)) :
    Matrix.det (Complex.I • Dp + m • Gs) = 0 ↔ m ^ 2 = psq := by
  constructor;
  · intro h_det_zero
    have h_mass_shell : (m ^ 2 - psq) ^ Fintype.card n = 0 := by
      have := massive_det_sq_scalar Dp Gs psq m hGs2 hAnti hDp2; aesop;
    exact eq_of_sub_eq_zero ( eq_zero_of_pow_eq_zero h_mass_shell );
  · intro h;
    have := massive_det_sq_scalar Dp Gs psq m hGs2 hAnti hDp2; simp_all +decide ;

/-
**Null-branch scalar lifting (the headline C20 result).**  On a determinant-zero
null branch (`p² = 0`), a nonzero constant scalar mass lifts the singularity:
`det(i Dp + m Γ_s) ≠ 0` for `m ≠ 0`, while `m = 0` preserves it.
-/
theorem nullBranch_scalar_lifted [Nonempty n] (Dp Gs : Matrix n n ℂ) (m : ℂ)
    (hGs2 : Gs * Gs = 1)
    (hAnti : Gs * Dp = -(Dp * Gs))
    (hDp2 : Dp * Dp = (0 : ℂ) • (1 : Matrix n n ℂ))
    (hm : m ≠ 0) :
    Matrix.det (Complex.I • Dp + m • Gs) ≠ 0 := by
  exact fun h => hm <| by simpa [ h, pow_eq_zero_iff ] using ( massive_det_zero_iff_scalar Dp Gs 0 m hGs2 hAnti ( by simp [ hDp2 ] ) ) |>.1 h

/-
On a null branch, a vanishing scalar mass preserves the determinant zero.
-/
theorem nullBranch_massless_preserved [Nonempty n] (Dp Gs : Matrix n n ℂ)
    (hGs2 : Gs * Gs = 1)
    (hAnti : Gs * Dp = -(Dp * Gs))
    (hDp2 : Dp * Dp = (0 : ℂ) • (1 : Matrix n n ℂ)) :
    Matrix.det (Complex.I • Dp + (0 : ℂ) • Gs) = 0 := by
  convert massive_det_zero_iff_scalar Dp Gs 0 0 hGs2 hAnti hDp2 |> Iff.mpr;
  norm_num

/-
**Matrix-mass determinant criterion.**  The massive operator with a matrix mass
block is singular iff the shifted mass-block square `Φ_H² - p²·1` is singular.
-/
theorem massive_det_zero_iff_matrix (Dp Gs Ph : Matrix n n ℂ) (psq : ℂ)
    (hGs2 : Gs * Gs = 1)
    (hAnti : Gs * Dp = -(Dp * Gs))
    (hDp2 : Dp * Dp = psq • (1 : Matrix n n ℂ))
    (hGsPh : Gs * Ph = Ph * Gs)
    (hDpPh : Dp * Ph = Ph * Dp) :
    Matrix.det (Complex.I • Dp + Gs * Ph) = 0
      ↔ Matrix.det (Ph * Ph - psq • (1 : Matrix n n ℂ)) = 0 := by
  have h_det_sq : Matrix.det (Complex.I • Dp + Gs * Ph) ^ 2 = Matrix.det (Ph * Ph - psq • 1) := by
    rw [ ← Matrix.det_pow ];
    rw [ sq, massive_square_matrix Dp Gs Ph psq hGs2 hAnti hDp2 hGsPh hDpPh ];
  rw [ ← h_det_sq, sq_eq_zero_iff ]

/-
**Null-branch matrix lifting.**  On a determinant-zero null branch (`p² = 0`), a
matrix mass block `Φ_H` lifts the singularity iff it is invertible: the massive
operator is singular iff `det Φ_H = 0`.  A zero mode of `Φ_H` survives as a
branch singularity.
-/
theorem nullBranch_matrix_lifted_iff (Dp Gs Ph : Matrix n n ℂ)
    (hGs2 : Gs * Gs = 1)
    (hAnti : Gs * Dp = -(Dp * Gs))
    (hDp2 : Dp * Dp = (0 : ℂ) • (1 : Matrix n n ℂ))
    (hGsPh : Gs * Ph = Ph * Gs)
    (hDpPh : Dp * Ph = Ph * Dp) :
    Matrix.det (Complex.I • Dp + Gs * Ph) = 0 ↔ Matrix.det Ph = 0 := by
  convert massive_det_zero_iff_matrix Dp Gs Ph 0 _ _ _ _ _ using 1 <;> norm_num [ hGs2, hAnti, hDp2, hGsPh, hDpPh ]

end Determinant

/-! ## 3. Explicit non-vacuous `2×2` Clifford witness

A concrete realization showing the Clifford hypotheses are satisfiable with a
genuine null symbol: `Dp² = 0` (so `p² = 0`) while `Dp ≠ 0`. -/

section Witness

/-- Chirality `Γ_s = σ_z = diag(1, -1)`. -/
def chiralZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- A null Clifford symbol `Dp = σ_x + i σ_y = !![0, 2; 0, 0]`: nilpotent
(`Dp² = 0`, so `p² = 0`), nonzero, anticommuting with `Γ_s`. -/
def nullSymbol : Matrix (Fin 2) (Fin 2) ℂ := !![0, 2; 0, 0]

theorem chiralZ_sq : chiralZ * chiralZ = 1 := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ chiralZ ]

theorem chiralZ_anticomm_nullSymbol : chiralZ * nullSymbol = -(nullSymbol * chiralZ) := by
  unfold chiralZ nullSymbol;
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num

theorem nullSymbol_sq : nullSymbol * nullSymbol = (0 : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ nullSymbol ]

theorem nullSymbol_ne_zero : nullSymbol ≠ 0 := by
  exact ne_of_apply_ne ( fun m => m 0 1 ) ( by norm_num [ nullSymbol ] )

/-
**Concrete null branch is lifted by a nonzero scalar mass.**  The explicit
`2×2` massive operator `i Dp + m Γ_s = !![m, 2i; 0, -m]` has determinant `-m²`,
which is nonzero exactly when `m ≠ 0`.
-/
theorem witness_det_scalar (m : ℂ) :
    Matrix.det (Complex.I • nullSymbol + m • chiralZ) = -m ^ 2 := by
  unfold nullSymbol chiralZ; norm_num [ Matrix.det_fin_two ] ; ring;

theorem witness_scalar_lifted (m : ℂ) (hm : m ≠ 0) :
    Matrix.det (Complex.I • nullSymbol + m • chiralZ) ≠ 0 := by
  rw [ witness_det_scalar ] ; aesop

theorem witness_massless_singular :
    Matrix.det (Complex.I • nullSymbol + (0 : ℂ) • chiralZ) = 0 := by
  convert witness_det_scalar 0 using 1;
  norm_num

end Witness

/-! ## 4. Linkage to the proven three-`π` null branches

The four high-momentum null corners (`cornerCount s = 3`) proved in
`TetrahedralHighMomentumNullBranch` have Lorentzian symbol square
`qform (cornerU s) = 0`.  Hence any gamma realization of those corners
(`Dp² = qform (cornerU s) · 1`) is exactly a `p² = 0` null branch, and the
classification above applies verbatim. -/

section Linkage

open PhysicsSM.Draft.TetrahedralNullBranch

variable {n : Type*} [Fintype n] [DecidableEq n]

/-
**Three-`π` branch scalar lifting.**  For any Clifford realization `Dp` of a
three-`π` corner (`Dp² = qform(cornerU s) · 1`, with `cornerCount s = 3`, so the
symbol square is null), a nonzero constant scalar mass lifts the branch.
-/
theorem threePi_branch_scalar_lifted [Nonempty n]
    (s : Fin 4 → Bool) (hs : cornerCount s = 3)
    (Dp Gs : Matrix n n ℂ) (m : ℂ)
    (hGs2 : Gs * Gs = 1)
    (hAnti : Gs * Dp = -(Dp * Gs))
    (hDp2 : Dp * Dp = (qform (cornerU s)) • (1 : Matrix n n ℂ))
    (hm : m ≠ 0) :
    Matrix.det (Complex.I • Dp + m • Gs) ≠ 0 := by
  have := massive_det_zero_iff_scalar Dp Gs ( qform ( cornerU s ) ) m hGs2 hAnti hDp2;
  have := threePi_null s hs; aesop;

/-
**Three-`π` branch matrix lifting criterion.**  For any Clifford realization of a
three-`π` corner, a matrix mass block `Φ_H` (Gate A convention) lifts the branch
iff it is invertible.
-/
theorem threePi_branch_matrix_lifted_iff
    (s : Fin 4 → Bool) (hs : cornerCount s = 3)
    (Dp Gs Ph : Matrix n n ℂ)
    (hGs2 : Gs * Gs = 1)
    (hAnti : Gs * Dp = -(Dp * Gs))
    (hDp2 : Dp * Dp = (qform (cornerU s)) • (1 : Matrix n n ℂ))
    (hGsPh : Gs * Ph = Ph * Gs)
    (hDpPh : Dp * Ph = Ph * Dp) :
    Matrix.det (Complex.I • Dp + Gs * Ph) = 0 ↔ Matrix.det Ph = 0 := by
  convert nullBranch_matrix_lifted_iff Dp Gs Ph hGs2 hAnti _ hGsPh hDpPh;
  rw [ hDp2, show qform ( cornerU s ) = 0 from by exact ( threePi_null s hs ) |>.1 ]

end Linkage

end NullEdgeMassiveBranchLifting
end Draft
end PhysicsSM

end
