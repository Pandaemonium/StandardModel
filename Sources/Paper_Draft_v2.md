# Verified Octonionic Algebra for Standard Model Gauge Structure

**Draft v2 -- 2026-06-03**

Primary target: Annals of Formalized Mathematics.
Secondary target: ITP 2027.

This draft reorganizes `Paper_Draft_v1.md` around the formal artifact and the
reader's path through the theorem inventory. It deliberately avoids claiming
pending Aristotle results until they have been integrated and checked.

---

## Abstract

The Standard Model is full of algebraic structure that looks too organized to
be accidental and too delicate to trust to notation alone. Its compact gauge
group is not merely `U(1) x SU(2) x SU(3)`, but the quotient
`S(U(2) x U(3)) ~= (U(1) x SU(2) x SU(3)) / Z6`; its particles arrange
themselves into charge, color, and weak-isospin patterns; and several
octonionic programs propose that these patterns are shadows of exceptional
algebra.

This paper formalizes a shared algebraic spine behind those proposals. The
spine begins with a chosen complex line inside the octonions, which induces a
`C + C^3` splitting and makes the stabilizer story `G2 -> SU(3)` visible. It
then branches into Furey-style complex-octonion ladder operators and minimal
ideals, Baez and Dubois-Violette-Todorov style substructures of the exceptional
Jordan algebra `h3(O)`, Krasnov's octonionic complex structure on `O^2`, and
the matrix-level Standard Model gauge target.

We report a Lean 4 formalization of this shared structure. The project fixes
an explicit octonion convention, records convention bridges for formulas from
the literature, and collects the main kernel-checked theorem islands in a
paper-facing declaration, `fureyBaezDVTMainTheorem`. The verified results
include a coordinate octonion model with a chosen complex line, Furey operator
and one-generation electroweak table packages, the Standard Model `Z6`
gauge-kernel and block-subgroup scaffold, a coordinate model of the Albert
algebra `h3(O)` with Jordan identities and DVT-style central-kernel results,
an algebraic `G2`-stabilizer-to-`SU(3)` equivalence in the chosen coordinate
setting, inner-derivation identities for `h3(O)`, anomaly naturality under
charge-preserving relabeling, and Krasnov's complex structure on `O^2` as a
complex module.

The paper's claim is intentionally narrower than a physical derivation of the
Standard Model from octonions. The contribution is a kernel-checked audit
trail through an exciting but convention-heavy landscape: signs, quotients,
basis choices, and parenthesization become explicit mathematical data. A
machine-readable `ClaimBoundary` records non-results, including the absence of
a full DVT stabilizer theorem, a topological Lie-group quotient theorem, and
any claim about Standard Model dynamics.

---

## 1. Introduction

The Standard Model works astonishingly well, but its internal organization
still feels like a clue. Hypercharge assignments cancel anomalies in just the
right way. Quarks come in three colors, weak interactions see doublets, and
electric charge is tied to weak isospin by the Gell-Mann-Nishijima relation.
At the group level, the familiar notation `U(1) x SU(2) x SU(3)` hides a
finite central identification: the compact gauge group is more accurately
described by `S(U(2) x U(3))`, equivalently as a quotient by `Z6`.

The puzzle is not any single one of these facts in isolation. The puzzle is
that they cohere. The same small cast of algebraic characters keeps returning:
complex numbers, three-dimensional complex spaces, special unitary groups,
finite centers, exceptional structures, and charge tables with just enough
rigidity to be memorable. That recurrence is what makes the octonionic
literature compelling even for readers who remain cautious about its physical
interpretation. It suggests that there may be a compact mathematical grammar
behind parts of the Standard Model's representation theory.

That `Z6` is not cosmetic. It says that the three visible gauge factors share
central elements. In other words, the Standard Model gauge group is not merely
a pile of independent symmetries; it has a small but precise piece of global
glue. For anyone looking for deeper algebraic explanations of the Standard
Model, this is exactly the kind of feature one wants to understand rather than
erase.

Octonions are attractive in this search because they are the largest normed
division algebra and sit at the entrance to exceptional mathematics. Their
automorphism group is `G2`; choosing a unit imaginary octonion picks out a
copy of the complex numbers; and the six remaining imaginary directions can
be organized as a three-dimensional complex space. This is the first flash of
Standard-Model-looking structure: a natural route from octonions to `SU(3)`,
the color group.

The same choice of complex structure also appears, in different forms, across
several octonionic Standard Model programs. In Furey's work, complexified
octonions support ladder operators whose minimal ideals encode charge and
color arithmetic for a generation of fermions. In Baez's exposition, choosing
a complex line inside the octonions explains why the stabilizer of that line
acts like `SU(3)` on a complementary `C^3`. In the Dubois-Violette-Todorov
picture, exceptional Jordan algebra substructures help organize routes toward
the Standard Model gauge group. In Krasnov's work, right multiplication by a
chosen imaginary octonion turns an octonionic spinor space into a complex
module.

These are beautiful clues. They are also exactly the sort of clues that can be
misread. Octonion multiplication is nonassociative. Fano-plane orientations
differ between authors. A missing quotient by `Z6`, a sign change in a basis
conversion, or an implicit parenthesization can turn a true statement into a
nearby false one. Much of the literature is written in a style that is natural
for physicists and geometers, but unforgiving when several convention systems
are combined.

This is why formalization is useful here. A proof assistant will not decide
whether octonions are the "reason" for the Standard Model. It can do something
more modest and, at this stage, more valuable: make the algebraic claims
auditable. It forces us to say which octonion convention is being used, which
copy of `C` has been chosen, what quotient is being formed, which map is
claimed to be multiplicative, and exactly where a physical interpretation
goes beyond a theorem.

This turns a speculative-looking subject into a sequence of concrete tests.
Does a chosen octonion complex line really produce the advertised `C^3`
structure? Does the stabilizer action really land in the intended `SU(3)`
model? Does the claimed `Z6` quotient have the stated kernel? Do Furey's
operator tables, Baez's stabilizer story, DVT's Jordan-algebraic picture, and
Krasnov's complex structure use compatible data, or merely similar notation?
Those are formal questions, and they are worth answering before asking the
larger physical ones.

This paper presents a Lean 4 formalization of the shared algebraic content
behind these programs. Its central thesis is:

```text
Choosing a complex structure inside the octonions is the common algebraic
move. It feeds Furey-style operators, Baez-style `G2 -> SU(3)` structure,
DVT-style Jordan subalgebras, Krasnov-style complex modules, and the
matrix-level Standard Model gauge target.
```

The paper does not claim that these theorem islands constitute a derivation of
the Standard Model. Rather, it provides an auditable formal foundation for
comparing them.

The intended payoff is twofold. For mathematical physicists, the project
offers a clean map of what is already theorem-level structure and what remains
speculative. For formalization researchers, it gives a case study in using
Lean to organize a convention-heavy, cross-disciplinary body of mathematics:
not by flattening it into a single grand theorem, but by building a reliable
network of small theorem islands with explicit bridges and explicit borders.

### Contributions

The main contributions are:

1. A convention-explicit Lean model of octonions with a fixed XOR
   binary-label convention, a chosen imaginary unit `e111`, and a convention
   bridge for Baez/Furey-style formulas.

2. A paper-facing theorem index, `PaperTheoremIndex`, and a top-level package,
   `FureyBaezDVTMainTheorem`, collecting the main trusted theorem islands
   together with explicit non-claim markers.

3. A formal Standard Model gauge scaffold centered on `S(U(2) x U(3))`,
   including finite `Z6` kernel packages, block-subgroup closure, GUT-square
   block predicates, and unit-valued quotient/image results.

4. A formal Furey theorem island for complex-octonion ladder and electroweak
   table arithmetic, including operator-level charge and Gell-Mann-Nishijima
   packages, plus triality/electroweak transport infrastructure.

5. A formal Baez-DVT theorem island for `h3(O)`, including the Jordan
   identity, DVT central `Z3` kernel packages, two-sided matrix-kernel
   results, and inner-derivation identities.

6. A formal `G2`/`SU(3)` theorem island: multiplicative real-linear maps
   fixing the chosen complex line act as determinant-one unitary maps on
   `C^3`, and the resulting matrix action is packaged as a multiplicative
   equivalence with the project's `SU(3)` submonoid model.

