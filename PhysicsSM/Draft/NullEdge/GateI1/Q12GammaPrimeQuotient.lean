import Mathlib

/-!
# Q12 T9/E4: GammaPrime equivariance on the physical quotient

This module is the finite linear-algebra core behind the Q12
constraint-equivariance gate.  The physical sector is modeled as a subquotient
`V' / N`: the constrained subspace `V'` and a radical `N <= V'`.  Operators such
as the family monodromy `tau`, the grading `Gamma`, or a Dirac operator are
defined upstairs on `V`; per-sector statements only live downstairs after
descent.

The proved finite interface is:

* `physDescend`: an upstairs operator descends to `V' / N` if it preserves both
  `V'` and `N`.
* `physDescend_id`, `physDescend_comp`, `physDescend_cube_eq_id`: descent is
  functorial, so `tau^3 = 1` upstairs descends to `tau_bar^3 = 1`.
* `physDescend_commutes_iff`: descended operators commute iff the upstairs
  commutator maps `V'` into `N`.  Thus upstairs non-commutation may heal on the
  quotient exactly when the offending part lies in the radical.
* `map_eq_of_invariant_of_injective`: the literal equality `tau GammaPrime =
  GammaPrime` follows from invariance plus injectivity on a finite-dimensional
  constraint space.
* `E4_commutator_can_fail` and `E4_healing`: rational witnesses showing the gate
  is non-vacuous in both directions.

Claim boundary: this is finite subquotient linear algebra only.  It does not
prove upstairs commutation for a specific null-edge model, equivariant
McKean-Singer, anomaly cancellation, or a physical chirality statement.  It
supplies the exact hypothesis interface those later claims must satisfy.

Provenance: Aristotle project
`11184eac-22e1-42de-9802-37e564712a8c`
(`ne-q12-gammaprime-quotient-equivariance-audit-20260707`), clean-room
formalization of the T9/E4 gate flagged in `AgentTasks/fable_parallel/Q12_answer.md`.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.Q12GammaPrimeQuotient

open Submodule LinearMap

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-! ## The physical quotient and operator descent -/

/-- The descent of an operator `f` to the physical quotient `V' / N`.

The two hypotheses say that `f` preserves the constrained subspace and the
radical.  Without both, there is no well-defined downstairs operator. -/
noncomputable def physDescend (Vc Nc : Submodule K V)
    (f : V →ₗ[K] V) (hV : ∀ x ∈ Vc, f x ∈ Vc) (hN : ∀ x ∈ Nc, f x ∈ Nc) :
    (Vc ⧸ Nc.comap Vc.subtype) →ₗ[K] (Vc ⧸ Nc.comap Vc.subtype) :=
  (Nc.comap Vc.subtype).mapQ (Nc.comap Vc.subtype) (f.restrict hV) (by
    intro y hy
    rw [Submodule.mem_comap]
    simp only [Submodule.mem_comap, Submodule.coe_subtype] at hy ⊢
    exact hN _ hy)

@[simp] lemma physDescend_mk (Vc Nc : Submodule K V)
    (f : V →ₗ[K] V) (hV : ∀ x ∈ Vc, f x ∈ Vc) (hN : ∀ x ∈ Nc, f x ∈ Nc)
    (x : Vc) :
    physDescend Vc Nc f hV hN (Submodule.Quotient.mk x) =
      Submodule.Quotient.mk (f.restrict hV x) := by
  simp [physDescend, Submodule.mapQ_apply]

/-- The identity descends to the identity. -/
theorem physDescend_id (Vc Nc : Submodule K V) :
    physDescend Vc Nc (LinearMap.id) (fun _ hx => hx) (fun _ hx => hx)
      = LinearMap.id := by
  apply LinearMap.ext; intro q
  obtain ⟨x, rfl⟩ := Submodule.Quotient.mk_surjective _ q
  simp only [physDescend_mk, LinearMap.id_coe, id_eq]; rfl

/-- Descent is functorial: `physDescend (f ∘ g) = physDescend f ∘ physDescend g`. -/
theorem physDescend_comp (Vc Nc : Submodule K V)
    (f g : V →ₗ[K] V)
    (hVf : ∀ x ∈ Vc, f x ∈ Vc) (hNf : ∀ x ∈ Nc, f x ∈ Nc)
    (hVg : ∀ x ∈ Vc, g x ∈ Vc) (hNg : ∀ x ∈ Nc, g x ∈ Nc) :
    physDescend Vc Nc (f.comp g) (fun _ hx => hVf _ (hVg _ hx))
        (fun _ hx => hNf _ (hNg _ hx))
      = (physDescend Vc Nc f hVf hNf).comp (physDescend Vc Nc g hVg hNg) := by
  apply LinearMap.ext; intro q
  obtain ⟨x, rfl⟩ := Submodule.Quotient.mk_surjective _ q
  simp only [LinearMap.comp_apply, physDescend_mk]
  rfl

