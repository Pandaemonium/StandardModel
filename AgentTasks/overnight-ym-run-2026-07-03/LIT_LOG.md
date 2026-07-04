# Literature log: overnight YM run 2026-07-03

Standing target list (worked top-down by T6, woven through all lanes)
plus the append-only log of searches-that-mattered and ingests. Protocol
in `RUN_PLAN.md`. Every entry in the debt register was cited FROM MEMORY
in the freeze/program docs - treat every remembered identifier, year,
and hypothesis as unverified until checked against the source.

## Standing targets (priority order)

1. **Osterwalder-Seiler 1978** (Ann. Phys., lattice gauge RP +
   strong-coupling expansion). Verify: the exact link-reflection
   positivity statement and hypotheses; the LINK vs SITE reflection
   distinction as they state it; the strong-coupling convergence regime.
   Affects: T1 claim language (flagship paper), T5 (YM4-a/b/c statement
   shapes). Load-bearing.
2. **Elitzur 1975** (Phys. Rev. D). Verify: original statement and proof
   scope vs the freeze's quantitative volume-uniform version (which is
   self-contained; this is attribution only). Affects: YM1 paper
   attribution; the shipped `ElitzurCore`/`ElitzurLattice` docstrings.
3. **Kotecky-Preiss 1986 (CMP) + Ueltschi's form of the criterion**.
   Verify: the exact KP condition (weight function, the `a(gamma)`
   choice, what "cluster expansion converges" concludes, tail bounds).
   BLOCKS T5's Lean statement freeze (F-YM-LIT: a wrong hypothesis here
   poisons the most reusable module on the ladder). Load-bearing.
4. **Wegner 1971** (J. Math. Phys., Z2 gauge dualities). Verify:
   statement of the 2D/3D dualities for the YM1 paper's positioning
   section. Dualities are NOT tonight's formalization scope.
5. **Wilson 1974** (Phys. Rev. D). Verify: the strong-coupling
   confinement argument's actual claim (for YM4 positioning and the
   plaquette-action attribution).
6. **Banks-Casher 1980**. Verify: original relation and conventions vs
   the freeze s8 finite shadow. Affects T4 statement docstring.
7. **Jaffe-Witten official problem statement + CMI rules**. Verify:
   exact wording of the existence + gap requirements and the
   universal-quantifier-over-G scope. Affects: all prize-adjacent claim
   language (F-YM-CONFLATE guard text).
8. **Prior-formalization novelty check** (gates every "first ever"
   sentence). Search: has ANYONE formalized lattice gauge theory,
   Wilson-action gauge invariance, transfer matrices, or reflection
   positivity in Lean/Isabelle/Coq/HOL? Check: AFP index, Mathlib +
   PhysLean (lean-explore), arXiv (cs.LO + hep-lat crossovers), Zulip
   archives via web. Record the verdict WITH the searches run, whatever
   it is. A negative result (someone did it) is a first-class finding.
   Load-bearing.
9. **2D YM rigorous constructions** (Driver, Sengupta, Levy; Migdal 1975
   heuristic). Verify: which continuum 2D results exist rigorously, for
   YM2 positioning. Low urgency tonight (YM2 is not in scope) but cheap
   to resolve while in the literature.
10. **Modern probabilistic school** (Chatterjee surveys; Cao-Chatterjee
    master-loop equations; related recent work through 2025-2026 - the
    training-data horizon means RECENT work is exactly what the graph
    and web must supply). Verify: current state of the art on
    strong-coupling Wilson loops and any YM6-relevant partial progress.
    Affects: program doc s11 corrections and the strategy partner job's
    context.
11. **Balaban UV-stability series** (mid/late 1980s). Verify: paper
    list, scope (finite volume, per-scale bounds, NOT a full
    construction), and the community's current assessment of
    Magnen-Rivasseau-Seneor 1993. Affects: YM5 audit planning only; do
    not formalize anything from it tonight.

## Standing rules

- Prior-art check before EVERY new theorem statement drafted tonight
  (one `--query` pass minimum; log only if it changed something).
- `--chunks` full-text search whenever a claim depends on a paper's
  internals; never trust the abstract for a hypothesis.
- Ingest anything load-bearing via `Scripts/lit/lit_ingest.py` with the
  pre-add existence check (arxiv_id/doi, not title); collection scoping
  needs the IN_COLLECTION edge to `9W59V3K9`.
- Corrections to the freeze or program doc discovered here go through a
  `corrections:` thread (claim-language edits need cross-review).

## Log (append only)

Format per entry:

```text
### [HH:MM] <agent> - <target item or ad-hoc search>
Searches run: ...
Verdict: ...
Ingested: <paper_key(s) or none>
Affects: <claim / statement / decision>
```

### [planning session, pre-run] claude - graph state + seed identifiers
Searches run: neo4j_paper_search --query on RP/Osterwalder-Seiler,
strong-coupling mass gap, cluster expansion/KP (all < 0.76, off-topic);
web search for Chatterjee survey and prior formalizations.
Verdict: the graph contains NO YM-ladder literature - all T6 items are
discovery + ingest. Neo4j was down and was restarted headlessly (see
PREP_NOTES.md section 4; re-verify at T0). Verified IDs to ingest:
arXiv:1803.01950 (Chatterjee survey), 2204.12737, 2309.07399; Nature
Rev. Phys. 2025 s42254-025-00909-2 (community assessment, verify
content). Pre-arXiv classics still unverified-from-memory.
Novelty check (item 8) preliminary: arXiv:2606.07922 + repo
github.com/jonwashburn/shape-of-logic is the closest adjacent art
(Lean + RP language, but RP is text-proof there, and not LGT) - scope
the flagship claim against it BEFORE any "first" sentence ships.
Also observed: 1709.04891 duplicated in graph (5J5XDKMN + malformed
key `zotero:SZJE69PE`) - dup-key pathology, log-only for tonight.
Ingested: none (left to T6 with the pre-add existence check).
Affects: T6 workload estimate; item 8 scoping; flagship claim language.