7. A reusable family-symmetry naturality interface: charge-preserving
   relabelings and commuting family actions transport finite anomaly and
   electroweak table data.

8. A proof-engineering account of agent-assisted formalization in which
   Aristotle proposes Lean code, but the Lean kernel remains the only trust
   root.

---

## 2. Formal Artifact and Theorem Map

This paper is primarily a formalized-mathematics artifact. The mathematical
claims below are meant to be read together with the Lean source.

### 2.1 Trust root

The trusted source is Lean 4, using the project's pinned toolchain and
Mathlib. Agent-generated code is not trusted as an oracle. An agent may propose
a proof script, but the proof counts only when the Lean kernel accepts it.

The repository distinguishes trusted files from draft handoff files. Trusted
modules should contain no `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
Draft modules may contain documented handoff holes, but are not part of the
trusted theorem hierarchy.

For submission, this section should include:

```text
Lean version:        leanprover/lean4:v4.28.0
Mathlib commit:      TODO: fill from lake-manifest
Repository commit:   TODO: fill at submission
Build command:       lake build
No-sorry command:    TODO: final no-sorry checker or grep audit
Artifact archive:    TODO: release archive / Software Heritage ID
```

### 2.2 The paper-facing theorem index

The main artifact-facing modules are:

```text
PhysicsSM.Publication.FureyBaezDVTTheoremIndex
PhysicsSM.Publication.FureyBaezDVTMainTheorem
```

The theorem index has the following structure:

```lean
structure PaperTheoremIndex where
  octonion : OctonionFoundationIndex
  jordan : JordanAlgebraIndex
  furey : FureyIndex
  gauge : GaugeIndex
  block_bridge : BlockBridgeIndex
  anomaly : AnomalyNaturalityIndex
  g2_su3 : G2SU3Index
  inner_deriv : InnerDerivationIndex
  krasnov_module : KrasnovModuleIndex
```

The top-level package is:

```lean
structure FureyBaezDVTMainTheorem where
  theorem_index : PaperTheoremIndex
  baez_faithful : G2FixingE111FaithfulPackage
  quunit_dictionary : QunitQubitQutritDictionaryPackage
  claim_boundary : ClaimBoundary
```

This is not a single theorem saying "octonions derive the Standard Model."
It is a bundled citation target: a compact Lean declaration that gathers the
verified theorem islands and the explicit non-claims.

### 2.3 Informal-to-formal correspondence

| Informal topic | Lean index/module | Status in this draft |
| --- | --- | --- |
| Chosen octonion complex line | `OctonionFoundationIndex` | Kernel-checked theorem island |
| `G2` stabilizer acts as `SU(3)` on `C^3` | `G2SU3Index` | Kernel-checked algebraic equivalence |
| Standard Model `Z6` kernel scaffold | `GaugeIndex` | Kernel-checked finite/algebraic scaffold |
| True product-cover quotient | `StandardModelProductCoveringTriple` plus pending repair module | Do not headline until repair is integrated |
| Furey electroweak table package | `FureyIndex` | Kernel-checked theorem island |
| Furey W+ and W- ladder operators | pending Aristotle result | Future/integration note in this draft |
| `h3(O)` Jordan identity | `JordanAlgebraIndex` | Kernel-checked theorem island |
| DVT central `Z3` kernel | `JordanAlgebraIndex` | Kernel-checked theorem island |
| Complement times complement behavior | pending Aristotle counterexample integration | Future/integration note in this draft |
| Inner derivation identities | `InnerDerivationIndex` | Kernel-checked theorem island |
| Krasnov complex module on `O^2` | `KrasnovModuleIndex` | Kernel-checked theorem island |
| Full DVT stabilizer theorem | `ClaimBoundary` | Explicit non-result |
| Topological Lie-group quotient theorem | `ClaimBoundary` | Explicit non-result |

The final submitted paper should turn this table into a full theorem audit,
with exact declaration names and source links.

---

## 3. Conventions and Architecture

### 3.1 Octonion basis convention

The project uses a coordinate model of the real octonions with basis elements
indexed by binary triples:

```text
e000, e001, e010, e011, e100, e101, e110, e111.
```

The product of basis labels is bitwise XOR, with signs determined by the Fano
orientation encoded in `PhysicsSM.Algebra.Octonion.Basic`. The unit is `e000`.
The chosen imaginary unit is `e111`, satisfying:

```lean
theorem e111_sq : e111 * e111 = -(1 : Octonion)
theorem normSq_e111 : normSq e111 = 1
```

This choice defines the project's copy of the complex numbers:

```text
C = span_R {1, e111} inside O.
```

The complementary six real coordinates are packaged as a `C^3`-like object
called `ComplexTriple`. The foundational splitting theorem is:

```lean
theorem octonion_decomp (a : Octonion) :
    a = a.toChosenComplex.toOctonion + a.toComplexTriple.toOctonion
