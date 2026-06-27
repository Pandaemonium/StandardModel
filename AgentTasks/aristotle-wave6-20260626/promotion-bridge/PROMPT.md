# Wave 6 job: promotion bridge and integration triage after live verification

You are Aristotle. This is a no-build integration/promotion planning job. Use the files in `materials/` as context.

## Core request

Recent jobs reported live proof verification, kinetic normalization, NullSolderFrame foundations, super-Dirac sign/counterexample work, branch-count interpretation, high-momentum branch proof, and Krein counterexamples. The repo needs a precise promotion queue: what can be moved toward trusted Lean, what stays draft, what needs convention banners, and what should not be touched until gates pass.

## Tasks

1. Read the live proof verification report and classify each returned theorem/file as:
   - promotion candidate now;
   - draft-only but useful;
   - artifact requiring independent verification;
   - blocked by Gate A;
   - blocked by Gate C;
   - should not be promoted.
2. Produce exact promotion prerequisites for each candidate: imports, namespace, docstring/convention banner, source provenance, theorem-name changes, and required checks.
3. Identify any statement that is semantically too strong even if it kernel-checks.
4. Specify how to promote EW stabilizer and SM anomaly arithmetic if live verification says they are clean, while preserving caveats that they do not prove chiral SM realization or W/Z mass coefficients.
5. Specify what remains in Draft for the super-Dirac square, finite tetrad, branch count, and Krein pieces.
6. Produce a stop list: jobs or files that should not be promoted until Gate A or Gate C resolves.

## Guardrails

- The Lean kernel checks proof validity, not semantic alignment.
- No promotion of finite-square theorem packages until Gate A passes.
- No continuum/no-doubling promotion until Gate C passes.
- Krein self-adjointness is hygiene only.
- Branch-count no-go artifacts may be publishable as audits but not as success certificates.

## Deliverable

Write `AgentTasks/null-edge-wave6-promotion-bridge.md` with tables for candidates, blockers, prerequisites, and stop-list items.
