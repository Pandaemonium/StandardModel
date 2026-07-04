# Aristotle semantic context pack

Generated: 2026-07-04T14:37:04
Query: `Q2 Q3 TransferHilbertBlock rpBlockMatrix center shift covariance KernelCommutesShifts C x A ShiftSystem`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeDirectOverlapSingularCrossing.lean` [X]

Score: `0.784`

```text
def X (x : V) : V := shiftedKernel S.D S.W S.r S.rho S.q x
```

### 2. `PhysicsSM/Draft/NullEdgeDirectOverlapSingularCrossing.lean`

Score: `0.777`

```text
@[simp] theorem X_def (x : V) : S.X x = S.D S.q x + (S.r * S.W S.q - S.rho) * x :=
  rfl

/-- The shifted kernel is **singular** if it annihilates a nonzero vector. -/
```

### 3. `PhysicsSM/Draft/NullEdgeDirectOverlapSingularCrossing.lean` [shiftedKernel]

Score: `0.777`

```text
def shiftedKernel [AddCommGroup V] [Module Real V]
    (D : Q -> V -> V) (W : Q -> Real) (r rho : Real) (q : Q) (x : V) : V :=
  D q x + (r * W q - rho) * x

/-- **Core algebraic fact.** If `v` is a zero mode of the bare operator,
`D q v = 0`, and the Wilson value sits exactly on the mass shell,
`r * W q = rho`, then `v` is annihilated by the shifted overlap sign kernel. -/
```

### 4. `PhysicsSM/Gauge/BlockEmbeddings.lean` [sixKernelElements]

Score: `0.771`

```text
noncomputable def sixKernelElements : Fin 6 -> KernelElement :=
  fun k => <kernelPhases k, kernelPhases_pow_six k>

/-! ## Block embedding as the covering map -/

/--
The covering homomorphism `U(1) x SU(2) x SU(3) -> SU(2) x SU(4)`:
  `(alpha, g, h) |-> (g, block_diag(alpha * h, alpha-^3))`

The SU(2) factor passes through unchanged; the SU(4) factor is the
block-diagonal matrix with upper-left block `alpha * h` and lower-right
entry `alpha-^3`.
-/
```

### 5. `PhysicsSM/Gauge/QunitQubitQutritDictionary.lean` [QunitQubitQutritDictionaryPackage]

Score: `0.770`

```text
structure QunitQubitQutritDictionaryPackage where
  /-- The covering kernel has exactly six elements. -/
  kernel_card : Fintype.card CoveringKernelElt = 6
  /-- The six unit-level kernel elements. -/
  unit_kernel_family : Fin 6 -> UnitCoveringKernelElt
  /-- Each unit kernel element maps to the identity under the covering
      image homomorphism. -/
  unit_kernel_maps_to_one :
    forall i : Fin 6,
      unitCoveringTripleImageGroupHom
        ((unit_kernel_family i).toUnitCoveringTriple) = 1
  /-- `SMBlockPredicate` is the qubit/qutrit block decomposition. -/
  sm_block_iff :
    forall M : GUTMatrix,
      SMBlockPredicate M <->
        exists A : Matrix (Fin 2) (Fin 2) Complex,
        exists B : Matrix (Fin 3) (Fin 3) Complex,
          M = Matrix.fromBlocks A 0 0 B /\
          IsUnitary A /\ IsUnitary B /\ A.det * B.det = 1

/-- The quunit/qubit/qutrit dictionary package, instantiated from
individually verified project theorems. -/
```

### 6. `PhysicsSM/Draft/NullEdgeP9BlockAliasingGuardrail.lean` [rankOneKernel4]

Score: `0.768`

```text
def rankOneKernel4 (x : Vec4) : Fin 4 -> Fin 4 -> Real :=
  fun i j => x i * x j

/-- The one-cell coarse trace after applying the block-average row. -/
```

### 7. `PhysicsSM/Draft/Hamming844SystematicNoNativeAristotle.lean` [parity_permuted_eq_canonical]

Score: `0.768`

```text
theorem parity_permuted_eq_canonical (tau : Equiv.Perm (Fin 4))
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hP : forall i : Fin 4, systematicParityRow P i = complementSingleZero (tau i)) :
    forall i j : Fin 4, P i (tau j) = canonicalP i j := by
  simp_all +decide [ funext_iff, Fin.forall_fin_succ ];
  fin_cases tau <;> simp +decide [ systematicParityRow, complementSingleZero ] at hP |-;
  all_goals simp +decide [ hP, Equiv.swap_apply_def ] ;

/-
Block-permuting a systematic codeword by `blockPerm tau.symm` permutes the
parity columns by `tau`.
-/
```

### 8. `PhysicsSM/Gauge/GUTSquare.lean` [fromBlocks_mul_zero_off_diag]

Score: `0.763`

```text
theorem fromBlocks_mul_zero_off_diag
    (A1 A2 : Matrix (Fin 2) (Fin 2) Complex) (B1 B2 : Matrix (Fin 3) (Fin 3) Complex) :
    fromBlocks A1 0 0 B1 * fromBlocks A2 0 0 B2 =
    fromBlocks (A1 * A2) 0 0 (B1 * B2) := by
  ext (i | i) (j | j) <;>
    simp [fromBlocks, mul_apply, Fintype.sum_sum_type]

/--
The conjugate transpose of a block-diagonal matrix (with zero off-diagonal
blocks) is block-diagonal with conjugate-transposed blocks.
-/
```

## Scoped paper hits

### 1. An analysis of completely-positive trace-preserving maps on M2

Score: `0.715`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 2. Toward a spectral theory of cellular sheaves

Score: `0.688`
Zotero key: `CWXAFIF4`
DOI: `10.1007/s41468-019-00038-7`
URL: https://doi.org/10.1007/s41468-019-00038-7

### 3. Connecting the discrete- and continuous-time quantum walks

Score: `0.680`
Zotero key: `XK9ZRDNJ`
DOI: `10.1103/physreva.74.030301`
URL: https://doi.org/10.1103/physreva.74.030301

### 4. Weyl, Dirac and Maxwell Quantum Cellular Automata: analytical solutions and phenomenological predictions of the Quantum Cellular Automata Theory of Free Fields

Score: `0.680`
Zotero key: `KCQGEDJE`
arXiv: `1601.04842`
URL: http://arxiv.org/abs/1601.04842v1

### 5. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.680`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039
