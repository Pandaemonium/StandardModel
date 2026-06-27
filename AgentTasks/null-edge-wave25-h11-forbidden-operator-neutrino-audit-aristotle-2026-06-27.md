# Aristotle H11: forbidden finite operators and neutrino stress-test audit

aristotle:
  project_id: 29b72890-a3d1-4474-a39f-bafa4e07c0f2
  task_id: ff3b3c1c-ef80-45f6-b88c-47449c60744a
  target_file: AgentTasks/null-edge-gate-h-forbidden-operator-neutrino-audit.md
  expected_module: n/a
  submission_project: AgentTasks/aristotle-submit/null-edge-wave25-lateral-analysis-20260627-project
  output_dir: AgentTasks/aristotle-output/29b72890-a3d1-4474-a39f-bafa4e07c0f2
  status: integrated
  initial_project_status: RUNNING
  initial_task_status: IN_PROGRESS
  integrated: 2026-06-27

Dependency class: Gate H / Gate F strategy and formalization design.

Context pack:

```text
AgentTasks/context-packs/null-edge-wave25-lateral-analysis-20260627-114614.md
```

## Background

The lateral analysis argues that the first prediction-grade target is probably
not a numerical mass value. It is an absence theorem:

```text
legal finite Dirac/Higgs operators have the Standard Model block form and
exclude leptoquark, diquark, proton-decay, wrong-hypercharge, and colored-Higgs
blocks.
```

The same analysis identifies neutrinos as the sharpest stress test:

```text
Dirac mass:    M_D : E_R -> E_L
Majorana mass: M_R : E_R -> E_R^c
seesaw:        M_eff = - M_D M_R^{-1} M_D^T
```

The program needs to know whether `M_R` is canonical, optional, or forbidden
under the selected finite-algebra conditions.

## Requested target

Return a focused report:

```text
AgentTasks/null-edge-gate-h-forbidden-operator-neutrino-audit.md
```

If a small Lean skeleton is useful, create it under:

```text
PhysicsSM/Draft/NullEdgeLegalFiniteDiracNeutrinoAudit.lean
```

Do not force a fake Lean theorem where a report is scientifically cleaner.

## Requested analysis

Please produce:

- A precise decomposition of which forbidden blocks are killed by gauge
  covariance alone and which require `J_F`, order-one, ideal compatibility, or
  `chi_E` grading.
- A minimal `LegalFiniteDirac` predicate proposal with clauses strong enough to
  make forbidden blocks vanish for reasons, not by deletion.
- A neutrino decision table:

```text
nu_R absent
nu_R present with Dirac only
nu_R present with Majorana
seesaw as second-order effective obstruction
```

- The first three exact Lean theorem statements to submit next.
- A warning list for overclaims: no Yukawa values, no mixing angles, no
  generation-number derivation, no Gate C release.

## Relation to existing Lean

Use this existing finite theorem as a guide but do not overread it:

```text
PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean
```

That file proves a chirality-odd/off-diagonal codimension statement. H11 should
explain what additional internal-algebra data are needed to upgrade from
"diagonal same-chirality mass is forbidden" to "SM-legal blocks only."

## Acceptance criteria

- Report is concrete enough to become an Aristotle Lean prompt without another
  strategy pass.
- It separates gauge-only, `J_F`/order-one, and ideal-compatibility mechanisms.
- It treats right-handed neutrinos as a flag/branch, not a solved mechanism.
- It identifies the cheapest next formal theorem and the strongest eventual
  forbidden-operator theorem.

## Integration review

Status: integrated 2026-06-27. The Lean skeleton integrated first; the Markdown
report was recovered and integrated in cycle 15 after the Aristotle extraction
helper was fixed to preserve Markdown payloads and Windows long paths.

Integrated artifact:

```text
PhysicsSM/Draft/NullEdgeLegalFiniteDiracNeutrinoAudit.lean
AgentTasks/null-edge-gate-h-forbidden-operator-neutrino-audit.md
```

Result:

- Added a draft Lean skeleton for legal finite Dirac blocks and neutrino branch
  flags.
- The skeleton records gauge/hypercharge/color/weak-singlet-style legality
  clauses and sample theorems for Standard Model Yukawa, wrong-Higgs,
  leptoquark, Dirac-neutrino, and Majorana-neutrino branch behavior.
- Added the H11 strategy report decomposing gauge-only, grading, `J_F`, and
  order-one mechanisms, plus the neutrino decision table and next Lean theorem
  targets.

Review notes:

- Treat this as Gate H/Gate F planning infrastructure, not as a completed
  forbidden-operator theorem.
- The report's strongest near-term target is the finite
  `legal_yukawa_complete` absence/completeness theorem.
