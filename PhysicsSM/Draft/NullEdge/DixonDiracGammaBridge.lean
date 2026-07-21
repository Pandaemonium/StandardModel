import PhysicsSM.Draft.NullEdge.DixonDiracGamma

/-!
# Signature bridge: mostly-plus bar-operator gammas -> mostly-minus convention (P8(d) stage 0)

Plan P8(d) stage 0 (`Sources/Null_Edge_Ten_Priorities_Research_Plan_2026-07-18.md`)
and the convention-doc caution: the landed `DixonDiracGamma` table is
MOSTLY-PLUS (`eta = diag(-1,+1,+1,+1)`, kernel-read); PhysLean, the repo's
`DiracGammaPhysLean.lean`, and most particle-physics texts are MOSTLY-MINUS
(`diag(+1,-1,-1,-1)`). The textbook bridge is `gamma -> i gamma`, which flips
every anticommutator sign: `{i gamma^mu, i gamma^nu} = -{gamma^mu, gamma^nu}`.

This module makes the bridge KERNEL-EXACT on the Dixon bar-operator
realization: `gammaM mu := i-smul o gamma mu` satisfies
`(gammaM 0)^2 = +1`, `(gammaM k)^2 = -1`, off-diagonal anticommutators `0` -
i.e. the mostly-minus table - so ANY mostly-minus identity can be imported
through `gammaM` without touching the landed mostly-plus module. No
sign-sensitive identity may be transported between the conventions except
through these lemmas (convention-doc sec 5 rule).

All proofs are algebraic from the landed table + `I^2 = -1`; the only kernel
content is the shallow `I`-smul/bar commutation.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DixonDiracGammaBridge

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.DixonWeakLadders
open PhysicsSM.Draft.NullEdge.DixonDiracGamma

set_option maxHeartbeats 4000000

/-- The mostly-minus gammas: `gammaM^mu = i gamma^mu` (central complex `i`
via the `C`-scalar action). -/
def gammaM0 (z : Dixon) : Dixon := Complex.I • gamma0 z
def gammaM1 (z : Dixon) : Dixon := Complex.I • gamma1 z
def gammaM2 (z : Dixon) : Dixon := Complex.I • gamma2 z
def gammaM3 (z : Dixon) : Dixon := Complex.I • gamma3 z

/-! The gammas commute with the central `C`-scalar action (shallow kernel:
bar operators with `H`-unit slots are `C`-linear). -/

