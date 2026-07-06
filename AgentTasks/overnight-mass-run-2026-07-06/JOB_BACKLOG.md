# Job backlog: WIDE portfolio toward "full origin of mass from null edges"

Goal: **the full origin of mass from null-edge theory**, at kernel-checked finite
grade, honest labels. Strategy: keep Aristotle's 10 concurrent slots SATURATED
with INDEPENDENT (non-gating, non-colliding) jobs across all mass lanes; harvest +
integrate continuously; coordinate lanes with Codex; consolidate periodically into
the `AllMassFromNullEdges` capstone so the wide output converges.

Legend: [ ] open · [~] in flight · [x] landed · (C=Codex lane). Prefer jobs that
do NOT depend on another job's output. Refill from here whenever a slot frees.

## Lane A - APERTURE / composite mass (matter kinematics)
- [x] aperture=turn on one on-shell momentum (`ApertureEqualsTurn`, unconditional)
- [x] ObstructionScalar (C and A share a structure, non-vacuous)
- [x] n-body aperture (sm-nbody-aperture c896e302, 2h-rule finalized):
      `NBodyAperture.lean` - `nbody_massSq_eq_double_sum`, `nbody_massSq_nonneg`,
      and THE HEADLINE `nbody_aperture_massless_iff_collinear` (any N: composite
      Minkowski square = 0 iff a single null direction). Headline sorry-free,
      standard axioms, guarded. ONE documented draft `s o r r y`:
      `nbody_massSq_eq_sum_pairwise` (strict upper-triangular presentation, pure
      re-indexing - the double-sum form is fully proved). Grand-strategy lane-A pick.
- [ ] Plucker/spinor bridge at 3+1D: tie `det P = m^2` to the spinor wedge for
      the full on-shell resolution (extend `PluckerUnificationBridge`)
- [ ] aperture entropy: the rest-frame maximally-mixed direction state (link
      aperture to the "mass = aging" observer-conditioned reading)

## Lane T - TURN / matter mass (Higgs-Yukawa, chirality)
- [x] `gamma5_mass_diff_comm`, `chiralEven/Odd_massVertex` (channel separation)
- [~] Wilson-vertex channel decomposition (sm-doubling-turn 5d05e8de):
      `DoublingTurnPrice.lean` - the FINITE, LOCAL, per-vertex spin-algebra channel
      split: Wilson term is chirality-EVEN (`chiralEven_wilsonProjector = r*1`),
      `chiralEven/chiralOdd_massVertexW`, `chiralEven_massVertexW_eq_zero_iff`
      (clean iff), plus the near-vacuous `no_chiral_and_doubler_removal` and the
      shared-threshold `regulator_turn_tie`. 0 sorry, standard axioms, guarded.
      DOWNGRADED per red-team sm-doubling-audit (521d1c86): this is NOT the
      topological Nielsen-Ninomiya no-go and does NOT establish necessity (no
      momentum/torus/chirality-sum). Docstrings corrected.
- [~] N-N TOPOLOGICAL SKELETON (1D) (sm-nn-nogo 2aaec751):
      `FiniteNielsenNinomiya.lean` - the SOUND pieces: `chiralSym_iff_offDiag`,
      `winding_exists`/`winding`/`winding_eq` (integer winding, NOT forced 0 - SSH),
      `signed_sum_telescope` (boundaryless telescoping), and the kernel-`decide`
      COMPUTED EXAMPLE `signedNodeCount4_eq_zero` (stipulated naiveSin4: +1 node,
      -1 doubler, sum 0). 0 sorry, standard axioms, guarded. DOWNGRADED per red-team
      7805c7f8: NOT a proof of "chiral symmetry => zero signed count" -
      signed_sum_telescope uses a FREE h; odd_signedCount_impossible is VACUOUS
      (unsatisfiable Odd hypothesis). Docstrings corrected.
- [ ] **N-N no-go, tie to chiral symmetry (red-team 7805c7f8 fix, OPEN):** DEFINE
      the signed count FROM a chirally-symmetric D's off-diagonal branch, prove it =
      the telescoping sum, restate necessity with an explicit ChiralSym(D p)
      hypothesis + a count-of-D conclusion. THEN the general d-dim / 4D continuum.
- [ ] NE-U6 electroweak: extend `ElectroweakRung` - W mass as a gauge-invariant
      composite transfer-spectrum feature (build on the proved 2-point clustering)
