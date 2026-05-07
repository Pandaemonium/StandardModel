# Publishable result opportunities from the PhysicsSM formalization project

Search date: 2026-05-06.

Status: planning document. This document identifies results that look
publishable if the formal claims are kept precise, kernel-checked, and
carefully separated from speculative physical interpretation.

## Executive summary

The most publishable near-term result is a Lean 4 formalization paper centered
on the project's octonion and Furey-style minimal-left-ideal development:

```text
real octonions
  -> complexified octonions
  -> division-algebraic ladder operators
  -> Cl(6) anticommutation relations
  -> minimal left ideal basis
  -> electric-charge operator and finite action table.
```

The likely novelty is not that these constructions are new in physics. The
novelty is that a nonassociative, convention-heavy algebraic Standard Model
proposal has been translated into small Lean statements checked by the kernel.
The current number-operator layer should be presented as electric-charge
formalization. Weak hypercharge belongs to a later layer that explicitly
introduces weak isospin via `Q = T3 + Y / 2`.

The best follow-up publication is a bridge from this division-algebraic charge
data to PhysLean/HepLean's anomaly-cancellation infrastructure. PhysLean already
formalizes anomaly-cancellation systems and Standard Model anomaly examples, so
the publishable contribution would be a convention-preserving theorem saying
that the algebraic representation data produced in this repo maps into a known
formal anomaly-free Standard Model charge system.

Longer-term publishable tracks are:

- the first Lean formalization of the exceptional Jordan algebra `h_3(O)` and
  its standard `h_2(O)`, `h_3(C)`, `h_2(C)` subalgebras;
- a formal Hamming/Fano/Construction A bridge from binary codes to E8, building
  on the 2026 Lean work on self-dual codes and the Sphere-Packing-Lean E8
  formalization;
- a methods paper on AI-assisted formalization of nonassociative algebra, using
  Aristotle/Gauss-style proof agents as proof-search collaborators while the
  Lean kernel remains the trust boundary.

## Literature landscape

### Formalized high-energy physics

PhysLean/HepLean is the closest public formalization neighbor. The public
documentation defines an `ACCSystem` hierarchy for anomaly-cancellation
conditions: charges, linear conditions, quadratic conditions, and the cubic
condition. It also includes Standard Model anomaly-cancellation systems such as
`SM.SMNoGrav` without right-handed neutrinos and without the gravitational ACC.

The HepLean paper describes Lean 4 formalizations of high-energy-physics
objects including CKM matrices, local anomaly cancellation, and Higgs physics.
That means a publishable result from this repo should avoid re-proving generic
anomaly infrastructure in isolation. A stronger contribution is an alignment
theorem from division-algebraic particle data into PhysLean-style anomaly
systems.

Useful sources:

- PhysLean anomaly documentation:
  <https://physlean.com/docs/PhysLean/QFT/AnomalyCancellation/Basic.html>
- PhysLean Standard Model no-gravity anomaly system:
  <https://physlean.com/docs/PhysLean/Particles/StandardModel/AnomalyCancellation/NoGrav/Basic.html>
- HepLean paper, Computer Physics Communications 2025:
  <https://www.sciencedirect.com/science/article/abs/pii/S0010465524003801>
- HEPLean/PhysLean repository: <https://github.com/HEPLean/PhysLean>

### Division algebras and the Standard Model

The Furey program supplies the nearest match to the current trusted Lean code.
Furey's thesis and related papers use complexified division algebras, ladder
operators, minimal ideals, and number operators to model Standard Model
fermion quantum numbers. The 2016 charge paper emphasizes electric charge
quantization from a number operator. The 2018 EPJC paper targets
`SU(3)_C x SU(2)_L x U(1)_Y`, possibly with an extra `U(1)_X`, as a symmetry of
division-algebraic ladder operators. Furey-Hughes 2024/2025 moves toward three
generations using a trio of trialities.

