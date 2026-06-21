# Aristotle task: mode flips and marked basis-orbit transitivity (Lemma S1 normal forms)

Date: 2026-06-10

## Goal

Fill the four documented `sorry`s in

```text
PhysicsSM/Draft/SpinorTenfoldBasisOrbitAristotle.lean
```

establishing the mode-flip action and up-to-scalar orbit transitivity of
`evenCliffordGroup` on the even Fock basis:

```lean
cliffordAction_flipVec                      -- flip = wedge + contract at i
gammaEnd_flipVec_basisSpinor                -- flip toggles mode i with opSign i T
flipUnit_mul_flipUnit_basisSpinor           -- double-flip formula
exists_evenCliffordGroup_smul_basisSpinor   -- orbit transitivity up to scalar
```

The derived payoffs are already proved in the file modulo the targets:

```lean
exists_evenCliffordGroup_basisSpinor   -- MARKED transitivity (scalar fixed via scalarUnit)
exists_evenCliffordGroup_vacuum_weak   -- vacuum -> weak anchor (Krasnov pair)
```

## Mathematical intent

The normal-form core of Lemma S1 (orbit transitivity) of
`Sources/Spin10_stabilizer.txt`: the hyperbolic mode-flip units
`gamma_{e_i + f_i}` (with `Q10 = 1`) toggle basis-spinor occupation, pairs
of flips stay in the even group, and any two even subsets are connected by
toggling index pairs. With `scalarUnit` the transitivity is *marked* (exact
equality, not projective). Combined with the basis-pair trichotomy
(`Draft/SpinorTenfoldBasisTrichotomyAristotle`, job `5662f6a5`, COMPLETE)
this reduces the orbit analysis of pure-spinor pairs to extending basis
transitivity to all pure spinors (the spinor Witt theorem, a later wave).

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide`.
  Plain kernel `decide` on `Finset (Fin 5)` bookkeeping is fine.
- Do not change definitions or sign conventions. Helper lemmas welcome.

## Verification

```bash
lake build PhysicsSM.Draft.SpinorTenfoldBasisOrbitAristotle
```

Axiom check on each finished theorem: only
`[propext, Classical.choice, Quot.sound]`.

## Submission

Status: COMPLETE_WITH_ERRORS from Aristotle packaging, proof output integrated
2026-06-12. The summary reports all submitted theorem targets proved.

Submission project:

```text
AgentTasks/aristotle-submit/spin10-wave6-20260611-project
```

Job ID (active):

```text
c53883a4-c8d6-4fba-9d12-260d6efcec73
```

Output archive:

```text
AgentTasks/aristotle-output/c53883a4-20260612-complete-with-errors
```

Selected extraction:

```text
AgentTasks/aristotle-output/c53883a4-20260612-picked
```

Integrated into:

```text
PhysicsSM/Draft/SpinorTenfoldBasisOrbitAristotle.lean
```

Verification run after integration:

```bash
lake build PhysicsSM.Draft.SpinorTenfoldBasisOrbitAristotle
```

Previous jobs (failed):

```text
32a15568-6cb5-4c68-8bd8-7bf6d97070f1
701dda9e-4bd5-4502-a990-ee44fc4bb027
```
