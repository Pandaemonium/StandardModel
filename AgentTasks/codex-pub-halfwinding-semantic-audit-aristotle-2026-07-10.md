# Aristotle adversarial audit: half-winding mode theorem

Audit the exact supplied `ModeInvariantHalfWinding.lean` source against the
claim that a derived collinearity defect has a `Z2` half-winding invariant and
forces protected localized `+1/-1` modes iff the wall count is `2 mod 4`. Do not
edit the source.

Check independently:

1. Which declarations are kernel-only and which use `native_decide` draft
   trust?
2. Does any theorem actually quantify over wall count or prove an `iff`, or are
   there only explicit two-wall, zero-wall, and four-wall fixtures?
3. Does `twoWall_protected_modes` prove localization, stability under a class of
   perturbations, topological protection, or only exact eigenmode existence?
4. Do the zero/four controls prove absence of modes for the full walk, or only
   invertibility of the displayed compressed matrices at `+1/-1`?
5. Is the fixed-leg compression genuinely invariant and self-adjoint for the
   live walk, with correct transport from rational to complex matrices?
6. Are the root-count and trace-count theorems valid at `k=0` and for repeated
   roots without a hidden diagonalizability assumption?
7. Is “half-winding” defined as an invariant in Lean and connected to the local
   Pluecker winding module, or is it presently an interpretation of three
   fixtures?
8. What is the strongest safe theorem sentence, and what exact successor would
   earn the general `iff`, localization, and perturbative-protection claims?

Return severity-ranked findings, a theorem table, a trust-footprint table, a
headline verdict, and exact replacement language. Missing unrelated repository
imports are irrelevant because this module is self-contained over Mathlib.

```yaml
aristotle:
  project_id: 9da8f4b0-337b-4a8e-927b-75e6cfb0b019
  target_file: PhysicsSM/Draft/NullEdge/ModeInvariantHalfWinding.lean
  expected_module: PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding
  submission_project: AgentTasks/aristotle-submit/codex-pub-halfwinding-semantic-audit-20260710-project
  output_dir: AgentTasks/aristotle-output/9da8f4b0-337b-4a8e-927b-75e6cfb0b019
  status: harvested/critical-findings-adopted
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Disposition

The audit compiled the source and found the abstract involutive-compression
engine sound and kernel-only. It confirmed that the explicit two-wall
`twoWall_protected_modes` theorem proves one nonzero `+1` and one nonzero `-1`
eigenvector under documented compiler-trusting draft evaluation. It also found
that the stronger prose is unsupported: there is no formal half-winding or
`ZMod 2` invariant, no quantified wall-count theorem or `iff`, no localization
or perturbation-stability statement, and no bridge to the Pluecker winding
module. The displayed zero/four compressed controls are not connected to
`Wzero` or `Wfour`; moreover `Afix0` and `Afix4` are the same literal matrix.
The full report is preserved as
`AgentTasks/overnight-publication-run-2026-07-11/HALFWINDING_SEMANTIC_AUDIT_2026-07-11.md`.
