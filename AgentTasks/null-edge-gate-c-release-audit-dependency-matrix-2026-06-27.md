# Gate C release-audit dependency matrix

Date: 2026-06-27
Loop cycle: 29
Status: planning / integration guide

## Purpose

This matrix records which current module or task note owns each Gate C release-audit obligation after the recovered C90 integration and the cycle 23-24 toy guardrails.

It is not a release theorem. It is a map for avoiding overclaim and for preparing the next Aristotle bridge job.

## Dependency matrix

| Obligation | Current owner | What it provides | What remains open |
| --- | --- | --- | --- |
| C0 species health | `NullEdgeRAWilsonGap`, `NullEdgeGateC0SpeciesHealth`, pending C89/C101 | Abstract scalar-Wilson/anti-Hermitian gap logic and C0 language | Concrete full null-edge instantiation still pending returned C89/C101 |
| Branch-locus framing | `NullEdgeBranchLocusPhysicalSectorAPI` | C100-style physical-sector/branch-locus API and non-implication guardrails | Actual physical sector and analytic/local branch data |
| Branch classifier scaffold | `NullEdgeBranchClassifierAPI` | C104 `T_br` / branch-classifier planning scaffold | Existence, locality, gauge safety, and nontrivial physical instantiation |
| Projected Wilson release API | `NullEdgeProjectedGateCWilsonRelease` | Recovered C90 hardening: `ProjectedWilsonGateCRelease D_phys`, residue/ghost/BRST/moduli split | Construction of `D_phys`; proof that a real candidate satisfies every field |
| Raw overlap mass-window hazard | `NullEdgeDirectOverlapSingularCrossing` | C102 fixed-symbol mass-window/singular-crossing guardrail | Actual mass-window theorem or proof of unavoidable crossing |
| Scalar origin no-go | `NullEdgeScalarOriginBalancedKernelNoGo` | C103 scalar-on-origin balanced-kernel no-go | Classification of minimal non-scalar escape hatch |
| Route/projection/localization overclaim | `NullEdgeReleaseAuditToyGuardrails` | Finite counterexamples: route label, projection, localized line do not imply full audit | Bridge to C90/C100/C104 via C106 |
| Locality overclaim | `NullEdgeLocalityCertificateToy` | Finite counterexamples: formal projector does not imply locality; quasi-local is not ultralocal | Concrete locality or decay theorem for an actual sign/projector kernel |
| Retrieval freshness | `NullEdgeRetrievalFreshnessToy` | Process guardrail after doc-search refresh timeout | Successful Neo4j repo-doc ingest after recent edits |
| Ghost-zero safety | C90 plus pending C92 | C90 separates residue positivity from no ghost-zero safety | C92 should supply stronger countermodels/API if it returns |
| Overlap/GW interface | pending C93 | Expected C1-facing overlap/GW interface | Still running; do not build C94 until C93 returns |
| Gate H internal legality | `NullEdgeLegalFiniteDiracNeutrinoAudit`, pending H follow-ups | Internal finite-Dirac/neutrino stress-test support | Does not release Gate C |

## Near-term decisions

1. Do not submit C106 while the queue remains near eight running jobs unless the user asks for higher concurrency.
2. When C89/C92/C93/C101/P16/P17/C82/C70 return, integrate those before launching another broad Gate C job.
3. If no return appears, the best local work is a small bridge module importing C90/C100/C104 plus the toy guardrails.
4. Do not rely on repo semantic search for the newest cycle 18-28 edits until `neo4j_doc_search.py` changed-file ingest completes successfully.

## Claim boundary

This matrix supports planning only. It does not assert a physical chiral branch release, anomaly cancellation, locality theorem, or Standard Model spectrum theorem.
