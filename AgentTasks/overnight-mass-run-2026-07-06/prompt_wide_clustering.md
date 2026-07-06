Lane C (closure/YM), toward the full origin of mass. Formalize EXPONENTIAL
CLUSTERING from the spectral gap on the finite connected Wilson slab: the
connected two-point function of the transfer operator decays as exp(-gap * n).
This is the missing link between the NE-U4 sector gap and the Faizal-Shabir
(2606.19362) clustering step, and feeds the lane-C end-to-end assembly.

Create NEW `PhysicsSM/Draft/NullEdge/GateYM/SlabClustering.lean`. Reuse
`SlabTransferGap` (slabTransferBlock, neU4_closure_gap_pos, the Z2 center
sectors), `OSReconstruction` (osTransfer, osSpectralGap), `TwoStateTransferZ2Sector`.
Check with `lake env lean`; if broader build stalls, SKIP.

Prove (finite, standard axioms): for the Z2 slab transfer operator with vacuum
eigenvalue lam0 and flux eigenvalue lamFlux (0<lamFlux<lam0), the n-step
connected correlation `<v, T^n w> - <v,vac><vac,w>` (v,w in the flux sector, or
the vacuum-subtracted 2-point) is bounded by `C * (lamFlux/lam0)^n = C * exp(-n * gap)`
with `gap = osSpectralGap`. State it as `slab_connected_correlation_decay` /
`slab_exponential_clustering`. Do the exactly-solvable 2-state case fully; a
documented handoff sorry is OK only on a genuinely heavy step. No new axiom /
native_decide / weakening. If lake build stalls, SKIP; return source.
