import PhysicsSM.Draft.NullEdge.GateYM.Z2GaugeCore
import PhysicsSM.Draft.NullEdge.GateYM.ElitzurCore
import PhysicsSM.Draft.NullEdge.GateYM.ElitzurLattice

/-!
# Gate YM aggregator: the Yang-Mills / confinement ladder

Pure import aggregator for the Gate YM draft tree - the lattice gauge theory
formalization ladder of `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md`
(Track A), with statements and finite-level proofs frozen in
`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`. One command
kernel-checks the layer:

    lake build PhysicsSM.Draft.NullEdge.GateYM

Current contents: `Z2GaugeCore` (YM0 gauge-invariance core; Z2/Bool, core
Lean only, axiom footprint empty-to-[Quot.sound]); `ElitzurCore` (YM1
Elitzur pairing bound, abstract core; axiom footprint
[propext, Classical.choice, Quot.sound]); `ElitzurLattice` (PKG-YM1-lattice:
the abstract bound instantiated at the one-site Z2 gauge flip, giving the
full quantitative volume-uniform Elitzur theorem; axiom footprint
[propext, Classical.choice, Quot.sound]). Not part of the default trusted
build target. Adding a new YM module? Import it here.
-/
