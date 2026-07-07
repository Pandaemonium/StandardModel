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
minors, and conjugation compatibility for `lambdaAction`.

Claim boundary: this file does not land the finite Cauchy-Binet functor law,
the identity-action theorem, Jacobi complementary minors, determinant cocycle,
or group-level RC0 equivalence. The returned Aristotle proof of that larger
chain is useful but still needs a kernel-clean Cauchy-Binet/identity-minor
integration pass, and the later Jacobi tail still depends on the separate
`gl_fiber` interleaving-sign factorization. In particular, this file does not
claim unimodularity.

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

end PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction
