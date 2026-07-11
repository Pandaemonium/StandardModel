# Morning report: overnight publication run 2026-07-11

Filled by Fable ~07:30 PDT after the user waived the 06:30/07:00 audit
cutoff in favor of pushing the two expert memos (advisor + Pro); Codex to
co-sign, correct, or record disagreement. Every claim below has a ledger
entry with a system-clock timestamp; declarations named here are in the
live tree and guard-pinned unless marked in-flight.

## 09:00 handoff

This supersedes the earlier dawn baseline and reflects the final Codex verifier
through 08:59 PDT.

**Current scientific picture**

- Paper C is now a positional-certificate paper, not a winding paper:
  `HalfPeriodInvariant.selfadj_iff_protected` landed, the 16-field family is
  mechanized, and the remaining gate is the stability / CGGSVWZ match.
- Paper E is exact declared-set CAR support plus scheduled propagation, and
  the pairwise-disjoint layer-depth cone has now landed as well. The open
  successor is the dynamical / continuous-time refinement, not the discrete
  layer bound.
- Paper F has split cleanly. The negative-classification spine is coherent
  and close to a standalone paper; the live carrier quotient and
  physically justified selector remain open. The positive-complement disk,
  Laurent-unit resource, Laurent flow exponent, Ward quotient, phase-defect
  spectrum, and layer-depth cone are real landings, but they do not close
  the selector problem.
- H1, H2, H3, H4, and H6 each gained a landed theorem this morning. H4 now has
  the small-step-sensitive `3+1` error
  `2 B4^2 t^2/n * exp(|t| B4/n)`; this is the quantitative growing-window
  precursor, not yet the Shannon/PDE theorem.

**Paper grades**

- A: `NEAR-READY` specialist, `THEOREM-GATED` prestige.
- A-prime: `NEAR-READY`.
- B: `THEOREM-GATED`.
- C: `THEOREM-GATED`, materially upgraded.
- D: `THEOREM-GATED`.
- E: `THEOREM-GATED`, with exact declared-set CAR support now closed.
- F: split route. Negative classification is `NEAR-READY`; positive
  selector is still `THEOREM-GATED`.
- G/H: `DEFER`.

**Strongest blockers**

- Release artifact gates: clean checkout, immutable archive identifier,
  repository license choice, and DOI plan.
- Paper F live carrier quotient / noncircular positive selector.
- Paper D scaling/Shannon interpolation and the channel/state-distance
  comparison.
- Paper E continuous-time / dynamical successor.
- Paper C stability and CGGSVWZ real-space-index match.

**Active Aristotle targets**

- `cb16b747`: Paper H2 window half-charge ladder, still in flight.
- `573430f4`: Paper C stability / atlas follow-up, still in flight.

**Artifact status**

- The final publication verifier covers 55 headline modules plus both pinned
  fixtures. Two consecutive runs passed with
  deterministic summary SHA-256
  `EBB3D95AF2D078E9959773954D41C96D7528010A5123621E65D47459A1B7C9B9`.
- The expanded aggregate guard passed all 8,194 jobs.
- `lake build` passed all 8,298 jobs on the Windows toolchain.
- The optional `PhysicsSMDraft` build still fails only at the known
  unrelated SpherePacking imports on native Windows.
- `pre-commit` and `git diff --check` both passed on the overnight surface.
- `archival_ready` remains `FALSE` because the tree is dirty and the clean
  checkout / license / DOI gates are still open.

**Unresolved evidence gaps**

- No clean checkout release run yet.
- No archive DOI yet.
- No repository license choice yet.
- No physical carrier quotient or selector theorem yet for Paper F.
- No scaled Shannon interpolation / position-space PDE theorem yet for Paper D.
- No continuous-time / dynamical successor theorem yet for Paper E.

## Executive result

