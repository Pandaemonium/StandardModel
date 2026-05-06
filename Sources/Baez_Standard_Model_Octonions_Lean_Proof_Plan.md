# Lean proof plan: Baez, "Can We Understand the Standard Model Using Octonions?"

Source: `Sources/John _Baez_standard_model_octonions.pdf`

Title slide: John Baez, "Can We Understand the Standard Model Using
Octonions?", Octonions and the Standard Model, 12 April 2021.

Status: planning document. This is not a proof and not a claim that the
Standard Model has been derived from octonions. It is a theorem inventory and
Lean roadmap for turning the presentation into formal targets.

## Executive target

The talk has one central mathematical chain:

```text
Euclidean Jordan algebras
  -> h_2(O) as an octonionic qubit and 10d spin factor
  -> h_3(O) as the exceptional Jordan algebra / octonionic qutrit
  -> Aut(h_3(O)) = F4
  -> Stab_F4(h_2(O)) = Spin(9)
  -> a unit imaginary i in O gives h_3(C) inside h_3(O)
  -> the i-induced stabilizer is (SU(3) x SU(3)) / Z3
  -> intersecting that stabilizer with Stab_F4(h_2(O)) gives S(U(2) x U(3))
  -> inside Spin(9), S(U(2) x U(3)) acts on O^2 like one generation of
     left-handed Standard Model fermions.
```

The Lean strategy should be staged. Most early progress should be finite
coordinate algebra. The compact Lie group isomorphisms should remain explicit
frontier targets until supporting infrastructure exists.

## Current local Lean anchors

- `PhysicsSM/Algebra/Octonion/Basic.lean`
- `PhysicsSM/Algebra/Octonion/Conjugation.lean`
- `PhysicsSM/Algebra/Octonion/Norm.lean`
- `PhysicsSM/Algebra/Octonion/ConventionBridge.lean`
- `PhysicsSM/Algebra/Jordan/H3O.lean` currently exists as a stub.
- `PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean` currently gives
  a typechecked draft scaffold for `h_3(O)`, standard blocks, projective
  points/lines, automorphisms, and stabilizers.

Related Aristotle job:

```text
17d42ab0-5795-4bcc-b387-d93e47bd976e
```

## Slide-by-slide proof inventory

### Slides 2-3: problem statement and final stabilizer claim

Informal content:

- The Standard Model internal symmetries are organized by
  `S(U(2) x U(3))`.
- Following Dubois-Violette and Todorov, this group appears as symmetries of
  an octonionic qutrit preserving:
  - structure from a chosen unit imaginary octonion `i`;
  - a chosen octonionic qubit `h_2(O)` inside `h_3(O)`.

Lean targets:

- Define the "true" Standard Model gauge group as `S(U(2) x U(3))`, not merely
  `U(1) x SU(2) x SU(3)`.
- Provide a bridge theorem stating that the familiar product group maps onto
  `S(U(2) x U(3))` with kernel `Z6`.
- State the final stabilizer theorem in draft form:

```lean
-- eventual shape, not current code
stabilizer_unitImaginary_and_H2O_is_standardModelGaugeGroup
```

Near-term status: define the group and map first; leave the `F4` stabilizer
theorem in draft.

### Slides 4-6: Euclidean Jordan algebras

Informal content:

- Observables are real vector spaces closed under squaring.
- The Jordan product is
  `a o b = 1/2 ((a + b)^2 - a^2 - b^2)`, and for associative matrices
  `a o b = 1/2 (ab + ba)`.
- Euclidean Jordan algebras are finite-dimensional real Jordan algebras with
  formal reality.
- The classification includes `h_n(R)`, `h_n(C)`, `h_n(H)`, `h_n(O)` for
  `n <= 3`, and spin factors.

Lean targets:

- Introduce only the interface we need:
  - real scalar action;
  - Jordan product;
  - commutativity;
  - power-associativity as a named property, not initially required for every
    downstream construction;
  - projections/idempotents.
- Prove the polarization identity for any algebra where squaring and bilinear
  product are available.
- Do not attempt the full Jordan-von Neumann-Wigner classification early. It is
  source context, not a dependency for the stabilizer theorem.

Suggested files:

- `PhysicsSM/Algebra/Jordan/Basic.lean`
- `PhysicsSM/Algebra/Jordan/Projection.lean`

### Slides 7-11: spin factors, states, pure states, and `h_2(K)`

