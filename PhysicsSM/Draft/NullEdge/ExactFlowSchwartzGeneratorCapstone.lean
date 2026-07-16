import PhysicsSM.Draft.NullEdge.PositionDiracSchwartzOperator
import PhysicsSM.Draft.NullEdge.ExactFlowGenerator

/-!
# Generator of the exact Dirac flow on Schwartz spinors (continuum capstone)

Focused Aristotle target `CONT-FOURIER-001`, continuum rung T2-B.  The landed
modules supply three ingredients:

* `ExactFlowSchwartzGroup.exactFlowSchwartzCLM` - the exact momentum-space Dirac
  time group lifted continuously to four-component Schwartz space, together with
  its zero-time / time-addition / inverse laws;
* `ExactFlowGenerator.momMult_apply_hasDerivAt_zero` - the *pointwise in a fixed
  momentum fibre* real-time derivative of the exact matrix multiplier, namely
  right action by the skew-Hermitian fibre generator `fibreGenerator = -i H`;
* `PositionDiracSchwartzOperator.positionDiracSchwartzCLM` together with
  `fourier_positionDiracSchwartzCLM` - the packaged position-space Dirac
  operator in Mathlib's `-I/(2*pi)` Fourier normalization, whose Fourier
  transform is exactly multiplication by the affine matrix symbol `H`.

This module composes them into the strongest *honest* generator/PDE statement
that the current Mathlib calculus API supports:

1. `exactFlowSchwartzCLM_apply_hasDerivAt_zero` - for every Schwartz spinor `g`
   and every momentum `k`, the fibrewise orbit `t \mapsto (exactFlowSchwartzCLM
   m t g) k` is differentiable at `t = 0` with derivative the fibre generator
   acting on `g k` (rung 1).
2. `exactFlowSchwartz_dirac_evolution_pointwise` - the same statement written in
   the physical `-i H` form: this is the free Dirac evolution equation
   `d/dt psi = -i H psi` in the momentum representation, evaluated fibrewise on
   Schwartz data (rung 4, pointwise topology).
3. `fourier_exactFlowSchwartz_generator_pointwise` - Fourier conjugation
   identifies the momentum generator with `-i` times the packaged position-space
   Dirac operator: the fibrewise time-derivative of the transformed flow equals
   the Fourier transform of `-i \cdot positionDiracSchwartzCLM m g` (rung 3).
4. boundary and non-vacuity controls: zero time, zero state, and a concrete
   nonzero fibre-generator action showing the result is not a constant-orbit
   tautology (rung 5).

## Blocked rung and the exact missing Mathlib API (rung 2)

Rung 2 of the mission - lifting the fibrewise `HasDerivAt` to a derivative in
the **Schwartz topology** - is not landed here, and the blocker is a genuine
gap in Mathlib's calculus rather than a proof-search failure.

`HasDerivAt` / `HasFDerivAt` / `fderiv` are defined only for maps valued in a
`NormedSpace`.  `SchwartzMap FourierMomentum3 Spinor` carries the Frechet
(countable-seminorm) topology and has **no** `NormedSpace Complex
SpinorSchwartz` instance, so the statement `HasDerivAt (fun t =>
exactFlowSchwartzCLM m t g) L 0` cannot even be *typed* at the Schwartz-topology
level.

The only stateable substitute is convergence of the Schwartz-space difference
quotient in the Schwartz topology, i.e.

```
Filter.Tendsto
  (fun t : Real => (t⁻¹ : Complex) •
    (exactFlowSchwartzCLM m t g - exactFlowSchwartzCLM m 0 g))
  (nhdsWithin 0 {0}ᶜ)
  (nhds ((-Complex.I) • positionDiracSchwartzCLM m ... ))
```

