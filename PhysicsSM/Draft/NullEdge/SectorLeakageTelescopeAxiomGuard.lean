import PhysicsSM.Draft.NullEdge.SectorLeakageTelescope

/-!
# Axiom guards for quantitative selected-sector leakage
-/

/-- info: 'SectorLeakageTelescope.commutator_pow_telescope' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SectorLeakageTelescope.commutator_pow_telescope

/-- info: 'SectorLeakageTelescope.norm_leakage_pow_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SectorLeakageTelescope.norm_leakage_pow_le

/-- info: 'SectorLeakageTelescope.leakage_tendsto_of_budget' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SectorLeakageTelescope.leakage_tendsto_of_budget

/-- info: 'SectorLeakageTelescope.leakage_tendsto_of_exponential_commutator' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SectorLeakageTelescope.leakage_tendsto_of_exponential_commutator