The project already has trusted Lean code for much of the finite Furey
arithmetic. That is much closer to publication than the more ambitious group
and representation-theoretic claims.

Useful sources:

- Furey thesis, arXiv:1611.09182:
  <https://arxiv.org/abs/1611.09182>
- Furey, "Charge quantization from a number operator", arXiv:1603.04078:
  <https://arxiv.org/abs/1603.04078>
- Furey, EPJC 2018 ladder-operator paper:
  <https://link.springer.com/article/10.1140/epjc/s10052-018-5844-7>
- Furey-Hughes, "Three Generations and a Trio of Trialities":
  <https://arxiv.org/abs/2409.17948>

### Exceptional Jordan algebra and octonionic gauge-group geometry

Dubois-Violette and Todorov characterize the Standard Model gauge group using
the exceptional Jordan algebra `h_3(O)` and exceptional groups. Krasnov gives a
more explicit `SO(9)`/`Spin(9)` characterization using the split
`O = C + C^3`, and Baez's 2021 talk explains this as symmetries of an
octonionic qutrit that preserve both a chosen unit-imaginary structure and an
octonionic qubit. The 2026 Baez-Schwahn presentation reframes the same region
as a projective-geometry conjecture in `OP^2`.

These are excellent long-term targets, but a paper should probably not wait for
the full stabilizer theorem. A publishable intermediate result would be a
kernel-checked coordinate formalization of `h_3(O)`, projections, the standard
subalgebras, and the relevant splitting. The full `F4`, `Spin(9)`, and
`S(U(2) x U(3))` isomorphism chain can be stated as sourced frontier targets.

Useful sources:

- Dubois-Violette and Todorov, arXiv:1806.09450:
  <https://arxiv.org/abs/1806.09450>
- Krasnov, arXiv:1912.11282:
  <https://arxiv.org/abs/1912.11282>
- Baez 2021 standard-model-octonions page:
  <https://math.ucr.edu/home/baez/standard/>
- PIRSA talk page:
  <https://pirsa.org/21040005>
- Baez-Schwahn slides:
  <https://math.ucr.edu/home/baez/standard/exceptional.pdf>

### Codes, E8, and string-theory bridges

The coding-theory track has become more publishable because of recent adjacent
formalization work. Baek and Kim's 2026 paper formalizes a core of self-dual
code building-up constructions in Lean. Sphere-Packing-Lean formalizes the E8
lattice in the context of the dimension-8 sphere-packing theorem. Mizoguchi and
Oikawa's 2026 paper explicitly studies Construction A code lattices for
heterotic Narain CFTs and includes the Hamming-to-E8 bridge.

This creates a clear formalization gap:

```text
linear code API
  -> binary [7,4,3] Hamming and extended [8,4,4] Hamming
  -> Construction A
  -> E8 lattice identification
  -> compatibility with Sphere-Packing-Lean's E8.
```

This is mathematically cleaner than a direct "Hamming codes explain Standard
Model anomaly cancellation" claim. The ordinary Standard Model anomaly
conditions are charge-sum equations; a code-theoretic explanation would require
extra structure not yet present.

Useful sources:

- Baek-Kim Lean self-dual code formalization, arXiv:2604.08485:
  <https://arxiv.org/abs/2604.08485>
- Mizoguchi-Oikawa, arXiv:2602.16269:
  <https://arxiv.org/abs/2602.16269>
- Sphere-Packing-Lean:
  <https://github.com/math-inc/Sphere-Packing-Lean>
- Error Correction Zoo E8 entry:
  <https://errorcorrectionzoo.org/c/eeight>
- Mathlib Hamming API:
  <https://leanprover-community.github.io/mathlib4_docs/Mathlib/InformationTheory/Hamming.html>

## Candidate publishable results

### Paper A: A Lean formalization of octonion arithmetic for mathematical physics

Possible title:

```text
Formalizing the Octonions and Moufang Identities in Lean 4
```

Core claim:

