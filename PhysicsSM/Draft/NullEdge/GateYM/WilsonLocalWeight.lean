import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.WilsonWeightPositivity
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteEnsemble

/-!
# Gate YM0/YM3: the Wilson local weight is a class function

Connecting tissue between T1's kernel-PSD engine
(`WilsonWeightPositivity.lean`) and T3's finite ensemble skeleton
(`PlaquetteCore.lean` / `PlaquetteEnsemble.lean`): the local Wilson weight
`exp(beta * Re chi(h))` (freeze C-4) is exactly the class-function
`localWeight : G -> R` that `PlaquetteEnsemble.weight_gauge` and its
descendants need. This module supplies that fact and instantiates the
ensemble-level gauge-invariance theorems at the concrete Wilson weight,
so the finite plaquette-product ensemble is now gauge invariant for an
ACTUAL physical weight, not just an abstract placeholder.

Key observation: the class-function property of `reChar` needs NO
unitarity. `reChar rho (a * h * a^{-1}) = reChar rho h` follows from
`rho (a h a^{-1}) = rho a * rho h * rho a^{-1}` (multiplicativity) and
trace cyclicity/conjugation-invariance alone
(`Matrix.trace_mul_comm`-style bookkeeping) - unitarity is a separate
hypothesis needed elsewhere (for PSD of the kernel, in
`WilsonWeightPositivity.lean`), not for this fact.
The inversion symmetry of the Wilson local weight, by contrast, does use
unitarity and is recorded separately as `wilsonLocalWeight_inv_of_unitary`.

This does NOT yet define a reflection plane, cut structure, or transfer
matrix - it makes the EXISTING finite ensemble skeleton gauge invariant
for the real Wilson weight, one step closer to a genuine RP-LINK
statement once the reflection/cut layer exists.

Draft-trust: kernel-checked, no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity**. Prerequisites:
`GateYM.WilsonWeightPositivity`, `GateYM.PlaquetteEnsemble`.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace WilsonLocalWeight

open scoped Matrix

open GaugeCoreGeneral
open PlaquetteCore

variable {G : Type*}
variable {n : ℕ}

/-- The Wilson local weight `exp(beta * Re chi(h))` (freeze C-4), read off
`WilsonWeightPositivity.reChar`. -/
noncomputable def wilsonLocalWeight (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (h : G) : ℝ :=
  Real.exp (beta * WilsonWeightPositivity.reChar rho h)

/-- The Wilson local weight is a class function: it is invariant under
conjugation of its argument. Needs only multiplicativity of `rho`, NOT
unitarity - trace is conjugation-invariant for any representation. -/
theorem wilsonLocalWeight_class (beta : ℝ)
    [Group G]
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (a h : G) :
    wilsonLocalWeight beta rho (a * h * a⁻¹) = wilsonLocalWeight beta rho h := by
  have hrho : rho (a * h * a⁻¹) = (rho a * rho h) * rho a⁻¹ := by
    rw [hmul, hmul]
  have hinv : rho a⁻¹ * rho a = 1 := by rw [← hmul, inv_mul_cancel, hone]
  have htrace : Matrix.trace (rho (a * h * a⁻¹)) = Matrix.trace (rho h) := by
    calc
      Matrix.trace (rho (a * h * a⁻¹))
          = Matrix.trace ((rho a * rho h) * rho a⁻¹) := by rw [hrho]
      _ = Matrix.trace (rho a⁻¹ * (rho a * rho h)) := Matrix.trace_mul_comm _ _
      _ = Matrix.trace (rho h) := by
        rw [← mul_assoc, hinv, one_mul]
  unfold wilsonLocalWeight WilsonWeightPositivity.reChar
  rw [htrace]

/-- For a unitary representation, the Wilson local weight is invariant under
group inversion. This packages `WilsonWeightPositivity.reChar_inv_of_unitary`
at the real-exponential weight level and is a prerequisite for later
orientation/opposite-group compatibility arguments. -/
theorem wilsonLocalWeight_inv_of_unitary (beta : ℝ)
    [Group G]
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (g : G) :
    wilsonLocalWeight beta rho g⁻¹ = wilsonLocalWeight beta rho g := by
  unfold wilsonLocalWeight
  rw [WilsonWeightPositivity.reChar_inv_of_unitary rho hmul hone hunit]

/-- The Wilson-weighted finite plaquette product is gauge invariant. -/
theorem wilsonWeight_gauge {ι : Type*} [Fintype ι]
    [Group G]
    {Λ : GaugeCoreGeneral.OrientedLattice} (P : ι → Plaquette Λ)
    (beta : ℝ) (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (g : Λ.V → G) (U : Λ.LinkField (G := G)) :
    PlaquetteEnsemble.weight P (wilsonLocalWeight beta rho) (Λ.gauge g U)
      = PlaquetteEnsemble.weight P (wilsonLocalWeight beta rho) U :=
  PlaquetteEnsemble.weight_gauge P (wilsonLocalWeight beta rho)
    (wilsonLocalWeight_class beta rho hmul hone) g U

/-- The Wilson-weighted finite plaquette-ensemble expectation is invariant
under applying a fixed gauge transformation to the observable alone. -/
theorem wilsonExpectation_observable_comp_gauge {ι : Type*} [Fintype ι]
    [Group G]
    {Λ : GaugeCoreGeneral.OrientedLattice} [Fintype (Λ.LinkField (G := G))]
    (P : ι → Plaquette Λ)
    (beta : ℝ) (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (g : Λ.V → G) (observable : Λ.LinkField (G := G) → ℝ) :
    PlaquetteEnsemble.expectation P (wilsonLocalWeight beta rho)
        (fun U => observable (Λ.gauge g U))
      = PlaquetteEnsemble.expectation P (wilsonLocalWeight beta rho) observable :=
  PlaquetteEnsemble.expectation_observable_comp_gauge P (wilsonLocalWeight beta rho)
    (wilsonLocalWeight_class beta rho hmul hone) g observable

/-- The Wilson weight is strictly positive (it is a real exponential), so
the ensemble partition function is strictly positive for any nonempty
finite lattice. -/
theorem wilsonLocalWeight_pos (beta : ℝ) (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (h : G) : 0 < wilsonLocalWeight beta rho h :=
  Real.exp_pos _

/-- The Wilson finite plaquette-product ensemble has a strictly positive
partition function. -/
theorem wilsonPartition_pos {ι : Type*} [Fintype ι] [Group G]
    {Λ : GaugeCoreGeneral.OrientedLattice} [Fintype (Λ.LinkField (G := G))]
    (P : ι → Plaquette Λ)
    (beta : ℝ) (rho : G → Matrix (Fin n) (Fin n) ℂ) :
    0 < PlaquetteEnsemble.partition P (wilsonLocalWeight beta rho) :=
  PlaquetteEnsemble.partition_pos P (wilsonLocalWeight beta rho)
    (wilsonLocalWeight_pos beta rho)

end WilsonLocalWeight
end GateYM
end NullEdge
end Draft
end PhysicsSM
