# Summary of changes for run c6c9f03e-7ae9-4980-b81f-3b62b2158f2c
Produced the requested Furey/Baez foundational source pack at `AgentTasks/null-edge-furey-foundational-source-pack.md`. This is a literature/provenance audit only — no papers were ingested and no Lean code was changed.

What the source pack contains:

1. **Theorem-provenance map** — a per-module, per-declaration table mapping the three audited Furey Lean files (`MinimalLeftIdeal.lean`, `FureyRealizesOneGeneration.lean`, `ElectroweakCompletePackage.lean`) to the correct foundational paper and the relevant project convention (XOR octonion basis, e111 = e_7 via ConventionBridge, the Locked electroweak `Q = T₃ + Y/2` convention). I also flagged that the three files import several sibling modules that are absent from this snapshot, so the same assignments should be propagated when those are curated.

2. **Source → claim cross-index** — explicit attribution of each requested claim: minimal left ideal / idempotent ω (Furey 1806.00612 §2); ladder operators and number-operator charge (Furey 1806.00612 + Furey 2015); gauge group SU(3)×SU(2)×U(1) (Furey 1810.10465); electroweak embedding / hypercharge / Gell-Mann–Nishijima / anomaly bookkeeping (Baez–Huerta 0904.1556 + project EW convention + Peskin–Schroeder §20.2 already cited). I flagged that "SU(3) from G₂" and "DVT/Jordan/triality" are **not** realized in the audited files and their proper sources lie outside the three-paper pack, recommending separate curation rather than mis-attribution.

3. **Provenance-strengthening flags F-1…F-6**, notably: the `T12…T32` SU(3) generators are defined but the SU(3) action is explicitly "not yet formalized" (should be marked as scaffolding); `MinimalLeftIdeal`'s Sources block cites only one arXiv ID though its content also rests on Furey 2015 and Baez–Huerta; `basis_linear_independent`/`omega_bar` record proof-job provenance but not claim provenance; and `FureyRealizesOneGeneration` cites the gauge paper by journal string only (no arXiv ID).

4. **Zotero/Neo4j metadata** — BibTeX-style entries with suggested keys (`Furey2018ideal`, `Furey2018gauge`, `BaezHuerta2010GUT`), keyword tags, a suggested collection, and Neo4j node/relationship templates (`:Paper`, `:LeanModule`, `[:SUPPORTED_BY]`, `[:USES_CONVENTION]`, `[:CLAIM_BOUNDARY]`).

5. **Curator confirmation items C1–C3** — to avoid an unverified bibliographic claim, the arXiv↔journal correspondences for the two Furey papers are listed for confirmation rather than asserted; the repo currently cites the gauge paper only by its EPJC journal string, so that link should be verified before the two citations are merged into one graph node.
