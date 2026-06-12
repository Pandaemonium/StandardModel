# Aristotle task: gauge quotient representation synthesis

Date: 2026-06-04

## Goal

Create a trusted gauge-facing synthesis module that ties together the newly
integrated unit-level Z6 exact-kernel package and the quunit/qubit/qutrit
quotient representation package.

Primary target file:

```text
PhysicsSM/Gauge/StandardModelGaugeRepresentationSynthesis.lean
```

Useful imports:

```text
PhysicsSM.Gauge.StandardModelUnitZ6ExactKernelPackage
PhysicsSM.Gauge.QunitQubitQutritQuotientRepresentation
```

## Preferred theorem shape

Work in the namespace that best matches the available declarations, probably
`PhysicsSM.Gauge.StandardModelSubgroup` or
`PhysicsSM.Gauge.QunitQubitQutritDictionary`.

Create a package such as:

```lean
structure StandardModelGaugeRepresentationSynthesisPackage where
  unit_z6_exact_kernel : StandardModelUnitZ6ExactKernelPackage
  quunit_quotient_representation :
    QunitQubitQutritQuotientRepresentationPackage
  identity_fiber_acts_trivially :
    forall x : SMCoveringTriple,
      x.smImage = 1 ->
        quotientActQubitPlusQutrit (Quotient.mk _ x) = id
  quotient_action_compatible_block_equiv :
    forall q : SMCoveringQuotient,
      forall v : QubitPlusQutrit,
        quotientActQubitPlusQutrit q v =
          (smCoveringQuotientMulEquivSMBlockUnits q :
            Units GUTMatrix).val.mulVec v
```

Instantiate it as:

```lean
noncomputable def standardModelGaugeRepresentationSynthesisPackage :
  StandardModelGaugeRepresentationSynthesisPackage := ...
```

Add small projection theorems:

```lean
theorem gaugeRepresentationSynthesis_has_unit_z6_exact_kernel :
  standardModelGaugeRepresentationSynthesisPackage.unit_z6_exact_kernel =
    standardModelUnitZ6ExactKernelPackage := rfl

theorem gaugeRepresentationSynthesis_has_quunit_quotient_representation :
  standardModelGaugeRepresentationSynthesisPackage.quunit_quotient_representation =
    qunitQubitQutritQuotientRepresentationPackage := rfl
```

## Proof hints

- `smCoveringTriple_smImage_one_quotient_eq` should reduce an identity-fiber
  representative to the identity quotient class.
- `quotientActQubitPlusQutrit_mk` and `actQubitPlusQutrit_one` should finish
  the identity action proof after rewriting.
- `quotientAction_compatible_blockEquiv` already proves the block-equivalence
  compatibility statement.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change existing gauge definitions or normalizations.
- This is an algebraic quotient/representation synthesis theorem only, not a
  topological quotient theorem or a physical Hilbert-space claim.

## Verification

Run:

```bash
lake build PhysicsSM.Gauge.StandardModelGaugeRepresentationSynthesis
```

## Submission

Status: integrated.

Submission project:

```text
AgentTasks/aristotle-submit/paper-wave13-20260604
```

Job ID:

```text
b9343bf9-e25b-42df-aeac-10d0137f6fec
```

## Integration

Result status: `COMPLETE`.

Integrated output from:

```text
AgentTasks/aristotle-output/b9343bf9-extracted/paper-wave13-20260604-project_aristotle
```

Files integrated:

```text
PhysicsSM/Gauge/StandardModelGaugeRepresentationSynthesis.lean
PhysicsSM.lean
```

Local verification target:

```bash
lake build PhysicsSM.Gauge.StandardModelGaugeRepresentationSynthesis
```
