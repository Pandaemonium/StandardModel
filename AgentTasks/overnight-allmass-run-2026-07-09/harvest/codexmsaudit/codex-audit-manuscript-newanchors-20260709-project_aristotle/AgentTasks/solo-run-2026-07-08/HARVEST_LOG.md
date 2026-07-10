# Harvest log — frontier jobs (2026-07-08)

Loop: download -> check sorry -> read summary -> build in-project -> semantic review
-> integrate at honest grade OR record no-go. Proof jobs first (likely M).

| job | id | status | verdict |
|---|---|---|---|
| nulldecomp | 15f19a55 | INTEGRATED M | converse: all mass IS null-edge disagreement (2-null decomp + PSD=MMᴴ). §3 bidirectional |
| chiralindex | bd0349a8 | INTEGRATED M | F6: dim ker ≥ index, perturbation-stable, ≥1 protected mode. §8/§11 (exactly-one out of scope) |
| bindingdeficit | b76379eb | INTEGRATED M | F8: Δ=κ=C(ρ)λ, binding=entanglement deficit. Closes §3a target (ii) C→M |
| schurseesaw | 9fb722f7 | INTEGRATED M | E: |m_eff|≤‖Bᴴv‖²/λ_min(M)→0, seesaw suppression. §10/§11 (neutrino-lightness) |
| bindingplane | 6b0d5321 | INTEGRATED M | F5: carrierK = closureCurvature (binding plane), ground mode spectator => carrier binds UNCONDITIONALLY. Closes DerivedInteraction C->M |
| confinementpositivity | f30e34a2 | INTEGRATED M | B: colored (traceless) => qval<0 negdef (no positive mass); singlet positive. Confinement = finite positivity dichotomy |
| positivesectors | ddf1d5bf | INTEGRATED M | step2: posDef_aperture_add_gram (A PosDef => A+BᴴB PosDef), mass gap>=1. Generalizes T2 beyond Cl(4) |
| eslotgeometry | cf0ecc48 | INTEGRATED M | F7: E-slot transformation law (tensorial on metric-preserving group), contorsion/nonmetricity split, no double-counting Q_C |
| carrierrigidity | 0e0f0db4 | INTEGRATED (nuanced) | F2: square_decomposition = exact 4-block, NO fifth block (type-count forced); but full uniqueness NOT forced (non-rigid). Disciplines "unification=decomposition" |
| checkerboardbridge | 5511075a | INTEGRATED M | F1: 1+1D Dirac QW IS a Krein carrier; null Clifford edges, kinetic/mass/D all Krein-self-adjoint, channels match. First "channels=physics" evidence |
| windinglowmodes | 0c848e8e | INTEGRATED M | F4: winding_protects_low_modes (winding-w bg has >=w protected zero modes, disorder-robust); index=w. Structured (not random) accumulates. Also Conj S |
| familyindex | 4f822368 | INTEGRATED (NO-GO) | C: count of completions = n+1, =3 iff n=2; three_not_forced. "Three generations" NOT forced w/o a rank-fixing axiom. Honest negative |
| cpholonomy | c57c871b | SUPERSEDED | D: 3 wedge-triple identities proved (SL2-inv, CP-odd, magnitude) BUT wedge triple not phase-gauge-invariant; the Bargmann module (NullEdgeBargmannPhaseInvariance) is the gauge-invariant home. Not integrated |
| massthermo | 2e522ee0 | INTEGRATED M | V: gibbs_duhem_sum_rule (Sum chi=0) + closure susceptibility dbC/dk=l/(l-k)^2 DIVERGES as k->l. Mass thermodynamics |
| signatureforcing | d58cb415 | INTEGRATED (rung1 M) | M: null_forces_indefinite (rung 1, Clifford wrapper); (1,3)&(2,2) both indefinite. Rung 2 (RP selector) = precise pre-registered PROBE (lives in OS lattice/tensor, not quadratic form) |
| finitelevinson | 10bf50fd | INTEGRATED M | L: finite_optical_theorem (|r|^2+|t|^2=1, phase relation) from S^H S=1. P-J spine, companion M-target |
| wayturn | 10a914e3 | INTEGRATED M | H: way_nogo (U=u(x)1 charge-conserving => [u,Q_s]=0), way_defect_identity, chirality-flip witness. Higgs as WAY frame resource |
| phasediagram | 966d4174 | INTEGRATED M | P-B: finite 4-channel mass phase diagram; 3-phase B3 (massive/critical/over-closure) reproved + multi-channel extension |
| spectraldistance | be0b5442 | INTEGRATED M | P: Connes spectralDist(Dm m) 0 1 = 1/m on the 2-vertex witness -- the complex's metric is RECOVERED from (A,D) (background independence, finite Malament first step) |
| modularselection | 0053fc61 | INTEGRATED M | J: flow_scalar_shift (central shift invisible) + modular flow of Gibbs(B) = B-generated -- derives the D2 generator instead of positing it |
| massdesigns | a02602f5 | INTEGRATED M | I/P-K: spinor_lagrange (|ψ|²|φ|²=|<ψ,φ>|²+|ψ∧φ|²), pair_disagreement_eq (|ψ∧φ|²=sin²(θ/2)=chordal dist). Bundle mass = pairwise energy on S² -- spherical-code foundation |
| divisionselection | 79b0b772 | INTEGRATED M | N: division_algebra_selection (Composes ∧ ContinuousPhase ⟺ k=C) => dimension_is_four. R fails continuity, H/O fail commutativity; only C. Feeds Q5. Boundary: Minkowski/Lorentz IDs are motivating docstrings, algebraic core proved |
| finitecpt | e690c3b3 | INTEGRATED M | R: finite CPT on the explicit C^4 Clifford/color witness; Theta antiunitary, Theta D Theta^-1 = D^#, spectrum conjugate-paired. Scope: explicit witness, not arbitrary carriers |
| siglorentz | 265f327e | INTEGRATED M | Suite A rung 2: one-time OS toy is reflection-positive/nondegenerate; a second time direction gives a concrete reflection-positivity failure. Scope: two-site toy, not full OS reconstruction |
| rigidityaxiom | 6f3f56de | INTEGRATED (nuanced) | Generic graded-decomposition theorem: distinct-grade operator recovers blocks as eigenspaces and makes the split unique; type-count alone does not force the split. Not yet wired to the concrete carrier square |
| familyrankfix | 79472461 | INTEGRATED (NO-GO) | Sharpens FamilyIndexNoGo: triality, anomaly cancellation, and J3(O)-style data do not force n=2; any forcing structure with C 2 is equivalent to the rank-fixing datum itself |
| bargmanncp | febae797 | INTEGRATED M | Bargmann/Pancharatnam triple is CP-odd; Im B != 0 is a genuine CP invariant; Bloch identity gives the Van Oosterom-Strackee tan(arg B) form. Supersedes cpholonomy wedge triple |

