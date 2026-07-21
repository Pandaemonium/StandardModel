import PhysicsSM.Draft.NullEdge.RingHolonomyClassification

/-!
# Aristotle harvest axiom guard

Build-enforced assumption-footprint audit for the assumption-clean A5
classification return harvested on 2026-07-19. This module adds no mathematics.
It keeps the accepted result from silently acquiring stronger assumptions
through later refactors.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.RingHolonomyClassification.unitarily_conjugate_of_holonomy_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RingHolonomyClassification.unitarily_conjugate_of_holonomy_eq
