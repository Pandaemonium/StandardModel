# Aristotle publication queue

Status values: `queued`, `running`, `snapshot`, `harvested`, `landed`, `killed`,
`sharpened`, `rejected`, `stalled`.

## P0 harvest inventory

Refresh with `aristotle list --limit 40` at startup.

| Priority | Existing project | Topic | First action | Status | Owner |
| --- | --- | --- | --- | --- | --- |
| 0 | `57fc7076` | full-Bloch split helper | audit found proof-script failure; branch jobs supplied repaired helper | rejected | Codex |
| 0 | `5337cc9e` | full-Bloch minus branch | exact `-1` determinant formula integrated and guarded | landed | Codex |
| 0 | `d13856aa` | full-Bloch plus branch | exact `+1` determinant formula integrated and guarded | landed | Codex |
| 0 | `b605f8b8` | finite CAR second quantization | creation covariance integrated and guarded; remote may continue | landed | Codex/Fable |
| 1 | `14ce545e` | strict-QCA successor strategy | harvest strategy and turn top target into statement | queued | Codex |
| 1 | `7ea06419` | changing-lattice UV tail | returned source is older/weaker than live module | rejected | Codex |
| 2 | `c6cdee4d` | earlier full-Bloch determinant | compare with newer branch jobs; preserve nonduplicate output | queued | Codex |

## New proof queue

Only submit after P0 inspection. Each target needs exact seeds, a typechecking
statement, a witness, a control, prohibited weakening, and manuscript effect.

| Rank | Prefix/name stem | Target | Success | Kill / fallback | Paper |
| --- | --- | --- | --- | --- | --- |
| 1 | `*-pub-pluecker-defect-index` | Derive patched link from local spinors and prove finite index/winding bridge | Explicit nonzero localized mode and zero-winding control | Exact blocker or equivalence-to-assigned-mass no-go | C/A |
| 2 | `*-pub-full-bloch-capstone` | Compose exact plus/minus characteristic data into all-zone classification | Complete zero/pi/body-center theorem | Sharp architecture-scoped no-go | A/B |
| 3 | `*-pub-changing-lattice-dirac` | Sampling/interpolation plus strong `L2` PDE convergence | Position-space Dirac-flow theorem | Exact missing analytic lemma and typechecking handoff | D |
| 4 | `*-pub-car-automorphism` | Creation covariance, functoriality, unitarity, locality | Local Fock automorphism | Smallest failed locality/functoriality witness | E |
| 5 | `*-pub-phase-observable` | Embed quartic Pluecker interaction and compute phase-sensitive observable | Exact transition/selection/scattering quantity | Prove phase cancels under stated class | E/A |
| 6 | `*-pub-strict-qca-resource` | Sharp lower bound or successor beyond minimal factorized class | Exact resource theorem plus relaxed witness | Counterexample to proposed minimum | B |
| 7 | `*-pub-paper-a-referee` | Full manuscript + exact Lean adversarial review | Ranked fatal/major/minor findings with source anchors | N/A | A |
| 8 | `*-pub-channel-decomposition-classification` | Classify type-only refinements of the canonical parity split and identify minimal intrinsic selectors | Explicit moduli/equivalence theorem plus joint-selector uniqueness | Residual-moduli or circular-selector no-go | F |

Active Codex publication jobs:

| Project | Name | Target | Status |
| --- | --- | --- | --- |
| `f90d69c7` | `codex-pub-car-functorial` | identity, Cauchy-Binet functoriality, conjugate transpose, and unitary Fock lift | running |
| `efc99053` | `codex-pub-full-bloch-zero-classification` | complete principal-massive zero/pi polynomial zero sets | landed |
| `4f21ae6e` | `codex-pub-grand-strategy` | post-full-Bloch/CAR publication strategy and adversarial target ranking | harvested |
| `6cbba323` | `codex-pub-live-dft-conjugacy` | complete normalized product DFT, Parseval, inverse, and exact live-walk block conjugacy | running |
| `9d0e0fe4` | `codex-pub-postlanding-semantic-audit` | hostile manuscript/source audit after full-Bloch and CAR landings | running |
| `144a848d` | `codex-pub-commutator-wilson-strictness-kill` | prove integer-range gate is trivial at zone edge and aliases survive | landed |
| `bad1dc90` | `codex-pub-changing-mode-embedding` | explicit finite-box sample/interpolate maps, exact energy, and strong square-summable tail convergence | running |

## Live submissions (2026-07-10 evening)

