# Gate B live elimination capstone

The on-demand module
`PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylEliminationCapstone.lean`
closes the formal composition gap between the imported live matrix and the
generated exact elimination certificate.

It proves:

- `live_numerators_eq_certificate`: the three live bridge polynomials and the
  three generated certificate polynomials agree exactly;
- `live_alias_forces_certificate_branch`: every imported live `+I` crossing
  lies on the generated zero, quintic, or sextic branch;
- `live_alias_forces_elimination_branch`: the same necessary condition in the
  canonical branch names used by the algebraic reconstruction modules.

This is a necessary branch theorem, not a complete census or converse. The
mandatory chart factor remains present in the generated certificate and is
canceled only by real positivity. The module and its guard remain outside the
always-on draft root because rebuilding the generated 522-term normalization is
expensive.

Verification:

- `lake build PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylEliminationCapstoneGuard`
- PASS (8,033 jobs)
- pinned footprint: `propext`, `Classical.choice`, `Quot.sound`
