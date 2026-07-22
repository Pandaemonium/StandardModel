import Mathlib

/-!
# Wave-3 adversarial self-audit of the origin-of-mass landings: five formal witnesses

Third adversarial audit round aimed at my own (Opus) mass-lane landings, this time
returning **kernel-checked counterexamples** rather than prose verdicts. Every finding
below is a correction to a SENTENCE, not to a theorem; no landed statement was unsound.

## The five findings, each with its witness

1. **Yukawa uniqueness** (`weak_phase_does_not_give_uniqueness`,
   `phase_and_magnitude_unique`). Fixing a PHASE alone does not give uniqueness, and
   requiring nonzero does not either, because the MAGNITUDE remains free. Fixed magnitude
   *plus* phase repairs it. Separately: a genuine `finrank = 1` space cannot be `{0}`, but a
   weakened `finrank <= 1` claim would permit vacuity - so the strict form is load-bearing.
2. **Mechanism matrix** (`trivial_grading_every_map_even`, `trivial_grading_odd_iff_zero`,
   `odd_even_intersection_of_surjective`). The `GammaOdd cap GammaEven = {0}` claim
   **survives the trivial grading**: when `Gamma` is trivial every map is even and only zero
   is odd, so the intersection statement is true for a reason unrelated to physics. What
   actually carries it is **surjectivity of `Gamma`**, which already suffices - the
   fixed-vector condition is not needed. This both weakens the physical reading and
   simplifies the hypothesis.
3. **Resolvent response** (`same_zero_zero_entry_different_full_response`). A formula for
   the `(0,0)` ENTRY does not determine the full response matrix, and therefore does not
   determine a two-point observable. Witness: two unequal matrices sharing the displayed
   entry. Any sentence reading the entry formula as "the response" is an over-claim.
4. **Uniform gap** (`empty_parameter_uniform_margin`, `uniform_margin_has_pointwise_content`).
   The `[Nonempty K]` instance is **semantically load-bearing**, not boilerplate: over
   `Empty`, every gap function vacuously admits a positive uniform lower bound. A uniform
   margin only has content once the parameter space is inhabited.
5. **Seesaw** (`nonsymmetricMR_inverse`,
   `general_invertible_MR_can_give_nonsymmetric_light_block`,
   `light_block_symmetric_of_inverse_symmetric`). General invertibility of `M_R` suffices
   for the Schur-complement formula under two-sided elimination, but **not** for a
   symmetry-preserving Majorana interpretation: the explicit invertible nonsymmetric
   `M_R = [[1,1],[0,1]]` produces a nonsymmetric light block. Symmetry of the INVERSE is
   what repairs the shape, and it is what a Majorana reading requires.

## Why this module exists

The pattern across three audit rounds is now unambiguous: **the theorem statements have not
failed, and the prose around them fails repeatedly.** Keeping the counterexamples in the
kernel - rather than only in an audit memo - means a future rewrite that reintroduces any
of these five over-claims contradicts a compiled witness in the same tree.

Provenance: Aristotle project `6ea8b5f0-5033-46a9-a015-8629f0bf0073`, task
`9d9711db-e2e8-4751-95f2-fafe68ca4b22` (a 22-hour run), verified verbatim at the pinned
toolchain. The prover's namespace `AuditWitnesses` is kept verbatim. The detailed verdicts
live in the job's `AUDIT.md`. Claim grade `M`, `[orig]` for the audit witnesses.
-/

open Matrix

/-! # Wave-3 semantic audit witnesses

Small Mathlib-only models used by `AUDIT.md`.  They test the logical shapes of the
claims without importing any external landing.
-/

namespace AuditWitnesses

section Yukawa

/-- A one-dimensional coupling space with a weak phase convention (`0 ≤ x`). -/
def WeakPhaseFixed (x : ℝ) : Prop := 0 ≤ x

/-
Phase fixing alone includes both the zero coupling and a nonzero coupling.
-/
theorem weak_phase_does_not_give_uniqueness :
    WeakPhaseFixed 0 ∧ WeakPhaseFixed 1 ∧ (0 : ℝ) ≠ 1 := by
  exact ⟨ by exact le_rfl, by exact zero_le_one, by norm_num ⟩

/-
A fixed magnitude repairs the real one-dimensional model.
-/
theorem phase_and_magnitude_unique {x y r : ℝ}
    (hx : WeakPhaseFixed x) (hy : WeakPhaseFixed y)
    (hxr : |x| = r) (hyr : |y| = r) : x = y := by
  linarith [ abs_of_nonneg hx, abs_of_nonneg hy ]

end Yukawa

section Mechanism

variable {V : Type*} [AddCommGroup V] [Module ℚ V]

/-- `M` preserves the grading. -/
def GammaEven (Γ M : V →ₗ[ℚ] V) : Prop := Γ.comp M = M.comp Γ

/-- `M` reverses the grading. -/
def GammaOdd (Γ M : V →ₗ[ℚ] V) : Prop := Γ.comp M = -(M.comp Γ)

/-
For the degenerate grading `Γ = 1`, every map is even.
-/
theorem trivial_grading_every_map_even (M : V →ₗ[ℚ] V) :
    GammaEven LinearMap.id M := by
  ext
  simp

