import Mathlib

/-!

WAVE-3 AUDIT CORRECTION (2026-07-21, job `6ea8b5f0`, witnesses in
`MassLandingsAuditWave3`). The `GammaOdd cap GammaEven = {0}` claim **survives the TRIVIAL
grading**: when `Gamma` is trivial, every map is even and only zero is odd
(`AuditWitnesses.trivial_grading_every_map_even`,
`AuditWitnesses.trivial_grading_odd_iff_zero`), so the intersection statement holds for a
reason unrelated to any physical parity. Reading it as physical non-double-counting is
therefore an over-claim on top of the parity-disjointness caveat already recorded.
SIMPLIFICATION, in our favour: **surjectivity of `Gamma` already suffices**
(`AuditWitnesses.odd_even_intersection_of_surjective`); the fixed-vector condition is not
needed and should be dropped from the hypothesis list.
# Mechanism-matrix cross-consistency (Opus, verified Aristotle 0beb6ad6)

Formal parity consistency facts for the origin-of-mass mechanism matrix:
Gamma-odd cap Gamma-even = {0}, unique odd/even decomposition, a nonzero fermion
(odd) response does not force a gauge/Higgs (even) contribution, and identifying
an odd response with an even one forces both to zero. These are formal response-
class facts; they do not establish physical-row non-double-counting or classify
all shared data. SCOPE CORRECTION (docstring audit `364a29ac`): Gamma-odd cap Gamma-even = {0}
establishes FORMAL parity-class disjointness away from zero. It does NOT by itself
imply injectivity or non-double-counting of the PHYSICAL rows - a witness exhibits
disjoint classes alongside a non-injective row assignment. The physical
non-double-counting claim needs the row-assignment map to be shown injective
separately.

Namespace kept as the prover's OriginOfMassAudit (verbatim
to preserve proofs). Provenance: verified at pin from Aristotle task d242ffbc.
Standard three. Claim grade M, [comp]. -/

open scoped Matrix

namespace OriginOfMassAudit

variable {n : Type} [Fintype n] [DecidableEq n]

/-- A response is chirality-even when it commutes with the grading. -/
def IsEven (Γ A : Matrix n n ℝ) : Prop := Γ * A = A * Γ

/-- A response is chirality-odd when it anticommutes with the grading. -/
def IsOdd (Γ A : Matrix n n ℝ) : Prop := Γ * A = -(A * Γ)

/-- A chirality grading is an involution. -/
def IsGrading (Γ : Matrix n n ℝ) : Prop := Γ * Γ = 1

/-- In this real finite-dimensional model, the Majorana alternative is represented
by a symmetric response matrix. -/
def IsMajoranaSymmetric (A : Matrix n n ℝ) : Prop := A.transpose = A

/-
No operator can be both chirality-odd and chirality-even except zero.
-/
theorem odd_and_even_iff_zero (Γ : Matrix n n ℝ) (hΓ : IsGrading Γ)
    (A : Matrix n n ℝ) : (IsOdd Γ A ∧ IsEven Γ A) ↔ A = 0 := by
  constructor <;> intro h;
  · have h_zero : Γ * A = 0 := by
      have h_zero : Γ * A = -(Γ * A) := by
        grind +locals;
      ext i j; have := congr_fun ( congr_fun h_zero i ) j; norm_num at *; linarith;
    apply_fun fun x => Γ * x at h_zero ; simp_all +decide [ IsGrading ];
    simp_all +decide [ ← mul_assoc ];
  · unfold IsOdd IsEven; aesop;

/-
Set-level version of disjointness of the two response classes.
-/
theorem odd_even_intersection (Γ : Matrix n n ℝ) (hΓ : IsGrading Γ) :
    {A | IsOdd Γ A} ∩ {A | IsEven Γ A} = ({0} : Set (Matrix n n ℝ)) := by
  grind +suggestions

