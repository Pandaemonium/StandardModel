# Literature added to Neo4j (overnight run, targeted at our challenges)

Real time ~06:00. 7 papers ingested into the null-edge Neo4j graph (collection
`9W59V3K9`) + embedded (semantically searchable via
`Scripts/lit/neo4j_paper_search.py`). NOTE: the `zotero_write` MCP server is NOT
wired in this session, so these were added DIRECT-TO-NEO4J (via
`lit_ingest.fetch_arxiv_meta` + `upsert_node`), with `paper_key = normalized
arxiv_id` and `source = 'arxiv-direct'`. Backfill the canonical Zotero item keys
when `zotero_write` is available (dedup is on `arxiv_id`/`doi`, so re-running the
full ingest will find and can re-key them).

## For the Q6 CRUX `pairSum_le_expBound` (the parked challenge)

The graph previously had ZERO cluster-expansion papers (top hits were unrelated
network-Laplacian papers). The crux's `pairSum_le_expBound` IS the Kotecky-Preiss
labeled-rooted-tree / tree-graph bound; these are the canonical machinery:

- **math-ph/0605041** - Fernandez & Procacci, "Cluster expansion for abstract
  polymer models. New bounds from an old approach" (2007). THE reference: the
  Penrose identity for truncated functions + iterated transformations to bound
  tree-graph expansions. The crux's tree-sum bound is exactly this shape.
- **2001.00652** - "Abstract polymer gas. A simple INDUCTIVE proof of the
  Fernandez-Procacci criterion" (2020). HIGH interest: an inductive proof that
  may SIDESTEP the explicit labeled-tree injection the crux is currently stuck on
  (`CRUX_PARKED_STATUS.md` residual #2). Recommended reading before the next crux
  attempt.
- **cond-mat/0309352** - Scott & Sokal, "The repulsive lattice gas, the
  independent-set polynomial, and the Lovasz local lemma" (2005). The tree bound /
  independent-set-polynomial view; Penrose, Shearer, Dobrushin lineage.
- **0707.0016** - Procacci, "Abstract polymer models with general pair
  interactions" (2007). Generalization.

## For the RP-LINK / transfer-gap / sign-rep character-expansion lane

- **2606.19362** - "Reflection-Positive Construction of a Four-Dimensional SU(N)
  Yang-Mills Theory with Mass Gap and Confinement" (2026). Source-mined on
  2026-07-06; detailed notes:
  `AgentTasks/paper-units/faizal-shabir-2606-19362-mining.md`. This is the
  closest recent blueprint for the project's Track A, but should be cited as a
  recent claim/audit roadmap, NOT as settled resolution of the continuum mass
  gap. Extracted spine: reflection-positive Wilson lattice -> positive transfer
  operator -> strong-coupling character/polymer expansion -> area law + temporal
  clustering -> finite-a transfer gap -> gauge-covariant FRD/locality ->
  reflection-positive multiscale blocking -> interlacing with summable defects
  -> OS limits/reconstruction -> universality by Lipschitz/telescoping ->
  claimed weak-coupling identification. Best immediate imports: Q6/Q7
  tree-graph/KP convergence, finite exponential-clustering-to-transfer-gap,
  abstract summable-defect gap transport, and finite Wilson-loop area-law
  transport. Audit cautions: the completely-monotone slice-projector proof needs
  a precise half-operator statement; gauge fixing/FMR/ghost/horizon-projector
  layers are avoidable in our finite first targets; gauge-covariant FRD and
  weak-coupling entry are the load-bearing continuum audit points.
- **1506.04197** - Jaffe & Janssens, "Characterization of Reflection Positivity:
  Majoranas and Spins" (2015). Necessary+sufficient RP conditions on a Clifford
  (Majorana) algebra with a reflection automorphism - the framework for the
  fermionic single-cut RP (`FermionicSingleCutRP.lean`) landed this run.
- **1802.09037** - "Reflection Positivity - A Representation Theoretic
  Perspective" (2018). General RP reference (the slab RP + Peter-Weyl context).

## Verification

All 7 are now top hits for their topic queries (e.g. the KP query returns
math-ph/0605041 at 0.87, 2001.00652/0707.0016 next; the RP+mass-gap query returns
2606.19362 at 0.86). Tags: cluster-expansion, reflection-positivity, fermionic-rp,
yang-mills-mass-gap (all also `null-edge`).