```

### 3.2 Convention bridge

Baez, Furey, and related sources do not all use the same basis labels or Fano
orientation. The project therefore treats source formulas as conventioned
objects. They must pass through project conversion lemmas before they are used
in trusted code.

This matters because a sign error in octonion multiplication can change an
anticommutation relation, a determinant, or a stabilizer condition. The Lean
formalization makes signs and parenthesization explicit.

### 3.3 Nonassociativity discipline

Octonion multiplication is not associative. The project avoids treating the
octonions as an associative algebra. Theorems involving products specify their
parentheses, and the exceptional Jordan product is represented in coordinates
rather than by silently applying associative matrix algebra over `O`.

### 3.4 What Lean checks

Lean checks that a formal statement follows from its hypotheses and imported
definitions. It does not check that the formal statement is the intended
translation of a paper's informal notation. The semantic alignment between
literature and Lean declarations is part of the formalization work and is
documented in module docstrings, task files, and the theorem index.

---

## 4. The Gauge Target: `S(U(2) x U(3))` and `Z6`

We describe the gauge target before the octonionic strands, because it gives
the reader a fixed destination.

The compact Standard Model gauge group is often written informally as
`U(1) x SU(2) x SU(3)`, but the faithful group acting on the usual
representations has a central quotient. Baez and Huerta emphasize the compact
form:

```text
S(U(2) x U(3)) ~= (U(1) x SU(2) x SU(3)) / Z6.
```

The project represents `S(U(2) x U(3))` by block matrices
`fromBlocks A 0 0 B`, where `A` is a unitary `2 x 2` complex matrix, `B` is a
unitary `3 x 3` complex matrix, and:

```text
det(A) * det(B) = 1.
```

The block predicate is closed under multiplication and inverse, producing a
subgroup of matrix units. The theorem index records this in `GaugeIndex` via
the `SMBlockUnitsSubgroup` package and related GUT-square packages.

### 4.1 The finite `Z6` kernel

The covering map has six central elements in its kernel. The project includes
a finite kernel package:

```lean
theorem mainTheorem_z6_kernel_card :
    Fintype.card CoveringKernelElt = 6
