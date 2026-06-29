# Aristotle task C250: D4 envelope audit

Date: 2026-06-28

Purpose:

```text
Explore the relationship between the rank-4 tetrahedral null-edge lattice and
the D4 root lattice as a parallel envelope/symmetry lane, without changing the
mainline tetrahedral Gate C1 proof.
```

Prompt:

```text
AgentTasks/aristotle-prompts/gate-c1-d4-envelope-audit-c250.prompt.md
```

Status:

```text
out-of-budget with useful checkpoint; Pro follow-up confirms main result.
```

Aristotle metadata:

```yaml
aristotle:
  project_id: 14828b89-0046-4e67-9cf3-4af9a8f4f4c2
  task_id: 1da2c6d8-6400-4b8d-936d-7259be9ee562
  target_file: null
  expected_module: null
  submission_project: AgentTasks/aristotle-submit/gate-c1-d4-envelope-audit-c250-20260628-project
  output_dir: AgentTasks/aristotle-output/14828b89-0046-4e67-9cf3-4af9a8f4f4c2
  status: out_of_budget_checkpoint
```

Submission note:

```text
Submitted as a parallel/envelope-lattice audit.  This is not a dependency of
the mainline tetrahedral scalar-Wilson proof and should not change the current
Gate C1 lattice unless the result explicitly argues for doing so.

Initial task status: QUEUED.
```

Checkpoint result:

```text
Aristotle ran out of budget before producing a Lean file or polished audit note,
but returned a useful checkpoint:
  L_H subset D4,
  [D4 : L_H] = 8,
  D4/L_H ~= (Z/2Z)^3,
  L_H^* = (1/4)L_H,
  D4^* subset L_H^* with index 8,
  full D4 adds non-null primitive root-neighbor steps,
  D4 should remain an envelope/comparison lattice, not the Gate C1 release
  lattice.
```

Pro follow-up:

```text
Pro independently checked the C250 checkpoint and found it mostly correct:
  L_H subset D4,
  [D4 : L_H] = 8,
  D4/L_H ~= (Z/2Z)^3,
  L_H^* = (1/4)L_H,
  D4^* subset L_H^* with index 8,
  T_D4 -> T_LH is an 8-fold cover/unfolding,
  full D4 is an envelope/symmetry lattice rather than the current Gate C1
  release lattice.

Important wording correction:
  D4 momentum space is the 8-fold cover/unfolding of the tetrahedral momentum
  torus, not the other way around.

Equivalent lattice characterization:
  L_H = {x in Z^4 : Hx = 0 mod 4}
      = {x in Z^4 : all coordinates have the same parity and sum_i x_i = 0 mod 4}.

Stronger null-only obstruction:
  integral null translations lie in the same-parity lattice L_same, with
  L_H subset L_same subset D4,
  [L_same : L_H] = 2,
  [D4 : L_same] = 4.

Therefore null translations alone cannot connect full D4.
```

Program decision:

```text
Keep L_H as the active Gate C1 lattice.
Use D4 as an envelope, quotient/folding comparison, triality/F4/Spin(8) lane,
and possible later constraint source for M_br.
Do not replace L_H by D4 unless the branch, gap, scalar-Wilson, and no-mirror
proofs are restarted from zero.
```
