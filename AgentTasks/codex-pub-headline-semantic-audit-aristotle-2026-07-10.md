# Aristotle audit: Paper A headline semantic alignment

Perform a hostile, review-only semantic audit of Paper A's abstract,
introduction, contribution list, conclusion, and run claim matrix against the
exact Lean sources in the package. Do not edit files and do not build the
repository.

Prioritize only claims affected by tonight's landings:

1. complete zero/pi crossing classification and its `0 < |cos theta| < 1`
   boundary;
2. spinor-derived winding versus an actual localized/protected mode;
3. the phase-sensitive `4/5` two-kick witness and its supplied-interaction
   boundary;
4. finite CAR functoriality, adjoint, inverse, and Fock-inner-product
   preservation versus annihilation/locality still open;
5. generic/conditional chiral sector mode protection versus the still-open
   concrete Pluecker-wall instantiation;
6. fixed-momentum/compact-support/changing-`Z^3` prerequisites versus a full
   continuum PDE theorem;
7. exact four-term carrier-square expansion versus canonicity of the named
   four-way decomposition.

For each mismatch, quote the exact manuscript phrase, exact declaration, and
minimal replacement. Check vacuity, hollow restatement, docstring outrunning
kernel, false theorem shape, and trust-footprint leakage. Treat documented
compiled-evaluation witnesses as draft trust and ensure they do not support a
kernel-only headline.

Output only:

- `FATAL`, `MAJOR`, `MINOR`, `CLEAR` findings;
- a seven-row headline verdict table;
- exact replacement text for every fatal/major phrase;
- a final `READY`, `READY AFTER WORDING`, or `NOT READY` verdict.

```yaml
aristotle:
  project_id: c7e14de3-4ee6-4b63-ac31-41988ada2ec7
  target_file: review-only
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-headline-semantic-audit-20260710-project
  output_dir: AgentTasks/aristotle-output/c7e14de3-4ee6-4b63-ac31-41988ada2ec7
  status: harvested
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Codex disposition

Aristotle returned `COMPLETE_WITH_ERRORS` because the deliberately reduced
review package omitted several imported dependency sources. The semantic audit
itself completed and found no fatal issue and no major scientific overclaim.
Its verdict was `READY AFTER WORDING`. The accepted findings and three wording
tightenings are preserved in
`AgentTasks/overnight-publication-run-2026-07-11/HEADLINE_SEMANTIC_AUDIT_2026-07-10.md`.

The missing-source finding is treated as an artifact-completeness gate, not as
evidence that the live guarded declarations fail. Fable owns the manuscript
wording lane; Codex handed off the exact changes through the append-only run
ledger.
