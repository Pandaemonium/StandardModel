# Aristotle task: Spin(10) Fock CAR and Clifford relation

Date: 2026-06-09

## Goal

Prove the canonical anticommutation relations for the concrete Spin(10)
Fock model and derive the Clifford relation.

Primary target file:

```text
PhysicsSM/Draft/SpinorTenfoldCARAristotle.lean
```

Trusted source file:

```text
PhysicsSM/Spinor/SpinorTenfoldFock.lean
```

## Preferred theorem targets

Fill the documented holes in:

```lean
wedge_contract_same_add
wedge_wedge_anticomm
contract_contract_anticomm
wedge_contract_distinct_anticomm
cliffordAction_cliffordAction_self
cliffordAction_anticomm
```

If a direct proof of all six theorems is too large, prioritize the first four
CAR lemmas and leave the Clifford relation as the next dependent target.

## Mathematical intent

This is the algebraic engine for the Spin(10) pure-spinor formalization. It
checks that the coordinate definitions of `wedge`, `contract`, and
`cliffordAction` really implement the hyperbolic Clifford algebra on the
exterior Fock model.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in the returned proof.
- Do not change the basis, signs, `Q10`, `B10`, or `cliffordAction`.
- Do not weaken theorem statements.
- Helper lemmas are welcome if they are small and documented.

## Verification

Run:

```bash
lake build PhysicsSM.Draft.SpinorTenfoldCARAristotle
```

## Submission

Status: submitted.

Submission project:

```text
AgentTasks/aristotle-submit/spin10-stabilizer-20260609
```

Job ID:

```text
d91d6453-444a-498f-bf12-a4027c46c13a
```

## Outcome (2026-06-10)

Status: COMPLETE, integrated and promoted to trusted.

Aristotle proved all six targets. Result archive:
`AgentTasks/aristotle-output/spin10-20260610/car`.

Integration notes:

- Promoted to `PhysicsSM/Spinor/SpinorTenfoldCAR.lean` in the trusted
  namespace `PhysicsSM.Spinor.SpinorTenfold`.
- Two helper lemmas (`belowCount_erase_of_lt`, `belowCount_insert_of_lt`)
  originally used `native_decide` (forbidden axiom in trusted code); replaced
  during review by structural proofs via `Finset.filter_erase` /
  `Finset.filter_insert`. The slow `fin_cases` proof of
  `belowCount_erase_of_not_lt` was replaced the same way.
- The draft handoff file `PhysicsSM/Draft/SpinorTenfoldCARAristotle.lean` was
  retired (deleted).
- Downstream: the isotropy corollary `Q10_eq_zero_of_mem_annihilator` now
  lives in `PhysicsSM/Spinor/SpinorTenfoldColorAxis.lean`.

Verification: `lake build PhysicsSM.Spinor.SpinorTenfoldCAR` (clean, style
warnings only).
