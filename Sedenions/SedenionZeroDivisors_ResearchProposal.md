# Sedenion Zero Divisors: Research Proposal

Status: research program scaffold
Date: 2026-05-23
Project: `PhysicsSM` / `StandardModel`

## Executive Thesis

The defensible thesis is not that sedenions directly solve a lattice-packing or
particle-physics problem.  The defensible thesis is narrower and stronger:

```text
Sedenion zero divisors appear to generate a signed affine-plane geometry
inside F_2^4, closely related to a doubly shortened RM(2,4) code.
```

The next layer is the genuinely interesting one:

```text
The Cayley-Dickson signs on those affine planes may define a canonical
quadratic or Z_4 refinement connected to Barnes-Wall, Clifford, Kerdock,
and stabilizer-state geometry.
```

Physics enters only after that finite algebra is under control.  The leading
physics question is whether the sedenion `S_3` family symmetry used in recent
Clifford-algebra generation models acts naturally on this signed zero-divisor
geometry, or instead moves sparse stabilizer-like plaquettes into non-stabilizer
or magic-like states.

## Known Starting Points

The following facts should be treated as background, not as new claims.

- de Marrais identifies 168 primitive unit zero divisors in the sedenions,
  arranged along 42 assessors and organized into seven octahedral box-kites.
- Cayley-Dickson multiplication can be represented as a twisted group algebra
  on binary labels:

  ```text
  e_a e_b = omega(a,b) e_(a+b),  a,b in F_2^4,
  ```

  for a sign function `omega(a,b) in {+1,-1}`.
- Reed-Muller codes are naturally described as evaluations of low-degree
  Boolean polynomials on affine binary spaces.
- Barnes-Wall lattices, Clifford groups, Kerdock-type structures, and
  stabilizer states form a real mathematical ecosystem.  The proposed
  sedenion bridge should be routed through this ecosystem, not asserted as a
  direct Barnes-Wall construction.

## Current Computational Evidence to Reproduce

Using labels `a = (h,i)` with `h in F_2` and `i in F_2^3`, consider mixed
assessor supports of the form:

```text
A_(i,j) = span{ e_(0,i), e_(1,j) },  i,j nonzero, i != j.
```

Primitive zero-divisor products select four basis indices:

```text
{ (0,i), (1,j), (0,p), (1,q) }.
```

When the struts agree,

```text
i + j = p + q,
```

this four-point support is an affine 2-plane in `F_2^4`.

The computational claim to reproduce first is:

```text
C_ZD = span_F2{42 mixed same-strut affine-plane supports}
```

has:

```text
dim C_ZD = 9
W_CZD(y) = 1 + 77 y^4 + 168 y^6 + 203 y^8 + 56 y^10 + 7 y^12
```

and equals:

```text
{ c in RM(2,4) : c_0 = 0 and c_8 = 0 }.
```

Terminology note: with coordinates 0 and 8 retained as forced-zero
coordinates, this is a doubly shortened subcode before puncturing.  After
puncturing those two coordinates, it becomes a length-14 shortened code.

## What Must Not Be Overclaimed

The following statements are research targets, not current theorem claims.

- The sedenion zero divisors do not yet construct the Barnes-Wall lattice
  `Lambda_16`.  At present the evidence is a Reed-Muller/Barnes-Wall-adjacent
  parity shadow.
- The binary code `C_ZD` is not automatically a quantum stabilizer code.  A
  stabilizer code needs a symplectic Pauli space, commuting checks, logical
  operators, and distance.
- The 168 primitive zero divisors should not be identified with stabilizer
  states until the signed Cayley-Dickson phases are explicitly converted into
  quadratic-phase stabilizer data.
- The sedenion `S_3` generation symmetry should not be claimed to preserve the
  sparse assessor system until its action has been computed on assessors,
  affine-plane supports, signs, and box-kites.

## Main Research Tracks

### Track A: Finite Algebra and Code Theorem

Goal:

```text
C_ZD = { c in RM(2,4) : c_0 = c_8 = 0 }.
```

Deliverables:

- a reproducible Python/Sage enumeration of sedenion multiplication signs;
- the 42 seed affine planes;
- a generator matrix for `C_ZD`;
- dimension, weight enumerator, and equality with the doubly shortened
  `RM(2,4)` subcode;
