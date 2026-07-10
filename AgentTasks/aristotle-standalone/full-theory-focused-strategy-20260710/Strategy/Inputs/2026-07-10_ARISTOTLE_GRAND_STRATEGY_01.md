# GRAND STRATEGY REPORT: complete finite null-information theory

Grand strategist pass, 2026-07-10. Scope: read-only audit and strategy. No Lean
build was run and no proof was edited, per instruction. All claims about the Lean
corpus below were checked against the verbatim source of the 18 supplied
`PhysicsSM/*.lean` modules and the guard file; all headline declarations audited
carry only `[propext, Classical.choice, Quot.sound]`. A repo-wide scan of the
supplied modules found no `sorry`, `admit`, `axiom`, `opaque`, or
`native_decide`. The corpus is kernel-clean; the problem is architectural, not
hygienic.

Important structural fact used throughout: the supplied `PhysicsSM/*.lean` files
are a curated representative subset. Several (`PositiveHodgeDecoder`,
`DecoderChainHomotopy`, `ExactCheckerboardPathSum`, `FourChannelPathActionCapstone`,
`QuantitativeDiracWalkContinuum`) `import PhysicsSM.Draft.NullEdge.*` modules that
are NOT present in this tree (`KugoOjima`, `KreinPositiveSectorWitness`,
`PathSumSemantics`, `CheckerboardCarrierBridge`, `SuiteBCl4Walk`,
`CarrierDynamicsCapstone`, ...). Statements from those files are analyzed at the
signature level; their proofs were not re-checkable here.

---

## 1. Proposed declaration of the theory (one page)

The three Pro essays already contain an implicit single declaration; this pass
makes it explicit and minimal.

**Primitive data.** A finite null-information universe is a tuple
`U = (NullHist, Z, K, Q, J, Gamma, D, omega, N)`:

- `NullHist`: a category of finite causal histories. Objects are finite causal
  boundaries (finite sets of null-information registers); morphisms `K : B- -> B+`
  are finite decorated causal complexes carrying (a) a null incidence structure,
  (b) null spinor directions `psi_e in C^2` on elementary transmissions, (c)
  internal charge/chirality/strand labels, (d) transport `nabla_e` and turn
  gates, (e) soldering covectors `alpha^a` comparing neighboring null frames,
  (f) a constraint differential `Q_K`, (g) a Krein polarity `J_K`. Composition is
  gluing; disjoint union is tensor; orientation reversal is a dagger.
- `Z : NullHist -> Krein`: the finite path-sum amplitude functor,
  `Z(K) = exp(i*Lambda*N(K)) * sum_{h in Hist(K)} A_K(h)`, with
  `A_K(h) = T_{e_n} ... T_{e_1}` the ordered product of transport/turn/gauge/
  soldering gates. Superposition is the linear addition of morphism amplitudes,
  not an added postulate.
- `K` (prephysical space), `Q` (gauge/constraint differential, `Q^2 = 0`),
  `J` (fundamental Krein symmetry, `J^2 = 1`), `Gamma` (grading/chirality),
  `D` (first-order update / Dirac-type comparator), `omega` (state), `N` (event
  count operator).

**Minimal postulates.**
1. (Composition) `Z(K2 o K1) = Z(K2) Z(K1)`, `Z(K1 disjunion K2) = Z(K1) tensor Z(K2)`,
   `Z(K dagger) = Z(K)^#` (Krein adjoint).
2. (Gauge) physical descriptions are `ker Q / im Q`.
3. (Positivity) probabilities attach only to the `J`-positive sector.
4. (Dynamics) histories are weighted by a finite action `S` through `exp(iS)`;
   the update operator is `D` with `c(alpha)^2 = 0` on null directions.

**State space (physicalization).**
`Phys(K, Q, J) = (ker Q / im Q)_{J>0}`. Four questions separate cleanly:
representable <-> `K`; distinct-not-redundant <-> `ker Q/im Q`; carries
probability <-> `J`-positivity; dynamically stable <-> `spec Delta_phys`.

**Dynamics / observables.** Physical mass operator `Delta_phys = D^#D | Phys`.
Master mass of a class `[psi]`:
`m^2([psi]) = inf { <phi, D^#D phi>_J : phi in [psi], <phi,phi>_J = 1, positive }`.
This one definition yields the taxonomy massive (`m^2>0`), massless (`m^2=0`),
confined (positive representative set empty), unstable (form unbounded below).

**Empirical dictionary (which layer is which).**
- Mass invariant: `det P = sum_{i<j} |psi_i wedge psi_j|^2`, normalized to
  invariant mass squared (kinematic identity; DERIVED, in Lean).
- Special relativity: `rho = P/tr P`, `d(tau)/dt = 2 sqrt(det rho)`; mass shell is
  hyperbolic information geometry (CONJECTURAL geometry theorem).
- Gauge fields = reference-frame comparators; gauge group = decoder automorphism
  group (CONJECTURAL; only a Gram avatar in Lean).
- Higgs = a quantum reference-frame resource; gauge-boson mass = orbit Gram cost
  (finite avatar in Lean; electroweak content IMPORTED).
- Flavor CP = holonomy; three families = minimal nonzero-phase case + rank no-go
  (finite avatar + no-go in Lean).
- Gravity = soldering response; `Lambda` = conjugate to event count (CONJECTURAL).
- Continuum QFT / Lorentz covariance / Born rule = OPEN reconstruction layers.

This is a coherent, opinionated declaration. The rest of the report measures how
much of it the Lean corpus actually delivers.

---

## 2. Shortest credible primitive-to-observable chain already in Lean

There is exactly one end-to-end chain in which every arrow is a named,
kernel-clean declaration: the **mass-kinematics chain**. It does NOT pass
through `Q`, `J`, `Hodge`, or the decoder `D` (see the decisive verdict in
section 4).

1. Primitive null data.
   `MassNullDecomposition.mink`, `massSq` (Minkowski `(+,-,-,-)` on `Four`);
   null spinors as columns of `M : Matrix (Fin n) (Fin n) C`.
2. Composition into a state (Gram).
   `MassNullDecomposition.posSemidef_eq_null_edge_sum`
   (`P.PosSemidef -> exists M, P = M * M^H`), i.e. `P = sum_i psi_i psi_i^H`.
3. Observable = mass = pairwise disagreement (forward).
   `MassNullDecomposition.det_eq_null_edge_disagreement`
   (`P.det = (normSq (det M) : C)`); for 4-momenta
   `two_null_sum_massSq` gives `massSq(p+q) = 2 mink p q` for null `p,q`.
4. Converse ("all mass IS null-edge disagreement").
   `MassNullDecomposition.massive_eq_two_null`,
   `massSq_eq_two_null_disagreement` (every future-timelike `p` is a sum of two
   future-null momenta with `massSq p = 2 mink k1 k2`).
5. Information reading of the same invariant.
   `TwoEdgeMassConcurrence.four_mul_det_gram_eq_concurrence_sq`
   (`4 * (M M^H).det.re = concurrence M ^ 2`, `concurrence = 2*|det M|`),
   `det_gram_eq_zero_iff_concurrence_eq_zero` (massless iff collinear/unentangled).
6. Kinematics / causal support.
   `LowerOrderChannelCausality.principal_characteristic_iff_null`,
   `four_lowerOrder_channels_preserve_principal_symbol`,
   `groupSpeedSq_eq_one_sub_massRatio`, `massive_groupSpeedSq_lt_one`,
   `three_four_five_drift_witness` (front speed `c`, massive drift subluminal;
   3-4-5 rational witness).
7. Continuum avatar (IMPORTED / partial arrow).
   `QuantitativeDiracWalkContinuum.Ustep_taylor_remainder_bound` and
   `three_four_five_quantitative_witness` give a one-step `O(eps^2)` bound only;
   `massless_exact_control` is the exact `m=0` control. The many-step Dirac limit
   is MISSING (open).

Named exact anchors in this chain (all `[propext, Classical.choice, Quot.sound]`):
`two_null_sum_massSq`, `massive_eq_two_null`, `massSq_eq_two_null_disagreement`,
`posSemidef_eq_null_edge_sum`, `det_eq_null_edge_disagreement`,
`det_gram_eq_normSq_wedge`, `four_mul_det_gram_eq_concurrence_sq`,
`det_gram_eq_zero_iff_concurrence_eq_zero`, `principal_characteristic_iff_null`,
`groupSpeedSq_eq_one_sub_massRatio`, `massive_groupSpeedSq_lt_one`.

**Missing arrows on the shortest chain.** (a) Step 2->3 is stated on an
arbitrary `PosSemidef` matrix, not on a matrix produced by `Z` from a history:
the functor arrow `history -> P` does not exist in Lean. (b) The chain never
reaches `Phys = (ker Q/im Q)_{J>0}`; the decoder/positivity layer is a parallel
vignette on a different space (`W = EuclideanSpace C (Fin 3)`) that shares no
object with steps 1-6. (c) The continuum arrow (step 7) is a single Taylor step,
not a limit. These three are precisely the composition theorems below.

---

## 3. Top ten composition theorems (highest architecture-closure per proof)

Each is given as: shape, minimal hypotheses, witness, degenerate control, kill
condition, likely API, benchmark. Statement shapes are Lean-ready sketches
(pseudo-Lean), not final syntax.

### T1. Positive Hodge-Plucker mass theorem (KEYSTONE)
Unifies gauge quotient + positivity + mass; wires `PositiveHodgeDecoder` to
`MassNullDecomposition`.
- Shape:
  `theorem hodge_plucker (W)(Q J D : W ->L W) (hQ : Q o Q = 0)`
  `(hJ : J o J = 1) (hpos : PositiveSector Q J) (psi : W) (hcl : psi in ker Q) :`
  `IsMinOn (fun phi => (kreinForm J phi ((kreinAdjoint J D o D) phi)).re)`
  `{phi | phi - psi in range Q and (kreinForm J phi phi).re = 1} (someHarmonic) and`
  `Harmonic (someHarmonic) and`
  `(Q = 0 -> m2 psi = (P psi).det.re)`  -- free case equals Plucker determinant.
- Minimal hyp: finite dim; `J`-positive cohomology nonempty; `D` Krein-self-adjoint.
- Witness: existing `e2`, `mu=2` gives `m^2 = 4` (`spectralMassSquare_e2`,
  `positive_hodge_mass_witness`); free-case value from `path_sum_information_packet`
  witness `det = 4/25`.
- Degenerate control: `Jneg` -> positive representative set empty -> CONFINED
  branch (must be proved as "no minimizer / R_+ = empty"), matching
  `hodge_without_positivity_no_go`.
- Kill: minimizer not harmonic; or free case `!= det P`; or infimum not attained.
- API: `IsCompact.exists_isMinOn` on the `J`-unit sphere (finite dim closed+bounded),
  `LinearMap.IsSymmetric.rayleigh`/finite spectral theorem, `Matrix.PosSemidef`.
- Benchmark: S03 (+ S01 for the free case). Closes matrix rows Positivity, Mass,
  and half of Particles at once.

### T2. Amplitude-functor gluing (monoidal spine)
Gives the ontology its missing categorical law in Lean.
- Shape: with histories = `List Gate` and `Z (h) = (h.map T).prod`,
  `Z (h2 ++ h1) = Z h2 * Z h1`, `Z (par h1 h2) = kron (Z h1) (Z h2)`,
  `Z (reverse (dagger h)) = kreinAdjoint J (Z h)`.
- Minimal hyp: gates are matrices; `Krein` structure fixed.
- Witness: `ExactCheckerboardPathSum.pathAmplitude_eq_corner_power` already
  exhibits `Z` as an ordered product.
- Degenerate control: empty history -> `1`.
- Kill: non-associative gluing, or a gate class breaking multiplicativity, or
  dagger not matching Krein adjoint.
- API: `List.prod_append`, `Matrix.mul_kronecker_mul`, `Matrix.conjTranspose_*`.
- Benchmark: S05 extended to composition; S08.

### T3. Mass-at-turns equals det P (dynamics -> mass identification)
Collapses the "path-sum mass" and "Gram mass" into one object.
- Shape: for a two-history with corner weights,
  `(rhoDir a psi deltaKer).det.re = |a0|^2 |a1|^2 |wedge psi0 psi1|^2`
  `= (P [psi0,psi1]).det.re` up to the stated normalization.
- Minimal hyp: 2 histories, decohered (delta) kernel.
- Witness: `path_sum_information_packet` decohered branch + `witness_decohered_det`
  (`4/25`), matched to `det_eq_null_edge_disagreement`.
- Degenerate control: coherent (ones) kernel -> `det rho = 0` (massless/pure).
- Kill: the two determinants differ for some rational witness.
- API: existing `SuiteB_PathSum.*`, `Complex.sq_norm`, `Matrix.det_fin_two`.
- Benchmark: S05 + S01.

### T4. Gauge group as decoder automorphism (derive, not insert)
- Shape: `Aut(Q,J,D) = { U in krein-unitary | U*Q = Q*U and U*D = D*U }` is a
  `Subgroup`; for the 3-dim witness it is computed explicitly; the
  `GaugeMassGram.gaugeMassMatrix` is its orbit Gram and
  `diagonal_zero_iff_stabilizer` characterizes the massless directions.
- Minimal hyp: finite carrier, fixed `J`.
- Witness: `GaugeMassGram.witness_stabilizer_split`, `gauge_mass_gram_witness`.
- Degenerate control: unbroken generator -> zero Gram diagonal (stabilizer).
- Kill: automorphism group trivial, or does not contain the inserted generators.
- API: `Matrix.unitaryGroup`, `Subgroup.centralizer`, `LinearMap.ker`.
- Benchmark: S09.

### T5. Krein positivity -> normalized instrument (isolate the Born input)
- Shape: on `Phys`, `rho = P / tr P` is `PosSemidef` with `tr rho = 1`; a finite
  Kraus instrument on a factor leaves remote marginals fixed (no-disturbance),
  and the Born map `p(i) = <phi, Pi_i phi>_J` is the UNIQUE normalized rule given
  a stated hypothesis `H_Born`.
- Minimal hyp: `J`-positive class; TP channel.
- Witness: `FiniteNoSignaling.reset_no_signaling_witness`,
  `partialTraceB_applyLocalKrausB`.
- Degenerate control: non-TP channel changes the marginal (kill fixture).
- Kill: normalization fails, or the marginal signals.
- API: `lean-quantum` density/channel shapes; `Matrix.trace`, `PosSemidef`.
- Benchmark: S13 (+ new repeated-record fixture).

### T6. Causal Bloch geometry (program B)
- Shape: `{ P | P.PosDef and P.det = m^2 } ~= SL(2,C)/SU(2)` isometrically with
  geodesic distance = rapidity, and `d(tau)/dt = 2 sqrt(det rho)`.
- Minimal hyp: `2x2` PosDef, `det = m^2 > 0`.
- Witness: rational boost fixture (reuse `LowerOrderChannelCausality.k345`).
- Degenerate control: `det = 0` (null/massless) at the boundary, not interior.
- Kill: computed distance != rapidity on the witness.
- API: hyperbolic-space / `UpperHalfPlane` distance, `Matrix.PosDef`,
  `Complex.abs`; likely needs new metric-geometry glue.
- Benchmark: S07.

### T7. Channel-equivalence spectral invariance (program C)
- Shape: if `D'` is chain-homotopic to `D` (via `Q`), then `D` and `D'` have the
  SAME spectrum on `ker Q/im Q` (physical), with a counterexample on full
  prephysical spectrum.
- Minimal hyp: `IsChainMap Q D`, `ChainHomotopic Q D D'`.
- Witness: extend `DecoderChainHomotopy.positive_decoder_moduli_witness` (already:
  distinct decoders, same on `e2`) to "same spectrum on the quotient".
- Degenerate control: prephysical spectra differ (`shifted_ne_original`).
- Kill: physical spectra differ.
- API: `Matrix.IsHermitian.eigenvalues`, `LinearMap` spectrum on quotient.
- Benchmark: S03/S04.

### T8. Many-step Dirac continuum limit (the continuum arrow)
- Shape: `mnorm (Ustep k m eps ^ (floor (t/eps)) - exp(-i t (Hgen k m))) <= C*t*eps`
  on fixed momentum `k` and `|eps| <= 1`.
- Minimal hyp: fixed `k, m`; `t >= 0`.
- Witness: `three_four_five_quantitative_witness`; `massless_exact_control` (exact).
- Degenerate control: `m=0` closed form is exact (no error).
- Kill: no `O(eps)` convergence, or wrong limit generator.
- API: existing `mnorm_mul_le`, `mnorm_triangle`, `Ustep_taylor_remainder_bound`;
  telescoping/Trotter estimate; `Matrix.exp`.
- Benchmark: S05 tier V2.

### T9. SSB refinement limit (degeneracy -> order parameter)
- Shape: a family `H_N` with gap -> 0 selects a symmetry-broken ground direction
  in the limit; each finite `N` obeys the no-go
  `simple_eigenstate_density_invariant` as the negative control.
- Minimal hyp: commuting unitary symmetry; gap sequence -> 0.
- Witness: `FiniteSSBDegeneracyNoGo.degenerate_symmetry_breaking_witness`.
- Degenerate control: nondegenerate `H` -> invariant density (no breaking).
- Kill: gap stays open, or no clustering ground state.
- API: `Filter.Tendsto`, `Matrix.IsHermitian.eigenvalues`, spectral gap lemmas.
- Benchmark: S09 / S12.

### T10. Vacuum-shift / Lambda-count conjugacy (program D)
- Shape: on the finite event-count path sum,
  `(S, Lambda) |-> (S + c*N, Lambda - c)` leaves fixed-`N` normalized correlators
  and the transformed partition function invariant.
- Minimal hyp: additive event count `N`; `exp(iS)` weighting.
- Witness: reuse `phaseOf_add` (exp additivity) and
  `OneLoopDimensionalTransmutation.runningInv_cocycle` shape.
- Degenerate control: non-additive count breaks invariance.
- Kill: normalized correlators shift under the map.
- API: `Finset.sum`, `Complex.exp_add`, `Real.exp_add`.
- Benchmark: S12.

Priority order for maximum architecture closure: **T1, T3, T2** (they turn three
coexisting vignettes into one chain), then **T8** (continuum), then
**T4, T7, T5** (gauge/positivity), then T6/T9/T10 as reach.

---

## 4. Decisive verdict: does it compose or merely coexist?

**Verdict: as formalized, the four layers COEXIST; they do not compose in the
kernel.** The theory declaration in section 1 is coherent on paper, but the Lean
corpus realizes it as a set of independently-verified finite vignettes that share
vocabulary, not objects.

Evidence:

1. **No shared state space across layers.** The mass layer
   (`MassNullDecomposition`, `TwoEdgeMassConcurrence`) lives on
   `Fin 4 -> R` and `Matrix (Fin n) C`. The positivity/Hodge/decoder layer
   (`PositiveHodgeDecoder`, `DecoderChainHomotopy`) lives on
   `W = EuclideanSpace C (Fin 3)` with hand-built `Qmat, Jpos, e2` (defined in the
   NOT-supplied `KugoOjima`/`KreinPositiveSectorWitness`). The dynamics layer uses
   yet another space (`CheckerboardState`, `M2`). No declaration maps one onto
   another. `Phys = (ker Q/im Q)_{J>0}` and `det P` never meet.

2. **The master mass definition is absent.** The essays' keystone
   `m^2([psi]) = inf <phi, D^#D phi>_J` (Rayleigh over positive representatives,
   attainment, free case = Plucker) is NOT in the corpus. `PositiveHodgeDecoder`
   proves an eigenvalue fact `spectralMassSquare mu (e2) = mu^2 (e2)` for a
   HAND-CHOSEN diagonal decoder `massDecoderMat mu = diag(0,0,mu)`. The mass
   value `mu` is an input, not derived, and there is no minimization and no link
   to `det P`. Program items A-H of the moduli essay are all still open. This is
   T1.

3. **The action/dynamics layer is largely a wrapper.** `FourChannelAction` is a
   bare 4-field `structure` over `R`; `total = sum`, and "phase factorization" is
   just `exp` turning `+` into `*` (`phaseOf_add`). The capstone docstring itself
   states the abstract action components "remain free inputs" and that
   `checkerboard_channel_action_total` derives their carrier specialization "but
   not from a history." So the action is not yet a law that weights histories.

4. **The capstones are conjunctions, not compositions.**
   `four_channel_path_action_capstone` and the various `*_verdict` theorems are
   `And`-bundles whose conjuncts quantify over independent variables
   (`a, psi, act, d`, and per-conjunct `E k m`, `lam kap`, ...). A conjunction of
   true statements about unrelated witnesses is a navigation interface, not an
   end-to-end derivation. The `THEORY_COMPLETION_MATRIX` "composition test"
   (one executable chain primitive -> ... -> falsifier) is NOT met at Lean level.

5. **What DOES genuinely compose** is the narrow mass-kinematics chain of
   section 2 (forward + converse + concurrence + causal cone), which is real,
   exact, and clean. That is the true spine to build outward from, and T1/T3/T2
   are exactly the arrows that would attach the Hodge/decoder, dynamics, and
   ontology layers to it.

Bottom line: preserve the bold thesis, but state it as a program with one proven
spine (mass kinematics) and a small explicit set of composition theorems (T1-T3
first) whose absence is currently masked by conjunction-capstones.

---

## 5. Manuscript architecture (paradigm proposal, honest layering)

Use the claim calculus already in `AGENTS.md`: `T` (source theorem), `T|H`
(conditional), `M` (machine-verified finite), `C` (pre-registered conjecture with
kill), `[import]`, `[interp]`. Structure:

1. **Declaration first (section 1 of this report).** State `U`, the four
   postulates, `Phys`, and the master mass definition as the proposed ontology
   BEFORE any evidence. Mark every symbol with its current grade.
2. **The proven spine (M/T).** The mass-kinematics chain of section 2, presented
   as one figure with every arrow a named declaration. This is the paper's
   verified core; do not dilute it with the vignettes.
3. **Composition frontier (C, with exact statements).** Present T1-T10 as the
   named theorem program that would attach each remaining layer to the spine.
   Each gets: statement shape, witness, degenerate control, kill, benchmark.
   This replaces "future work" prose with mathematics.
4. **Coexisting finite vignettes (M).** Hodge decoder, four-channel action,
   gauge Gram, SSB no-go, tensor locality, one-loop transmutation, tetrahedral
   3+1, soldering action. Each stated with its HONEST boundary: what object it
   lives on, and that it is not yet wired to the spine (cite the missing arrow
   = one of T1-T10).
5. **Dictionary and imports (I, explicit).** One table: derived vs selected vs
   imported vs fitted for every physical identification. Born rule, absolute
   scale, continuum limit, tensor factorization, beta-function coefficient are
   all IMPORTED/OPEN and must be in the main text, not footnotes.
6. **Falsifiers (C).** Keep the manuscript's existing falsifier list; add the
   kill condition of each T1-T10.

Architecture figure (mark each arrow M / T|H / C / import / open):

```
null histories --[Z, open T2]--> gauge quotient ker Q/im Q --[open]-->
  J-positive sector --[open, Born import]--> physical state -->
  finite action exp(iS) --[wrapper, open T3]--> D^#D decoder -->
  spectral/Plucker observable --[proven M: det P chain]--> calibrated units
  --[import]--> known-physics benchmark --[C]--> falsifiable extrapolation
```

Only the `det P` observable segment is currently `M`. Everything upstream of it
is `open`/`import` until T1-T3 land. The manuscript must show this honestly and
still argue the paradigm: the single verified identity "all invariant mass IS
null-edge disagreement" is the anchor that makes the program non-vacuous.

---

## 6. Pre-registered prediction candidates

**Primary candidate (accept, parameter-free structural): universal lattice
dispersion curvature `-1/3`.** The finite walk gives, on the principal branch,
`omega^2 = k^2 + m^2 - (a^2/3) k^2 m^2 + O(a^4)` (manuscript eq.; the coefficient
`1/3` is forced by tetrahedral isotropy, `TetrahedralNullHistory.tetraDir_gram`
and `unit_step_isotropy_factor`, not fitted). Pre-registration: with a SINGLE
microscopic spacing `a` fixed by one massive species, EVERY massive species must
show the SAME relative curvature coefficient `1/3` (i.e. the `k^2 m^2` term is
`-(a^2/3)` universally). Kill condition: any species-dependent coefficient, or a
coefficient `!= 1/3` after fixing `a`, falsifies it. This is NOT fitted
flexibility (only one parameter `a` for all species) and NOT an imported law
(the `1/3` comes from the tetrahedral structure). Note explicitly, per the
manuscript, that the massless sector gives `omega = |k|` exactly, so gamma-ray
photon time-of-flight is NOT the relevant bound; importing a photon LIV bound
here would be spurious and must be rejected.

**Secondary candidate (accept, structural, non-numeric): confinement as
decodability failure.** The positive-Hodge taxonomy predicts that any
color-singlet-like carrier configuration has an EMPTY positive representative set
(`R_+ = empty`), i.e. no isolated positive one-particle state. Pre-registration:
exhibit the finite carrier for a colored configuration and prove `R_+ = empty`;
kill condition: a finite isolated positive colored state (nonempty `R_+` with
`m^2 > 0`) exists. This depends on T1 landing.

**Rejected as non-predictions.** (a) One-loop dimensional transmutation
"predicting" `Lambda`: `dynScale (runningGSq ...) = Lambda`
(`OneLoopDimensionalTransmutation.dynScale_running`) is an inverse-function
identity of an IMPORTED running law; it computes nothing new. (b) Any "match" of
a measured particle mass: masses enter as the decoder eigenvalue `mu` (input).
(c) Reproductions of standard Dirac/QFT formulas after importing the Hamiltonian:
V2, not V4.

---

## 7. Kill list: five most dangerous false closures

1. **Conjunction-capstone illusion.** `four_channel_path_action_capstone`,
   `*_verdict`, and the packet theorems are `And`-bundles over independent
   witnesses. Danger: reading them as "the theory composes end to end." They do
   not. Remedy: demand a single theorem with SHARED witnesses (T1-T3); until
   then label them explicitly as navigation interfaces, not derivations.

2. **Inserted decoder + free eigenvalue = "derived mass" is circular.**
   `massDecoderMat mu = diag(0,0,mu)` and `spectralMassSquare mu e2 = mu^2 e2`.
   The mass `mu` is chosen, not derived, and is disconnected from `det P`. Danger:
   claiming mass is an output. Remedy: T1 must derive `m^2` as an attained
   infimum from `Q, J, D` and the null-history data, and match the free case to
   `det P`.

3. **Positivity / Krein `J` / Born rule are hidden inputs.** The corpus's own
   `hodge_without_positivity_no_go` proves positivity is INDEPENDENT data: the
   same `Q`, Laplacian, and cohomology survive for `Jneg` with negative norm. So
   `J` and the positive-sector selection are postulated, and probability is not
   derived. Danger: "probability/quantum mechanics emerges from null
   information." Remedy: name `H_Born` as an explicit hypothesis (T5); do not
   present Born as derived.

4. **Continuum leap.** Only a one-step `O(eps^2)` bound exists
   (`Ustep_taylor_remainder_bound`); there is NO many-step Dirac propagator, no
   Lorentz covariance, no local net beyond a supplied `A (x) B`, no GR limit.
   Danger: any present-tense "recovers Dirac/QFT/Lorentz/general relativity."
   Remedy: T8; grade every continuum sentence `C`; the soldering
   `UnifiedActionVariation.gravity_equation`/`one_action_verdict` is a stationary
   point of a `2x2` real trace polynomial `S = 10 - 8w + 2w^2`, NOT a field
   equation - rename to "finite variational witness" to avoid false shape.

5. **Imported-law-as-derivation + supplied factorization for locality.**
   Dimensional transmutation re-derives `Lambda` from the running law that
   defines it (beta coefficient `b` imported); `FiniteNoSignaling` and
   `TwoRegionTensorMicrocausality` ASSUME the tensor factorization `A (x) B`
   rather than deriving it from graph/causal separation (both docstrings admit
   this). Danger: counting the algebra of an imported law, or of an assumed
   factorization, as emergent locality/scale. Remedy: grade both `I`; make the
   derivation of factorization from history disjointness an explicit open arrow
   (a prerequisite for T5).

---

## 8. Overnight order of attack (through 06:30)

Optimized for theorem + executable-benchmark closure. Run composition jobs in
parallel where independent; keep one audit job live.

- **Now - 01:30 (attach the spine).** Launch T1 (Positive Hodge-Plucker
  keystone) and T3 (turns = det P) in parallel; these are the two arrows that
  convert coexistence into composition. Simultaneously stand up benchmarks S01
  (V0/V1 det P / wedge / rank, exact rational) and S03 (V1 Hodge decoder,
  closed/exact/harmonic + Krein norm) as exact-arithmetic oracles so T1's witness
  is numerically regressed the moment it lands. Audit job: verify no
  conjunction-capstone is cited in the manuscript as end-to-end.
- **01:30 - 03:00 (functor + continuum).** Launch T2 (amplitude-functor gluing,
  reusing `pathAmplitude_eq_corner_power`) and T8 (many-step Dirac limit from the
  one-step bound). Benchmark S05 gains a composition test (product of gates) and
  a V2 convergence sweep with tolerance stated. Reuse `massless_exact_control` as
  the exact negative control.
- **03:00 - 04:30 (gauge / positivity / instrument).** Launch T4 (gauge =
  decoder automorphism, on the `GaugeMassGram` witness), T7 (channel-equivalence
  physical-spectrum invariance, extending `positive_decoder_moduli_witness`), and
  T5 (normalized instrument + named Born hypothesis, on the `FiniteNoSignaling`
  witness). Benchmarks S09, S04, S13.
- **04:30 - 06:00 (reach + the real composition deliverable).** Assemble the
  SINGLE end-to-end composition theorem that chains T1 + T3 + T2 through ONE
  shared witness (this is the `THEORY_COMPLETION_MATRIX` composition-test
  deliverable, and the one thing the manuscript most needs). If capacity remains,
  attempt T6 (Bloch geometry, S07) or T10 (vacuum-shift/Lambda, S12) as reach.
- **06:00 - 06:30 (freeze).** No new broad jobs. For every landed module: rerun
  `#print axioms` guard, grep for placeholders, confirm `[propext,
  Classical.choice, Quot.sound]` only, and confirm each new theorem's docstring
  does not outrun its type (especially T1's "mass derived" and T8's "continuum"
  language). Update `THEORY_COMPLETION_MATRIX`, `MANUSCRIPT_CLAIM_MATRIX`, and
  `SIMULATION_BENCHMARKS` in the same unit.

Success metric for the night: at least T1 and T3 landed and chained (mass layer
and decoder layer share one object and one witness), the continuum arrow (T8)
either landed or reduced to a single named analytic lemma, and every benchmark
row S01/S03/S05 carries an exact V0/V1 artifact. That converts the decisive
verdict in section 4 from "coexist" to "one proven composed chain plus a named,
killable frontier."
