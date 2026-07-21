# Glossary wave 1: infrastructure relaxation + 178-term drafting run (2026-07-21)

## What happened

First population wave of the Physics and Math Glossary (`docs/GLOSSARY.md`),
plus the link-policy change that enables top-down writing.

### Policy change: dangling links are backlog, not errors

Decided by the project owner: authors write full links assuming targets will
eventually exist; a script locates dead-end links so the targets can be filled
in later.

- `Scripts/glossary/common.py`: unwritten link targets no longer fail
  validation (kebab-case, self-link, and duplicate-target checks remain);
  new `missing_link_targets` helper; backlink index skips unwritten targets.
- `Scripts/glossary/validate.py`: prints a backlog summary; `--strict`
  restores the closed-graph behavior.
- `Scripts/glossary/gaps.py` (new): dead-end link report ranked by citation
  count - this ranking is the writing queue.
- `Scripts/glossary/build.py`: emits `Index/glossary/missing.json`.
- `Scripts/glossary/ingest.py` (new): batch intake for drafting agents;
  normalizes records (ASCII, link hygiene, forces `draft` status), shards by
  first domain, writes nothing unless the combined glossary validates.
- `Scripts/glossary/query.py`: `--neighbors` marks unwritten targets instead
  of crashing; browser UI renders them as dashed "planned" chips.

Scope decision: physics + mathematics + project coinages (domain `null-edge`).
Lean/formalization tooling jargon and lab-operations vocabulary are out of
scope. Review policy: promotion out of `draft` is a human decision; agents
must not set `reviewed`/`stable`.

### Wave 1 drafting run

Multi-agent workflow (run id `wf_5e43dcba-e2d`, 25 agents, ~2.06M subagent
tokens): 7 harvesters swept docs/NULLSTRAND.md, docs/CONVENTIONS.md, AGENTS.md,
docs/NERD_ROADMAP.md, NULL_EDGE_RESULTS.md, PROGRESS.md, both null-edge
manuscripts, the Dixon convention reference, and the future-directions and
portfolio docs; 337 unique candidates were deduplicated, 180 selected
(project coinages and multiply-cited terms first), 18 drafter agents wrote 10
records each.

Post-processing merged two transliteration duplicates (`pluecker-mass` into
`plucker-mass`, `xor-basis` into `xor-octonion-basis`, kept as aliases).
`null-strand` (five-strand principle) and `nullstrand` (program name) were
inspected and are intentionally distinct entries.

Result: **179 terms** in three shards (`mathematics.jsonl`, `physics.jsonl`,
`null-edge.jsonl`), all `status: draft`, validation clean, site built,
16-item gap backlog.

## Verification

- `python Scripts/glossary/ingest.py wave1-final.json` (178 added, 0 skipped)
- `python Scripts/glossary/validate.py` (passed: 179 terms, 3 shards)
- `python Scripts/glossary/build.py` (built 179 terms)
- `python Scripts/glossary/gaps.py` (16 unwritten targets)
- `pre-commit run --files <touched files>` (passed)

Spot-checked records: `vector-space`, `soldering`, `metric-signature`,
`octonion` - convention fields correctly state the locked project choices
(mostly-minus signature; XOR/Fano octonion convention with AGENTS.md anchor
products; dual soldering with the trace obstruction as program convention).

## Next wave

- `AgentTasks/glossary-wave2-queue.json` holds the 157 harvested-but-deferred
  candidates (id, term, domains, context, seen_in) - feed these to the next
  drafting workflow.
- `python Scripts/glossary/gaps.py` lists the 16 link targets the written
  graph already cites (helicity, parity, lie-group, partial-order, ...);
  fold them into wave 2.
- All 179 entries await human review (`draft` -> `reviewed` is human-only).
- Later waves: sweep PhysicsSM module docstrings and the Spin(10)/E8/
  checkerboard/spiral-layer lanes for jargon the doc sweep missed.
