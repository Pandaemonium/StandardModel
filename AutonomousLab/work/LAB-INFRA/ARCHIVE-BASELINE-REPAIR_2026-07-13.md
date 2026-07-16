# Archive baseline repair: canonical identities and source tranche

## Metadata

- Work item: `ARCHIVE-BASELINE-001`
- Operator: Codex / Archivist
- Date: 2026-07-13
- Scope: canonical paper identity repair, active-manuscript arXiv linkage,
  and the first primary-source verification tranche

This report records bounded Zotero/Neo4j mutations and source-registry edits.
It does not promote a manuscript claim merely because a paper record exists.

## Canonical identity repair

The graph contained two `Paper` nodes for arXiv `1709.04891`. The canonical
node is now the bare Zotero key `5J5XDKMN`, which carries DOI
`10.1007/JHEP11(2021)070`. Relationships from legacy graph key
`zotero:SZJE69PE` were moved to the canonical node, chunk `paper_key` values
were normalized, and only the legacy graph node was deleted. The verification
query returned one graph paper, 91 relationships, and the preserved DOI,
authors, tags, concepts, collection, and chunks.

Zotero itself still contains items `5J5XDKMN` and `SZJE69PE`. The configured
write interface has no delete operation, so deleting or merging the remaining
library duplicate is explicit manual debt. The graph is canonical; the Zotero
library is not yet fully deduplicated.

## Active manuscript arXiv coverage

All ten exact arXiv gaps from the accepted baseline now have one canonical
graph path. Existing Zotero records were reused where present; additions went
through `Scripts/lit/lit_ingest.py`, whose pre-add check is keyed on normalized
arXiv ID or DOI rather than title.

| arXiv ID | Canonical key | Action |
|---|---|---|
| `1308.1697` | `IZDBNPRQ` | added and linked |
| `1212.2839` | `KTQS6SDD` | reused existing Zotero item and linked |
| `1509.08851` | `QT3JBHSQ` | added and linked |
| `2404.09840` | `8RZQA73D` | reused existing Zotero item and linked; DOI preserved |
| `0910.3675` | `6MZT3FBH` | added and linked |
| `1608.04696` | `SH5N2H8Q` | added and linked |
| `2006.04204` | `RCSSD8MZ` | added and linked |
| `1912.08854` | `U5M94GFX` | added and linked |
| `2405.08863` | `4CVWW854` | added and linked |
| `2603.15770` | `PHID9MVK` | added and linked |

## Primary-source verification tranche

The source map contained 22 actual table rows marked `NEEDS-VERIFY`; the
larger count of 26 included the status definition and workflow prose. Twelve
rows were resolved in this tranche. `Sources/Null_Edge_References.md` now
distinguishes metadata verification, content checks, claim-scope debt, and
source mismatch.

| Registry row | Canonical source or key | Disposition |
|---|---|---|
| Neuberger overlap | `9H7HA39S`, `hep-lat/9707022` | Primary abstract checked for the overlap determinant, no unwanted doubling, and no fine tuning; no transfer to the project theorem asserted. |
| Atiyah-Singer | DOI `10.2307/1970715` | Publisher metadata checked; applicability hypotheses remain claim-scope debt. |
| Jones/Thompson | `K68ST6N4`, `1412.7740` | Source mismatch: the paper constructs representations and local scale transformations; it is not a covariance-obstruction theorem. |
| Witten positive energy | DOI `10.1007/BF01208277` | Canonical metadata checked; asymptotic, constraint, regularity, and spin hypotheses remain load-bearing. |
| Weinberg-Witten | DOI `10.1016/0370-2693(80)90212-9` | Abstract checked and both Lorentz-covariant current/tensor hypotheses recorded. |
| Marolf emergent gravity | `PCHEN9K7`, `1409.2509` | Primary text checked for the boundary-Hamiltonian/local-kinematics obstruction. |
| Benincasa-Dowker | `JUVWME9X`, `1001.2725` | Primary abstract checked for the causal-set operator, curvature term, and action; broader order-plus-number reconstruction remains separate debt. |
| Kaloper-Padilla | `R4P8ESMS`, `1309.6562` | Primary abstract checked for protected-sector sequestering; no null-edge derivation asserted. |
| Furey charge operator | `EQUGNJWS`, `1603.04078` | Identifier reconciled against the arXiv export record: it lists the 2016-03-13 posting, the 2015 Phys. Lett. B journal reference, and DOI `10.1016/j.physletb.2015.01.023`; project basis conventions still require `ConventionBridge`. |
| Distler-Garibaldi | `CEQ6URHZ`, `0905.2658` | Primary theorem scope checked; recorded as a no-go under the paper's explicit chirality and representation hypotheses, not every E8-inspired model. |
| Springer-Veldkamp | DOI `10.1007/978-3-662-12622-6` | Publisher metadata and the Triality chapter, pp. 37-67, checked; not a verbatim XOR-basis convention source. |
| PDG lepton masses | PDG 2024, Phys. Rev. D 110, 030001 | Official data-source record checked; numerical extraction and uncertainty propagation remain version-pinned calculation debt. |

