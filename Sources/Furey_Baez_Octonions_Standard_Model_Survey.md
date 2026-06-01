# Furey, Baez, and Octonionic Approaches to the Standard Model

Last checked: 2026-05-31.

This note is a high-level research survey, not a proof plan.  Its purpose is to
explain the main ideas around Cohl Furey's division-algebraic Standard Model
program, John Baez's octonionic and exceptional-Jordan interpretation, and
nearby work by related authors.

The short version:

```text
Furey side:
  division algebras -> ladder operators -> ideals -> particle quantum numbers

Baez/Dubois-Violette/Todorov side:
  h3(O) and exceptional groups -> stabilizers -> Standard Model gauge group

Recent bridge:
  complex structures, triality, pure spinors, and S3 family symmetries
  are being used to attack symmetry breaking and the three-generation problem.
```

The work is mathematically rich, but it should be read with a careful claim
boundary.  These programs have uncovered striking algebraic coincidences and
many precise representation-theoretic structures.  They have not yet produced a
universally accepted derivation of the full Standard Model dynamics, masses,
mixing angles, or Lagrangian from octonions alone.

## 1. The Shared Motivation

The Standard Model looks both rigid and oddly assembled.  Its gauge algebra
contains:

```text
su(3)_C + su(2)_L + u(1)_Y
```

and its true compact gauge group is often better written as:

```text
S(U(2) x U(3)) ~= (SU(3) x SU(2) x U(1)) / Z6.
```

The octonion programs ask whether this structure is less arbitrary than it
looks.  Octonions are naturally tied to:

- `G2`, the automorphism group of the octonions;
- `SU(3)`, the subgroup of `G2` fixing a chosen imaginary unit;
- Clifford algebras and spinors;
- triality for `Spin(8)`;
- exceptional Jordan algebra `h3(O)`;
- exceptional groups such as `F4`, `E6`, and `E8`.

That is enough structure to make the Standard Model reappear in several
different guises.  The real challenge is deciding which appearances are merely
beautiful notation and which are mathematically or physically explanatory.

## 2. Furey's Program: Particles From Ideals and Ladder Operators

Furey's work starts from the Dixon algebra:

```text
R tensor C tensor H tensor O
```

and asks what happens when the algebra acts on itself.  Instead of treating
particles as vectors inserted by hand into a representation, the program tries
to obtain particle-like states from minimal ideals, ladder operators, and
number operators internal to the algebra.

### 2.1 One Generation

The early Furey picture uses the complex octonions `C tensor O` to build
fermionic ladder operators.  The resulting algebra behaves like a complex
Clifford algebra, usually `Cl(6)`, and its minimal left ideals carry states
that transform like one generation of quarks and leptons under:

```text
SU(3)_C x U(1)_em.
```

The conceptual move is simple but powerful:

```text
octonionic ladder operators
  -> minimal left ideals
  -> particle states
  -> number operator
  -> electric charge
```

In "Charge quantization from a number operator", Furey argues that electric
charge appears as a scaled number operator.  That gives an algebraic explanation
for charge quantization: occupation numbers are integral, and the charge
operator is a fixed rational multiple of the number operator.

The thesis "Standard model physics from an algebra?" broadens this into a more
complete program.  The complex quaternionic part is used for Lorentz
representations, while the complex octonionic part supplies color and charge
representations.  The thesis also proposes a rudimentary electroweak story in
which `SU(2)_L` acts chirally.

### 2.2 The Full Gauge Group and the Z6 Quotient

Furey's 2018 EPJC paper sharpens the gauge symmetry claim.  The main target is:

```text
G_SM = (SU(3)_C x SU(2)_L x U(1)_Y) / Z6,
```

with a possible extra `U(1)_X` when using `U(n)` rather than `SU(n)` ladder
symmetries.

The important feature here is that Furey's construction resembles aspects of
`SU(5)` unification, but the algebraic actions carry extra labels.  Some
transitions that would normally mediate proton decay in an `SU(5)`-like model
are argued to be blocked because they mix distinct algebraic action types.

For formalization, this is attractive because it decomposes into finite,
checkable pieces:

- ladder-operator anticommutation;
- minimal ideal bases;
- charge eigenvalues;
- color and weak representation tables;
- the finite `Z6` kernel of the covering map.

The hard part is not arithmetic.  The hard part is semantic alignment: making
sure the Lean statements really correspond to the intended physics
representations and not just to a convenient finite table.

### 2.3 Three Generations

The original one-generation picture is not enough.  Recent Furey-related work
has focused heavily on the three-generation problem.

