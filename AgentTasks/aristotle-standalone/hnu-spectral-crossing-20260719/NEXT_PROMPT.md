# HNU massive zero/pi crossing reduction

Work only on `PhysicsSM/Draft/NullEdge/HNUMassiveGlobalGap.lean`. Prove the two
gap theorems `massiveHNU_zero_pi_gap` and
`massiveHNU_origin_zero_pi_gap`, adding precise helper lemmas in the target.
You may use `endpoint_eq_momentumReverse_iff` as a named hypothesis in a local
helper if its existing handoff proof remains open; isolate the spectral
reduction so it can compose with the parity job later.

Reduce `det (massiveHNU k z - lambda)` for `lambda = +/-1` through the doubled
chiral basis and the exact onsite Pluecker coin. The desired result covers the
closed Brillouin cube and `0 < a < pi`; an infrared neighborhood is not enough.
If the theorem is false, return an exact momentum/mass counterexample and do
not weaken silently. No new assumptions or compiler-trusted procedures. Run
the narrow target and report all remaining holes and axioms. Read `CONTEXT.md`.
