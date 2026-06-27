# FUR-L1: Foundational Furey/Baez source pack for theorem provenance

    Type: literature/audit

    ## Task prompt

    You are Aristotle. This is a source/provenance audit for the Furey/Baez bridge.

Context:
The repo's Furey modules cite foundational papers, but Claude's audit says some of those papers may not yet be curated in the project literature graph. The most important are:

- Furey arXiv:1806.00612, division-algebraic ladder operators / complex-octonion ideal construction.
- Furey arXiv:1810.10465, SU(3) x SU(2) x U(1) from octonions.
- Baez-Huerta arXiv:0904.1556, The Algebra of Grand Unified Theories.

Task:
1. Produce a theorem-provenance source pack mapping each relevant repo theorem/module to the correct paper and convention note.
2. Identify which source supports which claim: minimal ideal, ladder operators, gauge group quotient, SU(3) from G2, electroweak embedding, DVT/Jordan/triality, etc.
3. Flag any theorem whose docstring/provenance should be strengthened.
4. Provide Zotero/Neo4j tags and metadata suggestions for the three papers.
5. Do not ingest papers yourself; this is a source-pack/audit job.

Deliverable:
`AgentTasks/null-edge-furey-foundational-source-pack.md`.

    ## Included context files

- `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`
- `PhysicsSM/Algebra/Furey/FureyRealizesOneGeneration.lean`
- `PhysicsSM/Algebra/Furey/ElectroweakCompletePackage.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- `docs/CONVENTIONS.md`