Furey's "Three generations, two unbroken gauge symmetries, and one
eight-dimensional algebra" observes that the complex octonions generate a
64-complex-dimensional left-action algebra.  Inside it, one finds states with
the behavior of three generations under the unbroken symmetries:

```text
SU(3)_C x U(1)_em.
```

The newer Furey-Hughes papers move toward a more structural explanation.
"Division algebraic symmetry breaking" uses a sequence of complex structures
associated to:

```text
O, then H, then C
```

to organize a symmetry-breaking cascade:

```text
Spin(10)
  -> Pati-Salam
  -> left-right symmetric model
  -> Standard Model + B-L.
```

"Three Generations and a Trio of Trialities" is especially important for the
current frontier.  It identifies the Standard Model internal symmetries inside:

```text
tri(C) + tri(H) + tri(O),
```

then applies the corresponding group action to a triality triple:

```text
(Psi_+, Psi_-, V), where each term lies in C tensor H tensor O.
```

In that picture, two generations come from the spinorial pieces `Psi_+` and
`Psi_-`, while the third is tied to the vector piece `V` through a Cartan
factorization.  This is one of the cleanest recent attempts to make
"three generations from triality" into a concrete representation-theoretic
claim.

## 3. Baez's Program: The Standard Model as Exceptional Geometry

Baez's role is different from Furey's.  Furey builds particle states from
division-algebraic operators and ideals.  Baez emphasizes the geometry and group
theory that make the Standard Model group look inevitable.

### 3.1 The GUT Square

Baez and Huerta's "The Algebra of Grand Unified Theories" is not primarily an
octonion paper.  It is an expository mathematical account of how the Standard
Model group sits inside the three classic GUT frameworks:

```text
SU(5)
Spin(10)
Pati-Salam
```

The key lesson for our purposes is that the Standard Model gauge group is best
treated with its finite quotient structure intact.  The naive product
`SU(3) x SU(2) x U(1)` is not quite the whole story; the quotient by `Z6` is
part of the representation theory.

That viewpoint lines up beautifully with Furey's 2018 ladder-operator result,
which also lands on the `Z6` quotient.

### 3.2 Octonions and the Exceptional Jordan Algebra

Baez's 2021 "Can We Understand the Standard Model Using Octonions?" talks build
on work of Dubois-Violette and Todorov.  The central object is the exceptional
Jordan algebra:

```text
h3(O) = 3 x 3 self-adjoint octonionic matrices.
```

This can be interpreted as an "octonionic qutrit".  Its automorphism group is
`F4`.  Dubois-Violette and Todorov identify the Standard Model group as an
intersection of special subgroups inside this exceptional setting.

Baez's explanatory reframing is:

```text
Standard Model group
  = symmetries of an octonionic qutrit
    that restrict to an octonionic qubit
    and preserve the structure coming from a chosen unit imaginary octonion.
```

The chosen imaginary octonion `I` selects a copy of the complex numbers:

```text
C = span_R {1, I} inside O.
```

The complement then behaves like a 3-dimensional complex vector space:

```text
O = C + C^3
```

This is the basic reason `SU(3)` keeps appearing: the automorphisms of `O` that
fix `I` preserve the complex structure and act on the `C^3` complement.

### 3.3 The 2026 Baez-Schwahn Direction

The newer Baez-Schwahn slides push the exceptional-Jordan story toward
projective geometry.  Their conjectural picture is:

```text
OP^2 contains:
  an octonionic projective line OP^1,
  a complex projective plane CP^2,
  intersecting in a complex projective line CP^1.
```

Then the Standard Model group acts as the symmetry group preserving this
incidence pattern.  This is not just a prettier version of the same theorem:
it suggests that the physically relevant group is the stabilizer of a geometric
configuration in the octonionic projective plane.

For formalization, this is tempting because incidence geometry often admits
clean finite-dimensional statements.  But it also requires great care:
projective geometry over octonions is subtle because octonions are
nonassociative, and over complexified octonions even basic incidence rules can
fail if naively copied from associative projective geometry.

## 4. Dubois-Violette, Todorov, and the Exceptional Jordan Stabilizer Picture

Dubois-Violette and Todorov are the main source for the exceptional-Jordan
stabilizer theorem that Baez discusses.  Their work considers:

```text
J = h3(O),
Aut(J) = F4,
```

and uses exceptional group theory, including maximal subgroup structure, to
recover the Standard Model symmetry group.  The key group is:

```text
S(U(2) x U(3)).
```

The appeal is that this group is not inserted as a product of observed gauge
groups.  It appears as an intersection of natural symmetry groups of a highly
structured object.

For our formalization project, this is the long-term Baez/DVT target:

