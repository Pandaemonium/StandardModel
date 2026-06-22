# Null-edge causal graph program: literature-grounded research plan

Companion to [`Null_Edge_Causal_Graph_Strengthened_Program.md`](Null_Edge_Causal_Graph_Strengthened_Program.md)
and the bibliography [`Null_Edge_Causal_Graph_Bibliography.md`](Null_Edge_Causal_Graph_Bibliography.md).
The expanded big-physics development note is
[`Null_Edge_Big_Physics_Inquiry_Development.md`](Null_Edge_Big_Physics_Inquiry_Development.md).

**Compiled:** 2026-06-21.
**Library:** Zotero collection "Null-Edge Causal Graph Program" (`9W59V3K9`) and the
Neo4j `coglab` graph (`Collection {collection_key:"9W59V3K9"}`). ~119 curated papers,
tagged `null-edge-program` plus per-pillar cluster tags. The reviewed Gemma4 harness
additions are also mirrored in Neo4j under `Collection {collection_key:"null-edge-lit"}`.
**Method note:** searches run through the `scholarly` MCP server (INSPIRE-HEP and
OpenAlex backends) and the staging-only Gemma4 literature harness; see
[`../Scripts/MCP_SERVERS.md`](../Scripts/MCP_SERVERS.md) and
[`../Scripts/lit/README.md`](../Scripts/lit/README.md). Gemma output is treated as
recall, not curation: only manually reviewed papers are promoted to Zotero/Neo4j.

## How to read this plan

For each pillar: **(i)** the anchor literature now in the library, **(ii)** what it
buys us, **(iii)** the concrete next Lean target (with proposed module/lemma names),
and **(iv)** the falsification hook. The discipline of the program is preserved:
finite, kernel-checkable algebra/combinatorics first; continuum physics stays an
explicitly conjectural layer.

The repo already has theorem islands to build on:
`PhysicsSM.Spinor.Checkerboard`, `PhysicsSM.Draft.SpinCoherentProjectorAristotle`,
`PhysicsSM.Draft.WeylCliffordBridgeAristotle`,
`PhysicsSM.Draft.SpinorHelicityRankOneAristotle`,
`PhysicsSM.Draft.SpinorHelicityQuaternionAristotle`, and the integrated
Gram-weighted flavor theorem cluster
`PhysicsSM.Draft.NullEdgeGramWeightedMassAristotle`.

## Falsification-aware priority map

The latest feedback is most useful as triage. It says: do not ask which big
problem the null-edge language can be made to resemble; ask where the finite
geometry could force a constraint that existing programs do not already force.

Current priority ranking:

1. **Cosmological constant / source visibility.** Highest leverage. The
   diamond source-visibility conjecture has a concrete collision with Sorkin's
   everpresent-Lambda causal-set program: both want a fluctuation scale of
   order `1 / sqrt(V)`, but the null-edge program may be able to supply a
   structural reason for mean-zero source visibility if coherent/internal
   vacuum bookkeeping is boundary-like while visible Plucker excitations are
   bulk sources. The new actionable bridge is spinor-network / twisted-
   geometry closure: treat a finite visible fan as a node with a moment-map
   closure vector, then test whether closure-satisfying internal bookkeeping
   pairs only with boundary data while closure defects feed diamond flux.
2. **Origin of mass / finite Dirac square root.** High leverage and now partly
   banked: the bundle Dirac-Plucker bridge is integrated. The remaining value
   is not the static square identity itself, but the causal super-Dirac
   decomposition in which Plucker mass, Higgs flips, and diamond curvature are
   blocks of one first-order operator.
3. **Bivector/BF simplicity defect and generation blindness.** Medium-high
   theorem value, but only after the representation table is corrected:
   Pluecker mass is a scalar in `Lambda^2 S`, self-dual curvature is in
   `Sym^2 S`, visible momentum is in `S tensor Sbar`, and the genuine common
   bivector arena is the Klein quadric in `Lambda^2 C^4`. The next useful
   claims are finite and falsifiable: pairwise masslessness as Klein-quadric /
   repeated-principal-spinor degeneracy, closure-constrained assembly for
   `n > 2`, spinor-network closure as a moment-map constraint, and generation
   blindness of the visible Plucker functional.
4. **Higher gauge / causal diamonds.** Medium-high theorem value because it has
   a decisive structural test: the trusted vertical and horizontal path-pair
   composition laws should satisfy the double-category interchange law. If
   they do, move to a crossed-module/fake-flatness wrapper. If not, record the
   obstruction.
5. **Reduced celestial concurrence.** Medium-high and cheap. The normalized
   mass ratio should be identified with qubit concurrence for a pure
   visible/internal bipartition, with monotonicity restricted to LOCC or local
   hidden-channel hypotheses. This is the same data-processing/relative-
   entropy spine as the ANEC/QNEC source-visibility audit, but applied to the
   visible/internal observer split rather than a diamond screen.
6. **CPT/two-sheet and order-complex Kähler-Dirac.** Medium. The finite branch
   projector theorems are real; the physical interpretation must be tested
   against Boyle-Deng Kähler-Dirac two-sheeting and standard Dirac projector
   caveats.
7. **Measurement, black holes, strong CP, confinement, and hierarchy.** Keep
   these as watch-list or interpretation layers until they produce a forcing
   theorem, numerical prediction, or falsification test. Otherwise they are
   at risk of being new vocabulary for known puzzles.

Rule of thumb: an extension is promoted only when it changes a computation or
constraint. It is demoted when it merely re-expresses an existing mystery.

**2026-06-21 falsification-map Zotero/Neo4j additions.** Added
Das-Nasiri-Yazdi everpresent-Lambda I `K5CFI3HI` (`2304.03819`),
everpresent-Lambda II `IHVSDGUC` (`2307.13743`), Bianconi network mass
`8ITHD4PG` (`2309.07851`), Boyle-Deng CPT-symmetric Kähler-Dirac fermions
`ZZCFUGH8` (`2511.11548`), and Boyle-Finn-Turok CPT-symmetric universe
`68R6TZ6X` (`1803.08928`).

**2026-06-21 strategy-loop source audit additions.** Added Engle-Livine-
Pereira-Rovelli `MQRXNUIX` (`0711.0146`) and Freidel-Krasnov `K8QAB5UD`
(`0708.1595`) as guardrails for the BF/simplicity-defect branch, plus
Catterall reduced Kahler-Dirac/chiral-fermion regularization `8RSBSW7Z`
(`10.21468/scipostphys.16.4.108`) as a guardrail for the order-complex
fermion/no-doubling branch.

**2026-06-21 Gemini triage additions.** Useful, bounded items to incorporate
next: Bahr-Belov volume simplicity (`1710.06195`) and Assanioussi-Bahr
Hopf-link volume simplicity (`2005.12004`) as spin-foam geometricity
guardrails; Barnum-Graydon-Wilce Euclidean Jordan composites (`1606.09331`) as
a cautious tensorial-autonomy guardrail for the Albert internal layer; the
energetic-causal-set edge-locality idea as a finite `edgeNeighbor_N` relation;
and Dirac-Bianconi graph neural networks as a simulation baseline, not a
theorem spine.

**2026-06-21 spinor-network/phase-space triage additions.** Source anchors to
review/add when the Zotero workflow next runs: Dupuis-Speziale-Tambornino
spinors/twistors in loop gravity (`1201.2120`) for twisted-geometry closure
and moment maps; Arkani-Hamed et al. positive Grassmannian (`1212.5605`) for
Pluecker-cell stratification; Kim-Lee massive ambitwistor zig-zag theory
(`2301.06203`) for the phase/symplectic target; Ruskai-Szarek-Werner qubit
CPTP maps (`quant-ph/0101003`) for Bloch-channel dynamics; Klyachko quantum
marginals (`quant-ph/0511102`) for hierarchy as a spectrum polytope; Faulkner-
Leigh-Parrikar-Wang ANEC (`1605.08072`) for the null-energy inequality audit;
and Dowker-Philpott-Sorkin swerves (`0810.5591`) as a phenomenology hazard for
stochastic flip dynamics.

**2026-06-21 relative-entropy triage update.** The ANEC/QNEC/source-visibility
branch and the proper-time/concurrence branch should be organized by one
monotonicity principle: relative entropy/data processing under a specified
observer or coarse-graining map. Faulkner-Leigh-Parrikar-Wang (`1605.08072`)
is the continuum template for deriving null-energy positivity from modular
Hamiltonians and relative entropy. The finite null-edge analogue should first
define the observer channel, then prove the appropriate monotonicity theorem.
This also clarifies what the LOCC restriction in the concurrence branch is
doing: it is not a separate ad hoc rule, but the channel class under which the
chosen reduced observable is monotone.

The same triage tightened several footholds. The Albert substrate already has
trusted Lean support under `PhysicsSM.Algebra.Jordan.H3O` and related modules;
the open generation gap is representation/Yukawa/mixing, not the existence of
`H_3(O)`. The visible reduced-density objects already exist in
`PhysicsSM.Draft.NullEdgeCelestialMixednessAristotle`, so Klyachko-style
moment-polytopes should constrain that object once a finite internal state
space is specified. Ruskai-Szarek-Werner's explicit affine Bloch-ball form for
qubit CPTP maps is the practical route for `celestialChannel_affineBloch`,
avoiding a premature general quantum-channel formalization.

## New master criterion: finite Dirac square root

The Dirac feedback sharpens the whole plan. The trusted and draft theorem
islands are mostly square-level objects:

```text
det(P)
sum_{i<j} |psi_i wedge psi_j|^2
4 det(rho_vis)
celestial dipole deficit
D^2
diamond holonomy / curvature defect
```

These should be treated as tests of a deeper first-order object, not as the
primitive ontology. The next central target is:

> Find a natural finite odd self-adjoint operator whose square produces the
> Plucker scalar mass block, the Higgs/Yukawa chirality-flip block, and the
> causal-diamond curvature block.

There are two levels.

At the static visible-momentum level, form

```text
P = sum_i psi_i psi_i^dagger = P_mu sigma^mu.
```

Then the Clifford square gives

```text
(gamma . P)^2 = (P_mu P^mu) I = det(P) I.
```

Composed with `PhysicsSM.Spinor.PluckerMass`, this gives the finite theorem
target:

```lean
diracSlash_bundleMomentum_sq_eq_pluckerMass
```

At the dynamical graph level, the target is a finite causal super-Dirac
operator

```text
D_{U,Phi} = d_U + delta_U + Phi + Phi^dagger
```

on the causal order complex, with \(U\) carrying edge/gauge transport and
\(\Phi\) the Higgs/Yukawa odd zero-form. The intended square is schematic:

```text
D_{U,Phi}^2 =
  covariant graph Laplacian
  + diamond curvature block
  + Higgs/Yukawa mass block
  + visible Plucker scalar block.
```

This reorders several existing ideas.

- The Higgs/Yukawa chirality flip is not a side mechanism; it is the
  off-diagonal mass entry in the doubled \(L\oplus R\) first-order operator.
- The l=1 celestial relaxation gap is a square-level diagnostic; the more
  fundamental object is the first-order flip generator whose eigenvalue is
  the mass.
- The complex Plucker amplitude should be retained before taking modulus:
  its modulus gives the pairwise mass spread, while its phase is the
  Pancharatnam/Berry target to compare with graph holonomy.
- The sign of the square root is a required two-sheet branch datum for any
  CPT, particle/antiparticle, or in/out interpretation.

The finite two-sheet branch algebra is now integrated in
`PhysicsSM.Draft.NullEdgeDiracTwoSheetCore`: any operator with
`D^2 = m^2 I` and `m != 0` has complementary projectors
`(1/2)(I plus/minus m^{-1}D)` carrying the `+m` and `-m` branches. The remaining
physics question is not whether the branches exist algebraically, but how a
causal graph, CPT convention, or scattering boundary condition should interpret
them.

The static bundle bridge is now also integrated in
`PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`: after extracting Weyl
coordinates from the trusted finite bundle momentum, the chiral slash squares
to `PhysicsSM.Spinor.PluckerMass.finPairwisePluckerMass`. The concrete
mass-shell branch specialization is integrated in
`PhysicsSM.Draft.NullEdgeDiracMassShellProjectorsCore`, proving idempotence,
orthogonality, and the `+m`/`-m` slash eigenvalue equations for the mass-shell
projectors.

**2026-06-21 branch/projector additions.** Added Foldy-Wouthuysen `NFMI3A99`
(`10.1103/physrev.78.29`), Newton-Wigner `74NU4C33`
(`10.1103/revmodphys.21.400`), and Thaller's *The Dirac Equation* `UI9343SX`
(`10.1007/978-3-662-02753-0`) to Zotero/Neo4j under `two-sheet-branch`.
These are guardrails for interpreting the algebraic branch projectors without
overclaiming a scattering or localization theory.

**Lean targets.**

- `hermitianTwoByTwo_det_eq_minkowski_norm` / Weyl-coordinate extraction;
- `diracSlash_sq_eq_minkowski_norm` integrated in
  `PhysicsSM.Draft.NullEdgeDiracSlashCore`;
- `chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass` integrated in
  `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`;
- concrete mass-shell branch projector laws integrated in
  `PhysicsSM.Draft.NullEdgeDiracMassShellProjectorsCore`;
- `leftRightDiracBlock_sq_eq_pluckerMass`;
- `higgsFlipBlock_sq_eq_yukawaMass`;
- Plucker/Bargmann phase algebra integrated in
  `PhysicsSM.Draft.NullEdgePluckerBargmannPhaseCore`, including the
  two-spinor Lagrange identity, normalized overlap complement, and finite
  Bargmann triple trace;
- scalar `d_U^2 = curvature` triangle identity integrated in
  `PhysicsSM.Draft.NullEdgeCovariantDifferentialCore`;
- `superDirac_sq_eq_laplacian_plus_curvature_plus_higgs`;
- `visibleScalarBlock_superDiracSq_eq_pluckerDet`.

**Finite spectral-triple audit.** The causal super-Dirac candidate should be
tested against finite almost-commutative geometry before we advertise it as a
geometry. The audit is useful even if it fails:

- grading and oddness of `D_{U,Phi}`;
- real structure / charge conjugation candidate;
- first-order condition and whether it forces Yukawa legality;
- orientability / volume-cycle surrogate on the order complex;
- inner fluctuation behavior for gauge and Higgs blocks;
- low-order spectral-action terms matching Plucker mass, diamond curvature,
  and Higgs/Yukawa blocks.

Lean/prose targets:

- `causalSuperDirac_has_realStructure`;
- `firstOrderCondition_fails_or_forces_YukawaLegality`;
- `higgsPhi_is_innerFluctuation_of_finiteDirac`;
- `spectralAction_lowOrderTerms_eq_plucker_plus_diamond`.

**Falsification.** If no natural finite odd self-adjoint operator exists whose
square simultaneously yields the Plucker scalar mass block, the diamond
curvature block, and the Higgs/Yukawa chirality-flip block, the program should
be treated as a set of related finite invariants rather than a unified physics
framework.

**2026-06-21 Zotero/Neo4j additions.** Added the concrete operator-spine
anchors that had previously been cited only as a broad prior-art row:
Quillen's superconnection paper `WNATKBT5`
(`10.1016/0040-9383(85)90047-3`), Chamseddine-Connes spectral action
`6WURA7MF` (`10.1007/s002200050126`), Ackermann-Tolksdorf generalized
Lichnerowicz formula `BQJAG9TR` (`hep-th/9503153`), and Lee's
superconnection/Connes-Lott gauge-Higgs paper `3Z543SD3`
(`hep-th/9602159`). These support the finite thesis that the Dirac-type
operator, not the quadratic invariant alone, should be treated as the geometry.

## New synthesis: celestial moments

The latest feedback sharpens the Plucker mass theorem by moving from spinors
to their celestial directions. A normalized visible null spinor determines a
point of `CP^1 ~= S^2`, and its rank-one Hermitian matrix has Bloch form

```text
psi_i psi_i^dagger = (w_i / 2) * (I + n_i . sigma).
```

For a finite bundle, the determinant mass should therefore be packaged as

```text
det(sum_i psi_i psi_i^dagger)
  = (1 / 4) * ((sum_i w_i)^2 - |sum_i w_i n_i|^2).
```

The monopole is energy, the dipole is spatial momentum, and mass is the
missing dipole. This gives the program a clean finite target:

```lean
rankOneHermitian_eq_weighted_spinProjector
fin_bundle_det_eq_bloch_minkowski_norm
finPairwisePluckerMassReal_eq_weighted_angular_variance
mass_zero_iff_bloch_dipole_saturates
```

The same sharpening changes the dynamics target. The flip-rate conjecture
should be phrased as an l=1 spectral-gap statement for the celestial direction
process. If `gamma_1` denotes the decay rate of the direction autocorrelation,
the convention-audited target is `m = hbar * gamma_1 / (2*c^2)`. In the 1+1
telegraph/checkerboard process, the autocorrelation decays as `exp(-2*nu*t)`,
so `gamma_1 = 2*nu` and `m = hbar*nu/c^2`.

Finally, the QGT/Berry idea becomes a concrete but still conjectural companion:
the real Fubini-Study/chordal part is the mass spread; the imaginary
Berry/Pancharatnam part should be tested against the existing Bargmann triple
trace theorem before any spin claim is promoted.

## New synthesis: reduced celestial mixedness

The same Plucker theorem should be repackaged as a partial-trace theorem.
Instead of treating the bundle index only as many classical null edges, let it
label unresolved internal/chiral/Higgs alternatives in a pure microscopic
state:

```text
|Psi> = sum_a v_a ⊗ e_a.
```

If the internal states `e_a` are orthonormal or decohered, the visible
observer sees

```text
P_vis = Tr_int |Psi><Psi| = sum_a v_a v_a^dagger.
```

Then the trusted Plucker identity says

```text
det(P_vis) = sum_{a<b} |v_a wedge v_b|^2.
```

After normalization `rho_vis = P_vis / Tr(P_vis)`, the target identity is

```text
m / E = 2 * sqrt(det(rho_vis))
      = sqrt(2 * (1 - Tr(rho_vis^2))).
```

Thus the mass ratio is the impurity, and for a pure
`visible celestial qubit tensor internal labels` state it is exactly the
concurrence of that bipartition. In units `c = 1`, this is also the proper-time rate
`d tau / dt`.

The caveat is part of the theorem statement: for nonorthogonal internal labels,
the partial trace contains overlaps `<e_b,e_a>`, so internal coherence can
change the visible determinant. The simple Plucker sum is the
orthonormal/decohered case.

## New synthesis: flavor as an internal Gram-overlap problem

The new feedback identifies the most native big-physics target for this
program: not "derive all Standard Model parameters" at once, but explain why
Yukawa masses, CKM/PMNS mixing, and CP violation should be controlled by one
internal quantum-geometric object.

The key formula is the nonorthogonal version of the reduced-state theorem.  If

```text
|Psi> = sum_a v_a tensor e_a
```

and `G_ab = <e_b,e_a>` is the internal Gram matrix, then the visible momentum is

```text
P_vis = M G M^dagger,
```

where `M` is the `2 x n` matrix of visible spinors.  The orthonormal case
`G = I` recovers the trusted Plucker sum.  The rank-one case, where all
internal labels are identical up to phase, forces `P_vis` to be rank one and
therefore determinant-massless.  Between these limits, the determinant should
be a weighted Plucker norm governed by the exterior-square Gram matrix
`Lambda^2 G`:

```text
det(M G M^dagger)
  =
sum_{a<b,c<d}
  (G_ac G_bd - G_ad G_bc)
  (v_a wedge v_b) conj(v_c wedge v_d).
```

This is the sharpened flavor hypothesis:

> light fermions correspond to internal labels that remain nearly indistinct to
> the visible celestial qubit; heavy fermions correspond to internal labels
> that are nearly orthogonal/distinguishable.

That relocates the hierarchy to internal geometry. It is not a solution unless
the internal layer, plausibly the Albert/Jordan `H_3(O)` side of the program,
produces non-generic overlaps. The useful comparison literature is
Froggatt-Nielsen flavor suppression and split-fermion overlap suppression, but
the null-edge version should try to derive the overlap from internal geometry
rather than assign a charge or extra-dimensional profile.

Mixing then has a clean mathematical home. Up-type and down-type sectors have
different internal Gram forms `G^u` and `G^d`; the CKM matrix is the unitary
misalignment between their diagonalizing bases. CP violation should be treated
as the imaginary/geometric companion to the real Plucker mixedness: the
Jarlskog invariant is the guardrail for any claim that an internal Berry or
Pancharatnam phase has become physical CP violation.

