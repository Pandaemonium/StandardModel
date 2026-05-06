# Aristotle moonshot: exceptional Jordan projective geometry and the Standard Model stabilizer

Status: submitted

Prepared: 2026-05-06

Aristotle job:

```text
17d42ab0-5795-4bcc-b387-d93e47bd976e
```

Submission note: the full text of this file was included in the submitted
project bundle. The CLI prompt instructed Aristotle to read this file and carry
out the moonshot task.

## Goal

Push as far as possible toward a Lean formalization of the Baez-Schwahn
projective-geometry conjecture:

```text
If X is a complex projective plane in OP^2, ell is an octonionic projective
line in OP^2, and X cap ell is a complex projective line, then the group of
automorphisms of h_3(O) preserving both X and ell is S(U(2) x U(3)).
```

This is intentionally ambitious. The expected best outcome is not necessarily
a proof of the final stabilizer theorem. A highly successful result would be:

- a well-typed and reviewed coordinate model for `h_3(O)`;
- a correct Jordan product using the project's octonion conventions;
- kernel-checked basic lemmas about trace, projections, and the standard
  `h_2(O)`, `h_3(C)`, and `h_2(C)` blocks;
- a clean projective dictionary between subalgebras and points/lines where the
  needed infrastructure is available;
- precise draft statements and handoff notes for any remaining `F4`,
  `Spin(9)`, or `S(U(2) x U(3))` frontier steps.

## Repository rules

Please follow `AGENTS.md`.

Important constraints:

- Trusted Lean code must not contain `sorry`, `admit`, `axiom`, `opaque`, or
  `unsafe`.
- Draft files may contain documented `sorry`s.
- Use verbose comments and descriptive names.
- Do not silently change octonion conventions.
- Do not weaken mathematical statements merely to make proofs easier.
- If a statement looks false or underspecified, leave a useful handoff note.

## Existing scaffold

Work from:

```text
PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean
Sources/Exceptional_Jordan_Projective_Geometry_Lit_Search.md
Sources/Baez_Octonions_Standard_Model_Talk_Notes.md
```

The draft file already introduces:

- `H3O`, a six-coordinate model for a Hermitian 3 by 3 octonionic matrix;
- `trace`;
- draft `jordanProduct`;
- projections, `OP2Point`, `OP2Line`, and incidence;
- the chosen complex line `span_R {1, e111}` in the project octonions;
- predicates for the standard blocks:
  - `InStandardA` for the upper-left `h_2(O)` block,
  - `InStandardB` for the chosen `h_3(C)` block,
  - `InStandardAInterB` for the upper-left `h_2(C)` intersection;
- draft automorphism and stabilizer structures;
- frontier target statements for pair-transitivity and the final stabilizer
  isomorphism.

The file typechecks with intentional draft `sorry`s under:

```text
lake env lean PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean
```

## Mathematical sources

Use the source note for details. The main references are:

- John Baez and Paul Schwahn, "Projective Geometry and the Exceptional Jordan
  Algebra", AMS Special Session slides, 2026.
- John Baez, n-Category Cafe note on the same project, 2026.
- Ivan Todorov and Michel Dubois-Violette, "Deducing the symmetry of the
  standard model from the automorphism and structure groups of the exceptional
  Jordan algebra", IJMPA 33(20), 1850118, 2018.
- Kirill Krasnov, "SO(9) characterization of the Standard Model gauge group",
  J. Math. Phys. 62, 021703, 2021.
- Landsberg and Manivel, "The projective geometry of Freudenthal's magic
  square", for projective geometry over composition algebras.
- Baez, "The Octonions", for background on `OP^2` and the exceptional Jordan
  algebra.

## Convention notes

The project octonions use the XOR binary-label convention:

```text
e000 = 1, e001, e010, e011, e100, e101, e110, e111
```

The chosen copy of the complex numbers is:

```text
C = span_R {1, e111}.
```

This means an octonion is in the chosen complex line exactly when coordinates
`c1` through `c6` vanish. The coordinate `c7` is the imaginary complex
coefficient. Do not import Baez or Furey signs directly without using the
project's convention bridge.

## Preferred attack plan

### Layer 1: finite coordinate algebra

Implement or repair as much as possible in the draft file:

1. Replace draft `jordanProduct` with the explicit coordinate formula for
   `(a*b + b*a)/2`, using the displayed Hermitian matrix convention:

   ```text
   [[alpha, z, conj y],
    [conj z, beta, x],
    [y, conj x, gamma]]
   ```

   Be extremely explicit about parenthesization because octonions are not
   associative.

2. Prove easy coordinate lemmas:

   - `trace_zero`;
   - `trace_add`;
   - `trace_neg`;
   - `trace_smul`;
   - `trace_standardOctonionicLineProjection`;
   - `standardOctonionicLineProjection_isProjection`.

3. Prove that the chosen complex line is closed under:

   - zero;
   - addition;
   - negation;
   - real scalar multiplication;
   - conjugation;
   - octonion multiplication.

The multiplication closure may require existing project lemmas about the XOR
octonion product. If a clean proof is not available, create small helper lemmas
with explicit component statements.

### Layer 2: standard block subalgebras

Construct `standardA`, `standardB`, and `standardAInterB` as actual
`JordanSubalgebra`s.

Prove closure under zero, addition, negation, scalar multiplication, and the
Jordan product.

The most valuable facts are:

- `standardA_mem_iff`;
- `standardB_mem_iff`;
- `standardAInterB_mem_iff`;
- `standardAInterB_is_intersection`;
- `standardA_isH2O` in the scaffold's current placeholder sense;
- `standardB_isH3C` in the scaffold's current placeholder sense;
- `standardAInterB_isH2C` in the scaffold's current placeholder sense.

If the placeholder propositions are too weak or poorly shaped, improve them in
the draft file, but document the change.

### Layer 3: projective dictionary

Formalize the standard line and standard complex plane:

- build `standardOctonionicLine`;
- build `standardComplexProjectivePlane`;
- prove that the point carrier of the standard complex plane is exactly the
  trace-one projections whose coordinates lie in the chosen complex line;
- state and, if possible, prove the standard intersection is a complex
  projective line in the scaffold sense.

### Layer 4: automorphisms and stabilizers

If feasible, replace the draft `Group H3OAutomorphism` and stabilizer group
instances with kernel-checked definitions.

Try to prove small general lemmas:

- automorphisms preserve projections;
- automorphisms send points to points;
- automorphisms send lines to lines;
- the common stabilizer is closed under composition and inverse.

Do not invent axioms for `F4`.

### Layer 5: frontier statements

The final transitivity and stabilizer isomorphism likely require Lie-group
infrastructure not currently present. If they cannot be proved, leave them as
draft statements with precise proof-handoff notes:

- what exact mathematical theorem is needed;
- which source supports it;
- what current Lean infrastructure is missing;
- what smaller theorem should be attacked next.

## Deliverables

Please return:

1. Every file changed.
2. Which declarations are trusted and sorry-free.
3. Which declarations remain draft.
4. The exact verification commands run.
5. A short semantic-alignment note explaining whether the formal statements
   still match the Baez-Schwahn and Dubois-Violette-Todorov statements.

If you can move any sorry-free, broadly useful pieces from
`PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean` into a trusted
module under `PhysicsSM/Algebra/Jordan/`, please do so only after checking that
the moved file has no `sorry`s and no hidden assumptions.
