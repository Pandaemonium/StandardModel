# Literature and formalization search: exceptional Jordan projective geometry

Purpose: collect helpful public references for formalizing the Baez-Schwahn
projective-geometry conjecture around `h_3(O)`, `OP^2`, and the Standard Model
gauge group.

Search date: 2026-05-06.

## Primary sources

### Baez and Schwahn slides

Reference:
<https://math.ucr.edu/home/baez/standard/exceptional.pdf>

Baez's 2026 slides state the projective-geometry version most directly. The
key conjecture is that, if `X` is a complex projective plane in `OP^2`, `ell`
is an octonionic projective line in `OP^2`, and `X cap ell` is a complex
projective line in `X`, then the automorphism group of `h_3(O)` preserving
both is:

```text
S(U(2) x U(3)).
```

The slides reduce this to a conjectural transitivity lemma: `F4` should act
transitively on pairs of Jordan subalgebras `A, B subset h_3(O)` with
`A ~= h_2(O)`, `B ~= h_3(C)`, and `A cap B ~= h_2(C)`.

Use in Lean:

- source for the exact conjecture statement;
- source for the dictionary between subalgebras and projective subspaces;
- source for the standard block example and stabilizer targets.

### Baez blog note

Reference:
<https://golem.ph.utexas.edu/category/2026/03/geometry_and_the_exceptional_j.html>

The n-Category Cafe announcement gives a compact abstract of the joint
Baez-Schwahn project. It says Dubois-Violette and Todorov observed that the
Standard Model gauge group is an intersection of two maximal subgroups of
`F4`, and that Baez-Schwahn conjecture a more flexible projective-geometry
statement where any suitable octonionic projective line and complex projective
plane should give the same stabilizer group.

Use in Lean:

- concise provenance for the projective version;
- good wording for the final documentation warning that this is a mathematical
  stabilizer theorem, not a physical derivation.

### Dubois-Violette and Todorov

Reference:
<https://www.researchgate.net/publication/326502016_Deducing_the_symmetry_of_the_standard_model_from_the_automorphism_and_structure_groups_of_the_exceptional_Jordan_algebra>

Bibliographic details from the public page:

```text
Ivan Todorov and Michel Dubois-Violette,
"Deducing the symmetry of the standard model from the automorphism and
structure groups of the exceptional Jordan algebra",
International Journal of Modern Physics A 33(20), 1850118, 2018.
DOI: 10.1142/S0217751X1850118X
```

The public abstract says the paper studies `J = J_3^8 = H_3(O)` and uses
Borel-de Siebenthal theory of maximal connected subgroups of compact simple Lie
groups to deduce the symmetry of the model.

Use in Lean:

- source for the standard block-pair stabilizer calculation;
- source for the `F4`, `Spin(9)`, and `(SU(3) x SU(3))/Z3` subgroup facts;
- likely not a near-term source for constructive coordinate proofs.

### Krasnov SO(9) characterization

References:

- <https://nottingham-repository.worktribe.com/output/5347800/so9-characterization-of-the-standard-model-gauge-group>
- arXiv DOI listed publicly as <https://doi.org/10.48550/arXiv.1912.11282>

The Nottingham repository abstract says Krasnov gives a more explicit
description of the Standard Model gauge group as the subgroup of `SO(9)`, or
more precisely a subgroup of `Spin(9)` acting on `O^2`, that preserves or
commutes with the complex structure induced by a chosen unit imaginary
octonion. It identifies the preserved split:

```text
O = C + C^3
```

and the resulting group:

```text
SU(3) x SU(2) x U(1) / Z6.
```

Use in Lean:

- alternative route that may be more concrete than full `F4`;
- source for a staged theorem about `O = C + C^3` and a `Spin(9)` stabilizer;
- useful fallback if the `h_3(O)` automorphism group is too large initially.

### Geometry over composition algebras

Reference:
<https://www.sciencedirect.com/science/article/pii/S0021869306000883>

The public abstract says the paper introduces projective geometry over
composition algebras, with projective spaces corresponding to Jordan algebras
and points corresponding to rank-one matrices in the Jordan algebra.

Use in Lean:

- source for the projective geometry over composition algebras;
- source for rank-one/projection matrix definitions;
- likely useful for the `OP^2` point/line dictionary.

### Baez, "The Octonions"

Reference:
<https://math.ucr.edu/home/baez/octonions/node8.html>

Baez's octonion notes explain the relationship between the exceptional Jordan
algebra and the octonionic projective plane. The public page says that
starting from the exceptional Jordan algebra gives the Moufang plane `OP^2`,
and discusses `h_2(O)` and the octonionic projective line.

Use in Lean:

- source for projective lines, `OP^1`, `OP^2`, and the exceptional Jordan
  algebra;
- helpful for introductory module documentation.

## Existing Lean/formalization findings

I did not find an obvious public Lean formalization of:

- the exceptional Jordan algebra,
- the Albert algebra,
- `OP^2`,
- the `F4` automorphism group of `h_3(O)`,
- the Baez-Schwahn projective-geometry conjecture.

Local project status:

- `PhysicsSM/Algebra/Jordan/H3O.lean` exists but is currently a stub.
- The project already has a concrete octonion model, conjugation, norm, and
  Moufang identities.
- Mathlib provides broad group/subgroup, matrix, linear algebra, and projective
  module infrastructure, but there does not appear to be a ready-made
  Euclidean Jordan algebra hierarchy or exceptional Jordan algebra module in
  the local pinned mathlib.

## Recommended formalization strategy

The final conjecture is too large to attack directly. The most useful initial
Lean scaffold should separate four layers:

1. Concrete `h_3(O)` coordinates:
   six fields `alpha beta gamma : R` and `x y z : O`, representing the
   Hermitian matrix

```text
[[alpha, z, conj y],
 [conj z, beta, x],
 [y, conj x, gamma]].
```

2. Jordan/projective dictionary:
   trace, Jordan product, projections, points, lines, incidence.

3. Standard block subalgebras:
   `standardA ~= h_2(O)`, `standardB ~= h_3(C)`, and
   `standardA cap standardB ~= h_2(C)`.

4. Stabilizer frontier:
   state the standard stabilizer theorem and the pair-transitivity theorem as
   explicit draft targets. Prove smaller preservation/intersection facts first.

The best Aristotle job should ask for all finite-coordinate pieces, while
allowing the final Lie-group isomorphism statements to remain in draft with
precise handoff notes if the available infrastructure is insufficient.