Quantum marginal and entanglement-polytope methods sharpen the hierarchy
question further. If the internal `H_3(O)` or triality layer restricts the
global pure states that can exist, it should restrict the spectra of the
visible reduced density matrices. Then mass ratios are not arbitrary
parameters but points or faces in a moment polytope. This is a good failure-
friendly target: compute the allowed reduced spectra first, and only then ask
whether observed Yukawa hierarchies can sit near a natural face or boundary.

**2026-06-21 Zotero/Neo4j additions.** Added Froggatt-Nielsen `AKMVETAK`
(`10.1016/0550-3213(79)90316-X`), Arkani-Hamed-Schmaltz `M9KJ7UCN`
(`10.1103/PhysRevD.61.033005`), and Jarlskog `D6TGC96N`
(`10.1103/PhysRevLett.55.1039`), tagged `flavor-gram-overlap`,
`yukawa-hierarchy`, and `cp-violation`.

**Lean targets.**

- `gramWeightedVisibleMomentum`;
- `visibleDet_eq_exteriorGram_weighted_plucker`;
- `rankOne_internalGram_implies_visible_massless`;
- `orthonormal_internalGram_recovers_plucker_sum`;
- `twoSectorGramBasisMisalignment` as a finite matrix wrapper for CKM/PMNS
  misalignment;
- `jarlskog_from_gram_commutator` as a later finite `3 x 3` invariant target;
- `visibleMassSpectrum_lies_in_internalMomentPolytope`;
- `generationEmbedding_constrains_reducedDensityEigenvalues`;
- `yukawaHierarchy_as_polytopeFaceDistance`;
- `albert_idempotent_gram_spectrum_pilot` as an oracle/prose computation
  before any trusted spectrum claim.

**Falsification.** This branch weakens sharply if natural `H_3(O)`/Albert
states have generic `O(1)` overlaps, if the hierarchy has to be inserted by
hand, or if the CKM/PMNS and CP data cannot be represented as basis
misalignment and a rephasing-invariant imaginary part of the same internal
Gram data.

## New synthesis: proper time as visible concurrence

The reduced-state formula also suggests a high-risk but coherent time target:

```text
d tau / dt = m / E = 2 * sqrt(det(rho_vis)).
```

For a pure state on `visible celestial qubit tensor internal labels`, this is
the two-qubit/qubit-subsystem concurrence formula
`C = 2 * sqrt(det(rho_vis))`, valid for any internal dimension because the
visible subsystem is a qubit. This makes proper-time rate an entanglement
resource of the visible/internal cut, not merely a generic mixedness slogan.

The safe monotonicity version is not a general data-processing claim for
arbitrary quantum channels. Concurrence monotonicity should be imported only
for LOCC or explicitly local hidden-channel classes on the visible/internal
bipartition. Entangling hidden dynamics can increase the concurrence, so any
proper-time arrow claim must name the allowed channel class. The surrounding
literature is thermal time and Page-Wootters relational time, but the
null-edge claim is narrower: proper time is read from a specific visible
two-state determinant/concurrence.

This is the same relative-entropy/data-processing audit that appears in the
ANEC/QNEC branch. The difference is the observer algebra: here the observer
forgets internal labels and sees a visible celestial qubit, while the gravity
branch restricts to a diamond screen/source algebra. Both monotonicity claims
must therefore start by naming the finite channel. Without that channel, the
word "monotone" is not yet a theorem target.

The dynamical version should be a qubit-channel statement on the celestial
Bloch ball. A finite CPTP channel has affine form

```text
r |-> T r + t
```

on the visible Bloch vector, and the mass ratio is
`sqrt(1 - |r|^2)`. The l=1 relaxation conjecture should therefore be stated
as a spectral property of the channel or its generator, not as an informal
flip count. A visible unitary preserves `|r|`; depolarizing or entangling
channels can increase mass/proper-time rate; LOCC/local hidden-channel
classes are the only safe place to import monotonicity.

**2026-06-21 Zotero/Neo4j additions.** Added Connes-Rovelli `I8XNBREW`
(`10.1088/0264-9381/11/12/007`) and Page-Wootters `EWXH3E6A`
(`10.1103/PhysRevD.27.2885`), tagged `proper-time-mixedness` and
`quantum-time`.

**Lean targets.**

- `properTimeRate_eq_two_sqrt_det_visibleDensity`;
- `normalized_mass_ratio_eq_concurrence`;
- `properTimeRate_zero_iff_visiblePure`;
- `celestialChannel_CPTP`;
- `celestialChannel_affineBloch`;
- `massRatio_afterChannel_eq_blochContraction`;
- `l1SpectralGap_bounds_massGenerationRate`;
- `partialCoherence_properTimeRate_monotone_for_real_overlap`, only when the
  channel is proven local on the visible/internal cut;
- `hiddenChannel_concurrence_nonincreasing_under_LOCC`, only for a precisely
  specified finite LOCC/coarse-graining map.

**Falsification.** Do not promote this if the concurrence identity requires
nonstandard normalization, if the monotonicity only holds after choosing ad hoc
channels, or if physically relevant hidden dynamics are generically entangling
on the visible/internal cut.

**2026-06-21 Gemma4/Zotero/Neo4j update.** Added the massive two-twistor papers
Fedoruk-Lukierski `1403.4127` (`HPP4FME8`) and Deguchi-Okano `1512.07740`
(`7V6SJB4F`). They support a sharper hidden-channel theorem target: the finite
internal label should carry a local `U(1)`/`SU(2)` basis freedom, and the visible
reduced density should be invariant under hidden-basis isometries. This is the
finite algebra now isolated in `PhysicsSM.Draft.NullEdgeDecoherenceChannelAristotle`.

**Lean targets.**

- `visibleDensity_from_orthonormal_internal_purification`;
- `det_visibleDensity_eq_internal_plucker_sum`;
- `visibleReducedDensity_hiddenMix2_eq_pairSpinorFamily`;
- `visibleDet_eq_exteriorGram_weighted_plucker`;
- `partialCoherenceMomentum_det_eq_overlap_factor_mul_plucker`;
- `normalized_mass_ratio_eq_two_sqrt_det_visibleDensity`;
- `mass_ratio_eq_sqrt_linear_entropy`;
- `massless_iff_visibleDensity_rank_one`;
- `restFrame_iff_visibleDensity_maximallyMixed`.

## New synthesis: rank-2 / rank-3 Jordan split

The generation feedback is useful because it tells us where not to look.
The visible Plucker/celestial mass layer is generation-blind: it sees a
bundle's visible null directions and their determinant mass, not whether the
fermion is first, second, or third generation. Generation labels should
therefore live in the internal label and Yukawa/flip-amplitude layer.

The algebraic refinement is:

```text
visible layer:
  H_2(C), the Jordan algebra of 2 x 2 complex Hermitian matrices
  determinant = Lorentzian norm
  rank-one idempotents = CP^1 celestial null directions

internal layer:
  H_3(O), the Albert algebra of 3 x 3 Hermitian octonionic matrices
  candidate home for family/generation labels and internal mixing data
```

This is a structural hypothesis, not a spectrum theorem. It may explain why
three is the right internal count if the Albert algebra is the correct
internal arena, but it does not yet determine charged-lepton/quark mass ratios
or CKM/PMNS mixing angles.

Lean foothold: the Albert side is already substantially trusted in the repo
through `PhysicsSM.Algebra.Jordan.H3O`, `H3OJordan`, trace-form modules, and
projective-geometry/stabilizer infrastructure. The next task is therefore not
to formalize the exceptional Jordan algebra from scratch, but to build a narrow
interface from that trusted substrate to generation labels, allowed internal
transitions, and reduced visible spectra.

**2026-06-21 Zotero/Neo4j additions.** Added Boyle `3ABEUB3K`
(`2006.16265`), Dubois-Violette-Todorov `SVNGPAFK` (`1806.09450`), and
Dubois-Violette-Todorov `FVH3WAAV` (`1808.08110`), tagged
`jordan-generations` and `albert-algebra`.

Barnum-Graydon-Wilce (`1606.09331`) gives the disciplined version of the
"tensorial autonomy" claim. Under specified composite-system axioms for
Euclidean Jordan algebras, exceptional Jordan summands do not participate in
ordinary non-signaling composite constructions with another nonclassical
factor. This supports treating `H_3(O)` as an internally rigid candidate
substrate, but it does not derive particle content. The branch is promoted
only after the exact axioms are stated and connected to a concrete
representation/Yukawa construction.

**Lean/prose targets.**

- `JordanVisibleMass`: source note or wrapper identifying the existing
  Hermitian momentum determinant with the norm form on `H_2(C)`.
- `generation_blind_visible_mass`: a finite statement that the Plucker/Bloch
  visible mass is independent of any auxiliary generation label.
- `AlbertGenerationHypothesis`: prose/source note only at first, recording
  `H_3(O)` as the internal generation-counting candidate and explicitly
  separating counting from spectra and mixing.
- `BGWCompositeObstructionNote`: source-backed statement of the composite
  axioms and the precise Albert-algebra obstruction, with physics claims kept
  conditional.

**Falsification.** A fourth generation, generation dependence forced by the
visible null geometry, or failure of the Albert layer to house the required
Standard Model family representation and mixing data would weaken or kill this
branch.

## New synthesis: the bivector/BF spine

The bivector line gives a useful integration principle only after a correction:
do not treat every wedge-like object as the same representation. The Plucker
mass theorem and the causal-diamond holonomy theorem should not be unrelated
islands, but their bridge must pass through an irrep-labeled interface.

```text
Lambda^2 S ~= C       : antisymmetric Plucker scalar / invariant mass bracket
Sym^2 S ~= Lambda^2_+ : self-dual curvature and Plebanski chiral B
S tensor Sbar         : Hermitian visible momentum
Lambda^2 C^4          : genuine Klein-quadric bivector arena
```

The real common geometry is the Klein quadric: a bivector in `Lambda^2 C^4`
is decomposable iff its Plucker coordinates satisfy the quadratic Klein
relation. In the two-edge spinor chart, the repeated-principal-spinor /
discriminant condition reduces to the same Plucker scalar that controls
`det(P)`.

The conservative version is:

```text
Bivector cochain B:
  pairwise mass sector = Klein/simplicity defect of a two-edge spinor fan
  gauge sector  = pairing of B with a diamond curvature defect
  gravity route = long-horizon Plebanski/BF interpretation, not yet a theorem
```

