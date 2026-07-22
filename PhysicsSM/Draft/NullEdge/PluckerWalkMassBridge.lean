import PhysicsSM.Draft.NullEdge.HNUResolventDomainBridge
import PhysicsSM.Spinor.PluckerMass

/-!
# Joining the kinematic and dynamical mass concepts, under the Pluecker identification

This program carries **two different notions of mass**, developed in separate lanes,
and until now nothing connected them:

1. **Kinematic (Pluecker) mass.** The trusted finite theorem
   `PhysicsSM.Spinor.PluckerMass.two_edge_plucker_mass_identity`: the determinant of a
   sum of rank-one null momenta is the squared modulus of the spinor wedge,
   `det (psi psi^dag + phi phi^dag) = |psi ^ phi|^2`. This is the invariant mass of an
   assembled system of lightlike constituents - the P1 manuscript's single theorem,
   "mass is the geometry of light that cannot agree on a direction".
2. **Dynamical (spectral) mass.** The mass parameter `z` of the live `3+1` massive Dirac
   walk, whose symbol satisfies the exact relativistic square
   `H4(k, z)^2 = (|k|^2 + normSq z) I` and whose resolvent denominator is the mass
   shell `|q|^2 + normSq z + 1`.

These are conceptually distinct: (1) is a property of a *momentum configuration*, (2) is
a property of an *operator's spectrum*. In continuum physics they are joined by the
mass-shell condition - the propagator pole sits at `p^2 = m^2`. This module proves the
finite version of exactly that join.

The observation is that `Pluecker3Plus1ComplexMass` already takes its mass parameter to
be *the complex Pluecker coordinate*, so the two masses are the same number by
construction - but that was never stated as a theorem, and a definitional coincidence
that no theorem records is exactly the kind of connection that silently rots. Here it is
recorded:

* `pluckerDet_eq_ofReal_normSq_wedge` - the Pluecker determinant is the real squared
  modulus of the wedge, as a complex scalar.
* `H4_sq_eq_momentumSq_add_pluckerDet` - **the headline.** Feeding the spinor wedge of
  two null edges in as the walk's mass parameter, the Dirac square is exactly
  `|k|^2 + det (two-edge Pluecker momentum)`. Note this is a SPECIALIZATION: the walk's
  mass `z` is a free parameter, and the theorem says the two masses agree *under the
  identification* `z = psi ^ phi`, not that the walk's mass must be a Pluecker mass.
* `walk_massless_iff_edges_parallel` - the walk is massless exactly when the two null
  edges are parallel (`psi ^ phi = 0`), matching the P1 massless criterion.
* `resolvent_bound_governed_by_pluckerMass` - the fibre resolvent estimate of
  `HNUResolventDomainBridge` becomes
  `(1 + normSq (psi ^ phi)) * norm (R v)^2 <= norm v^2`: **the dynamical spectral
  stand-off of the resolvent is set by the kinematic Pluecker mass.**

## Scope, stated so this does not outrun the kernel

These are finite algebraic identities in one fixed Clifford representation. They say the
two mass notions *coincide in this model*, because the model was built that way; they do
NOT derive either notion from the other, do not establish a mass-shell theorem for a
general operator, and do not predict any mass value. What they buy is that the origin-of-
mass lane and the `3+1` walk lane are demonstrably about the same quantity rather than
two things sharing a name - which is a prerequisite for any joint claim, and was
previously supported only by prose.

Provenance: clean-room composition of the trusted `PhysicsSM.Spinor.PluckerMass`
(two-edge identity), `Pluecker3Plus1ComplexMass.H4_sq` (Codex/Aristotle), and
`HNUResolventDomainBridge` (Opus, 2026-07-21). Claim grade `M`, `[orig]` for the join.
-/

noncomputable section

open Matrix Complex
open scoped Matrix.Norms.L2Operator

set_option autoImplicit false

namespace PhysicsSM.Draft.NullEdge.PluckerWalkMassBridge

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent
open PhysicsSM.Draft.NullEdge.HNUResolventDomainBridge
open PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

/-! ## The mass identification -/

/-- The two-edge Pluecker determinant, as the complex coercion of a real squared
modulus. This is the form in which it meets the walk's mass parameter. -/
theorem pluckerDet_eq_ofReal_normSq_wedge (psi phi : Fin 2 → ℂ) :
    (twoEdgeMomentum psi phi).det =
      ((Complex.normSq (spinorWedge psi phi) : ℝ) : ℂ) := by
  rw [two_edge_plucker_mass_identity, complexAbsSq_eq_ofReal_normSq]

