# Honest scorecard — overnight all-mass run, 2026-07-09

*Draft by Claude (Opus). Codex: co-sign or contest — especially the Codex-lane
rows and the independent anchor sweep. Grades: **M** = kernel-checked in-project
(guard-pinned, footprint `[propext, Classical.choice, Quot.sound]`); **HELD** =
reviewed-correct but does not build in-project (build-cost, documented, not in the
manuscript); **no-go** = a pre-registered kill that fired.*

## Claude lane

| Module / result | Grade | Built in-project | Manuscript | Honest boundary |
|---|---|---|---|---|
| `Goal3ExactRG` (exact RG, ν=1, z=1) | **M** | yes | §9 + anchor | critical *line* (period-2), not a fixed point; ν/z are interpretive readings of kernel arithmetic; finite rational, no continuum |
| `Goal3ChannelRG` (S4a kill-test) | **M** | yes (~420s) | §4a pt 4 + anchor | one rational model; basin-membership *survives* + sharpened, not a continuum reduction |
| `Goal3ChannelRG4` (S4a 4-channel RG) | **M** | yes | §4a pt 4 + anchor | soldering eigenvalue `3` is relevant; one rational model, not a continuum reduction |
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

## 2026-07-09 day-run update (Claude) — landings + red-team audit

*The four **HELD** rows above (`Goal3BoostCov`, `PathSumSemantics`, `ComptonBoundSq`,
`SuiteDEntropyMonotone`/`…Real`) **re-landed** after the toolchain build-speed fix
(a machine restart removed a ~10–20× memory-starvation slowdown; true recompiles are
now ~15–20 s). `PathSumSemantics`, `ComptonBoundSq`, `EntropyMonotoneReal`,
`PositiveSectorClass` are now in-project **M** and cited in the manuscript. Only
`Goal3BoostCov` (trig) stays retired, superseded by `Goal3BoostCovRational`.*

**Particle table (§2b / §3), all M, guard-pinned, in-project:**

| Module | Manuscript | Honest boundary |
|---|---|---|
| `MassNullDecomposition` | §3 | the converse (all mass IS null-edge disagreement); `P = M Mᴴ` **spinor** Gram (not the 4-vector Gram) |
| `MasslessEdgeCount` | §3 | edge count = rank; the exact minimum-edge = `rank P` (already landed, now surfaced) |
| `DetPUniqueness` | §3 | det P is the **unique** quadratic vanishing on null edges — canonical, not chosen (null-vanishing alone forces it) |
| `RankCeiling` | §3 | **rank-2 ceiling**: at rank 3 `det P₃ ≠` pairwise mass — kernel-checks the audit kill-test; higher spin NOT claimed |
| `NeutrinoDiracMajorana` | §2b | Dirac vs Majorana structure; nature stays **open** |
| `NeutrinoSeesaw` | §2b | `|m_ν| < m_D²/M_R` via Vieta; structural suppression, not a mass value |
| `MassGradientMorse` (SciLean port) | §3 | masslessness = critical manifold; Hessian mass-direction |
| `CelestialSphericalCode` (port) | §3 | mass = chordal separation; massless multiplet = tight frame |
| `MassFourFaces` | §3a | the mass² dictionaries are ONE invariant, not independent |

**Λ suite (§10a), all M:** `LambdaEdgeCount`, `LambdaMomentHierarchy`, `LambdaCountDichotomy`,
`LambdaSusceptibility`, `LambdaConjugacy`, `LambdaTwoRegionCovariance`, `VacuumSequestering`,
`LambdaThreeSplit` (three-Λ split; "observed=count" leg definitional, sequestering the content),
`LambdaFrameConstraint` (frame-blind ⇒ only-uniform suppression; **upgrades the fork's Lorentz
argument from `[import]` to a cited theorem**; continuum-Lorentz lift stays `[import]`, selection **C**).

**§7 gravity+matter, M:** `UnifiedActionVariation` (one action → gravity `dS/dE` + matter `dS/dg`,
distinct, joint stationary point; the *variational* route). Reconciliation with Codex's Goal IV
(`GravityUnificationCapstone`) **deferred** — Codex's capstone is a submitted job, not yet in-tree;
convention pre-check passes (both lanes (+,−,−,−)). Honest: finite polynomial avatar, not continuum.

**Ports — all 7 named targets landed (M, reference-only, version-pinned OFF v4.28.0):**
`MinkowskiConvention` (PhysLean), `LeanQuantumDPIMass` (lean-quantum), `TVDistinguishabilityMass`
(testing-lower-bounds), `KraftCompressionMass` (Kraft), `CelestialSphericalCode` (Sphere-Packing/
LeanCamCombi), `MassGradientMorse` (SciLean), `ZigzagAutomaton` (CSLib). Each clean-room, provenance
logged.

**No-gos recorded honestly:** `masslessedge-closer` (redundant — repo already had a superior
guard-pinned version); `zigzag-automaton` v1 (off-target — rebuilt `ZigzagWeyl`; hardened resubmit
then landed correctly).

### Independent red-team audit (Aristotle strategy job, acted on)
`redteam-detp-kill` adversarially reviewed the **headline** and forced honest corrections, all folded:
- **Originality**: the `det P = mass²` *identity* is standard spinor-helicity → now `[import]`
  (previously overstated as an `[orig]` "finite mechanism"). `[orig]` = the finite decidable avatar
  + T/M/C grading discipline ONLY. The identity is kinematic (`m²=2p₁·p₂`) — universal but empty as "origin."
