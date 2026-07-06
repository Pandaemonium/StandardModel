Lane T (turn/matter mass), toward the full origin of mass. Formalize the
NIELSEN-NINOMIYA DOUBLING as the PRICE OF THE TURN: on the finite lattice
Wilson-Dirac operator, the Wilson term is the chirality-EVEN regulator that
removes the fermion doubler, so the physical turn (mass) and the regulator turn
are BOTH chirality-even but only one survives the naive (r=0) limit. Create NEW
`PhysicsSM/Draft/NullEdge/GateYM/DoublingTurnPrice.lean`. Reuse
`ChiralMassStructure` (chiralEven/Odd_massVertex, chiralEven_massVertex_eq_zero_iff,
gamma5_mass_diff_comm), `WilsonDiracOperator` (wilsonDirac, the Wilson term),
`MassTaxonomySeparation` (wilsonRegulatorMass). Check with `lake env lean`.

Prove (finite, standard axioms): (1) the Wilson term contribution to the mass
vertex is chirality-EVEN (like the physical mass) - `chiralEven` of the Wilson
term is nonzero; (2) at the naive limit (r=0 / no Wilson term) the doubler
survives (the chirality-odd transport has extra zeros) while the Wilson term is
the momentum-dependent mass lifting it - state the finite shadow of
Nielsen-Ninomiya (cannot have chiral symmetry AND doubler removal: the even
channel vanishes at a special m, the finite `chiralEven_massVertex_eq_zero_iff`
already proves `= 0 iff m = -1`). Tie the regulator-turn to
`wilsonRegulatorMass`. Claim label: finite identity (the doubling-turn price).
No new axiom / native_decide / weakening. If lake build stalls, SKIP; return source.
