# Aristotle task: Q1 N3 cut-plaquette conjugation audit

```yaml
aristotle:
  project_id: 0a46d515-a9ea-4577-8f7e-970b8612f24b
  task_id: 80ff1cd5-936b-4aca-9c05-b178055cf862
  target_file: null
  expected_module: RequestProject.Main
  submission_project: null
  output_dir: AgentTasks/aristotle-output/0a46d515-a9ea-4577-8f7e-970b8612f24b
  status: harvested
```

## Purpose

Audit the Q1/N3 cut-plaquette word problem identified by the day-1 grand
strategy report: whether the raw mirror holonomy word is conjugate to the
original plaquette holonomy or its inverse, enough to identify Wilson local
weights by character invariance.

## Harvest record

Downloaded 2026-07-04 by Codex:

- Archive:
  `AgentTasks/aristotle-output/0a46d515-a9ea-4577-8f7e-970b8612f24b/ym-q1-n3-cutplaquette-conjugation-strategy.zip`
- Extracted summary:
  `AgentTasks/aristotle-output/0a46d515-a9ea-4577-8f7e-970b8612f24b/ym-q1-n3-cutplaquette-conjugation-strategy-20260704-project_aristotle/ARISTOTLE_SUMMARY.md`
- Extracted analysis:
  `AgentTasks/aristotle-output/0a46d515-a9ea-4577-8f7e-970b8612f24b/ym-q1-n3-cutplaquette-conjugation-strategy-20260704-project_aristotle/ANALYSIS_N3.md`
- Lean artifact:
  `AgentTasks/aristotle-output/0a46d515-a9ea-4577-8f7e-970b8612f24b/ym-q1-n3-cutplaquette-conjugation-strategy-20260704-project_aristotle/RequestProject/Main.lean`

## Result

The proposed universal mirror-conjugation claim is false in nonabelian groups.
Aristotle formalized an explicit `S3 = Equiv.Perm (Fin 3)` counterexample:
the mirror holonomy can be conjugate to neither the original plaquette holonomy
nor its inverse.  In the witness, the original plaquette holonomy is a 3-cycle
while the mirror holonomy is the identity.

The key diagnosis is word-level:

- `p0.hol = b0 * b1 * b2^-1 * b3^-1`
- raw `mirror_hol = b3^-1 * b2^-1 * b1 * b0`
- ordinary orientation-reversing loop reversal gives
  `b3 * b2 * b1^-1 * b0^-1 = p0.hol^-1`

The raw mirror operation is pure word reversal, not ordinary loop reversal.
Pure word reversal is not a conjugacy invariant for nonabelian words of length
at least three.

## Actionable consequence

Do not attempt to prove the raw mirror-conjugation lemma.  Q1/N3 should be
redesigned so the reflected per-step operation swaps forward/reverse tags, or
equivalently the false-side restriction should bake in one inverse convention.
Pick exactly one convention fix, not both.  With the corrected ordinary
reversal, the needed Wilson local-weight identity should reduce to the already
available unitary character fact `Re chi(g^-1) = Re chi(g)`.

## Verification

The Aristotle summary reports:

- `RequestProject/Main.lean` builds cleanly.
- No proof placeholders.
- Standard axiom footprint only: `[propext, Classical.choice, Quot.sound]`.

Local integration was not attempted in this harvest note; this is a design
correction for Q1, not a proof to paste into the project tree.
