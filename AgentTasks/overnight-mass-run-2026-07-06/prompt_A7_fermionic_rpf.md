Close the fermionic reflection-positivity (RP-F) crux and assemble the finite
fermionic-RP result, following the pre-computed lemma DAG in
`AgentTasks/fourday-ym-run-2026-07-05/QMF5_DESIGN_HARVEST.md` (Deliverable 1,
sections D1.3 / D1.4). This is the gate to the fermionic Ward-subtracted
confinement-gap (NE-U5 stretch).

Work in `PhysicsSM/Draft/NullEdge/GateYM/FermionicReflection.lean` (which already
has N1-N4 and the projector/reflection infrastructure:
`timeRefl`, `rpFReflection_herm/_sq/_unitary`, `liftProjPlus/Minus_herm/_idem`,
`conj_liftProjPlus/Minus_posSemidef`) and the QMF3/QMF4 API it imports
(`berezinGaussian_eq_det`, `gamma5_hermiticity`, `pairedFlavor_det_nonneg`,
`rpBlockMatrix_posSemidef_of_reflectionPositive`,
`cutKernel_posSemidef_of_factorized`, `reflectionForm_nonneg`).

Check with `lake env lean`. If broader `lake build` stalls, SKIP and return
source + DAG progress.

## The crux (DAG node N5, `reflectedWilsonBlock_eq_gram`)

Let `D` be the Wilson-Dirac operator, `Theta` the reflection unitary with
`Theta = Theta^H`, `Theta^2 = 1`, and `Theta D Theta = D^H` (node N3). Let `E`
select the positive half and `P+ = (1 - gamma0)/2` the forward temporal Wilson
projector. Prove the reflected boundary coupling is a GRAM matrix:

  `reflectedWilsonBlock = M^H M`, with `M := sqrt(hopping) * P+ * (half-operator) * E^H`.

Mechanism: link reflection identifies the `t=1` boundary of the positive half
with the `Theta`-image of the `t=0` boundary of the negative half; the single
cross-mirror hopping term carries `P+` on the `+` side and `P+^H = P+` on the
reflected side, so the coupling is literally `(P+ x)^H (P+ x)`. The Wilson mass
term and all SPATIAL hopping is block-diagonal across the mirror (the interior
of `M`); `Theta D Theta = D^H` makes the cross term Hermitian-symmetric.

## Assembly (cheap once N5 lands - all DIRECT per the DAG)

- N6 `reflectedWilsonBlock_posSemidef` : `posSemidef_conjTranspose_mul_self` on N5.
- N7 `fermionReflectedWeight = det` via `berezinGaussian_eq_det` on the glued `D`.
- N8 fixed-background cut kernel factorized : read the Gram vector off N5/N6.
- N9 `fermionCutKernel_posSemidef_fixed` : `cutKernel_posSemidef_of_factorized` on N8.
- N10 dynamical mixture weights `>= 0` : `pairedFlavor_det_nonneg` per config.
- N11 `fermionReflectedWeight_reflectionPositive` :
  `cutKernel_posSemidef_of_mixture` over N9 with N10 weights, then
  `reflectionForm_nonneg`.
- N12 `fermionRpBlockMatrix_posSemidef` :
  `rpBlockMatrix_posSemidef_of_reflectionPositive` on N11.

Everything downstream of N5 is cheap; the difficulty is concentrated in N5 and
the `posHalf`/`timeRefl` indexing bookkeeping of N1-N3.

## If N5 is too heavy: the minimal honest fragment (Deliverable 3 / D3.1)

Fall back to the SMALLEST tractable version: fix a concrete small lattice
(`L = 2`, `nc = 1`, one or two Dirac modes) and a concrete background so `D` is
an explicit small matrix; prove the Gram factorization and PSD by direct
`Matrix` computation for that instance, yielding a concrete
`FermionicReflection.ReflectedBoundaryCoupling` witness with the stated
reflection-hermiticity hypothesis discharged. A kernel-checked CONCRETE small
instance is a real advance and de-risks the general N5.

## Constraints

- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening. A
  documented handoff `s o r r y` on N5 (with N6-N12 assembled on top as a
  conditional chain, or the concrete fragment proved) is acceptable if you
  cannot close the general crux.
- Reuse the existing projector/reflection/Berezin API; do not redefine it.
- Claim label: finite fermionic RP (draft-trust); this is RP for a finite
  fermionic weight, NOT a physical mass gap.
- If `lake build` stalls, SKIP; return source + which DAG nodes closed.
