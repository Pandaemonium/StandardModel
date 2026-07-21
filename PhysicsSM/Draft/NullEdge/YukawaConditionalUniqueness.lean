import Mathlib

/-!
# Yukawa conditional uniqueness (Opus, verified Aristotle bbe67efa)

Positive complement to `PlueckerYukawaModuli` (the A2 no-go). One-dimensional
intertwiner (Schur mult sum = 1) + leading-coordinate phase fixing => unique
coupling; a multiplicity block gives a continuous norm-1/det-0 family (no
normalization selects it). SM pin = Higgs-vev contraction with a 1-dim
invariant-tensor space; field-redefinition group U(n)_L x U(n)_R1 x U(n)_R2;
three-generation counts kernel-checked: Dirac 6+3+1=10, +2 Majorana phases=12.
Provenance: verified at pin from Aristotle task ac6c5e63. Standard three. -/

open scoped BigOperators

set_option autoImplicit false
set_option maxHeartbeats 8000000

namespace PhysicsSM.Draft.NullEdge.YukawaConditionalUniqueness

/-!
This file gives a representation-independent formulation of the positive A2 gate.
The complex vector space `W` below is intended to be the intertwiner space
`Hom_G(V_R,V_L)`.  Thus the first two results apply after the usual Schur
calculation has identified its complex dimension.
-/

section OneDimensional

variable {W : Type*} [AddCommGroup W] [Module ℂ W]

/-
In a one-dimensional complex intertwiner space, every `y` is a unique
complex scalar multiple of a fixed nonzero `x`.
-/
theorem scalar_multiple_of_finrank_one
    (hfin : Module.finrank ℂ W = 1) {x y : W} (hx : x ≠ 0) :
    ∃! c : ℂ, y = c • x := by
  have h_unique : ∀ y : W, ∃ c : ℂ, y = c • x := by
    rw [ finrank_eq_one_iff_of_nonzero x hx ] at hfin;
    exact fun y => by have := Submodule.mem_span_singleton.mp ( hfin.symm ▸ Submodule.mem_top : y ∈ ℂ ∙ x ) ; tauto;
  obtain ⟨ c, rfl ⟩ := h_unique y; use c; simp +decide [ hx ] ;

/-
An exact normalization convention which removes both modulus and phase.
Here `lead` models a chosen leading matrix entry and `r > 0` is the prescribed
positive real value.  Requiring `lead Y = r` fixes its modulus and its phase at
once.
-/
theorem eq_of_finrank_one_of_fixed_positive_leading_entry
    (hfin : Module.finrank ℂ W = 1) (lead : W →ₗ[ℂ] ℂ) {r : ℝ} (hr : 0 < r)
    {x y : W} (hx : lead x = (r : ℂ)) (hy : lead y = (r : ℂ)) :
    x = y := by
  obtain ⟨c, hc⟩ : ∃ c : ℂ, y = c • x := by
    apply scalar_multiple_of_finrank_one hfin (by
    intro h; simp_all +decide;
    exact absurd hx ( by norm_cast; positivity )) |>.exists;
  simp_all +decide [ Complex.ext_iff, ne_of_gt hr ];
  rw [ show c = 1 by simpa [ Complex.ext_iff ] using hy ] ; simp +decide

/-- The Schur/multiplicity formulation: once the standard decomposition gives
`finrank Hom_G(V_R,V_L) = ∑ λ, mL λ * mR λ`, a multiplicity sum of one implies
the scalar-multiple classification. -/
theorem scalar_multiple_of_multiplicity_sum_one
    {Λ : Type*} [Fintype Λ] (mL mR : Λ → ℕ)
    (hdim : Module.finrank ℂ W = ∑ a, mL a * mR a)
    (hsum : ∑ a, mL a * mR a = 1)
    {x y : W} (hx : x ≠ 0) : ∃! c : ℂ, y = c • x := by
  apply scalar_multiple_of_finrank_one (hdim.trans hsum) hx

end OneDimensional

section Moduli

abbrev Two := Fin 2
abbrev Coupling := Matrix Two Two ℂ