The project gives a kernel-checked real octonion model in a documented XOR
Fano basis, including multiplication, conjugation, norm multiplicativity,
alternativity, flexibility, and all three Moufang identities.

Why this is publishable:

- The web search did not reveal an obvious public Lean 4 formalization of
  octonions with Moufang identities and norm multiplicativity.
- Nonassociativity makes this a good formalization case study: many generic
  algebra APIs are dangerous, and the paper can explain how explicit
  parenthesization and convention tracking prevent false proofs.
- The result is foundational for `G2`, `Spin(8)` triality, exceptional Jordan
  algebras, and Furey-style Standard Model constructions.

Current repo readiness:

- High. The trusted octonion core appears sorry-free in the relevant trusted
  modules.
- The `TrialityCompanions` theorem gives an additional research-flavored hook:
  a cube `= +/-1` condition for a conjugation-like map to preserve
  multiplication.

Remaining work before submission:

- Run a full clean `lake build` on CI or a non-Windows environment.
- Add a compact API overview and theorem list.
- Decide whether the paper is about just the octonion core or also includes
  the triality-companion foothold.
- Add a comparison section explaining why the XOR convention differs from
  Baez/Furey notation and how `ConventionBridge` controls translation.

Best venue fit:

- Formalization venues such as ITP, CPP, CICM, or Annals of Formalized
  Mathematics.
- A mathematical-physics venue is plausible if the paper includes the
  Standard Model motivation, but the formal-methods audience is the cleaner
  first target.

### Paper B: Machine-checking Furey's octonionic ladder-operator model

Possible title:

```text
A Lean 4 Formalization of Octonionic Ladder Operators and a Minimal Left Ideal
```

Core claim:

Starting from the project's complexified octonions, the formalization verifies
Furey-style ladder operators, nilpotency, the 27 Cl(6) anticommutation
relations, the finite minimal-left-ideal action table, linear independence of
the eight-state basis, and the electric-charge operator on that basis.

Why this is publishable:

- It is directly tied to active mathematical-physics literature.
- It is stronger than a symbolic notebook: every operator equality and basis
  statement is checked by Lean.
- It demonstrates a useful role for formal verification in speculative physics:
  it verifies the algebraic content while refusing to overclaim the physical
  interpretation.
- It keeps the charge layer clean: the formal number-operator eigenvalues are
  electric charges, while hypercharge is reserved for a later weak-isospin
  bridge using `Q = T3 + Y/2`.

Current repo readiness:

- High, but not quite paper-ready.
- The project already has trusted Furey ladder, minimal ideal, operator, and
  charge/eigenvalue layers.

Remaining work before submission:

- Create a theorem-index appendix listing exact Lean declarations and source
  correspondences.
- Add a semantic review table:
  - source formula;
  - project XOR convention translation;
  - Lean declaration;
  - physical interpretation status.
- Separate "verified algebra" from "particle assignment" in the prose.
- Add a no-sorry check over all files used in the paper.
- Decide whether anomaly cancellation is in scope or saved for Paper C.

Best venue fit:

- Formalized mathematics / theorem proving venue.
- Computer Physics Communications could be plausible if the artifact is
  presented as a reusable Lean library for high-energy-physics algebra.

### Paper C: A Furey-to-PhysLean bridge for anomaly cancellation

Possible title:

```text
From Division-Algebraic Charge Tables to Formal Anomaly Cancellation in Lean
```

Core claim:

The algebraic charge table produced by the Furey minimal-left-ideal
formalization can be mapped into a PhysLean/HepLean-style anomaly-cancellation
system, with the Standard Model anomaly equations verified under explicit
conventions.

Why this is publishable:

- PhysLean already has anomaly-cancellation infrastructure. A bridge theorem
  would show interoperability rather than another isolated physics library.
- The paper would connect a speculative algebraic construction to a standard
  consistency check in a formal setting.
- It would make convention choices explicit and mechanically auditable.

Current repo readiness:

