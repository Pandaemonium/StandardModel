import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.TYAreaLaw
import PhysicsSM.Draft.NullEdge.GateYM.TYAreaLawSUN

/-!
# Concrete Z2 one-plaquette Tomboulis-Yaffe twist system (Z_le DERIVED)

The concrete `N = 2` instance of the LANDED abstract `TYAreaLawSUN.TwistSystem`,
built from the `TYAreaLaw` one-plaquette partition sums `Zplus`/`Zminus`.  Its
whole point: the twist-monotonicity field `Z_le` (`Z k <= Z 0`) - which is a
*modeled* reflection-positivity hypothesis in the abstract `TwistSystem` - is here
DERIVED by direct computation (`Z2Twist_le`, from `e^{-beta} >= 0`), as are the
nonnegativity and positivity fields.  So for the concrete Z2 one-plaquette model
the ONLY remaining modeled input to the Tomboulis-Yaffe area law is the
reflection-positivity raw bound `hW` (kept an explicit hypothesis in `z2AreaLaw`).

`z2_tyBaseSUN_eq_tyBase` proves this twist system reproduces exactly the Z2
area-law base `TYAreaLaw.tyBase beta`, so it is the same object as the landed Z2
Tomboulis-Yaffe area law, now assembled from a `TwistSystem` with `Z_le` proved.

Honest scope: this closes `Z_le`/nonnegativity/positivity for the CONCRETE Z2
one-plaquette model only. The genuinely nonabelian SU(N) case - constructing an
actual SU(N) Haar-measure twisted partition function and proving its
RP-monotonicity - remains open (the single C gate). Provenance: Tomboulis-Yaffe
1985 [N7SIEMAC] for the rigorous RP-inequality lineage, Kanazawa [K9FIBTZC] for
the SU(N) center-twist generalization/notation, and sm-ty-concrete (0758865d)
rewired onto the landed modules.  The file does not rely on decimation-based
all-coupling confinement claims. Zero `s o r r y`, standard axioms.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace TYTwistSystemZ2

open TYAreaLaw TYAreaLawSUN

noncomputable section

/-! ## The concrete Z2 twist system with Z_le DERIVED

`Z2Twist β 0 = Zplus β` (periodic), `Z2Twist β 1 = Zminus β` (`Z2`-twisted). -/

/-- The concrete `N = 2` twist family: `Z2Twist β 0 = Zplus β` (periodic),
`Z2Twist β 1 = Zminus β` (`Z2`-twisted). -/
def Z2Twist (beta : ℝ) : Fin 2 → ℝ := ![Zplus beta, Zminus beta]

@[simp] theorem Z2Twist_zero (beta : ℝ) : Z2Twist beta 0 = Zplus beta := rfl

@[simp] theorem Z2Twist_one (beta : ℝ) : Z2Twist beta 1 = Zminus beta := rfl

/-- **Nonnegativity** (both partition sums `≥ 0`; `Zminus β ≥ 0` needs `β ≥ 0`). -/
theorem Z2Twist_nonneg {beta : ℝ} (hbeta : 0 < beta) : ∀ k, 0 ≤ Z2Twist beta k := by
  intro k
  fin_cases k
  · simpa using (Zplus_pos beta).le
  · simpa using (Zminus_pos hbeta).le

/-- **Positivity of the periodic partition function** `Zplus β > 0`. -/
theorem Z2Twist_zero_pos (beta : ℝ) : 0 < Z2Twist beta 0 := by
  simpa using Zplus_pos beta

/-- **The KEY monotonicity `Z_le`, DERIVED**: `Zminus β ≤ Zplus β` because
`e^{-β} ≥ 0`, hence every twisted `Z2Twist β k ≤ Z2Twist β 0`. -/
theorem Z2Twist_le (beta : ℝ) : ∀ k, Z2Twist beta k ≤ Z2Twist beta 0 := by
  intro k
  fin_cases k
  · simp
  · show Z2Twist beta 1 ≤ Z2Twist beta 0
    simp only [Z2Twist_one, Z2Twist_zero, Zminus, Zplus]
    have : (0 : ℝ) ≤ Real.exp (-beta) := (Real.exp_pos _).le
    linarith

/-- **The strict twist** `Zminus β < Zplus β` for `β > 0` (since `e^{-β} > 0`),
giving the strict-twist hypothesis `∃ k, Z k < Z 0`. -/
theorem Z2Twist_lt (beta : ℝ) : Z2Twist beta 1 < Z2Twist beta 0 := by
  simp only [Z2Twist_one, Z2Twist_zero, Zminus, Zplus]
  have : (0 : ℝ) < Real.exp (-beta) := Real.exp_pos _
  linarith

