import Mathlib
import PhysicsSM.Draft.NullEdge.FiniteContractedBianchi

/-!
# Curvature convergence interface for null-edge refinements

This module isolates two analytic obligations in the G4 curvature rung.

The holonomy half works in an arbitrary real normed vector space. A refinement
family has a first-order holonomy expansion when its loop area tends to zero,
the area is eventually nonzero, and

```text
holonomy n = base + area n * (target + residual n)
```

with residual tending to zero. Dividing the holonomy displacement by area then
converges to `target`. This is the exact normalization step needed after a
future diamond-holonomy expansion theorem. The expansion itself is an explicit
hypothesis here; it is not derived from graph transport.

The component half considers a sequence of real curvature-derivative tensors.
Componentwise convergence carries first-pair antisymmetry, last-pair
antisymmetry, and the differential Bianchi identity to the limiting tensor.
The existing finite-index contraction theorem then makes the limiting
Einstein combination divergence-free.

The module does not construct refinement maps, identify a diamond area, prove
the required holonomy expansion, justify differentiation of a curvature limit,
or derive the component tensors from null-edge operators. It gives a checked
interface: those geometric inputs are sufficient for curvature and contracted-
Bianchi convergence.
-/

open Filter Topology

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface

open PhysicsSM.Draft.NullEdge.FiniteContractedBianchi

/-! ## Area-normalized holonomy convergence -/

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Area-normalized displacement of a loop holonomy from its zero-area base
value. In a matrix realization, `base` is normally the identity matrix. -/
def normalizedHolonomyCurvature
    (area : ℕ -> ℝ) (holonomy : ℕ -> E) (base : E) (n : ℕ) : E :=
  (area n)⁻¹ • (holonomy n - base)

/-- Data certifying a shrinking-loop first-order holonomy expansion. -/
structure FirstOrderHolonomyLimit
    (area : ℕ -> ℝ) (holonomy : ℕ -> E) (base target : E) where
  /-- Normalized first-order error. -/
  residual : ℕ -> E
  /-- Refined loop areas are eventually nonzero, so normalization is defined. -/
  area_ne_zero : ∀ᶠ n in atTop, area n ≠ 0
  /-- The loops shrink in the refinement limit. -/
  area_tendsto_zero : Tendsto area atTop (nhds 0)
  /-- Exact first-order expansion with the displayed residual. -/
  expansion : ∀ᶠ n in atTop,
    holonomy n = base + area n • (target + residual n)
  /-- The normalized first-order error vanishes. -/
  residual_tendsto_zero : Tendsto residual atTop (nhds 0)

/-- **Area-normalized holonomy convergence.** A shrinking-loop first-order
expansion with vanishing normalized residual converges to its curvature
coefficient. -/
theorem firstOrderHolonomyLimit_converges
    (area : ℕ -> ℝ) (holonomy : ℕ -> E) (base target : E)
    (h : FirstOrderHolonomyLimit area holonomy base target) :
    Tendsto area atTop (nhds 0) ∧
      Tendsto (normalizedHolonomyCurvature area holonomy base)
        atTop (nhds target) := by
  refine ⟨h.area_tendsto_zero, ?_⟩
  have hpoint : ∀ᶠ n in atTop,
      normalizedHolonomyCurvature area holonomy base n =
        target + h.residual n := by
    filter_upwards [h.area_ne_zero, h.expansion] with n hne hexp
    unfold normalizedHolonomyCurvature
    rw [hexp, add_sub_cancel_left]
    simp [hne, smul_smul]
  have hsum :
      Tendsto (fun n => target + h.residual n) atTop (nhds target) := by
    simpa using tendsto_const_nhds.add h.residual_tendsto_zero
  exact hsum.congr' (Filter.EventuallyEq.symm hpoint)