Informal content:

- A Euclidean Jordan algebra has a positive cone, trace, determinant, states,
  and pure states.
- The spin factor `R + R^n` has product
  `(t, x) o (t', x') = (tt' + x dot x', t x' + t' x)`.
- Its determinant is the Minkowski quadratic form `t^2 - x dot x`.
- `h_2(R)`, `h_2(C)`, `h_2(H)`, and `h_2(O)` are spin factors in dimensions
  3, 4, 6, and 10.
- Pure states are projective lines: `RP^1`, `CP^1`, `HP^1`, `OP^1`, with the
  spin-factor pure-state sphere description.

Lean targets:

- Define a concrete `SpinFactor n` over `Real`.
- Prove:

```text
det(t, x) = t^2 - ||x||^2
trace(t, x) = 2 * t
projection equations for (t, x)
trace-one projections satisfy t = 1/2 and ||x|| = 1/2
```

- Define concrete `H2O` as triples `(t, x, y)` representing
  `[[t+x, y], [conj y, t-x]]`.
- Prove the concrete determinant formula:

```text
det([[t+x, y], [conj y, t-x]]) = t^2 - x^2 - normSq(y)
```

- Prove a coordinate equivalence between `H2O` and a 10-dimensional spin
  factor.

Suggested files:

- `PhysicsSM/Algebra/Jordan/SpinFactor.lean`
- `PhysicsSM/Algebra/Jordan/H2O.lean`

### Slide 12: observables as derivations

Informal content:

- For complex self-adjoint matrices, `i(ab - ba)` gives a Lie bracket acting
  by derivations of the Jordan product.
- This motivates why ordinary complex quantum mechanics is special.

Lean targets:

- Low priority for this project. Add a clean source note and optional theorem
  for associative `star` algebras:

```text
commutator acts as a derivation of the symmetrized Jordan product
```

Suggested placement:

- `PhysicsSM/Algebra/Jordan/Derivation.lean`

### Slides 14-16: choosing `i`, splitting `O`, and `Aut(h_2(O)) = O(9)`

Informal content:

- A unit imaginary octonion `i` picks a copy of `C = span_R {1, i}`.
- It gives a splitting `O = C + C_perp`.
- Left multiplication by `i` gives a complex structure on `C_perp`.
- It embeds `h_2(C)` into `h_2(O)` and splits
  `h_2(O) = h_2(C) + C_perp`.
- `h_2(O)` has both Minkowski determinant and Euclidean trace-square form.
- `Aut(h_2(O)) = O(9)`.

Lean targets:

- In the project convention choose `i = e111`, unless a later file
  parameterizes over any unit imaginary octonion.
- Define:

```text
chosenComplexLine = span_R {1, e111}
chosenComplexComplement = {octonions with c0 = 0 and c7 = 0}
```

- Prove the chosen complex line is closed under octonion multiplication and
  conjugation.
- Prove left multiplication by `e111` squares to `-1` on the complement.
- Define the embedding `H2C -> H2O`.
- Prove the concrete splitting predicate for `H2O`.
- State `Aut(H2O) = O(9)` as a frontier theorem after the spin-factor
  equivalence exists.

Suggested files:

- `PhysicsSM/Algebra/Octonion/ComplexLine.lean`
- `PhysicsSM/Algebra/Jordan/H2O.lean`

### Slides 17-21: embedding the Standard Model group into the `Spin(9)` subgroup

Informal content:

- The identity component double cover of `O(9)` is `Spin(9)`.
- The subgroup of `Spin(9)` preserving `h_2(C) subset h_2(O)` is
  `(Spin(3) x Spin(6))/Z2 ~= (SU(2) x SU(4))/Z2`.
- There is a homomorphism

```text
U(1) x SU(2) x SU(3) -> SU(2) x SU(4)
(alpha, g, h) |-> (g, diag(alpha h, alpha^-3))
```

- Passing through the quotient gives an inclusion
  `S(U(2) x U(3)) -> (SU(2) x SU(4))/Z2`.

Lean targets:

- Define the block embedding into `SU(4)`:

```text
(alpha, h) |-> block_diag(alpha * h, alpha^-3)
```

- Prove determinant one:

```text
det(block_diag(alpha * h, alpha^-3)) = 1
```

using `det h = 1` and `alpha in U(1)`.