- Medium.
- Local `StandardModel/AnomalyCancellation.lean` and draft anomaly scaffolding
  exist, but the cleanest result should probably align with PhysLean rather
  than duplicating everything.

Remaining work before submission:

- Audit PhysLean APIs and decide whether to import PhysLean or write a local
  compatibility layer.
- Define weak isospin and hypercharge separately from electric charge.
- Prove the linear and cubic anomaly equations for one generation and, if
  desired, three generations by summation.
- State exactly which model is being checked: with or without right-handed
  neutrino; with or without gravitational anomaly; left-handed Weyl convention
  versus particle/antiparticle convention.

Best venue fit:

- Computer Physics Communications, CICM, or an applied formalization venue.

### Paper D: Standard Model gauge-group quotient scaffolding

Possible title:

```text
Toward a Lean Formalization of S(U(2) x U(3)) and the Z6 Quotient
```

Core claim:

Lean defines concrete block-matrix scaffolding for the usual
`S(U(2) x U(3))` presentation, constructs the determinant-one block map behind
the familiar cover from `U(1) x SU(2) x SU(3)`, and proves the finite phase
facts expected of the central `Z6` kernel.

Claim boundary:

This is not yet a proof of the topological compact Lie group quotient theorem.
A publishable version must either formalize the required quotient/Lie-group
infrastructure or advertise itself as a scaffold and determinant/kernel
calculation only.

Why this is publishable:

- Many physics discussions casually write the gauge group as a direct product.
  A formal quotient statement is small but conventionally important.
- The theorem is independent of the speculative octonion/Jordan program and
  would be useful to PhysLean-style libraries.
- It is a natural bridge between the Furey 2018 paper, Baez's 2021 talk, and
  the Dubois-Violette/Todorov stabilizer theorem.

Current repo readiness:

- Medium-low. The plan exists, but the matrix-subgroup Lean code still needs to
  be written.

Remaining work before submission:

- Choose a mathlib-compatible definition of unitary and special unitary matrix
  groups.
- Define block matrices for `2+3` and `3+1` decompositions.
- Prove determinant and kernel facts.
- Decide how much quotient-group and compact Lie group infrastructure is needed
  for a polished statement.

Best venue fit:

- A short formalization note, possibly bundled with Paper C or with the
  exceptional-Jordan roadmap.

### Paper E: First Lean scaffolding for the exceptional Jordan algebra

Possible title:

```text
Toward a Formalization of the Exceptional Jordan Algebra and OP^2 in Lean
```

Core claim:

The project formalizes a coordinate model of `h_3(O)`, its Jordan product,
trace, projections, the standard `h_2(O)` and `h_3(C)` subalgebras, and the
projective point/line dictionary needed for the Baez-Schwahn and
Dubois-Violette/Todorov Standard Model stabilizer results.

Why this is publishable:

- The search did not reveal a public Lean formalization of the exceptional
  Jordan algebra, `OP^2`, or `F4 = Aut(h_3(O))`.
- Even without proving the final `F4` stabilizer theorem, a verified
  coordinate foundation would be a useful contribution for exceptional Lie
  theory, Jordan algebras, and mathematical physics.
- The formalization would clarify the exact gap between finite coordinate
  algebra and compact Lie group stabilizer geometry.

Current repo readiness:

- Early. There is a typechecked draft file and Aristotle jobs running, but this
  is not yet trusted code.

Remaining work before submission:

- Implement the actual `h_3(O)` Jordan product.
- Prove standard projection and block-closure facts.
- Move sorry-free parts from `Draft` into trusted modules.
- Keep `F4`, `Spin(9)`, `(SU(3) x SU(3))/Z3`, and `S(U(2) x U(3))`
  stabilizer isomorphisms as sourced frontier statements unless proved.

Best venue fit:

- A formalization workshop or mathematical-physics formalization paper.
- It may become a stronger journal paper only after more stabilizer theory is
  formalized.

### Paper F: Hamming codes, Construction A, and E8 in Lean

Possible title:

