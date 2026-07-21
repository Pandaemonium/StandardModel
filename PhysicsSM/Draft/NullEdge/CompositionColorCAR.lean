import PhysicsSM.Algebra.Furey.LadderOperators

/-!
# The colour ladder CAR at the COMPOSITION-OPERATOR level (eq 7 as maps)

**Status: DRAFT.** Foundational for P4 (Cl(10)) and P5 (three generations)
stage B, and the honest counterpart of the landed ELEMENT-level CAR.

Furey (1910.08395 eq 6-7; 1806.00612 eq 21) asserts the Cl(6) CAR for the
ladder operators AS MAPS: `{alpha_i, alpha_j‡}(f) = delta_ij f` etc., where
products are COMPOSITIONS of left multiplications. The repo's landed
`LadderOperators` CAR is the ELEMENT-level statement
(`alpha_i * alpha_j‡ + alpha_j‡ * alpha_i = delta_ij` in `C(x)O`) - for SINGLE
ladders both levels are plausible, but octonion non-associativity makes them
LOGICALLY DISTINCT (`(a b) z != a (b z)` in general; the weak sector's
anti-Fock dictionary is the cautionary example). This module kernel-checks the
composition-level CAR for all 21 pairs: 6 like `{a_i, a_j} = 0`, 6 daggered,
9 mixed `{a_i, a_j‡} = delta_ij` - each a depth-2 free-variable identity.

Convention: XOR octonions, repo `alpha_i`; application `alpha_i * (alpha_j * z)`
is composition order `L_{alpha_i} o L_{alpha_j}`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionColorCAR

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators

set_option maxHeartbeats 8000000
set_option maxRecDepth 8000

/-- Shared closer for the depth-2 operator identities. -/
macro "ccar" : tactic =>
  `(tactic|
    (ext <;>
      simp [alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
        ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring))

/-! ## Like anticommutators vanish: `{a_i, a_j} = 0` as maps -/

theorem opCAR_11 (z : ComplexOctonion) :
    alpha1 * (alpha1 * z) + alpha1 * (alpha1 * z) = 0 := by ccar
theorem opCAR_22 (z : ComplexOctonion) :
    alpha2 * (alpha2 * z) + alpha2 * (alpha2 * z) = 0 := by ccar
theorem opCAR_33 (z : ComplexOctonion) :
    alpha3 * (alpha3 * z) + alpha3 * (alpha3 * z) = 0 := by ccar
theorem opCAR_12 (z : ComplexOctonion) :
    alpha1 * (alpha2 * z) + alpha2 * (alpha1 * z) = 0 := by ccar
theorem opCAR_13 (z : ComplexOctonion) :
    alpha1 * (alpha3 * z) + alpha3 * (alpha1 * z) = 0 := by ccar
theorem opCAR_23 (z : ComplexOctonion) :
    alpha2 * (alpha3 * z) + alpha3 * (alpha2 * z) = 0 := by ccar

/-! ## Daggered like anticommutators: `{a_i‡, a_j‡} = 0` as maps -/

theorem opCAR_11d (z : ComplexOctonion) :
    alpha1_dag * (alpha1_dag * z) + alpha1_dag * (alpha1_dag * z) = 0 := by ccar
theorem opCAR_22d (z : ComplexOctonion) :
    alpha2_dag * (alpha2_dag * z) + alpha2_dag * (alpha2_dag * z) = 0 := by ccar
theorem opCAR_33d (z : ComplexOctonion) :
    alpha3_dag * (alpha3_dag * z) + alpha3_dag * (alpha3_dag * z) = 0 := by ccar
theorem opCAR_12d (z : ComplexOctonion) :
    alpha1_dag * (alpha2_dag * z) + alpha2_dag * (alpha1_dag * z) = 0 := by ccar
theorem opCAR_13d (z : ComplexOctonion) :
    alpha1_dag * (alpha3_dag * z) + alpha3_dag * (alpha1_dag * z) = 0 := by ccar
theorem opCAR_23d (z : ComplexOctonion) :
    alpha2_dag * (alpha3_dag * z) + alpha3_dag * (alpha2_dag * z) = 0 := by ccar

/-! ## Mixed anticommutators: `{a_i, a_j‡} = delta_ij` as maps -/

theorem opCAR_1d1 (z : ComplexOctonion) :
    alpha1 * (alpha1_dag * z) + alpha1_dag * (alpha1 * z) = z := by ccar
theorem opCAR_2d2 (z : ComplexOctonion) :
    alpha2 * (alpha2_dag * z) + alpha2_dag * (alpha2 * z) = z := by ccar
theorem opCAR_3d3 (z : ComplexOctonion) :
    alpha3 * (alpha3_dag * z) + alpha3_dag * (alpha3 * z) = z := by ccar
theorem opCAR_1d2 (z : ComplexOctonion) :
    alpha1 * (alpha2_dag * z) + alpha2_dag * (alpha1 * z) = 0 := by ccar
theorem opCAR_1d3 (z : ComplexOctonion) :
    alpha1 * (alpha3_dag * z) + alpha3_dag * (alpha1 * z) = 0 := by ccar
theorem opCAR_2d1 (z : ComplexOctonion) :
    alpha2 * (alpha1_dag * z) + alpha1_dag * (alpha2 * z) = 0 := by ccar
theorem opCAR_2d3 (z : ComplexOctonion) :
    alpha2 * (alpha3_dag * z) + alpha3_dag * (alpha2 * z) = 0 := by ccar
theorem opCAR_3d1 (z : ComplexOctonion) :
    alpha3 * (alpha1_dag * z) + alpha1_dag * (alpha3 * z) = 0 := by ccar
theorem opCAR_3d2 (z : ComplexOctonion) :
    alpha3 * (alpha2_dag * z) + alpha2_dag * (alpha3 * z) = 0 := by ccar

end PhysicsSM.Draft.NullEdge.CompositionColorCAR

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionColorCAR.opCAR_1d1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionColorCAR.opCAR_1d1

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionColorCAR.opCAR_12' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionColorCAR.opCAR_12
