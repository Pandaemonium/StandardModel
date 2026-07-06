import PhysicsSM.Draft.NullEdge.GateI1.Core
import PhysicsSM.Draft.NullEdge.GateI1.MassCoinBridge
import PhysicsSM.Draft.NullEdge.GateI1.MassEntropyDictionary
import PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
import PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass
import PhysicsSM.Draft.NullEdge.GateI1.PluckerUnificationBridge
import PhysicsSM.Draft.NullEdge.GateI1.SharedSpinorModule
import PhysicsSM.Draft.NullEdge.GateI1.ColorBlindMass
import PhysicsSM.Draft.NullEdge.GateI1.ColorBlindMassOrbit
import PhysicsSM.Draft.NullEdge.GateI1.ChargeGradingMassCompatible
import PhysicsSM.Draft.NullEdge.GateI1.MassTaxonomySeparation
import PhysicsSM.Draft.NullEdge.GateI1.ElectroweakRung
import PhysicsSM.Draft.NullEdge.GateI1.ApertureEqualsTurn
import PhysicsSM.Draft.NullEdge.GateI1.UnificationCapstone

/-!
# Gate I1 aggregator: finite kinematic dictionary

This is a pure import aggregator for the Gate I1 draft tree.  It currently
collects the Mathlib-only core port from the overnight standalone staging file:
Pauli/Hermitian soldering, the future-cone PSD dictionary, rank-one/null
factorization, the 2-edge Pluecker mass identity, normalized determinant
dictionary, first-order Weyl-block bridge, finite faithfulness shadow,
boost-Gibbs algebra, determinant superadditivity, determinant-line clock, and
the finite `U(2)` spin-clock split algebra; plus the P1/P2 no-double-counting
bridge and null-step walk coherence suite (`MassCoinBridge`); plus the I1.8
mass -> von Neumann entropy dictionary (`MassEntropyDictionary`: eigenvalue
ordering of the normalized block, its binary entropy, and the "null edges do
not age" theorem `vonNeumannEntropy = 0 <-> minkowskiSq = 0`, with the
observer-conditioned frame caveat); plus the NE-U1 composite aperture mass
keystone (`CompositeApertureMass`: `minkDot` polarization/double-sum layer,
reverse Cauchy-Schwarz on the future light cone with its equality case, and
the headline `compositeMassSq_eq_zero_iff_collinear` - a composite of null
constituents is massless iff it points along one null direction - with the
two-body Plucker bridge `det (minkHerm (p + q)) = 2 * minkDot p q`); plus the
NE-U5 "mass without mass" crown (`MassWithoutMass`: the pure-gauge Z2
single-plaquette transfer operator `transfer2`, its explicit eigenvectors and
strictly positive glueball gap `z2GlueballMass_pos` = `log coth beta > 0`, and
the headline `massWithoutMass` - `quarkMassParameter = 0` yet the gap is
strictly positive, a category-(3) closure mass with zero primitive mass input;
design provenance Aristotle `d1e7bece`, independently re-verified); plus the
octonion / null-edge unification bridges (`SharedSpinorModule`: the
structural spacetime (x) internal factorization with its honestly-vacuous
commutativity; `ColorBlindMass` / `ColorBlindMassOrbit`: the red-team audit's
decisive "colored mass" test, resolved on the co-location side - the octonion
color factor enters a mass only through the `SU(3)`-invariant norm, so the mass
is color-blind on the three basis states AND on every `SU(3)` orbit of the whole
fundamental rep; `UnificationCapstone`: the bundled 1a/1b/Furey/B0 conjunction,
labeled co-location not coupling per the audit).

It lets the current I1 draft stack be kernel-checked in one command:

    lake build PhysicsSM.Draft.NullEdge.GateI1

The module is draft-trust and is not added to the default trusted build target.
See `AgentTasks/nerd-gate-i1-kinematic-core-lean-plan-2026-07-02.md` for the
claim-to-theorem map and semantic review notes.
-/
