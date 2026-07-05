import PhysicsSM.Draft.NullEdge.GateI1.Core
import PhysicsSM.Draft.NullEdge.GateI1.MassCoinBridge
import PhysicsSM.Draft.NullEdge.GateI1.MassEntropyDictionary

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
observer-conditioned frame caveat).

It lets the current I1 draft stack be kernel-checked in one command:

    lake build PhysicsSM.Draft.NullEdge.GateI1

The module is draft-trust and is not added to the default trusted build target.
See `AgentTasks/nerd-gate-i1-kinematic-core-lean-plan-2026-07-02.md` for the
claim-to-theorem map and semantic review notes.
-/
