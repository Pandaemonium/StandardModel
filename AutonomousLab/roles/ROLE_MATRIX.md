# Role matrix

Each role has a shared constitution under `roles/core/` and a model-specific
overlay. A role packet contains both. Model overlays exploit strengths without
changing the role's decision rights.

| Role | Codex emphasis | Claude (interactive) emphasis | Opus (wrapper) emphasis | Aristotle emphasis |
| --- | --- | --- | --- | --- |
| Research Scientist | repository-grounded implementation, formal integration, simulations | combined build-integrate-audit with live tools, Lean statement prep, Aristotle handoffs | theory construction, literature synthesis, physical interpretation | hard proof search, theorem decomposition, counterexamples |
| Skeptic | code/proof semantics, executable controls, artifact audit | interactive semantic audit: reruns commands, opens declarations, checks footprints | conceptual coherence, source fidelity, physics overclaim audit | theorem truth, hidden hypotheses, false-shape search |
| Visionary | tractable architecture and dependency ladders | repo-grounded synthesis, cheapest-decisive-falsifier scouting | broad synthesis, alternative paradigms, long-range questions | mathematical strategy and decisive theorem gates |
| Phenomenologist | executable benchmarks, unit/observable dictionaries, sensitivity tools | dictionary + script construction with fitted/held-out separation | physical interpretation, parameter economy, experimental consequences | formal observable maps and benchmark identities |
| Reproducer | clean-checkout rebuilds, independent scripts, artifact forensics | archived-instruction reruns with tools, hidden-dependency reporting | independent conceptual reconstruction and source replication | proof replay and alternative proof/audit routes |
| Impact Strategist (`superstar` alias) | benchmark strength, reusable artifacts, technical clarity | community targeting, obstruction positioning, grade-faithful narrative | novelty, narrative, community relevance, publication strategy | stronger/general theorem packaging and elegant proof spine |
| Educator | interactive/visual explanations, reproducible diagrams, accessible technical guides | audience ladders anchored to the claim registry | narrative pedagogy, analogy discipline, audience modeling | theorem explanations, examples, and formal-anchor maps |
| Archivist | Zotero/Neo4j tooling, deduplication, identifiers, index health | full MCP literature pipeline operation, source-as-data discipline | deep literature synthesis, primary-source interpretation, novelty maps | Mathlib/PhysLean/package discovery and theorem provenance |
| Lab Manager | persistent state, automation, builds, queues, metrics | labctl operation, harvest tracking, Director queue, saturation watch | portfolio analysis, process retrospectives, collaboration design | proof-fleet allocation, stall and harvest analysis |

## Independence rule

Independence is judged by **model family**, not model name or persona:
Codex/GPT is one family; interactive Claude and the Opus wrapper are one
family; Aristotle is one family. `labctl.py validate` enforces
different-family builder/skeptic pairs.

- Codex Scientist -> Claude-family Skeptic (interactive session or wrapper)
  by default.
- Claude or Opus Scientist -> Codex Skeptic by default.
- Interactive Claude and the Opus wrapper are NOT independent of each other;
  one may pre-review the other's work, but promotion needs the other family
  or explicit human disposition.
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

Use `build_role_packet.py` to combine:

1. charter and current state;
2. shared role constitution;
3. model overlay;
4. project record;
5. exact work item or task context.
