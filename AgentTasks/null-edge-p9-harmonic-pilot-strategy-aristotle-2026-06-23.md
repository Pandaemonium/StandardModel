# Aristotle task: P9 harmonic-projector pilot strategy

```yaml
aristotle:
  project_id: de152449-2632-4a5f-b1dc-e0f22d5a07a6
  target_file: PROMPT.md
  expected_module: none
  submission_project: AgentTasks/aristotle-strategy-packs/null-edge-p9-harmonic-pilot-strategy-20260623
  output_dir: AgentTasks/aristotle-output/de152449-2632-4a5f-b1dc-e0f22d5a07a6
  status: strategy-reviewed
```

No-code strategy/audit job. Aristotle should not build Lean or edit files.

Scientific role: use Aristotle as an external proof-strategy critic for the P9
source-visibility/noise branch, focusing on the harmonic-projector and numerical
pilot gate that would keep P9 from being generic cochain vocabulary.

## Submission note

Submitted as Aristotle no-code strategy project
`de152449-2632-4a5f-b1dc-e0f22d5a07a6`.

## Result note

Aristotle returned a no-code roadmap and correctly flagged the current P9 spine
as generic cochain/linear algebra until a geometry-dependent finite diamond
metric/projector and response coefficient are added. The most useful target
ladder was:

1. finite Hodge/Betti separation for the harmonic sector;
2. constructive harmonic projector with boundary annihilation;
3. strict positive definiteness / no hidden null modes for projected noise;
4. condition-number or spectral-gap bounds;
5. a flat-vs-de Sitter-like finite diamond response law.

This result directly informed the follow-up proof jobs:
`a0dadc4c-2ea3-4741-b96b-508a795d1e1b`,
`6dfa769d-2271-4cbf-aca6-4a05e7827254`, and
`e6ef0730-727a-48e9-a5df-5be70830db99`, plus the explicit Hodge-projector
strategy job `689020dd-79b1-4b50-9971-6d40ac8dd801`.

This is a terminal no-code strategy state, not a Lean integration blocker.
