# Aristotle task: even Clifford group structure (conjugation = twisted reflection)

Date: 2026-06-10

## Goal

Fill the seven documented `sorry`s in

```text
PhysicsSM/Draft/SpinorTenfoldCliffordConjAristotle.lean
```

establishing the structure theory of `evenCliffordGroup` (the algebraic
`GSpin(10, C)` of the trusted module
`PhysicsSM/Spinor/SpinorTenfoldCliffordGroup.lean`):

```lean
gammaEnd_injective                     -- the Clifford map is injective
gammaUnit_conj_gammaEnd                -- conj by gamma_v = twisted reflection
B10_reflectTwist                       -- reflection preserves B10
Q10_reflectTwist                       -- reflection preserves Q10
reflectTwist_reflectTwist              -- reflection is an involution
evenCliffordGroup_preservesChirality   -- even group preserves chirality
evenCliffordGroup_conj_exists          -- conj stability of the vector image
```

## Mathematical intent

The opening move of the group-level `Spin(10)` stabilizer program
(`Sources/Spin10_stabilizer.txt`, Lemmas S1/S2 and the Selector Theorem).
Design decision: the group is the **algebraic** even Clifford group -
`Subgroup.closure` of pair products of anisotropic Clifford units - so no
exponentials or analysis are needed; all proofs are CAR algebra plus
`Subgroup.closure_induction`. The conjugation-stability theorem is the seed
of the vector representation `evenCliffordGroup -> SO(10, C)` (a later
wave, which will also need `gammaEnd_injective`).

Note `evenCliffordGroup` contains all nonzero scalars (`scalarUnit`), so it
is `GSpin`, not `Spin`; the spinor-norm-1 restriction comes later via the
Chevalley-pairing adjoint.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide`.
- Do not change definitions or sign conventions. Helper lemmas welcome.

## Verification

```bash
lake build PhysicsSM.Draft.SpinorTenfoldCliffordConjAristotle
```

Axiom check on each finished theorem: only
`[propext, Classical.choice, Quot.sound]`.

## Submission

Status: COMPLETE, integrated 2026-06-12 from the third attempt.

Submission project:

```text
AgentTasks/aristotle-submit/spin10-wave6-20260611-project
```

Job ID (active):

```text
f09621e4-4c8d-448d-bd9a-02c5a28e944c
```

Output archive:

```text
AgentTasks/aristotle-output/spin10-clifford-conj-20260612
```

Selected extraction:

```text
AgentTasks/aristotle-output/spin10-clifford-conj-20260612-picked
```

Integrated into:

```text
PhysicsSM/Draft/SpinorTenfoldCliffordConjAristotle.lean
```

Verification run after integration:

```bash
lake build PhysicsSM.Draft.SpinorTenfoldCliffordConjAristotle
```

Previous jobs (failed):

```text
e1bb33d4-dbfd-401f-a6be-f0611ae3e95d
3408462a-7697-47a5-8f75-d66262c1e082
```
