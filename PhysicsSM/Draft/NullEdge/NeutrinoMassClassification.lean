import Mathlib

/-!
# Neutrino mass operator classification (Opus, verified Aristotle 1d730886)

A5 classification of the FOUR PRINCIPAL neutrino mass branches: no-minimal-content
(empty V_R => no odd block), hypercharge obstruction to a renormalizable left
Majorana bilinear, right-handed-singlet Dirac turn, Weinberg dim-5 Majorana
(Delta L = 2, non-renormalizable) vs fermion-number-preserving Dirac, and the
one-generation seesaw Schur complement -m_D^2/M_R with a controlled |m_D/M_R|
approximation.

SCOPE CORRECTION (wave-2 self-audit `bb32d90b`, false-shape guard): the theorem
name `complete_four_branch_classification` is the prover's; "complete" must be read
as "the four principal branches above", NOT an exhaustive enumeration.  The MIXED
branch - a simultaneous Dirac + Majorana mass (pseudo-Dirac neutrino,
`(Dirac, leftMajorana, rightMajorana) = (1,1,0)` and its variants) - is NOT covered
by these four rows and is an explicit open row.  Do not cite this as an exhaustive
neutrino-mass classification.

Source anchors: Weinberg 1979 (Neo4j 4B4VURM2), Connes neutrino mixing
hep-th/0610241. Provenance: verified at pin from Aristotle task 9bf76e2f.
Clean-room Mathlib port; standard three axioms. Claim grade M, [comp]. -/

set_option autoImplicit false
set_option relaxedAutoImplicit false

/-!
# Neutrino mass operators: a finite classification

This file separates four operator-level possibilities.  The statements are finite-dimensional
linear algebra plus explicit metadata recording the physical interpretation of the operators.
No claim about dynamics is built into the definitions.
-/

namespace PhysicsSM.Draft.NullEdge.NeutrinoMassClassification

section OddBlock

variable (K : Type*) [Semiring K]
variable (VL VR : Type*) [AddCommMonoid VL] [AddCommMonoid VR]
variable [Module K VL] [Module K VR]

/-- The two off-diagonal pieces of a chirality-odd endomorphism of `VL ⊕ VR`. -/
structure OddBlock where
  rightToLeft : VR →ₗ[K] VL
  leftToRight : VL →ₗ[K] VR

instance : Zero (OddBlock K VL VR) := ⟨⟨0, 0⟩⟩

/-- The endomorphism represented by an odd block. -/
def OddBlock.action (M : OddBlock K VL VR) : (VL × VR) →ₗ[K] (VL × VR) where
  toFun x := (M.rightToLeft x.2, M.leftToRight x.1)
  map_add' _ _ := by simp
  map_smul' _ _ := by simp

/-
With no right-handed slot, every chirality-odd block is zero.
-/
theorem oddBlock_rightSlot_zero (M : OddBlock K VL (Fin 0 → K)) : M = 0 := by
  obtain ⟨rightToLeft, leftToRight⟩ := M;
  congr;
  · exact Subsingleton.eq_zero rightToLeft
  · exact Subsingleton.elim _ _

/-
Kernel version: the associated odd endomorphism on `VL ⊕ 0` vanishes.
-/
theorem oddAction_rightSlot_zero (M : OddBlock K VL (Fin 0 → K)) :
    M.action = 0 := by
  obtain ⟨rightToLeft, leftToRight⟩ := M;
  ext x;
  · convert rightToLeft.map_zero;
  · exact Fin.elim0 ‹_›;
  · exact Fin.elim0 x;
  · exact Fin.elim0 ‹_›

end OddBlock

/-- A concrete nonzero Dirac turn after adjoining one right-handed singlet. -/
def oneGenerationDiracTurn : (Fin 1 → ℂ) →ₗ[ℂ] (Fin 1 → ℂ) := LinearMap.id

theorem oneGenerationDiracTurn_nonzero : oneGenerationDiracTurn ≠ 0 := by
  exact ne_of_apply_ne ( fun f => f ( Pi.single 0 1 ) 0 ) ( by norm_num [ oneGenerationDiracTurn ] )