/-- If `tau^3 = 1` on the constrained subspace, then the descended monodromy
satisfies `tau_bar^3 = 1` on `V' / N`. -/
theorem physDescend_cube_eq_id (Vc Nc : Submodule K V) (t : V →ₗ[K] V)
    (hV : ∀ x ∈ Vc, t x ∈ Vc) (hN : ∀ x ∈ Nc, t x ∈ Nc)
    (h3 : ∀ x ∈ Vc, t (t (t x)) = x) :
    (physDescend Vc Nc t hV hN).comp
        ((physDescend Vc Nc t hV hN).comp (physDescend Vc Nc t hV hN))
      = LinearMap.id := by
  apply LinearMap.ext; intro q
  obtain ⟨x, rfl⟩ := Submodule.Quotient.mk_surjective _ q
  simp only [LinearMap.comp_apply, physDescend_mk, LinearMap.id_coe, id_eq]
  rw [Submodule.Quotient.eq]
  simp only [Submodule.mem_comap, Submodule.coe_subtype, AddSubgroupClass.coe_sub,
    LinearMap.restrict_coe_apply]
  rw [h3 _ x.2, sub_self]
  exact Nc.zero_mem

/-! ## The gate: descended commutation iff the commutator lands in the radical -/

/-- Two operators that preserve `V'` and `N` descend to commuting operators on
`V' / N` iff their upstairs commutator maps `V'` into the radical `N`.

Reading `f = tau` and `g = Gamma`: the descended family monodromy preserves the
descended grading exactly when `[tau, Gamma] V' <= N`. -/
theorem physDescend_commutes_iff (Vc Nc : Submodule K V)
    (f g : V →ₗ[K] V)
    (hVf : ∀ x ∈ Vc, f x ∈ Vc) (hNf : ∀ x ∈ Nc, f x ∈ Nc)
    (hVg : ∀ x ∈ Vc, g x ∈ Vc) (hNg : ∀ x ∈ Nc, g x ∈ Nc) :
    (physDescend Vc Nc f hVf hNf).comp (physDescend Vc Nc g hVg hNg) =
      (physDescend Vc Nc g hVg hNg).comp (physDescend Vc Nc f hVf hNf)
      ↔ ∀ x : Vc, (f (g x) - g (f x) : V) ∈ Nc := by
  constructor
  · intro h x
    have hx := LinearMap.congr_fun h (Submodule.Quotient.mk x)
    simp only [LinearMap.comp_apply, physDescend_mk] at hx
    rw [Submodule.Quotient.eq] at hx
    simpa only [Submodule.mem_comap, Submodule.coe_subtype, AddSubgroupClass.coe_sub,
      LinearMap.restrict_coe_apply] using hx
  · intro h
    apply LinearMap.ext; intro q
    obtain ⟨x, rfl⟩ := Submodule.Quotient.mk_surjective _ q
    simp only [LinearMap.comp_apply, physDescend_mk]
    rw [Submodule.Quotient.eq]
    simpa only [Submodule.mem_comap, Submodule.coe_subtype, AddSubgroupClass.coe_sub,
      LinearMap.restrict_coe_apply] using h x

/-- Convenience direction: if the upstairs commutator lands in the radical, the
descended operators commute. -/
theorem physDescend_commutes_of_commutator_mem (Vc Nc : Submodule K V)
    (f g : V →ₗ[K] V)
    (hVf : ∀ x ∈ Vc, f x ∈ Vc) (hNf : ∀ x ∈ Nc, f x ∈ Nc)
    (hVg : ∀ x ∈ Vc, g x ∈ Vc) (hNg : ∀ x ∈ Nc, g x ∈ Nc)
    (h : ∀ x : Vc, (f (g x) - g (f x) : V) ∈ Nc) :
    (physDescend Vc Nc f hVf hNf).comp (physDescend Vc Nc g hVg hNg) =
      (physDescend Vc Nc g hVg hNg).comp (physDescend Vc Nc f hVf hNf) :=
  (physDescend_commutes_iff Vc Nc f g hVf hNf hVg hNg).mpr h

