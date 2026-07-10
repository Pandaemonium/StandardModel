# Aristotle task: complete decoder moduli of the three-state carrier

Status: integrated

Project: `b037861c-3dfe-4a6a-9c15-fb9830a49d79`

Submission package:
`AgentTasks/aristotle-submit/codex-decoder-moduli-classification-20260710-project`

Integrated module:
`PhysicsSM/Draft/NullEdge/Carrier/DecoderModuliClassification.lean`

## Objective

Prove all five targets in
`DecoderModuliClassification/Core.lean` without changing any theorem statement.
The theorem should identify the chain-homotopy quotient of decoders commuting
with `Q = E_01` with one complex coordinate, the action on the surviving
cohomology class.

## Semantic reading

- `CommutesQ D` means the decoder descends through the constraint complex.
- `exactDeformation R = Q R + R Q` is presentation gauge.
- `physicalEigenvalue D = D 2 2` is the action on the one-dimensional class
  represented by `e_2`.
- Target 3 is the classification theorem; target 5 prevents a vacuous quotient.

This is a classification of one explicit finite carrier, not a universal
moduli theorem for all carriers.

## Verification

Run:

```text
lake env lean DecoderModuliClassification/Core.lean
```

No theorem may be weakened. Helper lemmas are welcome.
