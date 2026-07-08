# Aristotle audit job - final live wording/source-debt scope 2026-07-08 07:15 PDT

```yaml
aristotle:
  project_id: ce5cdb6a-387f-4a9c-84ae-108727b02877
  task_id: 27c3be49-0da4-4a01-b721-1c57e79ec9c7
  target_file: Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md
  expected_module: none
  submission_project: none
  output_dir: AgentTasks/aristotle-output/ce5cdb6a-387f-4a9c-84ae-108727b02877-extracted/27c3be49-0da4-4a01-b721-1c57e79ec9c7_aristotle
  status: complete-with-errors-harvested
```

Submitted with:

```powershell
aristotle submit (Get-Content -Raw AgentTasks/overnight-allmass-run-2026-07-08/ARISTOTLE_AUDIT_FINAL_LIVE_WORDING_2026-07-08_0715.md)
```

## Result / harvest

- 2026-07-08 07:22 PDT: task `COMPLETE_WITH_ERRORS`; archive downloaded to
  `AgentTasks/aristotle-output/ce5cdb6a-387f-4a9c-84ae-108727b02877.tar.gz`
  and extracted under the `output_dir` above. The error status did not block
  useful audit output.
- Findings accepted:
  - the HepLean parenthetical asserted specific chunk-level contents while the
    source is only exact-ID verified;
  - "to our search, unoccupied" and "plausibly among the first
    machine-checked fragments" were residual primacy/search-negative claims.
- Applied fixes in
  `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`:
  - HepLean is now cited only as `2405.08863`, exact-ID verified but not yet
    source-quoted;
  - the `det P` / indefinite-budget tie now says "we did not find ... and we
    make no primacy claim";
  - the constructive-QFT chain now says "a machine-checked instance ... on
    finite lattices" and explicitly disclaims priority relative to HepLean.
- Note: `[import]` is not an unresolved placeholder in this manuscript; it is
  the project claim-calculus tag for external imported results. The remaining
  issue is source-status specificity, not the marker itself.

## Prompt

You are Aristotle, asked for an audit-only final wording/source-debt review of
the live dawn surfaces. Do not prove anything, do not formalize anything, and do
not open a Lean proof front. Return only P0/P1 issues and exact wording fixes.

Important: the request project may not contain the actual manuscript files, so
the relevant live snippets are embedded below. Audit these snippets directly.

## Live snippets to audit

### Morning report source boundary

```text
7. **A narrowed novelty/source boundary after Neo4j came back**: the manuscript
   now treats finite Krein triples, no-doubling routes, QCA/free-field
   derivations, and machine-verified physics as occupied prior art, not as
   primacy claims. Foster-Jacobson, GW/Luscher, and several QCA-adjacent records
   are locally keyed; Bizi-Brouder-Besnard, Barrett, Bakircioglu-Arnault-
   Arrighi, HepLean, and Zwanziger 1991 are exact-ID verified but still need
   local ingestion/chunk checks before they can be called source-quoted.
```

### Scorecard G5 boundary

```text
G5 (lit chunk-level) remains PARTIAL, strengthened only for the
Lichnerowicz/Dirac-square and Luscher/Ginsparg-Wilson rails after the Neo4j
restart: top full-text chunks for those two rails were located, not yet quoted
against the manuscripts. The Banks-Casher rail is not source-closed - only
adjacent chiral-lattice records and a later paper's introduction mention
(`2602.19767`) were found, with no original/full-text anchor, no INSPIRE
record, and no Zotero item. This literature check supports background rails
and caveats only; it does not prove the null-edge program. Codex's previously
logged P0/P1 blocking findings are addressed, except the Banks-Casher source
anchor, which is deliberately left PARTIAL. A post-Neo4j novelty audit also
forced the related-work boundary: Foster-Jacobson (`TN53N8J2`), GW/Luscher
(`N68MN4ET`), and several QCA-adjacent records are locally keyed; Bizi-
Brouder-Besnard `1611.07062`, Barrett `hep-th/0608221`, Bakircioglu-Arnault-
Arrighi `2505.07900`, HepLean `2405.08863`, and Zwanziger 1991 are exact-ID
verified but still need local key/chunk ingestion. The manuscript therefore
uses no primacy claim for finite Krein triples, doubling avoidance, QCA/free-
field derivation, or machine-verified physics.
```

### Manuscript novelty paragraph

```text
What is new, stated by contrast - and narrowed after a literature
review. Neither the finite Krein setting (Bizi et al; Barrett) nor
machine-verified physics (HepLean, Tooby-Smith 2024, formalizes CKM, anomaly
cancellation, Higgs physics in Lean 4) [import] is new on its own, and we
do not claim either. The defensible novelty is the combination: (i) a
finite Krein null-edge carrier whose square is graded into a four-channel
budget `4 D^#D = Q_A+Q_C+4Q_T+E_#` that answers to the kernel-checked
Plucker mass invariant `det P` - the specific tie between an indefinite-
metric operator budget and the section 3 kinematic mass is, to our search,
unoccupied; (ii) a pre-registered kill-discipline (grades, oracle quarantine,
kill conditions) applied to a speculative unification - a working methodology,
not "first verified physics"; and (iii) kernel verification of a specific
constructive-QFT chain (reflection positivity -> OS reconstruction -> spectral
gap -> clustering), plausibly among the first machine-checked fragments in that
lineage. The pictures are borrowed and the individual ingredients are
occupied; the combination, the `det P`-answering budget, and the verified
kill-discipline are ours.
```

### Manuscript source/caution paragraphs

```text
Foster-Jacobson (2016), "Spin on a 4D Feynman Checkerboard" [import],
is now treated as the closest carrier prior art. Our novelty is at most
"cast the Foster-Jacobson null-face checkerboard as a Krein carrier and read
its mass budget," not a new 3+1D checkerboard.

Zwanziger's (1991) lattice confinement / positivity-violation setting is a
nearby comparison and a warning that this terrain is occupied, not source
support for section 6's finite balanced-closure theorem [import].

The strong-coupling pillars are kernel-checked (M). On concrete finite
lattices: the Wilson-loop area law, slab reflection positivity, an
OS-reconstructed spectral gap, and exponential clustering - finite
strong-coupling analogues of two hard pillars often associated with
confinement and mass-gap arguments.
```

## Questions

1. Any P0/P1 overclaim, source-status, or novelty issue remaining in these
   live snippets?
2. Does "plausibly among the first machine-checked fragments in that lineage"
   remain too strong given HepLean/verified-physics prior art? If so, provide a
   safer exact replacement.
3. Does "to our search, unoccupied" remain safe with the ID-only prior-art
   status, or should it be softened?
4. Any exact one-line warning to add to the final 8am handoff?

Return:

```text
P0:
- ...
P1:
- ...
Exact fixes:
- ...
Final handoff warning:
- ...
```