This is sharp because it turns "mass from pairwise null spread" and "curvature
from diamond disagreement" into one finite algebraic vocabulary without
mislabeling the spinor irreps. It also keeps the speculative part in the right
place: Plebanski gravity, Urbantke metric reconstruction, and simplicity
constraints are continuum/self-dual two-form technology; the repo should first
formalize the finite wrapper, then only later ask whether the continuum
interpretation survives. For `n > 2`, the assembly target is not "one simple
bivector" but pairwise simplicity plus a closure/Gauss-law constraint.

### Spinor-network closure as the source-visibility phase space

The missed connection with the highest leverage is spinor networks / twisted
geometries. In LQG fixed-graph phase space, spinors on half-edges reconstruct
holonomy-flux data, and closure is the moment-map constraint at a node. This
is almost exactly the finite architecture needed for the null-edge
source-visibility branch.

The correction is important: for a visible spinor fan with weights `w_i` and
celestial directions `n_i`, the closure vector

```text
C = sum_i w_i n_i
```

is the spatial momentum / dipole, while the Pluecker mass is the Casimir

```text
m^2 = (1/4) * ((sum_i w_i)^2 - |C|^2).
```

Thus `C = 0` is a rest-frame or polyhedral-closure condition, not by itself
"no matter." The source-visibility question should instead ask which closure
constraint is being tested: visible momentum closure, BF face closure
`sum_f B_f = 0`, or internal bookkeeping closure. The useful finite claim is
that closure defects are moment-map defects that can pair with a diamond
surface/curvature functional, while closure-satisfying internal bookkeeping is
a candidate for boundary-only contribution.

**Lean/prose targets.**

- `spinorFanClosureVector`: define `C = sum_i w_i n_i` from the visible fan.
- `pluckerMass_eq_energy_sq_sub_closureDefect_sq`: the celestial-moment identity
  expressed in spinor-network closure language.
- `closed_spinorFan_is_restFrame`: closure means zero spatial momentum for the
  visible fan, not zero mass.
- `closureDefect_pairing_eq_visibleMomentumFlux`: pair closure defects with a
  finite diamond/source functional.
- `bfClosure_satisfied_implies_boundaryDiamondPairing`: the separate BF-style
  source-visibility target for `sum_f B_f = 0`.

**Falsification.** This bridge fails if the spinor-network closure vector does
not align with the Pluecker/celestial convention, if BF closure and visible
momentum closure are conflated, or if closure-satisfying internal bookkeeping
still contributes a bulk diamond source.

**Reference anchors to add or cite defensively.**

- Plebanski/Krasnov self-dual two-form formulation: Krasnov `0904.0423`.
- Gravity/Yang-Mills/Higgs from enlarged Plebanski-type gauge group:
  Torres-Gomez-Krasnov `0911.3793`; Krasnov `1112.5097`; Smolin `0712.0977`.
- Modern spin-foam linear-simplicity guardrails now in the library:
  Engle-Livine-Pereira-Rovelli `MQRXNUIX` (`0711.0146`) and Freidel-Krasnov
  `K8QAB5UD` (`0708.1595`).
- Volume/geometricity guardrails for non-simplicial boundary graphs:
  Bahr-Belov `1710.06195` and Assanioussi-Bahr `2005.12004`.
- Spinor-network / twisted-geometry closure phase space:
  Dupuis-Speziale-Tambornino `1201.2120`.
- Energetic causal sets as the closest edge-momentum causal-set precedent:
  Cortes-Smolin `1308.2206`, `1307.6167`, `1407.0032`.
- Topological/Kahler-Dirac graph mass-gap precedent:
  Bianconi `2106.02929`, `2309.07851`.

**Claim boundary.** The finite novelty remains the kernel-checkable
Plucker/holonomy package and its graph-native synthesis. The continuum claim
"one two-form unifies gravity, Yang-Mills, and Higgs" has substantial prior
art in Krasnov/Smolin-style Plebanski programs. The null-edge program's
defensible angle is the finite causal-graph, Plucker-mass, and Lean-verified
version of the story.

**New Lean targets.**

- `NullEdgeBivector`: define the finite `B` wrapper whose local components are
  spinor wedges or diamond surface labels.
- `massless_iff_repeated_principal_spinor`: pairwise spinor theorem matching
  Plucker masslessness to the type-N/repeated-principal-spinor degeneracy.
- `mass_eq_squared_distance_from_klein_quadric`: a convention-audited quadratic
  identity measuring the pairwise off-quadric defect.
- `bivector_massDefect_eq_plucker`: identify the `B` simplicity/Gram defect
  with `finPairwisePluckerMassReal`.
- `pluckerMass_eq_energy_sq_sub_closureDefect_sq`: express the trusted
  celestial-moment theorem as a spinor-network moment-map identity.
- `closed_spinorFan_is_restFrame`: prevent the common mistake that closure
  means source-free or massless.
- `closure_violation_eq_diamond_source_defect`: finite Gauss-law target tying
  `sum_f B_f = 0` to source invisibility, and closure violation to a diamond
  defect.
- `hopfLinkVolumeSimplicity_functional`: define the finite boundary-graph
  volume-simplicity functional associated with Hopf links or crossing data.
- `hopfLinkVolumeSimplicity_invariant_under_boundary_moves`: prove the
  functionals are stable under the finite moves actually used by the null-edge
  boundary-graph API.
- `hopfLinkVolumeSimplicity_refines_pairwise_simplicity`: compare the
  Hopf-link volume/geometricity condition with the pairwise Pluecker
  simplicity defect, without claiming full Plebanski-sector isolation.
- `bivector_pairing_respects_diamond_composition`: show that the finite
  `B`-weighted diamond pairing is compatible with the already-proved
  vertical and horizontal path-pair composition laws.
- `topological_dirac_sq_eq_laplacian`: extend the cochain seed toward the
  Bianconi/Kahler-Dirac finite operator.
- `gapped_topological_dirac_sq`: for a finite matrix model, prove that adding
  a chiral mass term gives the expected algebraic square when the anticommutator
  hypotheses are explicit.

**Caveats.**

- In Lorentzian signature, self-dual two-forms are naturally complex; any
  Urbantke/Plebanski interpretation needs explicit reality conditions.
- The Plucker bracket is a scalar in `Lambda^2 S`, not a self-dual curvature
  spinor in `Sym^2 S`; theorem statements must preserve this distinction.
- For more than two visible null edges, the single-Klein-quadric picture must
  be replaced by pairwise Plucker data plus closure/assembly constraints.
- The QGT/Berry-curvature analogy is now a sharper finite target: the real
  part should match the Fubini-Study/chordal mass spread, while the imaginary
  part should be tested through Bargmann/Berry phase identities. The spin
  interpretation remains conjectural until this commutes with the graph
  holonomy layer.
- AHH massive spinor-helicity already owns the two-spinor on-shell mass
  identity. Our trusted theorem is the finite `n`-edge Cauchy-Binet bundle
  identity and its graph interpretation.

---

## Observable-relative nullity as a diagnostics layer

The graph-theoretic "null edges as kernels" note is useful, but it should be
integrated as an API/diagnostics layer rather than as a new physics pillar. The
safe definition is:

```text
Given a graph observable F, an edge or chain x is F-null when deleting,
contracting, quotienting, or gauge-normalizing x has zero effect on F.
Approximate F-nullity measures small effect on F.
```

This clarifies why no single definition of "null edge" should be expected.
The same edge can be connectivity-null, spectrally visible, quotient-null after
coarse-graining, gauge-null up to a vertex phase, or homology-null only as part
of a chain. That fits the program's existing theorem spine: Plucker mass is an
observable on null-spinor bundles, causal-diamond defects are observables on
path pairs, and order-complex cohomology sees chains rather than isolated
edges.

**2026-06-21 Zotero/Neo4j additions.** Added `UFHN99H4` (Spielman-Srivastava
effective-resistance sparsification), `N7T76U5H` (Schaub-Benson-Horn-Lippner-
Jadbabaie normalized Hodge 1-Laplacian), `33X7ZETB` (Roddenberry-Frantzen-
Schaub-Segarra Hodgelets), `FNP9V3DT` (Lange-Liu-Peyerimhoff-Post magnetic
Laplacians), `GNEARI9Q` (Fabila-Carrasco-Lledo-Post magnetic Laplacian
matrices), and `S78BASEN` (Kannan-Kumar-Pragada gain-graph Laplacians). All are
tagged `observable-relative-nullity` in the library/graph.

**Lean targets this suggests.**

- `quotient_incidence_internal_edge_eq_zero`: an edge internal to a quotient
  block maps to zero incidence in the quotient operator.
- `exact_one_cochain_has_trivial_cycle_holonomy`: an exact Abelian 1-cochain
  has trivial holonomy on every cycle.
- `tree_phase_assignment_is_gauge_trivial`: phases supported on a spanning
  tree can be removed by a vertex gauge transformation.
- `homology_null_boundary_chain`: a boundary chain is zero in homology, so
  topological nullity is naturally chainwise rather than edgewise.
- `laplacian_rankOne_modeShift`: first-order shift of a simple Laplacian
  eigenvalue under an edge update is the squared endpoint difference of the
  eigenmode.

**Claim boundary.** Connectivity and matroid nullity are standard graph theory,
and spectral/gauge/homology nullity have mature literatures. The project should
claim the observable-relative language as a useful organizing convention for
the null-edge causal graph program, not as a new discovery of those standard
notions.

---

## Pillar 1 — Mass as a Plucker spread of null spinors

**Literature (tags `mass-twistor`, `massive-spinor-helicity`).**
Modern massive spinor-helicity gives the cleanest target: Arkani-Hamed-Huang-Huang
*Scattering Amplitudes for All Masses and Spins* (`1709.04891`) writes a massive
momentum as a little-group-covariant pair of spinors — exactly the
`P^{AA'} = sum_i psi_i^A bar psi_i^{A'}` picture. The two-twistor mass models
(de Azcarraga `hep-th/0510161`, `1409.7169`; Bette `hep-th/0405166`; Bars single-twistor
`hep-th/0512091`; Albonico `2203.08087`; Kim `2102.07063`) realize mass as a two-twistor
invariant. Okano-Kugo's no-go theorem (`1606.01339`) bounds how far the n-twistor
description can be pushed. Dittmaier `hep-ph/9805445` and Ni `2501.09062` give the
Weyl-van der Waerden / helicity-chirality bookkeeping. The reviewed Gemma4 pass added
Fedoruk-Lukierski `1403.4127` and Deguchi-Okano `1512.07740`; these are especially
useful because they expose the two-twistor mass constraints, modified Penrose
incidence, and local `U(1)`/`SU(2)` gauge freedom in the massive spinning-particle
model.