**The Paper C gate closed at the register level with a machine-checked
positional protection law that provably beats winding.** The run's
centerpiece arc completed overnight: first the exhaustive four-site
theorem showed equal derived winding cannot determine the compression
signature (the 8-vs-4 positional split); then the dawn wave proved the
replacement law and killed the standard refinements on their own terms.
`HalfPeriodInvariant.selfadj_iff_protected` (harvest f4879a60, guards
pass): the reflection-fixed-leg compression is self-adjoint iff the field
has two walls and is not a fixed singleton - all 16 fields decided - and
`protected_modes` composes this through the kernel-only
involutive-compression engine into exact +-1 modes of the COMPLETE walk
for every protected field. The half-period timeframe pair
(Cedzich-Geib-Werner-Werner arXiv:2006.04634, the expert advisor's primary
proposal) was computed exactly on our register and is position-blind - the
advisor's own pre-registered kill condition fired - and the mirror-graded
winding is not merely blind but ILL-DEFINED on precisely the four blind
fields (`reflR_comm_walk_iff`: reflection commutes with the walk iff the
two fixed sites carry equal signs, which every fixed singleton violates).
The C paper ("Winding Is Not Enough") now states a proven positional law
instead of a conjecture. Open: stability / real-space-index match
(arXiv:1611.04439), design job 573430f4 in flight.

Second headline: **the Pluecker phase acquired two independent free-theory
observables in one night**, attacking the program's deepest criticism (R1:
"a reparametrized mass"). The sea-level window charge and one-particle
phase-defect spectrum are now both landed, and their supporting algebraic
routes have also been tightened by the Laurent flow exponent, Ward
quotient, phase-defect, and layer-cone results. The remaining live
question is the physical carrier quotient / selector, not the existence of
the free observables themselves.

## What changed scientifically

| Result | Status | Exact declaration/source | Why it matters | Boundary |
| --- | --- | --- | --- | --- |
| Positional protection law, family level | LANDED (draft trust +2, engine kernel-only) | `HalfPeriodInvariant.selfadj_iff_protected`, `protected_modes` | Replaces the refuted half-winding conjecture with a proven law; full-walk modes, not compression-only | Four-site register; stability + general-L open |
| Timeframe-pair and mirror refinements killed | LANDED (mirror: `reflR_comm_walk_iff`, `fixedSingleton_not_reflSym`); frame windings exact oracle in design memo | harvest f4879a60 + HALFPERIOD_INVARIANT_DESIGN.md | The C invariant is provably finer than the literature's standard refinements; sharpens novelty | Frame windings exact but not formalized (outside native_decide discipline) |
| Sector-resolved window half-charge -1/2 | LANDED from the oracle path; Lean target banked earlier (cb16b747 still running) | scratchpad window_charge oracles; exact L=8 rationals; dynamics_lab v1.1 demo | First FREE-theory sea-level observable separating equal-modulus fields; GW/JR walk avatar | Fixture-level; continuum GW interpretation stays prose |
| 4x4 phase-defect spectral theorem | LANDED (sympy + Lean) | Pro memo sec 2; `PlueckerPhaseDefectSpectrum.lean` | One-particle free observable for the phase; preregistered gap g^2; exact zero-mode locus | Two-site, not topological protection; equal moduli load-bearing |
| Exact chiral gradings, both families | VERIFIED exact (sympy/numpy); SCS grading landed as `gradeX` | SC family: Gamma(x) = c sigma_y - s(x) s0 sigma_z (rational blocks); SCS register: per-site sigma_x | The load-bearing hypothesis of the chiral-index framework, field-independent | - |
| Transfer-matrix localization data | VERIFIED exact (sympy) | T(lam,sg) with det 1, eigenvalues {1/2,2} at +1 and {-1/2,-2} at -1; stable-direction swap with the sign field | Decay factor exactly 1/2 per site; the visible mechanism behind the positional criterion; localization rung of 573430f4 | Bulk statement; wall gluing formalization in flight |
| Full 16-field mechanistic taxonomy (post-report, 07:42) | EXACT (sympy); formalization instructed into 573430f4 | Blocks: W^2 = 1, W = W^T, tr 0 -> (4,4) via engine at identity; singletons: axis-equivariant fixed-leg involutions, two charts {1,3}/{0,2} -> (2,2); zero/four-wall: no certificate, no modes | The constructive counterpart of "Winding Is Not Enough": one landed engine at three compression levels explains every field's modes; blind fields' mechanism FOUND same-morning | Exact-computation grade until the mirror-law/atlas Lean lands |
| Whole-family mode census + symmetry pinning | ORACLE (numpy, L=8/16) | ledger ~07:05: only antipodal wall pairs pin exactly; splitting ~0.6 x 2^-sep, exactly zero at antipodal | Honest "what exactness means at finite size": per-wall index + inversion-symmetry pinning; our landed fixtures are the symmetric case | Numeric (1e-16); Lean version queued |
| H7 scale selection: exact negative | LANDED kernel-only (Codex) + exact analysis (Fable) | `FiniteHomogeneousScaleNoGo` (Euler no-go, p=0 control); Fable: landed R3 marginal direction = pure dilatation, exact 2-cycle line, c+b^2 = 0 identically | Closes the KT escape for every degree-1 homogeneous decimation; transmutation REQUIRES homogeneity breaking | Does not exclude refining families with running couplings (the honest successor; Pro concurs) |
| H1 abstract physical quotient | LANDED kernel-only (Codex) | `ChannelPhysicalCohomology`: pXi=0 iff X=QH+HQ, lift ifp, rational control triple | The decomposition paper's moduli space is endomorphism cohomology, not a scalar selector | Live carrier Q, bounded-range homotopies, automorphism group still open (physical input) |
| F positive-sector moduli | LANDED (Codex, pre-dawn) | `ChannelPositiveSectorModuli`, `ChannelPositiveComplementDisk` | Explicit nonuniqueness witness + full rational open-disk classification | Carrier-level; not a physical selector; disk image under the quotient open |
| E exact CAR support + scheduled propagation | LANDED (Codex, corrected scope) | `PlueckerCausalCone` + guards | R7 demands (2)/(5) at declared-set level | Continuous-time / dynamical successor remains open; the discrete layer cone is now landed |
| H4 obstruction identified | SHARPENED (Codex 07:02) | live box constant grows 16(3K+M)^2 e^{3K+M} | Per Pro's own criterion the exponential growth, not changing state spaces, is the real blocker; repair job 9ce69fe9 in flight | - |
| Thirring-QCA field parity | LIT (verified) | 1711.03920, 2406.19917; register R7 updated | Interaction derivation is open in the FIELD, not a unique gap; repositions E | - |

