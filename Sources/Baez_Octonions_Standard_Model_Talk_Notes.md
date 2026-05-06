# Baez talk notes: Can We Understand the Standard Model Using Octonions?

Source video: <https://www.youtube.com/watch?v=OH9e9C0xvUg>

Local transcript: `Sources/Baez_Can_We_Understand_the_Standard_Model_Using_Octonions.txt`

Local presentation slides: `Sources/John _Baez_standard_model_octonions.pdf`

Related later projective-geometry slides: `Sources/John_Baez_exceptional.pdf`

Transcript provenance: tactiq.io YouTube transcript. The transcript contains
many automatic-transcription errors; these notes silently normalize obvious
terms such as "octonians" to octonions, "qtrit" to qutrit, and "Dubois Vlet" to
Dubois-Violette.

Slide provenance: text extracted from the local PDF
`John _Baez_standard_model_octonions.pdf`, titled "Can We Understand the
Standard Model Using Octonions?", by John Baez, "Octonions and the Standard
Model", 12 April 2021. The later local PDF `John_Baez_exceptional.pdf` is a
related Baez-Schwahn presentation focused on the projective-geometry
conjecture for the exceptional Jordan algebra.

Status: source notes for project planning, not a formal proof and not a claim
that the Standard Model has been derived from octonions.

## Executive takeaways

Baez presents a cautious mathematical route from octonions and exceptional
Jordan algebras to the true Standard Model gauge group. He explicitly avoids
answering "yes" or "no" to whether the Standard Model can be understood from
octonions.

The key reviewed result, attributed mainly to Dubois-Violette and Todorov with
related work by Krasnov and background from Yokota, is:

```text
S(U(2) x U(3))
```

can be characterized as the automorphism group of the exceptional Jordan
algebra `H_3(O)` preserving two extra pieces of structure:

1. the structure induced by choosing a unit imaginary octonion `I`, including
   the corresponding copy of `C` inside `O`, a splitting, and a complex
   structure on the complementary part;
2. a chosen Jordan subalgebra `H_2(O)` inside `H_3(O)`, interpreted as an
   octonionic qubit inside an octonionic qutrit.

This is directly relevant to the project because it suggests a proof ladder:

```text
Euclidean Jordan algebra infrastructure
-> H_2(O), H_3(O), trace, determinant, projections
-> Aut(H_3(O)) = F4 and stabilizer(H_2(O)) = Spin(9)
-> stabilizer(unit imaginary octonion structure) = (SU(3) x SU(3)) / Z3
-> intersection with stabilizer(H_2(O)) = S(U(2) x U(3))
```

The biggest remaining physics gap, according to Baez, is not the gauge group
itself but the fermion representation content. The construction naturally gives
a good action on an octonionic qubit `O^2` related to left-handed fermions in
one generation, while the right-handed fermions remain mysterious in this
specific framework.

The slide deck sharpens the gauge-group story into a Main Conjecture. It says
that if `A, B` are Jordan subalgebras of `h_3(O)` with

```text
A ~= h_2(O)
B ~= h_3(C)
A cap B ~= h_2(C)
```

then the subgroup of `Aut(h_3(O)) = F4` preserving both `A` and `B` is

```text
Stab(A) cap Stab(B) ~= S(U(2) x U(3)).
```

For the standard block-matrix example, Dubois-Violette and Todorov already
proved:

```text
Stab(A) ~= Spin(9)
Stab(B) ~= (SU(3) x SU(3)) / Z3
Stab(A) cap Stab(B) ~= S(U(2) x U(3)).
```

Baez and Schwahn's proposed route to the full conjecture is to prove that this
example is universal: `F4` should act transitively on all such pairs `(A, B)`.

## Main mathematical narrative

### Jordan algebras as observables

Timestamp region: about 00:05-00:12.

Baez motivates Jordan algebras from finite-dimensional quantum mechanics. The
self-adjoint complex matrices are observables. They are closed under real
linear combinations and squaring, but not under ordinary matrix multiplication.
From squaring and real linear structure one obtains the Jordan product:

```text
a o b = 1/2 ((a + b)^2 - a^2 - b^2)
```

For ordinary matrices this is the symmetrized product:

```text
a o b = 1/2 (ab + ba)
```

The product is commutative and power-associative, but not generally
associative. Baez emphasizes that power-associativity has a physical
interpretation: powers of a single observable remain unambiguous observables.

The relevant class is Euclidean, or formally real, Jordan algebras. In finite
dimension, these are classified into:

- self-adjoint real matrices,
- self-adjoint complex matrices,
- self-adjoint quaternionic matrices,
- self-adjoint octonionic matrices for `n <= 3`,
- spin factors.

The exceptional case is `H_3(O)`, the 3 by 3 self-adjoint octonionic matrices,
also called the Albert algebra.

Project implications:

- A future formalization should probably introduce a small Euclidean Jordan
  algebra interface before attempting `H_3(O)`.
- The current octonion core should eventually support a Jordan product on
  self-adjoint octonionic matrices.
- The distinction between Jordan multiplication and raw nonassociative
  octonion multiplication must remain explicit.

### States, pure states, cones, trace, determinant

Timestamp region: about 00:13-00:24, with follow-up discussion around
01:18-01:25.

Every Euclidean Jordan algebra has:

- a cone of nonnegative elements, defined as sums of squares;
- a determinant-like real function vanishing on the boundary of the positive
  cone;
- a trace-like linear functional;
- states, defined as positive elements with trace 1;
- pure states, identified with trace-one projections, equivalently extreme
  points of the convex state space.

For spin factors, the positive cone is isomorphic to a future light cone in
Minkowski spacetime, and the determinant is the Minkowski quadratic form. This
explains why `H_2(K)` for normed division algebras behaves like Minkowski
spacetime in dimensions 3, 4, 6, and 10.

Baez stresses that the Jordan algebra structure contains more than just the
Lorentzian metric: it remembers a Euclidean metric or a chosen time axis as
well. If one keeps only the determinant, one recovers the Lorentz group; if one
keeps the full spin-factor Jordan structure, the symmetry group is smaller.

Project implications:

- Useful proof targets include:
  - define projections/idempotents in a Jordan algebra;
  - define states as positive trace-one elements;
  - show trace-one projections are states;
  - show pure states of the spin factor are spheres;
  - formalize `H_2(O)` as a spin factor or at least as a concrete 10-dimensional
    Jordan algebra with determinant of signature `(9,1)`.

### H2(O), octonionic qubits, and Spin(9)

Timestamp region: about 00:34-00:45 and 00:49-00:50.

Choosing a unit imaginary octonion `I` picks out a copy of the complex numbers
inside the octonions:

```text
C = span_R {1, I} subset O
```

It also gives a splitting of the octonions into the chosen complex line plus a
six-dimensional real complement, which becomes a three-dimensional complex
space by left multiplication by `I`.

The same idea applies to `H_2(O)`: the chosen `C subset O` embeds `H_2(C)` into
`H_2(O)`, and the orthogonal complement is a three-dimensional complex vector
space. Baez identifies `H_2(O)` both with 10-dimensional Minkowski spacetime
and with the observables of an octonionic qubit.

The automorphism group of `H_2(O)` is `O(9)`. But if `H_2(O)` is viewed as a
Jordan subalgebra of `H_3(O)`, then the subgroup of `Aut(H_3(O)) = F4` that
preserves this copy of `H_2(O)` is `Spin(9)`. This is Baez's conceptual answer
to why the double cover `Spin(9)`, rather than just `O(9)`, appears.

There is a representation decomposition:

```text
H_3(O) ~= H_2(O) + O^2 + R
```

under `Spin(9)`, where:

- `R` is the trivial/scalar piece;
- `H_2(O)` is the vector representation;
- `O^2` is the real spinor representation.

Project implications:

- Formalizing `H_3(O)` should preserve the block decomposition into
  `H_2(O)`, `O^2`, and `R`.
- A future theorem target is:

```lean
-- eventual shape, not current code
stabilizer_H2O_in_Aut_H3O_is_spin9
```

- This result is likely too large for near-term trusted code, but it can be
  broken into finite-coordinate stabilizer statements and representation
  dimension checks.

### H3(O), F4, and the Standard Model gauge group

Timestamp region: about 00:45-00:59.

The exceptional Jordan algebra `H_3(O)` is interpreted as the algebra of
observables of an octonionic qutrit. Its automorphism group is the compact
exceptional group `F4`.

Baez reviews the following stabilizer sequence:

1. Start with `Aut(H_3(O)) = F4`.
2. Choose a copy of `H_2(O)` inside `H_3(O)`.
   The stabilizer is `Spin(9)`.
3. Choose a unit imaginary octonion `I`, giving a copy of `C` inside `O`,
   a splitting of `H_3(O)`, and a complex structure on the complementary
   space.
   The stabilizer of this induced structure is:

```text
(SU(3) x SU(3)) / Z3
```

4. The subgroup preserving both the `I`-induced structure and the chosen
   `H_2(O)` is the true Standard Model gauge group:

```text
S(U(2) x U(3))
```