/-- Shared closer: slot split + coordinate simp + ring. -/
macro "gammaM_tab" : tactic =>
  `(tactic|
    (refine Dixon.ext ?_ ?_ ?_ ?_ <;>
      ext <;>
        simp [gamma0, gamma1, gamma2, gamma3, bar, Rmul, Lmul, Idix, ofColour,
          mul, i1, i2, i3, I, ComplexOctonion.mul_re, ComplexOctonion.mul_im,
          ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] <;>
        ring))

theorem gamma0_smul (c : ℂ) (z : Dixon) : gamma0 (c • z) = c • gamma0 z := by
  gammaM_tab
theorem gamma1_smul (c : ℂ) (z : Dixon) : gamma1 (c • z) = c • gamma1 z := by
  gammaM_tab
theorem gamma2_smul (c : ℂ) (z : Dixon) : gamma2 (c • z) = c • gamma2 z := by
  gammaM_tab
theorem gamma3_smul (c : ℂ) (z : Dixon) : gamma3 (c • z) = c • gamma3 z := by
  gammaM_tab

/-- `I • I • a = -a` on Dixon (local copy of the CAR-file helper). -/
theorem I_smul_I' (a : Dixon) : Complex.I • Complex.I • a = -a := by
  have h : (Complex.I * Complex.I : ℂ) = -1 := Complex.I_mul_I
  calc Complex.I • Complex.I • a = (Complex.I * Complex.I) • a := by
        rw [← smul_smul]
    _ = -a := by rw [h, neg_one_smul]

/-! ## The mostly-minus table (algebraic from the landed mostly-plus table) -/

/-- **`(gammaM^0)^2 = +1`**: the timelike square is `+1` in mostly-minus. -/
theorem gammaM0_sq (z : Dixon) : gammaM0 (gammaM0 z) = z := by
  unfold gammaM0
  rw [gamma0_smul, I_smul_I', gamma0_sq]
  exact neg_neg z

/-- **`(gammaM^1)^2 = -1`**. -/
theorem gammaM1_sq (z : Dixon) : gammaM1 (gammaM1 z) = -z := by
  unfold gammaM1
  rw [gamma1_smul, I_smul_I', gamma1_sq]

/-- **`(gammaM^2)^2 = -1`**. -/
theorem gammaM2_sq (z : Dixon) : gammaM2 (gammaM2 z) = -z := by
  unfold gammaM2
  rw [gamma2_smul, I_smul_I', gamma2_sq]

/-- **`(gammaM^3)^2 = -1`**. -/
theorem gammaM3_sq (z : Dixon) : gammaM3 (gammaM3 z) = -z := by
  unfold gammaM3
  rw [gamma3_smul, I_smul_I', gamma3_sq]

/-- Off-diagonal `{gammaM^0, gammaM^1} = 0` (bridge preserves vanishing). -/
theorem gammaM01_anticomm (z : Dixon) :
    gammaM0 (gammaM1 z) + gammaM1 (gammaM0 z) = 0 := by
  unfold gammaM0 gammaM1
  rw [gamma0_smul, gamma1_smul, I_smul_I', I_smul_I', ← neg_add,
    gamma01_anticomm, neg_zero]

/-- `{gammaM^0, gammaM^2} = 0`. -/
theorem gammaM02_anticomm (z : Dixon) :
    gammaM0 (gammaM2 z) + gammaM2 (gammaM0 z) = 0 := by
  unfold gammaM0 gammaM2
  rw [gamma0_smul, gamma2_smul, I_smul_I', I_smul_I', ← neg_add,
    gamma02_anticomm, neg_zero]

/-- `{gammaM^0, gammaM^3} = 0`. -/
theorem gammaM03_anticomm (z : Dixon) :
    gammaM0 (gammaM3 z) + gammaM3 (gammaM0 z) = 0 := by
  unfold gammaM0 gammaM3
  rw [gamma0_smul, gamma3_smul, I_smul_I', I_smul_I', ← neg_add,
    gamma03_anticomm, neg_zero]

/-- `{gammaM^1, gammaM^2} = 0`. -/
theorem gammaM12_anticomm (z : Dixon) :
    gammaM1 (gammaM2 z) + gammaM2 (gammaM1 z) = 0 := by
  unfold gammaM1 gammaM2
  rw [gamma1_smul, gamma2_smul, I_smul_I', I_smul_I', ← neg_add,
    gamma12_anticomm, neg_zero]

/-- `{gammaM^1, gammaM^3} = 0`. -/
theorem gammaM13_anticomm (z : Dixon) :
    gammaM1 (gammaM3 z) + gammaM3 (gammaM1 z) = 0 := by
  unfold gammaM1 gammaM3
  rw [gamma1_smul, gamma3_smul, I_smul_I', I_smul_I', ← neg_add,
    gamma13_anticomm, neg_zero]

/-- `{gammaM^2, gammaM^3} = 0`. -/
theorem gammaM23_anticomm (z : Dixon) :
    gammaM2 (gammaM3 z) + gammaM3 (gammaM2 z) = 0 := by
  unfold gammaM2 gammaM3
  rw [gamma2_smul, gamma3_smul, I_smul_I', I_smul_I', ← neg_add,
    gamma23_anticomm, neg_zero]

end PhysicsSM.Draft.NullEdge.DixonDiracGammaBridge

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.DixonDiracGammaBridge.gammaM0_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DixonDiracGammaBridge.gammaM0_sq

/-- info: 'PhysicsSM.Draft.NullEdge.DixonDiracGammaBridge.gammaM01_anticomm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DixonDiracGammaBridge.gammaM01_anticomm
