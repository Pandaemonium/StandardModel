# Codex history-local four-channel action and checkerboard phase, 2026-07-09 15:55

aristotle:
  project_id: 2a29ad97-9626-47ce-9b4c-895e8f788d5d
  target_file: HistoryLocalAction/HistoryLocalFourChannelAction.lean
  expected_module: HistoryLocalAction.HistoryLocalFourChannelAction
  submission_project: AgentTasks/aristotle-submit/history-local-four-channel-action-20260709-1555-project
  output_dir: AgentTasks/aristotle-output/2a29ad97-9626-47ce-9b4c-895e8f788d5d
  status: integrated 2026-07-09 16:25 PDT

Harvest note: Aristotle completed the full placeholder-free target. It passed
the pinned Lean check and was integrated as
`PhysicsSM/Draft/NullEdge/HistoryLocalFourChannelAction.lean`, imported by
`PhysicsSMDraft.lean`, and verified by targeted `lake build`. The live module
records the flat-turn boundary: general four-channel weights remain input and
nonzero closure/soldering history densities are not derived.

You are Aristotle. Pro's highest-ranked research direction is to turn the static
four-channel mass decomposition into a quantum history theory. The project now
has a kernel-checked state-level bridge: the expectations of `Q_A`, `Q_C`,
`4 Q_T`, and `4 E_#` sum exactly to the checkerboard carrier action. Close the
next finite gap by proving the attached Mathlib-only history-local action target.

Target:

```text
HistoryLocalAction/HistoryLocalFourChannelAction.lean
```

Context pack:

```text
AgentTasks/context-packs/history-local-four-channel-action-20260709-1555-20260709-155248.md
```

## Required payload

1. Prove action additivity and phase multiplicativity under history
   concatenation.
2. Prove the exact weighted channel-count and per-channel phase-power formulas.
3. Prove the recursive checkerboard event translation has one aperture event per
   null step, exactly one turn event per direction reversal, and no flat closure
   or soldering events.
4. Prove the specialized local corner action `pi/2` gives exactly `I^r`.
5. Prove the amplitude equals the standard checkerboard corner power
   `(I * eps * m)^r`, with the explicit one-turn nonzero witness.

Use `Complex.exp_pi_div_two_mul_I`, `Complex.exp_nat_mul`, `List.count_append`,
and small induction helpers where useful. Preserve all statements unless one is
actually false; report and repair a malformed statement rather than silently
weakening it. Add axiom-footprint guard pins to all headline theorems.

## Claim boundary

This target proves a local finite action/phase semantics and the flat `1+1`
turn-only specialization. It does not derive nonzero closure or soldering action
densities, sum over all paths, prove a continuum propagator limit, or select the
physical Hamiltonian. The wider project retains those as explicit open steps.

Literature/provenance checks already made: Feynman's checkerboard assigns the
factor `i eps m` to each bend; Foster-Jacobson arXiv:1610.01142 gives the null-step
and bend-phase precedent. Translate mathematics only; do not copy external code.

Run first:

```text
lake env lean HistoryLocalAction/HistoryLocalFourChannelAction.lean
```
