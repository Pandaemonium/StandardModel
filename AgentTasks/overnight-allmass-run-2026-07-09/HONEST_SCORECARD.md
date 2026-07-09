# Honest scorecard — overnight all-mass run, 2026-07-09

*Draft by Claude (Opus). Codex: co-sign or contest — especially the Codex-lane
rows and the independent anchor sweep. Grades: **M** = kernel-checked in-project
(guard-pinned, footprint `[propext, Classical.choice, Quot.sound]`); **HELD** =
reviewed-correct but does not build in-project (build-cost, documented, not in the
manuscript); **no-go** = a pre-registered kill that fired.*

## Claude lane

| Module / result | Grade | Built in-project | Manuscript | Honest boundary |
|---|---|---|---|---|
| `Goal3ExactRG` (exact RG, ν=1, z=1) | **M** | yes | §9 + anchor | critical *line* (period-2), not a fixed point; finite rational, no continuum |
| `Goal3ChannelRG` (S4a kill-test) | **M** | yes (~420s) | §4a pt 4 + anchor | one rational model; basin-membership *survives* + sharpened, not a continuum reduction |
| `Goal3BoostCovRational` (boost cov.) | **M** | yes | §9 + anchor | mass-shell-set + Q-form invariance, not a spinor intertwiner |
| `SuiteAOp2Geom` (finite Malament) | **M** | yes | §7 + anchor | 2-point Krein carrier only |
| `Goal1Hadron` (toy hadron) | **M** | yes (~400s) | §6 + anchor | genuine = rungs 1–4; finite toy, no pion/rho, no continuum |
| `Goal1Rung5Tie` (b_C correction) | **M** | yes | §6 + anchor | **inverts a modelled claim**: closure ENERGY <0 but SHARE b_C=16/5 ≥ 0 |
| `FiniteCPT`, `RPSelectsLorentzian`, `BargmannCP` | **M** | yes | §8 (+ fut-dir) | witness-scoped; BargmannCP solid-angle reading = commentary |
| `FamilyRankNoGo` | **no-go** | yes | fut-dir | 3 generations not forced; only `AnomalyStruct` is a faithful candidate |
| `GradedDecompUniqueness` | **M (abstract)** | yes | fut-dir | generic graded-uniqueness only, NOT carrier-specific |
| `Goal3BoostCov` (trig) | **HELD** | no (582s) | — | superseded by `Goal3BoostCovRational` |
| `PathSumSemantics` (B1) | **HELD** | no (595s) | — | ℂ-heavy; result documented |
| `ComptonBound`/`…Sq` (D5) | **HELD** | no (595s/213s) | — | `Real.sqrt`/`nlinarith`; result documented |
| `SuiteDEntropyMonotone`/`…Real` (D2) | **HELD** | no (389s/350s) | — | ℂ then `nlinarith`-degree; result documented |

## Codex lane (from ledger — Codex to confirm)

| Module / result | Grade | Notes |
|---|---|---|
| `KMPhaseCounting` | **M** | finite CKM split; `0<physCP ↔ 3≤N` |
| `FiniteKMCP` | **M** | N=2 no-go + N=3 Jarlskog witness `J=6912/78125≠0` |
| `WEPTrace` | **M** | WEP as a finite trace identity (Goal IV cheapest rung) |
| `MassResourceModularAudit` | **M** | Suite D modular false-shape guardrail |
| general-N incidence / Goal IV action / C3 index=anomaly | in flight | were running at cutoff — Codex to harvest |

## Cross-checks passed
- Every **M** row: in-project `lake build` green, guard-pinned, cited names
  grep-verified in-file. Anchor table sweep note lists all 2026-07-09 additions
  pending the independent sweep.
- Codex manuscript audit: no false-shape/vacuity/hidden-hypothesis; 2 LOW findings fixed.
- No `sorry`/`admit`/`native_decide` anywhere in landed code.

## The one caveat a reader should carry
The **HELD** modules are correct mathematics that simply exceed our in-project
build budget (systemic ~10–20× slowdown vs Aristotle's environment). Their results
are reviewed and documented but are **not** M anchors and are **not** in the
manuscript. If the toolchain build-speed is addressed, they land unchanged.
