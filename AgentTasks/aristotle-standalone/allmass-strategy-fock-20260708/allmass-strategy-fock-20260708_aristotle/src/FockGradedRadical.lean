import Mathlib
import src.FockQuotientPairing

/-!
# Q08 graded radical assembly for the finite Fock quotient bridge

`FockQuotientPairing.lean` proved the fixed-particle-number
Gupta-Bleuler/Fock quotient bridge: for a symmetric form `h` on a
finite-dimensional space `W` with radical `N = ker h`, the radical of the
induced Gram-determinant form on `⋀[K]^n W` is exactly the kernel of the Fock
projection `exteriorPower.map n (LinearMap.ker h).mkQ`
(`exteriorForm_radical_eq`).

This module assembles that result across all particle numbers.  The graded Fock
space is the direct sum `⨁ n, ⋀[K]^n W`, and the graded form is the orthogonal
direct sum of the degreewise forms `exteriorForm n h`.  The main point is that
the radical of this direct-sum form is detected component by component, and
therefore becomes exactly the graded family of degreewise projection kernels.

Claim boundary: this is finite/graded multilinear algebra over a field.  It
does not prove positivity, Hilbert-space completion, or a model-level physical
Gupta-Bleuler quotient.  The individual exterior powers are finite-dimensional;
the all-degree direct sum is handled by Lean's finite-support direct-sum API.

Provenance: clean-room formalization from Aristotle job
`ne-solo-lane-q08-fock-graded-radical-lgv-lift-proof-20260707`, succeeding the
Q08 `FockQuotientPairing.lean` fixed-degree bridge.
-/

open scoped DirectSum ExteriorAlgebra
open exteriorPower

namespace PhysicsSM.Draft.NullEdge.Carrier.FockGradedRadical

/-! ## Orthogonal direct sums of bilinear forms -/

section DirectSumForm
variable {ι : Type*} [DecidableEq ι] {K : Type*} [Field K]
variable {M : ι → Type*} [∀ i, AddCommGroup (M i)] [∀ i, Module K (M i)]

/-- The orthogonal direct sum of a family of bilinear forms.  On homogeneous
generators, it pairs matching summands by `B i` and kills cross-summand pairs. -/
noncomputable def bilinDS (B : ∀ i, LinearMap.BilinForm K (M i)) :
    LinearMap.BilinForm K (⨁ i, M i) :=
  DirectSum.toModule K ι _ (fun i =>
    (LinearMap.lcomp K K (DirectSum.component K ι M i)).comp (B i))

/-- Evaluation of the direct-sum form when the left argument is homogeneous. -/
theorem bilinDS_apply_lof_left (B : ∀ i, LinearMap.BilinForm K (M i))
    (i : ι) (x : M i) (y : ⨁ i, M i) :
    bilinDS B (DirectSum.lof K ι M i x) y
      = (B i) x (DirectSum.component K ι M i y) := by
  simp [bilinDS]

/-- Evaluation of the direct-sum form when the right argument is homogeneous. -/
theorem bilinDS_apply_lof_right (B : ∀ i, LinearMap.BilinForm K (M i))
    (x : ⨁ i, M i) (i : ι) (v : M i) :
    bilinDS B x (DirectSum.lof K ι M i v)
      = (B i) (DirectSum.component K ι M i x) v := by
  induction x using DirectSum.induction_on
  · simp +decide
  · rename_i j x
    convert bilinDS_apply_lof_left B j x (DirectSum.lof K ι M i v) using 1
    erw [DirectSum.component.of]
    erw [DirectSum.component.of]
    aesop
  · simp_all +decide [bilinDS]

/-- An element is radical for the direct-sum form iff every homogeneous
component is radical for the corresponding summand form. -/
theorem bilinDS_ker_iff (B : ∀ i, LinearMap.BilinForm K (M i)) (x : ⨁ i, M i) :
    x ∈ LinearMap.ker (bilinDS B) ↔
      ∀ i, DirectSum.component K ι M i x ∈ LinearMap.ker (B i) := by
  constructor
  · intro hx i
    ext v
    convert congr_arg (fun f => f (DirectSum.lof K ι M i v)) hx using 1
    exact Eq.symm (bilinDS_apply_lof_right B x i v)
  · intro h
    ext y
    simp_all +decide [bilinDS_apply_lof_right]

