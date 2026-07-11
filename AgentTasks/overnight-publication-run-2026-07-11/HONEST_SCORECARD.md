# Honest scorecard

Complete during the 07:00 hard audit. Both agents sign or record disagreement.
(Filled by Fable ~07:40 PDT under the user's audit-cutoff waiver; factual
cells sourced from ledger entries with system-clock timestamps. Codex column
open for co-sign, correction, or disagreement.)

## Headline verdicts

| Claim | Intended grade | Exact support | Nonvacuity/control | Overclaim audit | Final grade | Codex | Fable |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Canonical null-spinor rest gap | M | Pluecker identity + unique odd Hermitian rest operator, kernel-checked; claim-matrix anchors verified against 15,502 declarations | Explicit spinor witnesses; degenerate/collinear controls | "Canonical" scoped to stated normalization + convention lock; R1 concession (Cauchy-Binet layer shared with amplitude literature) recorded | M | (to sign) | M - SIGNED |
| Exact local unitary dynamics | M | Exact unitary walk + locality modules; all-momentum determinant formulas; verifier 55 modules PASS x2 | Massless/boundary controls; alias census | Strict-QCA vs Hamiltonian locality kept separate throughout; sequential-gate vs layer-depth distinction enforced in E scope | M | M - SIGNED | M - SIGNED |
| Consequence beyond assigned constant mass | M/C | LANDED: derived winding (`PlueckerWindingDerived`), gauge classification, positional law + full-walk protection (`HalfPeriodInvariant`); later supporting landings include the sea half-charge, 4x4 phase-defect spectrum, Laurent flow exponent, Ward quotient, and layer-depth cone | 16-field family decided; blind controls (fixed singletons); zero/four-wall full-walk controls | Constant z IS a reparametrized mass at one-particle spectral level - conceded in A abstract; varying-phase consequences are now mostly landed, but the live carrier quotient / selector remains open | M (landed chain) + C (selector open) | (to sign) | M + C(open selector) - SIGNED |
| Strict 3+1 spectral verdict | M | Complete principal-massive zero/pi crossing classification; stationary-amplitude no-go; commutator-Wilson kill; alias lower bound | D4/Wilson controls; body-center eigenmodes | Scoped to the ordered minimal class; NOT a universal impossibility; resource-lower-bound retarget adopted (advisor + Pro + Gupta-Short parity) | M (scoped) | (to sign) | M (scoped) - SIGNED |
| Continuum recovery | M/T\|H/C | Fixed-mode + compact-box rates; refined `3+1` small-step bound; `SobolevTailRate`; complete finite DFT/spectral core; `ChangingModeEmbedding` | Nonzero boundary controls; negative-angle convention control | NOT called a PDE limit; the old exponential-cutoff obstruction is narrowed, while the scaling/Shannon map and PDE identification remain open | M (components) / C (full limit) | M/C - SIGNED | M/C - SIGNED |
| Local many-body interaction | M/C | CAR signs, determinant-minor lift, pair kick, exact declared-set support, sequential graph cone, and pairwise-disjoint layer-depth cone; no-Gamma(U)/no-one-body no-gos; 4/5 discriminator | Nonlocal gate control; footprint-vs-locality lemma; layer disjointness explicit | 4/5 remains scoped to a supplied interaction; continuous-time derivation and free-walk composition remain open | M (finite layer cone) / C (field dynamics) | M/C - SIGNED | M/C - SIGNED |
| Observed mass/scale selection | C | STRONG NEGATIVES LANDED: exact homogeneous collapse; `FiniteHomogeneousScaleNoGo` (Euler, kernel-only); marginal direction = pure dilatation, c+b^2 = 0 identically (exact analysis, ledgered) | p=0 flat control; quartic unit witness; exact 2-cycle line | No mass value predicted - stated in every manuscript; KT escape closed for degree-1 homogeneous decimations; selection retargeted to refining families with running couplings (H7 needs H4 + RG dynamics) | Negative theorems M; selection remains C (retargeted) | (to sign) | M(negatives)/C(retarget) - SIGNED |

## Required audits

- [x] Every abstract sentence has an anchor or visible interpretation grade
      (A: claim-matrix anchor sweep PASS; C: synced to landed theorems
      tonight; companion: boundary paragraphs).
- [x] Every cited Lean declaration was independently opened and inspected
      (Codex 216-identifier sweep vs 15,502 declarations; Fable
      four-over-claim-mode audit on the f4879a60 harvest).
- [x] Every flagship guard and targeted build passed (latest ledgered
      verifier PASS x2 at 55 headline modules, hash
      EBB3D95AF2D078E9959773954D41C96D7528010A5123621E65D47459A1B7C9B9;
      OvernightTheoryAxiomGuard PASS with the 4 new HalfPeriodInvariant
      pins).
- [x] Placeholder/expanded-trust scans were run and recorded (sole
      raw-sorry grep hit = preserved commented erratum in WallModeWitness;
      12 disclosed handoff holes confined to 4 non-imported submission
      targets, Codex 07:18).
- [x] Nonzero witnesses and boundary controls are present (every headline
      row above lists its control).
- [x] Metric, gamma, chirality, Fourier-sign, and ordering conventions
      agree (negative-lattice-angle convention control landed in the D
      core; PauliTraceConventions landed).
