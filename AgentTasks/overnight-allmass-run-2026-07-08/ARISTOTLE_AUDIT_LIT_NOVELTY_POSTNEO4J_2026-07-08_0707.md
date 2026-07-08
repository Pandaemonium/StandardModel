# Aristotle audit job - post-Neo4j literature/novelty scope 2026-07-08 07:07 PDT

```yaml
aristotle:
  project_id: 43311bde-bed3-4f00-a50b-d4add76f6c0a
  task_id: 784c5bcb-c9f9-4f8f-934b-321144154902
  target_file: Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md
  expected_module: none
  submission_project: none
  output_dir: AgentTasks/aristotle-output/43311bde-bed3-4f00-a50b-d4add76f6c0a-extracted/784c5bcb-c9f9-4f8f-934b-321144154902_aristotle
  status: complete-harvested
```

Submitted with:

```powershell
aristotle submit (Get-Content -Raw AgentTasks/overnight-allmass-run-2026-07-08/ARISTOTLE_AUDIT_LIT_NOVELTY_POSTNEO4J_2026-07-08_0707.md)
```

## Result / harvest

- 2026-07-08 07:12 PDT: task COMPLETE; archive downloaded to
  `AgentTasks/aristotle-output/43311bde-bed3-4f00-a50b-d4add76f6c0a.tar.gz`
  and extracted under the `output_dir` above.
- Important limitation: Aristotle's request project did not include the actual
  manuscript file, so the returned P0 "re-check against real manuscript" was
  accepted literally. Codex ran local line scans over the live manuscript,
  report, scorecard, and results surfaces before applying changes.
- Semantic-alignment correction: Aristotle's checklist mapped
  `5VWPZ8BP` to Bizi-Brouder-Besnard. Local Neo4j search showed
  `5VWPZ8BP` is instead "On the definition of spacetimes in Noncommutative
  Geometry, Part I"; Bizi-Brouder-Besnard `1611.07062` remains ID-only in
  `Sources/Null_Edge_References.md`, with no local key/chunk yet.
- P0/P1 actions applied locally:
  - consolidated `Sources/Null_Edge_References.md` so the must-cite prior-art
    cluster is separated into KEYED-LOCAL vs ID-ONLY rows;
  - softened the manuscript's Zwanziger comparison from theorem-support
    language to background/caution language;
  - softened "two hard pillars of confinement and mass gap" to finite
    strong-coupling analogues;
  - re-scanned the live manuscript/report/result surfaces for primacy claims.
    Remaining hits are negations ("not a new 3+1D checkerboard", not "first
    verified physics").

## Prompt

You are Aristotle, asked for an audit-only literature/novelty scope review after
Neo4j came back online. Do not prove anything, do not formalize anything, and do
not open a Lean proof front. Return only P0/P1 novelty/source-scope findings and
safe wording recommendations.

Context:

1. The project is a Lean 4 / mathematical physics formalization project around
   finite null-edge transport, Krein-adjoint audits, determinant/Plucker
   kinematic mass obstructions, and guarded draft routes toward all-mass
   mechanisms.
2. The 06:00 local hard switch to audit/reporting mode is active. This job is
   only to keep the manuscript/report honest.
3. A Claude literature review just added or recommended close prior art:
   Foster-Jacobson 2016 4D null-face/Feynman-checkerboard no-doubling work,
   Bizi-Brouder-Besnard 2016 Lorentzian/Krein spectral triple work, Barrett 2007
   Lorentzian NCG Standard Model work, Zwanziger/lattice chiral symmetry,
   QCA/free-field constructions, and HepLean/machine-verified physics.
4. The current intended novelty posture has been narrowed. It should no longer
   claim "finite Krein triples are new" or "first verified physics." The
   defensible novelty is meant to be the combination of:
   finite null-edge determinant/Plucker mass accounting, explicit kill gates and
   overclaim discipline, Lean-checked finite algebraic statements, and a
   constructive-QFT-facing program architecture.
5. Neo4j is now live locally. Codex verified:
   - paper query for "Foster Jacobson 4D Feynman checkerboard ... Bizi Brouder
     Besnard ... Barrett Lorentzian noncommutative geometry Standard Model"
     returned, among others, `TN53N8J2` "Spin on a 4D Feynman Checkerboard"
     and `5VWPZ8BP` "On the definition of spacetimes in Noncommutative Geometry,
     Part I".
   - paper query for "Zwanziger lattice fermions ... QCA ... HepLean" returned,
     among others, `N68MN4ET` Ginsparg-Wilson, `BVJBTK8J` free QFT from QCA,
     `B7IRW5HZ` lattice Dirac/Weyl as QCA, and `arxiv:2503.05998` QED from QCA.
   - chunk searches for Ginsparg-Wilson/overlap/minimally doubled material now
     work, but Banks-Casher remains adjacent/later-mention only in the local
     graph.

Questions:

1. What P0/P1 novelty or source-scope risks remain if the manuscript uses the
   narrowed novelty posture above?
2. Which exact claims should be forbidden or softened in the morning report and
   manuscript given the close prior art?
3. What minimal "must cite / not yet source-quoted" checklist should Codex use
   for the final pre-handoff audit now that Neo4j is available?

Please answer in this format:

```text
P0:
- ...
P1:
- ...
Safe wording:
- ...
Forbidden wording:
- ...
Must-cite / source-status checklist:
- ...
```