/-- A raw first-order remainder bound yields the corresponding normalized
curvature-error bound. This is the quantitative form a future diamond-holonomy
estimate can discharge directly. -/
theorem normalizedHolonomy_error_le
    (area : ℕ -> ℝ) (holonomy : ℕ -> E) (base target : E)
    (epsilon : ℕ -> ℝ)
    (harea : ∀ᶠ n in atTop, 0 < area n)
    (herror : ∀ᶠ n in atTop,
      ‖holonomy n - base - area n • target‖ ≤ area n * epsilon n) :
    ∀ᶠ n in atTop,
      ‖normalizedHolonomyCurvature area holonomy base n - target‖ ≤
        epsilon n := by
  filter_upwards [harea, herror] with n ha herr
  have hne : area n ≠ 0 := ha.ne'
  have htarget : (area n)⁻¹ • (area n • target) = target := by
    simp [hne, smul_smul]
  have hid :
      normalizedHolonomyCurvature area holonomy base n - target =
        (area n)⁻¹ • (holonomy n - base - area n • target) := by
    unfold normalizedHolonomyCurvature
    calc
      (area n)⁻¹ • (holonomy n - base) - target =
          (area n)⁻¹ • (holonomy n - base) -
            (area n)⁻¹ • (area n • target) := by rw [htarget]
      _ = (area n)⁻¹ • (holonomy n - base - area n • target) :=
        (smul_sub (area n)⁻¹ (holonomy n - base) (area n • target)).symm
  rw [hid, norm_smul, Real.norm_eq_abs, abs_inv, abs_of_pos ha]
  calc
    (area n)⁻¹ * ‖holonomy n - base - area n • target‖
        ≤ (area n)⁻¹ * (area n * epsilon n) :=
      mul_le_mul_of_nonneg_left herr (le_of_lt (inv_pos.mpr ha))
    _ = epsilon n := by field_simp

/-- **Quantitative holonomy convergence interface.** If the raw first-order
remainder is bounded by `area * epsilon` and `epsilon` tends to zero, then the
area-normalized holonomy displacement converges to the target curvature. -/
theorem normalizedHolonomy_tendsto_of_error_bound
    (area : ℕ -> ℝ) (holonomy : ℕ -> E) (base target : E)
    (epsilon : ℕ -> ℝ)
    (harea : ∀ᶠ n in atTop, 0 < area n)
    (herror : ∀ᶠ n in atTop,
      ‖holonomy n - base - area n • target‖ ≤ area n * epsilon n)
    (hepsilon : Tendsto epsilon atTop (nhds 0)) :
    Tendsto (normalizedHolonomyCurvature area holonomy base)
      atTop (nhds target) := by
  rw [tendsto_iff_norm_sub_tendsto_zero]
  exact squeeze_zero' (Filter.Eventually.of_forall (fun n => norm_nonneg _))
    (normalizedHolonomy_error_le area holonomy base target epsilon harea herror)
    hepsilon

/-! ### Explicit shrinking-area witness -/

/-- Positive loop area tending to zero. -/
def witnessArea (n : ℕ) : ℝ := 1 / ((n : ℝ) + 1)

/-- A vanishing normalized first-order error. -/
def witnessResidual (n : ℕ) : ℝ := witnessArea n

/-- A nontrivial scalar holonomy expansion with base one and target three. -/
def witnessHolonomy (n : ℕ) : ℝ :=
  1 + witnessArea n • ((3 : ℝ) + witnessResidual n)

/-- The concrete shrinking-area family satisfies the first-order interface. -/
def witnessFirstOrderHolonomyLimit :
    FirstOrderHolonomyLimit witnessArea witnessHolonomy (1 : ℝ) 3 := by
  refine ⟨witnessResidual, ?_, ?_, ?_, ?_⟩
  · exact Filter.Eventually.of_forall (fun n => by
      unfold witnessArea
      positivity)
  · change Tendsto (fun n : ℕ => (1 : ℝ) / ((n : ℝ) + 1))
      atTop (nhds 0)
    exact tendsto_one_div_add_atTop_nhds_zero_nat
  · exact Filter.Eventually.of_forall (fun n => rfl)
  · change Tendsto (fun n : ℕ => (1 : ℝ) / ((n : ℝ) + 1))
      atTop (nhds 0)
    exact tendsto_one_div_add_atTop_nhds_zero_nat