Baez describes the two `SU(3)` factors in the intermediate group as having
different meanings:

- one `SU(3)` becomes the strong/color `SU(3)`;
- the other is a larger primordial symmetry whose subgroup becomes
  electroweak `U(1) x SU(2)` after requiring preservation of the chosen
  `H_2(O)` block structure.

Project implications:

- This suggests a clean formalization target that is group-theoretic rather
  than particle-model-first:

```text
SM gauge group = intersection of two stabilizers in F4
```

- It is valuable to formalize `S(U(2) x U(3))` explicitly as the "true" gauge
  group, including the finite central quotient relative to
  `U(1) x SU(2) x SU(3)`.
- The project should avoid replacing this with a naive direct product unless
  the quotient/kernel is explicitly documented.

### Fermion representations remain the hard gap

Timestamp region: about 00:59-01:02 and 01:11-01:13.

Baez says the gauge group story is not enough. One still needs to explain the
representation on fermions.

Krasnov's work gives a description of the Standard Model gauge group as the
subgroup of `Spin(9)` whose action on `O^2` commutes with right multiplication
by the chosen unit imaginary octonion. With the induced complex structure, this
action on `O^2` matches the left-handed fermions in one generation.

But Baez notes that the right-handed fermions are not naturally present in this
particular description. This is one of the main unresolved issues.

Project implications:

- This maps directly onto our current Furey anomaly bridge caution:
  getting anomaly arithmetic is not enough; we need a theorem identifying the
  correct chiral multiplet table.
- A useful proof target is:

```text
action on O^2 with chosen complex structure ~= left-handed one-generation SM
representation
```

- The right-handed sector should be tracked as an explicit open problem rather
  than silently supplied by `Jbar` or charge conjugation.

## Q&A and speculative directions

### Dynamics and geometry

Timestamp region: about 01:02-01:05.

Lee Smolin asks whether the construction can be turned into geometry or a
connection over a 3+1-dimensional manifold, rather than only representation
theory. Baez says he has not developed such dynamics. He notes that `H_2(C)`
gives a visible copy of Minkowski spacetime and that one could at least build a
trivial bundle with the Standard Model gauge group over it, but no Yang-Mills
or topological field theory has been written in this talk.

Project implications:

- Dynamics is out of scope for the near-term Lean formalization.
- A reasonable intermediate target is only the bundle/interface layer:
  spacetime base, gauge group, representation data.

### Why choose a unit imaginary octonion?

Timestamp region: about 01:05-01:10.

The discussion raises a possible physical motivation for selecting a unit
imaginary octonion: in ordinary complex quantum mechanics, the imaginary unit
appears in time evolution and symmetry generation. For more general Jordan
algebras, derivations can be generated by associators rather than by a single
commutator with `iH`. Baez says this connection is worth thinking about and
mentions Nambu mechanics as related background.

Project implications:

- There may be a formal bridge between Jordan associators, derivations, and
  symmetry generators.
- This is relevant to current `OctonionSymmetry.lean` work on derivations.

### The second SU(3), generations, and E6

Timestamp region: about 01:10-01:13.

Baez says the second `SU(3)` in `(SU(3) x SU(3)) / Z3` is tempting to identify
with generations or flavor, but he does not know how to make that work. He
views it more naturally as a primordial symmetry containing the electroweak
`U(1) x SU(2)`.

On complexifying `H_3(O)` and bringing in `E6`, he does not give a concrete
obstacle or solution. He again emphasizes the pressing issue that left-handed
fermions appear more readily than right-handed fermions in the octonionic
qubit picture.

Project implications:

- Treat "three generations from the three rows/columns of H_3(O)" as
  speculative unless a precise representation theorem is available.
- `E6` should be tracked as a possible future extension, not as a current
  ingredient in the gauge-group theorem.

### Intrinsic Jordan-algebra formulation

Timestamp region: about 01:13-01:18.

An audience question asks whether one can state the structure intrinsically in
terms of `H_3(O)` as an anonymous Jordan algebra, rather than first choosing
the octonion matrix presentation. Baez likes this as a math problem: determine
what extra structure on the Albert algebra breaks `F4` down to the Standard
Model gauge group, stated purely in Jordan-algebra language.

The proposed intrinsic route:

1. choose a primitive idempotent, equivalently a point of the octonionic
   projective plane `OP^2`;
2. this selects an `H_2(O)` subalgebra as the orthogonal complement relative to
   trace;
3. possibly choose additional geometric data, such as a geodesic curve on the
   pure-state sphere inside that `H_2(O)`.

Baez agrees the first step is equivalent to choosing `H_2(O)` and says extra
structure is still needed to reach the Standard Model group.