```text
h3(O)
  -> standard h3(C) subalgebra and complement
  -> octonionic qubit h2(O)
  -> stabilizer/intersection theorem
  -> S(U(2) x U(3)).
```

We have formalized pieces of the coordinate scaffold, but not the full `F4`
stabilizer theorem.

## 5. Krasnov: Complex Structures, Spin(9), Spin(10), and Pure Spinors

Krasnov gives one of the clearest bridges between the Baez/DVT exceptional
geometry and more conventional spinor/GUT language.

In "SO(9) characterisation of the Standard Model gauge group", Krasnov
characterizes the Standard Model group as a subgroup of `Spin(9)` commuting
with a complex structure on the octonionic spinor space `O^2`.  This complex
structure is parametrized by a choice of unit imaginary octonion.

In the 2025 paper "Octonions, complex structures and Standard Model fermions",
Krasnov reframes the `Spin(10)` and `SU(5)` story using two suitably aligned
commuting complex structures on `R^10`.  These complex structures can be encoded
by pure spinors of `Spin(10)`, and the octonionic model of the spinors gives an
efficient description.

This direction is important because it says:

```text
The octonions are not merely a state-labeling trick.
They package the complex structures that select the Standard Model subgroup.
```

That is very close in spirit to Baez's chosen-imaginary-octonion story and to
Furey-Hughes symmetry breaking by successive complex structures.

## 6. Boyle: Exceptional Jordan Algebra, Triality, and Generations

Latham Boyle's "The Standard Model, The Exceptional Jordan Algebra, and
Triality" connects three motifs:

- the complexified exceptional Jordan algebra;
- the minimal left-right-symmetric extension of the Standard Model;
- `Spin(10)` unification.

The geometric proposal is that one generation of Standard Model fermions is
described by the tangent space:

```text
(C tensor O)^2
```

of the complex octonionic projective plane, while the existence of three
generations is related to `SO(8)` triality.

This is a useful conceptual bridge between Baez's projective geometry and
Furey's triality-heavy generation work.  It suggests that "three generations"
may be attached not simply to three copies of an algebra, but to three roles
related by triality:

```text
spinor, conjugate spinor, vector.
```

## 7. Gresnigt, Gourlay, Varma: Sedenions, S3, and Clifford Algebra

The Gresnigt/Gourlay/Varma line is adjacent rather than identical to the
Furey/Baez line, but it is one of the most active recent directions.

The main idea is that the sedenions `S`, despite no longer being division
algebras, have an `S3` symmetry not available in the octonions.  That `S3`
symmetry can act as a family symmetry, generating three generations from one
algebraic seed.

Recent papers move through several stages:

- complex sedenions and three generations under `SU(3)_C x U(1)_em`;
- `Cl(8)` as the algebra of complex-linear maps on complexified sedenions;
- an `S3`-invariant electric-charge operator;
- a 2026 `Cl(10)` model targeting the full
  `SU(3)_C x SU(2)_L x U(1)_Y` gauge group with three linearly independent
  generations.

This is more Clifford-algebraic than octonionic in its final form, but it is
still part of the same ecosystem:

```text
octonions -> left actions -> Clifford algebras
sedenions -> S3 family symmetry -> larger Clifford algebras
```

It also sharpens a recurring lesson: many "octonion" models eventually rely on
associative envelopes, left/right multiplication chains, or Clifford algebras
generated by octonionic actions.  That is not a defect, but it should be stated
honestly.

## 8. Historical and Critical Background

The octonion/Standard Model story did not begin with Furey.  Gunaydin and
Gursey studied octonions and quark structure in the 1970s, including the
appearance of `SU(3)` and triality-related structure.  Dixon later developed a
division-algebraic physics program around `C tensor H tensor O`, which is a
major ancestor of the Furey program.

There is also a skeptical strand.  Rowlands and Rowlands argue that octonions
are not themselves the best physical object because of nonassociativity; what
often does the useful work is an adjoint or left-multiplied algebra, effectively
a Clifford algebra.  Whether one sees this as a critique or a clarification,
it is important for formalization.  In Lean, the associative Clifford envelope
and the nonassociative octonion algebra must not be conflated.

## 9. How These Threads Fit Together

There are three broad strategies:

### Operator/Ideal Strategy

Representative authors: Furey, Dixon, Stoica, Gresnigt/Gourlay.

```text
division algebra actions
  -> Clifford algebra
  -> ladder operators
  -> minimal ideals
  -> particle states and charges
```

This is the easiest to formalize incrementally because many claims reduce to
finite algebraic identities.

### Stabilizer/Geometry Strategy

