# Aristotle semantic context pack

Generated: 2026-07-04T15:30:17
Query: `Q2 Q3 TransferHilbertZ2Electric block shift Z2 electric sectors rpBlockMatrix plaquette-bit field`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/quunit-qubit-qutrit-representation-moonshot-aristotle-2026-06-01.md` [Goal]

Score: `0.800`

```text
## Goal

Upgrade the current quunit/qubit/qutrit dictionary from type aliases and block
predicate equivalences to an actual representation-level theorem: the central
`Z6` kernel acts trivially on the qubit-plus-qutrit block representation.

The current trusted module `QunitQubitQutritDictionary` defines:

- `Qunit := Fin 1 -> Complex`;
- `Qubit := Fin 2 -> Complex`;
- `Qutrit := Fin 3 -> Complex`;
- `QubitPlusQutrit := (Fin 2 Sum Fin 3) -> Complex`;
- the split equivalence `QubitPlusQutrit ~= Qubit x Qutrit`;
- the block predicate bridge for `S(U(2) x U(3))`.

The next paper-useful step is to formalize the action itself and show why the
six central phases are invisible on the combined block representation.
```

### 2. `PhysicsSM/Draft/NullEdgeP4ScalarFlipIsotropy.lean` [sigmaZ]

Score: `0.796`

```text
def sigmaZ : CMat2 :=
  !![(1 : Complex), 0; 0, -1]

/--
Scalar plus Pauli-vector chirality-flip block. The scalar coefficient is the
candidate mass; the vector coefficients are anisotropic couplings.
-/
```

### 3. `PhysicsSM/Draft/Sedenions/S3PsiActionAbstract.lean` [psiBlock_sq]

Score: `0.774`

```text
theorem psiBlock_sq (a b : F) :
    psiBlock a b * psiBlock a b =
      !![a ^ 2 - b ^ 2, -(2 * a * b); 2 * a * b, a ^ 2 - b ^ 2] := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [psiBlock] <;> ring!

/-
Under the order-3 hypotheses, the squared block simplifies to the
    transpose/conjugate: `R² = [[a, b], [-b, a]]`.
-/
```

### 4. `AgentTasks/quunit-qubit-qutrit-dictionary-aristotle-2026-06-01.md` [Target declarations]

Score: `0.773`

```text
## Target declarations

Define the three complex state-space aliases:

```lean
abbrev Qunit := Fin 1 -> Complex
abbrev Qubit := Fin 2 -> Complex
abbrev Qutrit := Fin 3 -> Complex
abbrev QubitPlusQutrit := (Fin 2 ⊕ Fin 3) -> Complex
```

Add the block-sum equivalence:

```lean
noncomputable def qubitPlusQutritEquiv :
    QubitPlusQutrit ≃ₗ[Complex] (Qubit × Qutrit) := ...
```

or, if a linear equivalence is too much, an ordinary equivalence plus
coordinate projection/reconstruction theorems.

Record the unitary matrix dimensions:

```lean
theorem quunit_matrix_eq_scalar
    (M : Matrix (Fin 1) (Fin 1) Complex) :
    M = Matrix.diagonal (fun _ : Fin 1 => M 0 0) := ...
```

Prove block facts linking to the existing SM predicate:

```lean
theorem smBlockPredicate_is_qubit_qutrit_block
    {M : GUTMatrix} :
    SMBlockPredicate M <->
      exists A : Matrix (Fin 2) (Fin 2) Complex,
      exists B : Matrix (Fin 3) (Fin 3) Complex,
        M = Matrix.fromBlocks A 0 0 B /\
        IsUnitary A /\ IsUnitary B /\ A.det * B.det = 1 := ...
```

This theorem may just re-export the definition of `SMBlockPredicate` if that is
already definitional.

Add package fields tying the dictionary to the Z6 scaffold:

