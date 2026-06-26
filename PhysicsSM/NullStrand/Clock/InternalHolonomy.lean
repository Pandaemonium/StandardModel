import Mathlib
import PhysicsSM.NullStrand.Conventions

/-!
# NullStrand.Clock.InternalHolonomy

Finite ordered-products and unitarity lemmas for internal holonomy.

This module provides a small Lean kernel-checked version of the stage 11
"internal holonomy" goals in `Sources/NullStrand_Lean_Roadmap.md`.
-/

noncomputable section

namespace PhysicsSM.NullStrand.Clock

open Matrix Complex
open scoped BigOperators

/-- Noncommutative ordered product of finite matrix factors, in list order. -/
def internalHolonomy {d : Type*} [Fintype d] [DecidableEq d]
    (segments : List (Matrix d d ℂ)) : Matrix d d ℂ :=
  segments.prod

/-- Single holonomy step from a real duration and Hermitian generator. -/
def internalSegment {d : Type*} [Fintype d] [DecidableEq d] (Δs : ℝ)
    (M : Matrix d d ℂ) : Matrix d d ℂ :=
  NormedSpace.exp (-(Complex.I : ℂ) • (Complex.ofReal Δs • M))

/-- HOL-002: Unitary one-step holonomy for Hermitian generator. -/
theorem internalSegment_unitary_of_hermitian {d : Type*} [Fintype d] [DecidableEq d]
    (Δs : ℝ) (M : Matrix d d ℂ) (hHermitian : M.IsHermitian) :
    internalSegment Δs M ∈ Matrix.unitaryGroup d ℂ := by
  apply Matrix.mem_unitaryGroup_iff.mpr
  have hstar : ∀ A : Matrix d d ℂ, star (NormedSpace.exp A) = NormedSpace.exp (star A) := by
    intro A
    simp [Matrix.star_eq_conjTranspose, Matrix.exp_conjTranspose]
  have h_exp_unitary : ∀ A : Matrix d d ℂ,
      star A = -A → NormedSpace.exp A * star (NormedSpace.exp A) = 1 := by
    intro A hA
    rw [hstar, hA, ← Matrix.exp_add_of_commute] <;> norm_num [mul_comm]
  refine h_exp_unitary _ ?_
  simp [hHermitian.eq, Matrix.star_eq_conjTranspose]

/-- Ordered holonomy for a finite `Fin`-indexed path. -/
def internalHolonomyPath {N : ℕ} {d : Type*} [Fintype d] [DecidableEq d]
    (Δs : Fin (N + 1) → ℝ) (M : Fin (N + 1) → Matrix d d ℂ) : Matrix d d ℂ :=
  internalHolonomy (List.ofFn fun i => internalSegment (Δs i) (M i))

/-- Internal holonomy is multiplicative under concatenation of ordered products. -/
theorem internalHolonomy_concat {d : Type*} [Fintype d] [DecidableEq d]
    (left right : List (Matrix d d ℂ)) :
    internalHolonomy (left ++ right) = internalHolonomy left * internalHolonomy right := by
  simp [internalHolonomy, List.prod_append]

/-- If each step is `exp (-I * Δs * H)` with Hermitian `H`, the finite holonomy is unitary. -/
theorem internalHolonomy_unitary_of_hermitian {N : ℕ} {d : Type*}
    [Fintype d] [DecidableEq d] (Δs : Fin (N + 1) → ℝ)
    (M : Fin (N + 1) → Matrix d d ℂ)
    (hHermitian : ∀ i : Fin (N + 1), (M i).IsHermitian) :
    internalHolonomyPath Δs M ∈ Matrix.unitaryGroup d ℂ := by
  have hStep :
      ∀ i : Fin (N + 1), internalSegment (Δs i) (M i) ∈ Matrix.unitaryGroup d ℂ := by
    intro i
    exact internalSegment_unitary_of_hermitian (d := d) (Δs i) (M i) (hHermitian i)
  have hList :
      ∀ x ∈ List.ofFn (fun i : Fin (N + 1) => internalSegment (Δs i) (M i)),
        x ∈ Matrix.unitaryGroup d ℂ := by
    intro x hx
    obtain ⟨i, rfl⟩ := List.mem_ofFn.mp hx
    exact hStep i
  have hprod := list_prod_mem (S := Matrix.unitaryGroup d ℂ) hList
  simpa only [internalHolonomyPath, internalHolonomy] using hprod