/-- Squared Frobenius norm: the modulus datum used for this explicit family. -/
def plueckerModulusSq (A : Coupling) : ℝ :=
  ∑ i, ∑ j, Complex.normSq (A i j)

/-- A rational parametrization of rank-one Hermitian projectors.  It is defined
for every real parameter and has no singularity because `1 + t^2 > 0`. -/
noncomputable def projectorFamily (t : ℝ) : Coupling :=
  !![((1 / (1 + t ^ 2) : ℝ) : ℂ), ((t / (1 + t ^ 2) : ℝ) : ℂ);
     ((t / (1 + t ^ 2) : ℝ) : ℂ), ((t ^ 2 / (1 + t ^ 2) : ℝ) : ℂ)]

/-
Every member of the family has the same modulus datum.
-/
theorem projectorFamily_modulus (t : ℝ) :
    plueckerModulusSq (projectorFamily t) = 1 := by
  unfold plueckerModulusSq projectorFamily
  norm_num [Complex.normSq]
  ring
  norm_cast
  norm_num
  ring
  field_simp
  ring

/-
Every member has the same determinant (zero).
-/
theorem projectorFamily_det (t : ℝ) :
    (projectorFamily t).det = 0 := by
  unfold projectorFamily
  norm_num
  ring

/-
The family really has one real parameter: distinct parameters give distinct
couplings.
-/
theorem projectorFamily_injective : Function.Injective projectorFamily := by
  intro x y hxy
  simp_all +decide [projectorFamily]
  rw [div_eq_div_iff] at hxy <;> norm_cast at * <;>
    nlinarith [mul_self_nonneg (x - y)]

/-
The displayed moduli are therefore insufficient to select a coupling even
after the common unit normalization and determinant-zero condition are imposed.
-/
theorem normalized_moduli_not_unique :
    ∃ A B : Coupling,
      A ≠ B ∧ plueckerModulusSq A = 1 ∧ plueckerModulusSq B = 1 ∧
        A.det = 0 ∧ B.det = 0 := by
  refine' ⟨ _, _, _, projectorFamily_modulus 0, projectorFamily_modulus 1, projectorFamily_det 0, projectorFamily_det 1 ⟩;
  exact projectorFamily_injective.ne ( by norm_num )

/-
The moduli family varies continuously.
-/
theorem continuous_projectorFamily : Continuous projectorFamily := by
  refine' continuous_matrix _;
  intro i j;
  fin_cases i <;> fin_cases j <;> norm_num [ projectorFamily ];
  · exact Continuous.inv₀ ( by continuity ) fun x => by norm_cast; positivity;
  · exact Continuous.div ( Complex.continuous_ofReal ) ( by continuity ) fun x => by norm_cast; positivity;
  · exact Continuous.div ( Complex.continuous_ofReal ) ( by continuity ) fun x => by norm_cast; positivity;
  · exact Continuous.div ( by continuity ) ( by continuity ) fun x => by norm_cast; positivity

/-- A bundled statement of genuine moduli: a continuous injective real family
survives the simultaneous unit-modulus and determinant-zero normalization. -/
theorem continuous_normalized_moduli :
    ∃ f : ℝ → Coupling, Continuous f ∧ Function.Injective f ∧
      ∀ t, plueckerModulusSq (f t) = 1 ∧ (f t).det = 0 := by
  refine ⟨projectorFamily, continuous_projectorFamily,
    projectorFamily_injective, ?_⟩
  intro t
  exact ⟨projectorFamily_modulus t, projectorFamily_det t⟩

/-- The trivial representation of an arbitrary group on a vector space. -/
def trivialAction (G V : Type*) : G → V → V := fun _ v => v

/-- With trivial group actions every matrix is an admissible intertwiner, so the
continuous family above is an honest family of admissible Yukawa couplings for
any group. -/
theorem projectorFamily_trivially_equivariant
    {G : Type*} (g : G) (t : ℝ) (v : Two → ℂ) :
    (projectorFamily t).mulVec (trivialAction G (Two → ℂ) g v) =
      trivialAction G (Two → ℂ) g ((projectorFamily t).mulVec v) := by
  rfl

