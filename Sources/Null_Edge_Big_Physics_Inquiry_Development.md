# Developing the Big-Physics Lines of Inquiry

Companion to
[`Null_Edge_Causal_Graph_Research_Plan.md`](Null_Edge_Causal_Graph_Research_Plan.md).

**Date:** 2026-06-21.

This note develops the three high-value directions that emerged from the
recent feedback:

1. flavor as internal Gram overlap;
2. proper time as visible celestial mixedness;
3. cosmological-constant/vacuum visibility through finite causal-diamond
   source observables.

The main conclusion is asymmetric.  The flavor line is the most native and
mathematically ready.  The proper-time line is a clean corollary with careful
normalization caveats.  The cosmological-constant line is the deepest but must
stay at the level of finite diagnostics and pilots until it proves it can
distinguish visible matter excitations from coherent vacuum bookkeeping.

## 1. Flavor as internal Gram overlap

### 1.1 Core finite theorem

Let visible alternatives be complex two-spinors

```text
v_a in C^2,      a = 1,...,n,
```

and let their unresolved internal labels have Gram matrix

```text
G_ab = <e_b, e_a>.
```

Write `M` for the `2 x n` matrix whose columns are the spinors `v_a`.  The
visible observer sees

```text
P_vis = M G M^dagger.
```

The determinant is not merely the orthogonal Plucker sum.  By Cauchy-Binet for
the product `M G M^dagger`,

```text
det(P_vis)
  =
sum_{I,J, |I|=|J|=2}
  det(M_I) det(G_{I,J}) conj(det(M_J)).
```

For ordered pairs `I = (a,b)` and `J = (c,d)` with `a < b`, `c < d`, this is

```text
det(P_vis)
  =
sum_{a<b,c<d}
  (G_ac G_bd - G_ad G_bc)
  (v_a wedge v_b) conj(v_c wedge v_d).
```

Equivalently,

```text
det(P_vis) = w^dagger (Lambda^2 G) w,
```

where `w_ab = v_a wedge v_b`.  Thus the internal sector contributes through
the exterior-square Gram matrix.  The theorem should be the next finite
linear-algebra keystone after the orthogonal Plucker theorem.

### 1.2 Important limits

**Orthogonal/decohered internal labels.** If `G = I`, then `Lambda^2 G = I`
and

```text
det(P_vis) = sum_{a<b} |v_a wedge v_b|^2.
```

This is the trusted Plucker theorem already formalized.

**Perfect internal coherence.** If `G` has rank one, then `Lambda^2 G = 0`.
Equivalently, `G_ab = u_a conj(u_b)`, and

```text
P_vis = (sum_a u_a v_a) (sum_b u_b v_b)^dagger,
```

so `P_vis` has rank one and determinant zero.  A fully coherent hidden label
does not create visible mass.

**Two alternatives.** For

```text
G = [[1, k], [conj(k), 1]],
```

the formula becomes

```text
det(P_vis) = (1 - |k|^2) |v_1 wedge v_2|^2.
```

This is exactly the partial-coherence theorem already isolated in
`PhysicsSM.Draft.NullEdgeDecoherenceChannelAristotle`.

### 1.3 Flavor interpretation

The proposal is not that visible null geometry directly knows the electron,
muon, and tau.  It does not.  The visible layer only sees a two-dimensional
celestial qubit.  Flavor should live in the internal overlap data.

The sharp version is:

```text
Yukawa hierarchy = hierarchy of internal distinguishability.
```

Light fermions correspond to internal labels whose alternatives remain nearly
indistinguishable to the visible celestial observer, so `Lambda^2 G` is small
on the relevant Plucker directions.  Heavy fermions correspond to internal
labels that are nearly orthogonal/distinguishable, so the Plucker spread
survives the trace over internal data.

This is structurally adjacent to Froggatt-Nielsen charge suppression and
split-fermion wavefunction overlap suppression, but the ambition is different:
derive the overlap kernel from the internal exceptional/Jordan geometry rather
than assign charges or profiles by hand.

### 1.4 Mixing and CP

For each sector `f = u,d,e,nu`, introduce an effective internal overlap or
Higgs-transition kernel `G^f`.  The mass-square matrix is then the finite
observable built from `G^f` and the visible Plucker data.  Diagonalizing
up-type and down-type sectors gives different bases:

```text
H_u = U_u D_u U_u^dagger,
H_d = U_d D_d U_d^dagger,
V_CKM = U_u^dagger U_d.
```

The program should first prove the finite matrix bookkeeping:

```text
V_CKM is unitary;
if H_u and H_d commute and have nondegenerate spectra, then V_CKM is only a
diagonal/permutation ambiguity;
nontrivial mixing requires noncommuting internal Gram data.
```

For CP violation, the correct guardrail is the Jarlskog invariant.  The
speculative Berry/Pancharatnam language should not be promoted until the
finite invariant is visible:

```text
J_CP proportional to Im(V_ij V_kl conj(V_il) conj(V_kj)),
```

or equivalently to a basis-independent commutator invariant such as
`Im tr([H_u,H_d]^3)` in the nondegenerate case.

### 1.5 Make-or-break computation

The finite theorem relocates the flavor problem.  It does not solve it.  The
decisive question is whether the internal geometry naturally produces
hierarchical Gram spectra.

Pilot:

1. Choose natural internal states in the `H_3(O)`/Albert layer: primitive
   idempotents, Peirce components, or coherent states on the octonionic
   projective plane.
2. Define a canonical or at least convention-controlled Hermitian pairing.
3. Compute the Gram matrix for natural triples and Higgs-transition channels.
4. Look for forced small parameters, exponential/geodesic suppression, or
   constrained mixing angles.
5. If the spectra are generic `O(1)`, mark the flavor branch as elegant but
   nonpredictive.

### 1.6 Immediate theorem targets

```lean
gramWeightedVisibleMomentum
exteriorPairGram
visibleDet_eq_exteriorGram_weighted_plucker
orthonormal_internalGram_recovers_plucker_sum
rankOne_internalGram_implies_visible_massless
partialCoherenceGram_det_eq_factor_mul_plucker
ckm_unitary_from_two_unitary_diagonalizers
commuting_massSquares_imply_trivial_mixing_nondegenerate
jarlskog_rephasing_invariant
```

The first five are pure finite linear algebra and should be Aristotle-ready.
The CKM/Jarlskog targets are secondary and need careful finite-dimensional
matrix API choices before formalization.

## 2. Proper time as visible mixedness

### 2.1 Normalization

Let a positive `2 x 2` visible momentum matrix be written in Pauli form

```text
P = p^mu sigma_mu.
```

With the project convention,

```text
det(P) = m^2,
trace(P) = 2E.
```

Define the normalized visible celestial density

```text
rho_vis = P / trace(P).
```

Then

```text
det(rho_vis) = det(P) / trace(P)^2 = m^2 / (4 E^2),
```

so

```text
2 sqrt(det(rho_vis)) = m / E.
```

In units `c = 1`, this is also the special-relativistic proper-time rate

```text
d tau / dt = 1/gamma = m/E.
```

Thus the determinant mixedness of the visible celestial qubit is a proper-time
clock rate, provided the trace normalization is kept explicit.

### 2.2 Relation to partial hidden coherence

For two alternatives with hidden overlap `k`,

```text
det(P(k)) = (1 - |k|^2) |psi wedge phi|^2.
```

The unnormalized determinant is monotone decreasing in `|k|` on `0 <= |k| <= 1`.
The normalized proper-time rate is

```text
tau_rate(k)^2
  =
4 (1 - |k|^2) |psi wedge phi|^2 / trace(P(k))^2.
```

Here the trace can depend on `k`, because coherent alternatives also change
visible energy normalization.  Therefore the safe theorem is:

```text
For fixed trace, or under explicit hypotheses controlling trace(P(k)),
proper-time rate decreases as hidden coherence increases.
```

Do not state a general data-processing theorem unless the channel class is
fixed.  The determinant is not monotone under arbitrary qubit channels.

### 2.3 Finite theorem targets

```lean
normalizedVisibleDensity_det_eq_massSq_over_traceSq
properTimeRate_eq_two_sqrt_det_visibleDensity
partialCoherence_det_monotone_of_normSq_le
partialCoherence_properTimeRate_monotone_fixed_trace
properTimeRate_zero_iff_visible_rankOne
properTimeRate_one_iff_rest_frame_normalized
```

The first two are theorem-wrapper targets.  The monotonicity statements need
careful hypotheses.  The last target depends on the normalization convention:
for a trace-one qubit density, `2 sqrt(det rho) = 1` iff `rho = I/2`.

## 3. Causal-diamond source visibility

### 3.1 The sharpened cosmological-constant question

The line to pursue is not "vacuum energy is zero" and not "GR is replaced by
null edges."  The finite question is:

```text
Which microscopic graph data are visible to the gravitational source
observable of a causal diamond?
```

