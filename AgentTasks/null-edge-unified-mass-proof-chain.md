# Null-edge unified mass plan: proof chain (P1 -> P1.5 -> P2)

**No-build strategy/audit deliverable. Generated 2026-06-26.**

This report answers PROMPT Section B: the cleanest proof chain from P1 through
P1.5 to P2, with one entry per theorem. No Lean or build command was run; all
"Lean status" notes are read from the program's own source documents and must be
re-verified against the live repo before relying on them.

Companion: `AgentTasks/null-edge-unified-mass-grand-strategy-report.md`
(thesis, blockers, manuscript architecture, referee posture) and
`AgentTasks/null-edge-unified-mass-aristotle-next-jobs.md` (next jobs).

## Conventions assumed throughout

- Metric signature `(+,-,-,-)` (mostly minus).
- Visible Weyl spinor `psi : Fin 2 -> C`; null bispinor
  `psi psi^dagger = vecMulVec psi (star psi)`.
- Mass squared = `2 x 2` complex determinant of the summed Hermitian momentum.
- Pluecker bracket `spinorWedge psi phi = psi_0 phi_1 - psi_1 phi_0` lives in
  `Lambda^2 S ~= C` (the singlet), NOT in `Sym^2 S`.
- Super-Dirac architecture: `D_h = i sum_a c(alpha^a) nabla_a^A + Gamma_s Phi_H`,
  null support `ell_a`, dual-covector soldering `alpha^a`. Do not use
  `c(ell_a^flat) nabla_ell_a` (diagonal trace obstruction).
- Gradings kept separate: `Gamma_s` (spacetime chirality), `chi_E` (internal),
  `epsilon_form` (cochain degree).
- Claim-type labels: representation (R), reconstruction (Rec), structural
  theorem (S), prediction (P).
- Job-type: Lean proof job (L), strategy job (St), audit job (Au).

## Dependency overview

```text
T1 Pluecker obstruction map / mass identity        [P1, proved]
 |__ T2 massless iff rank-one / collinear          [P1, proved]
 |__ T3 celestial monopole/dipole + rest-frame     [P1, artifact]
 |__ (covariance, twistor: P1 wrappers)

T5 Yukawa checkerboard square                       [P1.5]
 |__ T6 rectangular singular-value theorem          [P1.5]  (feeds T5 flavor)
 |__ T7 Majorana/Takagi/seesaw stress test          [P1.5 appendix]

T8 Abelian Higgs link-stiffness identity            [P1.5]
 |__ T9 electroweak stabilizer ker/rank             [P1.5]  (uses T8 pattern)
       |__ T10 electroweak coefficient theorem      [P1.5 appendix, needs T9]
       |__ T11 FMS gauge-invariant link composite   [P1.5/later, needs T9]

T12 Higgs radial Hessian                            [P1.5 appendix]

T4 abstract mass-shell matching ker(-K(x)I+I(x)BdB) [bridge schema; P1.5->P2]

T13 dual-soldered commutator/symbol theorem         [P2]  (the missing seam)
 |__ T14 graded super-Dirac square                  [P2, needs T13]
       |__ T15 frame/tetrad postulate + frame audit [P2, needs T14]
       |__ T16 determinant branch-count/no-doubling [P2 audit, needs T13]
T17 moduli-rank prediction ledger                   [later, needs T5,T9,T10,T14]
T18 chirality/anomaly audit                          [P2/later]
```

The clean ordering is: finish P1 (promote wrappers) -> prove T5,T6,T8,T9 in
parallel (independent, all finite algebra) -> T10,T7,T12 (appendices) ->
T13 -> T14 -> T15,T16 -> T17,T18.

---

## T1. Pluecker obstruction map and mass identity

- Informal: for a finite family of null spinors `psi_i`, the invariant mass
  squared of `P = sum_i psi_i psi_i^dagger` equals the total pairwise Pluecker
  spread; equivalently `m^2 = |B_Pl(Psi)|^2` where
  `B_Pl(Psi) = (psi_i wedge psi_j)_{i<j}` is the rank-one-failure map.
- Formal shape:
  `theorem fin_bundle_plucker_mass_identity {n} (psi : Fin n -> CSpinor) :`
  `(finBundleMomentum psi).det = finPairwisePluckerMass psi`. Add the obstruction
  packaging `|B_Pl(Psi)|^2 = det(sum psi psi^dagger)`.
- Hypotheses/conventions: none beyond the spinor carrier; det-convention mass.
- Difficulty: low-medium (Cauchy-Binet / off-diagonal folding). Already done.
- Dependencies: none.
- Failure modes: `Lambda^2` vs `Sym^2` confusion; factor-of-two
  det-vs-trace normalization drift.
- Type: finite identity / kinematic reconstruction (Rec, with structural
  massless criterion).
- Aristotle: already proved (`PhysicsSM.Spinor.PluckerMass`). Remaining work is
  an **audit job** to add the explicit `B_Pl` obstruction-map packaging and
  confirm the `|B_Pl|^2 = det` wrapper. (Au, small)

## T2. Finite massless iff rank-one / projectively collinear

- Informal: the bundle is massless iff all spinors share one projective null
  direction (rank-one `Psi`).
- Formal shape:
  `theorem fin_bundle_mass_zero_iff_common_direction (psi) (base) (hbase) :`
  `(finBundleMomentum psi).det = 0 <-> exists c, forall i, psi i = c i . psi base`.
- Hypotheses: a chosen nonzero base spinor (`hbase`).
- Difficulty: low. Already done.
- Dependencies: T1.
- Failure modes: the all-zero bundle edge case; needs the nonzero base.
- Type: structural theorem (S).
- Aristotle: proved (`PhysicsSM.Spinor.PluckerMass`). No new job.

## T3. Celestial monopole/dipole form and rest-frame closure guardrail

- Informal: with unit directions `n_i` and weights `w_i`,
  `m^2 = (E^2 - |C|^2)/4`, `E = sum w_i`, `C = sum w_i n_i`; mass is the deficit
  of the momentum dipole below the energy monopole. Guardrail: `C = 0` is the
  rest frame (maximal mass `E^2/4`), NOT a massless or "no source" condition.
- Formal shape:
  `theorem pluckerMass_eq_energy_sq_sub_closureDefect_sq (w) (u) (hunit) :`
  `pairwiseAngularMass w u = momentMassSq w u`, plus
  `theorem closed_spinorFan_is_restFrame (... hclosed : closureVector w u = 0) :`
  `pairwiseAngularMass w u = energy w ^ 2 / 4`.
- Hypotheses: unit directions `normSq (u i) = 1`.
- Difficulty: low-medium. Proved but in a standalone package.
- Dependencies: T1 (same scalar, celestial parametrization).
- Failure modes: conflating closure `C = 0` with masslessness (explicitly the
  trap the guardrail theorem prevents).
- Type: kinematic identity (Rec) + structural guardrail (S).
- Aristotle: kernel-clean in the standalone artifact; **promotion/audit job**
  to bring it into the trusted `PhysicsSM` surface or cite as appendix. (Au/L,
  small)

## T4. Abstract mass-shell matching theorem

- Informal: for a null-edge kinetic operator `K` and a canonical obstruction
  `B`, a massive mode satisfies `K psi = B^dagger B psi`; with spectral
  decompositions the kernel of `A = -K (x) I + I (x) B^dagger B` is the diagonal
  sum over matching eigenvalues.
- Formal shape:
  `theorem mass_shell_matching (K BdB : ...) :`
  `LinearMap.ker (-(K (x) I) + (I (x) BdB)) = direct_sum over lambda of`
  `(eigenspace K lambda) (x) (eigenspace BdB lambda)`.
- Hypotheses: finite-dimensional `K`, `B^dagger B` self-adjoint/diagonalizable;
  `B` canonical; `K` forced by a null-edge operator.
- Difficulty: medium (finite spectral theorem; mostly Mathlib eigenspace
  algebra). The mathematics is standard; the content is the *labeling*.
- Dependencies: schema only; instantiated by T1 (Pluecker), T5/T6 (Yukawa),
  T9 (electroweak).
- Failure modes: vacuity if `B` not canonical (the central caveat); silent
  double-counting if `K` and `B^dagger B` are both "mass" (see grand-strategy
  D.6).
- Type: structural theorem schema (S); only nontrivial with a canonical `B`.
- Aristotle: **Lean proof job** (the abstract finite spectral lemma) plus an
  **audit job** confirming non-vacuity hypotheses are stated. (L, medium)

## T5. Yukawa checkerboard theorem

- Informal: null L/R propagation plus a constant chirality-flip `M` yields
  massive Dirac dispersion: from `i nabla_+ psi_L = M psi_R`,
  `i nabla_- psi_R = M^dagger psi_L` one gets `K_L psi_L = M M^dagger psi_L`,
  `K_R psi_R = M^dagger M psi_R`.
- Formal shape: over finite-dimensional `H_L`, `H_R`, with commuting null
  finite-difference operators `nabla_+`, `nabla_-` and `K_L = -nabla_- nabla_+`,
  `K_R = -nabla_+ nabla_-`:
  `theorem yukawa_checkerboard (M : H_R ->L[C] H_L) (hcommute ...) :`
  `K_L (psi_L) = (M comp M^dagger) (psi_L) /\ K_R (psi_R) = (M^dagger comp M) (psi_R)`.
- Hypotheses: `M` commutes with the spacetime differences; Hilbert inner product
  to define `M^dagger`; sign convention so `D^2 = -K + Phi^2` gives `K = Phi^2`.
- Difficulty: low-medium (finite algebra; no analysis). Highest-leverage P1.5
  theorem.
- Dependencies: feeds T4 (mass-shell), bridges to T14.
- Failure modes: the sign trap (`Phi` odd under the same `Gamma_s` flips
  `Phi^2`); confusing Dirac with Majorana mass (see T7).
- Type: operator reconstruction (Rec); structural if rank/texture is forced
  (it is not yet).
- Aristotle: **Lean proof job** (L, low-medium). Top priority.

## T6. Singular-value theorem for rectangular Yukawa maps

- Informal: for rectangular `M`, the positive spectra of `M M^dagger` and
  `M^dagger M` coincide; squared masses are the squared singular values; zero
  modes are kernel/dimension-mismatch remnants.
- Formal shape:
  `theorem rect_yukawa_pos_spec (M : H_R ->L[C] H_L) :`
  `posSpectrum (M comp M^dagger) = posSpectrum (M^dagger comp M)` (or the
  eigenvalue-multiset equality on positive eigenvalues).
- Hypotheses: finite-dimensional complex inner-product spaces.
- Difficulty: low (likely near-direct from Mathlib SVD / `ContinuousLinearMap`
  adjoint spectrum lemmas; check `Matrix` singular-value API first).
- Dependencies: feeds T5 (flavor masses), T7 (Majorana via Takagi).
- Failure modes: multiplicity bookkeeping at zero; treating CKM/PMNS mixing as
  emerging here (it appears only across incompatibly-diagonalized sectors).
- Type: structural theorem (S, standard linear algebra).
- Aristotle: **Lean proof job** (L, low). Pair with T5.

## T7. Majorana / Takagi / seesaw stress-test theorem

- Informal: a Majorana mass matrix is complex symmetric (Takagi factorization,
  not chirality-flip); squared masses still come from `M^dagger M`. Seesaw:
  with `M_seesaw = [[0, m_D],[m_D^T, M_R]]` and `M_R` large/invertible, the
  Schur complement gives `M_light ~ -m_D M_R^{-1} m_D^T`.
- Formal shape: two lemmas --
  `theorem takagi_majorana (M : ... ) (hsym : M = M^T) : exists U unitary, ...`
  and
  `theorem seesaw_schur (m_D M_R) (hinv : IsUnit M_R) :`
  `lightBlock = - m_D * M_R^{-1} * m_D^T` (as the Schur complement of the block
  matrix).
- Hypotheses: complex symmetric `M` (Takagi); invertible `M_R` (seesaw).
- Difficulty: medium (Takagi factorization may need building; Schur complement
  is more standard).
- Dependencies: T6 (positive spectra), appendix of P1.5.
- Failure modes: calling Majorana mass a "chirality-flip gap" (it is a
  charge-conjugation/self-pairing obstruction); overclaiming a neutrino model.
- Type: stress test / future model selection (Rec, explicitly not a result
  about real neutrinos).
- Aristotle: **Lean proof job** for the Schur-complement part (L, medium);
  Takagi may need an **audit/strategy** scoping first. Lower priority.

## T8. Abelian Higgs link-stiffness theorem

- Informal: the exact finite theorem is gauge-invariant link stiffness:
  `S_H(phi,U) = sum_e |U_e phi_t - phi_s|^2`, and with `|phi_v| = v`,
  `phi_v = v sigma_v`, exactly `S_H = v^2 sum_e |w_e - 1|^2` with the
  gauge-invariant mismatch `w_e = sigma_s^{-1} U_e sigma_t`. The mass term
  `v^2 epsilon^2 A_e^2` appears only after the small-holonomy expansion.
- Formal shape:
  `theorem abelian_higgs_link_stiffness (sigma : V -> U(1)) (U : E -> U(1)) :`
  `S_H = v^2 * sum_e complexAbsSq (w e - 1)` with `w e = (sigma (s e))^{-1} * U e * sigma (t e)`,
  plus a separate `gauge_invariance` lemma and a separate
  `small_holonomy_expansion` (Taylor) lemma labeled as interpretation.
- Hypotheses: `G = U(1)`; frozen modulus `|phi_v| = v`.
- Difficulty: low-medium (finite algebra + a Taylor bound for the expansion).
- Dependencies: pattern reused by T9; the FMS composite T11.
- Failure modes: presenting the expansion as the exact theorem; gauge-breaking
  wording.
- Type: exact gauge-invariant identity (S) for the stiffness; reconstruction
  (Rec) for the mass interpretation.
- Aristotle: **Lean proof job** for the exact identity + gauge invariance (L,
  low-medium); the expansion lemma can be a second target. Caveat: alone this is
  close to lattice gauge-Higgs theory (see grand-strategy E.2).

## T9. Electroweak stabilizer theorem (ker B_EW = u(1)_em, rank = 3)

- Informal: with `G = SU(2)_L x U(1)_Y` acting on `H in C^2`, `Q = T_3 + Y/2`,
  `Y(H) = 1`, `H_0 = (0, v/sqrt 2)`, the orbit map `B_EW(X) = rho(X) H_0` has
  `ker B_EW = span(Q) = u(1)_em` and `q(X) = |B_EW(X)|^2` has rank 3.
- Formal shape: stage 1 only --
  `theorem ew_stabilizer_kernel : LinearMap.ker B_EW = Submodule.span C {Q}` and
  `theorem ew_stabilizer_rank : LinearMap.rank q = 3` (or
  `FiniteDimensional.finrank` of the range of `B_EW` equals 3).
- Hypotheses: the SM electroweak group, Higgs doublet representation, `H_0`.
- Difficulty: medium (concrete finite representation-theory computation on
  `C^2`; mostly explicit matrix kernels).
- Dependencies: T8 (orbit/stiffness pattern); feeds T10, T11.
- Failure modes: presenting photon masslessness as a prediction (it is
  structural *given* the group and rep); basis/normalization slips in `Q`.
- Type: structural theorem (S), *given* SM group + Higgs rep; becomes prediction
  only if those are forced by null-edge axioms.
- Aristotle: **Lean proof job** (L, medium). High priority -- the most tractable
  nontrivial electroweak statement.

## T10. Electroweak coefficient theorem (m_W, m_Z, photon masslessness)

- Informal: evaluating `q` on `X = g(W^1 T_1 + W^2 T_2 + W^3 T_3) + g' B Y/2`
  gives `q = v^2/8 (g^2((W^1)^2+(W^2)^2) + (g W^3 - g' B)^2)`, hence
  `m_W = g v/2`, `m_Z = sqrt(g^2+g'^2) v/2`, `m_gamma = 0` in the physical
  basis.
- Formal shape:
  `theorem ew_mass_coefficients (g g' v : R) : massMatrix g g' v has eigenvalues`
  `{ (g v/2)^2 (double), ((g^2+g'^2) v^2/4), 0 }` (state as the quadratic form
  plus the basis change to `W^+`, `W^-`, `Z`, `A`).
- Hypotheses: a fixed kinetic-term normalization convention (must be documented).
- Difficulty: medium (eigenvalues of an explicit `4 x 4`/`2 x 2` form; the work
  is convention discipline).
- Dependencies: T9.
- Failure modes: silent normalization drift (the factor `v^2/8` and the
  `m_W = g v/2` vs `g v/sqrt 2` conventions); presenting as prediction.
- Type: reconstruction (Rec).
- Aristotle: **Lean proof job** (L, medium); appendix-level. Do after T9.

## T11. Gauge-invariant / FMS-style link composite target

- Informal: physical W/Z-like excitations should be gauge-invariant link
  composites, e.g. `O_e^a = H_s^dagger tau^a U_e H_t`, whose leading
  vacuum-expansion is the usual W/Z field.
- Formal shape: define `O_e^a`, prove gauge invariance
  `theorem fms_composite_gauge_invariant : O_e^a (gauge-transformed) = O_e^a`,
  then a leading-order expansion lemma matching the bare field.
- Hypotheses: the composite definition needs review (the schematic form is not
  yet confirmed correct).
- Difficulty: medium-hard (the exact composite and its expansion are open).
- Dependencies: T8, T9.
- Failure modes: the proposed `O_e^a` not actually reproducing W/Z at leading
  order; this is flagged "exact representation needs review."
- Type: structural theorem target (S), reconstruction of the FMS picture.
- Aristotle: **strategy/audit job first** (fix the correct composite), then a
  Lean proof job. (St -> L, medium-hard)

## T12. Higgs radial Hessian theorem

- Informal: `V(H) = lambda (H^dagger H - v^2/2)^2`, `H = (0, (v+h)/sqrt 2)`,
  gives `V = lambda v^2 h^2 + O(h^3)`, so `m_h^2 = 2 lambda v^2` (radial
  Hessian / stiffness of the condensate amplitude).
- Formal shape:
  `theorem higgs_radial_hessian (lambda v : R) :`
  `(deriv (deriv (fun h => V (vacuumPlus h)))) 0 = 4 * lambda * v^2`
  (the Hessian eigenvalue; with conventional kinetic normalization
  `m_h^2 = 2 lambda v^2`). State the potential expansion as the core lemma.
- Hypotheses: conventional scalar kinetic normalization (documented).
- Difficulty: low (one-variable Taylor expansion / second derivative).
- Dependencies: none (independent appendix).
- Failure modes: confusing the radial Hessian with a Pluecker spread (it is not
  one); normalization of the factor 2.
- Type: spectral gap / Hessian (Rec); the canonical example of "spectral gap"
  usage.
- Aristotle: **Lean proof job** (L, low). Appendix.

## T13. Dual-soldered commutator / symbol theorem

- Informal: the causal order-complex / null-edge operator has first-order symbol
  equal to the Dirac slash of the weighted null-edge momentum bundle:
  `[D, M_f] near x -> sum_y a_xy (f(y)-f(x)) gamma.p_xy`, squaring to the
  Pluecker mass. Uses dual-covector soldering `c(alpha^a)`, with
  `alpha^A = 1/4 dt + 3/4 n_A . dx` on the tetrahedral frame and
  `alpha^A(ell_B) = delta^A_B`.
- Formal shape:
  `theorem dual_soldered_symbol (...) : symbol (D_N) (xi) = c (sum_a xi(ell_a) alpha^a)`
  and the commutator form `[D_N, M_f] = sum_a c(alpha^a) (T_a - I) f`.
- Hypotheses: the simplex null-solder frame; consistent scaling of vectors and
  dual covectors (mixing `alpha` with scaled `L_A` is a convention error).
- Difficulty: hard (this is the named "missing seam" tying the static `gamma.P`
  theorem to the order-complex `d+delta` theorem).
- Dependencies: feeds T14, T16.
- Failure modes: reviving the diagonal operator `c(ell_a^flat) nabla_ell_a`
  (trace obstruction); scaling mismatch between `ell` and `alpha`.
- Type: reconstruction / structural (Rec/S); the key null-edge-earns-its-keep
  theorem.
- Aristotle: **Lean proof job**, finite/flat case first (L, hard). Precede with
  a strategy job to fix the finite target statement.

## T14. Graded super-Dirac square theorem

- Informal: under clean grading hypotheses,
  `D_h^2 = -D_N^2 + Phi_H^2 - i Gamma_s sum_a C_a [nabla_a^A, Phi_H]`, with
  `D_N^2 = Box_null + C_diamond + T_frame`, giving the schematic
  `D_h^2 = -K_h - C_diamond - T_frame + Phi_H^2 - i Gamma_s sum_a C_a [nabla_a, Phi_H]`.
- Formal shape:
  `theorem super_dirac_square (hGs2 : Gamma_s^2 = 1) (hGsC : {Gamma_s, C_a} = 0)`
  `(hGsNabla : [Gamma_s, nabla_a] = 0) (hGsPhi : [Gamma_s, Phi] = 0)`
  `(hCPhi : [C_a, Phi] = 0) : D_h^2 = -D_N^2 + Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi]`.
  Add the kinetic decomposition `D_N^2 = Box_null + C_diamond + T_frame` as a
  separate lemma.
- Hypotheses: the five commutation hypotheses above; separated gradings.
- Difficulty: medium-hard (careful operator algebra; the danger is the sign).
- Dependencies: T13 (symbol); feeds T15.
- Failure modes: THE sign trap -- `Phi` odd under the same `Gamma_s` flips to
  `-Phi^2`; conflating `chi_E`-oddness with `Gamma_s`-oddness; the `Box_null`
  mass-shell sign (`-Box_null + Phi^2 = 0` must give `p^2 = m^2`).
- Type: reconstruction / finite identity (Rec); "not new physics by itself."
- Aristotle: **Lean proof job** (L, medium-hard), with a paired **audit job**
  proving the sign flips when the grading hypothesis is negated (the audit value
  of the negative result).

## T15. Frame/tetrad postulate and frame-term audit

- Informal: `T_frame = sum_{a,b} C_a [nabla_a, C_b] nabla_b` vanishes under the
  finite tetrad postulate `[nabla_a, C_b] = 0`; if it fails, classify the defect
  (nonmetricity, curvature/holonomy, torsion-like, or smooth-limit
  contamination).
- Formal shape:
  `theorem frame_term_vanishes (htetrad : forall a b, [nabla_a, C_b] = 0) :`
  `T_frame = 0`, plus a classification note (each branch as a separate lemma or
  documented case).
- Hypotheses: the finite tetrad postulate / edge-transport compatibility.
- Difficulty: medium.
- Dependencies: T14.
- Failure modes: hiding a surviving `O(h^{-1})` frame term in the continuum
  limit (the key contamination mode); claiming the postulate when the frame
  varies but transport does not carry it.
- Type: consistency check / audit (S).
- Aristotle: **Lean proof job** for the vanishing lemma (L, medium) + an
  **audit job** for the defect classification (Au).

## T16. Determinant-level branch-count / no-doubling audit

- Informal: on a flat periodic patch, `D_+(q) = sum_a C_a (exp(i q_a)-1)/h`,
  symbol `p(q) = h^{-1} sum_a (exp(i q_a)-1) alpha^a`. Coefficient-zero doublers
  are ruled out by `p(q) = 0 iff q = 0`, but the physical test is
  `det D_+(q) = 0` (a nonzero null `p(q)` can still have a Clifford kernel).
- Formal shape:
  `theorem branch_count (h) : {q | (D_plus q).det = 0} = {0}` (or an explicit
  enumeration of real and complex branches with kernel dimensions and
  chirality), on the chosen periodic patch.
- Hypotheses: flat fixed decorated periodic graph; specific dimension.
- Difficulty: hard (determinant zero set over the torus; likely needs a concrete
  low-dimensional case first).
- Dependencies: T13.
- Failure modes: claiming no-doubling from coefficient-zero analysis alone
  (the explicit warning); missing complex/high-momentum branches.
- Type: consistency check / no-go audit (S).
- Aristotle: **Lean proof job** for a concrete low-dimensional patch (L, hard),
  preceded by a **strategy/audit job** to set up the determinant computation.

## T17. Moduli-rank prediction ledger

- Informal: define `F : M_finite -> M_EFT`; the model predicts iff
  `rank(dF) < dim M_EFT` at a generic point, or the image satisfies a nontrivial
  relation `R(theta_EFT) = 0` (codimension), beyond naive parameter counting.
- Formal shape: this is primarily a *ledger and analysis*, not a single theorem.
  A formalizable fragment: a finite parameter-count lemma
  `theorem moduli_count : dim M_finite (mod redundancy) = N` vs `dim M_EFT = K`,
  and, if a relation is found, `theorem coupling_relation : R(F theta) = 0`.
- Hypotheses: explicit enumeration of `M_finite` (graph, frame, soldering,
  edge weights, gauge group, reps, Higgs potential, Yukawas, Majorana blocks,
  spectral function, cutoff, counterterms) and `M_EFT` (`g_1,g_2,g_3,v,lambda,
  Y_u,Y_d,Y_e,Y_nu,M_R,CKM,PMNS,Lambda_QCD`, Wilson coefficients).
- Difficulty: hard conceptually (codimension, not just counting; field
  redefinitions can fake parameter deficits).
- Dependencies: T5, T9, T10, T14 (needs the reconstruction maps to define `F`).
- Failure modes: full-rank `F` (predicts nothing); mistaking a redundant
  coordinate deficit for a real constraint.
- Type: this is the prediction gate (P if a constraint is found; otherwise it
  certifies Rec).
- Aristotle: **strategy job** (build the ledger and the criterion) (St),
  followed by targeted Lean proof jobs if a candidate relation emerges.

## T18. Chirality / anomaly audit

- Informal: confirm the construction can host the observed chiral gauge
  structure with cancelled gauge anomalies, and that the doubling structure does
  not force a vector-like spectrum (Nielsen-Ninomiya evasion on the
  translation-non-invariant causal poset).
- Formal shape: a per-generation anomaly-sum vanishing check over SM
  hypercharges,
  `theorem sm_anomaly_cancellation : sum over multiplet of Y^3 = 0 /\ sum Y = 0 /\ ...`,
  plus an audit note on doubling/chirality.
- Hypotheses: SM one-generation hypercharge assignments.
- Difficulty: low for the numeric anomaly sums; medium-hard for the doubling
  argument.
- Dependencies: relates to T16 (doubling) and T18 reps.
- Failure modes: a model that only realizes vector-like fermions; missing mixed
  gauge-gravitational anomaly.
- Type: consistency check / structural (S).
- Aristotle: **Lean proof job** for the anomaly sums (L, low) + **audit job**
  for the chirality/doubling argument (Au).

---

## Recommended execution order (one line each)

1. T1/T2 audit packaging; T3 promotion (P1 close-out).
2. T5 + T6 in parallel (Yukawa core; finite algebra).
3. T8 + T9 in parallel (Higgs link stiffness; electroweak ker/rank).
4. T12, T10, T7 (appendices: Higgs Hessian, EW coefficients, seesaw).
5. T4 (abstract mass-shell schema) and T18 anomaly sums.
6. T13 (dual-soldered symbol; strategy then proof).
7. T14 (graded square) + paired sign audit.
8. T15, T16 (frame audit, branch count).
9. T11 (FMS composite) and T17 (moduli-rank ledger).

Parallelizable independent finite-algebra targets (best first wave): T5, T6, T8,
T9, T12. These need no continuum analysis and no shared dependencies.
