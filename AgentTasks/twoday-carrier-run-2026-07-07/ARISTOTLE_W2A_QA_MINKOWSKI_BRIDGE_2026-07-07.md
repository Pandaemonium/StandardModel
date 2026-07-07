# Aristotle task brief - W2a concrete Q_A / Minkowski bridge

Job name: `ne-solo-lane-w2a-qa-minkowski-detp-bridge-proof-20260707`

Aristotle project id: `ecbf61d8-c350-4f2e-975f-83ba0bfa6fc0`
Submission project:
`AgentTasks/aristotle-submit/ne-solo-lane-w2a-qa-minkowski-detp-bridge-proof-20260707-project`
Status: `RUNNING` as of the submission poll on 2026-07-07.

## Goal

Audit and, if feasible, prove the next W2a bridge theorem connecting the
abstract carrier aperture identity to the trusted kinematic aperture layer.

The Q13 audit found that the README previously overclaimed this seam.  The live
README now states the conservative truth:

- proved in carrier draft: abstract total-square identity
  `Q_A = Q(sum alpha)` in
  `PhysicsSM/Draft/NullEdge/Carrier/CarrierApertureIdentification.lean`;
- proved in trusted/kinematic aperture lane:
  `NBodyAperture.nbody_aperture_massless_iff_collinear`;
- still open: a literal Minkowski-specialized theorem tying the carrier `Q_A`
  statement to the trusted `det P` / aperture mass statement.

Please either:

1. return a Lean theorem/proof, preferably as a small patch or standalone file,
   that instantiates the carrier abstract theorem in the concrete Minkowski
   aperture setting and ties its zero locus to
   `NBodyAperture.nbody_aperture_massless_iff_collinear`; or
2. return a precise blocker report naming the exact missing API/definition bridge
   and the smallest theorem statement that should be added first.

## Files to inspect

- `PhysicsSM/Draft/NullEdge/Carrier/CarrierApertureIdentification.lean`
- `PhysicsSM/Draft/NullEdge/Carrier/SolderedSquareGram.lean`
- `PhysicsSM/Draft/NullEdge/GateI1/NBodyAperture.lean`
- `PhysicsSM/Draft/NullEdge/GateI1/CompositeApertureMass.lean`
- `PhysicsSM/Draft/NullEdge/GateI1/ApertureEqualsTurn.lean`
- `AgentTasks/twoday-carrier-run-2026-07-07/CLAIM_GRADE_REGRESSION_AUDIT_2026-07-07.md`
- `README.md`
- `AgentTasks/twoday-carrier-run-2026-07-07/THREAD_BOARD.md`

## Output requirements

- Do not weaken theorem statements just to make a proof pass.
- Do not add new assumptions without naming them as assumptions.
- Do not introduce axioms or placeholders as a success.
- If returning Lean, state exact verification commands.
- If returning a blocker, give the exact next theorem name(s) and proof route.
