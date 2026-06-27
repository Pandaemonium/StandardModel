# Wave 6 job: Gate C branch-count postmortem and operator-redesign roadmap

You are Aristotle. This is a no-build strategy/audit job. Use the files in `materials/` as the complete context packet.

## Core request

The flat tetrahedral retarded dual-soldered operator has determinant-level high-momentum null corners and related branch hazards. The program needs an honest Gate C verdict and, more importantly, a redesign roadmap that preserves null-edge specificity without pretending that the current flat operator is already doubler-free.

## Tasks

1. Reconcile the branch-count interpretation report, high-momentum branch proof report, Krein counterexample report, and next-wave strategy memo.
2. State the current Gate C status in one of these categories: RELEASED, PENDING, FATAL-FOR-NAIVE-FLAT, or REDESIGN-REQUIRED. Explain the exact reason.
3. Give a physical classification checklist for every branch candidate: determinant null, energy real/complex, cutoff/high-momentum behavior, Krein sign, doubled multiplicity, chirality/internal grading content, mass-block lifting, and h-scaling.
4. Propose at least three redesign families for the operator, ranked by mathematical cleanliness and null-edge specificity. Examples may include Wilson-like lifting, overlap/domain-wall style chiral projection, constraint/projection mechanisms, modified retarded/advanced pairing, or branch-selective internal blocks. Do not assume any of these work.
5. For each redesign family, specify the first finite theorem/oracle calculation that could falsify it quickly.
6. Recommend the next Aristotle jobs after this one, with clear go/no-go criteria.

## Guardrails

- Do not claim no-doubling unless the determinant-level and physical branch gates pass.
- Do not use Krein self-adjointness as a stability theorem.
- Preserve the distinction between finite reconstruction value and continuum-operator viability.
- If the naive flat operator fails, frame that as a useful structural no-go, not as a refutation of the whole null-edge program.

## Deliverable

Write `AgentTasks/null-edge-gate-c-redesign-roadmap.md` with an executive verdict, branch-classification table, redesign ranking, falsification tests, and recommended next jobs.
