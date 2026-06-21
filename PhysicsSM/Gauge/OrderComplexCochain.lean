import Mathlib

/-!
# Gauge.OrderComplexCochain

Trusted finite order-complex chain and cochain wrappers for the null-edge
causal graph program.

This module models a formal ordered simplex as a list of vertices, defines the
alternating boundary by deleting one list entry at a time, and proves that the
boundary squares to zero.  It then dualizes this finite chain calculation to
integral cochains and packages the usual coboundary/cocycle/cohomologous
language.

Claim boundary:
* simplices are formal ordered lists, not geometric simplices in a topological
  realization;
* degeneracy quotienting is not imposed;
* the result is finite combinatorial algebra only, not a continuum differential
  operator or analytic de Rham theorem.

Sources and provenance:
* `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
* `AgentTasks/null-edge-overnight-synthesis-aristotle-2026-06-21.md`
* Promoted from the no-s o r r y draft modules
  `PhysicsSM.Draft.NullEdgeCoreAristotle`,
  `PhysicsSM.Draft.NullEdgeCochainDiamond`, and
  `PhysicsSM.Draft.NullEdgeOvernightSynthesisAristotle` after semantic review.

Status: trusted, no `s o r r y`.
-/

noncomputable section

namespace PhysicsSM.Gauge.OrderComplexCochain

/-! ## Formal chains -/

/-- A formal simplex is represented by its ordered vertex list. -/
abbrev Simplex (V : Type*) := List V

/-- Integral chains on formal ordered simplices. -/
abbrev Chain (V : Type*) := Simplex V →₀ ℤ

/-- Delete the `i`-th vertex of a formal simplex. -/
def face {V : Type*} (s : Simplex V) (i : Nat) : Simplex V :=
  s.eraseIdx i

/-- Alternating boundary of one formal ordered simplex. -/
def simplexBoundary {V : Type*} (s : Simplex V) : Chain V :=
  ∑ i ∈ Finset.range s.length,
    Finsupp.single (face s i) ((-1 : ℤ) ^ i)

/-- Extend simplex boundary linearly to formal integral chains. -/
def chainBoundary {V : Type*} (c : Chain V) : Chain V :=
  c.sum fun s coeff => coeff • simplexBoundary s

/-- `chainBoundary` of a single generator. -/
lemma chainBoundary_single {V : Type*} (s : Simplex V) (n : ℤ) :
    chainBoundary (Finsupp.single s n) = n • simplexBoundary s := by
  unfold chainBoundary simplexBoundary
  aesop

/-- `chainBoundary` sends `0` to `0`. -/
lemma chainBoundary_zero {V : Type*} :
    chainBoundary (0 : Chain V) = 0 := by
  unfold chainBoundary
  simp [Finsupp.sum]

/-- `chainBoundary` is additive. -/
lemma chainBoundary_add {V : Type*} (c d : Chain V) :
    chainBoundary (c + d) = chainBoundary c + chainBoundary d := by
  unfold chainBoundary
  rw [Finsupp.sum_add_index'] <;> simp [add_smul]

/-- The formal chain boundary as an additive homomorphism. -/
def chainBoundaryAddHom {V : Type*} : Chain V →+ Chain V where
  toFun := chainBoundary
  map_zero' := chainBoundary_zero
  map_add' := chainBoundary_add

/-- `chainBoundary` commutes with finite sums. -/
lemma chainBoundary_sum {V ι : Type*} (t : Finset ι) (f : ι → Chain V) :
    chainBoundary (∑ i ∈ t, f i) = ∑ i ∈ t, chainBoundary (f i) := by
  classical
  change chainBoundaryAddHom (∑ i ∈ t, f i) =
    ∑ i ∈ t, chainBoundaryAddHom (f i)
  simp

/-- Face-of-face commutation identity for `eraseIdx`. -/
lemma face_face_comm {V : Type*} (s : Simplex V) {a b : ℕ} (h : a ≤ b) :
    face (face s a) b = face (face s (b + 1)) a := by
  induction' s with x xs ih generalizing a b
  · rfl
  · rcases a with (_ | a) <;> rcases b with (_ | b) <;>
      simp_all +decide [face]

/-- The alternating double sum over pairs of faces cancels to zero. -/
lemma face_double_sum_eq_zero {V : Type*} (s : Simplex V) :
    (∑ i ∈ Finset.range s.length, ∑ j ∈ Finset.range (s.length - 1),
        Finsupp.single (face (face s i) j) ((-1 : ℤ) ^ (i + j))) = 0 := by
  have h_sum_prod :
      ∑ p ∈ Finset.product (Finset.range s.length) (Finset.range (s.length - 1)),
        Finsupp.single (face (face s p.1) p.2) ((-1 : ℤ) ^ (p.1 + p.2)) = 0 := by
    apply Finset.sum_involution
    case g =>
      exact fun a _ => if a.2 < a.1 then (a.2, a.1 - 1) else (a.2 + 1, a.1)
    · intro a ha
      split_ifs <;> simp_all [pow_add, pow_one]
      · ext
        simp [*]
        ring
        by_cases h : face (face s a.1) a.2 = ‹_› <;>
          by_cases h' : face (face s a.2) (a.1 - 1) = ‹_› <;>
          simp_all +decide
        · cases a_1 : a.1 <;> simp_all [pow_succ']
          ring
        · exact h' (by
            rw [← h, face_face_comm _ (by omega)]
            simp [*, Nat.sub_add_cancel (by omega : 1 ≤ a.1)])
        · convert face_face_comm s
            (show a.2 ≤ a.1 - 1 from Nat.le_sub_one_of_lt ‹_›) using 1
          grind
      · rw [← face_face_comm _ (by linarith : a.1 ≤ a.2)]
        ring
        simp [mul_comm]
    · grind
    · grind
    · simp +zetaDelta at *
      grind
  erw [← h_sum_prod, Finset.sum_product]

/--
Order-complex seed theorem: the formal alternating boundary squares to zero
on every ordered simplex.
-/
theorem chainBoundary_simplexBoundary_eq_zero {V : Type*} (s : Simplex V) :
    chainBoundary (simplexBoundary s) = 0 := by
  have h_expand :
      chainBoundary (simplexBoundary s) =
        ∑ i ∈ Finset.range s.length,
          (-1 : ℤ) ^ i • simplexBoundary (face s i) := by
    convert chainBoundary_sum (Finset.range s.length)
        (fun i => Finsupp.single (face s i) ((-1 : ℤ) ^ i)) using 1
    exact Finset.sum_congr rfl fun _ _ => by rw [chainBoundary_single]
  have h_expand_face :
      ∀ i ∈ Finset.range s.length,
        simplexBoundary (face s i) =
          ∑ j ∈ Finset.range (s.length - 1),
            Finsupp.single (face (face s i) j) ((-1 : ℤ) ^ j) := by
    unfold simplexBoundary face
    grind
  convert face_double_sum_eq_zero s using 1
  rw [h_expand, Finset.sum_congr rfl]
  intro i hi
  rw [h_expand_face i hi]
  simp [pow_add, Finset.smul_sum]

/-- `chainBoundary` commutes with integer scalar multiplication. -/
lemma chainBoundary_zsmul {V : Type*} (n : ℤ) (c : Chain V) :
    chainBoundary (n • c) = n • chainBoundary c := by
  ext s
  simp [chainBoundary, Finsupp.smul_apply, Finsupp.sum_apply]
  simp [Finsupp.sum, mul_assoc, Finset.mul_sum _ _ _]
  refine Finset.sum_subset ?_ ?_
  · intro x hx
    aesop
  · intro x hx hnot
    aesop

/-- The boundary operator squares to zero on all formal integral chains. -/
theorem chainBoundary_comp_self_eq_zero {V : Type*} (c : Chain V) :
    chainBoundary (chainBoundary c) = 0 := by
  convert chainBoundary_sum c.support (fun s => c s • simplexBoundary s) using 1
  exact Eq.symm (Finset.sum_eq_zero fun x hx => by
    rw [chainBoundary_zsmul, chainBoundary_simplexBoundary_eq_zero, smul_zero])

/-! ## Integral cochains -/

/-- Integral cochains on formal ordered simplices. -/
abbrev IntegralCochain (V : Type*) := Chain V →+ ℤ

/-- Coboundary of an integral cochain by precomposition with chain boundary. -/
def cochainCoboundary {V : Type*}
    (f : IntegralCochain V) : IntegralCochain V :=
  f.comp chainBoundaryAddHom

/-- Evaluation form of the cochain coboundary definition. -/
theorem cochainCoboundary_apply {V : Type*}
    (f : IntegralCochain V) (c : Chain V) :
    cochainCoboundary f c = f (chainBoundary c) := rfl

/-- The cochain coboundary squares to zero because the chain boundary does. -/
theorem cochainCoboundary_comp_self_eq_zero {V : Type*}
    (f : IntegralCochain V) :
    cochainCoboundary (cochainCoboundary f) = 0 := by
  apply AddMonoidHom.ext
  intro c
  change f (chainBoundary (chainBoundary c)) = 0
  rw [chainBoundary_comp_self_eq_zero]
  exact map_zero f

/-- A finite integral cochain whose coboundary vanishes. -/
def IsCocycle {V : Type*} (f : IntegralCochain V) : Prop :=
  cochainCoboundary f = 0

/-- A finite integral cochain that is a coboundary. -/
def IsCoboundary {V : Type*} (f : IntegralCochain V) : Prop :=
  ∃ g : IntegralCochain V, f = cochainCoboundary g

/-- Every coboundary is a cocycle, the cochain form of `d^2 = 0`. -/
theorem coboundary_is_cocycle {V : Type*}
    (f : IntegralCochain V) (hf : IsCoboundary f) :
    IsCocycle f := by
  obtain ⟨g, rfl⟩ := hf
  exact cochainCoboundary_comp_self_eq_zero g

/-- Cohomologous integral cochains differ by a coboundary. -/
def Cohomologous {V : Type*} (f g : IntegralCochain V) : Prop :=
  IsCoboundary (f - g)

/-- Cohomology is reflexive at the finite cochain level. -/
theorem cohomologous_refl {V : Type*} (f : IntegralCochain V) :
    Cohomologous f f := by
  use 0
  simp [cochainCoboundary]

/-- Cohomology is symmetric at the finite cochain level. -/
theorem cohomologous_symm {V : Type*} {f g : IntegralCochain V}
    (h : Cohomologous f g) :
    Cohomologous g f := by
  obtain ⟨k, hk⟩ := h
  refine ⟨-k, ?_⟩
  convert congr_arg Neg.neg hk using 1
  abel_nf

/-- Cohomology is transitive at the finite cochain level. -/
theorem cohomologous_trans {V : Type*} {f g h : IntegralCochain V}
    (hfg : Cohomologous f g) (hgh : Cohomologous g h) :
    Cohomologous f h := by
  obtain ⟨a, ha⟩ := hfg
  obtain ⟨b, hb⟩ := hgh
  use a + b
  ext c
  simp [cochainCoboundary_apply]
  replace ha := congr_arg (fun f => f (Finsupp.single c 1)) ha
  replace hb := congr_arg (fun f => f (Finsupp.single c 1)) hb
  simp_all [cochainCoboundary_apply]
  lia

end PhysicsSM.Gauge.OrderComplexCochain

end
