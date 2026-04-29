/-!
# PhysicsSM Prelude

Orientation file for the PhysicsSM formalization project. This module documents
the available mathlib infrastructure and project-wide conventions. It does not
import all of mathlib — individual modules should import only what they need.

## Project conventions

### Scalar fields
- Division algebra content uses `ℝ` unless otherwise stated.
- Complexification is explicit: use `ℂ` or tensor with `ℂ` as needed.
- Do not silently pass between real and complex forms.

### Notation
- Octonion multiplication is never silently assumed associative.
- Parenthesization must be explicit in octonion statements.
- Metric signature is always stated explicitly: `(p, q)` or `(+, -, -, -)`, etc.
- Gamma matrix conventions (Weyl/Dirac/Majorana, Euclidean/Minkowski) are parameters,
  not global choices.

### Namespaces
Every declaration lives under a `PhysicsSM` sub-namespace matching its file location:
- `PhysicsSM.Algebra.Octonion`
- `PhysicsSM.Lie.Exceptional`
- `PhysicsSM.StandardModel`
- etc.

### Provenance
Every nontrivial definition or theorem should cite its source in its docstring.
Use `Provenance: clean-room formalization from <source>` or
`Provenance: adapted from <source> under <license>`.

## Available mathlib infrastructure

The following mathlib modules are directly relevant. Import them individually
in files that need them.

### Lie algebras and root systems
```
import Mathlib.Algebra.Lie.Basic
import Mathlib.Algebra.Lie.Abelian
import Mathlib.Algebra.Lie.Semisimple.Basic
import Mathlib.Algebra.Lie.Weights.Basic
import Mathlib.Algebra.Lie.Weights.RootSystem
import Mathlib.LinearAlgebra.RootSystem.Basic
import Mathlib.LinearAlgebra.RootSystem.Finite.Lemmas
import Mathlib.LinearAlgebra.RootSystem.Finite.G2
```

### Clifford algebras and spin
```
import Mathlib.LinearAlgebra.CliffordAlgebra.Basic
import Mathlib.LinearAlgebra.CliffordAlgebra.EvenOdd
import Mathlib.LinearAlgebra.CliffordAlgebra.SpinGroup
import Mathlib.LinearAlgebra.CliffordAlgebra.Contraction
import Mathlib.LinearAlgebra.CliffordAlgebra.Fold
```

### Quadratic forms and bilinear forms
```
import Mathlib.LinearAlgebra.QuadraticForm.Basic
import Mathlib.LinearAlgebra.QuadraticForm.Isometry
import Mathlib.LinearAlgebra.BilinearMap
import Mathlib.LinearAlgebra.Matrix.BilinearForm
```

### Representation theory
```
import Mathlib.RepresentationTheory.Basic
import Mathlib.RepresentationTheory.Character
import Mathlib.RepresentationTheory.FDRep
import Mathlib.RepresentationTheory.Maschke
```

### Quaternions (mathlib-native)
```
import Mathlib.Analysis.Quaternion
import Mathlib.LinearAlgebra.Quaternion
```

### Algebra foundations
```
import Mathlib.Algebra.Algebra.Basic
import Mathlib.Algebra.Star.Basic
import Mathlib.RingTheory.TensorProduct.Basic
import Mathlib.LinearAlgebra.Matrix.DotProduct
```

### Group theory
```
import Mathlib.GroupTheory.GroupAction.Basic
import Mathlib.Algebra.Group.Hom.Basic
import Mathlib.LinearAlgebra.GeneralLinearGroup.Basic
```

## Module map

```
PhysicsSM/
  Prelude.lean            ← this file
  Meta/
    NoSorry.lean          ← lint utilities
    SourceTrace.lean      ← provenance metadata support
    OracleCheck.lean      ← oracle fixture interfaces
  Algebra/
    Division/
      Basic.lean          ← normed division algebra axioms
      CayleyDickson.lean  ← generic doubling construction
      QuaternionBridge.lean ← bridge to Mathlib.LinearAlgebra.Quaternion
    Octonion/
      Basic.lean          ← Octonion type, multiplication table
      Conjugation.lean    ← conjugation involution
      Norm.lean           ← normSq, norm multiplicativity
      Alternativity.lean  ← left/right alternative laws
      Moufang.lean        ← Moufang identities
    Jordan/
      H3O.lean            ← 3×3 octonionic Hermitian matrices (exceptional Jordan)
  Clifford/
    Basic.lean            ← Clifford algebra conventions over this project
    GammaMatrices.lean    ← concrete gamma matrix families
    Even.lean             ← even subalgebra and spinors
  Spinor/
    Basic.lean            ← spinor conventions
    Weyl.lean             ← Weyl (chiral) spinors
    Dirac.lean            ← Dirac spinors
    Majorana.lean         ← Majorana conditions
  Lie/
    Cartan.lean           ← Cartan type data and notation
    RootData.lean         ← project root system wrappers
    Weights.lean          ← weight lattice and representations
    Branching.lean        ← branching rule interfaces
    Exceptional/
      G2.lean             ← G₂ root data and octonion automorphism connection
      E8.lean             ← E₈ root data, rank, root count, Cartan determinant
      Triality.lean       ← finite D4 Cartan-matrix triality cycle
      OctonionSymmetry.lean ← dot product and imaginary-octonion primitives
  Gauge/
    U1.lean               ← U(1) gauge algebra
    SU2.lean              ← SU(2) gauge algebra
    SU3.lean              ← SU(3) gauge algebra
    StandardModel.lean    ← SU(3)×SU(2)×U(1) gauge structure
  StandardModel/
    QuantumNumbers.lean   ← quantum number types and conventions
    Fermions.lean         ← fermion representation data
    Bosons.lean           ← boson representation data
    Representations.lean  ← full SM representation content
    Charges.lean          ← electric charge, hypercharge, color charge
  Supersymmetry/
    SuperVectorSpace.lean ← ℤ/2-graded vector spaces
    SuperLie.lean         ← super Lie algebra definition
    SUSYAlgebra.lean      ← SUSY algebra anticommutators
  Oracle/
    RootFixtures.lean     ← CAS-generated root system fixtures
    BranchingFixtures.lean ← CAS-generated branching data
    GammaFixtures.lean    ← CAS-generated gamma matrix identities
  Docs/
    Glossary.lean         ← notation and terminology glossary
    Roadmap.lean          ← formalization roadmap and open questions
```
-/

namespace PhysicsSM

end PhysicsSM