/-- A multiplicity block of size at least two forces the total Schur
multiplicity count to be at least two. -/
theorem multiplicity_block_forces_nonunique_dimension
    {Λ : Type*} [Fintype Λ] (mL mR : Λ → ℕ) (a : Λ)
    (ha : 2 ≤ mL a * mR a) :
    2 ≤ ∑ b, mL b * mR b := by
  exact ha.trans (Finset.single_le_sum (fun b _ => Nat.zero_le (mL b * mR b))
    (Finset.mem_univ a))

end Moduli

section StandardModelPin

/-- For two Dirac Yukawa matrices sharing one left-handed multiplet, basis
changes form `U(n)_L × U(n)_{R₁} × U(n)_{R₂}`.  The common central `U(1)` acts
trivially, and quotienting by these field redefinitions leaves precisely the
masses and CKM/Dirac-PMNS mixing data counted below. -/
abbrev TwoSectorFieldRedefinitionGroup (n : Type*) [Fintype n] [DecidableEq n] :=
  Matrix.unitaryGroup n ℂ × Matrix.unitaryGroup n ℂ × Matrix.unitaryGroup n ℂ

/-- Formal data expressing the additional physical pin: the observed map is a
Higgs-vev contraction of one invariant tensor, rather than an arbitrary point
of the bare fermion intertwiner space.  `invariantLine` records the hypothesis
that the space of allowed invariant tensors is one-dimensional. -/
structure HiggsPinnedCoupling
    (H VR VL Inv : Type*)
    [AddCommGroup H] [Module ℂ H]
    [AddCommGroup VR] [Module ℂ VR]
    [AddCommGroup VL] [Module ℂ VL]
    [AddCommGroup Inv] [Module ℂ Inv] where
  invariantLine : Module.finrank ℂ Inv = 1
  contraction : Inv →ₗ[ℂ] H →ₗ[ℂ] VR →ₗ[ℂ] VL
  invariantTensor : Inv
  vev : H
  coupling : VR →ₗ[ℂ] VL
  coupling_eq : coupling = (contraction invariantTensor) vev

/-- For two `n`-generation Dirac Yukawa sectors, the standard field-redefinition
quotient leaves `2n` masses, `n(n-1)/2` mixing angles, and
`(n-1)(n-2)/2` CP phases. -/
def diracMassCount (n : ℕ) : ℕ := 2 * n

def diracMixingAngleCount (n : ℕ) : ℕ := n * (n - 1) / 2

def diracCPPhaseCount (n : ℕ) : ℕ := (n - 1) * (n - 2) / 2

def diracPhysicalParameterCount (n : ℕ) : ℕ :=
  diracMassCount n + diracMixingAngleCount n + diracCPPhaseCount n

/-- Three generations give six masses, three angles, one phase: ten physical
parameters in either a CKM-type or Dirac-PMNS-type two-sector system. -/
theorem three_generation_dirac_parameter_count :
    diracMassCount 3 = 6 ∧
    diracMixingAngleCount 3 = 3 ∧
    diracCPPhaseCount 3 = 1 ∧
    diracPhysicalParameterCount 3 = 10 := by
  norm_num [diracMassCount, diracMixingAngleCount, diracCPPhaseCount,
    diracPhysicalParameterCount]

/-- If the three neutrinos are Majorana, two further Majorana phases survive,
so the corresponding three-generation count is twelve. -/
def majoranaExtraPhaseCount (n : ℕ) : ℕ := n - 1

def majoranaPhysicalParameterCount (n : ℕ) : ℕ :=
  diracPhysicalParameterCount n + majoranaExtraPhaseCount n

theorem three_generation_majorana_parameter_count :
    majoranaExtraPhaseCount 3 = 2 ∧
    majoranaPhysicalParameterCount 3 = 12 := by
  norm_num [majoranaExtraPhaseCount, majoranaPhysicalParameterCount,
    diracPhysicalParameterCount, diracMassCount, diracMixingAngleCount,
    diracCPPhaseCount]

end StandardModelPin

end PhysicsSM.Draft.NullEdge.YukawaConditionalUniqueness
