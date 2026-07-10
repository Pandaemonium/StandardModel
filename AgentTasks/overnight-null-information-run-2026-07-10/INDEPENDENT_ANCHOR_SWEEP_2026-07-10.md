# Independent manuscript anchor sweep - 2026-07-10

Pre-audit snapshot at 06:44 PDT. This checks declaration/module existence first
and then records the semantic boundaries that existence alone cannot certify.

## Existence result

Every backtick-delimited payload token in `MANUSCRIPT_CLAIM_MATRIX.md` rows
M1-M22 resolves to a live Lean declaration/module or the live simulator path.
The sweep used each exact token, or the declaration suffix after its namespace,
against `PhysicsSM/**/*.lean` and `Scripts/**/*.py`. There are no missing anchor
names in the matrix at this snapshot.

This is not a proof that prose matches type. The hard audit must still inspect
the wrapped definitions, hypotheses, witnesses, controls, and assumption
footprints.

## High-risk semantic findings

| Row | Existence | Controlling semantic boundary |
|---|---|---|
| M5 | pass | Fixed-momentum `1+1` recovery and abstract summable synthesis do not prove a walk-specific position/PDE limit. |
| M6 | pass | The simultaneous six-channel coin is killed only for a scalar-square four-block. The successive-axis Route B is a separate selected construction; its finite spatial Clifford dictionary is landed, while the compact rate and physical continuum remain open. |
| M12 | pass | Event-count/Lambda fluctuation statements depend on the displayed ensemble/statistics assumptions; they do not predict the observed value or sign of Lambda. |
| M14 | pass | Live laboratory count is 20: 17 V0/V1 and only S18, S21, S22 at V2. There is no V3/V4 and no prediction. |
| M18 | pass | `pathAction` is a positive least-residual action whose zero locus characterizes a selected unitary EOM. It is not a stationary-action derivation of the unitary and is not the shared Pluecker-Dirac field action. |
| M20 | pass | One pair supplies one mass scalar across five interfaces, but flow conservation and both Gibbs derivative laws are generic once the stiffness/spectrum is supplied. The theorem is a real anti-fragmentation seam, not an end-to-end physical derivation. |
| M21 | pass | The same literal `massSq` is substituted into the Gibbs gap and internal Dirac mass slot, with exact dispersion/tangent and controls. This closes parameter identity, not equality of state carriers or derivation from one action. |
| M22 | pass | Instrument consistency is derived from Kraus completeness and matrix hypotheses; the trace outcome rule is explicitly imported, so this is not a Born-rule derivation or decoherence theory. |

## Verification snapshot

- `lake build PhysicsSM.Draft.NullEdge.OvernightTheoryAxiomGuard`: PASS, 8,094 jobs;
  both `FiniteUnitaryPathAction` and `FiniteInstrumentAPI` are consolidated-guarded.
- New bridge/path-action strict token scan: PASS on four files.
- `python Scripts/sim/null_information_lab.py --all`: PASS, 20 families at the
  latest audited state; artifact `Scripts/sim/results/20260710-064524/results.json`.
- `git diff --check`: PASS before this note.
- `lake build PhysicsSMDraft`: FAIL only on known optional native-Windows
  Sphere-Packing imports. No overnight null-edge target failed; no full-root
  PASS is claimed.

## Hard-audit focus

1. Inspect every theorem type behind the rows marked high risk above.
2. Confirm all M/T/C/import labels in the manuscript agree with this split.
3. Keep the bold finite-architecture thesis, but reject shared-action,
   continuum-theory, and predictive-theory closure unless their exact open
   arrows land.
