# Null-edge causal graph proof advances

Date: 2026-06-21

Status: hand-proof and theorem-target note.  This document is meant to feed
future Aristotle jobs and human review.  It deliberately separates exact
finite mathematics from conjectural continuum physics.

Related notes:

- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `Sources/Null_Edge_Causal_Graph_Theorem_Roadmap_2026-06-21.md`
- `PhysicsSM/Draft/NullEdgeCoreAristotle.lean`
- `PhysicsSM/Draft/NullEdgePluckerGeneralAristotle.lean`
- `PhysicsSM/Draft/NullEdgeYukawaFlip.lean`

## Executive advance

The next layer of the program should not merely prove the finite Pluecker
identity.  It should prove that the identity is the Lorentz/spinor-helicity
mass functional and that it is invariant under the correct spinor symmetries.

The highest-value theorem cluster is now:

1. full finite Pluecker mass by Cauchy-Binet;
2. positivity/equality: mass zero iff every Pluecker coordinate vanishes;
3. projective collinearity, with zero-spinor edge cases handled explicitly;
4. the two-spinor Lagrange identity
   `|<psi,phi>|^2 + |psi wedge phi|^2 = |psi|^2 |phi|^2`;
5. `SL(2,C)` covariance of the wedge and invariance of the mass functional;
6. two-twistor or massive spinor-helicity chart matching;
7. non-Abelian causal-diamond gauge covariance, with class functions giving
   true gauge invariants.

This turns the slogan

```text
mass is Pluecker spread of null edges
```

into a robust theorem package:

```text
mass is the invariant, nonnegative, pairwise Fubini-Study spread of a finite
bundle of visible null spinors.
```

## Literature pass

The recent search pass reinforces the following anchors.

- Feynman-checkerboard and null-step Dirac dynamics:
  Earle's notes on the checkerboard model and Foster-Jacobson's 4D null-step
  construction support the idea that mass enters through turn or chirality-flip
  amplitudes.
  Sources: https://arxiv.org/abs/1012.1564 and
  https://arxiv.org/abs/1610.01142.
- Quantum-walk Dirac limits:
  D'Ariano-Mosco-Perinotti-Tosini and Arrighi-Forets-Nesme give controlled
  discrete-to-Dirac routes, useful as a continuum-limit comparison class.
  Sources: https://arxiv.org/abs/1603.06442 and
  https://arxiv.org/abs/1307.3524.
- Causal-set propagators and fermions:
  Johnston's causal-set propagator work and Noldus's causal-set fermion work
  give nearby matter-on-causet precedents.
  Sources: https://arxiv.org/abs/0806.3083 and
  https://arxiv.org/abs/1305.0443.
- Twistor and massive spinor-helicity mass:
  two-twistor particle models and massive amplitudes support the idea that a
  massive particle is naturally encoded by a pair or bundle of massless spinor
  data.
  Sources: https://arxiv.org/abs/1409.7169,
  https://arxiv.org/abs/2203.08087, and
  https://arxiv.org/abs/2501.09062.
- Lorentz-invariant causal discreteness:
  Bombelli-Henson-Sorkin is a hard constraint against fundamental fixed
  finite-valency graphs.
  Source: https://arxiv.org/abs/gr-qc/0605006.
- Causal-set gauge and curvature:
  Sverdlov formulates gauge fields using holonomies between causal pairs, and
  Baez-Schreiber gives the higher-gauge path/surface holonomy language.
  Sources: https://arxiv.org/abs/0807.2066,
  https://arxiv.org/abs/math/0511710, and
  https://arxiv.org/abs/hep-th/0412325.
- Kähler-Dirac and discrete Hodge-Dirac directions:
  Kähler-Dirac fermions and discrete Hodge-Dirac convergence give a credible
  order-complex route for graph-native fermions.
  Sources: https://arxiv.org/html/2306.17420v6,
  https://arxiv.org/abs/2304.00153, and
  https://arxiv.org/abs/2402.07094.
- Gravity:
  Jacobson's null-horizon thermodynamics and Benincasa-Dowker causal-set
  curvature remain the best gravity-side anchors.
  Sources: https://arxiv.org/abs/gr-qc/9504004 and
  https://arxiv.org/abs/1001.2725.

