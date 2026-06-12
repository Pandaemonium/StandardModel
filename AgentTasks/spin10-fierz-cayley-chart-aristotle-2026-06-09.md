# Aristotle task: Spin(10) Fierz identity and Cayley D5 chart

Date: 2026-06-09

## Goal

Prove the ten-dimensional Fierz identity in the concrete Spin(10) Fock model
and use it to close the affine D5 chart theorem for the Cayley-plane package.

Primary target file:

```text
PhysicsSM/Draft/SpinorTenfoldFierzAristotle.lean
```

Useful files:

```text
PhysicsSM/Spinor/SpinorTenfoldFock.lean
PhysicsSM/Spinor/SpinorTenfoldPurity.lean
PhysicsSM/Algebra/Jordan/CayleyPlaneD5Chart.lean
PhysicsSM/Draft/SpinorTenfoldCARAristotle.lean
Scripts/oracle/validate_spinor_tenfold.py
```

## Preferred theorem targets

Fill the holes in:

```lean
gammaBilinear_symm_even
fierz_clifford
```

The following theorems should then close from existing chart lemmas:

```lean
Q10_gammaBilinear_self_eq_zero
sharpMap_graph_eq_zero_of_even
```

## Mathematical intent

This is the bridge from the Spin(10) pure-spinor equations to the affine
Cayley-plane D5 chart. It is the most direct route from the Fock spinor model
to the geometric statement that `(1, psi, q(psi, psi))` is rank one.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in the returned proof.
- Do not alter the Chevalley pairing or alpha-twist convention.
- Do not use the Python oracle as evidence in Lean. It is only sign guidance.
- If the CAR job is needed, import and use its completed lemmas rather than
  duplicating a large proof.

## Verification

Run:

```bash
lake build PhysicsSM.Draft.SpinorTenfoldFierzAristotle
python Scripts/oracle/validate_spinor_tenfold.py
```

## Submission

Status: submitted.

Submission project:

```text
AgentTasks/aristotle-submit/spin10-stabilizer-20260609
```

Job ID:

```text
198550bc-ef58-4789-bda2-b7361cc6c3f7
```

## Outcome (2026-06-10)

Status: COMPLETE, partially promoted; one `native_decide` remains in draft.

Aristotle proved all four targets via a multilinear reduction to wedge-monomial
triples, with the finite combinatorial facts checked over an integer mirror of
the Fock model by `native_decide` (in a new file
`PhysicsSM/Spinor/SpinorTenfoldFierzInt.lean`). Result archive:
`AgentTasks/aristotle-output/spin10-20260610/fierz`.

Integration notes:

- `native_decide` introduces the compiled-evaluator axiom
  (`Lean.ofReduceBool`), which is forbidden in trusted code, so the result was
  split during review:
  - **Promoted to trusted** as
    `PhysicsSM/Spinor/SpinorTenfoldGammaSymm.lean`: the integer mirror, the
    closed form `gBasisZ` (its agreement `gBasisZ_eq` proved *structurally*
    during integration), the 32 x 32 basis symmetry `gBasisZ_symm` by kernel
    `decide`, the cast layer, the multilinear expansion lemmas, the
    unconditional symmetry theorem `gammaBilinear_symm`, and the single-`q`
    Krasnov condition `sum_quadric_iff_single`. No `native_decide` anywhere.
  - **Still draft** in `PhysicsSM/Draft/SpinorTenfoldFierzAristotle.lean`:
    `fierzZ_symmetrized` (the basis-level symmetrized Fierz identity over
    `16^3` even triples) is closed by `native_decide`; `fierz_clifford`,
    `Q10_gammaBilinear_self_eq_zero`, and `sharpMap_graph_eq_zero_of_even`
    (the unconditional Proposition 1(b)) depend on it and stay in the draft.
- Follow-up job to replace the remaining `native_decide` with a
  kernel-checkable proof: see
  `AgentTasks/spin10-fierz-kernel-decide-aristotle-2026-06-10.md`.

Verification: `lake build PhysicsSM.Spinor.SpinorTenfoldGammaSymm` (clean) and
`lake env lean PhysicsSM/Draft/SpinorTenfoldFierzAristotle.lean` (clean).
