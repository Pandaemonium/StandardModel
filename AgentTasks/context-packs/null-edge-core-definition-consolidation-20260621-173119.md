# Aristotle semantic context pack

Generated: 2026-06-21T17:31:27
Query: `NullEdge Core VisibleSpinor WeylBlocks PluckerConventions definition consolidation canonical rankOneHermitian bundleMomentum spinorWedge`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Spinor/PluckerMass.lean`

Score: `0.844`

```text
namespace PhysicsSM.Spinor.PluckerMass

open Matrix Complex

/-! ## Visible spinors and rank-one null momenta -/

/-- A visible complex Weyl spinor attached to a null edge. -/
```

### 2. `PhysicsSM/Draft/NullEdgeSpinorGeometryTargets.lean`

Score: `0.836`

```text
import PhysicsSM.Draft.NullEdgePluckerGeneralAristotle

/-!
# Draft.NullEdgeSpinorGeometryTargets

Aristotle handoff for the spinor-geometric strengthening of the null-edge
Pluecker mass program.

The finite Pluecker identity says that determinant mass is the sum of squared
pairwise spinor wedges.  This file asks for the next geometric layer:

1. the two-spinor Lagrange identity, identifying wedge-squared with
   Fubini-Study angular spread after normalization;
2. covariance of the wedge under `GL(2,C)` and invariance under `SL(2,C)`;
3. a narrow two-twistor/spinor-chart mass theorem.

These are draft targets.
-/
```

### 3. `Sources/Null_Edge_Causal_Graph_Theorem_Roadmap_2026-06-21.md` [Current kernel-checked core]

Score: `0.835`

```text
## Current kernel-checked core

Aristotle has now verified the first finite null-edge theorem island without
any Sphere-Packing-Lean dependency:

```lean
det_rankOneHermitian_eq_zero
two_edge_plucker_mass_identity
complexAbsSq_eq_zero_iff
two_edge_mass_zero_iff_wedge_zero
spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero
diamondDefect_gauge_invariant
chainBoundary_simplexBoundary_eq_zero
chainBoundary_comp_self_eq_zero
threeEdgeMomentum
three_edge_plucker_mass_identity
```

The most important new result is:

```lean
three_edge_plucker_mass_identity
```

It proves the first genuinely multi-edge visible-bundle mass formula:

```text
det(psi psi^dagger + phi phi^dagger + chi chi^dagger)
  =
|psi wedge phi|^2 + |psi wedge chi|^2 + |phi wedge chi|^2.
```

This moves the program past the two-edge toy case.  The next goal should be
the full finite bundle theorem.
```

### 4. `PhysicsSM/Draft/NullEdgeBundleDiracPluckerCore.lean` [to]

Score: `0.834`

```text
import PhysicsSM.Spinor.PluckerMass
import PhysicsSM.Draft.NullEdgeDiracSlashCore

/-!
# Draft.NullEdgeBundleDiracPluckerCore

Finite bridge from the trusted Pluecker mass theorem to the static chiral
Dirac square-root operator.

The trusted theorem
`PhysicsSM.Spinor.PluckerMass.fin_bundle_plucker_mass_identity` proves that
the determinant of the summed visible rank-one spinor momenta is the total
pairwise Pluecker mass.  This draft module extracts Weyl coordinates from that
`2 x 2` matrix and composes the determinant theorem with the finite chiral
Dirac-slash square.

This is still static finite algebra.  It does not assert a continuum Dirac
equation, propagation law, or scattering interpretation.

Provenance: integrated from the focused Aristotle job
`null-edge-bundle-dirac-plucker-core-20260621`, with the Pluecker determinant
step routed through the trusted `PhysicsSM.Spinor.PluckerMass` API.
-/
```

### 5. `AgentTasks/null-edge-autonomous-aristotle-loop-plan-2026-06-21.md` [Definition clarifications needed]

Score: `0.834`

```text
## Definition clarifications needed

These definitions are the main blockers for high-value proof jobs.

1. `VisibleSpinor`

   Canonical visible two-spinor type, preferred basis order, scalar field, and
   normalization convention. This should replace ad hoc local copies in draft
   files.

2. `rankOneHermitian` and `bundleMomentum`

   A canonical map `psi -> psi psi^dagger`, finite bundle sum, Weyl-coordinate
   extraction, and Minkowski norm. The determinant target should explicitly say
   when it is a real nonnegative value.

3. `spinorWedge` and Pluecker mass

   One canonical wedge convention, one squared-norm convention, and one bridge
   theorem to the trusted `finPairwisePluckerMass` result. Any phase theorem
   must use closed loops or normalized Bargmann triples.

4. `ReducedDensity`

   A visible density matrix with exact trace normalization. The clean theorem is
   `m / E = 2 sqrt(det rho_vis)` only under orthonormal or decohered internal
   labels; nonorthogonal internal labels require a Gram-weighted theorem.

5. `BivectorB` and `simplicityDefect`

   A finite `Lambda^2` wrapper whose mass-sector simplicity defect is the
   Pluecker Gram determinant. This must remain separate from full spin-foam
   cross-simplicity until the EPRL/FK convention map is written.