Representative authors: Dubois-Violette, Todorov, Baez, Krasnov, Boyle.

```text
octonionic Jordan geometry
  -> exceptional groups
  -> stabilizers and intersections
  -> S(U(2) x U(3))
```

This is conceptually elegant, but formalizing the full theorem requires much
heavier Lie theory, Jordan algebra, projective geometry, and group-action
infrastructure.

### Triality/Generation Strategy

Representative authors: Furey-Hughes, Boyle, Gresnigt/Gourlay/Varma.

```text
triality or S3 symmetry
  -> three related algebraic roles
  -> three fermion generations
```

This is currently one of the most active and promising directions, but also one
of the easiest places to overclaim.  A formalization should first prove exact
representation decompositions and only later attach physical interpretation.

## 10. What We Have Formalized Here, Briefly

The repository has a growing Lean scaffold for all three strategies:

- real octonions, conjugation, norm, Moufang/alternativity-style infrastructure;
- complex splitting `O = C + C^3` relative to a chosen imaginary direction;
- convention bridges for Baez/Furey signs versus the project XOR convention;
- Furey-style complex octonions, ladder operators, minimal ideals, charge and
  representation scaffolds;
- triality action scaffolds for the Furey-Hughes direction;
- `h3(O)` coordinate infrastructure, standard `h3(C)` subalgebra pieces, and
  complement-to-`M3(C)` bridges;
- DVT/Baez-style complement actions and two-sided matrix action scaffolds;
- finite Standard Model `Z6` kernel packages and covering-map wrappers;
- Krasnov-style octonionic qubit coordinate infrastructure.

Important things not yet formalized:

- the full Dubois-Violette/Todorov `F4` intersection theorem;
- a complete `Spin(9)` or `Spin(10)` centralizer theorem;
- a full proof that Furey's operators realize the entire Standard Model
  representation package without convention gaps;
- a full three-generation theorem for Furey-Hughes triality or
  Gresnigt/Gourlay `S3`;
- Standard Model dynamics, Lagrangian, Yukawa couplings, masses, CKM/PMNS
  mixing, or anomaly cancellation directly derived from octonions.

## 11. Most Promising Recent Directions

### A. Complex Structures as Symmetry-Breaking Data

This is the strongest common thread across Baez, Krasnov, and Furey-Hughes.
Choosing compatible complex structures appears to select the right subgroups:

```text
choose I in Im(O)
  -> O = C + C^3
  -> SU(3)-like color structure

choose aligned complex structures in Spin(10)
  -> Standard Model subgroup

choose successive structures from O, H, C
  -> symmetry-breaking cascade
```

This direction is mathematically concrete and formalization-friendly if broken
into small centralizer and preservation theorems.

### B. Triality as the Three-Generation Mechanism

Furey-Hughes and Boyle both point to triality as more than decorative symmetry.
The promising claim is not merely "triality has order three", but that the
three roles in a triality triple can carry the correct Standard Model
representations.

The formal target should be representation-level:

```text
Define the triality action.
Prove the three pieces transform as the claimed SM representations.
Only then call them generations.
```

### C. The True Gauge Group and the Z6 Kernel

The quotient by `Z6` is a place where Baez-Huerta, Furey, and conventional
representation theory agree.  It is also finite and formalizable.  This makes
it one of the safest publication-quality subgoals.

### D. Exceptional Jordan Incidence Geometry

The Baez-Schwahn projective-geometry reformulation is an appealing long-term
target.  If the Standard Model group is the stabilizer of:

```text
OP^1 and CP^2 intersecting in CP^1 inside OP^2,
```

then a formal proof would be conceptually cleaner than a large coordinate
intersection calculation.  But the foundations must be built carefully because
octonionic projective geometry is not ordinary projective geometry.

### E. Associative Envelopes and Clifford Models

Furey, Stoica, Rowlands, and Gresnigt/Gourlay all suggest that the actionable
object is often not raw `O`, but:

```text
left multiplication chains,
Cl(6),
Cl(8),
Cl(10),
or C tensor H tensor O acting on itself.
```

For Lean, this is good news.  Associative envelopes are much easier to connect
to existing algebra libraries than raw nonassociative multiplication.

## 12. Reading Map

Start here:

1. Baez, "Can We Understand the Standard Model Using Octonions?"
   gives the clearest geometric overview.
2. Furey's thesis gives the broadest account of the operator/ideal program.
3. Furey's 2018 ladder-operator paper is the most direct source for the
   `Z6` Standard Model group from ladder symmetries.
4. Dubois-Violette/Todorov is the source for the exceptional-Jordan stabilizer
   theorem.
