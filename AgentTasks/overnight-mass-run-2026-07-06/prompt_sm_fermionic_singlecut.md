Re-establish fermionic reflection positivity (RP-F) over the CORRECTED geometry.
A prior job proved the RP-F N5 Gram crux is FALSE on the PERIODIC time circle
(two cross-mirror hopping terms give an indefinite block - see
`FERMIONIC_RPF_CRUX_FALSE_FINDING.md` / `FermionicReflection.lean` header). The
corrected direction is a SINGLE-CUT (reflected-boundary) time geometry, where only
ONE cross-mirror hopping survives and the Gram factorization is expected to hold.

Create a NEW module `PhysicsSM/Draft/NullEdge/GateYM/FermionicSingleCutRP.lean`
(do NOT edit FermionicReflection.lean). Check with `lake env lean`. If broader
`lake build` stalls, SKIP.

## Task

Mirror the BOSONIC single-cut reflection geometry (`WilsonSlabConnected` /
`ReflectionCutPlaquetteFamily` use a genuine single reflection plane across one
cut, NOT a periodic circle) for the finite Wilson-Dirac operator:
1. Define a SINGLE-CUT time-reflection `Theta_sc` (one reflection plane, e.g. an
   open time interval reflected across its midpoint cut - NOT `t -> 1-t` on
   periodic `Fin L`), the positive-time-half selector `E`, and the reflected
   block `reflectedBlock_sc = E (D Theta_sc) E^H`.
2. Prove the Gram factorization `reflectedBlock_sc = M^H M` on this geometry
   (the single surviving cross-mirror hopping carries `P+` on both sides ->
   `(P+ x)^H (P+ x)`), taking the single-cut reflection-hermiticity
   `Theta_sc D Theta_sc = D^H` as the faithful hypothesis. THEN N6-N12 (PSD +
   Berezin=det + mixture RP) follow as in the QMF5 DAG.
3. If the general case is heavy, prove the CONCRETE small instance (L=2 open,
   nc=1, U=1) where the periodic version was FALSE (reduced to -gamma0), and show
   the single-cut version is instead PSD - the decisive contrast.

## Constraints

- Reuse the bosonic single-cut reflection pattern, the projector/Berezin API,
  `posSemidef_conjTranspose_mul_self`. No new `a x i o m`, `n a t i v e _ d e c i d e`,
  weakening. A documented handoff `s o r r y` on the general Gram step is OK if
  you prove the concrete single-cut PSD instance (the contrast with the false
  periodic one is the key deliverable).
- Claim label: finite fermionic RP on single-cut geometry (draft). If `lake
  build` stalls, SKIP; return source + the concrete contrast.
