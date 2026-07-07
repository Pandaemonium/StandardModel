import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Q11RealStructure

/-!
# Q11 group-action nucleus: exterior-functor data

This module is the kernel-checked structural nucleus of the group-level RC0
route for the Q11 real-structure lane. It introduces the exterior-functor
coefficient formula `lambdaAction` on the model
`Form = Finset (Fin 5) -> C`, together with the two maps `Kmap` (entrywise
conjugation) and `Cmap` (top-form duality).

The landed theorems are the factorization `JR = Cmap o Kmap`, the involution
and commutation laws for `Kmap` and `Cmap`, conjugation compatibility for
minors, conjugation compatibility for `lambdaAction`, and cardinality-support
control for the coefficient formula. It also packages the coefficient formula
as a linear endomorphism `lambdaLinearMap`.
It also proves the identity-minor Kronecker theorem and the identity action
`lambdaAction 1 = id`.

Claim boundary: this file does not land the finite Cauchy-Binet functor law,
Jacobi complementary minors, determinant cocycle, or group-level RC0
equivalence. The returned Aristotle proof of that larger chain is useful but
still needs a kernel-clean Cauchy-Binet/functoriality pass, and the later
Jacobi tail still depends on the separate `gl_fiber` interleaving-sign
factorization. In particular, this file does not claim unimodularity.

Provenance: Aristotle project `aa4e48f6-2581-4276-a5ae-db77c7660cd6`
(`ne-q11-jacobi-minor-cauchybinet-rc0-proof-20260707`), harvested as the
kernel-clean subset of the returned `Q11GroupAction.lean`.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction

open Finset Matrix
open PhysicsSM.Draft.NullEdge.GateI1.Q11RealStructure

/-- Reuse the fiber coefficient model. -/
abbrev Form := Finset (Fin 5) → ℂ

/-! ## The exterior-functor coefficient formula and conjugation maps -/

/-- The `|T| x |T|` minor of `g` on rows `T`, columns `S`, computed against the
increasing enumerations of `T` and `S`; it is zero unless the two sets have the
same cardinality. -/
noncomputable def minorDet (g : Matrix (Fin 5) (Fin 5) ℂ) (T S : Finset (Fin 5)) : ℂ :=
  if h : S.card = T.card then
    (g.submatrix (fun i : Fin T.card => T.orderEmbOfFin rfl i)
                 (fun i : Fin T.card => S.orderEmbOfFin h i)).det
  else 0

/-- The exterior-functor coefficient formula for `Lambda(g)`. Functoriality is
not proved in this module; see the module claim boundary. -/
noncomputable def lambdaAction (g : Matrix (Fin 5) (Fin 5) ℂ) (f : Form) : Form :=
  fun T => ∑ S : Finset (Fin 5), minorDet g T S * f S

/-- Entrywise conjugation. -/
def Kmap (f : Form) : Form := fun T => (starRingEnd ℂ) (f T)

/-- Top-form duality `C : e_S |-> sigma(S) e_{Sᶜ}`, in coefficients. -/
def Cmap (f : Form) : Form := fun T => f Tᶜ * (sigmaSign Tᶜ : ℂ)

/-! ## Bridge to the fiber real-structure file -/

/-- `JR = C o K`: the fiber real structure factors through the two maps here. -/
theorem JR_eq_Cmap_Kmap (f : Form) : JR f = Cmap (Kmap f) := by
  funext T
  simp only [JR, Cmap, Kmap]

/-- `K` is an involution. -/
theorem Kmap_involutive (f : Form) : Kmap (Kmap f) = f := by
  funext T
  simp [Kmap]

/-- `C` is an involution. -/
theorem Cmap_involutive (f : Form) : Cmap (Cmap f) = f := by
  funext T
  have hc : (sigmaSign T : ℂ) * (sigmaSign Tᶜ : ℂ) = 1 := by
    rw [← Int.cast_mul, sigmaSign_mul_compl]
    norm_num
  simp only [Cmap, compl_compl]
  calc f T * (sigmaSign T : ℂ) * (sigmaSign Tᶜ : ℂ)
        = f T * ((sigmaSign T : ℂ) * (sigmaSign Tᶜ : ℂ)) := by ring
    _ = f T := by rw [hc]; ring