```

At the unit-valued level, the project also packages quotient/image results
for covering triples. The final manuscript should distinguish three layers:

1. finite kernel enumeration;
2. algebraic quotient equivalence with the image subgroup;
3. quotient equivalence with the block subgroup `SMBlockUnitsSubgroup`.

The third layer is the one closest to the textbook statement of the Standard
Model gauge group. It should be cited only after a final theorem audit of the
exact domain. In particular, the project has both a general `SMCoveringTriple`
domain and a more restrictive true product domain
`SMProductCoveringTriple`; a recent audit found that one quotient module used
an alias to the general domain. A repair job has been submitted/completed but
must be integrated and reviewed before the paper headlines a true
`(U(1) x SU(2) x SU(3)) / Z6` theorem from that module.

### 4.2 The quunit, qubit, qutrit dictionary

The project includes a dictionary module relating the three gauge factors to
dimension labels:

```text
U(1)   -> one-dimensional phase space, "quunit"
SU(2)  -> two-dimensional weak space, "qubit"
SU(3)  -> three-dimensional color space, "qutrit"
```

This dictionary is explanatory infrastructure. It helps connect Baez-style
language to the block matrix representation `C^2 + C^3`. It is not a physical
derivation of the Standard Model representation table.

---

## 5. Octonions and the Chosen Complex Line

The first common algebraic move is the choice of an imaginary unit in `O`.
For the project this is `e111`. It gives:

```text
O = C + C^3-like complement.
```

This decomposition is the seed for several different stories:

- `G2` maps fixing `e111` act on the complementary `C^3`.
- Furey-style ladder operators are expressed in a convention depending on the
  chosen octonionic structure.
- DVT-style `h3(C)` is selected inside `h3(O)`.
- Krasnov's right multiplication by `e111` gives a complex structure on `O^2`.

The foundational Lean package proves the chosen line, the complement
coordinates, and the action of the chosen imaginary unit on the complement.

### 5.1 The `G2 -> SU(3)` theorem island

Classically, the subgroup of `G2 = Aut(O)` fixing a chosen imaginary unit is
isomorphic to `SU(3)`. The project formalizes a coordinate algebraic version
using the record `FixingE111MulLinear`: real-linear multiplicative maps
preserving the relevant octonion structure and fixing the chosen line.

The theorem index records:

```lean
structure G2SU3Index where
  fixing_acts_as_su3 :
    forall g : FixingE111MulLinear,
      MatrixActsAsSU3OnC3 g.onComplexVecMatrix
  faithful : Function.Injective fixingE111MulLinearToMatrixHom
  surjective : Function.Surjective fixingE111MulLinearToSU3Hom
  mul_equiv : MulEquiv FixingE111MulLinear su3Submonoid
```

This is one of the most conceptually important theorem islands in the paper:
it turns the informal phrase "fixing a complex line leaves color `SU(3)`" into
a kernel-checked algebraic equivalence in the project's coordinate model.

Claim boundary: this is not a topological or smooth Lie-group theorem, and
the record `FixingE111MulLinear` is a coordinate algebraic surrogate for the
stabilizer. The final paper should state exactly how this surrogate relates to
the mathematical `G2` used in the literature.

---

## 6. Furey's Ladder-Operator Construction

Furey's program builds Standard Model quantum numbers from division-algebraic
operators. In this project, the formalized core is the finite algebraic
operator package: complex-octonion ladder operators, minimal left ideals, and
the resulting one-generation charge table.

### 6.1 Ladder operators and minimal ideals

The complex-octonion layer defines ladder operators and their adjoints. The
trusted theorem island proves nilpotency and anticommutation tables, then
constructs the relevant minimal-left-ideal arithmetic.

The paper-facing Furey index is:

```lean
structure FureyIndex where
  electroweak : FureyElectroweakPaperPackage
  triality_transport : TrialityElectroweakTransportPackage
  jbar_linear_independence : FureyJbarLinearIndependencePackage
```

The corrected `Jbar` basis theorem is important for the reader. Earlier
informal tasks assumed a basis statement that failed for the original vector
choice; the repository now records a corrected linearly independent basis for
the finite span used in the paper-facing package.

### 6.2 Charge and electroweak tables

The electroweak bridge includes a finite table for the `Jbar` sector, an
operator-level charge package, and the Gell-Mann-Nishijima identity:

```text
Q = T3 + Y / 2.
```

The important point for a formalization venue is that this is not a floating
physics analogy. It is a finite checked statement about explicit operators and
state functions.

The paper should separate two levels:

1. The verified table/operator package currently in `FureyIndex`.
2. The stronger W-plus/W-minus raising/lowering package that has been sent to
   Aristotle and should be included only after integration and review.

If the W-plus/W-minus job is integrated before submission, this section can be
expanded to state the finite `su(2)_L` commutator relations. Until then, the
draft should describe W operators as a near-term theorem target rather than a
settled result.

### 6.3 Triality and family transport

The Furey-Hughes triality program and nearby `S3` family-symmetry proposals
motivate a reusable formal interface: if a family action commutes with the
charge or gauge data, it transports eigenvectors and preserves finite anomaly
sums.

This project formalizes that conditional principle. It does not prove that a
specific physical family symmetry generates the observed three generations.
It gives future models a precise Lean interface: prove the commutation
hypotheses, then reuse the transport theorem.

---

## 7. The Baez-DVT Exceptional Jordan Algebra Thread

The second major theorem island is the exceptional Jordan algebra `h3(O)`.
This thread connects Baez's octonionic explanations with the
Dubois-Violette-Todorov stabilizer program.

### 7.1 Coordinate model of `h3(O)`

The project represents an element of `h3(O)` by six independent coordinates:
three real diagonal entries and three octonion off-diagonal entries. The
Jordan product is given by an explicit coordinate formula corresponding to:

```text
A o B = (AB + BA) / 2.
```

Because octonion multiplication is nonassociative, this coordinate formula is
not treated as ordinary associative matrix multiplication. The parenthesized
formula is part of the trusted definition.

The theorem index records the Jordan identity:

```lean
forall a b : H3O,
  jordanProduct (jordanProduct a b) (jordanProduct a a) =
    jordanProduct a (jordanProduct b (jordanProduct a a))