/-- The normalized curvature of the explicit nonzero target family converges
to three while its loop area tends to zero. -/
theorem normalizedHolonomy_nonzero_limit_witness :
    Tendsto witnessArea atTop (nhds 0) ∧
      Tendsto
        (normalizedHolonomyCurvature witnessArea witnessHolonomy (1 : ℝ))
        atTop (nhds 3) :=
  firstOrderHolonomyLimit_converges witnessArea witnessHolonomy 1 3
    witnessFirstOrderHolonomyLimit

/-! ## Curvature-component identities pass to the limit -/

section ComponentIdentities

variable {I : Type*}

/-- First-pair curvature antisymmetry is closed under componentwise limits. -/
theorem first_antisymmetry_passes_to_limit
    (dR : ℕ -> CurvatureDerivative (I := I) (R := ℝ))
    (dRlim : CurvatureDerivative (I := I) (R := ℝ))
    (hconv : ∀ e a b c d,
      Tendsto (fun n => dR n e a b c d) atTop (nhds (dRlim e a b c d)))
    (hFirst : ∀ n e a b c d, dR n e a b c d = -dR n e b a c d) :
    ∀ e a b c d, dRlim e a b c d = -dRlim e b a c d := by
  intro e a b c d
  have hleft := hconv e a b c d
  have hright := (hconv e b a c d).neg
  have hseq :
      (fun n => dR n e a b c d) = (fun n => -dR n e b a c d) := by
    funext n
    exact hFirst n e a b c d
  rw [hseq] at hleft
  exact tendsto_nhds_unique hleft hright

/-- Last-pair curvature antisymmetry is closed under componentwise limits. -/
theorem last_antisymmetry_passes_to_limit
    (dR : ℕ -> CurvatureDerivative (I := I) (R := ℝ))
    (dRlim : CurvatureDerivative (I := I) (R := ℝ))
    (hconv : ∀ e a b c d,
      Tendsto (fun n => dR n e a b c d) atTop (nhds (dRlim e a b c d)))
    (hLast : ∀ n e a b c d, dR n e a b c d = -dR n e a b d c) :
    ∀ e a b c d, dRlim e a b c d = -dRlim e a b d c := by
  intro e a b c d
  have hleft := hconv e a b c d
  have hright := (hconv e a b d c).neg
  have hseq :
      (fun n => dR n e a b c d) = (fun n => -dR n e a b d c) := by
    funext n
    exact hLast n e a b c d
  rw [hseq] at hleft
  exact tendsto_nhds_unique hleft hright

/-- The uncontracted differential Bianchi identity is closed under
componentwise limits. -/
theorem differential_bianchi_passes_to_limit
    (dR : ℕ -> CurvatureDerivative (I := I) (R := ℝ))
    (dRlim : CurvatureDerivative (I := I) (R := ℝ))
    (hconv : ∀ e a b c d,
      Tendsto (fun n => dR n e a b c d) atTop (nhds (dRlim e a b c d)))
    (hBianchi : ∀ n e a b c d,
      dR n e a b c d + dR n c a b d e + dR n d a b e c = 0) :
    ∀ e a b c d,
      dRlim e a b c d + dRlim c a b d e + dRlim d a b e c = 0 := by
  intro e a b c d
  have hsum :
      Tendsto
        (fun n => dR n e a b c d + dR n c a b d e + dR n d a b e c)
        atTop
        (nhds (dRlim e a b c d + dRlim c a b d e + dRlim d a b e c)) :=
    ((hconv e a b c d).add (hconv c a b d e)).add (hconv d a b e c)
  have hseq :
      (fun n => dR n e a b c d + dR n c a b d e + dR n d a b e c) =
        (fun _ => 0) := by
    funext n
    exact hBianchi n e a b c d
  rw [hseq] at hsum
  exact tendsto_nhds_unique hsum tendsto_const_nhds

end ComponentIdentities

section ContractedLimit

variable {I : Type*} [Fintype I] [DecidableEq I]

