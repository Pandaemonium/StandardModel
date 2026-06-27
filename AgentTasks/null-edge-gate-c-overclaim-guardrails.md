# Gate C overclaim guardrails (living note)

Single home for the "X is not a release / not an audit / not a certificate"
guardrails the autonomous loop keeps rediscovering. Append new findings here as
one entry each; do NOT create a new per-cycle file, and do NOT encode these as
Lean `Bool`-record "theorems" (see the no-checklist-as-Lean rule in
`AgentTasks/autonomous-loop/AGENTS.md`). These are planning discipline, not
mathematics about the null-edge operator.

Related: `docs/NULLSTRAND.md` (claim-boundary labels, Gate C branch-topology
guardrail), `AgentTasks/null-edge-gate-c-redesign-roadmap.md` (section 6),
`AgentTasks/null-edge-golterman-shamir-ghost-zero-audit.md` (three-line branch
audit). A full Gate C1 release still requires a concrete `D_phys`, branch
selection, mirror-sector inverse-propagator gap, anomaly accounting, ghost-zero
safety, Krein/spectral positivity, and locality or controlled quasi-locality.

## Catalogued overclaim traps

Each line is a thing that looks like progress toward a chiral release but is not,
with the reason. (Rolled up from the cycle-18..22 Track B notes and the former
toy guardrail modules `NullEdge{ReleaseAuditToyGuardrails,LocalityCertificateToy,
RetrievalFreshnessToy}`, removed 2026-06-27 as checklist-as-Lean.)

- **Route label is not a release.** An overlap / Ginsparg-Wilson-style route
  label is useful vocabulary, not a release certificate. (cycle21
  gw-vocabulary-overclaim.)
- **Projection is not a release.** A projection or visible-sector reduction
  selects a sector; it does not gap the mirror sector or discharge the audit.
  (cycle20 projection-not-release.)
- **Localization is not a release.** A localized one-Weyl-line candidate is
  closer to a route but still lacks every safety clause. (cycle22
  localization-not-release.)
- **Formal projector is not a locality certificate.** A projected/sign-kernel
  description must still state explicitly whether it has a finite-range
  (ultralocal) certificate or a controlled quasi-local decay certificate; and a
  decay certificate is not an ultralocal certificate. (former LocalityCertificateToy.)
- **Observer erasure is not ghost safety.** Tracing out hidden labels (an
  observer/resolution operation) is not the same as a gauge-coupled ghost-zero
  audit. (cycle18 observer-erasure-not-ghost-safety.)
- **A deformation-dependent quantity is not an invariant.** If a proposed
  invariant shifts under the release deformation, it is leaking deformation data,
  not certifying release. (cycle19 deformation-dependent-invariant-leak.)
- **A nonzero flavored index is not a release.** A computed index never releases
  Gate C on its own; ghost-zero and Krein-positive safety must be accounted
  separately. (see the ghost-zero audit's `index_nonzero_not_sufficient`.)

## How to use this note

When a cycle is tempted to record "candidate has property P, therefore closer to
release," check P against the list. If P is already here, cite the entry and move
on; do not re-prove it. If P is genuinely new, add one line here with its reason
and the cycle that found it. Only promote a guardrail to Lean if it can be stated
about real mathematical objects (operators, matrices, spinors) - the
`NullEdgeBranchClassifierAPI` and `NullEdgeScalarOriginBalancedKernelNoGo`
modules are the pattern; the deleted `*Toy` Bool-record modules are the
anti-pattern.

## Process freshness (non-Lean)

Semantic-search freshness is a tooling concern, not a theorem: a repo-doc search
result is not automatically fresh for a claim that depends on recently edited
files if the index was not refreshed after the change. Track this in the
friction log and the literature record, not in Lean. (Former RetrievalFreshnessToy;
see the `neo4j_doc_search` changed-file refresh follow-up.)