```

This is a large coordinate theorem and belongs in the paper as a proof
engineering result as well as a mathematical result.

### 7.2 The `h3(C)` substructure and complement

The chosen complex line inside `O` selects a standard `h3(C)` inside `h3(O)`.
The project also defines a complement predicate `InComplementOfB` and
projection maps:

```text
h3(O) = h3(C)-part + complement-part.
```

The module `TraceForm` records trace-form orthogonality and splitting
infrastructure. The module `ComplementJordanModule` proves that `h3(C)` acts
on the complement by the Jordan product:

```lean
InStandardB a -> InComplementOfB X ->
  InComplementOfB (jordanProduct a X)
```

A tempting stronger statement is that complement times complement lands back
in `h3(C)`. That claim should not be used unless explicitly proved. A recent
Aristotle job was submitted to either prove or refute it by counterexample;
this draft treats it as pending integration.

### 7.3 Inner derivations

For a Jordan algebra, the inner derivation associated to `a` and `b` is the
commutator of the multiplication operators:

```text
D_{a,b}(c) = a o (b o c) - b o (a o c).
```

The formalization records antisymmetry, `D_{a,a} = 0`, additivity, scalar
compatibility, and the Jordan Leibniz rule. The theorem index bundles these
in `InnerDerivationIndex`.

This is a good example of formalization correcting an informal specification:
a symmetric candidate formula for `D_{a,b}` appeared in earlier task planning,
but it could not be the intended derivation because it does not have the
right antisymmetry. The Lean development forced the corrected formula.

### 7.4 DVT central `Z3` packages

The DVT complement action thread includes central cube-root packages and a
two-sided matrix-kernel theorem. The theorem index records:

```lean
dvt_z3_kernel_iff : DVTTwoSidedActionKernelZ3IffPackage
```

This is not the full DVT stabilizer theorem. It is a verified algebraic layer
below that theorem: central kernels and two-sided actions in the coordinate
model.

Claim boundary: the project does not prove `Aut(h3(O)) ~= F4`, does not prove
the compact stabilizer theorem, and does not identify the full DVT stabilizer
intersection with the Standard Model group.

---

## 8. Krasnov's Complex Structure on `O^2`

Krasnov's approach uses a complex structure on an octonionic spinor space.
In the project, right multiplication by the chosen imaginary unit is a map:

```text
rightMulE111 : O^2 -> O^2.
```

The theorem island proves:

```lean
rightMulE111 (rightMulE111 q) = -q
```

and packages `OctonionicQubit` as a complex module, with:

```lean
rightMulE111 q = Complex.I * q
```

in the appropriate scalar-action notation.

The Krasnov index deliberately stops before the Spin-group centralizer theorem.
It verifies the complex-module and complex-structure layer needed for that
future theorem.

This section should be concise in the main paper. It strengthens the common
theme of chosen complex structures but should not pull the manuscript away
from the main Furey/Baez/DVT/gauge story.

---

## 9. The Shared Bridge

The paper becomes cohesive if Section 9 explicitly synthesizes the preceding
theorem islands.

The common pattern is:

```text
choose I in Im(O)
  -> C = span_R {1, I}
  -> O = C + C^3-like complement
  -> color-like SU(3) action on C^3
  -> h3(C) inside h3(O)
  -> finite operator tables and gauge-block scaffolds
  -> S(U(2) x U(3)) as the comparison target
