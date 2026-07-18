# Aristotle job: five-event carrier Lorentz-inertia normalization

Date: 2026-07-16
Work item: `GRAV-ORDER-OPERATOR-001`
Status: locally proved and independently approved; stale Aristotle comparison cancelled

```yaml
aristotle:
  project_id: 9a705eeb-56af-4c05-a156-b2702b654206
  task_id: 046ae0dc-ac5c-4ad3-adac-fde66d582f3c
  target_file: PhysicsSM/Draft/NullEdge/CorrectedPairingCarrierInertiaWitness.lean
  expected_module: PhysicsSM.Draft.NullEdge.CorrectedPairingCarrierInertiaWitness
  submission_project: AgentTasks/aristotle-submit/corrected-pairing-carrier-inertia-20260716-project
  output_dir: AgentTasks/aristotle-output/9a705eeb-56af-4c05-a156-b2702b654206
  snapshot: AgentTasks/aristotle-output/9a705eeb-56af-4c05-a156-b2702b654206-in-progress-snapshot.zip
  status: cancelled
```

## Objective

Prove the exact production statement
`fiveEventLorentzDiamond_hasLorentzianInertia`: at equal nonzero operator
scales, the concrete five-event three-arm marked diamond satisfies
`ProbeFrameLorentzGauge.HasLorentzianInertia` at its carrier top.

## Exact target

`PhysicsSM/Draft/NullEdge/CorrectedPairingCarrierInertiaWitness.lean`

The public statement must remain unchanged. Do not replace the production
predicate by a new signature predicate, assume a supplied carrier basis, alter
the project sign convention, or weaken equality of the normalized Gram matrix
to a sign-only statement.

## Available finite results

- all five events lie in one marked closed carrier;
- the induced carrier order is definitionally isomorphic to the concrete
  three-arm diamond;
- the zero-sum probe space has an explicit four-vector basis;
- the actual project-local corrected Gram matrix in that basis is diagonal
  `(4s,-s/2,-s/2,-s/2)`;
- `s = sourceLocal4DPrefactor ell` is strictly positive for `ell != 0`;
- equal nonzero smeared/local scales reduce exactly to the local operator.

## Scope boundary

This is a finite normalization theorem only. It does not provide canonical
carrier selection, a spectral gap, overlap transitions, refinement stability,
or continuum convergence.

## Planned proof

Transport the explicit basis to `carrierProbeSubspace` through
`fiveEventInducedOrderIso`, use corrected-pairing equivariance and the
same-scale local reduction, then apply `Basis.unitsSMul` with nonzero
reciprocal-square-root factors to normalize the Gram matrix entrywise.

## Submission

Context pack:
`AgentTasks/context-packs/corrected-pairing-carrier-inertia-20260716-20260716-164935.md`.

The target file initially passed `lake env lean` with exactly the one documented
proof-handoff warning. The local transport half is now kernel-checked as
`fiveEventCarrierProbeBasis_gram`: it maps the explicit zero-sum basis into the
production carrier space, reduces the equal-scale smeared operator to the local
one, and transports the exact diagonal Gram formula. Aristotle project
`9a705eeb-56af-4c05-a156-b2702b654206`,
task `046ae0dc-ac5c-4ad3-adac-fde66d582f3c`, was submitted with verbatim-
statement, production-predicate, no-new-assumptions, and blocker-if-false
instructions.

## Local proof status

The exact target is now proved locally without placeholders. The proof uses the
transported basis, `Basis.unitsSMul` by reciprocal square-root units, positivity
of `sourceLocal4DPrefactor ell`, and an entrywise check against the project's
mostly-minus `MinkowskiConvention.eta`. The Aristotle task remains active as an
independent proof-search and semantic comparison rather than as a blocker.

Kernel-checked source SHA-256:
`665a50e07844540ca8ceba99fdce0e30ee4267437b9be5c14054e216e692e793`.
The targeted build passed 8,038 jobs, and the theorem's build-enforced axiom
guard pins exactly `propext`, `Classical.choice`, and `Quot.sound`.

The scheduled Claude semantic review could not start because its CLI credit
balance was exhausted. The same verbatim source packet was sent through the
Gemini wrapper; Gemini returned `APPROVED`. Review record:
`AutonomousLab/reviews/GEMINI_REVIEW_CORRECTED_PAIRING_CARRIER_INERTIA_2026-07-16.md`.

## Bounded status query

At 2026-07-16 21:28 PDT the Aristotle task still reported `IN_PROGRESS` after
about four hours. A `continue --mode ask --wait` request asked only which target
was solved, what exact Lean or build blocker remained, whether any public
statement changed, and whether to keep waiting or return the current file. The
request timed out after 124 seconds with no response. The task remains an
independent comparison only; the locally proved, built, and reviewed production
theorem is not blocked by it.

At 2026-07-16 22:22 PDT the original task still reported `IN_PROGRESS` after
about five hours. A second `continue --mode ask` request was submitted without
a wait loop, asking whether the theorem is proved, for the exact remaining Lean
blocker, whether any statement changed, and whether to keep waiting or harvest
the current file. No direction-changing instruction was sent.

At 2026-07-17 01:12 PDT the task still reported `IN_PROGRESS` after about eight
hours. A third bounded `continue --mode ask --wait` request timed out without a
response. The downloaded in-progress snapshot still contained the original two
private proof holes and the public target proof hole unchanged, so there was no
candidate proof to compare or integrate. Because the statement-preserved
production theorem was already locally proved, targeted-built, guarded, and
independently approved, the stale duplicate project was cancelled. This is an
Aristotle null result, not a failure of the landed production theorem.