## Proof A: finite Pluecker mass by Cauchy-Binet

Let `psi_i = (a_i,b_i)` be complex two-spinors and let `A` be the `2 x n`
matrix whose `i`-th column is `psi_i`.

The visible momentum matrix is

```text
P = sum_i psi_i psi_i^dagger = A A^dagger.
```

Cauchy-Binet gives

```text
det(P) = det(A A^dagger)
       = sum_{S subset {1,...,n}, |S|=2}
           det(A[:,S]) det(A^dagger[S,:]).
```

For a pair `S = {i,j}` with `i < j`,

```text
det(A[:,S]) = a_i b_j - b_i a_j = psi_i wedge psi_j.
```

The corresponding minor of `A^dagger` is the complex conjugate:

```text
det(A^dagger[S,:]) = conjugate(psi_i wedge psi_j).
```

Therefore

```text
det(P) = sum_{i<j} |psi_i wedge psi_j|^2.
```

This is the general theorem currently handed to Aristotle as
`fin_bundle_plucker_mass_identity`.

### Aristotle-friendly induction variant

If Cauchy-Binet is awkward in Lean, use the rank-one update form.

Let

```text
P_n = sum_{i<n} psi_i psi_i^dagger,
chi = (x,y).
```

Writing `P_n = [[A,B],[C,D]]`, direct determinant expansion gives

```text
det(P_n + chi chi^dagger) - det(P_n)
  = D x conjugate(x) + A y conjugate(y)
    - B y conjugate(x) - C x conjugate(y).
```

Since

```text
A = sum_i a_i conjugate(a_i),
B = sum_i a_i conjugate(b_i),
C = sum_i b_i conjugate(a_i),
D = sum_i b_i conjugate(b_i),
```

the difference is

```text
sum_i |a_i y - b_i x|^2
  = sum_i |psi_i wedge chi|^2.
```

Thus

```text
det(P_n + chi chi^dagger)
  = det(P_n) + sum_i |psi_i wedge chi|^2.
```

This gives an induction proof of the full finite formula.  In Lean, this may
be easier than invoking a general Cauchy-Binet theorem because the matrix size
is fixed at `2 x 2` and the final algebra can be discharged by `ring`.

Recommended theorem:

```lean
theorem fin_bundle_plucker_rank_one_update
    {n : Nat} (psi : Fin n -> CSpinor) (chi : CSpinor) :
    (finBundleMomentum (Fin.snoc psi chi)).det =
      (finBundleMomentum psi).det +
        sum_i complexAbsSq (spinorWedge (psi i) chi)
```

The exact Lean surface will need a convenient `Fin.snoc` or `Fin.cast` API,
but this is the proof route.

## Proof B: positivity and the real mass functional

The current draft uses

```lean
def complexAbsSq (z : C) : C := z * star z
```

because it compares directly with a complex determinant.  For equality
conditions, introduce a real-valued companion:

```lean
def complexAbsSqR (z : C) : R := Complex.normSq z
```

Then prove the bridge:

```text
complexAbsSq z = (complexAbsSqR z : C).
```

The equality proof is:

1. `complexAbsSqR z >= 0`;
2. a finite sum of nonnegative real numbers is zero iff every summand is zero;
3. `Complex.normSq z = 0` iff `z = 0`.

Therefore:

```text
sum_{i<j} |psi_i wedge psi_j|^2 = 0
  iff
forall i<j, psi_i wedge psi_j = 0.
```

This should become its own theorem, independent of the determinant identity:

```lean
theorem finPairwisePluckerMassR_eq_zero_iff_pair_terms_zero
    {n : Nat} (psi : Fin n -> CSpinor) :
    finPairwisePluckerMassR psi = 0 <->
      forall p in finPairIndexSet n,
        spinorWedge (psi p.1) (psi p.2) = 0
```

This theorem is the cleanest way to avoid trying to reason about positivity
inside `C`.

## Proof C: massless iff projectively collinear

Pairwise zero wedge is exactly rank at most one for the `2 x n` spinor matrix.

The safest statement has a zero-bundle disjunction:

```text
PairwiseWedgeZero psi
  iff
  (forall i, psi_i = 0)
  or
  exists base, psi_base != 0 and exists c_i, psi_i = c_i psi_base.
```

Proof:

1. If every spinor is zero, the result is trivial.
2. Otherwise choose a nonzero base spinor `psi_b`.
3. Pairwise wedge zero gives `psi_b wedge psi_i = 0` for every `i`.
4. For a nonzero two-spinor `u`, `u wedge v = 0` iff `v = c u`.
   This is the existing two-spinor collinearity lemma.
5. Conversely, scalar multiples of one spinor have pairwise zero wedge by
   bilinearity and antisymmetry:

```text
(c_i u) wedge (c_j u) = c_i c_j (u wedge u) = 0.
```

Recommended theorem:

```lean
theorem pairwise_wedge_zero_iff_zero_or_common_direction
    {n : Nat} (psi : Fin n -> CSpinor) :
    PairwiseWedgeZero psi <->
      (forall i, psi i = 0) \/
      exists base : Fin n,
        psi base 0 != 0 \/ psi base 1 != 0 /\
        exists c : Fin n -> C, forall i, psi i = c i • psi base
```

After combining with Proof A and Proof B:

```text
det(sum_i psi_i psi_i^dagger) = 0
  iff
the visible null bundle is projectively one-dimensional
```

with zero edges allowed as degenerate members.

## Proof D: spinor Lagrange identity and angular spread

Define the Hermitian inner product

```text
<psi,phi> = conjugate(psi_0) phi_0 + conjugate(psi_1) phi_1.
```

Then the two-spinor Lagrange identity is

```text
|<psi,phi>|^2 + |psi wedge phi|^2
  = |psi|^2 |phi|^2.
```

Proof: expand both sides for

```text
psi = (a,b), phi = (c,d).
```

The left side is

```text
|conj(a)c + conj(b)d|^2 + |ad - bc|^2.
```

After expansion, the mixed terms cancel and the result is

```text
(|a|^2 + |b|^2)(|c|^2 + |d|^2).
```

For normalized spinors,

```text
|psi wedge phi|^2 = 1 - |<psi,phi>|^2.
```

This is the bridge from Pluecker mass to Fubini-Study geometry:

```text
pairwise mass contribution = sine^2(projective spinor angle).
```

Recommended theorem:

```lean
theorem spinor_inner_wedge_lagrange_identity (psi phi : CSpinor) :
    complexAbsSq (spinorInner psi phi) +
      complexAbsSq (spinorWedge psi phi) =
    spinorNormSq psi * spinorNormSq phi
```

This theorem is high value because it turns the mass identity into an
interpretable geometry theorem: massive bundles are not just non-collinear,
they carry quantified projective angular spread.

## Proof E: `SL(2,C)` covariance and mass invariance

Let `A` be a `2 x 2` complex matrix and define the spinor action

```text
psi |-> A psi.
```

Then

```text
(A psi) wedge (A phi) = det(A) (psi wedge phi).
```

Proof: write

```text
A = [[alpha,beta],[gamma,delta]].
```

Then

```text
(alpha a + beta b)(gamma c + delta d)
  - (gamma a + delta b)(alpha c + beta d)
  = (alpha delta - beta gamma)(ad - bc).
```

Consequences:

```text
|A psi wedge A phi|^2 = |det(A)|^2 |psi wedge phi|^2.
```

For `A in SL(2,C)`, `det(A) = 1`, so every pairwise Pluecker contribution is
invariant.  Therefore the full finite mass functional is invariant under the
spin double-cover action of the proper Lorentz group.

Recommended theorem:

```lean
theorem spinorWedge_mulVec
    (A : Matrix (Fin 2) (Fin 2) C) (psi phi : CSpinor) :
    spinorWedge (A.mulVec psi) (A.mulVec phi) =
      A.det * spinorWedge psi phi
```

and then:

```lean
theorem finPairwisePluckerMass_sl2_invariant
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) C)
    (hA : A.det = 1) (psi : Fin n -> CSpinor) :
    finPairwisePluckerMass (fun i => A.mulVec (psi i)) =
      finPairwisePluckerMass psi
```

This is the theorem that makes the finite Pluecker mass a relativistic mass
candidate rather than just a coordinate calculation.

## Proof F: two-twistor and massive spinor-helicity matching

In massive spinor-helicity notation, a real massive momentum can be written
as a sum of two null spinor outer products:

```text
P_{A A'} = lambda_A^1 conjugate(lambda_{A'}^1)
         + lambda_A^2 conjugate(lambda_{A'}^2).
```

The determinant is therefore

```text
det(P) = |lambda^1 wedge lambda^2|^2.
```

This is exactly the two-edge Pluecker mass identity already proved in Lean.

The little-group `SU(2)` acts on the pair index:

```text
lambda^I |-> lambda^J U_J^I.
```

The wedge of the two columns changes by `det(U)`, which is `1` for `SU(2)`.
Thus the two-edge Pluecker mass is little-group invariant.

Two-twistor models add incidence data, but their spinor momentum chart has the
same algebraic core.  The first trusted theorem should not claim full twistor
geometry.  It should state the chart-level equivalence:

```text
two-twistor massive momentum determinant
  =
two-null-spinor Pluecker mass.
```

Recommended Lean scope:

```lean
structure SpinorChartTwoTwistor where
  left : CSpinor
  right : CSpinor

def twoTwistorChartMomentum (Z : SpinorChartTwoTwistor) :=
  rankOneHermitian Z.left + rankOneHermitian Z.right

theorem two_twistor_chart_mass_eq_plucker
    (Z : SpinorChartTwoTwistor) :
    (twoTwistorChartMomentum Z).det =
      complexAbsSq (spinorWedge Z.left Z.right)
```

This theorem is mostly repackaging, but the repackaging matters: it is the
formal bridge from null-edge bundles to the twistor and massive-amplitudes
literature.

## Proof G: Higgs-permitted flips as gauge-neutral graph vertices

The Lean theorem already added locally checks the hypercharge bookkeeping for
four one-generation Yukawa flip types:

```lean
YukawaFlip.hyperchargeDefect_eq_zero
```

The hand-proof interpretation is:

1. Left and right fermions carry different electroweak representations.
2. A bare left-right flip is not gauge-invariant.
3. Inserting `H` or `H^dagger` supplies exactly the missing hypercharge.
4. After electroweak symmetry breaking, replacing the neutral Higgs component
   by `v/sqrt(2)` turns the allowed flip amplitude into `m_f = y_f v/sqrt(2)`.

The next theorem should make the graph rule explicit:

```text
An internal vertex label is legal iff the tensor product of incoming fermion,
Higgs insertion, and outgoing conjugate contains the gauge-trivial
representation.
```

At the hypercharge-only level this becomes exact charge conservation.  At the
full electroweak level it should become a singlet-existence theorem for
`SU(2)_L x U(1)_Y`.

Recommended theorem:

```lean
theorem yukawa_flip_vertex_is_electroweak_neutral
    (v : YukawaFlip) :
    electroweakDefect v = trivialCharge
```

This gives a precise meaning to:

```text
the Higgs is the permission structure for chirality-changing null-edge
continuations.
```

## Proof H: non-Abelian causal-diamond covariance

The existing core proves Abelian diamond defect invariance.  The stronger and
more physical non-Abelian statement is covariance by endpoint conjugation.

Let a path holonomy transform as

```text
U_gamma |-> g_bottom^{-1} U_gamma g_top.
```

For a diamond with two paths from `bottom` to `top`, define

```text
Delta = U_left^{-1} U_right.
```

Then under gauge transformation:

```text
Delta |-> g_top^{-1} Delta g_top.
```

Proof:

```text
(g_bottom^{-1} U_left g_top)^{-1}
  (g_bottom^{-1} U_right g_top)
= g_top^{-1} U_left^{-1} g_bottom
  g_bottom^{-1} U_right g_top
= g_top^{-1} Delta g_top.
```

So in a non-Abelian theory the raw defect is not gauge invariant; its
conjugacy class is.  Any class function, such as trace in a representation, is
gauge invariant.  This is the correct finite graph replacement for plaquette
curvature.

Recommended theorem:

```lean
theorem diamondDefect_gauge_covariant [Group G]
    (g : DiamondGauge G) (U : DiamondLabels G) :
    diamondDefect (gaugeTransformDiamond g U) =
      g.top^-1 * diamondDefect U * g.top
```

The Abelian theorem is recovered because conjugation is trivial in a
commutative group.

## Proof I: cochain coboundary and Kähler-Dirac seed

The core file already proves

```lean
chainBoundary_comp_self_eq_zero
```

for formal ordered simplices.  The next step is the dual theorem.

Let a cochain be an additive homomorphism from chains to an Abelian group:

```text
C^k = Hom(Chains_k, A).
```

Define coboundary by precomposition:

```text
(delta f)(c) = f(boundary c).
```

Then

```text
(delta^2 f)(c) = f(boundary(boundary c)) = f(0) = 0.
```

This is the algebraic seed of a Kähler-Dirac operator:

```text
D = d + delta^*
```

on the order complex of a causal poset.  The theorem is not yet a Dirac
continuum limit, but it provides the finite cochain complex needed before
fermionic graph dynamics can be discussed cleanly.

Recommended theorem:

```lean
theorem cochainCoboundary_comp_self_eq_zero
    (f : Chain V ->+ A) :
    cochainCoboundary (cochainCoboundary f) = 0
```

Use additive homomorphisms rather than arbitrary functions so that `f 0 = 0`
is automatic.

## Proof J: finite flux and entropy observables for gravity

For the gravity branch, avoid continuum Einstein-equation claims at first.
Define finite graph observables:

```text
ScreenCrossing(S) = finite set of null edges crossing a screen S
Entropy(S) = alpha * #ScreenCrossing(S)
Flux(S) = sum_{e crossing S} weight(e) p_e
```

Immediate finite theorems:

1. entropy is additive over disjoint screen partitions;
2. flux is additive over disjoint screen partitions;
3. refinement invariance: subdividing a crossing edge without changing total
   null momentum leaves flux unchanged;
4. collinear refinement leaves massless character unchanged;
5. non-collinear refinement contributes Pluecker mass spread.

These are not GR yet.  They are the finite conservation and coarse-graining
lemmas needed before Jacobson-style null-horizon thermodynamics can be mapped
onto graph observables.

## Aristotle priority list after the current job

### Wave 1: finish finite Pluecker geometry

Files:

- `PhysicsSM/Draft/NullEdgePluckerGeneralAristotle.lean`

Targets:

- `fin_bundle_plucker_mass_identity`
- real-valued positivity companion
- zero-or-common-direction equality criterion

This is already running as Aristotle project
`9df58363-44c2-46b5-8349-cfdbbd2fc113`.

### Wave 2: spinor geometry and covariance

New target file:

- `PhysicsSM/Draft/NullEdgeSpinorGeometryTargets.lean`

Targets:

- `spinor_inner_wedge_lagrange_identity`
- `spinorWedge_mulVec`
- `finPairwisePluckerMass_sl2_invariant`
- two-twistor chart matching

This wave is the highest-value follow-up because it upgrades the mass identity
from algebra to invariant geometry.

### Wave 3: non-Abelian diamonds

New target file:

- `PhysicsSM/Draft/NullEdgeDiamondNonabelian.lean`

Targets:

- left and right path holonomy gauge-transformation formulas;
- `diamondDefect_gauge_covariant`;
- Abelian invariance as a corollary;
- class-function invariance in matrix representations.

### Wave 4: electroweak legality

Files:

- `PhysicsSM/Draft/NullEdgeYukawaFlip.lean`

Targets:

- promote hypercharge neutrality to `SU(2)_L x U(1)_Y` singlet existence;
- connect Higgs versus conjugate Higgs insertions to up-type/down-type flips.

### Wave 5: order-complex/Kähler-Dirac

Targets:

- additive cochains;
- coboundary squares to zero;
- finite Hodge-Dirac operator scaffold;
- positivity of the combinatorial Laplacian under a chosen inner product.

## Highest-value mathematical claim right now

The strongest new claim is:

```text
The mass of a finite visible null-edge bundle is not merely non-collinearity.
It is the `SL(2,C)`-invariant sum of pairwise Fubini-Study angular spreads of
the associated projective spinors, and it is exactly the spinor chart of the
massive two-/multi-twistor invariant.
```

This is mathematically sharp, literature-aligned, and close enough to Lean that
Aristotle can attack it theorem by theorem.