```

The formalization does not prove that all arrows are instances of one master
theorem. Instead, it proves multiple compatible theorem islands over the same
fixed convention. That is enough to make the literature comparison auditable.

This section should be written for the skeptical reader. The right message is
not "everything is unified." It is:

```text
These programs share a precise algebraic move, and Lean lets us compare the
consequences of that move without silently changing conventions.
```

---

## 10. Proof Engineering and Agent-Assisted Formalization

The project was developed with a human/agent/Lean loop:

1. A human or coding agent identifies the intended mathematical statement.
2. The statement is translated into Lean with explicit hypotheses and
   conventions.
3. Aristotle may be asked to fill proof obligations or find useful lemmas.
4. The proposed source is integrated only if the Lean kernel accepts it.
5. The statement is reviewed for semantic alignment with the literature.

The trust boundary is clear: Aristotle is a proof-search assistant, not a
trusted oracle. The kernel checks proof terms. The final artifact should be
independently reproducible by running `lake build`.

### 10.1 Formalization as error detection

Several useful corrections emerged during formalization:

- The original candidate formula for inner derivations was not antisymmetric.
  The formal development uses the correct commutator-of-left-multiplications
  formula.

- A proposed qubit-level sesquilinearity theorem for the Krasnov Hermitian
  form failed because the flattening map does not interact with the complex
  scalar action as naively expected. The repository records a corrected
  coordinate-level sesquilinearity statement and a claim-boundary note.

- A proposed vector equality for opposite `T3` eigenstates confused equality
  of eigenvalues with equality of vectors in different basis directions. The
  formal statement was changed to the correct eigenvalue relation.

- A quotient theorem using the phrase "product covering" was found to require
  careful distinction between a broad `SMCoveringTriple` domain and the true
  restricted `SMProductCoveringTriple` domain.

These examples are a methodological contribution: the formalization did not
merely certify expected facts; it sharpened several informal claims.

---

## 11. Claim Boundaries and Non-Results

The project contains a machine-readable claim boundary:

```lean
structure ClaimBoundary where
  no_full_standard_model_derivation : True
  no_full_dvt_stabilizer_theorem : True
  no_topological_quotient_isomorphism : True