```lean
structure QunitQubitQutritDictionaryPackage where
  kernel_card : Fintype.card CoveringKernelElt = 6
  unit_kernel_family : Fin 6 -> UnitCoveringKernelElt
  unit_kernel_maps_to_one :
    forall i : Fin 6,
      unitCoveringTripleImageGroupHom
        ((unit_kernel_family i).toUnitCoveringTriple) = 1
  sm_block_iff :
    forall M : GUTMatrix,
      SMBlockPredicate M <->
        exists A : Matrix (Fin 2) (Fin 2) Complex,
        exists B : Matrix (Fin 3) (Fin 3) Complex,
          M = Matrix.fromBlocks A 0 0 B /\
          IsUnitary A /\ IsUnitary B /\ A.det * B.det = 1

non
```

### 5. `PhysicsSM/NullStrand/BellQFT/FiniteCurrent.lean` [quantumCurrent]

Score: `0.772`

```text
def quantumCurrent {Q : Type*} [Fintype Q] (q q' : Q) (psi : Q -> Complex)
    (H : Matrix Q Q Complex) (P : Q -> Matrix Q Q Complex) : Real :=
  2 * Complex.im (vectorInner psi (matVec (P q * H * P q') psi))

/-- A zero block contributes zero Bell current. -/
```

### 6. `PhysicsSM/Draft/NullEdgeP1SU2NormalizedDetInvariance.lean` [CMat2]

Score: `0.772`

```text
abbrev CMat2 := Matrix (Fin 2) (Fin 2) Complex

/-- Visible action of a residual spin frame on a `2 x 2` block. -/
```

### 7. `PhysicsSM/NullStrand/BellQFT/BlockSupport.lean`

Score: `0.771`

```text
namespace PhysicsSM.NullStrand.BellQFT

open Matrix Complex
open scoped BigOperators

/-- The finite Bell current carried by an operator block `B = P q * H * P q'`. -/
```

### 8. `PhysicsSM/Gauge/StandardModelGaugeRepresentationSynthesis.lean`

Score: `0.770`

```text
namespace PhysicsSM.Gauge.QunitQubitQutritDictionary

open Complex Matrix PhysicsSM.Gauge.StandardModelSubgroup
open PhysicsSM.Gauge.GUTSquare PhysicsSM.Gauge.BlockEmbeddings

/-! ## Bundled synthesis package -/

/--
Bundled synthesis package connecting the unit-level Z₆ exact kernel
package to the quotient representation package, with cross-cutting
identity-fiber and block-equivalence compatibility properties.
-/
```

## Scoped paper hits

### 1. Weyl, Dirac and Maxwell Quantum Cellular Automata: analytical solutions and phenomenological predictions of the Quantum Cellular Automata Theory of Free Fields

Score: `0.713`
Zotero key: `KCQGEDJE`
arXiv: `1601.04842`
URL: http://arxiv.org/abs/1601.04842v1

### 2. alpha-z-relative Renyi entropies

Score: `0.710`
Zotero key: `MKJFW9HM`
arXiv: `1310.7178`
DOI: `10.1063/1.4906367`
URL: http://arxiv.org/abs/1310.7178

Abstract:

Defines alpha-z quantum Renyi relative entropies and studies the parameter region where data processing holds.

### 3. An analysis of completely-positive trace-preserving maps on M2

Score: `0.709`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 4. Free quantum field theory from quantum cellular automata: derivation of Weyl, Dirac and Maxwell quantum cellular automata

Score: `0.708`
Zotero key: `BVJBTK8J`
arXiv: `1601.04832`
URL: http://arxiv.org/abs/1601.04832v1

### 5. Momentum bispinor, two-qubit entanglement and twistor space

Score: `0.701`
Zotero key: `3VBEK82X`
arXiv: `1407.2492`
URL: http://arxiv.org/abs/1407.2492

Abstract:

Re-examines massive momentum bispinor symmetry and connects unit-energy future-lightcone geometry with two-qubit entanglement and twistor-space normalization. Important prior-art guardrail for observer-conditioned Pluecker mixedness.
