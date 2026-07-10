# Aristotle semantic context pack

Generated: 2026-07-10T01:02:22
Query: `unitary matrix list product Kronecker parallel history composition`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Algebra/Octonion/G2FixingE111MonoidHom.lean` [matrixActsAsSU3OnC3_one]

Score: `0.833`

```text
theorem matrixActsAsSU3OnC3_one :
    MatrixActsAsSU3OnC3 (1 : Matrix (Fin 3) (Fin 3) ℂ) := by
  rw [← FixingE111MulLinear.one_onComplexVecMatrix]
  exact FixingE111MulLinear.onComplexVecMatrix_actsAsSU3 1

/-- The product of two unitary matrices is unitary. -/
```

### 2. `PhysicsSM/Gauge/StandardModelGroupStructure.lean` [one_eq_fromBlocks]

Score: `0.827`

```text
theorem one_eq_fromBlocks :
    (1 : GUTMatrix) = fromBlocks 1 0 0 1 := by
  ext i j
  by_cases hi : i = j <;> simp_all +decide [Matrix.one_apply]

/-- Unitary matrices are closed under multiplication. -/
```

### 3. `PhysicsSM/Algebra/Octonion/G2FixingE111MonoidHom.lean` [matrixActsUnitaryOnC3_mul]

Score: `0.825`

```text
theorem matrixActsUnitaryOnC3_mul {M N : Matrix (Fin 3) (Fin 3) ℂ}
    (hM : MatrixActsUnitaryOnC3 M) (hN : MatrixActsUnitaryOnC3 N) :
    MatrixActsUnitaryOnC3 (M * N) := by
  intro u v
  simp only [← Matrix.mulVec_mulVec]
  rw [hM, hN]

/-- The product of two SU(3) matrices is SU(3). -/
```

### 4. `PhysicsSM/Gauge/StandardModelProductCoveringTriple.lean` [SUUnitMatrix.instMul]

Score: `0.823`

```text
instance SUUnitMatrix.instMul {n : Type*} [Fintype n] [DecidableEq n] :
    Mul (SUUnitMatrix n) where
  mul x y := ⟨x.unit * y.unit,
    isUnitary_mul x.unitary y.unitary,
    by simp [det_mul, x.det_one, y.det_one]⟩
```

### 5. `PhysicsSM/Gauge/StandardModelCoveringMapSurjective.lean` [unitOfIsUnitary]

Score: `0.820`

```text
noncomputable def unitOfIsUnitary {n : Type*} [Fintype n] [DecidableEq n]
    {M : Matrix n n ℂ} (hM : IsUnitary M) :
    Units (Matrix n n ℂ) :=
  ⟨M, M.conjTranspose,
    by unfold IsUnitary at hM; rw [← mul_eq_one_comm]; exact hM,
    hM⟩
```

### 6. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean`

Score: `0.819`

```text
namespace PhysicsSM.NullStrand.Clock

open Matrix Complex
open scoped BigOperators

/-- Noncommutative ordered product of finite matrix factors, in list order. -/
```

### 7. `PhysicsSM/Gauge/StandardModelUnitZ6QuotientGroup.lean` [matrixScalarUnit_mul]

Score: `0.819`

```text
@[simp] theorem matrixScalarUnit_mul {n : Type} [Fintype n] [DecidableEq n]
    (z w : Units ℂ) :
    @matrixScalarUnit n _ _ (z * w) =
      @matrixScalarUnit n _ _ z * @matrixScalarUnit n _ _ w := by
  exact map_mul _ z w

/-
Scalar units commute with all matrix units.
-/
```

### 8. `PhysicsSM/Draft/NullEdgeQWUnitarity.lean` [Ua_unitary]

Score: `0.811`

```text
theorem Ua_unitary (a k mu : ℝ) :
    IsUnitary2 (Ua a k mu) := by
  unfold IsUnitary2 Ua
  rw [Matrix.conjTranspose_mul, Matrix.mul_assoc,
    ← Matrix.mul_assoc (Rz (k * a)).conjTranspose, Rz_unitary (k * a),
    Matrix.one_mul, Rx_unitary (mu * a)]

end PhysicsSM.Draft.NullEdgeQWUnitarity
```

## Scoped paper hits

### 1. Von Neumann algebra automorphisms and time-thermodynamics relation in generally covariant quantum theories

Score: `0.716`
Zotero key: `I8XNBREW`
DOI: `10.1088/0264-9381/11/12/007`
URL: https://doi.org/10.1088/0264-9381/11/12/007

### 2. Temporal Lorentzian Spectral Triples

Score: `0.714`
Zotero key: `JKDD4KGC`
arXiv: `1210.6575`
DOI: `10.48550/arXiv.1210.6575`
URL: https://arxiv.org/abs/1210.6575

Abstract:

Introduces temporal Lorentzian spectral triples, corresponding to a 3+1 decomposition and global time structure for noncommutative Lorentzian spaces.

### 3. An analysis of completely-positive trace-preserving maps on M2

Score: `0.713`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 4. Dirac-Kahler fermion with noncommutative differential forms on a lattice

Score: `0.707`
Zotero key: `GU9K5KKW`
arXiv: `hep-lat/0309120`
DOI: `10.1016/S0920-5632(03)02740-3`
URL: https://www.zotero.org/19894138/items/GU9K5KKW

Abstract:

Noncommutativity between a differential form and a function allows us to define differential operator satisfying Leibniz's rule on a lattice. We propose a new associative Clifford product defined on the lattice by introducing the noncommutative differential forms. We show that this Clifford product naturally leads to the Dirac-Kahler fermion on the lattice.

### 5. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.705`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039