## Tally (2026-07-08)
Harvested 27 of 27 jobs after the 2026-07-09 P0 closer pass. Integrated M/structural
wins include nulldecomp, chiralindex, bindingdeficit, schurseesaw, subluminal, mass<=energy
(earlier) + finitecpt + the strategy/structural wins (bindingplane, confinementpositivity, positivesectors,
eslotgeometry, carrierrigidity[nuanced], checkerboardbridge, windinglowmodes, massthermo,
signatureforcing[rung1], finitelevinson, wayturn, phasediagram, spectraldistance,
modularselection, massdesigns, divisionselection, siglorentz, rigidityaxiom, bargmanncp).
No-gos recorded: familyindex/familyrankfix (three not forced), carrierrigidity (non-rigid
without a selecting axiom). Superseded: cpholonomy (Bargmann is the home).
Every integrated module builds green in-project, footprint [propext, Classical.choice,
Quot.sound]. Manuscript: S3 bidirectional thesis, S3a binding=deficit (C->M), S9 carrier
binds unconditionally (C->M), S4 rigidity partly-resolved. P0 closer modules are wired into
`PhysicsSMDraft.lean`; full `lake build PhysicsSMDraft` still fails on the known disabled
SpherePacking dependency, not on the closer modules.

## Semantic review (load-bearing, deep pass)
- bindingplane `carrier_closure_binds`: GENUINE. massBlock_eq_carrierK ties carrierK to the
  actual mass block B=λI+iκK; carrierK_eq_closureCurvature (binding plane); conclusion is the
  real below-threshold IsLeast + boundEnergy<pairThreshold. Non-vacuous. C->M sound.