## Publication portfolio at dawn

| Paper | Verdict | New headline | Venue lane | Next blocking task |
| --- | --- | --- | --- | --- |
| A | NEAR-READY (specialist) | Two-pillar framing; both phase observables incoming; content compile PASS x2; claim-matrix anchor sweep PASS | J.Phys.A-level now; prestige lane theorem-gated | Artifact freeze on clean tagged tree; author line; portfolio ratification (user) |
| A-prime (obstruction letter) | NEAR-READY | All headline theorems landed + guarded; survived 3 referee sims | PRL-adjacent letter | Release gates shared with A |
| B | THEOREM-GATED | Two scoped no-go families + lattice-independent NN origin + BCC anchors; advisor+Pro converge on resource-lower-bound retarget | - | Determinant-monomial index protocol (ea501e65 in flight); apply to D4 control first |
| C | UPGRADED tonight | "Winding Is Not Enough": blindness pair + engine + PROVEN positional law + mirror ill-definedness + timeframe kill | Quantum vs SciPost (user decision) | Stability/CGGSVWZ match (573430f4); portfolio ratification |
| D | THEOREM-GATED | Complete finite DFT/spectral core; exponential-constant obstruction named exactly | - | Refined window rate (9ce69fe9), then cutoff balance vs `SobolevTailRate` |
| E | THEOREM-GATED | Exact declared-set CAR cone + creation covariance + functoriality; field-parity repositioning | - | Continuous-time / dynamical successor; interaction derivation honestly open-in-field |
| F | Below NEAR-READY by named items | Negative spine + moduli disk + abstract quotient theorem | JMP/J.Phys.A negative-classification route, safer title only | Fable cross-audit items (PAPER_F_CROSS_AUDIT): stabilizer, example/control triple, disk-image, nonlinear-metric control; live-carrier quotient |
| Mixedness companion | RATIFICATION-PENDING | Fourth boundary vs relativistic-QI + verified bibitems | - | User ratification |

## Manuscript work

- Paper A: abstract observable-overclaim repaired at freeze preflight
  (exact spectral statement; 4/5-vs-1 scoped to the supplied interaction
  sector); content compile PASS twice; claim-matrix shorthands replaced by
  exact theorem names (Codex).