/-- Gauge invariance of a bilinear requires its two additive charges to sum to zero. -/
def BilinearGaugeInvariant (q₁ q₂ : ℚ) : Prop := q₁ + q₂ = 0

/-
A same-chirality bilinear of two fields of the Standard Model lepton-doublet
hypercharge `-1/2` is not hypercharge invariant.
-/
theorem leftNeutrino_renormalizableMajorana_forbidden :
    ¬ BilinearGaugeInvariant (-1 / 2) (-1 / 2) := by
  exact ne_of_lt ( by norm_num )

inductive MassKind
  | dirac
  | majorana
  deriving DecidableEq, Repr

inductive FermionNumberBehavior
  | preserves
  | violatesBy (units : ℕ)
  deriving DecidableEq, Repr

/-- Operator metadata used to keep the Dirac and Weinberg branches distinct. -/
structure OperatorProfile where
  massKind : MassKind
  massDimension : ℕ
  renormalizable : Bool
  requiresHeavyScale : Bool
  fermionNumber : FermionNumberBehavior
  deriving DecidableEq, Repr

/-- The renormalizable Dirac branch preserves fermion/lepton number. -/
def diracProfile : OperatorProfile where
  massKind := .dirac
  massDimension := 4
  renormalizable := true
  requiresHeavyScale := false
  fermionNumber := .preserves

/-- The Weinberg `(L H)(L H)/Λ` branch: after symmetry breaking its output is
Majorana, it has dimension five, needs the heavy scale `Λ`, and violates lepton
number by two units. -/
def weinbergProfile : OperatorProfile where
  massKind := .majorana
  massDimension := 5
  renormalizable := false
  requiresHeavyScale := true
  fermionNumber := .violatesBy 2

/-
The two branches have different mass kind and fermion-number grading, while
also recording the non-renormalizable cost of the Weinberg branch.
-/
theorem dirac_weinberg_classification :
    diracProfile.massKind = .dirac ∧
    diracProfile.fermionNumber = .preserves ∧
    weinbergProfile.massKind = .majorana ∧
    weinbergProfile.massDimension = 5 ∧
    weinbergProfile.renormalizable = false ∧
    weinbergProfile.requiresHeavyScale = true ∧
    weinbergProfile.fermionNumber = .violatesBy 2 := by
  exact ⟨ rfl, rfl, rfl, rfl, rfl, rfl, rfl ⟩

section Seesaw

/-- Scalar Schur complement, used for the one-generation `2 × 2` block matrix. -/
noncomputable def schurComplement (A B C D : ℝ) : ℝ := A - B * D⁻¹ * C

/-
For `[[0,m_D],[m_D,M_R]]`, the light block obtained by eliminating the
invertible heavy block is exactly `-m_D M_R⁻¹ m_D`.
-/
theorem seesaw_schur_complement (mD MR : ℝ) :
    schurComplement 0 mD mD MR = -(mD ^ 2 / MR) := by
  unfold schurComplement; ring;

