# From here to mass from QCD: the closure-channel roadmap

Date: 2026-07-07 (late). Author: Fable 5 (synthesis seat). Status: LIVE
planning document for the null-edge program's QCD/closure endgame.
Claim calculus applies throughout: `T` source-verified theorem, `M`
machine-verified program-internal, `C` pre-registered conjecture,
`[import]` external result used as input.

## 0. Why this document

Roughly 99 percent of the mass of visible matter is not Higgs-generated:
it is QCD binding energy - gluon field energy, quark kinetic energy, and
the trace anomaly, confined into color singlets. A program whose thesis is
"mass is the obstruction to coherent null transport" has not explained
mass until its closure channel (`Q_C` in the carrier Weitzenboeck split)
delivers this. This document states precisely what "delivering it" means,
inventories what is already kernel-checked, and lays out the staged gap
with claim ceilings and kill conditions.

## 1. The target, defined honestly

"A full description of mass from QCD" decomposes into five pillars plus a
boundary we do not claim:

- P-CONF (confinement): static color charges cost energy growing with
  separation (area law / string tension `sigma`); physical states are
  color singlets.
- P-GAP (mass gap): the transfer/Hamiltonian spectrum above the vacuum is
  bounded away from zero; correlations cluster exponentially.
- P-CHI (chiral symmetry breaking): the dominant source of constituent
  quark mass (~300 MeV per light quark) is a dynamically generated
  condensate, not the Yukawa term; the pion is its (pseudo-)Goldstone.
- P-SPEC (hadron spectrum): meson/baryon masses as bound-state levels of
  the confined, gapped, chirally broken theory.
- P-BUDGET (mass budget): the decomposition of a hadron's mass into
  quark-mass, kinetic, gluon-energy, and anomaly shares (Ji 1995
  `[import]`) - i.e. WHERE in the operator the mass sits.
- BOUNDARY (not claimed): the continuum limit at weak coupling -
  existence of quantum Yang-Mills with a gap in the continuum is the Clay
  problem. Everything below is finite-complex or strong-coupling; the
  program's quotient-then-limit rule (Q06) governs any limit language.

Known-science calibration `[import]`: lattice QCD computes the light
hadron spectrum to percent accuracy from first principles numerically
(Durr et al. 2008); strong-coupling expansions prove area law and gap in
the strong-coupling phase (Wilson 1974; Osterwalder-Seiler 1978); the
condensate-spectrum link is Banks-Casher 1980. Our value-add is NOT
recomputing these: it is (a) kernel-checked versions of the
strong-coupling pillar theorems, and (b) the carrier-native reading -
closure disagreement as the common invariant - with the mass-budget
theorem (stage S6) as the genuinely novel deliverable shape.

## 2. Where we are (inventory, kernel-checked unless marked)

The program is further along here than anywhere else outside kinematics.
The GateYM lane holds ~113 modules with a build-enforced guard
(`PhysicsSM/Draft/NullEdge/GateYM/SlabAxiomGuard.lean`). Highlights, by
pillar:

- P-CONF: strong-coupling Wilson-loop area law at concrete-lattice level
  (`TYAreaLaw.tyAreaLaw_slab_exp`); character expansion bound
  (`CharacterExpansion.charCoeff_abs_le_dim_mul_trivCoeff`); Elitzur-type
  results; center-flux sectors; `AreaLawTransport`.
- P-GAP: slab reflection positivity
  (`WilsonSlabConnected.wilsonSlabConnected_reflectionPositive`), positive
  closure/transfer gaps (`SlabTransferGap.neU4_closure_gap_pos`,
  `SlabGapAssembly.slabGapAssembly`), an OS-reconstructed spectral gap
  (`OSReconstruction.osSpectralGap_pos`), exponential clustering
  (`SlabClustering.slab_exponential_clustering`), and the exact readout
  identity `partitionRatio_eq_exp_neg_osSpectralGap`. Remaining polymer
  strengthening is blocked on ONE documented hole: the fixed-forest
  injection (`PolymerKPConclusion.lean` ~line 1564; handoff piece 7,
  Aristotle-ready with its own proof sketch).