Project implications:

- Intrinsic formulation target:

```text
primitive idempotent in H_3(O) <-> embedded H_2(O)
```

- A later stabilizer theorem could avoid matrix-coordinate choices if this
  intrinsic setup is formalized.

### SU(3), color, and octonions from C + C3

Timestamp region: about 01:26-01:35.

Michel Dubois-Violette comments on the naturalness of `SU(3)` rather than
`U(3)` for color. A complex volume form on `C^3`, together with the Hermitian
inner product, defines a conjugate-linear cross product. Extending `C + C^3`
with this product gives the octonions. The subgroup preserving the chosen unit
imaginary octonion is `SU(3)`, because it preserves the Hermitian form and
volume form on `C^3`.

Baez agrees and connects this to the familiar fact:

```text
Stab_G2(I) ~= SU(3)
```

for a unit imaginary octonion `I`.

Project implications:

- This is a highly tractable Lean target compared with the full `F4` story:

```text
O = C + C^3 with Hermitian form and volume form
Stab_G2(I) = SU(3)
```

- It connects to our existing octonion convention bridge and future `G2`
  automorphism work.

## Slide-deck supplement: Main Conjecture and projective geometry

The slides provide a more formal projective-geometry framework than the
YouTube transcript alone.

### Algebraic Main Conjecture

Let `A, B` be Jordan subalgebras of `h_3(O)` satisfying:

```text
A ~= h_2(O)
B ~= h_3(C)
A cap B ~= h_2(C)
```

The Main Conjecture states:

```text
Stab(A) cap Stab(B) ~= S(U(2) x U(3)).
```

Here the stabilizers are taken inside `Aut(h_3(O)) = F4`.

The concrete block example is:

```text
h_3(O) = { [[alpha, z, y*],
            [z*, beta, x],
            [y, x*, gamma]]
          : alpha beta gamma in R, x y z in O }

A = { [[alpha, z, 0],
      [z*, beta, 0],
      [0, 0, 0]]
    : alpha beta in R, z in O } ~= h_2(O)

B = same form as h_3(O), but with x y z in C, so B ~= h_3(C)

A cap B = the same 2 by 2 block as A, but with z in C, so A cap B ~= h_2(C)
```

For this example:

```text
Stab(A) ~= Spin(9)
Stab(B) ~= (SU(3) x SU(3)) / Z3
Stab(A) cap Stab(B) ~= S(U(2) x U(3)).
```

The conjectural universal step is:

```text
F4 acts transitively on pairs (A, B)
with A ~= h_2(O), B ~= h_3(C), and A cap B ~= h_2(C).
```

If true, this reduces every such pair to the Dubois-Violette-Todorov block
example and proves the Main Conjecture.

### Preliminary lemmas in the slides

The slides report two preliminary results:

```text
Lemma 1. F4 acts transitively on Jordan subalgebras A subset h_3(O)
with A ~= h_2(O).

Lemma 2. F4 acts transitively on Jordan subalgebras B subset h_3(O)
with B ~= h_3(C).
```

These are weaker than the conjectured pair-transitivity lemma because they do
not control the intersection condition `A cap B ~= h_2(C)` simultaneously.

Project implication: in Lean, the pair version should be a separate theorem
from the two one-object transitivity theorems. It is exactly where the geometry
becomes more constrained.

### Projective-plane dictionary

For `K = R, C, H, O`, the Jordan algebra `h_3(K)` defines the projective plane
`KP^2`.

The dictionary is:

- a projection `p` satisfies `p o p = p`;
- `tr(p) = 1` means `p` is a point;
- `tr(p) = 2` means `p` is a line;
- a point `p` lies on a line `ell` when `p o ell = p`.

For `h_3(K)`, points and lines obey the projective-plane axioms:

- any two distinct points lie on a unique line;
- any two distinct lines meet in a unique point.

The point manifolds have dimensions:

```text
RP^2: 2
CP^2: 4
HP^2: 8
OP^2: 16
```

The projective lines are:

```text
RP^1 ~= S^1
CP^1 ~= S^2
HP^1 ~= S^4
OP^1 ~= S^8
```

Project implication: the `h_3(O)` formalization should expose projections,
trace, points, lines, and incidence as named structures. This will make the
eventual stabilizer statements more conceptual and less matrix-coordinate
bound.

### Subalgebras as projective subspaces

The slides state an equivariant bijection:

```text
{A subset h_3(O) : A ~= h_2(O)}
<-> {octonionic projective lines ell in OP^2}.
```