- classification of the 77 weight-4 words, expected to split into natural
  geometric classes such as `42 + 21 + 7 + 7`.

This is the safest first paper-sized theorem.

### Track B: Signed Cocycle and Quadratic Refinement

Goal:

```text
Identify the de Marrais box-kite sign rules as restrictions of the
Cayley-Dickson twisting cochain to the zero-divisor affine-plane complex.
```

Deliverables:

- an explicit sign function `omega : F_2^4 x F_2^4 -> {+1,-1}`;
- a gauge-change model for equivalent sign conventions;
- a signed affine-plane complex;
- a candidate `Z_4` or quadratic refinement;
- comparison with Kerdock, Preparata, and Barnes-Wall glue data.

This is the deepest mathematical direction.

### Track C: Stabilizer and Barnes-Wall Geometry

Goal:

```text
Turn each signed zero-divisor affine plane into a 4-qubit quadratic-phase
state and test whether it is a stabilizer state.
```

Deliverables:

- normalized 4-sparse vectors in `C^16`;
- stabilizer-generator extraction for each signed plaquette;
- orbit decomposition inside the 4-qubit stabilizer-state set;
- comparison with Barnes-Wall minimal vectors and Clifford symmetries;
- a test of whether the sedenion order-three `S_3` automorphism is Clifford,
  lattice-preserving, or magic-generating in the chosen basis.

This is the strongest quantum-information angle.

### Track D: S3 Generation Symmetry and Physics

Goal:

```text
Test whether the S_3 family symmetry used in sedenion/Clifford generation
models acts covariantly on the signed zero-divisor geometry.
```

Deliverables:

- explicit matrices for the old Cayley-Dickson `S_3` action and the newer
  `Cl(8)`/`Cl(10)` embedded actions;
- images of the 42 assessors, 7 box-kites, 77 affine planes, and signed
  cocycle data;
- a clear trichotomy:
  - preserves sparse signed plaquettes;
  - maps a plaquette to a sum of plaquettes;
  - leaves the stabilizer/Barnes-Wall scaffold and generates magic.

This is the physics-facing track, but it should be downstream from Tracks A-C.

### Track E: Discrete Physics / COG Toy Models

Goal:

```text
Treat zero products as exact cancellation channels in a finite transition
system, then study the induced code, invariant, and frustration structure.
```

Deliverables:

- a finite state machine whose local transitions are signed zero-divisor
  relations;
- invariant parity checks and conserved quantities;
- frustration and orbit structure;
- comparison with stabilizer evolution, cellular automata, discrete gauge
  constraints, and causal graph dynamics.

This is speculative, but it can be made disciplined by starting with small
finite experiments.

## Recommended Order

1. Reproduce the finite code claim and write it as a clean computational note.
2. Extract and normalize the Cayley-Dickson sign function.
3. Prove or refute the signed-affine-plaquette stabilizer-state claim.
4. Run the `S_3` orbit tests on signed plaquettes.
5. Only then attempt Barnes-Wall lattice construction, Kerdock lifts, or
   particle-physics interpretation.

## Document Map

- `README.md`: entry point and workstream index.
- `Literature_Map.md`: source map and claims supported by each reference.
- `SignedAffinePlaquettes.md`: core finite algebra and signed-plane program.
- `ReedMuller_BarnesWall_Bridge.md`: code/lattice bridge and overclaim guardrails.
- `Stabilizer_QuantumInfo_Program.md`: stabilizer-state and magic tests.
- `S3_Generation_Physics_Program.md`: generation-symmetry and physics tests.
- `PSL_Kerdock_Cocycle_Program.md`: signed `GL(3,2)`, `PSL(2,7)`, and
  `Z_4`/Kerdock questions.
- `DiscretePhysics_COG_Program.md`: finite cancellation dynamics and
  COG-style toy models.
- `Computational_Roadmap.md`: scripts, invariants, reproducibility plan.

## Trust Boundary

Nothing in this folder is currently a proved Lean theorem.  The documents are
research scaffolding.  Claims should be promoted only after they are backed by:

- a reproducible finite computation;
- a mathematically reviewed proof;
- or a kernel-checked Lean formalization.