**What it buys us.** A finite-dimensional linear-algebra keystone: the determinant
identity `det(sum_i psi_i psi_i^dagger) = sum_{i<j} |psi_i wedge psi_j|^2`, mass as
total pairwise Plucker spread, zero iff collinear. The celestial rewrite adds
a second, physically transparent form: mass is the deficit of the
direction-distribution dipole from its monopole bound.

**Original Lean target, now completed.** New trusted module
`PhysicsSM/Spinor/PluckerMass.lean`, building on
`SpinorHelicityRankOneAristotle`:
- `complex_plucker_mass_identity` : `det (∑ i, ψ i • (ψ i)ᴴ) = ∑ i j, ‖ψ i ∧ ψ j‖²` (i<j),
- `complex_plucker_mass_nonneg`,
- `complex_plucker_mass_eq_zero_iff_collinear`.
Then a matching lemma to the two-twistor mass invariant (`twistor_mass_eq_plucker`),
scoped to the spinor chart only — no full Penrose transform.

**Status update, 2026-06-21.** `PhysicsSM.Spinor.PluckerMass` now promotes the
finite determinant identity, the real-valued nonnegativity wrapper, and the
mass-zero/common-direction criterion to a trusted kernel-clean module. The
remaining Pillar 1 work is the celestial-moment wrapper and the
twistor-incidence interpretation layer. The hidden-channel update adds one more
finite theorem cluster: coherent alternatives have zero determinant mass,
decohered alternatives have Plucker mass, and partial hidden coherence scales that
mass by the hidden Gram determinant `1 - |k|^2`. The next theorem names are:

- `rankOneHermitian_eq_weighted_spinProjector`;
- `fin_bundle_det_eq_bloch_minkowski_norm`;
- `finPairwisePluckerMassReal_eq_weighted_angular_variance`;
- `mass_zero_iff_bloch_dipole_saturates`.
- `visibleReducedDensity_hiddenMix2_eq_pairSpinorFamily`;
- `partialCoherenceMomentum_det_eq_overlap_factor_mul_plucker`.

**Positive-Grassmannian / positroid classification angle.** The `2 x n`
spinor matrix defines a point of `Gr(2,n)` through its Pluecker coordinates.
For the complex null-edge program, the robust finite structure is first the
vanishing/sign/phase pattern of the minors; strict positivity only applies
after a real ordered or phase-gauge-fixed restriction. The useful scattering
analogy is therefore stratification, not immediate amplituhedra:

```text
vanishing minors       -> collinear / factorization / boundary degenerations
positive ordered cell  -> oriented real null-edge sector, if a phase gauge exists
remaining phases       -> Bargmann/Pancharatnam/holonomy data
```

Finite targets:

- `pluckerMass_zero_iff_boundaryStratum_collinear`;
- `pluckerMinorVanishingPattern_refines_nullEdgeDegeneration`;
- `positiveOrderedFan_has_nonnegative_pairwiseMass`;
- `positroidCell_refines_nullEdgeCausalOrdering`, only after an ordered real
  sector is defined.

**Falsification.** Failure of the determinant identity, failure of the
Bloch/angular-variance rewrite, or mismatch with the physical invariant-mass
convention `m^2 = det P`.

---

## Pillar 2 — Chirality flips and checkerboard / quantum-walk universality

**Literature (tags `checkerboard`, `quantum-walk`).**
The 1+1 core is well covered (Foster 4D checkerboard `1610.01142`, D'Ariano-Perinotti
Dirac QCA `1406.1021`, Earle `1012.1564`). For the higher-dimensional and universality
question: Bialynicki-Birula *Dirac and Weyl equations on a lattice as QCA*
(`hep-th/9304070`), Meyer QCA-to-lattice-gas (`quant-ph/9604003`), the Arrighi
honeycomb/curved-spacetime walks (`1803.01015`, `1505.07023`), Mlodinow-Brun
(`1802.03910`, `2006.08927`), Marquez-Martin fermion confinement via QW in 2D+1/3D+1
(`1612.08027`), Chandrashekar multi-dim Dirac walks, and Kauffman discrete physics
(`hep-th/9603202`). 't Hooft's deterministic CA (`1992`) anchors the
discrete-determinism angle. The Gemma4 review added Brun-Mlodinow `2503.05998`
(`SBQ24VRF`), useful as a current QCA/QED continuum-limit guardrail: locality,
symmetry, and positive-energy restriction are not simultaneously innocent
assumptions.

**What it buys us.** Concrete higher-dimensional walk constructions whose continuum
limits are Dirac/Weyl — the evidence base for the chirality-flip universality
conjecture (`m_eff = C * nu`).

Sharpened 2026-06-21 formulation: replace the raw proportionality slogan
with an l=1 spectral-gap statement. Effective mass should be calibrated by
the relaxation gap of the celestial direction process. If `gamma_1` is the
decay rate of the direction autocorrelation, the convention-audited target is
`m = hbar*gamma_1/(2*c^2)`. In the 1+1 telegraph/checkerboard process,
`gamma_1 = 2*nu`, hence `m = hbar*nu/c^2`.

The publishable near-term physics version is a 3+1D null-history theorem:
an isotropic null-edge spinor process with Higgs-legal chirality transitions
should coarse-grain to a Dirac propagator whose mass is the l=1 relaxation
gap of the celestial direction channel. This is much sharper than saying
"mass is a flip rate"; it says the mass is the dipole relaxation scale of the
visible celestial process, while higher multipoles are separate observables.

**Next steps.** (a) Promote the kernel-clean endpoint-kernel closed forms from
`PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle` into the trusted
checkerboard theorem surface after a semantic/documentation audit. (b) State
the universality conjecture precisely as a renewal/random-history statement
(Stage-2 paper, not yet Lean). (c) Numerical pilot:
isotropic null-edge flip ensemble dispersion relation (oracle script, justifies tests
not theorems).

The numerical pilot should also measure the l=1 relaxation spectrum and check
whether higher multipoles are invisible to the determinant mass while still
affecting other observables.

**Swerve/diffusion hazard.** Causal-set particle models already show that
microscopic discreteness can appear macroscopically as Lorentz-invariant
energy-momentum diffusion ("swerves"; Dowker-Philpott-Sorkin `0810.5591`).
Any stochastic version of the flip/l=1 relaxation process should therefore be
tested for residual diffusion. This is a high-value falsifier because it can
force the program to distinguish coherent unitary mass generation from
classical stochastic flipping.

Pilot/Lean-facing targets:

- `unitaryFlipProcess_has_zero_swerveDiffusion`;
- `decoheredFlipProcess_diffusionConstant_eq_l1Noise`;
- `swerveBound_constrains_hiddenChannelParameters`.

**Falsification.** Isotropic flip ensembles fail to flow to a Dirac dispersion, or
`m_eff` depends non-universally on microscopic flip distribution details.

Sharper falsification hook: the l=1 generator block fails to reconstruct the
Dirac operator, the factor-of-two convention cannot be made coherent, or
anisotropic microscopic generators couple l=1 to higher multipoles in a way
the mass observable can detect.

---

## Pillar 3 — Higgs as permission for chirality flips

**Status.** Literature search returned mostly phenomenology, not the conceptual target;
this pillar is best served by the repo's own Standard Model representation modules
(`PhysicsSM.StandardModel.Representations`, `.Bosons`, and the Furey electroweak packages)
rather than new external papers.

**Next Lean target.** Representation bookkeeping, not dynamics:
`yukawa_vertex_hypercharge_neutral` and `higgs_permits_left_right_flip` — prove the
hypercharge neutrality of a `Ψ_L ⊗ H → Ψ_R` vertex from existing charge assignments.

**Falsification.** Representation bookkeeping fails to match SM Yukawa quantum numbers.

---

## Pillar 4 — Twistor incidence as the continuum target

**Literature (tag `mass-twistor`).** The two-twistor models above plus Bars'
single-twistor multi-sector description (`hep-th/0512091`) give the incidence machinery.

**Next step.** A narrow source note / Lean draft `TwistorPluckerMass`: define only the
spinor part of the two-twistor invariant, record `SL(2,C)` / dotted-undotted / signature
conventions, and prove the reduction to `|psi_1 ∧ psi_2|^2`. Defer Penrose transform and
twistor cohomology.

**Status update, 2026-06-21.** `PhysicsSM.Spinor.TwistorPluckerMass`
now provides this narrow spinor-chart wrapper as trusted code, promoted from
the earlier draft after semantic review. It records the explicit convention
bridge between `m^2 = det(P)` and the common trace-pairing convention
`P^2 = 2 det(P)`. It is still only a chart-level mass wrapper, not a full
twistor-incidence formalization.

**Phase/symplectic target.** Kim-Lee massive ambitwistor zig-zag theory
(`2301.06203`) is the best current continuum neighbor for the complex
Pluecker/Bargmann phase. The finite phase theorem should not stop at "Berry-
like"; it should test whether the complex Pluecker amplitude and causal-
diamond holonomy form the finite shadow of a massive-twistor symplectic
structure. The related two-twistor spinning-particle models also warn that
local `U(1)`/`SU(2)` little-group redundancy should be handled as a quotient,
not as an extra observable.

Lean-facing targets:

- `pluckerBargmannPhase_gaugeCovariant_underDiamondTransport`;
- `diamondHolonomy_linearized_acts_on_pluckerPhase`;
- `twoTwistorSymplecticReduction_preserves_pluckerMass`;
- `hiddenIsometry_action_preserves_momentMap`;
- `pluckerMass_descends_to_hiddenQuotient`.

**Falsification.** The two-twistor mass invariant does not reduce to the Plucker term,
incidence reconstruction needs extra non-null structure, or the Pluecker phase
cannot be made compatible with little-group quotienting and diamond transport.

---

## Pillar 5 — Causal-diamond holonomy instead of plaquettes