- [ ] Yukawa turn amplitude: the mass = coin-turn amplitude at operator grade for
      a concrete finite flavor model

## Lane C - CLOSURE / gauge mass (Yang-Mills) - the biggest lane
- [x] connected slab RP (`WilsonSlabConnected`), NE-U4 sector gap
      (`SlabTransferGap`), sign-rep full-block gap (`SlabSignRepGap`)
- [x] OS/GNS reconstruction (`OSReconstruction`): self-adjoint transfer + gap
- [x] (C) summable-defect gap transport, area-law transport, local cyclicity,
      CM slice-projector (Faizal-Shabir pieces)
- [~] **THE ASSEMBLY (north star):** `SlabGapAssembly.slabGapAssembly` LANDED
      (Z2 sign-rep slab), NOW 6 conjuncts: RP-block PSD + Hermitian/self-adjoint
      transfer + strictly-positive OS spectral gap + explicit `-log(tanh beta)`
      value + vacuum separation + EXPONENTIAL CLUSTERING `exp(-(n*gap))` (folded in
      from SlabClustering), as ONE finite theorem (axiom-guarded, standard axioms,
      KP-crux-FREE via OS reconstruction). STILL OPEN: the NONABELIAN SU(2)/SU(3)
      generalization = the single gate (per grand-strategy), via the TY route.
- [x] exponential clustering from the gap: `SlabClustering.slab_exponential_clustering`
      LANDED - connected 2-point decay = C*exp(-(n*gap)) on the Z2 slab transfer
      operator; EXACT identity `slab_connected_correlation_eq`. Folded into assembly.
- [~] **TY ROUTE (grand-strategy pivot 6fecc7f5) - Z2 SCAFFOLD LANDED:**
      `TYAreaLaw.lean` (sm-ty-arealaw 03a37fa8): abstract layer `tyBaseOf p`,
      `tyStringTensionOf p` (parameterized by ANY ratio p in [0,1) - SU(N) drop-in);
      concrete Z2 `partitionRatio = tanh beta`, `tyStringTension > 0`, area law
      `tyAreaLaw_slab_exp` `|W| <= 2*exp(-r*tyStringTension)`, BC-insensitivity
      rate->inf. Tied to the assembly via `partitionRatio_eq_exp_neg_osSpectralGap`.
      0 sorry, standard axioms, guarded. HONEST GAP (remaining to genuine SU(2)):
      the RP/Cauchy-Schwarz raw bound `|W| <= 2*q^r` is an explicit HYPOTHESIS (hW),
      NOT derived; and Z/Z^(-) are MODELED as one-plaquette Boltzmann sums.
- [~] **SU(N) TY SCAFFOLD LANDED** (sm-ty-sun 93e022dd): `TYAreaLawSUN.lean` -
      abstract `TwistSystem N` (Z : Fin N -> R, RP-monotonicity Z_le hypothesized),
      center-average `pN = (1/N)Sum ratio`, `tyBaseSUN = 1-pN in [0,1)`,
      `tySunTension > 0` (strict twist), area law `tyAreaLawSUN_exp_strict`. SU(2)
      RECONCILIATION `tyBaseSUN_two_landed`: (TwistSystem 2).tyBaseSUN =
      TYAreaLaw.tyBaseOf (Z1/Z0) - the landed Z2 base is literally the N=2 shadow.
      0 sorry, standard axioms, guarded. REMAINING GAP to genuine SU(N): (a) build
      the SU(N) lattice Haar measure + twisted partition functions Z^[k], (b) derive
      hW + Z_le from RP, (c) continuum limit. THIS is the honest single-gate frontier.
- [ ] (C) Q6 crux `pairSum_le_expBound` - the KP tree-graph bound (Codex active;
      inductive Fernandez-Procacci route via `2001.00652`)
- [ ] character expansion of the Wilson weight (finite group) [~ sm-character-expansion]
- [ ] Peter-Weyl finite: character orthogonality for finite nonabelian G (SU(2)
      Fin-rep), the strong-coupling input
- [ ] strong-coupling area law from the character expansion (leading-rep dominance)