Its proof needs a lemma of the shape "fibrewise time-derivative with
temperate-growth derivative bound implies convergence of the `bilinLeftCLM`
lifted curve in every Schwartz seminorm" - equivalently, a dominated /
uniform-in-seminorm differentiation theorem for `SchwartzMap`-valued curves.
Mathlib currently provides neither (a) a bornological / Frechet calculus on
`SchwartzMap`, nor (b) a `SchwartzMap.bilinLeftCLM`-specific differentiation
lemma converting fibrewise `HasDerivAt` plus a temperate-growth bound on the
derivative family into Schwartz-seminorm convergence.  That single missing
theorem is the sharply isolated blocker; the fibrewise rungs below hold
unconditionally.

## Scope guard

This file does **not** claim a closed self-adjoint `L2` generator, Stone's
theorem, a changing-lattice limit, interacting dynamics, or Lorentz
restoration.  It distinguishes pointwise-momentum differentiation (proved here)
from Schwartz-topology differentiation (blocked, named above) and from strong
`L2` differentiation (untouched).  Mathlib's Fourier convention and the exact
`-I/(2*pi)` position coefficient are inherited unchanged from the imported
capstones.

Provenance: definitions and immutable theorem statements prepared in-project for
task `CONT-FOURIER-001` on 2026-07-13.  Cross-family semantic review remains
required before manuscript promotion.
-/

noncomputable section

open Matrix Complex
open scoped SchwartzMap

namespace PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGeneratorCapstone

open ChangingCellScaledLiveWalk
open ChangingCellFourierL2
open Compact3Plus1DiracRate
open FourierDiracSchwartzCapstone
open ExactFlowSchwartzGroup
open ExactFlowGenerator
open PositionDiracSchwartzOperator

/-! ## Rung 1: fibrewise generator of the lifted Schwartz flow -/

/-- **Rung 1.** For every Schwartz spinor `g` and every fixed momentum `k`, the
fibrewise orbit `t \mapsto (exactFlowSchwartzCLM m t g) k` has, at `t = 0`,
derivative equal to the skew-Hermitian fibre generator `-i H(k,m)` acting on the
value `g k`.  This is the pointwise-in-momentum infinitesimal generator of the
lifted exact time group. -/
theorem exactFlowSchwartzCLM_apply_hasDerivAt_zero (m : Real) (g : SpinorSchwartz)
    (k : FourierMomentum3) :
    HasDerivAt (fun t : Real => exactFlowSchwartzCLM m t g k)
      (matrixAction (fibreGenerator (k 0) (k 1) (k 2) m) (g k)) 0 := by
  have h := momMult_apply_hasDerivAt_zero m k (g k)
  simpa only [exactFlowSchwartzCLM_apply_apply] using h

/-! ## Rung 4 (pointwise topology): the free Dirac evolution equation -/

/-- **Rung 4, momentum representation.** The same fibrewise derivative written
in the physical form: `d/dt|_{t=0} psi(t,k) = -i H(k,m) psi(0,k)`, the free
Dirac / Schroedinger evolution equation for the exact time group, evaluated on
Schwartz data at each momentum fibre. -/
theorem exactFlowSchwartz_dirac_evolution_pointwise (m : Real) (g : SpinorSchwartz)
    (k : FourierMomentum3) :
    HasDerivAt (fun t : Real => exactFlowSchwartzCLM m t g k)
      ((-Complex.I) • matrixAction (H (k 0) (k 1) (k 2) m) (g k)) 0 := by
  have h := exactFlowSchwartzCLM_apply_hasDerivAt_zero m g k
  have hgen : matrixAction (fibreGenerator (k 0) (k 1) (k 2) m) (g k)
      = (-Complex.I) • matrixAction (H (k 0) (k 1) (k 2) m) (g k) := by
    unfold fibreGenerator matrixAction
    rw [map_smul, ContinuousLinearMap.smul_apply]
  rwa [hgen] at h

/-! ## Rung 3: Fourier conjugation to the position-space Dirac generator -/

