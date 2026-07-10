# Aristotle semantic context pack

Generated: 2026-07-10T00:18:56
Query: `history operator list product append conjugate transpose reverse Kronecker parallel monoidal dagger`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean`

Score: `0.807`

```text
namespace PhysicsSM.NullStrand.Clock

open Matrix Complex
open scoped BigOperators

/-- Noncommutative ordered product of finite matrix factors, in list order. -/
```

### 2. `PhysicsSM/Algebra/Jordan/StabilizerDerivation.lean` [jordanProduct_add_right]

Score: `0.791`

```text
theorem jordanProduct_add_right (a b c : H3O) :
    a ○ (b + c) = a ○ b + a ○ c := by
  rw [jordanProduct_comm a (b + c), jordanProduct_add_left,
      jordanProduct_comm b a, jordanProduct_comm c a]

set_option maxHeartbeats 800000 in
-- The off-diagonal octonion coordinate expressions are large after expansion.
/--
The Jordan product scales in the left argument.
-/
```

### 3. `PhysicsSM/Draft/NullEdgeSuperDiracBlockCore.lean`

Score: `0.789`

```text
namespace PhysicsSM.Draft.NullEdgeSuperDiracCore

open Matrix Complex

variable {L R : Type*} [Fintype L] [Fintype R]

/-- Off-diagonal operator on a finite `L ⊕ R` space. -/
```

### 4. `PhysicsSM/Draft/NullEdgeP2ReflectionProductDetParity.lean` [det2_mul_two_branchReflections_eq_one_on_massShell]

Score: `0.789`

```text
theorem det2_mul_two_branchReflections_eq_one_on_massShell
    (h1 p1 m1 E1 h2 p2 m2 E2 : Real)
    (hh1 : h1 * h1 = 1) (hE10 : E1 ≠ 0)
    (hshell1 : E1 ^ 2 = p1 ^ 2 + m1 ^ 2)
    (hh2 : h2 * h2 = 1) (hE20 : E2 ≠ 0)
    (hshell2 : E2 ^ 2 = p2 ^ 2 + m2 ^ 2) :
    det2 (branchReflection h1 p1 m1 E1 * branchReflection h2 p2 m2 E2) = 1 := by
  rw [det2_mul]
  rw [branchReflection_det2_eq_neg_one_on_massShell h1 p1 m1 E1 hh1 hE10 hshell1]
  rw [branchReflection_det2_eq_neg_one_on_massShell h2 p2 m2 E2 hh2 hE20 hshell2]
  norm_num

/-- Product of a list of matrices. -/
```

### 5. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean` [internalHolonomy_concat]

Score: `0.788`

```text
theorem internalHolonomy_concat {d : Type*} [Fintype d] [DecidableEq d]
    (left right : List (Matrix d d ℂ)) :
    internalHolonomy (left ++ right) = internalHolonomy left * internalHolonomy right := by
  simp [internalHolonomy, List.prod_append]

/-- If each step is `exp (-I * Δs * H)` with Hermitian `H`, the finite holonomy is unitary. -/
```

### 6. `PhysicsSM/Draft/NullEdgeSuperDiracBlockCore.lean` [chirality_anticommutes_offDiagonal]

Score: `0.788`

```text
theorem chirality_anticommutes_offDiagonal [DecidableEq L] [DecidableEq R]
    (phi : Matrix R L Complex) (psi : Matrix L R Complex) :
    chirality * offDiagonal phi psi + offDiagonal phi psi * chirality = 0 := by
  ext x y
  cases x <;> cases y <;>
    simp +decide [chirality, offDiagonal, Matrix.mul_apply, Fintype.sum_sum_type]

/-- The canonical self-adjoint odd operator attached to a rectangular map. -/
```

### 7. `PhysicsSM/Draft/NullEdgeSuperconnectionCrossTermHiggsKinetic.lean`

Score: `0.787`

```text
namespace PhysicsSM.Draft.NullEdgeSuperconnectionCrossTermHiggsKinetic

open Matrix Complex

variable {L R : Type*} [Fintype L] [Fintype R]

/-- Off-diagonal operator on a finite `L plus R` space. -/
```

### 8. `PhysicsSM/Algebra/Division/CayleyDickson.lean` [star_star_eq]

Score: `0.786`

```text
theorem star_star_eq (x : CayleyDickson A) : star (star x) = x := by
  ext <;> simp [star_star]

/-- Conjugation distributes over addition. -/
```

## Scoped paper hits

### 1. An analysis of completely-positive trace-preserving maps on M2

Score: `0.735`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 2. Von Neumann algebra automorphisms and time-thermodynamics relation in generally covariant quantum theories

Score: `0.732`
Zotero key: `I8XNBREW`
DOI: `10.1088/0264-9381/11/12/007`
URL: https://doi.org/10.1088/0264-9381/11/12/007

### 3. On Noncommutative and semi-Riemannian Geometry

Score: `0.725`
Zotero key: `F877GT5B`
arXiv: `math-ph/0110001`
DOI: `10.48550/arXiv.math-ph/0110001`
URL: https://arxiv.org/abs/math-ph/0110001

Abstract:

Introduces semi-Riemannian spectral triples using Krein spaces and Krein-selfadjoint Dirac operators, with recovery of signature data from spectral data.

### 4. Equivalence of lattice operators and graph matrices

Score: `0.716`
Zotero key: `Z2DPSX6K`
arXiv: `2311.11320`
URL: https://arxiv.org/abs/2311.11320

Abstract:

We explore the relationship between lattice field theory and graph theory, placing special emphasis on the interplay between Dirac and scalar lattice operators and matrices within spectral graph theory. The paper introduces an anti-symmetrized adjacency matrix for cycle digraphs and directed paths, and relates graph Laplacians, Wilson terms, and lattice Dirac operators.

### 5. Temporal Lorentzian Spectral Triples

Score: `0.716`
Zotero key: `JKDD4KGC`
arXiv: `1210.6575`
DOI: `10.48550/arXiv.1210.6575`
URL: https://arxiv.org/abs/1210.6575

Abstract:

Introduces temporal Lorentzian spectral triples, corresponding to a 3+1 decomposition and global time structure for noncommutative Lorentzian spaces.