- P-CHI: the exact Ginsparg-Wilson structure with edge-reversal grading
  (carrier lane); the GW-circle facts for the overlap operator
  (`BanksCasherShadow.lean`: `Dov - 1` unitary, gamma5-Hermiticity); the
  finite Banks-Casher condensate identity is SCOPED there but not
  attempted. The RG-Schur witness (`RGSchurMassWitness.lean`, 2026-07-07)
  supplies the mechanism seed: decimation converts null disagreement into
  non-null effective terms, with the collinear control.
- P-SPEC prerequisites: color fiber `Lambda(C^3)` with hypercharge
  derived (Q04); color commutant landings
  (`ColorCommutantScalar`/`ColorCommutantMultiplicity`) - the singlet
  sector has kernel-checked structure; two-state transfer spectra on
  small complexes; `QCCarrierBridge.LeadingQCCarrierContract`
  (readout = tanh) tying QC readouts to the carrier.
- P-BUDGET prerequisites: the carrier Weitzenboeck split
  `4 D^#D = Q_A^# + Q_C^# + 4 Q_T + 4 E_#` (guard-pinned as an algebraic
  identity) - the candidate finite mass-budget decomposition; abelian
  closure Gram = Laplacian (`QCClosureGramCheck`).
- Kinematic anchor (TRUSTED): `det P = sum |psi_i wedge psi_j|^2`.

## 3. The staged gap: S1-S7

Each stage: TARGET (the statement to land), STATE, NEEDED, CEILING (the
strongest honest claim available at that stage).

### S1. Nonabelian Q_C identification (THE crux; handoff piece 3)

- TARGET: on a nonabelian finite model, identify the Weitzenboeck `Q_C`
  with a manifestly positive closure object: either `Q_C = L^# L` for a
  rectangular closure current `L`, or `Q_C = sum_f J_f^# J_f + R` with
  the remainder `R` classified (zero / PSD / indefinite). Then the
  small-plaquette expansion note: `|1 - hol(f)|^2 ~ |F|^2` - closure
  disagreement IS gauge-field energy density at leading order.
- STATE: abelian/unitary Gram = Laplacian landed; nonabelian OPEN.
- NEEDED: two-face SU(2) numeric oracle first; then Lean; the three
  outcomes are pre-registered in the hardest-pieces handoff. If `R` is
  indefinite, positivity relocates to the physical-sector quotient
  (Q01/HSTAR interface) - a reroute, not a defeat.
- CEILING: `M` finite identity. This stage decides whether "QCD mass =
  closure disagreement" is an operator theorem or only a channel label.

### S2. Strong-coupling gap, completed (piece 7)

- TARGET: close the fixed-forest injection, discharging
  `fiber_card_mul_le_factorial` and landing the polymer/KP bound; combine
  with the pinned slab gap into a single strong-coupling gap statement
  with explicit coupling domain.
- STATE: everything else in the chain is pinned (reflection positivity,
  slab gap, OS gap, clustering, area law); ONE documented hole with its
  own proof sketch in comments.
- NEEDED: ship the file section standalone to Aristotle (left-inverse
  parsing argument; tie-break lemma explicit).
- CEILING: `M` - a kernel-checked strong-coupling mass gap on the
  concrete lattice class. This is the first honest "mass from QCD"
  THEOREM the program can own end-to-end. Estimated: days.

### S3. String tension as closure disagreement per unit area

- TARGET: wire the pinned area law to a mass statement: the static
  pair's energy grows as `sigma * L` with `sigma` = areal density of
  closure defect; flux-tube reading; "meson mass scale = sigma * length"
  at strong coupling. Mostly assembling pinned pieces
  (`TYAreaLaw` + `partitionRatio_eq_exp_neg_osSpectralGap` +
  `QCCarrierBridge`) plus one new potential-from-Wilson-loop lemma.
- STATE: components pinned; the assembled statement not yet written.
- NEEDED: one Lean assembly module + the S1 identification for the
  "closure disagreement" wording to be operator-honest.
- CEILING: `M` finite identity; prose reading `T|H` conditional on S1.

### S4. Chiral symmetry breaking (the constituent-mass source)

- TARGET, in three rungs:
  (a) finite Banks-Casher identity: regularized condensate = eigenvalue
      count near zero of the GW-circle spectrum, on a FIXED finite
      background (the `BanksCasherShadow` scope);
  (b) strong-coupling condensate nonvanishing (finite analog of the
      known strong-coupling result `[import]` for orientation);
  (c) mechanism wiring: iterate the RG-Schur step - blocking maps
      generating non-null effective terms from null microstructure IS
      dynamical mass generation; connect the generated term's chirality
      structure to the GW grading (it must be GW-compatible, not a naive
      mass).
- STATE: GW-circle facts landed; identity scoped; RG-Schur one-step
  witness landed; (b), (c) not started.
- CONSTRAINT (hard rail): Banks-Casher is a SPECTRAL statement. Program
  rule: spectral language is forbidden until the positivity crux closes.
  Rung (a) must therefore be stated as a finite eigenvalue-COUNT /
  characteristic-polynomial identity on a fixed background (no spectral
  measure, no thermodynamic limit), or explicitly gated on the Q01
  physical-sector closure.
- CEILING: `M` for (a) as a finite identity; `C` with gates for (b),
  (c). Physical constituent-mass claims stay `T|H` at best until S7.

### S5. Color singlets and hadron masses

- TARGET: define hadrons program-natively - color-singlet states = the
  commutant sector of the `Lambda(C^3)` strand fiber (the landed
  color-commutant results are exactly this door) - and compute
  transfer-matrix level splittings below the gap on small complexes;
  strong-coupling meson mass formulas as finite identities.
- STATE: singlet-sector algebra landed; two-state transfer spectra
  landed; no bound-state-level statement yet.
- NEEDED: a "first meson" module: smallest complex with a singlet
  two-point function whose decay rate is kernel-evaluated; compare
  against the strong-coupling expansion `[import]` as an oracle fixture.