- C paper: synced tonight to the landed law (thm:law, thm:mirror; verified
  citations incl. corrected Cedzich title; time-frame windings marked
  exact-but-not-formalized; stability language embargoed) (Fable).
- Mixedness companion: phase-observability wording synchronized (Codex);
  fourth-boundary scoping vs Peres-Terno/Gingrich-Adami with verified
  bibitems (Fable).
- General-audience: NOT synced tonight (kernel-first discipline); queued
  with the same earned-scope rules.
- Nearest-work/novelty: 10 anchors verified and ingested to Zotero+Neo4j
  with embeddings (CGWW 2006.04634, CGGSVWZ 1611.04439, bulk-edge
  1502.02592, homotopy companion 1804.04520, Asboth 1208.2143,
  Asboth-Obuse 1303.1199, Thirring QCA 1711.03920 + 2406.19917,
  Peres-Terno quant-ph/0212023, Gingrich-Adami quant-ph/0205179). Pro's
  2601.15885 verified = Gupta-Short (already cited in Paper A);
  2607.05112 NOT FOUND - unverified, excluded from all prose.
- Referee register: R1/R5 upgraded (two free-theory observables in flight
  + landed law); R3 anchored (BCC Weyl QCA); R7 repositioned (interaction
  appended-not-derived is field-wide).

## Aristotle harvest (dawn wave; earlier harvests in ledger)

| Project | Target | Verdict | Integrated file/result | Follow-up |
| --- | --- | --- | --- | --- |
| f4879a60 (Fable) | Half-period invariant decision, C gates 1-2 | LANDED; four-over-claim-mode audit PASS | `PhysicsSM/Draft/NullEdge/HalfPeriodInvariant.lean` + 4 guard pins; design memo banked | Stability 573430f4 |
| cb16b747 (Fable) | Window half-charge ladder T1-T6 | IN FLIGHT | - | Integrate on return |
| 497535a1 (Fable) | 4x4 phase-defect spectrum, kernel-only | LANDED | `PhysicsSM/Draft/NullEdge/PlueckerPhaseDefectSpectrum.lean` | Phase-defect spectrum now folded into the Paper F negative spine |
| 573430f4 (Fable) | Localization + symmetry-resolved stability | IN FLIGHT | - | The decisive C gate; honest-negative branch included |
| 82b10567 (Codex) | H1 contraction theorem | LANDED clean (no holes) | `ChannelPhysicalCohomology.lean` | Live-carrier instantiation (physical input) |
| ea501e65 (Codex) | H3 Laurent unit/monomial index | IN FLIGHT | - | Determinant-monomial protocol |
| 9ce69fe9 (Codex) | H4 refined window rate | LANDED by local completion | `Compact3Plus1RefinedWindowRate.lean` | Exact small-step-sensitive cutoff bound; Shannon/PDE composition remains open |
| 63b8418b (Codex) | H6/E per-layer cone | LANDED | `PhysicsSM/Draft/NullEdge/PlueckerLayerCone.lean` | Discrete layer cone now folded into Paper E; continuous-time successor open |
| d683a0c4 (Codex) | H1 locality successor | LANDED | `PhysicsSM/Draft/NullEdge/Carrier/PhysicalHomotopyLocality.lean` | Added composition/range-locality corollaries |
| de5baafe (Codex) | H3 Laurent flow exponent | LANDED | `PhysicsSM/Draft/NullEdge/LaurentFlowIndex.lean` | Exact additive flow exponent now recorded |
| 7399f4a8 (Codex) | Ward automorphism quotient | LANDED | `PhysicsSM/Draft/NullEdge/Carrier/WardAutomorphismQuotient.lean` | Corrected exact quotient law now recorded |
| ef95daca (Codex, pre-dawn) | F positive-complement disk | LANDED | `ChannelPositiveComplementDisk` | Disk image under quotient |
| 13d62a22 (Codex, pre-dawn) | F sector moduli (remote route) | Superseded by local landing | `ChannelPositiveSectorModuli` | - |
| af92e727 (Codex) | E graph-metric cone | REJECTED at freeze (5 exact defects) | quarantined | Fresh-source re-audit only |

## Verification