/-- The concrete `Z2` one-plaquette **twist system**, with all three structure
fields (`Z_nonneg`, `Z_zero_pos`, `Z_le`) PROVED — in particular the
RP-monotonicity `Z_le` is *derived*, not assumed. -/
def z2TwistSystem (beta : ℝ) (hbeta : 0 < beta) : TwistSystem 2 where
  Z := Z2Twist beta
  Z_nonneg := Z2Twist_nonneg hbeta
  Z_zero_pos := Z2Twist_zero_pos beta
  Z_le := Z2Twist_le beta

/-- The concrete strict-twist witness. -/
theorem z2_strict_twist (beta : ℝ) (hbeta : 0 < beta) :
    ∃ k, (z2TwistSystem beta hbeta).Z k < (z2TwistSystem beta hbeta).Z 0 :=
  ⟨1, Z2Twist_lt beta⟩

/-- The `Z2` string tension is strictly positive. -/
theorem z2_tySunTension_pos (beta : ℝ) (hbeta : 0 < beta) :
    0 < (z2TwistSystem beta hbeta).tySunTension :=
  (z2TwistSystem beta hbeta).tySunTension_pos
    ((z2TwistSystem beta hbeta).tyBaseSUN_pos (z2_strict_twist beta hbeta))

/-! ## Recovery of the `Z2` area law of `TYAreaLaw.lean` -/

/-- **Recovery of `pN`.**  For the concrete `Z2` twist system,
`pN = (1/2)(1 + tanh β)`. -/
theorem z2_pN_eq (beta : ℝ) (hbeta : 0 < beta) :
    (z2TwistSystem beta hbeta).pN = (1 / 2) * (1 + Real.tanh beta) := by
  unfold TwistSystem.pN TwistSystem.ratio
  rw [Fin.sum_univ_two]
  show (1 / (2 : ℝ)) * ((z2TwistSystem beta hbeta).Z 0 / (z2TwistSystem beta hbeta).Z 0
      + (z2TwistSystem beta hbeta).Z 1 / (z2TwistSystem beta hbeta).Z 0) = _
  have h0 : (z2TwistSystem beta hbeta).Z 0 = Zplus beta := rfl
  have h1 : (z2TwistSystem beta hbeta).Z 1 = Zminus beta := rfl
  rw [h0, h1, div_self (ne_of_gt (Zplus_pos beta)), ← partitionRatio,
    partitionRatio_eq_tanh]

/-- **Recovery of the base.**  For the concrete `Z2` twist system,
`tyBaseSUN = (1/2)(1 − tanh β) = tyBase β`, i.e. this twist system reproduces the
`Z2` area-law base of `TYAreaLaw.lean`. -/
theorem z2_tyBaseSUN_eq (beta : ℝ) (hbeta : 0 < beta) :
    (z2TwistSystem beta hbeta).tyBaseSUN = (1 / 2) * (1 - Real.tanh beta) := by
  unfold TwistSystem.tyBaseSUN
  rw [z2_pN_eq beta hbeta]; ring

/-- The base equals the `TYAreaLaw` concrete base `tyBase β`. -/
theorem z2_tyBaseSUN_eq_tyBase (beta : ℝ) (hbeta : 0 < beta) :
    (z2TwistSystem beta hbeta).tyBaseSUN = tyBase beta := by
  rw [z2_tyBaseSUN_eq beta hbeta, tyBase, TYAreaLaw.tyBaseOf, partitionRatio_eq_tanh]

/-- **The concrete `Z2` area law with a fully-derived base.**  For `β > 0` and the
reflection-positivity raw bound `hW : |W| ≤ 2·q^r` (the one remaining modeled
input), the Wilson loop obeys the exponential area law at a strictly positive
rate.  All of `Z_nonneg`, `Z_zero_pos`, `Z_le` are PROVED for this system. -/
theorem z2AreaLaw (beta : ℝ) (hbeta : 0 < beta) {r W : ℝ}
    (hW : |W| ≤ 2 * ((z2TwistSystem beta hbeta).tyBaseSUN) ^ r) :
    0 < (z2TwistSystem beta hbeta).tySunTension ∧
      |W| ≤ 2 * Real.exp (-(r * (z2TwistSystem beta hbeta).tySunTension)) :=
  (z2TwistSystem beta hbeta).tyAreaLawSUN_exp_strict (z2_strict_twist beta hbeta) hW

end

end TYTwistSystemZ2
end GateYM
end NullEdge
end Draft
end PhysicsSM