/-- Upstairs commutation is a sufficient condition for descended commutation. -/
theorem physDescend_commutes_of_commute (Vc Nc : Submodule K V)
    (f g : V →ₗ[K] V)
    (hVf : ∀ x ∈ Vc, f x ∈ Vc) (hNf : ∀ x ∈ Nc, f x ∈ Nc)
    (hVg : ∀ x ∈ Vc, g x ∈ Vc) (hNg : ∀ x ∈ Nc, g x ∈ Nc)
    (h : ∀ x, f (g x) = g (f x)) :
    (physDescend Vc Nc f hVf hNf).comp (physDescend Vc Nc g hVg hNg) =
      (physDescend Vc Nc g hVg hNg).comp (physDescend Vc Nc f hVf hNf) := by
  refine physDescend_commutes_of_commutator_mem Vc Nc f g hVf hNf hVg hNg ?_
  intro x; rw [h]; simp

/-! ## The literal constraint identity `tau GammaPrime = GammaPrime` -/

/-- Invariance plus injectivity on a finite-dimensional constraint space gives
the equality `tau GammaPrime = GammaPrime`. -/
theorem map_eq_of_invariant_of_injective (Cc : Submodule K V)
    [FiniteDimensional K Cc]
    (t : V →ₗ[K] V) (hinv : ∀ x ∈ Cc, t x ∈ Cc) (hinj : Function.Injective t) :
    Submodule.map t Cc = Cc := by
  apply le_antisymm
  · rintro _ ⟨x, hx, rfl⟩; exact hinv x hx
  · intro y hy
    set tR : Cc →ₗ[K] Cc := t.restrict hinv with htR
    have hinjR : Function.Injective tR := by
      intro a b hab
      have hab' : t (a : V) = t (b : V) := by
        have := congrArg Subtype.val hab
        simpa [tR, LinearMap.restrict_coe_apply] using this
      exact Subtype.ext (hinj hab')
    have hsurj : Function.Surjective tR := LinearMap.injective_iff_surjective.mp hinjR
    obtain ⟨x, hx⟩ := hsurj ⟨y, hy⟩
    refine ⟨x, x.2, ?_⟩
    have := congrArg Subtype.val hx
    simpa [tR, LinearMap.restrict_coe_apply] using this

/-! ## Non-vacuity witnesses: the gate genuinely cuts both ways -/

/-- Local witness carrier. -/
abbrev W := Fin 2 → ℚ

/-- A nilpotent shift, `e01`. -/
noncomputable def fW : W →ₗ[ℚ] W := Matrix.mulVecLin !![0,1;0,0]

/-- A rank-one idempotent, `e00`. -/
noncomputable def gW : W →ₗ[ℚ] W := Matrix.mulVecLin !![1,0;0,0]

/-- `fW` and `gW` do not commute: the E4 commutator condition fails for the
radical `N = bottom`. -/
theorem E4_commutator_can_fail :
    ¬ ∀ x : (⊤ : Submodule ℚ W),
        (fW (gW x) - gW (fW x) : W) ∈ (⊥ : Submodule ℚ W) := by
  intro h
  have h1 := h ⟨![1,1], Submodule.mem_top⟩
  rw [Submodule.mem_bot] at h1
  have h0 := congrFun h1 0
  simp [fW, gW, dotProduct, Fin.sum_univ_two] at h0

/-- Healing: for the same non-commuting pair, taking the radical `N = top`
makes the descended operators commute because every commutator value lies in
`N`. -/
theorem E4_healing :
    ∀ x : (⊤ : Submodule ℚ W),
        (fW (gW x) - gW (fW x) : W) ∈ (⊤ : Submodule ℚ W) :=
  fun _ => Submodule.mem_top

/-! ## Footprint audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12GammaPrimeQuotient.physDescend_cube_eq_id' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physDescend_cube_eq_id

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12GammaPrimeQuotient.physDescend_comp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physDescend_comp

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12GammaPrimeQuotient.physDescend_commutes_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physDescend_commutes_iff

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12GammaPrimeQuotient.map_eq_of_invariant_of_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms map_eq_of_invariant_of_injective

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12GammaPrimeQuotient.E4_commutator_can_fail' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms E4_commutator_can_fail

end PhysicsSM.Draft.NullEdge.GateI1.Q12GammaPrimeQuotient