| Job | ID | Prompt/task note | Status | Owner |
| --- | --- | --- | --- | --- |
| `fable-pub-grand-strategy-20260710` | `db9b25fc` | `AgentTasks/fable-pub-grand-strategy-aristotle-2026-07-10.md` | running | Fable |
| `fable-pub-paper-a-referee-20260710` | `85cbba5e` | `AgentTasks/fable-pub-paper-a-referee-aristotle-2026-07-10.md` | running | Fable |
| `fable-pub-pluecker-winding-20260710` | `e64d0d5d` | `AgentTasks/fable-pub-pluecker-winding-aristotle-2026-07-10.md` (queue rank 1, Paper C pillar 1: derived link data, integrality, winding-one spinor witness, no-go bridge; statements typecheck) | landed 21:35 as PlueckerWindingDerived.lean | Fable |
| `fable-pub-phase-observable-20260710` | `a4420507` | `AgentTasks/fable-pub-phase-observable-aristotle-2026-07-10.md` | landed 21:55 as PlueckerPhaseObservable.lean | Fable |
| `fable-pub-chiral-flip-mode-20260710` | `ecbe0d8b` | `AgentTasks/fable-pub-chiral-flip-mode-aristotle-2026-07-10.md` (Paper C pillar 2 engine: det=-1 forces exact -1 mode, +1 partner in even dim) | running | Fable |
| `fable-pub-defect-mode-design-20260710` | `b407e2d5` | `AgentTasks/fable-pub-defect-mode-design-aristotle-2026-07-10.md` (Paper C pillar 3 design: sign-wall walk, det-vs-wall-parity, localized witness) | running | Fable |
| `fable-pub-qca-referee-20260710` | `382a2b2c` | `AgentTasks/fable-pub-qca-referee-aristotle-2026-07-10.md` (mandatory second referee: QCA specialist on updated manuscript + 9 sources) | running | Fable |
| `fable-pub-grand-strategy2-20260711` | `85a80ef1` | strategy refresh with landed state: packaging/endgame/venue/announcement/risk | running | Fable |
| `codex-pub-channel-classification-strategy-20260710` | `cb571b0d` | hostile Paper F moduli/equivalence/selector design grounded in four exact rigidity and non-rigidity modules | harvested/integrated | Codex |
| `codex-pub-channel-shear-moduli-20260710` | `c2852345` | exact faithful additive shear family preserving total even-channel sum and every linear type constraint | landed | Codex |
| `codex-pub-headline-semantic-audit-20260710` | `c7e14de3` | compact no-build audit of seven current Paper A headline boundaries against verbatim source | running | Codex |
| `codex-pub-channel-selector-audit-20260710` | `d4dfeb30` | hostile audit of landed F1/F2 plus exact full-torsor and necessary-and-sufficient selector successors | harvested/integrated | Codex |
| `codex-pub-grand-strategy3-20260710` | `000899b2` | post-affine-classification portfolio ranking and freeze-aware publication endgame | harvested/integrated | Codex |
| `codex-pub-affine-fibre-audit-20260710` | `fbe6bd4e` | hostile false-shape/nonvacuity audit of the new complete type-only affine-fibre theorem | harvested/integrated | Codex |
| `codex-pub-selector-rigidity-20260710` | `904751e4` | selector rigidity iff injectivity plus rational-module finite-selector no-go | landed | Codex |
| `codex-pub-paper-d-prefix-audit-20260710` | `5351a06b` | hostile normalization/rate/scope audit of the max-radius tail and DFT round-trip prefixes | harvested/integrated | Codex |
| `codex-pub-reproducibility-audit-20260710` | `73433966` | hostile executable-artifact, manifest, CI, hash, and claim-coverage audit | harvested/integration-in-progress | Codex |
| `codex-pub-paper-f-selector-capstone-audit-20260710` | `46e899bd` | hostile combined audit of the full torsor, exact selector criterion, and symmetry/finite-label no-gos | harvested/integrated-with-packaging-disposition | Codex |
| `codex-pub-grand-strategy4-20260710` | `4070e029` | post-DFT-conjugacy theorem ranking and freeze-aware endgame | harvested/integrated | Codex |
| `codex-pub-live-dft-capstone-audit-20260710` | `0c77b48c` | hostile normalization, orientation, Parseval, completeness, and operator-conjugacy audit | harvested/integrated | Codex |
| `codex-pub-reproducibility-reaudit-20260710` | `16c39ad9` | disposition audit of golden hashes, deterministic summary, expanded coverage, and pinned CI | harvested: pass with release gates | Codex |
| `codex-pub-car-adjoint-20260710` | `224621b8` | isolated finite-Fock creation/annihilation adjoint identities; bridge from creation covariance to annihilation covariance | landed | Codex |
| `codex-pub-selector-descent-20260710` | `545decd7` | intrinsic-selector iff: source grading descends through carrier evaluation exactly when it preserves the evaluation kernel | landed | Codex |
| `codex-pub-selector-descent-audit-20260710` | `42092589` | adversarial theorem-shape and publication audit of selector descent against the full Paper F moduli package | harvested | Codex |
| `codex-pub-car-covariance-20260710` | `816777bf` | annihilation covariance derived from landed adjointness and unitary exterior-lift APIs | canceled after stronger local landing | Codex |
| `codex-pub-halfwinding-semantic-audit-20260710` | `9da8f4b0` | hostile source audit of explicit two-wall theorem versus half-winding iff/localization/protection language | harvested: critical demotions adopted | Codex |
| `codex-pub-grand-strategy5-20260711` | `b0d7357d` | post-selector-descent portfolio ranking, Paper C wording audit boundary, and freeze-aware endgame | harvested/integrated | Codex |
| `codex-pub-halfwinding-control-repair-20260711` | `d9d46738` | full-walk zero/four controls plus exact two-wall characteristic-polynomial multiplicities | harvested/preserved; stronger local inverse controls landed | Codex |
| `codex-pub-live-selector-design-audit-20260711` | `a4862d7d` | primitive carrier-word relation audit for solder-degree/edge-exchange selector descent or exact kill | harvested; positive verdict contested | Codex |
| `codex-pub-live-selector-kernel-counteraudit-20260711` | `6833acfa` | hostile check of full-kernel homogeneity, concrete-representation identities, and claimed positive selector verdict | harvested: raw solder degree refuted; kernel-only no-go landed | Codex |
| `codex-pub-pairkick-nonquasifree-audit-20260711` | `4204b732` | hostile semantic audit of the finite pair-kick separation from every determinant-minor one-particle lift | harvested: narrow theorem PASS, broad quasi-free wording demoted | Codex |
| `codex-pub-grand-strategy6-20260711` | `2fc55252` | post-half-winding-control and solder-selector-kill publication endgame through freeze and dawn audit | harvested with one false E successor rejected | Codex |
| `codex-pub-paper-c-control-prose-reaudit-20260711` | `8f6b11dd` | hostile re-audit of full-walk inverse controls, sign orientation, trust boundary, and corrected Paper C/A/GA prose | harvested: PASS; corrections applied | Codex |
| `codex-pub-quartic-generator-audit-20260711` | `3e0fa1a7` | hostile audit of standard one-body CAR generator convention and disjoint-pair quartic obstruction | harvested: PASS | Codex |
| `codex-pub-quadratic-selector-audit-20260711` | `f6905c13` | hostile audit of weighted completion, unique minimizer, metric dependence, and permutation interpretation | harvested: PASS; positivity wording sharpened | Codex |
| `codex-pub-grand-strategy7-20260711` | `b2d0edea` | post-variational-selector portfolio ranking and freeze/audit endgame | harvested/integrated | Codex |
| `codex-pub-quadratic-selector-inner-lift-20260711` | `c6b52d4a` | generic real-inner-product weighted selector classification and metric-dependence control | running | Codex |
| `codex-pub-commutator-selector-classification-20260711` | `6381645c` | classify every commutator-blind rational-linear scalar matrix selector as a trace multiple and prove noninjectivity | running | Codex |
| `codex-pub-krein-metric-nogo-audit-20260711` | `50523bdb` | hostile audit of exact negative even/self-adjoint direction and metric-scope interpretation | running | Codex |
| `codex-pub-c-index-bridge-design-20260711` | `32a89f02` | noncircular Pluecker-winding to compression-signature theorem or sharpened missing axiom | running | Codex |
| `codex-pub-e-causal-cone-design-20260711` | `0388c69e` | exact spatial pair-kick layer and finite Heisenberg causal-cone theorem design | landed as sequential finite-range graph cone; parallel-layer successor open | Codex |
| `codex-pub-grand-strategy9-20260711` | `4b8f47be` | post-C/E/F correction theorem ranking, Paper F verdict, freeze plan, and hostile semantic checklist | harvested/filtered | Codex |
| `codex-pub-positive-sector-moduli-20260711` | `13d62a22` | explicit rational Krein boost, distinct injective positive families, exact norm preservation, and non-diagonal witness | locally landed; remote independent route running | Codex |
| `codex-pub-positive-complement-disk-20260711` | `ef95daca` | rational open-disk classification of positive complements containing all three named even channels | locally landed; remote independent route running | Codex |
| `codex-pub-grand-strategy10-20260711` | `bca4194e` | final pre-freeze active-job ranking, rejection gates, and harvest-to-audit sequence | harvested/filtered | Codex |
| `codex-pub-channel-physical-cohomology-20260711` | `82b10567` | finite contraction theorem identifying zero physical action with null homotopy, plus witness/control triple | landed as `ChannelPhysicalCohomology` | Codex |
| `codex-pub-laurent-unit-resource-20260711` | `ea501e65` | classify units of the Laurent-polynomial ring, exponent uniqueness, and two-term nonunit control | submitted | Codex |
| `codex-pub-refined-window-rate-20260711` | `9ce69fe9` | retain the small-step exponent through the 3+1 one-step and many-step bounds so growing cutoffs become possible | landed by local completion | Codex |
| `codex-pub-e-layer-cone-20260711` | `63b8418b` | upgrade the sequential graph cone to one neighborhood step per pairwise-disjoint circuit layer | landed by local completion | Codex |

## Strategy cadence

- Codex grand strategy: startup, +90 min, +180 min, +270 min.
- Fable grand strategy: startup, +90 min, +180 min, +270 min.
- Keep at least one audit job active; two when the service has room.
- Apply the two-hour stall rule and log preserved subsets.