/-- `K` and `C` commute, because `C` has real coefficients. -/
theorem Kmap_Cmap_comm (f : Form) : Kmap (Cmap f) = Cmap (Kmap f) := by
  funext T
  simp only [Kmap, Cmap, map_mul, map_intCast]

/-! ## Conjugation compatibility -/

/-- The minor of the entrywise conjugate is the conjugate of the minor. -/
theorem minorDet_conj (g : Matrix (Fin 5) (Fin 5) ℂ) (T S : Finset (Fin 5)) :
    minorDet (g.map (starRingEnd ℂ)) T S = (starRingEnd ℂ) (minorDet g T S) := by
  unfold minorDet
  by_cases h : S.card = T.card
  · simp only [h, dif_pos]
    rw [RingHom.map_det]
    rfl
  · simp [h]

/-- Conjugation compatibility of the exterior-functor coefficient formula:
`Lambda(conj g) = K o Lambda(g) o K`. -/
theorem lambdaAction_conj (g : Matrix (Fin 5) (Fin 5) ℂ) (f : Form) :
    lambdaAction (g.map (starRingEnd ℂ)) f = Kmap (lambdaAction g (Kmap f)) := by
  funext T
  simp only [lambdaAction, Kmap, map_sum, map_mul]
  refine Finset.sum_congr rfl (fun S _ => ?_)
  rw [minorDet_conj, Complex.conj_conj]

/-! ## Small checked minor lemma -/

/-- Empty minor is `1`. -/
theorem minorDet_empty (g : Matrix (Fin 5) (Fin 5) ℂ) : minorDet g ∅ ∅ = 1 := by
  simp [minorDet]

/-! ## Cardinality support -/

/-- Minors with different row/column cardinalities vanish by definition. -/
theorem minorDet_card_ne (g : Matrix (Fin 5) (Fin 5) ℂ) {T S : Finset (Fin 5)}
    (h : S.card ≠ T.card) :
    minorDet g T S = 0 := by
  simp [minorDet, h]

/-- The exterior coefficient sum only sees subsets with the same cardinality as
the output subset. -/
theorem lambdaAction_eq_sum_filter_card (g : Matrix (Fin 5) (Fin 5) ℂ) (f : Form)
    (T : Finset (Fin 5)) :
    lambdaAction g f T =
      ∑ S ∈ Finset.univ.filter (fun S : Finset (Fin 5) => S.card = T.card),
        minorDet g T S * f S := by
  rw [lambdaAction, Finset.sum_filter]
  refine Finset.sum_congr rfl (fun S _ => ?_)
  by_cases hcard : S.card = T.card
  · simp [hcard]
  · simp [minorDet_card_ne g hcard, hcard]

/-- `lambdaAction` preserves cardinality-degree support: if a form vanishes
away from degree `k`, then its image also vanishes away from degree `k`. -/
theorem lambdaAction_preserves_card_support
    (g : Matrix (Fin 5) (Fin 5) ℂ) (f : Form) (k : ℕ)
    (hf : ∀ S : Finset (Fin 5), S.card ≠ k → f S = 0)
    {T : Finset (Fin 5)} (hT : T.card ≠ k) :
    lambdaAction g f T = 0 := by
  rw [lambdaAction_eq_sum_filter_card]
  refine Finset.sum_eq_zero (fun S hS => ?_)
  have hcard : S.card = T.card := by
    simpa using hS
  have hSk : S.card ≠ k := by
    intro hSk
    exact hT (hcard ▸ hSk)
  simp [hf S hSk]

/-! ## Linearity in the form argument -/

/-- `lambdaAction g` is additive in the form argument. -/
theorem lambdaAction_add (g : Matrix (Fin 5) (Fin 5) ℂ) (f h : Form) :
    lambdaAction g (f + h) = lambdaAction g f + lambdaAction g h := by
  funext T
  simp [lambdaAction, mul_add, Finset.sum_add_distrib]

/-- `lambdaAction g` is homogeneous in the form argument. -/
theorem lambdaAction_smul (g : Matrix (Fin 5) (Fin 5) ℂ) (c : ℂ) (f : Form) :
    lambdaAction g (c • f) = c • lambdaAction g f := by
  funext T
  simp [lambdaAction, Finset.mul_sum, mul_assoc, mul_comm]