```

The fields are intentionally trivial propositions. Their role is not to prove
mathematics, but to keep non-results visible in the same artifact as the
positive theorem index.

### 11.1 What is proved

| Layer | Status |
| --- | --- |
| Fixed octonion coordinate convention | Trusted theorem island |
| Chosen complex line and complement splitting | Trusted theorem island |
| Algebraic `G2`-surrogate to `SU(3)` equivalence | Trusted theorem island |
| Furey finite electroweak table package | Trusted theorem island |
| Standard Model `Z6` finite kernel scaffold | Trusted theorem island |
| Block subgroup and GUT-square predicates | Trusted theorem island |
| `h3(O)` coordinate Jordan identity | Trusted theorem island |
| DVT central `Z3` kernel packages | Trusted theorem island |
| Inner derivation identities | Trusted theorem island |
| Krasnov complex module structure on `O^2` | Trusted theorem island |
| Family anomaly/relabeling naturality | Trusted theorem island |

### 11.2 What is not proved

| Non-result | Reason |
| --- | --- |
| Full derivation of the Standard Model from octonions | Physical dynamics, chirality, masses, mixing, and Lagrangian structure are outside scope |
| `Aut(h3(O)) ~= F4` as compact Lie groups | Requires formal compact Lie group infrastructure not present here |
| DVT stabilizer intersection theorem | Depends on the full exceptional-group layer |
| `Spin(9)` or `Spin(10)` centralizer theorem | Requires a formal Spin action on the octonionic spinor space |
| Topological/smooth quotient theorem for the gauge group | Current quotient results are algebraic |
| Furey W operators derived from the octonionic algebra | Current/pending W operators are finite table operators unless later derived |
| Three-generation physical theorem | Current family-symmetry results are conditional naturality theorems |

This table is not an apology. It is part of the contribution. A formalization
paper about speculative mathematical physics is stronger when it states its
non-theorems as carefully as its theorems.

---

## 12. Related Work

The octonionic Standard Model literature begins with the observation of
Gunaydin and Gursey that octonionic structure naturally contains color-like
`SU(3)` behavior. Dixon developed a broad division-algebraic framework using
`C`, `H`, and `O`. Furey developed a concrete operator and ideal program in
which Standard Model quantum numbers arise from complex-octonion ladder
operators. Dubois-Violette and Todorov developed an exceptional-Jordan
stabilizer program around `h3(O)`. Baez and Huerta emphasized the precise
gauge-group quotient and the role of `S(U(2) x U(3))`, while Baez's later
expository work highlights the `O = C + C^3` and `G2 -> SU(3)` story. Krasnov
formulates a related complex-structure centralizer program on octonionic
spinors.

This project is closest in formalization spirit to Lean-based physics and Lie
algebra projects such as HepLean/Physlib, Tooby-Smith's index-notation work,
and recent Lean formalizations of low-dimensional Lie algebras. It differs in
target: rather than formalizing phenomenological calculations or tensor-index
notation, it formalizes convention-heavy octonionic, Jordan, and gauge-group
algebra.

The Furey-Hughes triality program, Boyle's exceptional-Jordan/triality work,
and Gresnigt-style `S3` family-symmetry models motivate the family-naturality
interface. The project does not formalize those physical generation claims,
but it provides a reusable theorem schema for any future model that can prove
the required commutation hypotheses.

---

## 13. Future Work

Near-term formalization targets:

1. Integrate and audit the corrected true product-covering quotient theorem.
2. Integrate and audit the complement-product counterexample or replacement
   theorem.
3. Integrate and audit the Furey W-plus/W-minus ladder-operator package if the
   returned result is trusted and semantically aligned.
4. Update `PaperTheoremIndex` after each integration so the paper cites one
   stable theorem surface.
5. Produce a final artifact table with exact declaration names, source files,
   line counts, and build commands.

Longer-term mathematical targets:

1. Formalize enough compact Lie group infrastructure to state and prove the
   full DVT stabilizer theorem.
2. Connect the algebraic `FixingE111MulLinear` surrogate to a formal `G2`
   automorphism group.
3. Build the Spin-group layer needed for Krasnov's centralizer theorem.
4. Derive finite Furey electroweak ladder operators from division-algebraic
   operators rather than defining them as table maps.
5. Instantiate family-symmetry naturality for a concrete three-generation
   triality or `S3` model.

---

## 14. Submission Checklist

Before submitting to AFM or ITP, complete:

- Run `lake build` from a clean checkout.
- Run the no-sorry/no-admit/no-axiom audit on trusted modules.
- Freeze exact Lean and Mathlib versions.
- Add exact Git commit hash and archived artifact URL.
- Replace all TODOs in Section 2.
- Audit every theorem claim against `PaperTheoremIndex`.
- Decide whether pending Aristotle jobs are included, excluded, or moved to
  future work.
- Add source-line links or appendix table for every displayed Lean theorem.
- Normalize references from `Sources/Paper_References.md`.
- Prepare an artifact appendix explaining generated/proof-agent-assisted code.

---

## References

The working reference list is maintained in `Sources/Paper_References.md`.
The final manuscript should include, at minimum:

- Albert 1934, for exceptional Jordan algebras.
- Baez 2002, for octonions and the Albert algebra.
- Baez and Huerta 2010, for the GUT square and the `Z6` quotient.
- Baez 2021, for the octonions/Standard Model expository bridge.
- Conway and Smith 2003, for octonion background and conventions.
- Dixon 1994, for the division-algebraic physics program.
- Dubois-Violette and Todorov 2018/2019, for the DVT stabilizer and
  exceptional quantum geometry program.
- Furey 2015/2016/2018, for charge operators, ideals, and ladder symmetries.
- Furey and Hughes 2024/2025, for triality and generations.
- Krasnov 2019/2025, for complex structures and Standard Model fermions.
- McCrimmon 2004, for Jordan algebra and derivation background.
- Lean 4 and Mathlib references.
- HepLean/Physlib and related Lean physics formalization references.
