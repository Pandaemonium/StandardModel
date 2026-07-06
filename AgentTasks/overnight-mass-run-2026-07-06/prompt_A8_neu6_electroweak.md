Open the NE-U6 electroweak rung of the null-edge mass program: a finite lattice
gauge-Higgs toy in which a W-like mass appears as a transfer-spectrum feature of
GAUGE-INVARIANT composite operators (the physical W is itself a closed
composite, not an open edge). See
`AgentTasks/fourday-ym-run-2026-07-05/NULL_EDGE_MASS_UNIFICATION.md` section 3,
"NE-U6 - the electroweak rung."

Deliverable: statement freeze + the SMALLEST provable finite identity. Create a
NEW module `PhysicsSM/Draft/NullEdge/GateI1/ElectroweakRung.lean`. Check with
`lake env lean`. If broader `lake build` stalls, SKIP and return source.

## Target

1. **The smallest finite gauge-Higgs model.** A `Z2` (or `U(1)`) gauge field
   plus a `Z2` Higgs/matter field on the smallest lattice (one plaquette /
   two sites). Reuse the finite transfer-operator machinery already in the tree
   (the `transfer2` 2x2 pattern in `GateI1/MassWithoutMass.lean`, the finite
   ensemble/weight API in `GateYM`). Define the gauge-invariant composite
   operator (the "physical W" = a closed link-Higgs-Higgs composite, e.g.
   `phi(x)^dag U_xy phi(y)` gauge-invariant combination) as an explicit finite
   observable.
2. **The smallest provable theorem.** Prove ONE honest finite identity about
   this composite - e.g. its two-point transfer correlation is positive and
   decays (a positive transfer-gap for the gauge-invariant composite channel),
   OR that the composite operator is genuinely gauge-invariant while the bare
   link/Higgs field is not (the electroweak analogue of Elitzur/closure). A
   `wLikeMass := transferGap(compositeChannel) > 0` positivity statement on the
   toy is the ideal shape.
3. **Statement freeze** for the rung's intended arc (W-mass as
   gauge-invariant-composite transfer-spectrum feature) as documented theorem
   signatures with handoff `s o r r y`s where proof is out of reach tonight,
   clearly labeled.

## HARD BOUNDARY (kill condition - put this in the module docstring)

Fradkin-Shenker is FINITE-LATTICE PHASE-DIAGRAM connectivity of the Higgs and
confinement regimes, NOT an identity of mechanisms. Claiming "Higgs mechanism
IS confinement" outright is a KILL CONDITION. The honest claim is: on the
lattice the physical W is a gauge-invariant CLOSED composite (like a glueball),
so its mass is a closure/composite obstruction of the SAME SHAPE as the gauge
sector - a shared mechanism shape, NOT a proven mechanism identity. Any
Fradkin-Shenker citation is bibliographic-verification-pending; do not rely on
it for a formal step.

## Constraints

- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening. Prove
  the one smallest finite identity genuinely (`s o r r y`-free); the broader
  arc may be a statement-freeze with documented handoff `s o r r y`s, clearly
  separated from the proved core.
- Reuse existing finite-transfer / ensemble API; do not redefine it.
- Claim label: reconstruction (statement layer) + one finite identity.
  Draft-trust. No continuum, no numerical W-mass value.
- If `lake build` stalls, SKIP; return source + proved-vs-frozen note.