The hypothesis is that the gravitational observable sees screen-crossing null
flux, entropy imbalance, and holonomy/curvature defects.  It need not see
every internal coherent amplitude that QFT bookkeeping would count as local
vacuum energy.

### 3.2 Finite observable package

For a finite causal diamond `D`, define:

```text
Screen(D)          finite set of cut/crossing edges
Flux(D)            sum of screen-crossing null energy/momentum weights
Entropy(D)         edge-count, log-rank, or visible-density entropy proxy
CurvatureDefect(D) path-pair/diamond holonomy defect
B_D                finite bivector or area cochain on the screen
Pairing(D)         <B_D, CurvatureDefect(D)>
```

Then define a finite diagnostic

```text
ClausiusDefect(D)
  =
DeltaEntropy(D) - beta_D * Flux(D) - alpha * Pairing(D).
```

This is not yet Jacobson's theorem.  It is a graph observable whose continuum
limit can later be compared with Clausius/Raychaudhuri behavior.

### 3.3 Required finite properties

The first mathematical targets should be deliberately modest:

```text
Flux is additive on disjoint screen unions.
Entropy proxy is monotone or subadditive under screen refinement.
Curvature pairing is gauge invariant when the holonomy defect is tested by a
class function or an invariant pairing.
ClausiusDefect is additive under disjoint diamond union.
Boundary/gluing terms are explicit under diamond composition.
```

These are finite graph theorems.  They do not require a continuum metric.

### 3.4 Vacuum-visibility pilots

Build two finite model classes.

**Coherent/internal vacuum bookkeeping.**

Internal alternatives are coherent or cancel in visible flux:

```text
P_vis rank one or zero net screen flux;
CurvatureDefect trivial or gauge-removable;
ClausiusDefect zero or boundary-only.
```

This is a model of microscopic activity that remains invisible to the
gravitational diamond observable.

**Visible Plucker-mass excitation.**

Alternatives are decohered or internally distinguishable:

```text
det(P_vis) > 0;
screen flux nonzero;
ClausiusDefect nonzero unless compensated by curvature pairing.
```

The falsification test is harsh: if coherent internal vacuum bookkeeping
contributes a volume-scaling source to the finite diamond observable in the
same way as visible matter, then this line does not help the cosmological
constant problem.

### 3.5 Immediate theorem and pilot targets

```lean
DiamondScreenObservable
screenFlux_additive_union
diamondCurvaturePairing_gauge_invariant
diamondClausiusDefect_additive_disjoint
diamondClausiusDefect_gluing_boundary_term
coherentHiddenChannel_zero_screenMass
decoheredPluckerExcitation_positive_screenMass
```

Oracle pilots:

```text
Scripts/null_edge/diamond_source_pilot.py
Scripts/null_edge/albert_gram_spectrum_pilot.py
Scripts/null_edge/celestial_gap_dirac_pilot.py
```

The pilots should produce fixtures only.  They should not be treated as proofs.

## 4. Priority order

1. **Gram-weighted Plucker theorem.** This is the next highest-value Lean
   target because it turns the flavor idea into finite linear algebra.
2. **Proper-time normalization wrappers.** These are low-risk theorem
   wrappers once trace conventions are fixed.
3. **Diamond source observable.** Define the finite API before arguing about
   dark energy.
4. **Albert/Jordan Gram pilot.** This is the make-or-break physics computation
   for whether the flavor line becomes predictive.
5. **CKM/Jarlskog finite matrix package.** Important, but only after the
   internal Gram theorem and conventions are stable.

## 5. Literature anchors already added

Flavor and CP:

- Froggatt-Nielsen, `AKMVETAK`,
  `10.1016/0550-3213(79)90316-X`.
- Arkani-Hamed-Schmaltz, `M9KJ7UCN`,
  `10.1103/PhysRevD.61.033005`.
- Jarlskog, `D6TGC96N`, `10.1103/PhysRevLett.55.1039`.

Proper/thermal/relational time:

- Connes-Rovelli, `I8XNBREW`, `10.1088/0264-9381/11/12/007`.
- Page-Wootters, `EWXH3E6A`, `10.1103/PhysRevD.27.2885`.

Cosmological constant and causal diamonds:

- Weinberg, `5A68ISBN`, `10.1103/RevModPhys.61.1`.
- Burgess, `TH8UZJ9K`, `1309.4133`.
- Jacobson-Visser, `2ZZTQS43`, `1812.01596`.
- Sorkin, `G3FT8BXC`, `0710.1675`.
- Ahmed-Dodelson-Greene-Sorkin, `ZP7E648U`,
  `10.1103/PhysRevD.69.103523`.
