# Aristotle task: Spin(10) pure-spinor color axis

Date: 2026-06-09

## Goal

Compute the common annihilator of the normal-form Krasnov pure-spinor pair
`(vacuumSpinor, weakSpinor)` and identify it with the color `C^3` axis.

Primary target file:

```text
PhysicsSM/Draft/SpinorTenfoldColorAxisAristotle.lean
```

Trusted source file:

```text
PhysicsSM/Spinor/SpinorTenfoldPurity.lean
```

## Preferred theorem targets

Fill the holes in:

```lean
mem_annihilator_weakSpinor_iff
mem_colorAxis_iff
colorAxisLinearEquivC3
```

The key expected coordinate facts are:

- `annihilator weakSpinor` is the span of `e_3`, `e_4`, `f_0`, `f_1`, `f_2`.
- `annihilator vacuumSpinor inf annihilator weakSpinor` is the span of
  `f_0`, `f_1`, `f_2`.

## Mathematical intent

This isolates the color axis selected by two marked pure spinors. It is a
focused algebraic step toward the larger Spin(10) stabilizer story: a marked
pure-spinor pencil should leave a distinguished 3-dimensional complex
subspace, matching the color factor.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in the returned proof.
- Do not change `vacuumSpinor`, `weakSpinor`, `annihilator`, or the Fock basis.
- Helper coordinate lemmas are welcome.
- If the final linear equivalence is too much, prioritize the two membership
  characterizations.

## Verification

Run:

```bash
lake build PhysicsSM.Draft.SpinorTenfoldColorAxisAristotle
```

## Submission

Status: submitted.

Submission project:

```text
AgentTasks/aristotle-submit/spin10-stabilizer-20260609
```

Job ID:

```text
88884ecb-60f8-41fb-8be0-8977a7da86c9
```

## Outcome (2026-06-10)

Status: COMPLETE, integrated and promoted to trusted.

Aristotle proved all three targets (both membership characterizations and the
`C^3` linear equivalence), axiom-clean. Result archive:
`AgentTasks/aristotle-output/spin10-20260610/coloraxis`.

Integration notes:

- Promoted verbatim to `PhysicsSM/Spinor/SpinorTenfoldColorAxis.lean` in the
  trusted namespace `PhysicsSM.Spinor.SpinorTenfold`.
- Added during integration: `Q10_eq_zero_of_mem_annihilator` (annihilators of
  nonzero spinors are isotropic, via the CAR Clifford relation),
  `finrank_colorAxis = 3`, the vacuum-annihilator equivalence
  `annihilator vacuumSpinor ~ C^5`, and `finrank_annihilator_vacuumSpinor = 5`
  (so `N_1` is maximal isotropic and the color axis is honestly `d = 3`).
- The draft handoff file
  `PhysicsSM/Draft/SpinorTenfoldColorAxisAristotle.lean` was retired (deleted).

Verification: `lake build PhysicsSM.Spinor.SpinorTenfoldColorAxis` (clean,
style warnings only).