6. `OrderComplex`

   Finite poset simplices, cochains, coboundary, adjoint, grading, and
   `D = d + delta`. This is the seed for the graph Kahler-Dirac route and the
   finite topological Dirac theorem.

7. `SuperDirac`

   A finite odd self-adjoint block operator
   `D_{U,Phi} = d_U + delta_U + Phi + Phi^dagger`, with explicit Hilbert-space
   decomposition, edge transport, Higgs/Yukawa block, and curvature block.

8. `DiamondSourceVisibility`

   A diamond screen, source pairing, visible/bounda
```

### 6. `Sources/Null_Edge_Causal_Graph_Proof_Advances_2026-06-21.md` [Proof C: massless iff projectively collinear]

Score: `0.831`

```text
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
```

### 7. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Trusted Pluecker mass layer]

Score: `0.830`

```text
### Trusted Pluecker mass layer

`PhysicsSM.Spinor.PluckerMass` proves the finite determinant identity that
turns the null-edge mass slogan into algebra:

- two-edge mass is the squared wedge;
- finite bundle mass is the sum of all pairwise squared wedges;
- the real Pluecker mass functional is nonnegative;
- zero mass is equivalent to a common spinor direction.

This module is trusted and kernel-clean. It should be treated as a central anchor
for future twistor, momentum-bundle, and publication work.
```

### 8. `PhysicsSM/Draft/NullEdgeCoreAristotle.lean` [det_rankOneHermitian_eq_zero]

Score: `0.826`

```text
theorem det_rankOneHermitian_eq_zero (psi : CSpinor) :
    (rankOneHermitian psi).det = 0 := by
  simp [rankOneHermitian, Matrix.det_fin_two, Matrix.vecMulVec]
  ring

/--
Two-edge Pluecker mass identity.  The determinant of the summed null momenta
is the squared modulus of the spinor wedge.

This is the finite algebraic keystone of the null-edge program:
mass is not attached to one edge, but to the Pluecker spread of a bundle of
non-collinear null edges.
-/
```

### 9. `PhysicsSM/Spinor/PluckerMass.lean` [is]

Score: `0.823`

```text
import Mathlib

/-!
# Spinor.PluckerMass

Trusted finite Pluecker-mass identities for visible complex null spinors.

This module packages the algebraic keystone of the null-edge causal graph
program in a non-draft namespace.  A visible null edge is represented by a
complex two-spinor `psi : Fin 2 -> ℂ` and the rank-one Hermitian momentum
matrix `psi psi^dagger`.  The determinant of a finite sum of such null
momenta is exactly the total pairwise squared Pluecker spread

```text
det(sum_i psi_i psi_i^dagger)
  =
sum_{i<j} |psi_i wedge psi_j|^2.
```

The theorem is purely finite-dimensional linear algebra.  It does not assert
a continuum limit, a quantum-measure construction, or a twistor incidence
```

### 10. `PhysicsSM/Spinor/PluckerMass.lean` [det_rankOneHermitian_eq_zero]

Score: `0.823`

```text
theorem det_rankOneHermitian_eq_zero (psi : CSpinor) :
    (rankOneHermitian psi).det = 0 := by
  simp [rankOneHermitian, Matrix.det_fin_two, Matrix.vecMulVec]
  ring

/--
Two-edge Pluecker mass identity.  The determinant of the summed null momenta
is the squared modulus of the spinor wedge.
-/
```

## Scoped paper hits

### 1. Spin on a 4D Feynman Checkerboard

Score: `0.717`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 2. Two-twistor particle models and free massive higher spin fields

Score: `0.711`
Zotero key: `zotero:MFUJKFEA`
arXiv: `1409.7169`
DOI: `10.1007/JHEP04(2015)010`
URL: https://doi.org/10.1007/JHEP04(2015)010

### 3. Massive twistor particle with spin generated by Souriau-Wess-Zumino term and its quantization

Score: `0.709`
Zotero key: `arxiv:1403.4127`
arXiv: `1403.4127`
DOI: `10.1016/j.physletb.2014.04.059`
URL: http://arxiv.org/abs/1403.4127

Abstract:

Two-twistor action for a massive spinning particle with Souriau-Wess-Zumino spin term; includes spin-dependent twistor shift modifying standard Penrose incidence relations.

### 4. Weyl-van der Waerden formalism for helicity amplitudes of massive particles

Score: `0.708`
Zotero key: `986CC8CS`
arXiv: `hep-ph/9805445`
DOI: `10.1103/PhysRevD.59.016007`
URL: https://www.zotero.org/19894138/items/986CC8CS

Abstract:

The Weyl-van-der-Waerden spinor technique for calculating helicity amplitudes of massive and massless particles is presented in a form that is particularly well suited to a direct implementation in computer algebra. Moreover, we explain how to exploit discrete symmetries and how to avoid unphysical poles in amplitudes in practice. The efficiency of the formalism is demonstrated by giving explicit compact results for the helicity amplitudes of the processes gamma gamma -&gt; f fbar, f fbar -&gt; gamma gamma gamma, mu^- mu^+ -&gt; f fbar gamma.
