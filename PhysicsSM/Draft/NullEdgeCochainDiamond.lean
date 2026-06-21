import PhysicsSM.Draft.NullEdgeDiamondNonabelian

/-!
# Draft.NullEdgeCochainDiamond

Two finite follow-up theorem islands for the null-edge causal graph program.

1. Non-Abelian causal-diamond defects are not themselves gauge invariant, but
   any class function of the defect is gauge invariant.
2. The order-complex boundary theorem in `NullEdgeCoreAristotle` dualizes to a
   coboundary operator on integral cochains with `delta^2 = 0`.

These are finite algebraic/combinatorial statements.  They do not claim a
continuum Stokes theorem or a continuum Dirac operator.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeCochainDiamond

open PhysicsSM.Draft.NullEdgeCore
open PhysicsSM.Draft.NullEdgeDiamondNonabelian

/-! ## Class functions of non-Abelian diamond defects -/

variable {G A : Type*}

/-- A class function is constant on conjugacy classes. -/
def IsClassFunction [Group G] (F : G -> A) : Prop :=
  ∀ g x : G, F (g⁻¹ * x * g) = F x

/--
Any class function of the non-Abelian diamond defect is gauge invariant.

This is the finite graph version of taking a trace of a plaquette holonomy in
a non-Abelian lattice gauge theory.
-/
theorem diamondDefect_classFunction_gauge_invariant [Group G]
    (F : G -> A) (hF : IsClassFunction F)
    (g : DiamondGauge G) (U : DiamondLabels G) :
    F (diamondDefect (gaugeTransformDiamond g U)) = F (diamondDefect U) := by
  rw [diamondDefect_gauge_covariant]
  exact hF g.top (diamondDefect U)

/-! ## Cochains dual to the formal order-complex boundary -/

/-- The formal chain boundary as an additive homomorphism. -/
def chainBoundaryAddHom {V : Type*} : Chain V →+ Chain V where
  toFun := chainBoundary
  map_zero' := chainBoundary_zero
  map_add' := chainBoundary_add

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

/--
Order-complex/Kähler-Dirac seed theorem: the cochain coboundary squares to
zero because the chain boundary squares to zero.
-/
theorem cochainCoboundary_comp_self_eq_zero {V : Type*}
    (f : IntegralCochain V) :
    cochainCoboundary (cochainCoboundary f) = 0 := by
  apply AddMonoidHom.ext
  intro c
  change f (chainBoundary (chainBoundary c)) = 0
  rw [chainBoundary_comp_self_eq_zero]
  exact map_zero f

end PhysicsSM.Draft.NullEdgeCochainDiamond

end
