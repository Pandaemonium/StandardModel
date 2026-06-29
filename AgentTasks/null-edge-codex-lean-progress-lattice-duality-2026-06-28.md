# Codex Lean progress: tetrahedral lattice-duality scaffold

Date: 2026-06-28

Created Draft file:

```text
PhysicsSM/Draft/NullEdge/GateC1/TetrahedralLatticeDuality.lean
```

Purpose:

```text
Expose the finite linear-algebra layer behind C240's independent-angle
Brillouin-torus assumption.
```

Main definitions:

```text
homogeneousTetraMap:
  c_A |-> (sum c_A, sum c_A w_A^0, sum c_A w_A^1, sum c_A w_A^2).

TetrahedralAngleCoordinateContract:
  explicit source-contract placeholder for the quotient-lattice theorem.

IndependentTetrahedralAngles:
  the exact assumption C240 needs until the quotient-torus theorem is proved.
```

Main handoff targets:

```text
homogeneousTetraMap_eq_zero_imp:
  should follow directly from C240's tetra_homogeneous_injective.

homogeneousTetraMap_injective:
  should follow by explicit finite linearity and the kernel theorem.
```

What this does not prove:

```text
It does not yet build the dual lattice.
It does not yet define the Brillouin torus quotient.
It does not yet prove that p -> (n_A dot p)_A descends to a torus equivalence.
```

Status:

```text
Draft/unverified.
Contains explicit proof placeholders in the finite map lemmas.
No live Lean check was run.
No trusted theorem or GateC1_NU claim is made.
```
