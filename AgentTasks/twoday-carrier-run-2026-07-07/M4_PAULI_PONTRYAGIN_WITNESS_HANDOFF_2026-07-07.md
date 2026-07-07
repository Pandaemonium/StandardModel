# M4 Pauli/Pontryagin Witness Handoff

Date: 2026-07-07

Source:

- Fable call 03 positivity correction.
- Aristotle project `578f32e6-efb8-4cab-abd8-325b02034685`, task
  `873b2c8c-4c49-4c77-a50d-ab2e2074e848`.

## Verdict

The old `WITNESS_SATISFIABILITY.md` model is superseded for the physical
Krein/Pontryagin reading. It is internally consistent as an ordinary Hilbert-star
matrix exercise, but that is the vacuous `kappa = 0` reading Fable warned about.

The corrected witness is:

- Carrier space: `M4(C)`.
- Fundamental symmetry: `J = Gamma = diag(1,1,-1,-1)`.
- Krein sharp: `kreinSharp J X = J * X^H * J`.
- Gamma generators: `gamma0 = i * (sigma_x tensor I)`,
  `gamma1 = i * (sigma_y tensor I)`.
- Transports: `nabla0 = I tensor sigma_x`, `nabla1 = I tensor sigma_y`.
- Potential: `phi = c * I`, with `c : R` and `c != 0`.
- Clifford metric: `g e e = -2`, off-diagonal `0`.

The `J` certificate is Hermitian involution plus trace zero, so in dimension four
the positive and negative eigenspaces have multiplicity two. This gives inertia
`(2,2)` and Pontryagin `kappa = 2`.

## Slot Values

All three slots are simultaneously nonzero in the corrected model:

- `Q_A = -8 * I`.
- `Q_C = +8 * (sigma_z tensor sigma_z)`.
- `Q_T = c^2 * I` for real `c != 0`.

The signs differ from the old note because replacing Hermitian Pauli gammas by
`i * Pauli` flips the Clifford diagonal and the commutator contribution. The
nonzeroness claims survive.

## Lean Artifact

Aristotle produced a standalone Mathlib-only skeleton:

- `AgentTasks/aristotle-output/578f32e6-efb8-4cab-abd8-325b02034685/tc-m4-pauli-pontryagin-witness-20260707-0202_aristotle/CarrierGlueWitnessSkeleton.lean`

Reported verification in the Aristotle project:

- `lake build CarrierGlueWitnessSkeleton`
- a x i o m prints for the headline theorems, standard trust base only
- no placeholder or fake-assumption tokens in the skeleton

The skeleton should be treated as a handoff artifact, not as integrated project
code. It imports Mathlib only and re-declares a local `kreinSharp`.

## Carrier Follow-Up

This is Claude-owned Carrier surface work. Codex should not integrate it under
`PhysicsSM/Draft/NullEdge/Carrier/**` without acknowledgement.

Recommended next theorem shape:

```lean
carrier_krein_square_J
```

where the ambient star assumptions in `carrier_krein_square` are replaced by an
explicit `kreinSharp J` and hypotheses that `J` is a Hermitian involution. The
alternative is a heavier `M4Krein` type synonym whose `StarRing` instance uses
`kreinSharp J`.

Once that surface exists, instantiate it with the M4 witness to obtain the first
non-vacuous `kappa = 2` carrier glue model with `Q_A`, `Q_C`, and `Q_T`
simultaneously nonzero.