The map sends `A` to its identity element `ell`, which is a trace-two
projection. In the standard example, the identity of the upper-left `h_2(O)`
block is:

```text
ell = diag(1, 1, 0).
```

Similarly, there is an equivariant bijection:

```text
{B subset h_3(O) : B ~= h_3(C)}
<-> {complex projective planes X in OP^2}.
```

Here `X` is the submanifold of `OP^2` consisting of trace-one projections lying
inside `B`; it has the structure of `CP^2`.

The projective-geometry version of the Main Conjecture is:

```text
Suppose X is a complex projective plane in OP^2,
ell is an octonionic projective line in OP^2,
and X cap ell is a complex projective line in X.

Then
Stab(X) cap Stab(ell) ~= S(U(2) x U(3)).
```

This is a cleaner geometric restatement of the algebraic subalgebra
conjecture.

### Important caution from the slides

The slides explicitly warn that this conjecture, even if true, should not be
read as an explanation of the Standard Model. It may be a red herring. The
safe conclusion is narrower:

```text
The Standard Model gauge group appears naturally as a stabilizer intersection
in the projective geometry of OP^2 / the exceptional Jordan algebra.
```

This warning fits the repository philosophy: formalize the stabilizer theorem
first, and keep the physics interpretation in a separate layer.

## Suggested proof-target roadmap from this talk

### Near-term targets

1. Define the true Standard Model gauge group as `S(U(2) x U(3))`, with the
   central quotient from `U(1) x SU(2) x SU(3)` documented.
2. Prove exact arithmetic facts for the one-generation Standard Model
   representation table, including anomaly cancellation.
3. Define projective-geometry scaffolding for `h_3(K)`:
   - projections;
   - trace-one points;
   - trace-two lines;
   - incidence `p o ell = p`.
4. Formalize `Stab_G2(I) ~= SU(3)` as a staged target:
   - first as a statement;
   - then through a concrete `C + C^3` model;
   - finally as an automorphism-group theorem.
5. Add a source note to the Furey bridge: the left/right-handed fermion issue is
   open in the Baez/Dubois-Violette/Todorov/Krasnov route.

### Medium-term targets

1. Define Euclidean Jordan algebra scaffolding sufficient for:
   - Jordan product;
   - squares and sums of squares;
   - projections/idempotents;
   - trace and determinant hooks.
2. Define concrete `H_2(O)` and prove its spin-factor-like structure.
3. Define concrete `H_3(O)` as self-adjoint octonionic matrices, with extreme
   care around nonassociativity.
4. Prove the block decomposition:

```text
H_3(O) ~= H_2(O) + O^2 + R
```

5. Prove the two subalgebra/projective-subspace dictionaries:
   - `h_2(O)` subalgebras correspond to octonionic projective lines in `OP^2`;
   - `h_3(C)` subalgebras correspond to complex projective planes in `OP^2`.

### Long-term targets

1. `Aut(H_3(O)) = F4`.
2. `Stabilizer_F4(H_2(O)) = Spin(9)`.
3. Stabilizer of a unit-imaginary-induced splitting and complex structure is
   `(SU(3) x SU(3)) / Z3`.
4. Intersection of that stabilizer with `Stabilizer_F4(H_2(O))` is
   `S(U(2) x U(3))`.
5. Pair transitivity: `F4` acts transitively on pairs `(A, B)` with
   `A ~= h_2(O)`, `B ~= h_3(C)`, and `A cap B ~= h_2(C)`.
6. Projective-geometry Main Conjecture:
   `Stab(X) cap Stab(ell) ~= S(U(2) x U(3))` when
   `X cap ell ~= CP^1`.
7. Fermion representation theorem for the action on `O^2`, including an
   explicit statement of what happens to right-handed fermions.

## Would slide images be useful?

Yes. The transcript is enough for a conceptual source note, but screenshots of
specific slides would be valuable for exact formulas and diagrams. The most
useful slides to capture would be:

1. the classification table of finite-dimensional Euclidean Jordan algebras;
2. the spin-factor cone/state/pure-state diagram;
3. the `H_2(O)` and `H_2(C)` splitting after choosing a unit imaginary
   octonion;
4. the `H_3(O) = H_2(O) + O^2 + R` block decomposition;
5. the stabilizer chain involving `F4`, `Spin(9)`, `(SU(3) x SU(3)) / Z3`, and
   `S(U(2) x U(3))`;
6. the final summary slide describing the Standard Model gauge group as
   automorphisms of an octonionic qutrit preserving the unit-imaginary
   structure and an octonionic qubit.

Those screenshots would help us avoid transcription errors in group names,
quotients, and block decompositions.
