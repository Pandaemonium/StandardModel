/-
# The free-case §3↔§4 bridge: the free mass operator IS the kinematic mass

DRAFT (kernel-clean; no `s o r r y`). Roadmap item **T3a / crux 0b(a)**: the
free-case half of the §3↔§4 bridge. The full interacting bridge splits (the
interacting discrepancy is the `Delta` binding-defect candidate,
`DELTA_BINDING_ENERGY_FINDING.md`); the FREE case is a clean identity, landed
here.

For the bundle momentum `P = sum_i psi_i psi_i^dagger` (the §3 object, here the
two-edge `twoEdgeMomentum`), the *free mass operator* is `P * adjugate P`. By the
`2x2` adjugate identity it equals `det(P) • 1`, and `det P` is the kinematic
Plücker mass `|psi ^ phi|^2` (the trusted `two_edge_plucker_mass_identity`). So
the free mass operator is a **scalar equal to the §3 kinematic mass**, and its
least eigenvalue is `det P`. This is the finite Clifford/Pauli mass-shell: the
slash-square of the total momentum is the invariant mass squared times the
identity - the honest free-case statement that "the operator mass IS the
kinematic mass" (numerically validated, `Scripts/oracle/probe_t3a_free_bridge.py`).

Note: this pins the FREE-case bridge only. The interacting bridge (nonflat
carriers) fails by the `Delta` binding defect - which is the physically correct
outcome (bound-state mass is not additive), not a gap.

## Provenance

Roadmap T3a; all-mass overnight run 2026-07-08 [orig]. Builds on the trusted
`PhysicsSM.Spinor.PluckerMass` and `Matrix.mul_adjugate` [import].
-/

import Mathlib
import PhysicsSM.Spinor.PluckerMass

namespace PhysicsSM.Draft.NullEdge.Carrier.FreeMassBridge

open Matrix PhysicsSM.Spinor.PluckerMass

/-- **The free mass operator is a scalar (the adjugate identity).** For any `2x2`
momentum `P`, `P * adjugate P = det P • 1`. -/
theorem massOp_eq_det_smul (P : Matrix (Fin 2) (Fin 2) ℂ) :
    P * P.adjugate = P.det • (1 : Matrix (Fin 2) (Fin 2) ℂ) :=
  Matrix.mul_adjugate P

/-- **The free §3↔§4 bridge.** The free mass operator of a two-edge null bundle
equals the kinematic Plücker mass `|psi ^ phi|^2` times the identity - the
operator mass IS the §3 kinematic mass in the free case. -/
theorem free_mass_operator_eq_plucker (psi phi : CSpinor) :
    (twoEdgeMomentum psi phi) * (twoEdgeMomentum psi phi).adjugate
      = (complexAbsSq (spinorWedge psi phi)) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  rw [Matrix.mul_adjugate, two_edge_plucker_mass_identity]

/-- **Massless free control.** A single null edge (rank-one momentum) has free
mass operator zero: `det = 0` so `P * adjugate P = 0`. -/
theorem free_mass_operator_single_eq_zero (psi : CSpinor) :
    (rankOneHermitian psi) * (rankOneHermitian psi).adjugate = 0 := by
  rw [Matrix.mul_adjugate, det_rankOneHermitian_eq_zero]; simp

/-! ## Local axiom guard (self-contained; not yet wired into CarrierAxiomGuard,
which is under concurrent edit) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FreeMassBridge.free_mass_operator_eq_plucker' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms free_mass_operator_eq_plucker

end PhysicsSM.Draft.NullEdge.Carrier.FreeMassBridge