/-
For the degenerate grading `Γ = 1`, an odd map is zero.
-/
theorem trivial_grading_odd_iff_zero (M : V →ₗ[ℚ] V) :
    GammaOdd LinearMap.id M ↔ M = 0 := by
  constructor;
  · intro h
    ext x
    simp [GammaOdd] at h;
    replace h := congr_arg ( fun f => f x ) h; norm_num at h;
    rw [ eq_neg_iff_add_eq_zero ] at h;
    simpa [ ← two_smul ℚ ] using h;
  · unfold GammaOdd; aesop;

/-
Surjectivity of the grading map suffices; an involution and a
`no-fixed-vector` assumption are stronger than necessary.
-/
theorem odd_even_intersection_of_surjective (Γ M : V →ₗ[ℚ] V)
    (hΓ : Function.Surjective Γ) (he : GammaEven Γ M) (ho : GammaOdd Γ M) :
    M = 0 := by
  ext x;
  obtain ⟨ y, hy ⟩ := hΓ x;
  replace he := congr_arg (fun f => f y) he
  replace ho := congr_arg (fun f => f y) ho
  simp_all
  rw [ neg_eq_iff_add_eq_zero ] at he;
  simpa [ ← two_smul ℚ ] using he

end Mechanism

section Resolvent

/-- A two-by-two response with prescribed `(0,0)` entry and arbitrary `(1,1)` entry. -/
def responseWithTail (head tail : ℚ) : Matrix (Fin 2) (Fin 2) ℚ :=
  !![head, 0; 0, tail]

/-
Knowing the displayed pole in one matrix entry does not determine the full response.
-/
theorem same_zero_zero_entry_different_full_response (z : ℚ) :
    (responseWithTail (z + 1)⁻¹ 0) 0 0 = (z + 1)⁻¹ ∧
    (responseWithTail (z + 1)⁻¹ 1) 0 0 = (z + 1)⁻¹ ∧
    responseWithTail (z + 1)⁻¹ 0 ≠ responseWithTail (z + 1)⁻¹ 1 := by
  unfold responseWithTail; aesop;

end Resolvent

section UniformGap

/-
On an empty parameter space, a positive uniform margin exists for every gap
function, solely because the pointwise condition has no instances.
-/
theorem empty_parameter_uniform_margin (gap : Empty → ℝ) :
    ∃ δ : ℝ, 0 < δ ∧ ∀ k, δ ≤ gap k := by
  exact ⟨ 1, by norm_num, by rintro ⟨ ⟩ ⟩

/-
With a nonempty parameter space, a positive uniform lower bound has an actual
pointwise witness.
-/
theorem uniform_margin_has_pointwise_content {K : Type*} [Nonempty K]
    (gap : K → ℝ) (δ : ℝ) (hδ : 0 < δ) (hgap : ∀ k, δ ≤ gap k) :
    ∃ k, 0 < gap k := by
  exact ⟨ Classical.arbitrary K, lt_of_lt_of_le hδ ( hgap _ ) ⟩

end UniformGap

section Seesaw

abbrev M2 := Matrix (Fin 2) (Fin 2) ℚ

def nonsymmetricMR : M2 := !![1, 1; 0, 1]

def nonsymmetricMRInv : M2 := !![1, -1; 0, 1]

/-
A concrete nonsymmetric right-handed block is nevertheless invertible.
-/
theorem nonsymmetricMR_inverse :
    nonsymmetricMR * nonsymmetricMRInv = 1 ∧
    nonsymmetricMRInv * nonsymmetricMR = 1 := by
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;>
    norm_num [nonsymmetricMR, nonsymmetricMRInv, Matrix.mul_apply, Fin.sum_univ_two]

/-
With `mD = 1`, the advertised light block is nonsymmetric when `MR` is
nonsymmetric.  Thus it is not automatically a symmetric Majorana mass matrix.
-/
theorem general_invertible_MR_can_give_nonsymmetric_light_block :
    (-nonsymmetricMRInv)ᵀ ≠ -nonsymmetricMRInv := by
  intro h
  have h01 := congrFun (congrFun h (0 : Fin 2)) (1 : Fin 2)
  norm_num [nonsymmetricMRInv] at h01

/-
Symmetry of `MR` (expressed here directly for its inverse) repairs the shape:
the Schur-complement light block is symmetric.
-/
theorem light_block_symmetric_of_inverse_symmetric
    (mD MRinv : M2) (h : MRinvᵀ = MRinv) :
    (-mD * MRinv * mDᵀ)ᵀ = -mD * MRinv * mDᵀ := by
  simp_all
  rw [Matrix.mul_assoc]

end Seesaw

end AuditWitnesses
/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'AuditWitnesses.weak_phase_does_not_give_uniqueness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms AuditWitnesses.weak_phase_does_not_give_uniqueness
/-- info: 'AuditWitnesses.trivial_grading_odd_iff_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms AuditWitnesses.trivial_grading_odd_iff_zero
/-- info: 'AuditWitnesses.odd_even_intersection_of_surjective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms AuditWitnesses.odd_even_intersection_of_surjective
/-- info: 'AuditWitnesses.same_zero_zero_entry_different_full_response' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms AuditWitnesses.same_zero_zero_entry_different_full_response
/-- info: 'AuditWitnesses.empty_parameter_uniform_margin' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms AuditWitnesses.empty_parameter_uniform_margin
/-- info: 'AuditWitnesses.general_invertible_MR_can_give_nonsymmetric_light_block' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms AuditWitnesses.general_invertible_MR_can_give_nonsymmetric_light_block
/-- info: 'AuditWitnesses.light_block_symmetric_of_inverse_symmetric' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms AuditWitnesses.light_block_symmetric_of_inverse_symmetric