- divisionselection: NOT hollow. Composes/ContinuousPhase proved from genuine facts (mul_comm,
  noncomposes_quat, phaseC_infinite); selection is case-by-case real algebra. (Minkowski/
  Lorentz IDs honestly left as motivating docstrings, reflected in the manuscript grade.)
- carrierrigidity: no-fifth-block GENUINE. The 4 blocks are independently grade-characterized
  (aperture_even/closure_even/turn_even/solder_odd); type-count forced, uniqueness not (honest).
- familyrankfix `FamilyRankNoGo.three_generations_not_forced`: GENUINE as a sharpened no-go.
  It proves each proposed rank-fixing source is realizable away from n=2 and that any
  successful forcing predicate is equivalent to the rank-fixing datum itself. This should be
  cited as a missing-axiom result, not as a derivation of three generations.
- finitecpt/siglorentz/bargmanncp/rigidityaxiom closer pass: each module has in-file
  `#guard_msgs` axiom pins and targeted builds green. Honest boundaries: finitecpt is an
  explicit C^4 witness; siglorentz is a two-site RP toy; rigidityaxiom is generic
  decomposition algebra, not yet the carrier-specific uniqueness theorem; bargmanncp gives
  the VOS tangent/half-angle form, not a full spherical-triangle area theorem.

## 2026-07-09 Codex seed landings (Goal II / Goal IV / Suite D)

Three Codex-lane Aristotle seed files were ported as small draft modules (all M,
self-guarded, targeted build green):

- `codex-grand-strategy-goalII-IV-suiteCD` -> `NullEdge/KMPhaseCounting`:
  `ckm_param_split` proves the CKM parameter bookkeeping split and
  `cp_possible_iff` proves the CP-phase count is positive iff `N >= 3`. Honest
  scope: count arithmetic only; not yet the constructive N=2 rephasing no-go or
  the N=3 nonzero Jarlskog witness.
- `codex-goalII-finiteKM-strategy` -> `NullEdge/FiniteKMCP`:
  `jarlskog_rephase` proves rephasing invariance, `jarlskog_two_eq_zero` and
  `exists_real_rephasing_two` prove the N=2 no-go in invariant and constructive
  forms, and `Vwitness_unitary` + `jarlskog_Vwitness_ne_zero` prove an exact
  N=3 `3-4-5` unitary witness with nonzero `J = 6912 / 78125`. Honest scope:
  the full general-N incidence/corank theorem is still future work.
- `codex-goalIV-WEP-action-strategy` -> `NullEdge/WEPTrace`:
  `wep_trace_identity` and `wep_universality` prove that a channel-blind source
  `Tr(K rho)` depends only on `Tr rho`; `wep_source_nonvacuous` and
  `wep_violation_of_channel_stress` pin nonvacuity and the load-bearing
  channel-blind hypothesis. Honest scope: WEP trace rung only; no E-slot field
  equation yet.
- `codex-D-kills-resource-audit` -> `NullEdge/MassResourceModularAudit`:
  `modular_generator_eq_adB` proves a central shift cancels in the commutator
  derivation, while `modular_shift_operator_ne` proves the operator equality
  itself is generally false. Honest scope: Suite D modular audit anchor, not a
  full resource theory.