/-- **Contracted-Bianchi limit interface.** Componentwise convergence of
curvature derivatives, together with the discrete curvature symmetries and
differential Bianchi identity at every refinement, gives a divergence-free
Einstein combination for the limiting tensor. -/
theorem limiting_divEinstein_eq_zero
    (weight : I -> ℝ)
    (dR : ℕ -> CurvatureDerivative (I := I) (R := ℝ))
    (dRlim : CurvatureDerivative (I := I) (R := ℝ))
    (hWeight : ∀ i, weight i * weight i = 1)
    (hconv : ∀ e a b c d,
      Tendsto (fun n => dR n e a b c d) atTop (nhds (dRlim e a b c d)))
    (hFirst : ∀ n e a b c d, dR n e a b c d = -dR n e b a c d)
    (hLast : ∀ n e a b c d, dR n e a b c d = -dR n e a b d c)
    (hBianchi : ∀ n e a b c d,
      dR n e a b c d + dR n c a b d e + dR n d a b e c = 0)
    (d : I) :
    divEinstein weight dRlim d = 0 := by
  apply divEinstein_eq_zero weight dRlim hWeight
  · exact first_antisymmetry_passes_to_limit dR dRlim hconv hFirst
  · exact last_antisymmetry_passes_to_limit dR dRlim hconv hLast
  · exact differential_bianchi_passes_to_limit dR dRlim hconv hBianchi

end ContractedLimit

/-! ### Nonzero component-limit witness -/

/-- Real cast of the existing nonzero rational curvature-derivative witness. -/
def witnessDRReal : CurvatureDerivative (I := Fin 2) (R := ℝ) :=
  fun e a b c d =>
    (PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.witnessDR e a b c d : ℝ)

/-- Real cast of the Lorentzian `(+,-)` witness weights. -/
def witnessWeightReal : Fin 2 -> ℝ :=
  fun i =>
    (PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.witnessWeight i : ℝ)

theorem witnessDRReal_first_antisymm (e a b c d : Fin 2) :
    witnessDRReal e a b c d = -witnessDRReal e b a c d := by
  unfold witnessDRReal
  exact_mod_cast
    PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.witnessDR_first_antisymm
      e a b c d

theorem witnessDRReal_last_antisymm (e a b c d : Fin 2) :
    witnessDRReal e a b c d = -witnessDRReal e a b d c := by
  unfold witnessDRReal
  exact_mod_cast
    PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.witnessDR_last_antisymm
      e a b c d

theorem witnessDRReal_bianchi (e a b c d : Fin 2) :
    witnessDRReal e a b c d + witnessDRReal c a b d e +
      witnessDRReal d a b e c = 0 := by
  unfold witnessDRReal
  exact_mod_cast
    PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.witnessDR_bianchi
      e a b c d

/-- A nonzero constant refinement family exercises the limiting contraction
theorem with a genuine Lorentzian component model. -/
theorem curvatureDerivativeLimit_nonzero_witness :
    witnessDRReal 0 0 1 0 1 = 1 ∧
      divEinstein witnessWeightReal witnessDRReal 0 = 0 := by
  refine ⟨?_, ?_⟩
  · norm_num [witnessDRReal,
      PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.witnessDR,
      PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.witnessQ,
      PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.witnessArea]
  · apply limiting_divEinstein_eq_zero witnessWeightReal
      (fun _ => witnessDRReal) witnessDRReal
    · intro i
      fin_cases i <;> norm_num [witnessWeightReal,
        PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.witnessWeight]
    · intro e a b c d
      exact tendsto_const_nhds
    · intro n e a b c d
      exact witnessDRReal_first_antisymm e a b c d
    · intro n e a b c d
      exact witnessDRReal_last_antisymm e a b c d
    · intro n e a b c d
      exact witnessDRReal_bianchi e a b c d

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.firstOrderHolonomyLimit_converges' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.firstOrderHolonomyLimit_converges

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.normalizedHolonomy_nonzero_limit_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.normalizedHolonomy_nonzero_limit_witness

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.normalizedHolonomy_error_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.normalizedHolonomy_error_le

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.normalizedHolonomy_tendsto_of_error_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.normalizedHolonomy_tendsto_of_error_bound

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.differential_bianchi_passes_to_limit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.differential_bianchi_passes_to_limit

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.limiting_divEinstein_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.limiting_divEinstein_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.curvatureDerivativeLimit_nonzero_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.curvatureDerivativeLimit_nonzero_witness

end PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface
