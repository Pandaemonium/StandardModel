# Aristotle semantic context pack

Generated: 2026-07-17T22:12:25
Query: `matrix exponential of a mostly-minus Lorentz Lie algebra generator is eta-Lorentz with determinant one and supplies a proper Lorentz link curve`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/LorentzBivectorLieAlgebraBridge.lean` [lorentzGenerator]

Score: `0.868`

```text
def lorentzGenerator (bivector : Fiber 6) : Matrix (Fin 4) (Fin 4) Real :=
  bivectorMatrix bivector * MinkowskiConvention.eta

/-- Matrix form of the mostly-minus Lorentz Lie-algebra condition. -/
```

### 2. `AgentTasks/context-packs/sl2c-lorentz-exact-kernel-20260716-20260716-141602.md` [print axioms PhysicsSM.Draft.NullEdge.SL2CLorentzAction.pauliHermitianEquiv_hermitianCoords]

Score: `0.857`

```text
#print axioms PhysicsSM.Draft.NullEdge.SL2CLorentzAction.pauliHermitianEquiv_hermitianCoords

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CLorentzAction.sl2LorentzMatrix_isEtaLorentz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
```

### 3. `PhysicsSM/Draft/NullEdge/LorentzAtlasStructureGroup.lean` [EtaLorentzGroup]

Score: `0.850`

```text
def EtaLorentzGroup : Subgroup (GL (Fin 4) Real) where
  carrier := {g | IsEtaLorentz (g : Matrix (Fin 4) (Fin 4) Real)}
  one_mem' := by
    simp [IsEtaLorentz]
  mul_mem' := by
    intro g h hg hh
    change IsEtaLorentz
      ((g : Matrix (Fin 4) (Fin 4) Real) *
        (h : Matrix (Fin 4) (Fin 4) Real))
    exact isEtaLorentz_mul _ _ hg hh
  inv_mem' := by
    intro g hg
    let A : Matrix (Fin 4) (Fin 4) Real := g
    let B : Matrix (Fin 4) (Fin 4) Real :=
      ((g⁻¹ : GL (Fin 4) Real) : Matrix (Fin 4) (Fin 4) Real)
    have hAB : A * B = 1 := by
      change (g : Matrix (Fin 4) (Fin 4) Real) *
        ((g⁻¹ : GL (Fin 4) Real) : Matrix (Fin 4) (Fin 4) Real) = 1
      exact congrArg
        (fun u : GL (Fin 4) Real =>
          (u : Matrix (Fin 4) (Fin 4) Real))
        (mul_inv_cancel g)
    change IsEtaLorentz
      (((g⁻¹ : GL (Fin 4) Real) : Matrix (Fin 4) (Fin 4) Real))
    change IsEtaLorentz B
    unfold IsEtaLorentz
    calc
      B.transpose * MinkowskiConvention.eta * B =
          B.transpose *
            ((A.transpose * MinkowskiConvention.eta) * A) * B := by
        rw [hg]
      _ = (B.transpose * A.transpose) * MinkowskiConvention.eta *
          (A * B) := by
        simp only [Matrix.mul_assoc]
      _ = (A * B).transpose * MinkowskiConvention.eta * (A * B) := by
        rw [Matrix.transpose_mul]
      _ = MinkowskiConvention.eta := by
        rw [hAB]
        simp

/-- The underlying concrete matrix of a bundled eta-Lorentz element. -/
```

### 4. `PhysicsSM/Draft/NullEdge/SL2CLorentzAction.lean` [sl2LorentzMatrix_det_one]

Score: `0.850`

```text
theorem sl2LorentzMatrix_det_one (A : SL2C) :
    (sl2LorentzMatrix A).det = 1 := by
  rw [<- explicitSL2LorentzMatrix_eq_sl2LorentzMatrix]
  unfold explicitSL2LorentzMatrix
  convert det_hermitianCongruence A.val using 1
  simp +decide [Matrix.SpecialLinearGroup.det_coe A]

/-- The induced four-by-four matrix is eta-Lorentz. -/
```

### 5. `PhysicsSM/Draft/NullEdge/LorentzAtlasStructureGroup.lean` [matrixUnitOfIsEtaLorentz]

Score: `0.847`

```text
def matrixUnitOfIsEtaLorentz
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M) :
    GL (Fin 4) Real where
  val := M
  inv := etaAdjoint M
  val_inv := mul_etaAdjoint M hM
  inv_val := etaAdjoint_mul M hM
```

### 6. `PhysicsSM/Draft/NullEdge/SL2CLorentzAction.lean` [determinantCharacter_sl2ToEtaLorentz]

Score: `0.836`

```text
theorem determinantCharacter_sl2ToEtaLorentz (A : SL2C) :
    determinantCharacter (sl2ToEtaLorentz A) = 1 := by
  apply (determinantCharacter_eq_one_iff (sl2ToEtaLorentz A)).mpr
  change 0 <= (sl2LorentzMatrix A).det
  rw [sl2LorentzMatrix_det_one]
  norm_num

/-- Every image matrix belongs to the proper-orthochronous Lorentz component. -/
```

### 7. `PhysicsSM/Draft/NullEdge/SL2CLorentzAction.lean` [sl2LorentzMatrix_isEtaLorentz]

Score: `0.836`

```text
theorem sl2LorentzMatrix_isEtaLorentz (A : SL2C) :
    IsEtaLorentz (sl2LorentzMatrix A) := by
  unfold IsEtaLorentz
  ext i j
  have hinner := sl2LorentzLinear_preserves_minkowskiInner A
    ((Pi.basisFun Real (Fin 4)) i) ((Pi.basisFun Real (Fin 4)) j)
  rw [<- sl2LorentzMatrix_mulVec A,
    <- sl2LorentzMatrix_mulVec A] at hinner
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.mulVec, Fin.sum_univ_four,
      MinkowskiConvention.eta, minkowskiInner, Pi.basisFun_apply]
      at hinner ⊢
  all_goals linarith

/-- The identity spin matrix induces the identity Lorentz matrix. -/
```

### 8. `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniResponse.lean`

Score: `0.835`

```text
namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniResponse

open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent

/-- Identity matrix transport satisfies the eta-Lorentz link hypothesis. -/
```

## Scoped paper hits

### 1. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.731`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 2. Temporal Lorentzian Spectral Triples

Score: `0.726`
Zotero key: `JKDD4KGC`
arXiv: `1210.6575`
DOI: `10.48550/arXiv.1210.6575`
URL: https://arxiv.org/abs/1210.6575

Abstract:

Introduces temporal Lorentzian spectral triples, corresponding to a 3+1 decomposition and global time structure for noncommutative Lorentzian spaces.

### 3. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.719`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 4. Connections on non-abelian Gerbes and their Holonomy

Score: `0.717`
URL: http://arxiv.org/abs/0808.1923