**Literature (tags `causal-set-gauge`, `higher-gauge`, `spin-foam`, `discrete-gravity`).**
Sverdlov *Gauge Fields in Causal Set Theory* (`0807.2066`) and *Bosonic Fields*
(`0807.4709`) are the direct precedent for gauge fields on causal sets. Baez *Higher
Yang-Mills* (`hep-th/0206130`) and *Teleparallel Gravity as Higher Gauge Theory*
(`1204.4339`) supply the 2-connection language for the diamond/higher-gauge upgrade.
Spin foams (Baez intro `gr-qc/9905087`, Livine-Oriti causality `gr-qc/0210064`) and
Regge/simplicial dynamics (Dittrich `0807.2806`) are the adjacent discrete gauge-gravity
methods. The reviewed harness also added Zucchini `1112.2819` (`T73WQRFW`), which is
useful background for semistrict Lie-2-algebra, higher BF, and higher Chern-Simons
conventions before we attempt a non-Abelian 2-connection layer.

**Next Lean target.** Finite + Abelian first:
`PhysicsSM/Draft/CausalDiamondHolonomy.lean` — a finite DAG diamond, two paths, edge
labels in an abelian group, `path_holonomy` as edge-label product, vertex gauge
transformations, and `holonomy_defect_gauge_invariant` (endpoints fixed). Keep the
continuum Stokes statement as documented interpretation only.

**Status update, 2026-06-21.** The finite Abelian target has been promoted to
trusted code as `PhysicsSM.Gauge.CausalDiamondHolonomy`. The same trusted
module also proves the non-Abelian endpoint-conjugation law and class-function
gauge invariance. It now also contains a path-pair abstraction for glued
diamonds, with vertical and horizontal composition laws for the holonomy
defect and the Abelian multiplication specialization. Literature additions
from this pass: Wilson `QDII2KHM` in Neo4j, plus Zotero keys `AHK54SN9`,
`K9XTAJUM`, and `Z38RZX2Q` for higher-gauge/surface-holonomy context.

**New target after the categorical feedback.** The trusted vertical and
horizontal composition laws should be tested against the interchange law of a
double category:

```lean
pathPairDefect_interchange
```

If it holds, the next layer is a crossed-module 2-group wrapper with:

```lean
fakeFlatness_iff_surfaceTransport_welldefined
crossedModule_action_eq_endpoint_covariance
```

Here fake-flatness means the `H`-valued 2-cell label maps under
`partial : H -> G` to the ordinary path-pair defect, and the non-Abelian
endpoint covariance is the `G`-action on `H`. If interchange fails, that is a
useful obstruction: the causal-diamond API may be a weaker categorical object
rather than a 2-group.

**Falsification.** Path-comparison defects are not gauge invariant, the
vertical/horizontal laws fail interchange, or their continuum limit fails to
reproduce field strength.

---

## Pillar 6 — Gravity through null-horizon thermodynamics

**Literature (tag `spacetime-thermodynamics`).** Jacobson's seminal `gr-qc/9504004`
and entanglement-equilibrium `1505.04753`, Eling-Guedens-Jacobson `gr-qc/0602001`,
Padmanabhan `1312.3253`, Verlinde `1001.0785`, Wald-Noether-charge entropy
`gr-qc/9307038`, Bekenstein bound `quant-ph/0311049`, the null Raychaudhuri equation
(Bak `2312.17214`), and Swingle's *Spacetime from Entanglement* review
(`10.1146/annurev-conmatphys-033117-054219`).

**Big-question sharpening: cosmological-constant visibility.** The useful
claim is not that the program solves dark energy. It is that it gives a finite
place to ask what actually counts as a gravitational source. Standard QFT
bookkeeping assigns huge local vacuum-energy contributions; the null-edge
program should instead test whether finite causal-diamond observables see
coarse-grained null flux, screen entropy change, and holonomy/curvature
defect, rather than every microscopic internal fluctuation.

Define a finite diamond Clausius defect schematically as

```text
ClausiusDefect(D)
  = DeltaS(D) - HeatFlux(D) / Temperature(D)
    - alpha * <B_D, CurvatureDefect(D)>.
```

Here `B_D` is the finite bivector/screen cochain, and `CurvatureDefect(D)` is
the diamond holonomy defect already being formalized. The falsifiable question
is whether vacuum-like internal/coherent null structure is invisible or
boundary-renormalizing for this observable, while a visible decohered
Plucker-mass excitation produces nonzero flux/defect.

**2026-06-21 Zotero/Neo4j additions.** Added Weinberg `5A68ISBN`
(`10.1103/RevModPhys.61.1`), Burgess `TH8UZJ9K` (`1309.4133`),
Jacobson-Visser `2ZZTQS43` (`1812.01596`), Sorkin `G3FT8BXC`
(`0710.1675`), and Ahmed-Dodelson-Greene-Sorkin `ZP7E648U`
(`10.1103/PhysRevD.69.103523`), tagged `cosmological-constant`,
`vacuum-energy`, `causal-diamond-gravity`, and `everpresent-lambda`.
The falsification-map pass added Das-Nasiri-Yazdi everpresent-Lambda I
`K5CFI3HI` and II `IHVSDGUC`, which sharpen both the opportunity and the
observational threat: everpresent Lambda naturally fluctuates with sign and
rough Hubble-timescale correlation, but current CMB-facing fits make the
allowed amplitude much smaller than the naive late-acceleration value.

**Everpresent-Lambda decision threshold.** The null-edge contribution should
not be "another fluctuating Lambda model." Its distinctive test is a finite
source-visibility lemma:

```text
coherent/internal vacuum labels -> boundary or mean-zero diamond term
visible Plucker-mass excitations -> bulk diamond source term
residual stochastic source       -> Poisson-like sqrt(N) fluctuation
```

If this holds, the program supplies the structural mean-zero ingredient that
the causal-set/unimodular everpresent-Lambda story needs but does not by
itself derive. If it fails, the branch should be reclassified as ordinary
vacuum-energy bookkeeping rather than a dark-energy handle.

**Next steps (finite observables first).** Define, on a finite causal graph:
edge-crossing count for a screen, null momentum flux through a cut, and nested-diamond
coarse-graining. The continuum Clausius/Raychaudhuri derivation stays a long-horizon
conjecture (links to the Benincasa-Dowker curvature route in Pillar 8).

Concrete theorem/pilot targets:

- `DiamondScreenObservable`: finite screen, crossing edges, edge weights, and
  entropy proxy;
- `diamondNullFlux_additive_under_screen_union`;
- `diamondCurvaturePairing_gauge_invariant`;
- `diamondClausiusDefect_additive_under_gluing`;
- `coherentInternalVacuum_zero_visibleFlux`, for a specified finite coherent
  hidden-channel model;
- `coherentInternalVacuum_boundaryDiamondSource`, the stronger version needed
  for the everpresent-Lambda mean-zero claim;
- `pluckerMassExcitation_nonzero_diamondFlux`, first as an oracle/pilot
  calculation and only later as a theorem.
- `diamondSource_poisson_sqrtN_fluctuation`, first as a finite stochastic
  pilot, not trusted Lean.

**Null-energy inequality audit.** The continuum gravity branch should be
tested against ANEC/QNEC-style positivity before it is promoted. Faulkner-
Leigh-Parrikar-Wang (`1605.08072`) derive ANEC from modular Hamiltonians and
relative entropy for deformed half-spaces; this is a source-level warning that
null flux and entropy variation cannot have arbitrary signs. The finite
version should ask whether the diamond source obeys a discrete inequality of
the form

```text
null flux >= entropy second difference
```

for the class of coarse-grainings used by the program.

This should now be treated as the gravity-side version of the same
data-processing spine used in the proper-time/concurrence branch. The finite
diamond source observable is not mature until it specifies the observer
channel/coarse-graining, the relative-entropy-like functional, and the modular
or source term whose monotonicity produces the null-flux inequality.

Targets:

- `diamondRelativeEntropy_secondDifference_nonnegative`;
- `visiblePluckerFlux_satisfies_discreteANEC`;
- `sourceVisibility_implies_discreteQNEC`, only after the source observable
  and entropy proxy are defined.

**Falsification.** Edge-count entropy and momentum flux do not yield
Raychaudhuri/Clausius behavior under coarse-graining; finite diamond
observables count coherent vacuum bookkeeping as a volume source just as badly
as naive vacuum energy; visible Plucker-mass excitations fail to source the
defect; the discrete source violates the required null-energy/relative-entropy
positivity; or the residual stochastic source inherits the known everpresent-
Lambda amplitude tension without a new suppression or correlation mechanism.

---

## Pillar 7 — Fermions through order complexes and Kahler-Dirac structure

**Literature (tags `dirac-kahler`, `discrete-geometry`, `lattice-fermion`).**
Becher-Joos *Dirac-Kahler Equation and Fermions on the Lattice* (`10.1007/BF01614426`)
is the foundation; Kanamori (`hep-lat/0309120`) and Watterson (`0706.4385`) give the
chiral/flavour projection. The discretization toolkit: Desbrun *Discrete Exterior
Calculus* (`math/0508341`), Arnold-Falk-Winther *Finite Element Exterior Calculus*
(`10.1017/s0962492906210018`), Leopardi *Abstract Hodge-Dirac Operator and its Stable
Discretization* (`10.1137/15m1047684`). The doubling obstruction is Nielsen-Ninomiya
(`10.1016/0550-3213(82)90011-6`) with the Ginsparg-Wilson resolution (Luscher
`hep-lat/9802011`); Aoki lattice Weyl (`2402.09774`) for the chiral-surface angle.
Zenkin's extension of Nielsen-Ninomiya (`hep-lat/9803002`, Zotero `5245553T`)
is a useful guardrail because it reaches beyond translation-invariant local lattices.
The falsification-map pass adds Bianconi's network-mass paper `8ITHD4PG`
(`2309.07851`) and Boyle-Deng CPT-symmetric Kähler-Dirac fermions `ZZCFUGH8`
(`2511.11548`) as direct collision points for the order-complex and two-sheet
branches.

**What it buys us.** A graph-native home for graded fermionic data via `d + delta` on the
order complex, with a clear-eyed view of the doubling problem it must navigate.
Bianconi supplies a mature comparison target where a topological Dirac field
on a network gains mass through a gap equation; Boyle-Deng supplies a
two-sheet/KD-Majorana interpretation that prevents us from overclaiming our
finite branch-projector theorem. Dirac-Bianconi graph neural networks are the
computational offshoot to use for simulations: they are not evidence for the
physics, but they give a non-diffusive baseline to compare against ordinary
Laplacian/message-passing propagation on the same order complexes.

**Simulation target.** Compare topological-Dirac/DBGNN propagation with
Hodge-Laplacian diffusion and ordinary message passing on finite order
complexes. The diagnostic should be whether node/edge cochain signals preserve
Pluecker phase, mass-spread, and diamond-curvature observables better than the
diffusive baselines. If not, keep DBGNNs out of the core program.
finite plus/minus branch projectors as physics by themselves.

**Next Lean target.** Finite combinatorics:
`PhysicsSM/Draft/OrderComplex.lean` — chains in a finite poset, coboundary operator,
`coboundary_sq_eq_zero` (`d^2 = 0`); then `PhysicsSM/Draft/KahlerDiracGraph.lean` for the
`d + delta` operator. Becher-Joos and Leopardi fix the conventions.

**Falsification.** The graph cochain operator cannot reproduce a Weyl/Dirac continuum
sector without reintroducing hidden lattice structure (the Nielsen-Ninomiya
trap); the two-sheet branch cannot be made compatible with any finite
Kähler-Dirac reality condition; or the construction only imports Bianconi-style
network mass without adding a Plucker/Higgs/diamond block constraint.

---

## Pillar 8 — Causal-set foundations and discrete fields

**Literature (tag `causal-set`).** Foundations: Bombelli-Lee-Meyer-Sorkin
(`10.1103/PhysRevLett.59.521`), the Surya Living Review (`1903.11544`), Henson review
(`gr-qc/0601121`), Bombelli *Discreteness without symmetry breaking* (`gr-qc/0605006`),
Rideout-Sorkin sequential growth (`gr-qc/9904062`), Sorkin *Light, Links and Causal Sets*
(`0910.0673`). Fields/curvature: Benincasa-Dowker scalar curvature (`1001.2725`), Johnston
propagators (`0909.0944`, `1010.5514`), BDG continuum limit (`2007.13192`), spectral
dimension (Eichhorn `1311.2530`). The reviewed harness added Johnston's finite-density
correction paper `1411.2614` (`SBHC9STK`), the causal-set QFT review `2306.04800`
(`DFRSS56K`), and Dowker-Henson-Sorkin on Lorentz-invariant discreteness
`gr-qc/0311055` (`P9HI8CI4`).

**Role.** This is the ambient discrete-causal setting. The near-term, repo-faithful
contribution is the *finite* order-complex and diamond-holonomy machinery (Pillars 5, 7);
causal-set Dirac propagators and the d'Alembertian are Stage-4 continuum targets.

**Energetic-causal-set locality refinement.** The useful Gemini extraction is
an edge-neighborhood definition, not a claim that Lorentz-invariant causal
sets have naive finite point valency. Define `edgeNeighbor_N(a,b)` for causal
links `a` and `b` when the causal diamond between the relevant endpoints has
at most `N` intermediate events. In finite causal sets this gives an explicit
locality cutoff for link-based action sums and propagation kernels while
keeping the underlying incidence structure Lorentz-compatible in spirit.

**Lean/prose targets.**

- `edgeNeighborN_finite`: in a finite causal set, each edge has finitely many
  `N`-neighbors.
- `edgeNeighborN_subdiamond_mono`: the relation is stable under induced
  sub-diamonds or monotone in the cutoff parameter.
- `edgeLocalAction_depends_only_on_edgeNeighbors`: a design target for later
  finite action sums; do not use it as a physics theorem until the definition
  survives simulations.

**Falsification.** The cutoff becomes frame-dependent, unstable under the
coarse-grainings used by the program, or fails to localize the finite action
and propagation sums.

---

## Pillar 9 — Quantum measure, histories, and the Bell/Tsirelson question

**Literature (tag `quantum-measure`).** Sorkin *Quantum mechanics as quantum measure
theory* (`gr-qc/9401003`) and *Quantum dynamics without the wave function*
(`quant-ph/0610204`) formalize the decoherence-functional / quantum-measure view that the
program's "quantum measure over causal histories" needs. The curated Gemma4 pass added
Salgado's sum-rule identities `gr-qc/9903015` (`7QR6F4VK`), Dowker-Johnston-Surya
on extension and strong positivity `1007.2725` (`UC5T4NKA`), Bub on the Tsirelson
bound `1208.3744` (`AIHKUCDK`), and Dowker-Wilkes on strong positivity
`2011.06120` (`DRPQH4ME`).

**Next finite target.** Before claiming any Bell/Tsirelson physics, formalize the
finite event-algebra layer:

```lean
grade2_sum_rule
decoherenceFunctional_stronglyPositive_gram
strongPositivity_closed_under_tensor_product_finite
```

These are finite algebra targets only; the operational Tsirelson claim remains a
later theorem or falsification test.

**Falsification.** The decoherence functional cannot produce quantum correlations while
preserving operational no-signalling and strong positivity.

---

## Internal algebra layer (context, not spacetime)

**Literature (tag `internal-algebra`).** The internal layer is now sharper:
octonions/triality label internal transition rules and generation structure,
not observed spacetime coordinates. Boyle `2006.16265` and
Dubois-Violette-Todorov `1806.09450`, `1808.08110` anchor the exceptional
Jordan/Albert-algebra generation hypothesis. Singh *Trace dynamics and
division algebras* (`2009.05574`) remains a useful bridge between the internal
algebra and a quantum-gravity / unification narrative.

**Claim boundary.** `H_3(O)` is a candidate home for the family index and
mixing structure. It does not by itself explain the observed Yukawa spectra,
and it should not be used to alter the visible Plucker mass theorem.

The sharper triality hypothesis is that the three off-diagonal octonionic
entries of `H_3(O)` carry the three inequivalent Spin(8) eight-dimensional
representations, cyclically permuted by triality, and that the Standard Model
embedding breaks this triality in a way that organizes the family index. This
is a lead rather than a handle. It earns promotion only if the breaking
produces usable representation, Yukawa, and mixing data without ad hoc states.

---

## Sequenced work plan (literature-grounded)

**Stage 0 — conventions.** One convention table (signature, Pauli matrices,
spinor indices, twistor incidence, checkerboard corner weight, hypercharge)
plus an irrep table distinguishing:

```text
Lambda^2 S ~= C             -- antisymmetric Pluecker scalar / mass bracket
Sym^2 S ~= Lambda^2_+       -- self-dual curvature and Plebanski chiral B
S tensor Sbar               -- Hermitian momentum vector
Lambda^2 C^4                -- genuine Klein-quadric bivector arena
```

Done before any new trusted physics claim, especially before any statement
that uses the word "bivector" to connect mass, gauge, twistor, and spin-foam
layers.

**Stage 1 — finite Lean theorems (kernel-checkable, no analysis):**
1. Promote the kernel-clean checkerboard endpoint-kernel closed forms after
   semantic audit.
2. Promote `SpinCoherentProjectorAristotle` and `WeylCliffordBridgeAristotle`.
3. `PluckerMass.lean`: identity, nonnegativity wrapper, and collinearity are
   now trusted; add the celestial-moment wrapper and twistor chart matching
   (Pillar 1).
4. `CelestialPluckerMass`: prove the Bloch decomposition, angular-variance
   identity, and dipole-saturation masslessness criterion.
5. `ReducedCelestialMixedness`: prove the visible partial-trace theorem,
   determinant-as-concurrence identity, mass-ratio formula, LOCC/local-channel
   monotonicity boundary, and the orthonormal/decohered internal-label caveat.
   `NullEdgeDecoherenceChannelAristotle`: finish the hidden-basis isometry
   invariance and partial-coherence determinant theorem, using the two-twistor
   `U(1)`/`SU(2)` literature as the physical interpretation.
6. `GramWeightedVisibleMass`: the nonorthogonal internal-label theorem
   `det(M G M^dagger)` as an exterior-square-Gram weighted Plucker sum is now
   integrated, with the orthonormal, rank-one Gram, and two-state
   partial-coherence limits as corollaries.
7. `DiracSlashPluckerMass`: the static Weyl-block square-root algebra is
   integrated in `PhysicsSM.Draft.NullEdgeDiracSlashCore`; the trusted bundle
   theorem is composed with it in
   `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`; and the concrete
   mass-shell projectors are integrated in
   `PhysicsSM.Draft.NullEdgeDiracMassShellProjectorsCore`.
8. `ComplexPluckerAmplitude`: the first finite phase layer is integrated in
   `PhysicsSM.Draft.NullEdgePluckerBargmannPhaseCore`; next connect its
   Bargmann/Pancharatnam triple trace to the graph-native holonomy layer and
   compare phase conventions with the spinor-projector draft module.
9. `PositiveGrassmannianStrata`: classify finite null-edge bundles by
   Pluecker-minor vanishing patterns, and only then by positivity in a real
   ordered / phase-gauge-fixed sector.
10. `SpinorNetworkClosure`: express the celestial-moment theorem as the
   moment-map identity
   `m^2 = (E^2 - |closureDefect|^2) / 4`, and separate visible closure from
   BF face closure.
11. `JordanVisibleMass` and `generationBlindness`: source-backed wrappers
   saying visible determinant mass is the `H_2(C)` Jordan norm and is
   invariant under internal generation relabeling, so any family structure
   must enter through hidden labels, Gram overlaps, and Yukawa/flip amplitudes.
12. `QuantumMarginalHierarchy`: compute whether the internal state-space
   hypothesis constrains visible reduced-density eigenvalues before claiming
   a Yukawa hierarchy explanation.
13. `CelestialChannelDynamics`: formalize finite CPTP maps on the visible
   Bloch ball and state l=1 relaxation as a channel/generator spectral target.
14. `yukawa_vertex_hypercharge_neutral` (Pillar 3).
15. `PhysicsSM.Gauge.CausalDiamondHolonomy`: finite Abelian gauge invariance,
   non-Abelian endpoint covariance, and class-function invariance are now
   trusted; vertical and horizontal path-pair composition laws are now
   trusted; next prove `pathPairDefect_interchange`, then develop the
   crossed-module/fake-flatness wrapper (Pillar 5).
16. `DiamondSourceObservable`: finite screen entropy, null flux, curvature
   pairing, and a diamond Clausius-defect wrapper.
17. `DiscreteNullEnergyAudit`: after `DiamondSourceObservable`, state the
   finite ANEC/QNEC-style positivity tests.
18. `OrderComplex.lean`: `d^2 = 0` (Pillar 7).
19. `NullEdgeBivector`: draft a finite `B`-cochain wrapper tying Plucker
   mass defects to diamond surface pairings, with the continuum BF/Plebanski
   reading kept in comments/prose only. The cheap decisive targets are the
   pairwise Klein-quadric/discriminant wrapper
   `massless_iff_repeated_principal_spinor`, the simplicity-defect lemma
   `B wedge B = 0` iff the pairwise bundle is collinear iff Plucker mass
   vanishes, and the closure/assembly caveat for larger bundles. This is not
   yet the full Plebanski constraint package.
20. `HopfLinkVolumeSimplicity`: define boundary-graph Hopf-link volume
   functionals and compare them with closure plus pairwise Pluecker
   simplicity. This is a spin-foam geometricity guardrail, not a claim of full
   Plebanski-sector isolation.
21. `KahlerDiracGraph`: build the finite topological Dirac operator from the
   cochain seed, then prove `D^2 = Laplacian` and the algebraic chiral
   mass-gap square under explicit adjoint/anticommutation hypotheses.
22. `CausalSuperDirac`: the abstract off-diagonal block-square algebra is now
   integrated in `PhysicsSM.Draft.NullEdgeSuperDiracBlockCore`, and the
   finite superconnection expansion is integrated in
   `PhysicsSM.Draft.NullEdgeSuperconnectionExpansionCore`; the scalar
   covariant-differential curvature seed is integrated in
   `PhysicsSM.Draft.NullEdgeCovariantDifferentialCore`. Next define a
   graph-native `D_{U,Phi}=d_U+delta_U+Phi+Phi^dagger` candidate and map its
   curvature/Higgs/mass blocks to existing null-edge observables.
23. `SpectralTripleAudit`: test the graph-native `D_{U,Phi}` against finite
   real-structure, first-order-condition, inner-fluctuation, and low-order
   spectral-action checks.
24. `LeftRightFlipOperator`: connect the Higgs/Yukawa legality predicates to
   an off-diagonal mass block on doubled \(L\oplus R\) visible/internal data.
25. `SwerveDiffusionPilot`: distinguish coherent/unitary flip dynamics from
   decohered stochastic flipping by measuring residual momentum diffusion.
26. `EdgeNeighborLocality`: define the energetic-causal-set
   `edgeNeighbor_N` relation and prove its finite/monotonicity properties
   before using it in action or propagation claims.
27. `ObservableNullity`: package the quotient, exact-cochain, tree-gauge,
   boundary-chain, and rank-one spectral-nullity lemmas as diagnostics for
   finite graph observables.

**Stage 2 — finite-dimensional synthesis:** two-twistor/Plucker spinor-chart
matching is now drafted; next package the null-step projector + Plucker mass
theorems with the hidden-channel `SU(2)` basis-invariance theorem, the static
Dirac-slash square-root wrapper, and the bivector/BF wrapper. Then state the
doubled left/right chirality-flip operator precisely enough for Aristotle,
and write an expository paper tying Lean results to checkerboard /
Foster-Jacobson / energetic-causal-set / Plebanski-BF literature.

Celestial-moment addendum: Stage 2 should now package the null-step projector
and Plucker mass theorems with the Bloch/dipole wrapper, state the
chirality-flip universality conjecture as an l=1 spectral-gap theorem target,
and add the finite Berry/Pancharatnam triangle phase as the imaginary
companion to the real Fubini-Study mass spread.

Spinor-network addendum: Stage 2 should express the celestial-moment theorem
as a spinor-network moment-map identity. The closure vector is the visible
dipole/spatial momentum, so `C = 0` is a rest-frame condition; BF closure and
source invisibility are separate diamond-pairing targets.

Positive-Grassmannian addendum: Stage 2 should classify null-edge bundles by
Pluecker-minor vanishing patterns first. Positivity and positroid language are
allowed only for a real ordered or phase-gauge-fixed sector.

Reduced-channel addendum: Stage 2 should also package Higgs/chiral/internal
bookkeeping as a unitary dilation of a visible mass channel. In this language,
the stable mass observable is the determinant of the reduced visible celestial
state, while effective flip rates are derived descriptions of particular
checkerboard or quantum-walk limits.

Quantum-channel addendum: Stage 2 should define finite CPTP celestial channels
and their affine Bloch action. The l=1 relaxation conjecture should become a
spectral statement about a channel/generator, with unitary, depolarizing, and
LOCC/local hidden-channel cases kept separate.

Concurrence addendum: Stage 2 should promote
`normalized_mass_ratio_eq_concurrence` as the cheap physics-facing theorem.
The monotonicity story should be stated only for explicit finite LOCC or local
hidden-channel maps; entangling hidden dynamics are a falsifying boundary, not
a nuisance to hide.

Klein/interchange addendum: Stage 2 should prove the pairwise Klein-quadric
wrapper before broad BF claims, then test `pathPairDefect_interchange` before
asserting a crossed-module or 2-group diamond layer.

Hopf-link addendum: Stage 2 should add volume-simplicity only after the
pairwise `B wedge B = 0` / Pluecker simplicity wrapper exists. The Hopf-link
target is finite boundary-graph geometricity and volume reconstruction; do not
advertise it as a solved physical-sector projector.

Jordan addendum: Stage 2 should also add a source-backed note making the
rank-2/rank-3 split explicit: `H_2(C)` for visible determinant mass and
`H_3(O)` for the internal generation-counting hypothesis. The note should
state plainly that the hierarchy of Yukawa eigenvalues and CKM/PMNS mixing
remain open.

Quantum-marginal addendum: Stage 2 should treat hierarchy as an allowed-
spectra problem before it treats it as a parameter fit. If the internal
Albert/triality layer does real work, it should constrain visible reduced
density eigenvalues through a moment or entanglement polytope.

Flavor addendum: Stage 2 should package the Gram-weighted Plucker theorem as
the finite flavor spine. The paper-level claim should be deliberately narrow:
Yukawa hierarchy becomes an internal-overlap hierarchy; CKM/PMNS mixing becomes
misalignment of two internal Gram forms; CP violation is tested against a
Jarlskog-type invariant before any Berry/Pancharatnam interpretation is
claimed.

Diamond-source addendum: Stage 2 should introduce the causal-diamond
Clausius-defect observable as a finite diagnostic, not as a solved theory of
dark energy. The target claim is that the program can distinguish visible
screen-crossing Plucker-mass excitations from coherent/internal vacuum
bookkeeping in a finite model. Escalate this branch only if the finite
visibility lemma gives boundary or mean-zero coherent-vacuum contribution and
the residual stochastic source has a Poisson-like `sqrt(N)` pilot. If coherent
hidden labels source a bulk volume term, demote the branch immediately.

Edge-locality addendum: Stage 2 should define `edgeNeighbor_N` as an effective
link-neighborhood relation for finite causal sets. It may support local action
sums or propagation kernels only after the relation is shown to be stable
under the coarse-grainings used by the program.

Spectral-triple addendum: Stage 2 should make the finite real-structure and
first-order-condition audit part of the `CausalSuperDirac` design, even if the
result is a documented failure. A failure here is information about how causal
incidence differs from almost-commutative geometry.

Null-energy addendum: Stage 2/3 should define the finite diamond source before
attempting ANEC/QNEC analogues. Once defined, positivity of null flux versus
entropy second difference is a hard gate on the gravity branch.

**Stage 3 — numerical/probabilistic pilots (oracle scripts):** isotropic flip-ensemble
dispersion; effective-mass universality test; abelian diamond holonomy on random diamonds;
graph observables vs expected curvature/flux; QGT/Fubini-Study mass-spread and
Berry-curvature diagnostics on the celestial `CP^1` direction space; internal
Albert/Jordan Gram spectra for natural idempotent/coherent-state families;
vacuum-visibility tests comparing coherent hidden-channel fluctuations with
visible Plucker-mass excitations on nested diamonds; approximate
spectral/gauge/homology nullity signatures for coarse-graining pilots.
DBGNN/topological-Dirac pilots should compare non-diffusive cochain
propagation against ordinary Laplacian/message-passing baselines and score the
result by preservation of Pluecker phase, mass-spread, and diamond-curvature
observables.
Swerve pilots should measure residual energy-momentum diffusion in stochastic
flip models and compare it with the coherent/unitary case; unacceptable
diffusion demotes stochastic flip-rate dynamics.
Everpresent-Lambda pilots should measure the diamond-source autocorrelation
time and amplitude against the observational warning from `IHVSDGUC`: the
model must not simply inherit an unsuppressed CMB-era fluctuation problem.

Celestial dynamics addendum: the numerical pilots should measure both the
dispersion relation and the l=1 relaxation spectrum, but the square-root
target is a first-order flip generator on doubled \(L\oplus R\) data. The l=1
gap is the square-level diagnostic of that operator. Pilots should also test
whether higher celestial multipoles are invisible to determinant mass while
remaining visible to other observables.

**Stage 4 — long-horizon continuum:** causal-set Dirac propagator (Johnston route);
3+1D null-history Dirac universality from the first-order celestial flip
operator and its l=1 square-level diagnostic;
diamond-holonomy continuum limit; higher-gauge 2-connection over diamonds;
Plebanski/Urbantke reality-condition analysis for the bivector wrapper;
null-horizon Clausius derivation; cosmological-constant/vacuum-visibility
analysis through the diamond source observable; decoherence-functional
Bell/Tsirelson analysis.

## Falsification ledger

Maintained in the strengthened-program note; each pillar above lists its failure mode.
Every new conjecture must enter the ledger before it is promoted from prose to a Lean target.

## Using the tooling going forward

- **Search:** `python Scripts/mcp/mcp_call.py scholarly search-inspirehep --args '{"query":"...","limit":8}'`
  (avoid `search-papers` until a Semantic Scholar key is set — its SS leg 429s).
- **Add to Zotero:** `zotero_add_item_by_arxiv` / `zotero_add_item_by_doi` with
  `collection_key:"9W59V3K9"` when available, or at least the `null-edge-program`
  tag plus per-pillar tags.
- **Graph:** new papers are synced into the `coglab` Neo4j graph as `Paper` nodes linked
  `IN_COLLECTION` to `9W59V3K9` or the reviewed-harness collection `null-edge-lit`,
  with `AUTHORED_BY`/`HAS_TAG` and, for curated additions, `Concept`/`ABOUT` links per
  pillar. Query relevance with `read-cypher`.