/-- The exterior coefficient formula as a linear endomorphism of `Form`.
Functoriality of this linear map is the remaining Cauchy-Binet target. -/
noncomputable def lambdaLinearMap (g : Matrix (Fin 5) (Fin 5) ℂ) : Form →ₗ[ℂ] Form where
  toFun := lambdaAction g
  map_add' := lambdaAction_add g
  map_smul' := lambdaAction_smul g

@[simp]
theorem lambdaLinearMap_apply (g : Matrix (Fin 5) (Fin 5) ℂ) (f : Form) :
    lambdaLinearMap g f = lambdaAction g f := rfl

/-! ## Identity matrix minors -/

/-- The identity matrix has Kronecker minors on ordered finite subsets. -/
theorem minorDet_one (T S : Finset (Fin 5)) :
    minorDet (1 : Matrix (Fin 5) (Fin 5) ℂ) T S = if S = T then 1 else 0 := by
  unfold minorDet
  by_cases hcard : S.card = T.card
  · by_cases hST : S = T
    · subst S
      have hcols :
          (fun i : Fin T.card => T.orderEmbOfFin hcard i) =
            fun i : Fin T.card => T.orderEmbOfFin rfl i := by
        funext i
        congr
      rw [hcols]
      have hmat :
          (1 : Matrix (Fin 5) (Fin 5) ℂ).submatrix
              (fun i : Fin T.card => T.orderEmbOfFin rfl i)
              (fun i : Fin T.card => T.orderEmbOfFin rfl i) =
            (1 : Matrix (Fin T.card) (Fin T.card) ℂ) :=
        Matrix.submatrix_one _ (T.orderEmbOfFin rfl).injective
      simp [hmat]
    · simp only [hcard, dif_pos, hST, ↓reduceIte]
      obtain ⟨x, hxS, hxT⟩ : ∃ x, x ∈ S ∧ x ∉ T := by
        by_contra hnone
        have hsub : S ⊆ T := by
          intro x hx
          by_contra hxT
          exact hnone ⟨x, hx, hxT⟩
        exact hST (Finset.eq_of_subset_of_card_le hsub hcard.ge)
      have hxrange : x ∈ Set.range (S.orderEmbOfFin hcard) := by
        rw [Finset.range_orderEmbOfFin]
        exact hxS
      obtain ⟨k, hk⟩ := hxrange
      apply Matrix.det_eq_zero_of_column_eq_zero k
      intro i
      have hne : T.orderEmbOfFin rfl i ≠ S.orderEmbOfFin hcard k := by
        intro heq
        exact hxT (heq.trans hk |>.symm ▸ Finset.orderEmbOfFin_mem T rfl i)
      simp [Matrix.one_apply_ne hne]
  · have hST : S ≠ T := by
      intro hST
      exact hcard (by simp [hST])
    simp [hcard, hST]

/-- `lambdaAction` sends the identity matrix to the identity operator on forms. -/
theorem lambdaAction_one (f : Form) :
    lambdaAction (1 : Matrix (Fin 5) (Fin 5) ℂ) f = f := by
  funext T
  simp [lambdaAction, minorDet_one]

/-- The linear operator attached to the identity matrix is the identity. -/
theorem lambdaLinearMap_one :
    lambdaLinearMap (1 : Matrix (Fin 5) (Fin 5) ℂ) = LinearMap.id := by
  ext f T
  simp [lambdaAction_one]

/-! ## Footprint guard for the harvested nucleus -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction.JR_eq_Cmap_Kmap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms JR_eq_Cmap_Kmap

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction.Kmap_involutive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Kmap_involutive

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction.Cmap_involutive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Cmap_involutive

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction.Kmap_Cmap_comm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Kmap_Cmap_comm

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction.lambdaAction_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lambdaAction_conj

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction.minorDet_empty' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms minorDet_empty

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction.minorDet_card_ne' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms minorDet_card_ne

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction.lambdaAction_eq_sum_filter_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lambdaAction_eq_sum_filter_card

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction.lambdaAction_preserves_card_support' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lambdaAction_preserves_card_support

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction.lambdaAction_add' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lambdaAction_add

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction.lambdaAction_smul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lambdaAction_smul

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction.lambdaLinearMap_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lambdaLinearMap_one

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction.minorDet_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms minorDet_one

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction.lambdaAction_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lambdaAction_one

end PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction
