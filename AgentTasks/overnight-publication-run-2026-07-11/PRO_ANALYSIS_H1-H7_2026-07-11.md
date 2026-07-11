# Pro analysis of the seven help-brief gates (received ~07:10 PDT 2026-07-11; banked 07:15)

Provenance: second external expert memo relayed by the user mid-run
(after the advisor response banked at ADVISOR_RESPONSE_H1-H7_2026-07-11.md).
Pro's own grading: "paper-proof complete, pending M transcription"; not run
through Lean. Citations partially from memory / with URLs; verify before
load-bearing use (two 2026 arXiv IDs in H3 need existence checks).

## Fable triage at receipt (cross-checked against the fleet state)

- H5 (reflection-resolved chiral indices nu_{eps,r}): PARTLY PRE-EMPTED by
  the f4879a60 harvest landed this hour: the sectorwise index REQUIRES
  [R, W] = 0, which the landed `reflR_comm_walk_iff` proves FAILS on
  exactly the four blind fields (every fixed singleton breaks reflection
  symmetry). So nu_{eps,r} is not defined where the 8-vs-4 discrimination
  is needed - same fate as the mirror-graded winding; the landed
  discriminator (fixed-leg self-adjointness = not-fixedSingleton) stands.
  HOWEVER Pro's Riesz-projection integer-trace homotopy argument is the
  right STABILITY template for the protected subfamily (where reflSym
  holds), and the transfer-contraction localization rung matches our
  verified rho = 1/2 exactly. Pro's own R-Gamma caveat is answered:
  [R, Gamma] = 0 landed (`reflR_comm_grade`). Next H5 job = stability +
  localization on the protected subfamily, NOT a new discriminator hunt.
- H2 (4x4 phase-defect polynomial): NEW and complementary to the in-flight
  window half-charge (cb16b747): a one-particle, Hamiltonian-level, exact
  closed-form spectral separation of equal-modulus fields, with
  gauge-covariant mismatch and exact zero-mode condition. Consistent with
  our landed observability ladder (constant phase conjugacy-removable;
  gradient visible at one particle). Verify algebra by sympy, then submit
  as a focused Lean job (my lane).
- H1 (H^0(End K, delta_Q) = End(H_Q(K)) + locality-bounded homotopies +
  disk decision procedure): sharpens the advisor's H1 quotient with the
  exact cohomology mechanism and an explicit contraction-data proof.
  Codex lane (job 82b10567 in flight); relay.
- H6: same exact-cone ladder as the advisor; Codex 63b8418b in flight;
  Pro adds the U_xy(theta) far-pair control - already in Codex's scope.
- H4: same cutoff-split as the advisor, PLUS the decisive caveat that
  CONVERGES with Codex's 07:02 finding: the live bounded-box constant
  grows exponentially (16(3K+M)^2 e^{3K+M}), so per Pro's own criterion
  the exponential growth - not the changing state spaces - is the real
  obstruction; Codex's refined-window-rate job (9ce69fe9) is the repair.
- H7 (Euler no-go: positive homogeneous action has no nonzero stationary
  point; p=0 flat control; "H7 requires H4 + RG dynamics"): CONVERGES
  with my exact result this hour (the landed R3's marginal direction is
  pure dilatation by Euler; homogeneity-breaking required). Merge into
  one small FiniteScaleSelectionNoGo target: Euler theorem + p=0 control
  + the exact 2-cycle dilatation line.
- H3 (retarget to resource lower bound; two 2026 citations): aligns with
  the run's R3 disposition; VERIFY arXiv 2601.15885 and 2607.05112 exist
  before citing anywhere.

Verbatim memo follows.

---

Yes. Several of the open gates can be narrowed substantially, and two admit short, exact finite proofs right now. I have not run these through your Lean verifier, so I would grade them **paper-proof complete, pending M transcription**. They are designed around the collaborator brief's requested theorem/witness/control/kill structure. The notation below uses the existing null-edge and positive-sector framework.

## What can be resolved now

| Gate                        | Proposed outcome                                                                     |
| --------------------------- | ------------------------------------------------------------------------------------ |
| H1, channel equivalence     | Canonical quotient by endomorphism cohomology and carrier automorphisms              |
| H2, Pluecker phase          | Exact 4x4 free-carrier phase-defect spectral theorem                                 |
| H4, changing lattice        | One quantitative theorem combining the existing bounded-box and Sobolev-tail results |
| H5, defect invariant        | Reflection-resolved chiral indices at +1 and -1                                      |
| H6, geometric CAR causality | Exact graph-distance cone for finite-depth even CAR circuits                         |
| H7, scale selection         | Strong finite scale-selection no-go; identifies the first viable escape              |
| H3, strict 3+1 walk         | Not resolved, but current evidence strongly favors a resource lower-bound theorem    |

# 1. H1: the physical channel quotient should be endomorphism cohomology

The decomposition ambiguity should not be settled by a scalar selector. There is already a canonical quotient available from the constraint complex.

Let the finite carrier include a nilpotent constraint operator Q^2 = 0 on a graded carrier K. Define the differential on carrier endomorphisms by

  delta_Q(X) = Q X - (-1)^{|X|} X Q.

For an even operator X, delta_Q(X) = 0 iff Q X = X Q, so X descends to physical cohomology. For an odd H, delta_Q(H) = Q H + H Q is a chain-homotopically trivial change of representative.

The correct algebra of physical carrier operators is therefore

  H^0(End K, delta_Q) = {X : QX = XQ} / {QH + HQ}.

## Finite physical-operator theorem

For a finite-dimensional complex over C,

  H^0(End K, delta_Q)  ~=  End(H_Q(K)).   [BOXED]

This is stronger than saying that null-homotopic operators act trivially. It says the quotient is EXACTLY the algebra of operators induced on physical cohomology. There is no arbitrary selector in the definition.

### Explicit proof

Choose contraction data i : H_Q -> K, p : K -> H_Q, s : K -> K such that

  p i = 1,  Q i = 0,  p Q = 0,  and  Q s + s Q = 1 - i p.

Write P = i p. Let X be an even chain map (X Q = Q X). Its physical action is Xhat = p X i. If Xhat = 0, then P X P = 0. Define H = s X + P X s. A direct computation gives

  Q H + H Q = X - P X P = X.

Conversely, if X = Q H + H Q, then p X i = 0. Thus

  p X i = 0  iff  exists H, X = Q H + H Q.

Surjectivity is equally explicit: every f in End(H_Q) lifts to X_f = i f p.

This is a very small Lean theorem.

## Proposed physical equivalence relation

Take the retained carrier datum to be

  C = (K, Q, J, Gamma, {A_X}_{X subset V}, D, gamma, nabla),

including: the full carrier operator D; the Krein form J; chirality Gamma; the local observable filtration A_X; Clifford soldering and transport; the gauge or BRST differential Q.

A channel refinement is an admissible tuple R = (X_A, X_C, X_T, X_E) with sum_i X_i = D^# D, where each X_i has the prescribed grade and locality type.

Require first that each proposed physical channel descends: delta_Q(X_i) = 0. If an individual X_i fails this condition, then only the total square is physical; that channel is a gauge- or scheme-dependent bookkeeping term.

Define R ~ R' when there is a full carrier automorphism U preserving (Q, J, Gamma, D), soldering, gauge action, and the locality filtration, together with local odd homotopies H_i, such that

  X_i' = U X_i U^{-1} + Q H_i + H_i Q.

The homotopies should satisfy the same finite-propagation bound as the corresponding channel. This prevents a highly nonlocal H_i from declaring two locally distinct decompositions equivalent.

On physical cohomology this becomes Xhat_i' = Uhat Xhat_i Uhat^{-1}. That is an operational equivalence: the channels produce the same physical responses after a legitimate relabeling of the entire carrier.

## The requested control triple

A nontrivially equivalent pair is immediate:

  X_A' = X_A + (QH + HQ),  X_C' = X_C - (QH + HQ),

with the other channels unchanged. The matrices differ and the total remains fixed, but the physical operators are identical.

An inequivalent pair is certified by any difference in a simultaneous-conjugacy invariant, such as Tr Xhat_i, det(lambda - Xhat_i), spec Xhat_i.

A justified invariant selector is therefore not a hand-chosen raw trace on the carrier. It is the physical compressed response Xhat_i = p X_i i or its positive-sector restriction.

If Q^# = Q, the ordinary physical expectation is also invariant: <psi, (QH + HQ) phi>_J = 0 for Q psi = Q phi = 0.

## Immediate test for the positive-complement disk

For every point in the rational open disk of positive complements, compute Xhat_i = P_phys^# J X_i P_phys. Then:

* if these compressed channel operators vary in trace or spectrum, the refinements are physically inequivalent;
* if they are all simultaneously conjugate, the disk collapses physically;
* if they agree globally but no bounded-range homotopy exists, they are globally equivalent but microscopically distinct.

This gives H1 a canonical quotient and a finite decision procedure.

Suggested file: ChannelPhysicalEquivalence.lean

Core Lean target:

  induced_eq_zero_iff_nullHomotopic
    (hQ2 : Q * Q = 0)
    (hContract : Q * s + s * Q = 1 - i * p)
    (hChain : X * Q = Q * X) :
    p * X * i = 0 iff exists H, X = Q * H + H * Q

This would resolve the mathematical part of H1. What remains is to choose the exact locality-preserving automorphism group, which is physical input rather than a missing selector.

# 2. H2: an exact free-carrier Pluecker-phase observable

There is a very small finite construction showing that the phase is not merely a reparametrized mass.

Recall B_z = [[0, z], [zbar, 0]], B_z^2 = |z|^2 I. Let Sigma = [[1, 0], [0, -1]], Sigma B_z = -B_z Sigma.

Consider two neighboring carrier sites with equal local Pluecker modulus, |z_L| = |z_R| = m, coupled by the standard chirality-sensitive kinetic edge t Sigma:

  H(z_L, z_R; t) = [[B_{z_L}, t Sigma], [t Sigma, B_{z_R}]]   (4x4 blocks 2x2)

This is Hermitian and contains no quartic interaction.

## Phase-defect polynomial theorem

Define a = m^2 + t^2. Then

  (H^2 - a I_4)^2 = t^2 |z_L - z_R|^2 I_4.   [BOXED]

### Proof

Squaring gives diagonal blocks B_{z_L}^2 + t^2 I = B_{z_R}^2 + t^2 I = a I. The upper-right block is t(B_{z_L} Sigma + Sigma B_{z_R}) = t(B_{z_L} - B_{z_R}) Sigma = t B_{z_L - z_R} Sigma. The lower-left block is its adjoint. Since B_w B_w^dag = |w|^2 I, squaring H^2 - a I yields the claimed scalar matrix. No spectral theorem is needed for the core identity.

## Exact phase-sensitive spectrum

The two squared-energy levels are

  E_pm^2 = m^2 + t^2 pm t |z_L - z_R|.   [BOXED]

Each has multiplicity two in H^2. Writing z_L = m e^{i theta_L}, z_R = m e^{i theta_R} gives |z_L - z_R| = 2m |sin((theta_R - theta_L)/2)|. Therefore the squared gap is

  g^2 = m^2 + t^2 - 2 m t |sin(Delta theta / 2)|.   [BOXED]

Two fields with the same pointwise modulus but different phase mismatch have different spectra.

A common phase is unobservable: z_L, z_R -> e^{i alpha} z_L, e^{i alpha} z_R is implemented by a common unitary conjugation. The observable depends only on the relative, transported phase.

## Fully gauge-covariant form

If the connecting edge carries a phase chi, use T_chi = t Sigma e^{i chi Sigma / 2}. The covariant mismatch is Delta_chi = z_R - e^{-i chi} z_L. The identity becomes

  (H_chi^2 - a I_4)^2 = t^2 |Delta_chi|^2 I_4.   [BOXED]

Under local basis changes z_j -> e^{i alpha_j} z_j, chi -> chi + alpha_L - alpha_R, one has Delta_chi -> e^{i alpha_R} Delta_chi, so its modulus and the spectrum are invariant.

## Exact zero-mode condition

The gap vanishes exactly when t = m and z_R = -e^{-i chi} z_L.   [BOXED]

Thus the local Pluecker phases are antipodal after parallel transport, and the kinetic coupling equals their common modulus.

This is a direct finite defect-mode statement. It is not yet a topological-protection theorem: in the two-site model, moving t/m away from one opens the gap. Topological protection requires a chain with gapped asymptotic bulks and the invariant proposed in H5.

This is closely aligned with established continuum phase-defect phenomena: spatially varying complex fermion masses can carry observable induced quantum numbers, and vortex phase winding can force fermion zero modes (Goldstone-Wilczek PRL 47, 986; Jackiw-Rossi). But the 4x4 identity above is finite and self-contained.

This resolves H2's operational gate in the weakest decisive form:

> The free local carrier itself has a gauge-invariant observable that distinguishes equal-modulus Pluecker fields.

No supplied quartic interaction is required.

Suggested file: PlueckerPhaseDefectSpectrum.lean

Suggested theorem ladder: Bz_sq, sigmaZ_mul_Bz, phaseDefect_sq_block, phaseDefect_polynomial, phaseDefect_gapSq, phaseDefect_gap_zero_iff, common_phase_unitary_equiv.

The observable to preregister is g^2, before any fit.

# 3. H5: the missing invariant is reflection-resolved chiral pinning

[Fable note at banking: the discriminator role of this proposal is already
answered negatively by the landed reflR_comm_walk_iff / 
fixedSingleton_not_reflSym - the sectorwise index requires [R, W] = 0 which
fails on exactly the blind fields. The stability template and localization
rung below remain the valuable content.]

Let W be the full finite walk. Assume W^dag W = I, Gamma^2 = I, Gamma W Gamma = W^dag, and a reflection R^2 = I, [R, W] = 0, [R, Gamma] = 0.

The special Floquet points are eps = +1 and eps = -1 (quasienergies 0 and pi). Define E_{eps,r} = ker(W - eps I) cap ker(R - r I), r = pm 1. Because eps = eps^{-1}, chiral symmetry preserves these eigenspaces. Define

  nu_{eps,r} = Tr(Gamma restricted to E_{eps,r})   [BOXED]

equivalently nu_{eps,r} = n^+_{eps,r} - n^-_{eps,r}, the chirality imbalance of pinned modes in reflection sector r.

## Reflection-resolved pinning theorem

dim E_{eps,r} >= |nu_{eps,r}|. Moreover, under a continuous perturbation W_s preserving unitarity, chiral symmetry, reflection symmetry, and an open spectral gap around eps outside the defect modes, the integer nu_{eps,r} is constant.

### Proof structure

Let P_eps(s) be the Riesz projection around a small contour enclosing eps, and P_r = (1/2)(I + r R). Then nu_{eps,r}(s) = Tr(Gamma P_r P_eps(s)). The Riesz projection varies continuously. The trace is an integer because it is the trace of an involution on a finite-dimensional invariant space. A continuous integer-valued function is constant. Pinned modes can disappear only in opposite-chirality pairs in the same reflection sector.

The global and reflection-weighted indices are nu_eps = nu_{eps,+} + nu_{eps,-} = Tr(Gamma P_eps) and nu^R_eps = nu_{eps,+} - nu_{eps,-} = Tr(Gamma R P_eps). Therefore it is possible to have nu_eps = 0 but nu_{eps,+} = -nu_{eps,-} != 0. That is exactly the pattern "globally cancelling, sectorwise protected."

This explains why two same-winding configurations can behave differently: translating a wall from a reflection-fixed site to a reflection-fixed bond can leave winding and wall count unchanged while changing its R-representation and therefore nu_{eps,r}.

## Immediate fixture test

For both same-winding four-site fields, compute the four integers (nu_{+,+}, nu_{+,-}, nu_{-,+}, nu_{-,-}). Three outcomes are decisive:

* If the tuples differ exactly as the mode patterns differ, H5 is essentially resolved.
* If the tuples agree but the modes differ, reflection-resolved chirality is insufficient.
* If the tuple is nonzero but a mode disappears under a symmetry- and gap-preserving perturbation, there is an error in the symmetry implementation or projection.

## Localization rung

Suppose outside a finite defect region the walk has fixed bulk transfer matrices. If, at eps = pm 1, their stable subspaces obey |T_{eps,st} v| <= rho |v| with rho < 1, then any pinned defect mode satisfies |psi_x| <= C rho^{d(x, defect)}. This follows by iterating the transfer relation. In a rational fixture, the contraction inequality can be certified by an exact positive-semidefinite matrix inequality.

Suggested file: ReflectionResolvedPinnedIndex.lean

Core targets: reflectionChiralIndex, pinnedMode_count_ge_abs_index, reflectionChiralIndex_homotopy_invariant, globalIndex_eq_sum_reflectionSectors, reflectionWeightedIndex_eq_difference, transfer_contraction_implies_localization.

One algebraic check is essential: if the actual R ANTIcommutes with Gamma, then Gamma exchanges the reflection sectors and the sectorwise index above is not defined. In that case the correct invariant is a twisted relative index based directly on Gamma R. This should be checked before transcribing the fixture theorem.
[Fable note: landed reflR_comm_grade proves [R, Gamma] = 0 - the commuting case.]

# 4. H6: an exact geometric CAR causal cone

[Same ladder as the advisor's H6; Codex 63b8418b in flight. Key elements:]

Even unitaries commute ordinarily with every operator on a disjoint region. One-layer support theorem: for pairwise disjoint supports S_j of graph diameter <= r, conjugation maps A_X into A_{N_r(X)}. Depth-T theorem: U^dag A_X U subset A_{N_{Tr}(X)}; for varying radii replace Tr by sum r_t. Outside the cone, graded commutator vanishes; if either operator is even, ordinary commutator.

Required nonlocal control: U_xy(theta) = exp[-i theta (a_x^dag a_y + a_y^dag a_x)] for d(x,y) > r is even but fails the radius hypothesis, and conjugation of a_x immediately has an a_y component.

Applying to the Pluecker pair kick: the quartic generator K_S(z) = z a_i^dag a_j^dag a_l a_k + zbar a_k^dag a_l^dag a_j a_i is Hermitian, even, supported on S = {i,j,k,l}; once required to lie in a graph block of diameter <= r, every scheduled pair kick obeys the exact cone.

Suggested file: GeometricCARCausalCone.lean. Core targets: even_disjoint_commute, support_conj_localGate_subset_union, support_conj_layer_subset_neighborhood, support_conj_schedule_subset_iteratedNeighborhood, gradedComm_eq_zero_outside_cone, ordinaryComm_eq_zero_outside_cone_of_even, nonlocal_hopping_fails_radius.

This closes H6's FIRST gate. It does not derive the quartic gate from the null-edge action or compute its binding/scattering data.

# 5. H4: the missing changing-lattice theorem is mostly one low/high-frequency estimate

[Same split as the advisor's H4. Key formula:]

With S_a I_a = id, I_a S_a = P_a (Fourier box projection), n_a(t) = round(t/a), bounded-box error eps_a(T, K) <= C_T a (1+K)^p, the theorem is

  || I_a U_a^{n_a(t)} S_a psi - e^{-itH_D} psi ||_{L^2}
    <= C_T a (1+K)^p ||psi||_{L^2} + 2 K^{-s} ||psi||_{H^s}.

Proof: split psi = P_K psi + (I - P_K) psi; Parseval + symbol conjugacy on the low part; norm-preservation + contraction on the tail; Sobolev tail estimate. Choosing K(a) = a^{-1/(p+s)} gives rate O(a^{s/(p+s)}) uniformly on |t| <= T. Point sampling adds an aliasing estimate (s > 3/2).

Lean ladder: sampling_interpolation_id, interpolation_sampling_eq_fourierProjection, lowMode_evolution_error, highMode_error_le_two_tail, sobolev_fourier_tail, changingLattice_continuum_bound, optimized_cutoff_rate, pointSampling_alias_bound.

This would close H4 PROVIDED the constants in the bounded-box estimate grow at most polynomially in K. If they grow faster than every polynomial, that growth - not the changing state spaces - is the real obstruction.
[Fable note: Codex's 07:02 finding shows exactly super-polynomial growth
16(3K+M)^2 e^{3K+M} in the live constant; the refined-window-rate job is
the repair. Pro's caveat and Codex's diagnosis agree.]

# 6. H7: a stronger finite scale-selection no-go

Let S be differentiable and homogeneous: S(r x) = r^p S(x), p > 0. Euler: dS_x[x] = p S(x). If S(x) > 0 for x != 0, then at every nonzero point dS_x[x] > 0. Therefore:

  A positive homogeneous finite action has no nonzero stationary point.   [BOXED]

If p = 0, the radial direction is flat, so it cannot select an isolated scale either. No search over fixed finite homogeneous potentials can solve H7. Adding terms of different engineering degrees selects a scale only by inserting a dimensionful ratio; r^4 log(r/mu) contains a reference scale mu.

The first honest escape is a refining family with running dimensionless couplings: derive a beta function a dg/da = beta(g) and an RG invariant Lambda_dyn = a^{-1} exp[-int^{g(a)} dg'/beta(g')]. The physical target is m_i(a)/Lambda_dyn -> c_i with at least one held-out universal ratio c_i/c_j.

Dependency ordering: H7 requires H4 plus a local many-body/RG dynamics.   [BOXED]

Suggested file: FiniteScaleSelectionNoGo.lean with the homogeneous Euler theorem and the p = 0 flat-direction control.
[Fable note: converges with the exact dilatation result landed this hour
(ledger 07:0x): the landed R3's -1 marginal direction is the dilatation
mode, exact 2-cycle line, c + b^2 = 0 identically.]

# 7. H3: the next theorem should be a resource lower bound

A 2026 analysis constructs Dirac-walk families without conventional doublers and pseudo-doublers, but still finds additional low-energy non-Dirac solutions (arXiv 2601.15885 - VERIFY). A July 2026 result in two dimensions shows a single unpaired cone can depend on nonsymmorphic, half-translation symmetries fragile under generic inhomogeneity (arXiv 2607.05112 - VERIFY).

The promising H3 theorem shape: finite range + translation invariance + onsite chiral/time-reversal symmetry + minimal internal dimension + robust single Dirac tangent ==> doublers, pseudo-doublers, or extra low-energy modes. The first escape resource should then be identified exactly: larger unit cell, additional memory/substeps, non-onsite symmetry, larger coin dimension, or longer range.

# Recommended build order (Pro's)

1. Pluecker phase-defect polynomial theorem (short, decisive, preregisters g^2).
2. Physical channel quotient theorem (tells the decomposition paper its moduli space).
3. Geometric CAR cone and changing-lattice estimate (integration exercises).
4. Reflection-resolved index (most consequential; requires the R-Gamma convention check).

Central new formulas: H^0(End K, delta_Q) ~= End(H_Q(K)) and (H_chi^2 - (m^2+t^2) I)^2 = t^2 |z_R - e^{-i chi} z_L|^2 I.
