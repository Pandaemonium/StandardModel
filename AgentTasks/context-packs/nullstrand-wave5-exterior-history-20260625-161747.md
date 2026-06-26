# Aristotle semantic context pack

Generated: 2026-06-25T16:17:54
Query: `exterior history Plucker Sorkin grade two mass measure finite histories capacity causal graph`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [Overview]

Score: `0.795`

```text
## Overview

| ID | Working title | Readiness | Lead venue |
| --- | --- | --- | --- |
| P1 | Mass as Plucker spread of null spinors | Banked | Formalized-math / math-phys |
| P2 | A finite Dirac square root of the Plucker mass | Near | Formalized-math / math-phys |
| P3 | Causal-diamond holonomy: finite gauge curvature without plaquettes | Banked | ITP / discrete gravity |
| P4 | Luminal checkerboard dynamics, formalized | Banked | ITP / math-phys |
| P5 | Finite quantum measure on causal events | Near | Foundations / quantum info |
| P6 | Flavor as an internal Gram-overlap problem | Synthesis | Physics (flavor), framed as structural |
| P7 | Observer channels and relative-entropy monotonicity | Synthesis | Foundations / QI + gravity |
| P8 | The null-edge causal graph program (manifesto) | Synthesis | Foundations / quantum gravity |
| P11 | Stable particle sectors of finite causal quantum channels | Aspirational | Foundations / quantum information |
| P9 | Cosmological-constant source visibility from diamond closure | Aspirational | Quantum gravity |
| P10 | Generations from the exceptional Jordan / triality layer | Aspirational | Math-phys / particle |
```

### 2. `PhysicsSM/Draft/NullEdgeQuantumMeasureFiniteAristotle.lean` [targets]

Score: `0.791`

```text
import Mathlib
import PhysicsSM.Spinor.PluckerMass

/-!
# Draft.NullEdgeQuantumMeasureFiniteAristotle

This Aristotle handoff builds a finite quantum-measure/decoherence-functional
bridge for the null-edge causal graph program.

The intended physics connection is modest but important: finite visible
Pluecker mass should sit inside the same algebraic world as Sorkin-style
quantum measure theory.  Here a finite event has amplitude
`sum x in A, amp x`; its quantum measure is the squared modulus of that
amplitude; and its decoherence functional is the rank-one Gram functional
`alpha(A) conj(alpha(B))`.

The ambitious theorem targets are:

* the grade-2 quantum-measure sum rule for three disjoint finite events;
* strong positivity of the finite decoherence Gram matrix;
* tensor-product closure on rectangular events.

Claim boundary:

* all statements are finite `Finset` algebra;
* this file does not assert a continuum path integral or analytic measure;
* the decoherence functional here is the rank-one amplitude model, used as a
  finite algebraic baseline before adding richer histories.
-/
```

### 3. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Short canonical thesis]

Score: `0.791`

```text
## Short canonical thesis

The strongest version of the program is:

> A null-edge causal graph theory should be built as a quantum measure over
> causal/twistor incidence histories. Visible edges carry complex null spinors,
> whose non-collinear bundles have invariant mass equal to a Pluecker
> determinant, equivalently the missing dipole moment of their celestial
> direction distribution or the mixedness of a reduced visible celestial
> qubit. The Pluecker determinant is a squared quantity: the static square
> root is a finite Dirac-slash operator built from the bundle momentum, while
> the dynamical square root should be a first-order transfer operator on a
> doubled \(L\oplus R\) celestial space. In that operator, Higgs/Yukawa
> chirality flips are the off-diagonal mass block, the complex Pluecker
> amplitude carries the phase information discarded by the squared modulus,
> and the sign of the square root supplies the two-sheet branch data that any
> CPT or scattering interpretation must respect. The larger conjecture is
> that a causal super-Dirac operator on the order complex has the Pluecker
> scalar, Higgs/Yukawa chirality-flip block, and causal-diamond
...[truncated]
```

### 4. `AgentTasks/null-edge-quantum-measure-finite-aristotle-2026-06-21.md` [Objective]

Score: `0.787`

```text
## Objective

Fill the proof holes in:

```text
PhysicsSM/Draft/NullEdgeQuantumMeasureFiniteAristotle.lean
```

This batch builds a finite quantum-measure/decoherence-functional bridge for
the null-edge causal graph program.  It is meant to connect the finite
Pluecker-mass program with Sorkin-style quantum measure theory using only
finite `Finset` algebra.
```

### 5. `PhysicsSM/Spinor/PluckerMass.lean`

Score: `0.786`

```text
theorem.

Sources and provenance:
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `Sources/Null_Edge_Causal_Graph_Research_Plan.md`
- First formalized in the no-s o r r y Aristotle draft
  `PhysicsSM.Draft.NullEdgePluckerGeneralAristotle`, task
  `16146014-3b07-41dd-b56b-ec17a4fc0a08`.

Conventions:
- visible spacetime spinors are complex two-spinors;
- `rankOneHermitian psi = psi psi^dagger`;
- determinant mass is the `2 x 2` determinant over `ℂ`;
- squared modulus is represented as the complex number `z * conj z`.

Status: trusted, no `s o r r y`.
-/
```

## Scoped paper hits

No paper hits returned.
