# Aristotle task: complete live product DFT and walk conjugacy

## Publication role

Paper D needs an exact walk-specific Fourier bridge before any changing-lattice
sampling/interpolation or strong position-space convergence claim is honest.
The live project currently proves invariance of individual plane-wave sectors.
This job upgrades that result to a complete normalized product DFT for arbitrary
finite fields, including inverse, Parseval, and exact conjugacy of the local
walk to its momentum blocks.

## Target

Prove every theorem in:

`LiveDFTConjugacy/Main.lean`

Run the narrow target first:

```text
lake env lean LiveDFTConjugacy/Main.lean
```

## Required semantic constraints

- Do not change any theorem statement or Fourier sign convention.
- Do not replace operator-level `fourier_localStep` with a plane-wave-only
  theorem; that theorem already exists and is only the seed.
- No new assumptions, compiler-trusting shortcuts, or proof placeholders in
  the returned file.
- The transform must remain normalized by `1 / sqrt(card)` and Parseval must
  hold exactly.
- Preserve both nonzero controls.
- Small helper lemmas are welcome.
- If the full conjugacy blocks, return the proof-complete orthogonality,
  normalization, inverse, and Parseval prefix plus the exact remaining Lean
  goal and recommended lemma.

## Available seeds

- `Finite3Plus1FourierBridge.localStep_mode`
- `Finite3Plus1FourierBridge.planeWave_source`
- `Finite3Plus1FourierBridge.stdAddChar_val_formula`
- generic finite Parseval machinery in
  `GateC1.FiniteFourierParseval`
- ZMod character orthogonality in Mathlib

## Publication effect

Success closes the walk-specific product-DFT-conjugacy rung of Paper D. It does
not by itself prove changing-lattice or continuum PDE convergence; those remain
separate sampling/interpolation and analytic obligations.

## Metadata

```yaml
aristotle:
  project_id: 6cbba323-d021-4546-a7b4-5f072a2431de
  task_id: pending
  target_file: LiveDFTConjugacy/Main.lean
  expected_module: LiveDFTConjugacy.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-live-dft-conjugacy-20260710-project
  output_dir: AgentTasks/aristotle-output/6cbba323-d021-4546-a7b4-5f072a2431de
  status: submitted
```
