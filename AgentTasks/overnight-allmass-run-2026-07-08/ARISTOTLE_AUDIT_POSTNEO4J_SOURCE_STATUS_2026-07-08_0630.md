# Aristotle audit job - post-Neo4j source status 2026-07-08 06:30 PDT

```yaml
aristotle:
  project_id: df15aa40-de65-411a-9922-939cd3bec984
  task_id: fd930853-4d7e-4806-ad52-27d5cd5d5e53
  target_file: Sources/Null_Edge_References.md
  expected_module: none
  submission_project: none
  output_dir: AgentTasks/aristotle-output/df15aa40-de65-411a-9922-939cd3bec984-extracted/fd930853-4d7e-4806-ad52-27d5cd5d5e53_aristotle
  status: complete
```

## Harvest

Status: COMPLETE, harvested 2026-07-08 06:41 PDT.

Artifact archive:
`AgentTasks/aristotle-output/df15aa40-de65-411a-9922-939cd3bec984.tar.gz`.
Extracted output:
`AgentTasks/aristotle-output/df15aa40-de65-411a-9922-939cd3bec984-extracted/fd930853-4d7e-4806-ad52-27d5cd5d5e53_aristotle/`.

Verdict: no P0 blockers. Applied P1 edits:

- G5 now says Banks-Casher is adjacent/later-mention only, not
  adjacent/abstract-level.
- `Sources/Null_Edge_References.md` now says `BQJAG9TR` and `N68MN4ET` have
  full-text chunks located, not yet manuscript-citation-quoted.
- Scorecard G5 now states that literature support is only for background rails
  and caveats, not evidence for the null-edge program itself.
- "P0/P1 blocking findings all addressed" is scoped to exclude the deliberately
  PARTIAL Banks-Casher source anchor.

P2 verification items:

- `hep-th/9503153` title/key binding confirmed by Neo4j paper search.
- `2602.19767` binding confirmed by Neo4j read; its introduction mentions the
  Banks-Casher relation as background, not as a source-closure anchor.

Submitted with:

```powershell
aristotle submit (Get-Content -Raw AgentTasks/overnight-allmass-run-2026-07-08/ARISTOTLE_AUDIT_POSTNEO4J_SOURCE_STATUS_2026-07-08_0630.md)
```

## Prompt

You are Aristotle, asked for an audit-only post-Neo4j source-status review. Do
not open a proof front. Do not formalize physics. The 06:00 local switch to
audit/reporting mode is active.

Context: Neo4j was down during the first G5 literature verification pass, then
restarted. Codex reran chunk search and updated the source surfaces. Please act
as an adversarial source-auditor and identify only overclaims, missing caveats,
or exact sentence edits needed. Return findings in severity order and include
verbatim replacement wording for any sentence you think should change.

Current intended boundaries:

1. The generalized Lichnerowicz/Dirac-square rail is now keyed to local
   full-text chunks: `hep-th/9503153` / Zotero `BQJAG9TR`.
2. The Luescher/Ginsparg-Wilson rail is now keyed to local full-text chunks:
   `hep-lat/9802011` / Zotero `N68MN4ET`.
3. Banks-Casher remains **not** source-closed. Search found only adjacent
   lattice-spectrum/chiral-condensate records and a later introduction mention,
   not a clean original/source full-text anchor.
4. The current reporting should therefore say G5 is partial but strengthened,
   not closed.
5. Literature support must not be presented as proving the null-edge program;
   it only supports background rails and caveats.

Current live source-log snippets:

```text
[Codex] [direct] post-06 Neo4j rerun after service restart -> chunk search
succeeded. `hep-th/9503153` / Zotero `BQJAG9TR` returned top chunks for
generalized Lichnerowicz/Dirac-square/gauge-curvature wording, including chunk
8 with curvature commutator terms. `hep-lat/9802011` / Zotero `N68MN4ET`
returned top chunks for exact lattice chiral symmetry and the Ginsparg-Wilson
relation; `Sources/Null_Edge_References.md` updated from TBD to keyed/local
full-text-chunk status. Banks-Casher query found adjacent
lattice-spectrum/chiral-condensate chunks but not a clean original/full-text
anchor; G5 remains PARTIAL, strengthened only for the Lichnerowicz and GW rails.

[Codex] [direct] sharpened Banks-Casher source check -> INSPIRE query for
original Banks-Casher/chiral symmetry breaking returned no record; Neo4j
all-project paper search found adjacent chiral-lattice records (`XM6QTH2P`,
`N3MMUN7D`, `N68MN4ET`) but not a clean Banks-Casher original/source record;
Neo4j chunk search found adjacent lattice-spectrum/chiral-condensate chunks (top
hit `2602.19767` introduction mentions the relation), and Zotero direct search
found no item. Verdict: leave G5 PARTIAL for Banks-Casher; no keys ingested.
```

Current references rows:

```text
| `BQJAG9TR` | `hep-th/9503153` | "The generalized Lichnerowicz formula and analysis of Dirac operators" | Continuum Weitzenbock/Lichnerowicz comparison for carrier square and curvature-slot wording. | KEYED-LOCAL; full-text chunks found 2026-07-08 |
| `N68MN4ET` | `hep-lat/9802011` | Luscher, "Exact chiral symmetry on the lattice and the Ginsparg-Wilson relation" | Imported lattice-chirality convention; exact lattice chiral symmetry from the GW relation. | KEYED-LOCAL; full-text chunks found 2026-07-08 |
```

Current report/status snippets:

```text
G5 (lit chunk-level) partial but strengthened after Neo4j restart:
Lichnerowicz/Dirac-square and Luescher/Ginsparg-Wilson chunks checked; the
Banks-Casher source remains adjacent/abstract-level rather than fully
chunk-closed. Codex's P0/P1 blocking findings all addressed.

the finite Banks-Casher-type eigenvalue count (not the physical Banks-Casher
relation)

finite Banks-Casher-type eigenvalue count identity, spectral-rail safe; not the
physical Banks-Casher relation
```

Questions:

1. Do any snippets still imply that Banks-Casher is source-closed or physically
   proved?
2. Is "adjacent/abstract-level" precise enough, or should it be changed to
   "adjacent/later-mention only" or similar?
3. Are the two KEYED-LOCAL reference rows safe, or should either row say
   "full-text chunks located, not yet manuscript-citation-quoted"?
4. Are there any P0/P1 edits needed before morning delivery?