## Lane X - TAXONOMY & UNIFICATION (convergence / consolidation)
- [x] `massTaxonomy_functionals_pairwise_separated` (4 masses distinct)
- [x] NON-DEGENERACY (sm-taxonomy-nondegen 64fa14af): `MassTaxonomyNonDegeneracy.lean`
      - independent-realizability companion. `regulator_on_others_off`,
      `closure_on_others_off`, `aperture_on_others_off`, `turn_off_others_on`,
      bundled `massTaxonomy_nondegenerate`; 0 sorry, standard axioms, self-guarded.
      HONEST per-leg report: regulator+aperture cleanly two-sided; closure has no
      finite in-range zero (vanishes only as beta->inf, `z2GlueballMass_off_limit`);
      turn/bare has clean OFF but NO ON witness (quarkMassParameter pinned to 0).
      Scope: non-degeneracy/basis-like (independent domains), NOT a common-carrier
      claim. [integration: fixed the shim-vs-real z2GlueballMass=gap2 mismatch.]
- [x] `AllMassFromNullEdges` (+ guarded companion)
- [ ] extend the capstone: fold in NE-U4 closure gap + OS Hamiltonian gap +
      aperture=turn + ObstructionScalar as they harden (re-bundle each cycle)
- [ ] common-carrier separation: the four masses on ONE model family (if a
      non-artificial shared carrier exists; else the documented negative)

## Lane B - DIVISION ALGEBRA -> SM (where the mass structure lives)
- [x] su3Submonoid = SU(3); color triplet = fundamental; one-generation package;
      charge co-location verdict
- [ ] deepen the octonion->mass connection beyond co-location (the coupling test)
- [~] Spin(10) stabilizer draft (sm-spin10-audit 5bace153): TRANSITIVITY sorry
      AUDITED = FALSE as stated (OrthogonalPureSpinors admits the d=5 diagonal
      stratum, Chevalley), CLOSED with kernel-checked negative
      `not_evenCliffordGroup_transitive_on_krasnov_pairs` (4th verified negative
      of the run). ISO sorry = FALSE (complex-vs-compact real-form mismatch, dim
      24 vs 12). SELECTOR = underspecified (backward dir tractable next). Fixes in
      sm-spin10-audit-FINDINGS_5bace153.md. Original 3 draft sorries preserved.
- [ ] anomaly-from-Qop: extend beyond the U(1) linear/cubic sums

## Lane V - TRUST CONSOLIDATION (hardens the whole)
- [x] de-nativize E8-240 (sm-e8-denative d2e2dbb8): kernel-checked (no
      native_decide) 240 short-vector count + completeness in
      E8ShortVectorsNoNativeAristotle.lean - `short_vector_count_eq_240_structural_no_native`,
      `shortHammingE8Vector_count_eq_240_no_native`,
      `shortHammingE8VectorList_complete_no_native` all audit to
      [propext, Classical.choice, Quot.sound] (verified). Type-2 nodup via
      structural eightfold flatMap (no 3^8 enum). E8ShortVectors.lean trust note
      points citations at the kernel replacements. Genuine trust narrowing.
- [ ] reroute `StrongCouplingPolymerMap` off the FALSE
      `kp_convergence_bound_of_selfIncompatible` to the `_plain` version, then
      DELETE the 2 known-false downstream theorems (coordinate with Codex)
- [ ] axiom-guard the new lane-C flagships (SlabTransferGap, SlabSignRepGap,
      OSReconstruction, SummableDefectGap, AreaLawTransport)

## Lane L - LITERATURE (continuous feed, every ~3-4h)
- [x] 19 papers added (cluster expansion, RP, Chatterjee, Fradkin-Shenker,
      mass-origin, 2606.19362 the blueprint)
- [ ] mine 2606.19362 fully into a proof-strategy doc (Codex started
      `faizal-shabir-2606-19362-mining.md`)
- [ ] search + add: finite Peter-Weyl / nonabelian character orthogonality;
      lattice OS reconstruction; Ising gauge cluster-expansion follow-ups;
      hadron-mass decomposition follow-ups; each mined into a job
- [ ] `2603.06770` (mass without mass from SU(3) holonomy) - read + assess against
      the (C) closure obstruction

## Ops (every cycle / periodically)
- [ ] keep 10 slots full; harvest + semantic-review + integrate + commit
- [ ] harvest Codex's jobs too (shared tree; git-clean check first)
- [ ] red-team the latest headline every ~4-6h (3 verified negatives came from this)
- [ ] checkpoint report every ~8h + final report; honest distance-to-goal each time
- [ ] LEDGER heartbeat every cycle; lane-split with Codex in DISCUSSION