/-
Every response splits uniquely into its odd and even components.  This is the
algebraic direct-sum assertion used by the audit.
-/
theorem existsUnique_odd_even_decomposition (Γ : Matrix n n ℝ) (hΓ : IsGrading Γ)
    (A : Matrix n n ℝ) :
    ∃! p : Matrix n n ℝ × Matrix n n ℝ,
      A = p.1 + p.2 ∧ IsOdd Γ p.1 ∧ IsEven Γ p.2 := by
  refine' ⟨ ⟨ ( 1 / 2 : ℝ ) • ( A - Γ * A * Γ ), ( 1 / 2 : ℝ ) • ( A + Γ * A * Γ ) ⟩, _, _ ⟩;
  · refine' ⟨ _, _, _ ⟩ <;> norm_num [ IsGrading, IsOdd, IsEven ] at *;
    · module;
    · simp_all +decide [ mul_sub, sub_mul, ← mul_assoc ];
      simp_all +decide [ mul_assoc, sub_eq_add_neg ];
    · simp_all +decide [ mul_add, add_mul, mul_assoc ];
      simp_all +decide [ ← mul_assoc ] ; abel_nf;
  · intro y hy; obtain ⟨ hy₁, hy₂, hy₃ ⟩ := hy; simp_all +decide [ IsOdd, IsEven ] ;
    simp_all +decide [ mul_add, add_mul, mul_assoc ];
    simp_all +decide [ IsGrading ];
    ext <;> norm_num <;> ring

/-
A nonzero odd response can occur with zero even response.
-/
omit [DecidableEq n] in
theorem odd_nonzero_does_not_force_even {Γ A : Matrix n n ℝ}
    (hAodd : IsOdd Γ A) (hA : A ≠ 0) :
    ∃ Ao Ae, Ao ≠ 0 ∧ Ae = 0 ∧ IsOdd Γ Ao ∧ IsEven Γ Ae := by
  exact ⟨ A, 0, hA, rfl, hAodd, by unfold IsEven; simp +decide ⟩

/-
A nonzero even response can occur with zero odd response.
-/
omit [DecidableEq n] in
theorem even_nonzero_does_not_force_odd {Γ A : Matrix n n ℝ}
    (hAeven : IsEven Γ A) (hA : A ≠ 0) :
    ∃ Ao Ae, Ao = 0 ∧ Ae ≠ 0 ∧ IsOdd Γ Ao ∧ IsEven Γ Ae := by
  refine' ⟨ 0, A, _, _, _, _ ⟩ <;> simp_all +decide [ IsEven, IsOdd ]

/-- The shared input allowed across response rows: one vacuum vector together
with one involutive chirality grading.  Sharing this input does not identify the
operators returned by the different rows. -/
structure VacuumGrading (n : Type) [Fintype n] [DecidableEq n] where
  vacuum : n → ℝ
  grading : Matrix n n ℝ
  grading_involutive : IsGrading grading

/-- An abstract mechanism matrix: all rows use the same datum, while their
outputs carry the appropriate, distinct response-class constraints. -/
structure MechanismRows (d : VacuumGrading n) where
  fermion : Matrix n n ℝ
  gauge : Matrix n n ℝ
  higgs : Matrix n n ℝ
  neutrino : Matrix n n ℝ
  composite : Matrix n n ℝ
  fermion_odd : IsOdd d.grading fermion
  gauge_even : IsEven d.grading gauge
  gauge_psd : gauge.PosSemidef
  higgs_even : IsEven d.grading higgs
  higgs_psd : higgs.PosSemidef
  neutrino_allowed : IsOdd d.grading neutrino ∨ IsMajoranaSymmetric neutrino
  composite_psd : composite.PosSemidef

/-
If one nevertheless identifies an odd row with an even row, that common
operator is forced to vanish: this precisely rules out nonzero double-counting.
-/
theorem identified_fermion_gauge_is_zero (d : VacuumGrading n)
    (r : MechanismRows d) (hidentify : r.fermion = r.gauge) :
    r.fermion = 0 ∧ r.gauge = 0 := by
  obtain ⟨h_odd, h_even⟩ : IsOdd d.grading r.fermion ∧ IsEven d.grading r.fermion := by
    exact ⟨ r.fermion_odd, hidentify ▸ r.gauge_even ⟩;
  exact odd_and_even_iff_zero _ d.grading_involutive _ |>.1 ⟨ h_odd, h_even ⟩ |> fun h => by aesop;

/-
The same no-double-counting conclusion holds for the Higgs row.
-/
theorem identified_fermion_higgs_is_zero (d : VacuumGrading n)
    (r : MechanismRows d) (hidentify : r.fermion = r.higgs) :
    r.fermion = 0 ∧ r.higgs = 0 := by
  obtain ⟨h_odd, h_even⟩ : IsOdd d.grading r.higgs ∧ IsEven d.grading r.higgs := by
    exact ⟨ hidentify ▸ r.fermion_odd, r.higgs_even ⟩;
  have := odd_and_even_iff_zero d.grading d.grading_involutive r.higgs; aesop;

end OriginOfMassAudit