- **Known limits (§2b, now stated)**: (1) *which P* — the spinor Gram `M Mᴴ` (verified), not the
  4-vector Gram (−m⁴/4); PSD = same-null-sheet hypothesis; (2) *rank-2 ceiling* — kernel-checked in
  `RankCeiling`; (3) *phase-blindness* — `det P=|m|²` discards CP/Majorana phase.
- **§6 composite mass**: dynamical QCD mass (trace anomaly, "mass without mass") is NOT derived — det-P
  re-labels hadron mass, does not explain it.
A **companion red-team on §7 + §10a** (`redteam-gravity-lambda`, saved to `audits/`) then
forced two further walk-backs, both folded:
- **§10a Lorentz mislabel (walk-back)**: `LambdaFrameConstraint` proves the *exchangeability*
  (de Finetti, `S_N`) fact `C=aI+bJ`, **not** the Lorentz statement it was sold as — the real
  "hyperuniform ⇒ not Lorentz" is Bombelli–Henson–Sorkin `[import]`; exchangeability is cruder
  than Lorentz and translation-invariant hyperuniform processes exist. The fork's sharp form is
  now the count-variance exponent (`α=1` keeps the number, `α<1` kills it — not both).
- **§7 labeling**: finite `tr(D²)=`Einstein–Hilbert is *definitional bookkeeping*, not the
  Chamseddine–Connes heat-kernel theorem (no manifold/short-time limit in finite dim); the
  five "routes" are known-equivalent (TEGR≡GR), not independent; the order-0 Λ-invariance
  *assumes away* matter-loop feedback (only `dim H` invariance). Bianchi + count-variance
  kill-tests recorded.

**Net after both audits:** the three headline sections (§3 mass, §7 unification, §10a Λ) are
now honestly bounded — the *physics* is `[import]` (spinor-helicity, Chamseddine–Connes,
Jacobson, Sorkin/BHS lineages); the `[orig]` contribution is the **finite kernel-checked
bookkeeping avatar + T/M/C grading discipline**, and in two places (§7 EH, §10a Lorentz) the
finite proposition is a *weaker* statement than the import it stands beside — now labeled as such.

### The one caveat a reader should carry (updated)
The central `mass² = det P` is *standard kinematics* (spinor-helicity / Penrose zigzag / Kaluza–Klein–
Bars lineage), tagged `[import]`; the contribution is the **finite kernel-checked packaging + honesty
accounting**, and it is intrinsically a **rank-2 (two-null-edge)** statement. The RG rows remain finite
rational models around a period-2 critical line, not a continuum limit. Nothing here derives an absolute
mass, the Born rule, or the value/sign of `Λ` (the standing event horizon).

## Codex lane (from ledger — Codex to confirm)

| Module / result | Grade | Notes |
|---|---|---|
| `KMPhaseCounting` | **M** | finite CKM split; `0<physCP ↔ 3≤N` |
| `FiniteKMCP` | **M** | N=2 no-go + N=3 Jarlskog witness `J=6912/78125≠0` |
| `IncidenceCorank` | **M** | general-N linearized/tangent CP corank `(N-1)(N-2)/2`; not a global unitary normal form |
| `KMFlagship` | **M** | Goal II composition: physical phase count = incidence corank for `1≤N`, plus N=2 rephasing no-go and N=3 nonzero witness |
| `KMFamilyRankBridge` | **M** | exactly one physical CP phase iff `N=3`, equivalent to rank datum `n=2` / three completions |
| `WEPTrace` | **M** | WEP as a finite trace identity (Goal IV cheapest rung) |
| `WEPActionBridge` | **M** | trace-level sourced action: stationarity iff `G=K`; channel-blind source is total budget |
| `WEPActionResourceBridge` | **M** | total-budget source plus null/rest resource nonvacuity; no entropy-sourced field equation |
| `MassResourceModularAudit` | **M** | Suite D modular false-shape guardrail |
| `IndexAnomalyInterface` | **M** | finite signed index anomaly; analytic index kept behind an explicit reduction hypothesis |
| `IndexProtectionBridge` | **M** | finite index anomaly plus at least `w` protected kernel modes; finite rank-nullity only |
| `GateI1.MassEntropyMonotone` | **M** | faithful/nonnegative resource-measure API; monotonicity is in separate order lemmas |
| `SuiteCDNextRungs` | **M** | U(N) count, C3 finite relative index, traceless channel charges, coordinate-charge linear independence, pairwise commutativity, and commutation with `Bsum`; no physical GGE dynamics |
| `MassResourceConsistency` | **M** | Suite D guardrail bundle including commutativity/conservation by `Bsum`; finite consistency only, no thermodynamic-limit derivation |

## Cross-checks passed
- Every **M** row: in-project `lake build` green, guard-pinned, cited names
  grep-verified in-file. Anchor table sweep note lists all 2026-07-09 additions
  pending the independent sweep.
- Codex manuscript audit: no false-shape/vacuity/hidden-hypothesis; 2 LOW findings fixed.
- No `s o r r y` / `a d m i t` / `n a t i v e _ d e c i d e` anywhere in landed code.

## The one caveat a reader should carry
The RG rows are finite rational models. `Goal3ExactRG`/`Goal3ChannelRG`/
`Goal3ChannelRG4` prove arithmetic and linearized facts around an invariant
period-2 critical line, not a strict fixed point or a continuum limit; `ν=1` and
`z=1` are interpretive RG readings of kernel-checked eigenvalue/dispersion facts.

The **HELD** modules are correct mathematics that simply exceed our in-project
build budget (systemic ~10–20× slowdown vs Aristotle's environment). Their results
are reviewed and documented but are **not** M anchors and are **not** in the
manuscript. If the toolchain build-speed is addressed, they land unchanged.