```text
From the Extended Hamming Code to the E8 Lattice: A Construction A Bridge in Lean
```

Core claim:

Lean defines the binary Hamming and extended Hamming codes, implements
Construction A for binary linear codes, and proves that the extended
`[8,4,4]` Hamming code yields a lattice equivalent to the E8 lattice used by
Sphere-Packing-Lean.

Why this is publishable:

- It sits at the intersection of coding theory, lattice theory, and formal
  verification.
- It connects directly to recent Lean work on self-dual codes and to the E8
  sphere-packing formalization.
- It gives a clean mathematical version of the Hamming-to-E8-to-heterotic
  bridge without overclaiming a direct Standard Model anomaly explanation.

Current repo readiness:

- Medium-low locally, but strategically strong.
- Claude is reportedly working on Construction A code; once that lands, this
  could become one of the cleanest publishable targets.

Remaining work before submission:

- Review and license-check any imported Construction A code.
- Define binary linear codes in a way compatible with mathlib's Hamming API.
- Prove the `[7,4,3]` Fano/Hamming bridge.
- Prove the extended `[8,4,4]` code is self-dual and doubly even.
- Prove the Construction A lattice has the E8 Gram matrix or is equivalent to
  the Sphere-Packing-Lean E8 lattice.

Best venue fit:

- Formalized mathematics, coding theory, or discrete geometry formalization
  venues.

### Paper G: AI-assisted formalization of nonassociative algebra

Possible title:

```text
Proof Agents for Nonassociative Algebra in Lean: A Case Study with Octonions and the Standard Model
```

Core claim:

The project demonstrates a workflow in which human agents prepare
semantically reviewed theorem statements, proof-specialist agents such as
Aristotle attempt difficult proof obligations, and the Lean kernel validates
the final result. The case study is nonassociative octonion algebra and its
Standard Model motivated descendants.

Why this is publishable:

- It is timely: proof-agent systems are changing the cost profile of formal
  mathematics.
- Nonassociative algebra is an excellent stress test because naive rewriting
  easily introduces false associativity assumptions.
- The project has a real audit trail: Aristotle task files, source provenance,
  convention notes, and kernel-checked outputs.

Current repo readiness:

- Medium. The process is happening, but the paper needs careful metrics.

Remaining work before submission:

- Record quantitative data:
  - number of declarations proved by humans versus Aristotle;
  - number of failed jobs;
  - size and type of proofs;
  - statement refinements discovered during proof review.
- Include at least one end-to-end case study where an Aristotle result is
  reviewed, corrected, and integrated.
- Avoid making the paper sound like an AI benchmark if the methodology is not
  controlled enough.

Best venue fit:

- ITP/CICM workshop, AI for theorem proving workshop, or formal-methods
  experience-report track.

## Conjecture and Frontier Target Backlog

Search update: 2026-05-06. This section collects mathematically interesting
claims and conjectural directions found in papers, source pages, and serious
blog discussions. The point is not to claim these are proved in the repository;
the point is to identify targets that could become publishable Lean
formalization results if the claim boundary is kept exact.

### Target 1: Baez-Schwahn projective stabilizer conjecture

Informal target:

```text
In OP^2, the common stabilizer of a complex projective plane X ~= CP^2
and an octonionic projective line ell ~= OP^1 meeting in CP^1 is
S(U(2) x U(3)).
```

Why it is interesting:

- It packages the Dubois-Violette/Todorov exceptional-Jordan stabilizer picture
  in projective-geometric language.
- It is close to the repository's current trusted coordinate work:
  `H3O`, projections, standard `h_2(O)`, `h_3(C)`, and incidence.

Lean entry point:

- First publishable step: formalize the standard block example and prove the
  algebraic/projective dictionary for `X`, `ell`, and `X cap ell`.
- Frontier step: prove or source the pair-transitivity theorem used to reduce
  arbitrary pairs to the standard example.

Claim boundary:

Do not present this as proved until the compact Lie group/stabilizer
identification is actually formalized.

Sources:

- Baez-Schwahn slides, "Projective Geometry and the Exceptional Jordan Algebra":
  <https://math.ucr.edu/home/baez/standard/exceptional.pdf>
- Baez 2021 standard-model-octonions page:
  <https://math.ucr.edu/home/baez/standard/>
- Dubois-Violette and Todorov, arXiv:1806.09450:
  <https://arxiv.org/abs/1806.09450>

### Target 2: Conway-Smith/Yokota triality-shadow criterion

Informal target:

```text
For an invertible octonion a, conjugation x |-> a*x*a^{-1}
is an octonion algebra automorphism iff a^3 is a real scalar.
For unit a, this specializes to the a^3 = +/-1 cases, with order-three
behavior in the nontrivial cases.
```

Why it is interesting:

- This is a compact, beautiful theorem connecting Moufang identities,
  companion maps, and Spin(8) triality.
- It is small enough to be a serious formalization paper section, especially
  because the project already has Moufang identities and a forward
  `cube = +/-1` theorem.

Lean entry point:

- Formalize companion maps for left and right multiplication by a unit
  octonion.
- Prove the "companions are `a^3` and `a^{-3}`" lemma.
- Prove the converse direction, or at least reduce it to a scalar-cube lemma.

Claim boundary:

The current trusted repo result covers a forward special case; it does not yet
prove the iff statement.

Sources:

- Baez, "A Shadow of Triality?", n-Category Cafe, September 2025:
  <https://golem.ph.utexas.edu/category/2025/09/a_shadow_of_triality.html>
- Baez, "The Octonions":
  <https://math.ucr.edu/home/baez/octonions/octonions.html>

### Target 3: Krasnov `Spin(9)` / `Spin(10)` complex-structure centralizers

Informal targets:

```text
Centralizer_{Spin(9)}(J on O^2) ~= S(U(2) x U(3)).

Inside Spin(10), two suitably aligned commuting complex structures encoded by
pure spinors determine the Standard Model subgroup.
```

Why it is interesting:

- This is a more concrete route to the gauge group than the full `F4`
  exceptional-Jordan theorem.
- It directly addresses the known weakness of the `Spin(9)` route: it is too
  left-right symmetric for the full chiral Standard Model, while the
  `Spin(10)` two-complex-structure route is designed to encode chirality.

Lean entry point:

- Start with the coordinate centralizer of `rightMulE111` on `O^2`.
- Formalize the `O = C plus C^3` splitting and centralizer-preservation
  predicates before touching compact groups.
- Later, connect to Clifford algebra and pure spinor infrastructure.

Sources:

- Krasnov, "SO(9) characterization of the Standard Model gauge group",
  arXiv:1912.11282:
  <https://arxiv.org/abs/1912.11282>
- Krasnov, "Geometry of Spin(10) Symmetry Breaking", arXiv:2209.05088:
  <https://arxiv.org/abs/2209.05088>
- Krasnov, "Octonions, complex structures and Standard Model fermions",
  arXiv:2504.16465:
  <https://arxiv.org/abs/2504.16465>
- Baez, "Octonions and the Standard Model (Part 13)", n-Category Cafe:
  <https://golem.ph.utexas.edu/category/?wref=bif>

### Target 4: Furey-Hughes triality-triple generation conjecture

Informal target:

```text
The Standard Model internal Lie algebra su(3) + su(2) + u(1)
appears inside tri(C) + tri(H) + tri(O), acting on a triality triple
(Psi_+, Psi_-, V) in C tensor H tensor O, with the three roles accounting
for three generations after Cartan factorization.
```

Why it is interesting:

- It is a plausible right-handed/three-generation route that does not try to
  squeeze the full fermion sector into Krasnov's `O^2` left-handed picture.
- It is representation-theoretic and table-driven enough to break into Lean
  milestones.

Lean entry point:

