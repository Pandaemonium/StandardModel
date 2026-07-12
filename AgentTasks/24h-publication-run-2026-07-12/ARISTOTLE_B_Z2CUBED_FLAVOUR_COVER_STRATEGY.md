# Aristotle strategy: exact `Z2^3` flavour-cover successor

Design the smallest exact Lean theorem program for the eight-sheeted
Brillouin-zone covering route described by Bakircioglu, Arnault, and Arrighi,
specialized to the repository's `3+1` QCA conventions.  This is a focused
strategy job.  Do not edit files and do not run a broad build.  Return
`B_Z2CUBED_FLAVOUR_COVER_STRATEGY_REPORT.md`.

## Context

The direct four-component reciprocal embedding now has exact extra zero and pi
crossings.  The stationary-amplitude isotropic fixture also has exact aliases.
The covering route changes the microscopic register: a `Z2^3` flavour label
tracks the eight sheets of a reduced Brillouin zone.  It may remove spurious
solutions only by reinterpreting them as explicit flavours.  It is not a
single-species unique-cone theorem and must not be sold as one.

Read:

- `DIRECT_LIT_MINIMAL_DOUBLING_RECIPROCAL_2026-07-11.md`;
- `MasslessBlochCrossingClassification.lean`;
- `MasslessChargeCensusComposition.lean`;
- `PositiveWeylBranchCompleteness.lean`;
- `FiniteNoSignaling.lean` and existing finite translation/register patterns;
- `MEMO_3PLUS1_ATTACK.md`.

## Required output

1. Give exact finite types for phase corners, `Z2^3` flavour, reduced-zone
   representatives, covering map, and translation action.
2. State a first theorem proving every old corner alias has exactly one
   reduced-zone representative plus a unique flavour label.
3. State an intertwining theorem between the original symbol pulled back along
   the cover and an enlarged-register block symbol.
4. State the determinant/root-census corollary honestly: aliases become flavour
   multiplicity; say exactly what physical multiplicity remains.
5. Supply a nonidentity explicit witness and a wrong-cover negative control.
6. Identify which statements can use finite `decide`, which need matrices, and
   which require topology/analysis.
7. Recommend a sequence of two focused Aristotle proof packages that can land
   tonight, with declaration signatures and imports.
8. Audit whether an eight-flavour register helps or hurts the paper's claim to
   derive observed particle multiplicities.

```yaml
aristotle:
  project_id: 183d920d-a3ae-43f3-a5f4-9421bbafed2f
  task_id: 88a4d101-3cd4-43b1-ba8f-068a5707ee14
  target_file: review-only
  expected_module: B_Z2CUBED_FLAVOUR_COVER_STRATEGY_REPORT.md
  expected_report: AgentTasks/24h-publication-run-2026-07-12/B_Z2CUBED_FLAVOUR_COVER_STRATEGY_REPORT.md
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-z2cubed-flavour-cover-strategy-20260711-project
  output_dir: AgentTasks/aristotle-output/183d920d-a3ae-43f3-a5f4-9421bbafed2f
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Harvested 2026-07-11 23:55 PDT. The report is live at
`B_Z2CUBED_FLAVOUR_COVER_STRATEGY_REPORT.md`. Its decisive audit finding is
that the successive-axis symbol sees the deck action only through a scalar
parity sign: the cover relabels an eightfold multiplicity and does not remove
or dynamically mix it. The first finite census package was integrated as
`PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner` and passes direct Lean.