/-- The concrete one-generation seesaw mass matrix. -/
def seesawMatrix (mD MR : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![0, mD; mD, MR]

/-- The triangular change of variables that eliminates the heavy component. -/
noncomputable def seesawElimination (mD MR : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![1, 0; -(mD / MR), 1]

/-
Congruence block diagonalization.  This proves, rather than merely defines,
that the light block is the Schur complement.
-/
theorem seesaw_block_diagonalization (mD MR : ℝ) (hMR : MR ≠ 0) :
    Matrix.transpose (seesawElimination mD MR) * seesawMatrix mD MR *
        seesawElimination mD MR =
      !![-(mD ^ 2 / MR), 0; 0, MR] := by
  unfold seesawElimination seesawMatrix
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply, hMR] <;> ring_nf
  norm_num [hMR]

/-- Action of the one-generation mass matrix on `(ν_L,ν_R)`. -/
def seesawAction (mD MR : ℝ) (v : ℝ × ℝ) : ℝ × ℝ :=
  (mD * v.2, mD * v.1 + MR * v.2)

/-- Schur-complement approximate light mass. -/
noncomputable def approximateLightMass (mD MR : ℝ) : ℝ := -(mD ^ 2 / MR)

/-
The standard light vector has an exactly vanishing heavy equation before
multiplication by its approximate eigenvalue.
-/
theorem seesaw_approximate_vector_action (mD MR : ℝ) (hMR : MR ≠ 0) :
    seesawAction mD MR (1, -(mD / MR)) = (approximateLightMass mD MR, 0) := by
  unfold seesawAction approximateLightMass
  ring_nf
  aesop

/-
Controlled small-`m_D/M_R` approximation: if the mixing ratio is at most
`ε`, the residual in the heavy component of the approximate eigenpair is at
most `ε` times the magnitude of the approximate light mass.
-/
theorem seesaw_approximation_controlled (mD MR ε : ℝ) (hMR : MR ≠ 0)
    (hratio : |mD / MR| ≤ ε) :
    |(seesawAction mD MR (1, -(mD / MR))).2 -
        approximateLightMass mD MR * (-(mD / MR))| ≤
      ε * |approximateLightMass mD MR| := by
  unfold seesawAction approximateLightMass
  ring_nf
  norm_num [abs_mul, abs_div, hMR]
  convert mul_le_mul_of_nonneg_right hratio
      (show 0 ≤ mD ^ 2 * |MR|⁻¹ by positivity) using 1
  all_goals ring_nf
  cases abs_cases mD <;> cases abs_cases MR <;> simp +decide [*] <;> ring

end Seesaw

/-
A single proposition collecting the concrete availability/obstruction facts
for minimal content, the singlet Dirac extension, and the Weinberg branch.  The
seesaw identities are stated separately above because they carry parameters.
-/
theorem four_branch_operator_classification :
    (∀ M : OddBlock ℂ (Fin 1 → ℂ) (Fin 0 → ℂ), M.action = 0) ∧
    (¬ BilinearGaugeInvariant (-1 / 2) (-1 / 2)) ∧
    oneGenerationDiracTurn ≠ 0 ∧
    weinbergProfile.massKind = .majorana ∧
    weinbergProfile.massDimension = 5 ∧
    weinbergProfile.renormalizable = false ∧
    weinbergProfile.requiresHeavyScale = true ∧
    weinbergProfile.fermionNumber = .violatesBy 2 := by
  refine' ⟨ _, _, _, rfl, rfl, rfl, rfl, rfl ⟩;
  · intro M;
    convert oddAction_rightSlot_zero ℂ ( Fin 1 → ℂ ) M;
  · exact ne_of_lt ( by norm_num );
  · exact oneGenerationDiracTurn_nonzero

/-
The complete four-branch gate, now including the parameterized seesaw
identities and its controlled small-mixing residual estimate.
-/
theorem complete_four_branch_classification (mD MR ε : ℝ) (hMR : MR ≠ 0)
    (hratio : |mD / MR| ≤ ε) :
    ((∀ M : OddBlock ℂ (Fin 1 → ℂ) (Fin 0 → ℂ), M.action = 0) ∧
      (¬ BilinearGaugeInvariant (-1 / 2) (-1 / 2)) ∧
      oneGenerationDiracTurn ≠ 0 ∧
      weinbergProfile.massKind = .majorana ∧
      weinbergProfile.massDimension = 5 ∧
      weinbergProfile.renormalizable = false ∧
      weinbergProfile.requiresHeavyScale = true ∧
      weinbergProfile.fermionNumber = .violatesBy 2) ∧
    schurComplement 0 mD mD MR = -(mD ^ 2 / MR) ∧
    Matrix.transpose (seesawElimination mD MR) * seesawMatrix mD MR *
        seesawElimination mD MR = !![-(mD ^ 2 / MR), 0; 0, MR] ∧
    |(seesawAction mD MR (1, -(mD / MR))).2 -
        approximateLightMass mD MR * (-(mD / MR))| ≤
      ε * |approximateLightMass mD MR| := by
  exact ⟨four_branch_operator_classification,
    seesaw_schur_complement mD MR,
    seesaw_block_diagonalization mD MR hMR,
    seesaw_approximation_controlled mD MR ε hMR hratio⟩

end PhysicsSM.Draft.NullEdge.NeutrinoMassClassification