- Define `tri(A)` for the project octonions first in a finite-coordinate way.
- Prove the triality relation is closed under commutator.
- Build a typed `TrialityTriple` scaffold and then formalize the representation
  tables.

Sources:

- Furey-Hughes, "Three Generations and a Trio of Trialities",
  arXiv:2409.17948:
  <https://arxiv.org/abs/2409.17948>
- Furey, "Three generations, two unbroken gauge symmetries, and one
  eight-dimensional algebra", arXiv:1910.08395:
  <https://arxiv.org/abs/1910.08395>
- Furey-Hughes, "Division algebraic symmetry breaking", arXiv:2210.10126:
  <https://arxiv.org/abs/2210.10126>

### Target 5: Baez-Huerta grand-unification square

Informal target:

```text
The Standard Model gauge group can be characterized as a pullback/intersection
relating the Georgi-Glashow SU(5), Pati-Salam, and Spin(10) grand-unification
groups.
```

Why it is interesting:

- This is less speculative than many octonion-based claims: it is a precise
  representation-theoretic organization of known GUTs.
- It could give the project a clean conventional-physics anchor and a path to
  right-handed charge-conjugate conventions.

Lean entry point:

- Formalize the finite-dimensional complex representations and block subgroup
  inclusions.
- Prove the pullback/intersection statement first at the level of matrix
  predicates before adding Lie-group topology.

Sources:

- Baez-Huerta, "The Algebra of Grand Unified Theories":
  <https://math.ucr.edu/home/baez/guts.pdf>
- AMS article page:
  <https://www.ams.org/bull/2010-47-03/S0273-0979-10-01294-2/>
- nLab `SO(10)` page, useful as a source map rather than a proof source:
  <https://ncatlab.org/nlab/show/SO%2810%29>

### Target 6: Bioctonionic projective geometry

Informal target:

```text
Define a "bioctonionic plane" using C tensor O. Points and lines exist, but
the incidence axioms of an ordinary projective plane fail: some pairs of
distinct lines meet in more than one point, and dually for points.
```

Why it is interesting:

- It is a crisp negative theorem: a formally checked failure of projective-plane
  axioms can be more publishable than a vague positive physics analogy.
- It connects naturally to the repository's complexified octonions and
  projective-geometry draft.

Lean entry point:

- Define the bioctonionic point/line predicates in a small coordinate model.
- Exhibit a concrete counterexample to uniqueness of line intersection or
  uniqueness of line through two points.

Sources:

- Baez, "Octonions and the Standard Model (Part 12)", n-Category Cafe archive:
  <https://golem.ph.utexas.edu/category/?wref=bif>
- Baez octonions background:
  <https://math.ucr.edu/home/baez/octonions/octonions.html>

### Target 7: Integral octonions, E8, Leech lattice, and `H3O`

Informal targets:

```text
The 240 shortest integral octonions form an E8 root system.
Certain triples of integral octonions realize the Leech lattice.
Some Leech lattice embeddings into the off-diagonal part of H3O are compatible
with the exceptional Jordan product.
```

Why it is interesting:

- This is a mathematically rich route that is less physically speculative.
- It could connect the project to Sphere-Packing-Lean's E8 formalization and
  recent Lean work on codes.

Lean entry point:

- Start with the E8 lattice/integral-octonion equivalence or a bridge to
  Sphere-Packing-Lean's E8.
- Formalize the off-diagonal `H3O` embedding and a small product-compatibility
  theorem for one explicit embedding.

Sources:

- Baez-Egan, "Integral Octonions" series:
  <https://math.ucr.edu/home/baez/octonions/integers/>
- Integral Octonions Part 9, Leech lattice in `O^3`:
  <https://golem.ph.utexas.edu/category/2014/11/integral_octonions_part_9.html>
- Integral Octonions Part 10, Leech lattice in the exceptional Jordan algebra:
  <https://golem.ph.utexas.edu/category/2014/12/integral_octonions_part_10.html>