Primary records used in the checks include the
[Annals Atiyah-Singer record](https://annals.math.princeton.edu/1968/87-3/p05),
[Springer-Veldkamp book record](https://link.springer.com/book/10.1007/978-3-662-12622-6),
[2024 Particle Data Group site](https://pdg.lbl.gov/index-2024.html), and the
primary arXiv records linked by identifier above.

## Graph ingestion and exact verification

The source tranche used a dry run before every add. Existing graph records
`9H7HA39S` and `JUVWME9X` were reused. Five canonical records were added or
linked:

| arXiv ID | Key | DOI |
|---|---|---|
| `1603.04078` | `EQUGNJWS` | `10.1016/j.physletb.2015.01.023` |
| `0905.2658` | `CEQ6URHZ` | `10.1007/s00220-010-1006-y` |
| `1412.7740` | `K68ST6N4` | none in the record |
| `1409.2509` | `PCHEN9K7` | `10.1103/PhysRevLett.114.031104` |
| `1309.6562` | `R4P8ESMS` | `10.1103/PhysRevLett.112.091304` |

The exact post-add query is stored in
`archive_baseline_source_tranche_query.json`. It returned exactly one paper for
each requested arXiv ID.

## Remaining source debt

Ten actual `NEEDS-VERIFY` rows remain:

1. Nielsen-Ninomiya.
2. McKean-Singer.
3. Connes real-structure / KO convention.
4. Tomita-Takesaki state-dependent modular convention.
5. Shale-Stinespring implementability.
6. Malament causal-order theorem.
7. Hawking-King-McCarthy causal-order theorem.
8. Hyperuniformity and Coulomb sum rules.
9. Koide's original relation.
10. Wilczek's "Mass without mass" essays.

No unresolved row was silently promoted. Metadata-only records retain explicit
claim-scope debt, and the Jones attribution is marked `SOURCE-MISMATCH`.

## Reproduction commands

```powershell
$py = 'C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe'
& $py Scripts/lit/lit_ingest.py `
  hep-lat/9707022 1603.04078 0905.2658 1412.7740 1409.2509 `
  1001.2725 1309.6562 `
  --collection 9W59V3K9 --tag null-edge-program `
  --tag archive-baseline-repair --dry-run

python Scripts/mcp/mcp_call.py neo4j_graph read-cypher `
  --args-file AutonomousLab/work/LAB-INFRA/archive_baseline_source_tranche_query.json `
  --timeout 60

rg -n "NEEDS-VERIFY" Sources/Null_Edge_References.md
python AutonomousLab/scripts/labctl.py validate
```

## Verdict

The canonical graph and manuscript-arXiv coverage gates are substantially
repaired, and source debt fell from 22 actual rows to 10. The work item remains
open: the Zotero library duplicate, ten source rows, convention checks, and
portfolio-wide claim-to-primary-text audit are not complete.
