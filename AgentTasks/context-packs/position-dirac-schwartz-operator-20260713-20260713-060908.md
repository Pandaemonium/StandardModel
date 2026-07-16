# Aristotle semantic context pack

Generated: 2026-07-13T06:09:13
Query: `Schwartz spinor position Dirac continuous linear operator Fourier symbol minus i over two pi`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/DiracOperatorMassShellDet.lean`

Score: `0.814`

```text
import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

/-!
# The Dirac-operator determinant: `det(pslash - m·1) = (m² - p²)²` (the 4-spinor mass shell)

The program characterizes mass by a determinant in two complementary places. At the
little-group level, the 2×2 spinor matrix `P(p) = p·σ` has `det P = m²`
(`PauliMomentumPhysLean`, `SigmaMapNullEdges`). This module proves the 4-SPINOR
companion: the characteristic determinant of the full Dirac operator
`D = pslash - m·1`.

Because `pslash² = (E² - kz²)·1`, the operator `pslash` has characteristic
polynomial `(X² - (E²-kz²))²`, so the determinant is a PERFECT SQUARE and the
square root cancels — everything is rational, no `Real.sqrt`:

  `det(pslash - m·1) = (m² - E² + kz²)²`   (`= (m² - p²)²`, `p² = E² - kz²`).

On the mass shell (`E² - kz² = m²`) this is `0` — the Dirac operator is singular
EXACTLY on the shell; off shell it is a positive square and `D` is invertible.
This is the dispersion relation, and it realizes the program's determinant-level
mass-shell test `det D(q) = 0` (the object a genuine, non-doubled mode must satisfy;
see `docs/NULLSTRAND.md`).

Honest scope: the real `(t,z)`-restricted rational avatar of the Dirac dispersion
relation, as finite kernel-checked matrix algebra. The `[import]` physics is the
standard Dirac dispersion `det(pslash - m) ∝ (p² - m²)²`; it complements — but is a
SEPARATE object from — the 2×2 little-group `det P = m²` (`massless_det` records the
`m=0` value `(E²-kz²)² = (det P)²` as interpretation only, not a claim that the two
matrices coincide).

Provenance: PhysLean's Dirac-representation gamma convention (`spaceTime.gamma`),
used as a REFERENCE only, NOT imported. Draft status: kernel-checked with no proof
```

### 2. `PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean` [diracSymbol_sq]

Score: `0.813`

```text
theorem diracSymbol_sq (k : ℝ) (z : ℂ) :
    diracSymbol k z * diracSymbol k z =
      (((k ^ 2 : ℝ) : ℂ) + complexAbsSq z) • (1 : Mat) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [diracSymbol, velocity, massOperator, complexAbsSq,
      Matrix.mul_apply] <;> ring

/-- For a pair of null spinors, the squared mass operator is exactly the
determinant of their summed Hermitian momentum. -/
```

### 3. `PhysicsSM/Draft/NullEdge/GateC1/TetraOperatorOverlapGW.lean` [fourierUnitary_signHfree]

Score: `0.808`

```text
theorem fourierUnitary_signHfree
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi : SiteN N → Spin → ℂ) (m : MomN N) :
    fourierUnitary N (signHfree N gamma5 D a r rho Psi) m =
      (signSymbol gamma5 D a r rho (kOfMom N m)).mulVec
        (fourierUnitary N Psi m) := by
  unfold signHfree
  rw [fourierUnitary_fourierUnitaryInv]

/-- **The operator sign squares to the identity**: `signHfree` is an involution.

This is the operator-level counterpart of the elementary symbol involution
`signSymbol_sq`.  It uses the block diagonalization (`fourierUnitary_signHfree`),
the per-momentum involution (`signSymbol_sq`), and injectivity of the Fourier
transform (its inverse round trip). -/
```

### 4. `PhysicsSM/Draft/NullEdge/GateC1/TetraOperatorOverlapGW.lean` [fourierUnitary_DovOp]

Score: `0.807`

```text
theorem fourierUnitary_DovOp
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi : SiteN N → Spin → ℂ) (m : MomN N) :
    fourierUnitary N (DovOp N gamma5 D a r rho Psi) m =
      (Dov gamma5 (signSymbol gamma5 D a r rho (kOfMom N m))).mulVec
        (fourierUnitary N Psi m) := by
  unfold DovOp Gamma5op Dov
  rw [fourierUnitary_piAdd, fourierUnitary_matrixFieldAction,
    fourierUnitary_signHfree, Matrix.mulVec_mulVec, Matrix.add_mulVec,
    Matrix.one_mulVec]

/-- **Operator-level Ginsparg-Wilson relation.**

The real-space overlap Dirac operator `Dov = 1 + Gamma5 . signHfree` satisfies
the Ginsparg-Wilson relation

    Gamma5 (Dov Psi) + Dov (Gamma5 Psi) = Dov (Gamma5 (Dov Psi))

for a Hermitian unitary chirality `gamma5` anticommuting with the kinetic slash,
throughout the first Wilson band.  Proved by transporting to momentum space
(where `DovOp` block-diagonalizes to the symbol `Dov`) and applying the
per-momentum `symbol_ginsparg_wilson`, then Fourier injectivity - the same
pattern as `signHfree_involutive`.  This lifts the symbol-level chiral release
to the real-space operator. -/
```

### 5. `PhysicsSM/Draft/NullEdge/GateC1/TetraFreeOperator.lean` [fourierUnitary_kineticSlashField_trig]

Score: `0.804`

```text
theorem fourierUnitary_kineticSlashField_trig
    (D : TetraEuclideanSlashData Spin)
    (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (kineticSlashField N D Psi) m =
      (Complex.I • TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m))).mulVec
        (fourierUnitary N Psi m) := by
  unfold kineticSlashField
  rw [fourierUnitary_finset_sum N Finset.univ
    (fun A =>
      scalarFieldAction N (1 / 2 : ℂ)
        (matrixFieldAction N (D.B A) (centeredTransportDiff N A Psi))) m]
  funext s
  have hsum :
      ∑ A : Fin 4,
          fourierUnitary N
            (scalarFieldAction N (1 / 2 : ℂ)
              (matrixFieldAction N (D.B A) (centeredTransportDiff N A Psi))) m s
        =
      ∑ A : Fin 4,
        (1 / 2 : ℂ) *
          ((D.B A).mulVec
            (fun t =>
              (2 * (Real.sin ((kOfMom N m) A) : ℂ) * Complex.I) *
                fourierUnitary N Psi m t)) s := by
    apply Finset.sum_congr rfl
    intro A _hA
    rw [fourierUnitary_scalarFieldAction]
    rw [fourierUnitary_matrixFieldAction]
    rw [fourierUnitary_centeredTransportDiff_trig]
  rw [hsum]
  simp +decide [TetraEuclideanSlashData.Q, Matrix.mulVec, dotProduct,
    sinCoeffs, kOfMom,
    Finset.mul_sum, Finset.sum_mul, mul_assoc, mul_left_comm, mul_comm]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro t _ht
  trans
    ∑ A : Fin 4,
      (Complex.I * fourierUnitary N Psi m t) *
        (Complex.sin ((kAngle N m A : ℝ) : ℂ) * D.B A s t)
  · apply Finset.sum_congr rfl
    intro A _hA
    ring
  · rw [← Finset.mul_sum]
    have hentry :
        (∑ A : Fin 4, Complex.sin ((kAngle N m A : ℝ) : ℂ) • D.B A) s t =
          ∑ A : Fin 4, Complex.sin ((kAngle N m A : ℝ) : ℂ) * D.B A s t := by
      rfl
    rw [hentry]
    ring_nf

/-- Real-space finite/free Wilson ke
```

### 6. `PhysicsSM/Draft/NullEdge/GateC1/TetraFreeOperator.lean` [fourierUnitary_Hfree_trig]

Score: `0.804`

```text
theorem fourierUnitary_Hfree_trig
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (Hfree N gamma5 D a r rho Psi) m =
      (TetraScalarWilsonSymbol.H gamma5 D a r rho (kOfMom N m)).mulVec
        (fourierUnitary N Psi m) := by
  unfold Hfree
  rw [fourierUnitary_matrixFieldAction_Kfree_trig]
  rfl

end Slash

end TetraFreeOperator
end GateC1
end NullEdge
end Draft
end PhysicsSM
```

### 7. `PhysicsSM/Draft/NullEdge/GateC1/TetraFreeOperator.lean` [kineticSlashField]

Score: `0.803`

```text
def kineticSlashField (D : TetraEuclideanSlashData Spin)
    (Psi : SiteN N -> Spin -> ℂ) : SiteN N -> Spin -> ℂ :=
  fun x s =>
    ∑ A : Fin 4,
      scalarFieldAction N (1 / 2 : ℂ)
        (matrixFieldAction N (D.B A) (centeredTransportDiff N A Psi)) x s

/-- Normalized Fourier diagonalization of the real-space kinetic slash field.

This is the kinetic half of the finite/free symbol-intertwining theorem:
the centered transport differences become the symbol
`i Q(sin(k))`. -/
```

### 8. `AgentTasks/overnight-allmass-run-2026-07-09/harvest/dirac-operator-massshell-det/739f5708-fa03-45e2-9c29-9101c6ee8152_aristotle/ARISTOTLE_SUMMARY.md` [DiracOperatorMassShellDet — the 4-spinor Dirac-operator determinant face of mass]

Score: `0.802`

```text
# DiracOperatorMassShellDet — the 4-spinor Dirac-operator determinant face of mass
```

## Scoped paper hits

No paper hits returned.