- Sphere-Packing-Lean:
  <https://github.com/math-inc/Sphere-Packing-Lean>

### Target 8: Construction A bridge from Hamming codes to E8/Narain lattices

Informal targets:

```text
The extended binary [8,4,4] Hamming code gives the E8 lattice by Construction A.
Recent heterotic Narain examples can be reproduced from code data plus metric,
B-field, and gauge-background choices.
```

Why it is interesting:

- It is much cleaner than claiming Hamming codes explain Standard Model anomaly
  cancellation.
- Recent formalization and physics papers make this unusually timely.

Lean entry point:

- Formalize the extended Hamming code and Construction A lattice.
- Prove the result is isometric/equal to the E8 lattice definition used by
  Sphere-Packing-Lean or a local coordinate definition.
- Keep the Narain-lattice part as a later typed scaffold.

Sources:

- Mizoguchi-Oikawa, "Error correcting codes and heterotic Narain CFTs",
  arXiv:2602.16269:
  <https://arxiv.org/abs/2602.16269>
- Baek-Kim, "Formalizing building-up constructions of self-dual codes through
  isotropic lines in Lean", arXiv:2604.08485:
  <https://arxiv.org/abs/2604.08485>
- Error Correction Zoo E8 entry:
  <https://errorcorrectionzoo.org/c/eeight>
- Sphere-Packing-Lean blueprint:
  <https://thefundamentaltheor3m.github.io/Sphere-Packing-Lean/blueprint/index.html>

## Recommended publication sequence

### First paper

Best bet:

```text
A Lean 4 Formalization of Octonionic Ladder Operators and a Minimal Left Ideal
```

Scope:

- real octonion core summary;
- complexified octonions;
- Furey ladder operators;
- Cl(6) relations;
- minimal-left-ideal basis;
- electric-charge operator and action table;
- explicit convention audit.

Do not include:

- a claim that the Standard Model is derived;
- hypercharge claims unless `T3` and chirality conventions are formalized;
- full anomaly cancellation unless it is complete and aligned with PhysLean.

### Second paper

Best follow-up:

```text
From Division-Algebraic Charge Tables to Formal Anomaly Cancellation in Lean
```

This should connect the Furey formalization to PhysLean/HepLean's anomaly
systems and settle the charge/hypercharge convention story.

### Third paper

Choose based on which infrastructure lands first:

- if Construction A lands cleanly: publish the Hamming-to-E8 bridge;
- if Aristotle makes strong progress on `h_3(O)`: publish the exceptional
  Jordan scaffold;
- if the Standard Model group quotient is finished: publish it as a short
  formal gauge-group note or fold it into the anomaly paper.

## Claims to avoid for now

The following claims are not yet publishable from the current formalization:

- "The Standard Model has been derived from octonions."
- "The Baez/Dubois-Violette/Todorov stabilizer theorem has been formalized."
- "The project explains right-handed fermions in the Krasnov/Baez `O^2`
  picture."
- "Hurwitz's classification has been proved because the sedenions fail."
- "The Standard Model gauge group quotient or any `F4`/`Spin(9)` stabilizer
  isomorphism has been formalized as a compact Lie group theorem."
- "Three generations have been derived from triality."
- "Hamming codes explain Standard Model anomaly cancellation."
- "Green-Schwarz anomaly cancellation has been formalized."

These may become research targets, but a publishable paper should currently
frame them as motivation and future work.

## Minimum checklist for any submission

Before submitting any paper, require:

1. A no-sorry check over every trusted module cited in the paper.
2. A clean build under the pinned Lean toolchain.
3. A source-provenance table for every physics-facing declaration.
4. A convention table for:
   - octonion basis and Fano orientation;
   - complex unit choice;
   - charge normalization;
   - particle/antiparticle convention;
   - weak isospin and hypercharge convention;
   - group quotient convention.
5. A statement of what the Lean kernel verifies and what remains semantic
   interpretation.
6. A reproducibility appendix with exact commands and commit hash.