- Prove the kernel of the map from `U(1) x SU(2) x SU(3)` to the true SM group
  is cyclic of order 6.
- Prove or state the quotient equivalence:

```text
(U(1) x SU(2) x SU(3)) / Z6 ~= S(U(2) x U(3))
```

- Leave the inclusion into the `Spin(9)` stabilizer as a later theorem until
  the `Spin(9)` model is available.

Suggested files:

- `PhysicsSM/Gauge/StandardModelGroup.lean`
- `PhysicsSM/Gauge/BlockEmbeddings.lean`

### Slides 23-25: `h_3(O)`, `F4`, `Spin(9)`, and the block decomposition

Informal content:

- `h_3(O)` consists of Hermitian 3 by 3 octonionic matrices:

```text
[[alpha, z, conj y],
 [conj z, beta, x],
 [y, conj x, gamma]]
```

- `Aut(h_3(O))` is the compact exceptional group `F4`.
- A chosen copy of `h_2(O)` inside `h_3(O)` has stabilizer `Spin(9)`.
- As `Spin(9)` representations:

```text
h_3(O) ~= R + h_2(O) + O^2
```

where `O^2` is the real spinor representation.

Lean targets:

- Promote the safe part of
  `PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean` into trusted
  modules:
  - `H3O`;
  - trace;
  - Jordan product;
  - standard `H2O` block;
  - block decomposition projection maps.
- Prove a coordinate equivalence:

```text
H3O ~= Real x H2O x (Octonion x Octonion)
```

for the chosen block placement.

- State but do not fake:

```text
Aut(H3O) ~= F4
Stab_F4(H2O) ~= Spin(9)
```

Suggested files:

- `PhysicsSM/Algebra/Jordan/H3O.lean`
- `PhysicsSM/Algebra/Jordan/H3OBlockDecomposition.lean`
- `PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean`

### Slides 26-33: the `h_3(C)` splitting and the final stabilizer theorem

Informal content:

- Choose a unit imaginary octonion `i`.
- This gives `h_3(C) subset h_3(O)` and a trace-orthogonal splitting:

```text
h_3(O) = h_3(C) + h_3(C)^perp
```

- The orthogonal complement consists of off-diagonal octonionic entries in
  `C_perp`.
- Left multiplication by `i` gives a complex structure on `h_3(C)^perp`.
- The subgroup of `F4` preserving this splitting and complex structure is:

```text
(SU(3) x SU(3)) / Z3
```

- In coordinates, after identifying `C_perp ~= C^3`,

```text
h_3(O) ~= h_3(C) + M_3(C)
(g, h)(X, M) = (g X g^*, h M g^*)
```

- The second `SU(3)` is color. The first contains the electroweak subgroup
  preserving the chosen `h_2(O)` block.
- The final theorem:

```text
automorphisms of h_3(O) preserving
  h_3(C) + h_3(C)^perp splitting,
  complex structure on h_3(C)^perp,
  chosen h_2(O)
are isomorphic to S(U(2) x U(3)).
```

Lean targets:

- Define `H3CInH3O` using the chosen complex line in octonions.
- Define `H3COrthogonalComplement` using the trace form
  `tr(a o b)`.
- Prove the coordinate characterization of `H3COrthogonalComplement`.
- Define the complex structure on the complement and prove it squares to `-1`.
- Define the action of `SU(3) x SU(3)` on `h_3(C) + M_3(C)` at the vector-space
  level.
- Prove the central diagonal `Z3` acts trivially.
- Leave preservation of the full Jordan product as a Yokota/DVT frontier
  theorem until the calculation is formalized.
- State the final stabilizer theorem in draft with exact source provenance.

Suggested files:

- `PhysicsSM/Algebra/Jordan/H3CSubalgebra.lean`
- `PhysicsSM/Algebra/Jordan/H3OComplexSplitting.lean`
- `PhysicsSM/Draft/YokotaStabilizer.lean`

### Slides 35-36: Krasnov endpoint and left-handed fermions

Informal content:

- `S(U(2) x U(3))` is the subgroup of `Spin(9)` whose action on `O^2`
  commutes with right multiplication by the chosen unit imaginary octonion.
- On `O^2` with this complex structure, the action is the one-generation
  left-handed Standard Model fermion representation.
- The octonionic qutrit remains mysterious, and the right-handed fermions are
  not solved by this talk.

Lean targets:

- Define right multiplication by `e111` on `O^2` and prove it is a complex
  structure.
- State:

```text
centralizer_Spin9(rightMul_e111_on_O2) ~= S(U(2) x U(3))
```

- Build a comparison table between the resulting complex representation and
  the left-handed one-generation SM multiplets.
- Keep the right-handed sector as an explicit open question, not a hidden
  assumption.

Suggested files:

- `PhysicsSM/Spinor/OctonionicQubit.lean`
- `PhysicsSM/StandardModel/LeftHandedFermionRepresentation.lean`
- `OPEN_QUESTIONS.md` for the right-handed gap.

## Proposed implementation order

### Phase 0: source hygiene and names

1. Keep this document and `Sources/Baez_Octonions_Standard_Model_Talk_Notes.md`
   synchronized with the local PDF.
2. Record that the talk uses a generic unit imaginary octonion `i`, while the
   current Lean scaffolding chooses `e111`.
3. Never copy Baez multiplication signs directly into trusted code without a
   convention bridge check.

### Phase 1: trusted coordinate foundations

1. `Octonion.ComplexLine`: chosen `C = span_R {1, e111}` and complement.
2. `Jordan.Basic`: minimal Jordan product/projection vocabulary.
3. `Jordan.SpinFactor`: finite coordinate spin factor and determinant.
4. `Jordan.H2O`: concrete `h_2(O)`, determinant, trace, spin-factor bridge.
5. `Jordan.H3O`: concrete `h_3(O)`, trace, Jordan product, standard blocks.

Success criterion: all files above are trusted and sorry-free.

### Phase 2: Standard Model group as a matrix subgroup

1. Define `S(U(2) x U(3))` as a subgroup of `SU(5)` using block matrices.
2. Define the familiar product cover
   `U(1) x SU(2) x SU(3) -> S(U(2) x U(3))`.
3. Prove the kernel is `Z6`.
4. Define the block map into `SU(2) x SU(4)` from slides 18-21.

Success criterion: the finite quotient/group-cover facts are theorem-backed,
not just comments.

### Phase 3: `h_3(O)` block and complex splitting

1. Define `H3CInH3O` from the chosen complex line.
2. Define the trace form and orthogonal complement.
3. Prove the coordinate description of `h_3(C)^perp`.
4. Prove the complex-structure square on the complement.
5. Define the vector-space isomorphism `h_3(O) ~= h_3(C) + M_3(C)`.

Success criterion: the splitting facts from slides 28-31 are trusted.

### Phase 4: automorphisms and stabilizers

1. Define Jordan automorphisms of `H3O`.
2. Prove they preserve projections, trace, and incidence.
3. Define stabilizers of:
   - the chosen `H2O` block;
   - the `i`-induced `H3C` splitting;
   - the complex structure on the complement.
4. State the DVT/Yokota theorem:

```text
stabilizer_i_structure ~= (SU(3) x SU(3)) / Z3
```

5. State the DVT intersection theorem:

```text
stabilizer_i_structure cap stabilizer_H2O ~= S(U(2) x U(3))
```

Success criterion: all stabilizer objects are correctly typed, and the
frontier theorems have precise source and convention notes.

### Phase 5: Krasnov representation bridge

1. Define the octonionic qubit `O^2`.
2. Define right multiplication by `e111` as a complex structure.
3. State the centralizer theorem inside `Spin(9)`.
4. Formalize the left-handed one-generation representation table.
5. Compare weights/charges with existing Standard Model/anomaly modules.

Success criterion: the left-handed representation theorem is separated from
the unresolved right-handed sector.

## What not to prove yet

- The full Jordan-von Neumann-Wigner classification.
- `Aut(H3O) = F4` as an immediate trusted theorem.
- The full compact Lie group quotient/stabilizer chain before the concrete
  coordinate infrastructure exists.
- Any claim that the talk explains right-handed fermions or three generations.

## Best next Aristotle jobs

1. `Octonion.ComplexLine`: prove closure and complex-structure facts for
   `span_R {1, e111}` and its complement.
2. `H2O spin factor`: prove determinant, trace form, and projection equations.
3. `H3O Jordan product`: implement the coordinate product and prove standard
   line/block projection facts.
4. `StandardModelGroup`: prove the `Z6` kernel and block embedding lemmas.
5. `H3C splitting`: prove the trace-orthogonal complement coordinate
   characterization and complex-structure square.
