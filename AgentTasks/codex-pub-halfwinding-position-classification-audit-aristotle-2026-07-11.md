# Aristotle audit: four-site winding-insufficiency classification

Name this project `codex-pub-halfwinding-position-classification-audit-20260711`.

Perform a hostile review-only audit of `IndexBridgeDesign.lean` and the supplied
source modules. Do not edit files.

Check independently:

1. The 16-pattern `signField` enumeration and `wallCount` definition cover the
   complete nowhere-zero fixed-magnitude sign family exactly once.
2. Both displayed fields really have the same derived total turning `2*pi`.
3. `discriminant` and `corrected_bridge` have the claimed exhaustive scope and
   exact positional condition; recompute the two-wall/fixed-singleton counts.
4. The same-winding counterexample really has different compression
   self-adjointness and no `+1/-1` mode in the counterexample compressed sector.
5. Verify the report does not silently promote compressed-sector no-mode to
   full-walk no-mode, finite enumeration to a general-length theorem, or
   signature dependence to topology/stability/protection.
6. Audit the split trust footprint: winding equality standard-three versus
   compiled evaluation for family-wide matrix facts.
7. Search for any remaining stale `2 mod 4`, half-winding-protection, or
   wall-count-only prose in the supplied modules/matrices and rank it by
   severity.

Return PASS/FAIL, severity-ranked findings, exact safe headline, and any
required manuscript correction.

```yaml
aristotle:
  project_id: 8b09453a-0618-4f42-a556-e3f31ec917d8
  target_file: review-only
  expected_module: review-only
  submission_project: AgentTasks/aristotle-output/32a89f02-49f4-4198-bc22-93f1316f9aae/extracted/project-files.tar/codex-pub-c-index-bridge-design-20260711-project_aristotle
  output_dir: AgentTasks/aristotle-output/8b09453a-0618-4f42-a556-e3f31ec917d8
  status: audited-pass
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## 2026-07-11 04:16 PDT disposition

Hostile audit PASS. It independently recomputed all 16 sign fields, the exact
8-versus-4 split among the 12 two-wall fields, both `2*pi` winding values, the
positional `fixedSingleton` discriminant, the compressed-sector no-mode
counterexample, and the split trust footprint. The audit's high-severity stale
prose finding had already been corrected in the live
`ModeInvariantHalfWinding.lean`: the historical theorem name remains for API
stability, while its docstring now says exact fixture modes rather than
protection. The manuscript and matrices already use the safe winding-
insufficiency headline. No additional correction required.
