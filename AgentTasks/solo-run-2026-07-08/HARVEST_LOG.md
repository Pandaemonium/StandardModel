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

## Tally (2026-07-08)
Harvested 22 of 23 jobs (finitecpt R still running). Integrated as M/structural: 4 proof
wins (nulldecomp, chiralindex, bindingdeficit, schurseesaw) + subluminal + mass<=energy
(earlier) + 13 strategy wins (bindingplane, confinementpositivity, positivesectors,
eslotgeometry, carrierrigidity[nuanced], checkerboardbridge, windinglowmodes, massthermo,
signatureforcing[rung1], finitelevinson, wayturn, phasediagram, spectraldistance,
modularselection, massdesigns, divisionselection). No-gos recorded: familyindex (three
not forced), carrierrigidity (non-rigid). Superseded: cpholonomy (Bargmann is the home).
Every integrated module builds green in-project, footprint [propext, Classical.choice,
Quot.sound]. Manuscript: S3 bidirectional thesis, S3a binding=deficit (C->M), S9 carrier
binds unconditionally (C->M), S4 rigidity partly-resolved. Follow-up round of 4 closers
submitted (siglorentz, rigidityaxiom, familyrankfix, bargmanncp). REMAINING: harvest
finitecpt (R) + the 4 follow-ups when they land.
