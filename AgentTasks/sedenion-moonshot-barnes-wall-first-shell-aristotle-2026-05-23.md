# Aristotle M5: Barnes-Wall first-shell moonshot

Create or modify the draft Lean module:

```text
PhysicsSM/Draft/Sedenions/BarnesWallFirstShell.lean
```

## Big Goal

Test the bridge:

```text
signed sedenion zero-product plaquettes -> 4-qubit stabilizer states ->
Barnes-Wall first-shell geometry.
```

The full Barnes-Wall lattice may not exist in the project.  If so, build a
finite proxy that can later be connected to a full lattice formalization.

## Existing Context

Use:

```text
PhysicsSM.Draft.Sedenions.StabilizerPlaquettes
PhysicsSM.Draft.Sedenions.ReedMullerCode
PhysicsSM.Draft.Sedenions.CocycleQuadraticPhase
PhysicsSM.Draft.Sedenions.GL32Action
```

## Desired Theorems

Try for one of the following, in order of ambition:

1. Define a finite `BarnesWallShellCandidate` predicate for normalized
   4-sparse quadratic-phase states and prove every signed zero-product
   plaquette satisfies it.
2. Prove the 42 signed plaquettes form a single symmetry orbit under the
   available `GL(3,2)` action plus gauge/sign changes.
3. Define a Clifford-style finite orbit containing the representative
   stabilizer plaquette and prove the zero-product plaquettes are contained in
   that orbit.
4. If a direct Barnes-Wall statement is impossible, return a precise missing
   API note in the module docstring and prove the strongest finite stabilizer
   orbit theorem available.

Suggested public theorem names:

```lean
theorem zero_product_plaquettes_mem_shell_candidate : ...
theorem zero_product_plaquettes_single_symmetry_orbit : ...
theorem signed_plaquettes_mem_clifford_proxy_orbit : ...
```

## Constraints

- Do not claim a true Barnes-Wall lattice theorem unless a lattice predicate is
  actually defined in the file.
- A finite shell-candidate theorem is acceptable and useful.
- No axioms, opaque constants, unsafe code, or admits.