/-- **Rung 3.** Fourier conjugation identifies the momentum-space generator with
`-i` times the packaged position-space Dirac operator.  For every Schwartz
spinor `g` and every momentum `w`, the fibrewise time-derivative at `0` of the
transformed flow orbit equals the Fourier transform, evaluated at `w`, of
`-i \cdot positionDiracSchwartzCLM m g`.  This preserves the exact `-I/(2*pi)`
normalization carried by `positionDiracSchwartzCLM`. -/
theorem fourier_exactFlowSchwartz_generator_pointwise (m : Real) (g : SpinorSchwartz)
    (w : FourierMomentum3) :
    HasDerivAt
      (fun t : Real => exactFlowSchwartzCLM m t (SchwartzMap.fourierTransformCLM Complex g) w)
      ((SchwartzMap.fourierTransformCLM Complex
          ((-Complex.I) • positionDiracSchwartzCLM m g)) w) 0 := by
  have h := exactFlowSchwartzCLM_apply_hasDerivAt_zero m
    (SchwartzMap.fourierTransformCLM Complex g) w
  have hfourier := fourier_positionDiracSchwartzCLM m g w
  have e1 : matrixAction (fibreGenerator (w 0) (w 1) (w 2) m)
        ((SchwartzMap.fourierTransformCLM Complex g) w)
      = (-Complex.I) • matrixAction (H (w 0) (w 1) (w 2) m)
          ((SchwartzMap.fourierTransformCLM Complex g) w) := by
    unfold fibreGenerator matrixAction
    rw [map_smul, ContinuousLinearMap.smul_apply]
  rw [e1, ← hfourier] at h
  rw [map_smul, SchwartzMap.smul_apply]
  exact h

/-! ## Rung 5: boundary and non-vacuity controls -/

/-- **Zero-time control.** The lifted flow is the identity at `t = 0` (restated
from `ExactFlowSchwartzGroup`), so every orbit passes through its initial datum
before the generator acts. -/
theorem exactFlowSchwartz_zero_time_control (m : Real) (g : SpinorSchwartz) :
    exactFlowSchwartzCLM m 0 g = g := by
  rw [exactFlowSchwartzCLM_zero_time]
  rfl

/-- **Zero-state control.** The orbit of the zero Schwartz spinor is constant,
so its generator derivative vanishes: the evolution equation is compatible with
the trivial datum. -/
theorem exactFlowSchwartz_zero_state_control (m : Real) (k : FourierMomentum3) :
    HasDerivAt (fun t : Real => exactFlowSchwartzCLM m t (0 : SpinorSchwartz) k)
      (0 : Spinor) 0 := by
  have h := exactFlowSchwartz_dirac_evolution_pointwise m (0 : SpinorSchwartz) k
  simpa using h

/-
**Nonzero generator control.** The generator acts nontrivially: on the rest
fibre `k = 0` with mass `m = 4`, the fibre generator `-i H(0,0,0,4) = -4 i beta`
sends the first spinor basis vector to `-4 i e_0 \ne 0`.  Hence the evolution
theorem is not a constant-orbit tautology - it carries the nonzero mass
coefficient into a genuine nonzero infinitesimal motion.
-/
theorem exactFlowSchwartz_generator_nonzero_control :
    ((-Complex.I) • matrixAction (H 0 0 0 4)
        (EuclideanSpace.single (0 : Fin 4) (1 : Complex))) ≠ 0 := by
  intro h
  have hcomp := congr_arg (fun x : Spinor => x 0) h
  norm_num [matrixAction, H, beta, alpha1, alpha2, alpha3, Matrix.mulVec] at hcomp

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGeneratorCapstone.exactFlowSchwartzCLM_apply_hasDerivAt_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlowSchwartzCLM_apply_hasDerivAt_zero

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGeneratorCapstone.exactFlowSchwartz_dirac_evolution_pointwise' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlowSchwartz_dirac_evolution_pointwise

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGeneratorCapstone.fourier_exactFlowSchwartz_generator_pointwise' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_exactFlowSchwartz_generator_pointwise

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGeneratorCapstone.exactFlowSchwartz_zero_time_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlowSchwartz_zero_time_control

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGeneratorCapstone.exactFlowSchwartz_zero_state_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlowSchwartz_zero_state_control

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGeneratorCapstone.exactFlowSchwartz_generator_nonzero_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlowSchwartz_generator_nonzero_control

end PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGeneratorCapstone
