# Final report: 24-hour publication run ending 2026-07-12

Draft populated ~05:40 PDT; complete the freeze-time fields (commit SHA,
verifier two-pass, full-build counts) at the 08:00 freeze. Trust legend:
Kernel = [propext, Classical.choice, Quot.sound]; Kernel+Eval = also
[Lean.ofReduceBool, Lean.trustCompiler] (compiled evaluator, disclosed);
oracle-exact = computed exactly, not formalized; run-record = computed,
not yet kernel; HONEST-PENDING = no manuscript claim rides on it.

## Executive result

1. A timelike rest gap is packaged as an odd Hermitian operator whose
   off-diagonal datum is the complex Plucker area of two null spinors;
   the same finite cubic closure `X^3 = (area) X` governs both that rest
   operator (for any number of null constituents) and the supplied
   many-body interaction, and the interaction's selecting gauge is not
   chosen but forced by covariance of the derived family.
2. For the exactly-unitary 3+1 successive-axis walk, the crossing
   doublers carry an exact charge bookkeeping derived from the Bloch
   symbol itself at all eight nodes — opposite charges at the two
   quasienergies, summing to zero — a machine-checked instance of the
   discrete-time doubling obstruction, with the 1+1 flow-count law proved
   from eigenphase geometry.
3. The interacting two-particle spectrum of the finite fermionic walk is
   exact: the composed step's characteristic polynomial factors into
   named free levels and a palindromic degree-12 factor whose twelve
   quasienergies solve one rational cubic.

## Landed theorems and exact no-gos

| Result | File/declaration | Trust | Witness/control | Manuscript effect |
| --- | --- | --- | --- | --- |
| Generalized cube law `B_w^3=mu^2 B_w`, all n; rank-4 support | `PlueckerRestOperatorGeneral.*` | Kernel | non-decomposable control (coeff fails) | A open-problem-4 resolved |
| Selection RESOLVED + FORCED (covariance group = chiral circle) | `PairKickSelection.*`, `Selection2Repairs.scalar_gauge_collapse`, `MassCovarianceForcing.classification/covariance_group_eq_chiralPhase` | Kernel | scalar-gauge collapse; equivariance control | A: interaction gauge forced (static); dynamical commutant open |
| CAR-to-block reduction isomorphism + gauge tie | `CARBlockReduction.hermitian_iff/blockOf_KopL/Kop_equivariance/sharpener` | Kernel | — | A: reduction is a theorem, not packaging |
| 8-node charge census DERIVED from walk symbol, anchored to landed census | `SplitStepSchurJetAllNodes.*` + `CensusDerivationBridge.census_agree/capstone_charge_reproduces_landed` | Kernel | no drift (compiler-enforced) | A: doubling census kernel-derived |
| 1D flow-count from eigenphase geometry | `TwoBandEigenphaseAnalytic` (`...TwoBandFamily.countAt_locally_constant/jump_law/flowDiff_eq_zero`) | Kernel | flow-one fixture | A: 1+1 no-single-crossing; concrete instance [flowinstance] |
| Multiplicity census 2/4/0 | `CensusMultiplicity.*` | Kernel-clean (07-12 retrofit) | 16-field certificates | C: last caveat removed |
| all-theta self-adjointness iff + atlas | `ThetaFamilyCompletion.*` | Kernel | wrong-chart = -2 sin theta | C: genuinely all-theta |
| translation-index impossibility | `CGGSVWZDictionary.no_periodic_index...` | Kernel (decide) | protected singleton vs translate | C |
| exact interacting charpoly = degree-28 product + cubic | `PairSpectrumFixture.charpoly_factorization/p12`, `PairCharpolyBridge.V_charpoly_eq` | Kernel (structural charpoly) + Kernel+Eval (twin arith) | 6 pinned modes (kernel decide) | E: headline, charpoly identification closed |
| `V_annihilated` kernel-from-charpoly (Cayley-Hamilton) | `CayleyHamiltonAnnihilation.*` | Kernel | — | E: annihilation not an independent heavy native |
| momentum blocks 6/8/6/8 + annihilators | `PairMomentumBlocks.*` | Kernel+Eval (twin) [momtwin->kernel in flight] | neutrality; participation open | E: structural companion |
| Aut_e111 ~= SU(3), = specialUnitaryGroup | `octonionMulAutFixingE111MulEquivSU3`, `su3Submonoid_eq_specialUnitaryGroup` | Kernel, guarded | — | FB: algebraic (not Lie G_2); group-iso LANDED (FBGroupIso) |

## Rejected or sharpened routes

| Proposed route | Verdict | Exact blocker/counterexample | Successor |
| --- | --- | --- | --- |
| full four-component Dirac local charge nonzero | FALSE SHAPE | explicit mass homotopy gaps it (class-A neutral) | Weyl-sector charge (chirality-resolved) |
| naive pairKick = quarter half-pulse (no phase) | FALSE | `naive_halfpulse_false` (sign mismatch) | corrected i*U(0,1) identity |
| embrace-doubling via derived kick gaps doublers | KILL fired | composed kick VECTORIZES (Gamma-even, chi -4->0) | odd-kick C4 dichotomy (kernel) |
| window half-charge symbolic Gamma route | OUT_OF_BUDGET (34GB) | symbolic matrix blowup | integer-twin minimal cut [halfcharge3] |
| E fixture natives in aggregate guard | OOM (my error) | Vz^28 > 34GB | separate PairSpectrumFixtureGuard |

## Manuscript and portfolio changes

- Paper A (frozen): +generalized cube law, +selection forced, +CAR-block
  reduction, +8-node kernel census, +1D flow-count; abstract adjectives
  aligned to body (redteam); "no independent mass parameter" -> honest
  reparametrization; appendix+manifest +7 modules.
- Paper C (frozen): census kernel-clean; marks corrected.
- Paper E (working draft): spectrum charpoly closed; trust marks
  scoped to eval-on-twin; de-"skeleton".
- FB paper: abstract qualified (algebraic automorphism group, MulEquiv
  onto submonoid, not smooth Lie G_2); flagship/remainder axiom split;
  group-iso upgrade LANDED (FBGroupIso, kernel).
- Jordan-Clifford bridge: unchanged this run; remains graded rungs with
  kill conditions (the unification is future work, stated as such).

## Verification

- final headline module count: 66 (verify_null_edge_paper_a.py) + 7 new
- aggregate guard job count: 8,346 (green ~05:50; RE-RUN AT FREEZE)
- heavy E-fixture guard: PairSpectrumFixtureGuard (on-demand, >34GB)
- full build: the aggregate guard build (8,346, targeted) is the
  verification of record; a bare `lake build` (full glob) additionally
  compiles the E fixture natives (Vz^28 over ZZ[i]) and needs a >34GB
  machine - run it there, or rely on the guard + the on-demand
  PairSpectrumFixtureGuard. The heavy E natives are also verified in the
  Aristotle build environment (job #print axioms).
- numerical fixture hashes: benchmark dd44f123..., dynamics 79cff2a9...
- deterministic verifier summary hash: ____
- pre-commit: passing on touched files (run --all-files at freeze)
- `git diff --check`: ____
- clean/dirty state: dirty (uncommitted run edits) — commit at freeze
- expanded-trust declarations: Kernel+Eval disclosed per §2 (C-POS;
  PairMomentumBlocks twin; E fixture twin arithmetic); no new axioms

## Honest remaining gates

- Theorem gates (OPEN): A dynamical walk commutant; E eigenvector
  participation. LANDED 07-12 (previously listed here): FB group-iso
  (FBGroupIso), flow-count concrete instance (FlowOneInstance), fixture
  faithful kernel (FaithfulKernel), full covariance group
  (CovarianceGroupFull). IN FLIGHT: E momentum kernel-clean [momtwin],
  Vz_annihilated kernel [vzannihil], C-POS kernel [cpostwin].
- Empirical gates: A high-momentum benchmark is a floating-point
  regression check, NOT part of the verified chain.
- Release/user-decision gates: named authors on all manuscripts; clean
  commit + source archive + DOI; venue selection (E->Quantum;
  FB->arXiv+AFM/AACA; A->specialist theorem venue).
- Jordan-Clifford: every rung's dimension-match / imported-theorem /
  noncanonical-choice / unformalized-interpretation status is in
  JORDAN_CLIFFORD_BRIDGE_PROGRAM.md; the master unification is unproven.

## Active external jobs (at ~05:52)

LANDED + INTEGRATED (guard green 8346): flowinstance (FlowOneInstance),
faithful (FaithfulKernel, on-demand heavy guard), fbgroupiso (FBGroupIso),
covfull (CovarianceGroupFull).
RUNNING: momtwin (cb89fd27, momentum kernel-clean), vzannihil (38810370,
Vz_annihilated kernel), cpostwin (f0e2e541, C-POS kernel -> Paper C fully
kernel-clean).
None supersede a landed result; all are strengthenings/caveat-closers.
