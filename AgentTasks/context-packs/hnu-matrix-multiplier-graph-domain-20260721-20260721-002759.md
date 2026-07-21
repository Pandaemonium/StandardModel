# Aristotle semantic context pack

Generated: 2026-07-21T00:28:11
Query: `matrix-valued L2 multiplication operator self-adjoint maximal graph domain massive Dirac HNU Pluecker symbol`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean` [phaseBasis]

Score: `0.827`

```text
def phaseBasis (u : ℂ) : Mat := !![u, 0; 0, 1]

/-- The Pluecker mass operator is Hermitian. -/
```

### 2. `PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean`

Score: `0.826`

```text
import PhysicsSM.Spinor.PluckerMassCovariance

/-!
# The Pluecker-derived finite Dirac mass operator

For two complex null spinors `psi, phi`, their complex Pluecker coordinate
`z = spinorWedge psi phi` defines the odd Hermitian matrix

```text
B(z) = !![0, z; conj z, 0].
```

This module proves that `B(z)^2 = |z|^2 I`, that `B(z)` anticommutes with the
diagonal velocity grading, and hence that the finite Dirac symbol
`H(k,z) = k sigma_z + B(z)` satisfies

```text
H(k,z)^2 = (k^2 + det(twoEdgeMomentum psi phi)) I.
```

The first-order rest gap is therefore `|z|`, while the determinant and every
quadratic cost are `|z|^2`. This removes the need to insert the determinant
itself as an independent first-order Dirac mass parameter.

Multiplying `z` by a unit complex phase conjugates `B(z)` by an explicit
unitary diagonal basis change. Thus the spectrum depends only on the momentum
matrix, although an oriented null decomposition retains a corner phase.

Provenance: clean-room formalization of the operator construction proposed in
the July 2026 manuscript review, built on the trusted Cauchy--Binet/Pluecker
identity in `PhysicsSM.Spinor.PluckerMass`. The construction is finite and
algebraic; no continuum or Standard Model identification is asserted.
-/
```

### 3. `PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean` [pair_diracSymbol_sq]

Score: `0.826`

```text
theorem pair_diracSymbol_sq (psi phi : CSpinor) (k : ℝ) :
    diracSymbol k (spinorWedge psi phi) *
        diracSymbol k (spinorWedge psi phi) =
      (((k ^ 2 : ℝ) : ℂ) + (twoEdgeMomentum psi phi).det) • (1 : Mat) := by
  rw [diracSymbol_sq, two_edge_plucker_mass_identity]

/-- The operator vanishes exactly on the zero-Pluecker locus. -/
```

### 4. `PhysicsSM/Draft/NullEdge/PlueckerHNUIntertwiner.lean`

Score: `0.824`

```text
import PhysicsSM.Draft.NullEdge.HNUInfraredTangent
import PhysicsSM.Draft.NullEdge.PluckerMassOperator
import PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

/-!
# An explicit HNU--Pluecker bridge after four-component doubling

This module composes three existing finite results without reproducing their
definitions.  The HNU endpoint has the infrared tangent `-i q.sigma`; the live
four-component Pluecker operator has the usual massless Dirac kinetic block;
and the two Pluecker rest operators are related by one explicit rectangular
intertwiner `W`.

The scope boundary is essential.  The theorem does **not** derive the Pluecker
coordinate from the HNU endpoint, and it does not make one two-component HNU
Weyl point massive.  Indeed, `singleWeyl_mass_noGo` proves that no nonzero
`2 x 2` matrix anticommutes with all three Pauli velocity generators.  The
compatible mass appears only after passing to the live four-component
Clifford representation.  The displayed `W` is an explicit compatible
embedding; no uniqueness or canonicity claim is made.

Conventions: the Pauli matrices are those of `HNUExactCore`; the four-component
Dirac matrices are those of `Pluecker3Plus1ComplexMass`; and the complex rest
operator is `PluckerMassOperator.massOperator`.  These imported modules already
record their metric, basis, and Pluecker conventions.

Provenance: clean-room integration of the mathematically valid subset of
Aristotle project `f0d38cd0-cdec-46ef-800b-b588e3e07740`, task
`c9f31d7f-a8ae-4ade-9d36-e03b2db004a9`.  The returned file duplicated the live
APIs and described `W` as forced; this integration instead reuses the live APIs
and retains only the proved explicit-existence statement.
-/
```

### 5. `PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean` [massOperator]

Score: `0.823`

```text
def massOperator (z : ℂ) : Mat :=
  !![0, z; (starRingEnd ℂ) z, 0]

/-- The finite one-dimensional Dirac symbol with Pluecker-derived rest term. -/
```

### 6. `PhysicsSM/Draft/NullEdge/GateI1/PluckerSpinorBridge.lean` [plueckerMatrix]

Score: `0.819`

```text
def plueckerMatrix (lam : CSpinor) : Mat2 := Matrix.vecMulVec lam (star lam)

/-- The **two-edge (composite) momentum** of a pair of null spinors:
`P = ψ ψ† + φ φ†`, the sum of the two Plücker matrices. -/
```

### 7. `PhysicsSM/Draft/NullEdge/PluckerMassDynamics.lean` [decomposition_independence]

Score: `0.818`

```text
theorem decomposition_independence (M V : Mat) (hV : V * Vᴴ = 1) :
    (M * V) * (M * V)ᴴ = M * Mᴴ ∧
      (M * V).det = V.det * M.det ∧
      ‖V.det‖ = 1 := by
  refine ⟨?_, ?_, ?_⟩
  · rw [Matrix.conjTranspose_mul]
    rw [show M * V * (Vᴴ * Mᴴ) = M * (V * Vᴴ) * Mᴴ by noncomm_ring]
    rw [hV]
    simp
  · rw [Matrix.det_mul, mul_comm]
  · have hdet : V.det * starRingEnd ℂ (V.det) = 1 := by
      have h := congrArg Matrix.det hV
      rw [Matrix.det_mul, Matrix.det_conjTranspose, Matrix.det_one] at h
      exact h
    have hns : Complex.normSq V.det = 1 := by
      have h := Complex.mul_conj V.det
      rw [hdet] at h
      exact_mod_cast h.symm
    rw [Complex.normSq_eq_norm_sq] at hns
    nlinarith [norm_nonneg V.det, hns]

/-- The exact mass coin generated by the Pluecker rest operator. -/
```

### 8. `PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean`

Score: `0.812`

```text
namespace PhysicsSM.Draft.NullEdge.PluckerMassOperator

open Matrix Complex
open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Spinor.PluckerMassCovariance

/-- Complex `2 x 2` matrices used by the finite Dirac symbol. -/
```

## Scoped paper hits

### 1. Equivalence of lattice operators and graph matrices

Score: `0.764`
Zotero key: `Z2DPSX6K`
arXiv: `2311.11320`
URL: https://arxiv.org/abs/2311.11320

Abstract:

We explore the relationship between lattice field theory and graph theory, placing special emphasis on the interplay between Dirac and scalar lattice operators and matrices within spectral graph theory. The paper introduces an anti-symmetrized adjacency matrix for cycle digraphs and directed paths, and relates graph Laplacians, Wilson terms, and lattice Dirac operators.

### 2. Locality properties of Neuberger's lattice Dirac operator

Score: `0.762`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 3. Laplace and Dirac Operators on Graphs

Score: `0.760`
Zotero key: `WW6TKVH8`
arXiv: `2203.02782`
URL: https://www.zotero.org/19894138/items/WW6TKVH8

Abstract:

Discrete versions of the Laplace and Dirac operators studied in the context of combinatorial models of statistical mechanics and quantum field theory. Introduces several variations of the Laplace and Dirac operators on graphs and investigates graph-theoretic versions of the Schroedinger and Dirac equation, with a combinatorial interpretation for solutions, and proves gluing identities for the Dirac operator on lattice graphs as well as for graph Clifford algebras.

### 4. Matching number, Hamiltonian graphs and magnetic Laplacian matrices

Score: `0.752`
Zotero key: `GNEARI9Q`
arXiv: `2010.08828`
DOI: `10.1016/j.laa.2022.02.006`
URL: https://doi.org/10.1016/j.laa.2022.02.006

### 5. The generalized Lichnerowicz formula and analysis of Dirac operators

Score: `0.733`
Zotero key: `BQJAG9TR`
arXiv: `hep-th/9503153`
URL: http://arxiv.org/abs/hep-th/9503153v1

Abstract:

Generalized Lichnerowicz formula for Dirac operator squares, with applications to gravity and Yang-Mills actions from Dirac operators.
