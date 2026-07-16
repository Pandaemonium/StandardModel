import Mathlib

/-!
# Aristotle target: deterministic decoration invariance iff equivariance

This target upgrades the finite decoration counterexample into an exact
classification. For a full-support base PMF invariant under an equivalence,
the graph-decorated joint law is invariant under the product action if and
only if the deterministic decoration is equivariant.

The theorem is abstract and distributional. It does not construct a Lorentz
group action, an infinite-volume point process, or a physical frame field.
-/

noncomputable section

open Set

namespace PhysicsSM.Draft.NullEdge.DeterministicDecorationEquivariance

variable {X M : Type*}

/-- Graph support of a deterministic decoration. -/
def decorationGraph (d : X -> M) : Set (X × M) :=
  Set.range fun x => (x, d x)

/-- Product action on an object and its mark. -/
def productAction (T : X ≃ X) (S : M ≃ M) : X × M -> X × M :=
  fun q => (T q.1, S q.2)

/-- Graph-support invariance is exactly equivariance of the decoration. -/
theorem decorationGraph_invariant_iff_equivariant
    (T : X ≃ X) (S : M ≃ M) (d : X -> M) :
    productAction T S '' decorationGraph d = decorationGraph d ↔
      ∀ x, d (T x) = S (d x) := by
  constructor
  · intro h x
    have hmem : (T x, S (d x)) ∈ decorationGraph d := by
      rw [← h]; exact ⟨(x, d x), ⟨x, rfl⟩, rfl⟩
    obtain ⟨y, hy⟩ := hmem
    have h1 : y = T x := (Prod.ext_iff.mp hy).1
    have h2 : d y = S (d x) := (Prod.ext_iff.mp hy).2
    rw [← h1]; exact h2
  · intro hd
    ext q
    constructor
    · rintro ⟨p, ⟨x, rfl⟩, rfl⟩
      exact ⟨T x, by simp [productAction, hd x]⟩
    · rintro ⟨y, rfl⟩
      have hval : S (d (T.symm y)) = d y := by
        rw [← hd (T.symm y), Equiv.apply_symm_apply]
      exact ⟨(T.symm y, d (T.symm y)), ⟨T.symm y, rfl⟩, by simp [productAction, hval]⟩

/-- Joint law obtained by attaching a deterministic mark. -/
def decoratedLaw (p : PMF X) (d : X -> M) : PMF (X × M) :=
  p.map fun x => (x, d x)

/-- Equivariance and invariance of the base law imply invariance of the
decorated joint law. -/
theorem decoratedLaw_invariant_of_equivariant
    (p : PMF X) (T : X ≃ X) (S : M ≃ M) (d : X -> M)
    (hp : p.map T = p) (hd : ∀ x, d (T x) = S (d x)) :
    (decoratedLaw p d).map (productAction T S) = decoratedLaw p d := by
  calc (decoratedLaw p d).map (productAction T S)
      = p.map (fun x => (T x, d (T x))) := by
        unfold decoratedLaw productAction
        rw [PMF.map_comp]
        congr 1; funext x; simp [hd x]
    _ = (p.map T).map (fun y => (y, d y)) := by rw [PMF.map_comp]; rfl
    _ = decoratedLaw p d := by rw [hp]; rfl

/-- **Classification capstone.** For a full-support invariant base PMF,
invariance of the deterministic graph-decorated law is equivalent to
equivariance of the mark. -/
theorem decoratedLaw_invariant_iff_equivariant
    (p : PMF X) (T : X ≃ X) (S : M ≃ M) (d : X -> M)
    (hp : p.map T = p) (hfull : p.support = Set.univ) :
    (decoratedLaw p d).map (productAction T S) = decoratedLaw p d ↔
      ∀ x, d (T x) = S (d x) := by
  constructor
  · intro h
    rw [← decorationGraph_invariant_iff_equivariant T S d]
    have hsupp : (decoratedLaw p d).support = decorationGraph d := by
      unfold decoratedLaw
      rw [PMF.support_map, hfull, Set.image_univ]; rfl
    have hc := congrArg PMF.support h
    rw [PMF.support_map, hsupp] at hc
    exact hc
  · intro hd
    exact decoratedLaw_invariant_of_equivariant p T S d hp hd

/-- Constant-mark control when the chosen mark is fixed by the mark action. -/
theorem decoratedLaw_const_invariant
    (p : PMF X) (T : X ≃ X) (S : M ≃ M) (m : M)
    (hp : p.map T = p) (hm : S m = m) :
    (decoratedLaw p fun _ => m).map (productAction T S) =
      decoratedLaw p fun _ => m := by
  apply decoratedLaw_invariant_of_equivariant p T S (fun _ => m) hp
  intro x
  simpa using hm.symm

end PhysicsSM.Draft.NullEdge.DeterministicDecorationEquivariance