/-- The orthogonal direct sum of symmetric forms is symmetric. -/
theorem bilinDS_isSymm (B : ∀ i, LinearMap.BilinForm K (M i))
    (hB : ∀ i, (B i).IsSymm) :
    (bilinDS B).IsSymm := by
  have h_symm : ∀ x y : ⨁ i, M i, (bilinDS B) x y = (bilinDS B) y x := by
    intro x y
    induction' x using DirectSum.induction_on with i x ih generalizing y
    · simp +decide [bilinDS]
    · convert (hB i).eq x (DirectSum.component K ι M i y) using 1
      · convert bilinDS_apply_lof_left B i x y using 1
      · convert bilinDS_apply_lof_right B y i x using 1
    · simp +decide [*, LinearMap.map_add]
  exact { eq := h_symm }

/-- The orthogonal direct-sum form is nondegenerate iff every summand form is
nondegenerate. -/
theorem bilinDS_nondegenerate_iff (B : ∀ i, LinearMap.BilinForm K (M i)) :
    (bilinDS B).Nondegenerate ↔ ∀ i, (B i).Nondegenerate := by
  constructor <;> intro h
  · intro i
    simp [LinearMap.Nondegenerate] at h ⊢
    constructor
    · intro x hx
      have := h.1 (DirectSum.lof K ι M i x)
      simp_all +decide [LinearMap.SeparatingLeft]
      have := h.1 (DirectSum.lof K ι M i x) ?_
      · simpa using congr_arg (fun f => f i) this
      · intro y
        rw [bilinDS_apply_lof_left]
        simp +decide [hx]
    · intro x hx
      specialize h
      have := h.2
      simp_all +decide [LinearMap.SeparatingRight]
      specialize h
      replace h := h.2 (DirectSum.lof K ι M i x)
      simp_all +decide [bilinDS_apply_lof_right]
      simpa using congr_arg (fun f => f i) h
  · constructor
    · intro x hx
      specialize hx
      have := bilinDS_ker_iff B x
      simp_all +decide
      simp_all +decide [LinearMap.ext_iff]
      ext i
      specialize h i
      specialize this i
      simp_all +decide [LinearMap.Nondegenerate]
      exact h.1 _ (by aesop)
    · intro x hx
      simp_all +decide [LinearMap.SeparatingRight, LinearMap.Nondegenerate]
      ext i
      specialize h i
      have := h.2 (DirectSum.component K ι M i x)
      simp_all +decide
      convert h.2 (x i) _ using 1
      intro y
      specialize hx (DirectSum.lof K ι M i y)
      simp_all +decide [bilinDS_apply_lof_left]
      convert hx using 1

end DirectSumForm

/-! ## Graded Fock radical assembly -/

section FockGraded
variable {K W : Type*} [Field K] [AddCommGroup W] [Module K W] [FiniteDimensional K W]

open PhysicsSM.Draft.NullEdge.Carrier.FockQuotientPairing

/-- The graded Fock form: the orthogonal direct sum over particle number `n` of
the per-degree Gram-determinant forms `exteriorForm n h`. -/
noncomputable def fockGradedForm (h : LinearMap.BilinForm K W) :
    LinearMap.BilinForm K (⨁ n, ⋀[K]^n W) :=
  bilinDS (fun n => exteriorForm n h)

/-- Q08 graded radical assembly.  For a symmetric form `h`, an element of the
graded Fock space is in the radical of `fockGradedForm h` iff every homogeneous
component lies in the kernel of the corresponding exterior-power projection
onto the radical quotient. -/
theorem fockGraded_radical_componentwise (h : LinearMap.BilinForm K W)
    (hsymm : h.IsSymm) (x : ⨁ n, ⋀[K]^n W) :
    x ∈ LinearMap.ker (fockGradedForm h) ↔
      ∀ n, DirectSum.component K ℕ (fun n => ⋀[K]^n W) n x
        ∈ LinearMap.ker (exteriorPower.map n (LinearMap.ker h).mkQ) := by
  rw [fockGradedForm, bilinDS_ker_iff]
  exact forall_congr' fun n => by
    rw [exteriorForm_radical_eq h hsymm n]

end FockGraded

end PhysicsSM.Draft.NullEdge.Carrier.FockGradedRadical
