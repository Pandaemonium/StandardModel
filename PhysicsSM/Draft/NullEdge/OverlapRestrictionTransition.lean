import Mathlib

/-!
# Basis-free transitions from overlap restrictions

This module isolates the exact linear-algebra bridge needed after a protected-
core atlas exists. Let two local probe spaces restrict into one common overlap
observation space. If both restriction maps are injective and have the same
image, their ratio determines a unique linear equivalence between the local
spaces. No basis or preferred tetrad is selected.

If both local bilinear forms are pullbacks of one form on the common image, the
derived transition is exactly isometric. Three compatible restriction maps
give an exact transition cocycle. A rational one-dimensional witness shows
that the derived transition can be nonidentity.

For the null-edge program, the intended observation space is a scalar-field
space on a genuine protected-core overlap, and the local spaces are candidate
rank-four graph-derived probe spaces. Injectivity, equal images, Lorentzian
inertia, and refinement convergence remain open gates. This module does not
construct those inputs, a tetrad, a spin lift, curvature, or GR dynamics.
Claim grade: `M [orig]` for the conditional finite identities.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.OverlapRestrictionTransition

variable {R M N P O : Type*} [CommSemiring R]
  [AddCommMonoid M] [Module R M]
  [AddCommMonoid N] [Module R N]
  [AddCommMonoid P] [Module R P]
  [AddCommMonoid O] [Module R O]

/-- The basis-free transition induced by two injective overlap restrictions
with equal image. -/
def overlapTransition
    (f : M →ₗ[R] O) (g : N →ₗ[R] O)
    (hf : Function.Injective f) (hg : Function.Injective g)
    (hrange : LinearMap.range f = LinearMap.range g) : M ≃ₗ[R] N :=
  (LinearEquiv.ofInjective f hf).trans
    ((LinearEquiv.ofEq (LinearMap.range f) (LinearMap.range g) hrange).trans
      (LinearEquiv.ofInjective g hg).symm)

/-- The derived transition is characterized by equality of overlap
observations. -/
theorem overlapTransition_spec
    (f : M →ₗ[R] O) (g : N →ₗ[R] O)
    (hf : Function.Injective f) (hg : Function.Injective g)
    (hrange : LinearMap.range f = LinearMap.range g) (x : M) :
    g (overlapTransition f g hf hg hrange x) = f x := by
  simp [overlapTransition]

/-- Injectivity of the target restriction makes the overlap transition unique.
This is the precise sense in which no additional frame choice is needed once
the two overlap images agree. -/
theorem overlapTransition_unique
    (f : M →ₗ[R] O) (g : N →ₗ[R] O)
    (hf : Function.Injective f) (hg : Function.Injective g)
    (hrange : LinearMap.range f = LinearMap.range g)
    (T : M →ₗ[R] N) (hT : forall x, g (T x) = f x) :
    T = (overlapTransition f g hf hg hrange).toLinearMap := by
  ext x
  apply hg
  rw [hT x]
  exact (overlapTransition_spec f g hf hg hrange x).symm

/-- Pull a bilinear form on the overlap observation space back to one local
probe space. -/
def pulledForm
    (B : LinearMap.BilinForm R O) (f : M →ₗ[R] O) :
    LinearMap.BilinForm R M :=
  B.comp f f

/-- Two local forms pulled back from the same overlap form are related by an
exact isometry under the derived transition. -/
theorem overlapTransition_isometry
    (B : LinearMap.BilinForm R O)
    (f : M →ₗ[R] O) (g : N →ₗ[R] O)
    (hf : Function.Injective f) (hg : Function.Injective g)
    (hrange : LinearMap.range f = LinearMap.range g) (x y : M) :
    pulledForm B g (overlapTransition f g hf hg hrange x)
        (overlapTransition f g hf hg hrange y) =
      pulledForm B f x y := by
  simp [pulledForm, overlapTransition_spec]

/-- Three local probe spaces with compatible common overlap images give the
exact Cech transition cocycle. Equality is proved in the observation space,
so it is independent of bases and equality-proof representatives. -/
theorem overlapTransition_cocycle
    (f : M →ₗ[R] O) (g : N →ₗ[R] O) (h : P →ₗ[R] O)
    (hf : Function.Injective f) (hg : Function.Injective g)
    (hh : Function.Injective h)
    (hfg : LinearMap.range f = LinearMap.range g)
    (hgh : LinearMap.range g = LinearMap.range h)
    (hfh : LinearMap.range f = LinearMap.range h) :
    (overlapTransition f g hf hg hfg).trans
        (overlapTransition g h hg hh hgh) =
      overlapTransition f h hf hh hfh := by
  ext x
  apply hh
  change h (overlapTransition g h hg hh hgh
      (overlapTransition f g hf hg hfg x)) =
    h (overlapTransition f h hf hh hfh x)
  rw [overlapTransition_spec g h hg hh hgh]
  rw [overlapTransition_spec f g hf hg hfg]
  rw [overlapTransition_spec f h hf hh hfh]

/-! ## Nonidentity rational witness -/

/-- Rational scaling by two as a linear equivalence. -/
def scalarDoubleEquiv : ℚ ≃ₗ[ℚ] ℚ where
  toFun x := 2 * x
  invFun x := x / 2
  map_add' x y := by ring
  map_smul' c x := by simp; ring
  left_inv x := by ring
  right_inv x := by ring

/-- Identity and double-scaling restrictions have the same image. -/
theorem scalarRange_eq :
    LinearMap.range (LinearEquiv.refl ℚ ℚ).toLinearMap =
      LinearMap.range scalarDoubleEquiv.toLinearMap := by
  rw [LinearEquiv.range, LinearEquiv.range]

/-- Equal overlap images do not force the transition to be the identity. With
identity observations on one side and doubled observations on the other, the
unique transition rescales by one half. -/
theorem scalarTransition_nonidentity :
    overlapTransition
        (LinearEquiv.refl ℚ ℚ).toLinearMap
        scalarDoubleEquiv.toLinearMap
        (LinearEquiv.refl ℚ ℚ).injective
        scalarDoubleEquiv.injective scalarRange_eq ≠
      LinearEquiv.refl ℚ ℚ := by
  intro heq
  have hspec := overlapTransition_spec
    (LinearEquiv.refl ℚ ℚ).toLinearMap
    scalarDoubleEquiv.toLinearMap
    (LinearEquiv.refl ℚ ℚ).injective
    scalarDoubleEquiv.injective scalarRange_eq (1 : ℚ)
  rw [heq] at hspec
  norm_num [scalarDoubleEquiv] at hspec

end PhysicsSM.Draft.NullEdge.OverlapRestrictionTransition

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.OverlapRestrictionTransition.overlapTransition_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.OverlapRestrictionTransition.overlapTransition_unique

/-- info: 'PhysicsSM.Draft.NullEdge.OverlapRestrictionTransition.overlapTransition_isometry' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.OverlapRestrictionTransition.overlapTransition_isometry

/-- info: 'PhysicsSM.Draft.NullEdge.OverlapRestrictionTransition.overlapTransition_cocycle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.OverlapRestrictionTransition.overlapTransition_cocycle

/-- info: 'PhysicsSM.Draft.NullEdge.OverlapRestrictionTransition.scalarTransition_nonidentity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.OverlapRestrictionTransition.scalarTransition_nonidentity