- [x] Strict QCA locality is not conflated with local Hamiltonian
      evolution (E scope corrections 04:35, 06:12).
- [x] Fixed-mode/compact-support results are not called a PDE limit
      (R4 register; D-row language).
- [x] Constant `z` reparametrization is stated honestly (A abstract repair
      06:18; C paper states removability; companion states the exact
      conjugacy).
- [x] Supplied/fitted/held-out parameters are disclosed (4/5 = supplied
      sector; g^2 preregistered held-out; window charge pre-registered
      with kill condition BEFORE computation).
- [x] Novelty comparisons were checked in primary sources (Dittmaier/AHH
      full-text chunks earlier in run; 10 walk/QI anchors verified +
      ingested tonight; Cedzich bibitem title CORRECTED in the C paper;
      2607.05112 rejected as unverified).
- [x] Simulations and failure controls rerun from documented commands
      (dynamics_lab v1.1 demos; verifier numerical fixtures x2;
      whole-family censuses tonight).
- [x] General-audience ontology does not overwrite research-paper evidence
      grades (GA untouched tonight by design; kernel-first discipline).

## Paper verdicts

| Paper | Readiness | Strongest completed result | Fatal remaining issue | Justified venue lane | Signatures/disagreement |
| --- | --- | --- | --- | --- | --- |
| A | NEAR-READY (specialist) | Canonical operator + exact walk + classification + controls; compile + anchors PASS | None theorem-side; artifact freeze + author line are release gates | J.Phys.A-level; prestige gated on C-stability or strict-QCA upgrade | Fable SIGNED; Codex (to sign) |
| B | THEOREM-GATED | Two scoped no-go families + alias lower bound + lattice-independent NN origin | Universal resource lower bound or strict successor missing | - | Fable SIGNED; Codex (to sign) |
| C | THEOREM-GATED, materially upgraded tonight | Proven positional law + full-walk protection + blindness/ill-definedness of winding, timeframe-pair, and mirror refinements | Stability/CGGSVWZ match open (573430f4); general-L open | Quantum vs SciPost = user decision | Fable SIGNED; Codex (to sign) |
| D | THEOREM-GATED | Complete finite DFT/spectral core + exact tail rates | Exponential K-growth of the live box constant (repair in flight) | - | Fable SIGNED; Codex (to sign) |
| E | THEOREM-GATED | Exact declared-set CAR cone + minor-lift functoriality + no-gos | Continuous-time / dynamical successor | - | Fable SIGNED; Codex (to sign) |
| F | Split route: negative classification near-ready; positive selector theorem-gated | Negative selector spine + moduli disk + abstract cohomology quotient + supporting Laurent/Ward/phase/layer landings | Live carrier quotient, noncircular positive selector, and physical equivalence relation still open | JMP/J.Phys.A negative route; positive-selector paper remains theorem-gated | Fable SIGNED (cross-audit filed); Codex (to sign) |
| G (general-audience companion) | Held | Task-1 restructure + demoted-scope sync earlier in run | Needs post-run sync to tonight's landings (earned scope only) | General-audience venue after research ratifications | Fable SIGNED; Codex (to sign) |

## Trust and build disclosure

- New trusted modules: NONE (all overnight work is in Draft/ by design).
- New draft modules (Fable lane): PlueckerWindingDerived,
  PlueckerPhaseObservable, ChiralFlipMode, SignWallDefectRouteB,
  SignWallDefectRouteBConcrete, MassMixedness, GaugeClassification,
  ModeInvariantHalfWinding, WallModeWitness, PauliTraceConventions,
  HalfPeriodInvariant. (Codex lane): HalfWindingFullWalkControls,
  HalfWindingFieldPositionClassification, PlueckerCausalCone, the D-lane
  DFT/bridge cores, StrictQCAMinimalArchitecture,
  CommutatorWilsonStrictnessKill, ChannelPositiveSectorModuli,
  ChannelPositiveComplementDisk, ChannelPhysicalCohomology,
  FiniteHomogeneousScaleNoGo, and the selector/torsor/signature spine.
  Note: this is a historical inventory; several items have since landed or
  been superseded by the morning ledger and paper-verdict table. The
  latest ledgered aggregate verifier remains the 49-module PASS above; the
  08:07-08:36 landings are source-level/compile-level results only.
- Proof placeholders in draft/handoff code: 12 disclosed handoff holes in
  the 4 in-flight submission targets (NOT imported into any root or the
  verifier); 1 preserved commented false-statement erratum
  (WallModeWitness provenance).
- Compiler-trusting finite checks: the +2 footprint
  (`Lean.ofReduceBool`/`Lean.trustCompiler`) is confined to explicit
  rational instantiations and 16-field decisions, each guard-pinned and
  disclosed in module docstrings (K6 fixtures, position classification,
  HalfPeriodInvariant, full-walk controls); engines and abstract theorems
  are standard-3.
- Full build: `lake build` 8,298 jobs PASS; the optional PhysicsSMDraft
  root retains the 4 KNOWN pre-existing E8/SpherePacking import failures
  (Windows search path), unrelated to the overnight surface.
- Pre-commit: scoped surfaces PASS (92-file Codex surface + Fable
  touched-file runs); `git diff --check` PASS.
- archival_ready = FALSE (dirty tree) - release is user-gated.