/-- **The walk's mass shell is the Pluecker mass.** With the spinor wedge of two null
edges as the mass parameter, the mass-shell scalar is the spatial momentum square plus
the two-edge Pluecker determinant. -/
theorem massShellSq_eq_momentumSq_add_pluckerDet (psi phi : Fin 2 → ℂ)
    (q : Fin 3 → ℝ) :
    ((massShellSq (spinorWedge psi phi) q : ℝ) : ℂ) =
      ((q 0 ^ 2 + q 1 ^ 2 + q 2 ^ 2 : ℝ) : ℂ) + (twoEdgeMomentum psi phi).det := by
  rw [pluckerDet_eq_ofReal_normSq_wedge]
  unfold massShellSq
  push_cast
  ring

/-- **HEADLINE: setting the walk's mass parameter to the two-edge spinor wedge makes the
Dirac square exactly `|k|^2 + det P`**, where `det P` is the determinant mass of the
summed null momenta - the trusted P1 quantity.

PRECISION (self-audit, 2026-07-21): the walk's mass `z` is a FREE PARAMETER of `H4`, and
nothing in the dynamics forces it to be a spinor wedge. This theorem is a
SPECIALIZATION, not a derivation: it says that *under the identification* `z = psi ^ phi`
- which is what `Pluecker3Plus1ComplexMass` intends by naming `z` the Pluecker
coordinate - the dynamical mass shell and the kinematic Pluecker mass are the same
number. Do not paraphrase this as "the walk's mass is necessarily the Pluecker mass". -/
theorem H4_sq_eq_momentumSq_add_pluckerDet (kx ky kz : ℝ) (psi phi : Fin 2 → ℂ) :
    H4 kx ky kz (spinorWedge psi phi) * H4 kx ky kz (spinorWedge psi phi) =
      (((kx ^ 2 + ky ^ 2 + kz ^ 2 : ℝ) : ℂ) + (twoEdgeMomentum psi phi).det) •
        (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  rw [H4_sq, pluckerDet_eq_ofReal_normSq_wedge]
  congr 1
  push_cast
  ring

/-- **The walk is massless exactly when the two null edges are parallel.** This is the
P1 massless criterion, transported to the dynamical side: the walk's mass parameter
vanishes iff the spinor wedge does. -/
theorem walk_massless_iff_edges_parallel (psi phi : Fin 2 → ℂ) :
    (twoEdgeMomentum psi phi).det = 0 ↔ spinorWedge psi phi = 0 := by
  rw [two_edge_plucker_mass_identity]
  exact complexAbsSq_eq_zero_iff _

/-! ## The consequence for the resolvent -/

/-- **The dynamical stand-off is set by the kinematic mass.** Specializing the fibre
resolvent estimate of `HNUResolventDomainBridge` to a wedge mass, the uniform bound is
governed by `1 + normSq (psi ^ phi)`, i.e. by the two-edge Pluecker mass. The resolvent
of the walk sees exactly the mass that the null-edge geometry supplies. -/
theorem resolvent_bound_governed_by_pluckerMass (psi phi : Fin 2 → ℂ)
    (q : Fin 3 → ℝ) (v : EuclideanSpace ℂ (Fin 4)) :
    (1 + Complex.normSq (spinorWedge psi phi)) *
        ‖act (minusShiftInverse (spinorWedge psi phi) q) v‖ ^ 2 ≤ ‖v‖ ^ 2 :=
  minusShiftInverse_mass_gap_bound (spinorWedge psi phi) q v

/-- Parallel null edges give the massless resolvent bound: the estimate degenerates to
the plain contraction bound exactly in the massless case. -/
theorem resolvent_bound_massless_case (psi phi : Fin 2 → ℂ)
    (hparallel : spinorWedge psi phi = 0) (q : Fin 3 → ℝ) (v : EuclideanSpace ℂ (Fin 4)) :
    ‖act (minusShiftInverse (spinorWedge psi phi) q) v‖ ^ 2 ≤ ‖v‖ ^ 2 := by
  have h := resolvent_bound_governed_by_pluckerMass psi phi q v
  rw [hparallel] at h ⊢
  simpa using h

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerWalkMassBridge.H4_sq_eq_momentumSq_add_pluckerDet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms H4_sq_eq_momentumSq_add_pluckerDet

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerWalkMassBridge.walk_massless_iff_edges_parallel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms walk_massless_iff_edges_parallel

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerWalkMassBridge.resolvent_bound_governed_by_pluckerMass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms resolvent_bound_governed_by_pluckerMass

end PhysicsSM.Draft.NullEdge.PluckerWalkMassBridge