5. Krasnov's 2019/2025 papers explain the complex-structure and pure-spinor
   version of the same story.
6. Furey-Hughes 2022/2024 and Boyle 2020 are the best entry points for the
   current triality/generation frontier.
7. Gresnigt/Gourlay/Varma are useful for the neighboring `S3` family-symmetry
   and Clifford-algebra approach.

## References

- John C. Baez, "The Octonions", arXiv:math/0105155.
  <https://arxiv.org/abs/math/0105155>

- John C. Baez and John Huerta, "The Algebra of Grand Unified Theories",
  arXiv:0904.1556.
  <https://arxiv.org/abs/0904.1556>

- John C. Baez, "Can We Understand the Standard Model Using Octonions?",
  2021 talk page.
  <https://math.ucr.edu/home/baez/standard/>

- John C. Baez and Paul Schwahn, "Projective Geometry and the Exceptional
  Jordan Algebra", 2026 slides.
  <https://math.ucr.edu/home/baez/standard/exceptional.pdf>

- C. Furey, "Charge quantization from a number operator", arXiv:1603.04078.
  <https://arxiv.org/abs/1603.04078>

- C. Furey, "Standard model physics from an algebra?", arXiv:1611.09182.
  <https://arxiv.org/abs/1611.09182>

- C. Furey, "SU(3)_C x SU(2)_L x U(1)_Y (x U(1)_X) as a symmetry of division
  algebraic ladder operators", arXiv:1806.00612.
  <https://arxiv.org/abs/1806.00612>

- C. Furey, "Three generations, two unbroken gauge symmetries, and one
  eight-dimensional algebra", arXiv:1910.08395.
  <https://arxiv.org/abs/1910.08395>

- N. Furey and M. J. Hughes, "Division algebraic symmetry breaking",
  arXiv:2210.10126.
  <https://arxiv.org/abs/2210.10126>

- N. Furey and M. J. Hughes, "Three Generations and a Trio of Trialities",
  arXiv:2409.17948.
  <https://arxiv.org/abs/2409.17948>

- Ivan Todorov and Michel Dubois-Violette, "Deducing the symmetry of the
  standard model from the automorphism and structure groups of the exceptional
  Jordan algebra", arXiv:1806.09450.
  <https://arxiv.org/abs/1806.09450>

- Ivan Todorov, "Exceptional quantum algebra for the standard model of particle
  physics", arXiv:1911.13124.
  <https://arxiv.org/abs/1911.13124>

- Kirill Krasnov, "SO(9) characterisation of the Standard Model gauge group",
  arXiv:1912.11282.
  <https://arxiv.org/abs/1912.11282>

- Kirill Krasnov, "Octonions, complex structures and Standard Model fermions",
  arXiv:2504.16465.
  <https://arxiv.org/abs/2504.16465>

- Latham Boyle, "The Standard Model, The Exceptional Jordan Algebra, and
  Triality", arXiv:2006.16265.
  <https://arxiv.org/abs/2006.16265>

- Niels G. Gresnigt, Liam Gourlay, and Abhinav Varma, "Three generations of
  colored fermions with S3 family symmetry from Cayley-Dickson sedenions",
  arXiv:2306.13098.
  <https://arxiv.org/abs/2306.13098>

- Liam Gourlay and Niels Gresnigt, "Algebraic realisation of three fermion
  generations with S3 family and unbroken gauge symmetry from C l(8)",
  arXiv:2407.01580.
  <https://arxiv.org/abs/2407.01580>

- Niels Gresnigt, "Electroweak Structure and Three Fermion Generations in
  Clifford Algebra with S3 Family Symmetry", arXiv:2601.07857.
  <https://arxiv.org/abs/2601.07857>

- Ovidiu Cristinel Stoica, "The Standard Model Algebra - Leptons, Quarks, and
  Gauge from the Complex Clifford Algebra Cl6", arXiv:1702.04336.
  <https://arxiv.org/abs/1702.04336>

- Murat Gunaydin and Feza Gursey, "Quark structure and octonions", Journal of
  Mathematical Physics 14, 1651-1667 (1973).
  <https://doi.org/10.1063/1.1666240>

- Murat Gunaydin and Feza Gursey, "Quark statistics and octonions",
  Physical Review D 9, 3387-3391 (1974).
  <https://doi.org/10.1103/PhysRevD.9.3387>

- Peter Rowlands and Sydney Rowlands, "Are octonions necessary to the Standard
  Model?", Journal of Physics: Conference Series 1251 (2019).
  <https://doi.org/10.1088/1742-6596/1251/1/012044>
