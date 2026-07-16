import PhysicsSM.Draft.NullEdge.SynchronizedTetradBundle

/-!
# Axiom guard for the synchronized tetrad-bundle bridge

This module pins the transitive axiom footprint of the exact finite
metric/coframe transition bridge and its nonidentity rational witness. It does
not upgrade the conditional inputs to graph reconstruction or continuum
geometry.
-/

namespace PhysicsSM.Draft.NullEdge.SynchronizedTetradBundleAxiomGuard

/-- info: 'PhysicsSM.Draft.NullEdge.SynchronizedTetradBundle.MetricCoframeCocycle.internalTransition_lorentz_of_metric_covariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SynchronizedTetradBundle.MetricCoframeCocycle.internalTransition_lorentz_of_metric_covariant

/-- info: 'PhysicsSM.Draft.NullEdge.SynchronizedTetradBundle.MetricCoframeCocycle.internalTransition_cocycle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SynchronizedTetradBundle.MetricCoframeCocycle.internalTransition_cocycle

/-- info: 'PhysicsSM.Draft.NullEdge.SynchronizedTetradBundle.MetricCoframeCocycle.exact_metric_bundle_gives_lorentz_cocycle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SynchronizedTetradBundle.MetricCoframeCocycle.exact_metric_bundle_gives_lorentz_cocycle

/-- info: 'PhysicsSM.Draft.NullEdge.SynchronizedTetradBundle.MetricCoframeCocycle.nonidentity_metric_covariant_lorentz_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SynchronizedTetradBundle.MetricCoframeCocycle.nonidentity_metric_covariant_lorentz_witness

end PhysicsSM.Draft.NullEdge.SynchronizedTetradBundleAxiomGuard