/-- Conjugating each segment by a fixed unitary gives a conjugated holonomy. -/
theorem internalHolonomy_gaugeCovariant {d : Type*} [Fintype d] [DecidableEq d]
    (U : Matrix.unitaryGroup d ℂ) (segments : List (Matrix d d ℂ)) :
    internalHolonomy (segments.map (fun M => (U : Matrix d d ℂ) * M * ((U : Matrix d d ℂ))⁻¹)) =
      (U : Matrix d d ℂ) * internalHolonomy segments * ((U : Matrix d d ℂ))⁻¹ := by
  have hUinv : ((U : Matrix d d ℂ) : Matrix d d ℂ)⁻¹ * ((U : Matrix d d ℂ) : Matrix d d ℂ) = 1 := by
    have hstar : star ((U : Matrix d d ℂ) : Matrix d d ℂ) * ((U : Matrix d d ℂ) : Matrix d d ℂ) = 1 :=
      (Matrix.mem_unitaryGroup_iff').1 U.property
    have hinv : ((U : Matrix d d ℂ) : Matrix d d ℂ)⁻¹ = star ((U : Matrix d d ℂ) : Matrix d d ℂ) :=
      Matrix.inv_eq_left_inv hstar
    rw [hinv]; exact hstar
  have hUinv' : ((U : Matrix d d ℂ) : Matrix d d ℂ) * ((U : Matrix d d ℂ) : Matrix d d ℂ)⁻¹ = 1 := by
    have hstar : ((U : Matrix d d ℂ) : Matrix d d ℂ) * star ((U : Matrix d d ℂ) : Matrix d d ℂ) = 1 :=
      (Matrix.mem_unitaryGroup_iff).1 U.property
    have hinv : ((U : Matrix d d ℂ) : Matrix d d ℂ)⁻¹ = star ((U : Matrix d d ℂ) : Matrix d d ℂ) :=
      Matrix.inv_eq_left_inv ((Matrix.mem_unitaryGroup_iff').1 U.property)
    rw [hinv]; exact hstar
  induction segments with
  | nil =>
      simp [internalHolonomy, hUinv']
  | cons a segs ih =>
      simp only [List.map_cons, internalHolonomy, List.prod_cons] at ih ⊢
      rw [ih]
      have key : (((U : Matrix d d ℂ) : Matrix d d ℂ) * a * ((U : Matrix d d ℂ))⁻¹) * (((U : Matrix d d ℂ)) * segs.prod * ((U : Matrix d d ℂ))⁻¹)
          = ((U : Matrix d d ℂ)) * a * (((U : Matrix d d ℂ))⁻¹ * ((U : Matrix d d ℂ))) * segs.prod * ((U : Matrix d d ℂ))⁻¹ := by
        simp only [mul_assoc]
      rw [key, hUinv]
      simp only [mul_assoc, mul_one]

/-- Matrix exponential is natural under unitary conjugation for one internal segment. -/
theorem internalSegment_conj {d : Type*} [Fintype d] [DecidableEq d]
    (U : Matrix.unitaryGroup d ℂ) (Δs : ℝ) (M : Matrix d d ℂ) :
    internalSegment Δs ((U : Matrix d d ℂ) * M * ((U : Matrix d d ℂ))⁻¹) =
      (U : Matrix d d ℂ) * internalSegment Δs M * ((U : Matrix d d ℂ))⁻¹ := by
  unfold internalSegment
  have h_unit : IsUnit (U : Matrix d d ℂ) :=
    IsUnit.of_mul_eq_one _ U.2.2
  have h_exp : ∀ A : Matrix d d ℂ,
      NormedSpace.exp (U.val * A * U.val⁻¹)
        = U.val * NormedSpace.exp A * U.val⁻¹ := by
    intro A
    convert Matrix.exp_units_conj h_unit.unit A using 1
    · simp [Matrix.inv_def]
    · simp
  convert h_exp _ using 2
  simp [mul_assoc]

/-- HOL-003: Path-level gauge covariance follows by unfolding `internalHolonomyPath`. -/
theorem internalHolonomy_gaugeCovariant_path {N : ℕ} {d : Type*}
    [Fintype d] [DecidableEq d] (U : Matrix.unitaryGroup d ℂ) (Δs : Fin (N + 1) → ℝ)
    (M : Fin (N + 1) → Matrix d d ℂ) :
    internalHolonomyPath Δs (fun i => (U : Matrix d d ℂ) * M i * ((U : Matrix d d ℂ))⁻¹) =
      (U : Matrix d d ℂ) * internalHolonomyPath Δs M * ((U : Matrix d d ℂ))⁻¹ := by
  unfold internalHolonomyPath
  induction N with
  | zero =>
    simp only [List.ofFn_succ, List.ofFn_zero]
    simp [internalHolonomy, internalSegment_conj]
  | succ k ih =>
    have hUU := U.2.2
    have hcong :=
      congr_arg (fun x => internalSegment (Δs 0) (U.val * M 0 * U.val⁻¹) * x)
        (ih (fun i => Δs i.succ) (fun i => M i.succ))
    convert hcong using 1
    · simp only [internalHolonomy, List.ofFn_succ, List.prod_cons]
    · unfold internalHolonomy
      simp only [← mul_assoc, internalSegment_conj]
      simp [mul_assoc, Matrix.inv_eq_right_inv hUU]

/-! ## Synchronization: commuting transports, path independence, holonomy defect

This section connects three notions in the synchronization lane of the
NullStrand roadmap:

* **commuting local transports** (the internal segments commute),
* **path independence** of the ordered internal holonomy (reordering the
  transports leaves the holonomy unchanged), and
* a finite **holonomy/curvature defect** that measures, and exactly detects, the
  failure of path independence.

All statements are finite, kernel-checkable group/ring facts about ordered
matrix products. They do not assert any continuum Stokes theorem or continuum
field strength. The additive elementary-square defect is the matrix (Lie)
commutator `A * B - B * A`; the multiplicative defect lives in the unitary
group and is the group commutator. -/

/-- **Path independence from commuting transports.**

If the ordered transport factors pairwise commute, then any reordering of the
same local transports (traversing them along a different path with the same
endpoints) yields the same internal holonomy. This is the finite statement
that synchronization is path independent whenever the local transports commute.
-/
theorem internalHolonomy_perm_of_pairwise_commute {d : Type*} [Fintype d] [DecidableEq d]
    {segs segs' : List (Matrix d d ℂ)} (hperm : segs.Perm segs')
    (hcomm : segs.Pairwise Commute) :
    internalHolonomy segs = internalHolonomy segs' :=
  hperm.prod_eq' hcomm

/-- Commuting Hermitian generators produce commuting one-step internal
transports: if the generators `M` and `N` commute then the holonomy steps
`exp (-i Δs M)` and `exp (-i Δt N)` commute. -/
theorem internalSegment_commute_of_commute {d : Type*} [Fintype d] [DecidableEq d]
    (Δs Δt : ℝ) (M Nmat : Matrix d d ℂ) (h : Commute M Nmat) :
    Commute (internalSegment Δs M) (internalSegment Δt Nmat) := by
  unfold internalSegment
  exact ((((h.smul_left (Complex.ofReal Δs)).smul_right (Complex.ofReal Δt)).smul_left
    (-(Complex.I : ℂ))).smul_right (-(Complex.I : ℂ))).exp

/-- **Elementary-square path independence.**

If two local generators commute, then transporting `M` for duration `Δs` and
then `N` for duration `Δt` gives the same holonomy as transporting them in the
opposite order. This is the elementary plaquette of synchronization. -/
theorem internalHolonomy_segment_swap_of_commute {d : Type*} [Fintype d] [DecidableEq d]
    (Δs Δt : ℝ) (M Nmat : Matrix d d ℂ) (h : Commute M Nmat) :
    internalHolonomy [internalSegment Δs M, internalSegment Δt Nmat]
      = internalHolonomy [internalSegment Δt Nmat, internalSegment Δs M] := by
  have hc := internalSegment_commute_of_commute Δs Δt M Nmat h
  simp only [internalHolonomy, List.prod_cons, List.prod_nil, mul_one, hc.eq]

/-- **Additive internal holonomy defect.**

The matrix difference of two ordered holonomies with the same endpoints. It is
the finite carrier of the failure of path independence: it vanishes exactly
when the two paths give the same holonomy (proved in
`holonomyDefect_eq_zero_iff`). -/
def holonomyDefect {d : Type*} [Fintype d] [DecidableEq d]
    (p q : List (Matrix d d ℂ)) : Matrix d d ℂ :=
  internalHolonomy p - internalHolonomy q

/-- The additive holonomy defect vanishes iff the two paths are holonomy-equal,
i.e. path independence holds between them. -/
theorem holonomyDefect_eq_zero_iff {d : Type*} [Fintype d] [DecidableEq d]
    (p q : List (Matrix d d ℂ)) :
    holonomyDefect p q = 0 ↔ internalHolonomy p = internalHolonomy q :=
  sub_eq_zero

/-- **Elementary-square defect equals the matrix (Lie) commutator.**

The defect of the two ways around the elementary square (transport `A` then
`B`, versus `B` then `A`) is the matrix commutator `⁅A, B⁆ = A * B - B * A`,
the linearized curvature of the internal connection. -/
theorem holonomyDefect_swap_eq_commutator {d : Type*} [Fintype d] [DecidableEq d]
    (A B : Matrix d d ℂ) :
    holonomyDefect [A, B] [B, A] = A * B - B * A := by
  simp [holonomyDefect, internalHolonomy]

/-- **Curvature defect detects commutativity.**

The elementary-square defect vanishes exactly when the two transports commute,
i.e. path independence around the square is equivalent to vanishing curvature. -/
theorem holonomyDefect_swap_eq_zero_iff_commute {d : Type*} [Fintype d] [DecidableEq d]
    (A B : Matrix d d ℂ) :
    holonomyDefect [A, B] [B, A] = 0 ↔ Commute A B := by
  rw [holonomyDefect_swap_eq_commutator, sub_eq_zero]
  exact Iff.rfl

/-- **Failure of path independence from nonvanishing curvature.**

If the matrix commutator (curvature defect) is nonzero, then the two ways around
the elementary square give genuinely different holonomies: synchronization is
path dependent. This is the contrapositive direction of the defect/flatness
correspondence. -/
theorem pathDependent_of_commutator_ne {d : Type*} [Fintype d] [DecidableEq d]
    (A B : Matrix d d ℂ) (h : A * B - B * A ≠ 0) :
    internalHolonomy [A, B] ≠ internalHolonomy [B, A] := by
  rw [Ne, ← holonomyDefect_eq_zero_iff, holonomyDefect_swap_eq_commutator]
  exact h

/-- **Multiplicative unitary holonomy defect.**

Compares two parallel transports inside the unitary group; this is the proper
group-valued holonomy defect, `U⁻¹ * V`. -/
def unitaryHolonomyDefect {d : Type*} [Fintype d] [DecidableEq d]
    (U V : Matrix.unitaryGroup d ℂ) : Matrix.unitaryGroup d ℂ :=
  U⁻¹ * V

/-- The multiplicative unitary defect is trivial iff the two unitary holonomies
agree: path independence in group form. -/
theorem unitaryHolonomyDefect_eq_one_iff {d : Type*} [Fintype d] [DecidableEq d]
    (U V : Matrix.unitaryGroup d ℂ) :
    unitaryHolonomyDefect U V = 1 ↔ U = V := by
  rw [unitaryHolonomyDefect, inv_mul_eq_one, eq_comm]

/-- **Elementary-square unitary defect is the group commutator.**

The multiplicative defect of the two ways around the square is trivial exactly
when the two unitary transports commute. -/
theorem unitaryHolonomyDefect_swap_eq_one_iff_commute {d : Type*} [Fintype d] [DecidableEq d]
    (U V : Matrix.unitaryGroup d ℂ) :
    unitaryHolonomyDefect (U * V) (V * U) = 1 ↔ Commute U V := by
  rw [unitaryHolonomyDefect_eq_one_iff]
  exact Iff.rfl

/-- Internal holonomy of a Hermitian-generated finite path, packaged as a
unitary-group element (its unitarity is `internalHolonomy_unitary_of_hermitian`). -/
def internalHolonomyPathU {N : ℕ} {d : Type*} [Fintype d] [DecidableEq d]
    (Δs : Fin (N + 1) → ℝ) (M : Fin (N + 1) → Matrix d d ℂ)
    (hH : ∀ i : Fin (N + 1), (M i).IsHermitian) : Matrix.unitaryGroup d ℂ :=
  ⟨internalHolonomyPath Δs M, internalHolonomy_unitary_of_hermitian Δs M hH⟩

/-- The packaged unitary holonomy has the expected underlying matrix. -/
theorem internalHolonomyPathU_coe {N : ℕ} {d : Type*} [Fintype d] [DecidableEq d]
    (Δs : Fin (N + 1) → ℝ) (M : Fin (N + 1) → Matrix d d ℂ)
    (hH : ∀ i : Fin (N + 1), (M i).IsHermitian) :
    (internalHolonomyPathU Δs M hH : Matrix d d ℂ) = internalHolonomyPath Δs M :=
  rfl

/-- **Path independence as triviality of the unitary holonomy defect.**

Two Hermitian-generated finite paths give the same unitary holonomy iff their
multiplicative holonomy defect is trivial. This packages the abstract group
defect over the concrete internal-holonomy parallel transports. -/
theorem internalHolonomyPathU_eq_iff_defect_trivial {N : ℕ} {d : Type*}
    [Fintype d] [DecidableEq d]
    (Δs Δt : Fin (N + 1) → ℝ) (M Nmat : Fin (N + 1) → Matrix d d ℂ)
    (hM : ∀ i, (M i).IsHermitian) (hN : ∀ i, (Nmat i).IsHermitian) :
    internalHolonomyPathU Δs M hM = internalHolonomyPathU Δt Nmat hN ↔
      unitaryHolonomyDefect (internalHolonomyPathU Δs M hM)
        (internalHolonomyPathU Δt Nmat hN) = 1 :=
  (unitaryHolonomyDefect_eq_one_iff _ _).symm

end PhysicsSM.NullStrand.Clock