- Targeted Lean: `lake env lean PhysicsSM/Draft/NullEdge/HalfPeriodInvariant.lean`
  PASS; OvernightTheoryAxiomGuard build PASS after the 4 new pins (Fable);
  Codex targeted aggregate 8,181-job build PASS.
- Guards/axioms: publication verifier PASS twice at 46 direct modules with
  identical deterministic summary SHA-256 B803E39543732C75B3042E691873B655694B3692869517B4D8A5CD632A63E9B8
  (Codex 07:06); all new pins at documented footprints (standard-3, or +2
  native_decide disclosed).
- Simulations: dynamics_lab v1.1 demos reproduce the -1/2 sector
  half-charges and 1e-16 grading residuals; whole-family censuses and
  hybridization scaling rerun tonight (scratchpad, deterministic).
- TeX: Paper A content compile PASS twice (Codex, MiKTeX, exit 0, all refs
  resolve); C paper structural check clean after tonight's sync (Fable).
- `git diff --check`: PASS (Codex 07:18).
- Pre-commit: scoped surfaces PASS (Codex 92-file surface; Fable
  touched-file runs).
- Full build: `lake build` all 8,298 jobs PASS (Codex, ~06:21-06:28);
  optional PhysicsSMDraft root retains the four KNOWN unrelated
  E8/SpherePacking import failures (Windows search-path issue,
  pre-existing).
- archival_ready remains FALSE on the dirty tree - artifact freeze is a
  user-gated release step.

## Honest losses and exact open gates

1. The timeframe-pair proposal (the advisor's primary) is dead for this
   family by its own pre-registered kill condition - documented and turned
   into a sharper novelty statement for the C paper.
2. H7/KT escape closed: no degree-1 homogeneous decimation can transmute;
   scale selection requires homogeneity breaking (refining family + RG
   dynamics; Pro's dependency ordering concurs).
3. H4's real obstruction is the exponential K-growth of the landed box
   constant, not lattice-changing bookkeeping; repair in flight.
4. E graph-metric cone: rejected at construction freeze with five exact
   defects; quarantined pending fresh-source audit.
5. C stability + CGGSVWZ real-space match: THE remaining C gate; the
   sector-resolved indices may come back balanced (design job carries an
   explicit honest-negative branch).
6. Full-walk mode status of the blind fields: ANSWERED exactly at 07:32
   (sympy rational kernels, all 16 fields) - every two-wall field
   INCLUDING the blind fixed singletons has dim ker(W-+1) = (2,2)
   (blocks (4,4); zero/four-wall (0,0)). Mode existence follows wall
   count at this size; the positional law delimits the reach of the
   reflection CERTIFICATE, not existence. C paper and the stability job
   (573430f4, instructed mid-task) updated; a kernel witness for one
   blind field's modes was added to the job's deliverables.
7. Fable discipline slips tonight, both caught in-pass and ledgered: two
   estimated timestamps (corrected), two unverified bibitem page numbers
   (removed). Recurring lesson: clock and citation fields only from
   checked sources.
8. 2607.05112 (Pro's second H3 citation) unverified - excluded.

## Highest-value next seven days

1. Harvest + integrate the three in-flight Fable jobs (both phase
   observables + stability); sync Paper A/C prose on earned scope.
2. Decide the C stability question: CGGSVWZ match or honest negative -
   either closes the paper's last theorem gate.
3. User decisions: portfolio ratification (companion + C), C venue
   (Quantum vs SciPost), author lines, artifact release (clean tagged
   tree + manifest -> archival_ready).
4. F: live-carrier quotient (choose Q + automorphism group - physical
   input), disk-image computation, cross-audit items.
5. H3: determinant-monomial index protocol (harvest ea501e65); apply to
   the D4 control and any 3+1 candidate BEFORE zone classification.
6. H4: harvest refined window rate; if polynomial-in-K is achieved,
   assemble the changing-lattice theorem via the cutoff split.
7. GA manuscript sync + queued kernel-only replacements of native_decide
   literals.

## Agent signatures

- Fable: SIGNED 2026-07-11 07:35 PDT (dawn-wave author; Fable-lane claims
  ledgered with system-clock timestamps; Codex-lane rows sourced from
  ledger entries and open to correction).
- Codex: (to sign / correct / record disagreement)