- CEILING: `M` finite identities for level splittings; NO claim of
  physical hadron masses (that needs S7's scale).

### S6. The hadron mass budget (the program's distinctive theorem)

- TARGET: the Ji-decomposition analog, finite and exact: for a
  (singlet) state `psi` of a carrier complex,
  `4 <psi, D^#D psi> = <Q_A^#> + <Q_C^#> + 4 <Q_T> + 4 <E_#>` - the mass
  budget splits EXACTLY into aperture (kinetic), closure (gluon-energy
  -shaped), turn (quark-mass-shaped), and soldering-gradient
  (gravity-shaped) shares. Then evaluate the budget on the S5 witness
  states: the program's claim "hadron mass is dominantly closure
  disagreement, not turn amplitude" becomes a computable finite
  statement mirroring the physical fact that ~99 percent of proton mass
  is not Yukawa.
- STATE: the operator identity is guard-pinned; the expectation-value
  budget theorem and a witness evaluation are not yet written; the `#`
  vs Hilbert-adjoint honesty caveat carries over verbatim.
- NEEDED: one Lean module (cheap - it is linear algebra over the pinned
  identity) + the S5 witness + S1 for the closure share to be honestly
  named. This is the flagship paper shape for the QCD slot: "The mass
  budget of a bound state on a finite null-edge complex."
- CEILING: `M` finite identity + `T|H` physical reading. Novel
  packaging; nothing comparable is kernel-checked anywhere.

### S7. Scale: dimensional transmutation and the continuum (the boundary)

- TARGET (honest version): (i) express all S2-S6 masses in units of the
  string tension or gap (dimensionless ratios - what lattice QCD
  actually predicts); (ii) iterate the RG-Schur step into a blocking map
  with controlled coefficient growth (the M-dependent generalization is
  queued) and state monotonicity facts; (iii) IMPORT the perturbative
  beta function and asymptotic freedom as `[import]` context, never as a
  program result.
- NOT TARGETED: weak-coupling confinement, the continuum limit, or any
  Clay-adjacent claim. The Q06 refinement-category ladder (R0-R6) is the
  only sanctioned limit language, and every continuum sentence stays
  behind the quotient-then-limit rule.
- CEILING: ratios `M`; scale-setting `[import]`; continuum `C` at most,
  with the ladder rungs as gates.

## 3a. AMENDMENT A (2026-07-07 late): external-review upgrades, integrated

An external review (user-supplied memo, same date) proposed five upgrades.
All load-bearing identities were hand-verified by the executor before
integration; they are adopted as follows.

- **A0. The pre-theorem that unlocks S1 (adopted; module landed).** Before
  identifying the carrier's `Q_C`, prove that the STANDARD Wilson gauge
  action is itself a squared closure defect: for unitary `U`,
  `Tr((1-U)^dag (1-U)) = 2N - 2 Re Tr U`, hence
  `S_W = (beta/2N) sum_f |1 - H_f|_HS^2` exactly. Verified: expand and use
  `U^dag U = 1`, `Tr U^dag = conj Tr U`. Kernel-checked in
  `PhysicsSM/Draft/NullEdge/GateYM/PlaquetteClosureAction.lean`. The
  thesis sentence sharpens to: "QCD mass is the transfer-matrix energy
  cost of non-closing color-null transport."
- **A1. S1 splits into S1a + S1b (adopted).** S1a (fast): the linearized
  theorem - at the flat connection the Hessian of the closure action is
  `d_1^# d_1 (x) kappa` (face-edge coboundary tensor the invariant form);
  this alone justifies the small-plaquette `|F|^2` sentence. S1b (the
  residual crux): the nonlinear/BCH remainder classification
  (`R_comm = 0 / PSD / indefinite`), with the existing honesty rail
  unchanged. The crux is now isolated in the commutator remainder only.
- **A2. S3 gains an exact finite theorem (adopted).** The coupling
  derivative of the Wilson-loop tension is the EXCESS areal closure
  defect induced by the sources:
  `d/dbeta [-log <W(C)>] = <S~>_W - <S~>_0` with
  `S~ = (1/2N) sum_f |1 - H_f|^2` (Feynman-Hellmann on the finite
  ensemble; verified). String tension is not merely correlated with
  closure defect - its coupling derivative IS excess closure defect per
  area.
- **A3. The budget claim splits weak/strong (adopted; changes S6).**
  Define budget fractions `f_A, f_C, f_T, f_E` (each channel expectation
  over `M_#^2(psi) = 4<psi, D^#D psi>`) and prove `f_A+f_C+f_T+f_E = 1`
  on normalized admissible witnesses. The WEAK claim (physically safest,
  matches Ji/lattice budgets `[import]`: quark energy ~33%, glue ~37%,
  anomaly ~23%, condensates ~9%, Yang et al. 1808.08677): hadron mass is
  dominantly NON-TURN (`f_T << 1`). The STRONG claim (`f_C` largest
  single share) is a separate, harder test. S6's first theorem targets
  the weak claim; the strong claim is decided by the S5 witness, not
  asserted.
- **A4. S4a gets a smooth, rail-respecting form (adopted).** Away from
  exceptional (doubler) modes, map the GW circle to the imaginary axis
  by `A = D (1 - D/2)^{-1}` (anti-Hermitian, chirally paired,
  eigenvalues `+-i lambda_j`); define the regularized condensate
  `Sigma_m = (1/V) Re Tr (A + m)^{-1}` and the smooth near-zero count
  `N_m = sum_j m^2/(lambda_j^2 + m^2)`. Exact finite identity (verified):
  `m V Sigma_m = N_m`. No spectral measure, no limits - a trace identity.
  Follow-up conjecture (grade C, gated): controlled blocking of
  closure-disordered backgrounds increases `N_m` - the bridge from the
  RG-Schur mechanism to constituent mass.
- **A5. Module sequence (adopted as the S-lane execution order).**
  (1) `PlaquetteClosureAction.lean` [LANDED]; (2)
  `LinearizedNonabelianClosure.lean` (S1a Hessian); (3)
  `ClosureTensionDerivative.lean` (A2 identity); (4)
  `CarrierMassBudgetExpectation.lean` (f-sum = 1); (5)
  `FiniteBanksCasherSmoothCount.lean` (A4 identity); (6)
  `FirstMesonClosureBudget.lean` (S5 witness with budget insertions
  `B_C(t)` tracking the flux sheet; success = `m_Gamma ~ sigma |Gamma|`
  and `B_C` localized on the sheet).
- Additional lit anchors adopted: Yang et al. (2018) proton mass
  decomposition from the QCD EMT (arXiv:1808.08677); Ji (1994/95)
  hep-ph/9410274; Durr et al. arXiv:0906.3599 - ingest with dedup check.

## 4. Critical path

```text
S2 (KP injection)  -- days; unblocks the clean gap theorem [Aristotle now]
S1 (nonabelian Q_C) -- the crux; oracle-first [numeric this week]
S3 (string tension assembly) -- after S1 wording, pieces are pinned
S4a (finite Banks-Casher count identity) -- clean novel Lean target
S6 (mass-budget theorem) -- cheap Lean; needs S5 witness for content
S5 (first-meson witness) -- small complex + oracle fixture
S4bc, S7 -- long-running; gated
```

Parallelism: S2 and S4a are independent Aristotle packages; S1's oracle
and S5's witness share the small-complex infrastructure; S6 can be
stated abstractly before S5 lands (vacuity guard: it is only "landed"
with a witness state, per the four over-claim modes).

## 5. Kill conditions and honesty rails

- S1 outcome (c) (indefinite remainder): closure positivity relocates to
  the physical-sector quotient; S3/S6 wording must then say "channel
  share", not "positive energy share", until Q01-Stage-C lands.
- S4a must not smuggle spectral-measure language; if the finite count
  identity cannot be stated without it, STOP and gate on positivity.
- S5's decay rates must match the strong-coupling oracle fixture within
  stated tolerance, or the witness is misconstructed - fixture first.
- No sentence of the form "we derive confinement/the mass gap" without
  the qualifier "strong-coupling, finite complex class"; the Clay
  boundary is named in every outward-facing artifact.
- Lattice numerics (ours or imported) are oracle fixtures, never proof.

## 6. Literature anchors (to verify/ingest before the writeups)

- Wilson (1974), confinement and strong coupling. `[import]`
- Osterwalder-Seiler (1978), lattice reflection positivity and the
  strong-coupling phase. `[import]` (already the OS lane's source frame)
- Banks-Casher (1980), condensate = spectral density at zero. `[import]`
- Ji (1995), proton mass decomposition; plus the modern mass-budget
  literature. `[import]` - the S6 comparison target.
- Durr et al. (2008), ab initio light hadron spectrum. `[import]` -
  calibration of what "full description" means numerically.
- Montvay-Muenster, strong-coupling expansions (meson masses). `[import]`
- Run the pre-add existence check before ingesting; several OS/lattice
  items are already in the null-edge collections.

## 7. One-paragraph summary

The program already owns kernel-checked strong-coupling versions of
confinement (area law) and the mass gap (slab/OS chain) - the two hard
pillars - plus the chirality framework (GW), the singlet sector (color
commutant), the mechanism seed (RG-Schur), and the budget identity
(Weitzenboeck). What separates this from "mass from QCD" is: one
combinatorial hole (S2), one operator identification (S1 - the true
crux), one spectral-honest condensate identity (S4a), one witness
computation (S5), one assembly theorem (S6), and the permanently honest
boundary at the continuum (S7). Everything except S7 is finite, staged,
and either Aristotle-ready or oracle-first; S7 is where the program's
claim discipline - ratios yes, scale no, continuum never (yet) - earns
its keep.
