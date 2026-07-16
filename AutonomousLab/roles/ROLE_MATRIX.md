# Role matrix

Each role has a shared constitution under `roles/core/` and a model-specific
overlay. A role packet contains both. Model overlays exploit strengths without
changing the role's decision rights.

| Role | Codex emphasis | Claude Code emphasis | Aristotle emphasis |
| --- | --- | --- | --- |
| Research Scientist | repository-grounded implementation, formal integration, simulations | theory construction, live build-integrate-audit work, literature synthesis, Lean statement prep, Aristotle handoffs | hard proof search, theorem decomposition, counterexamples |
| Skeptic | code/proof semantics, executable controls, artifact audit | conceptual coherence, source fidelity, interactive semantic audit, physics overclaim audit | theorem truth, hidden hypotheses, false-shape search |
| Visionary | tractable architecture and dependency ladders | broad repo-grounded synthesis, alternative paradigms, long-range questions, cheapest decisive falsifiers | mathematical strategy and decisive theorem gates |
| Phenomenologist | executable benchmarks, unit/observable dictionaries, sensitivity tools | physical interpretation, parameter economy, dictionary and script construction, experimental consequences | formal observable maps and benchmark identities |
| Reproducer | clean-checkout rebuilds, independent scripts, artifact forensics | archived-instruction reruns, conceptual reconstruction, source replication, hidden-dependency reporting | proof replay and alternative proof/audit routes |
| Impact Strategist (`superstar` alias) | benchmark strength, reusable artifacts, technical clarity | novelty, community relevance, obstruction positioning, grade-faithful narrative, publication strategy | stronger/general theorem packaging and elegant proof spine |
| Educator | interactive/visual explanations, reproducible diagrams, accessible technical guides | narrative pedagogy, analogy discipline, audience ladders anchored to the claim registry | theorem explanations, examples, and formal-anchor maps |
| Archivist | Zotero/Neo4j tooling, deduplication, identifiers, index health | deep literature synthesis, primary-source interpretation, full MCP pipeline operation, source-as-data discipline | Mathlib/PhysLean/package discovery and theorem provenance |
| Lab Manager | persistent state, bounded supervisor, leases, builds, queues, metrics | portfolio analysis, labctl operation, review routing, harvest tracking, process retrospectives | proof-fleet allocation, stall and harvest analysis |

## Independence rule

Independence is judged by **model family**, not model name or persona:
Codex/GPT is one family; interactive Claude Code is one family; Aristotle is
one family. `labctl.py validate` enforces different-family builder/skeptic
pairs.

- Codex Scientist -> Claude Code Skeptic by default.
- Claude Code Scientist -> Codex Skeptic by default.
- Multiple Claude Code personas are same-family self-review, not independent
  review.
- Aristotle outputs -> integration plus semantic audit by two different
  interactive families (either may integrate; the other audits).
- Aristotle cannot own a work item (owners must mutate lab state); it
  contributes proofs, audits, and counterexamples through jobs on an owned
  item, and can be the skeptic of record for a formal claim.
- A second persona from the same family is a self-review, not independent
  replication.
- Release candidates -> Reproducer from a family that did not build the
  primary artifact whenever possible.

## Invocation

Use `labctl.py role-start` to activate a role. It records the bounded duty in
`state/ROLE_SCHEDULE.json` and invokes `build_role_packet.py` to combine:

1. charter and current state;
2. shared role constitution;
3. model overlay;
4. project record;
5. exact work item or task context.

Periodic cadence is enforceable rather than aspirational: Visionary every 3
hours, Impact Strategist every 6 hours, Archivist every 6 hours, Lab Manager
every 3 hours, and Educator/Phenomenologist every 12 hours. Scientist is
continuous; Skeptic and Reproducer are event-driven gates. Completion requires
the contracted artifact and stores its SHA-256 digest.

In collaborative mode, periodic roles rotate model families when possible. In
solo mode, cadence continues under the active model and family rotation is
temporarily suspended. This provides continuous Visionary, Impact Strategist,
Archivist, Manager, Educator, and Phenomenologist coverage, but no same-family
activation can satisfy an independent Skeptic or Reproducer gate. See
`../SOLO_MODE.md`.
