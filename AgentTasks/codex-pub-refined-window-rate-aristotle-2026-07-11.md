# Aristotle proof job: small-step-sensitive 3+1 window rate

Name this project `codex-pub-refined-window-rate-20260711`.

Run only:

```text
lake env lean AgentTasks/aristotle-targets/Compact3Plus1RefinedWindowRate.lean
```

The existing `Compact3Plus1DiracRate` proof first bounds the split-product
remainder by `exp(|eps|*B4)-1-|eps|*B4`, but then weakens the exponential to
`exp(B4)`.  Prove the four targets while retaining `exp(|eps|*B4)`, then carry
it through the unitary telescope with `eps=t/n`.

Audit every coefficient and parenthesization.  If the displayed factor `2` is
too small under the live operator norm, return the smallest explicit universal
coefficient and a corrected statement; do not silently weaken the theorem.
Include a nonzero rational momentum/time witness and explain why the new bound,
unlike `Dbox`, can remain polynomial on windows `B4 = o(n)`.

Do not claim a changing-lattice PDE theorem.  This is the missing quantitative
precursor; sampling/interpolation and Sobolev-tail composition follow only
after it lands.

```yaml
aristotle:
  project_id: 9ce69fe9-51f8-4f04-96d0-28db8cc58b68
  task_id: d321574e-42e7-423e-a4fd-e3b23c908fbd
  target_file: AgentTasks/aristotle-targets/Compact3Plus1RefinedWindowRate.lean
  expected_module: review/target
  submission_project: AgentTasks/aristotle-submit/codex-pub-refined-window-rate-20260711-project
  output_dir: AgentTasks/aristotle-output/9ce69fe9-51f8-4f04-96d0-28db8cc58b68
  status: integrated-local-completion
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

At 07:56 PDT Codex downloaded an in-progress snapshot. It contained the correct
coefficient/growing-window audit and a nonzero rational witness, but all four
headline proofs remained open. Codex sent an instruct-mode continuation
pointing to the exact reusable lines in `Compact3Plus1DiracRate`: retain the
existing `exp(|eps|*B4)` remainder, use monotonicity only from the matrix norm
to that small-step exponent, sum the two remainders, and telescope at
`eps=t/n`. No snapshot result was landed.

At 08:48 PDT a delegated local proof pass completed all four frozen theorems
without changing their statements or adding `|eps| <= 1`. Direct Lean passed
for `PhysicsSM/Draft/NullEdge/Compact3Plus1RefinedWindowRate.lean`, which is
now integrated with standard-three pins. The remote Aristotle project remained
running; provenance for the landed proof is the local completion over the
existing `Compact3Plus1DiracRate` API.
