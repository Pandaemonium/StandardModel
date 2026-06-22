# Null-edge overnight literature log

Date: 2026-06-21 / 2026-06-22 overnight loop

## Semantic-search status

The Neo4j vector indexes are online, and earlier checks showed the null-edge
document graph is populated. The local CLI semantic-search helpers could not be
run from this shell because the Neo4j environment variables are not inherited
here. For this cycle, MCP-backed Zotero/Neo4j checks were used for concrete
paper anchors, and the stale-index issue is recorded as an operational blocker
rather than hidden.

## Relative entropy / P9 source-visibility anchors

Existing Zotero anchors confirmed:

- `BHNTND4W`: Fawzi-Renner, "Quantum conditional mutual information and
  approximate Markov chains". Use for recoverability / approximate Markov
  diagnostics.
- `B68T629C`: Faulkner-Leigh-Parrikar-Wang, "Modular Hamiltonians for
  Deformed Half-Spaces and the Averaged Null Energy Condition". Use for the
  ANEC / relative-entropy bridge.
- `8TA2W3MV`: Saravani-Sorkin-Yazdi, "Spacetime Entanglement Entropy in 1+1
  Dimensions". Use for Sorkin-Johnston diamond-entropy guardrails.

Duplicate cleanup:

- Ceyhan-Faulkner, "Recovering the QNEC from the ANEC", arXiv:1812.04683 was
  already present as canonical key `TFGTQQTU`. A duplicate Zotero item
  `UEU4CUDW` was accidentally created after the initial title search missed
  the existing record. The duplicate Neo4j node was removed, leaving
  `TFGTQQTU` as the canonical graph key. Zotero still needs a manual
  merge/delete for `UEU4CUDW` because the Zotero API key is not exposed in this
  shell.

Why it matters: Ceyhan-Faulkner is the clean source for treating QNEC as a
relative-entropy / modular-flow consequence of ANEC-style data. For the
null-edge program it should remain a continuum motivation and positivity
guardrail, not a finite theorem we claim to have proved.

## Immediate effect on theorem planning

- The finite `RelativeEntropyObserverChannel` job should start with classical
  or finite-dimensional data processing before any QFT modular-flow claim.
- P9 source visibility should use Ceyhan-Faulkner only at Gate 4, after the
  finite observer-channel and source-functional APIs exist.
- Any manuscript text should say that ANEC/QNEC supplies the continuum target
  for the finite observer-loss/source-visibility analogy, not evidence that the
  finite toy model already satisfies QNEC.
