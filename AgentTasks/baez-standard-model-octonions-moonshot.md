# Aristotle moonshot: Baez 2021 "Standard Model from the octonions" targets

Status: submitted

Prepared: 2026-05-06

Aristotle job:

```text
76df9a63-ef90-4aa4-b0cb-e82e2ba48b32
```

Submission note: the full text of this file was included in the submitted
project bundle. The CLI prompt instructed Aristotle to read this file and
carry out the moonshot task.

## Goal

Push as far as possible toward Lean formalization of the concrete theorem
targets in John Baez's 2021 presentation:

```text
Can We Understand the Standard Model Using Octonions?
```

Local source PDF:

```text
Sources/John _Baez_standard_model_octonions.pdf
```

Local proof plan:

```text
Sources/Baez_Standard_Model_Octonions_Lean_Proof_Plan.md
```

The most valuable result would be a set of small, trusted, sorry-free Lean
modules that make the presentation's early and middle claims precise enough
for later stabilizer work:

- the chosen complex line `C = span_R {1, e111}` inside the project octonions;
- the complement to that line and the induced complex structure;
- a concrete `h_2(O)` / octonionic-qubit model;
- spin-factor determinant/projection facts for `h_2(O)`;
- the true Standard Model gauge group `S(U(2) x U(3))` as a block matrix group
  or, if full matrix-subgroup infrastructure is too heavy, a carefully named
  draft scaffold with the `Z6` quotient target;
- the `h_3(C)` subalgebra/splitting targets needed for the later
  Dubois-Violette-Todorov/Yokota stabilizer theorem;
- the `O^2` octonionic-qubit complex-structure target used in Krasnov's
  left-handed fermion statement.

The final compact Lie group isomorphisms are frontier targets. Do not fake
them with axioms. State them precisely in `Draft` if the supporting
infrastructure is missing.

## Repository rules

Follow `AGENTS.md`.

Important constraints:

- Trusted Lean source must not contain `sorry`, `admit`, `axiom`, `opaque`, or
  `unsafe`.
- Draft files may contain documented `sorry`s.
- Use verbose comments and descriptive names.
- Do not silently change octonion conventions.
- The project octonion convention is the XOR binary-label convention.
- The chosen imaginary unit for this job should be `e111`, matching the current
  draft scaffold, unless you explicitly parameterize and prove a conversion.
- Do not claim that the Standard Model has been physically derived. The trusted
  near-term claims are algebraic and group-theoretic scaffolding.

## Existing context

Read these files first:

```text
AGENTS.md
Sources/Baez_Standard_Model_Octonions_Lean_Proof_Plan.md
Sources/Baez_Octonions_Standard_Model_Talk_Notes.md
Sources/Exceptional_Jordan_Projective_Geometry_Lit_Search.md
PhysicsSM/Algebra/Octonion/Basic.lean
PhysicsSM/Algebra/Octonion/Conjugation.lean
PhysicsSM/Algebra/Octonion/Norm.lean
PhysicsSM/Algebra/Octonion/ConventionBridge.lean
PhysicsSM/Algebra/Jordan/H3O.lean
PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean
```

There is also a related Aristotle job already running:

```text
17d42ab0-5795-4bcc-b387-d93e47bd976e
```

That job targets the later Baez-Schwahn projective-geometry conjecture. This
job should avoid needless duplication and emphasize the 2021 talk's concrete
foundational targets.

## Preferred implementation order

### 1. Chosen complex line in octonions

Create a trusted module if feasible:

```text
PhysicsSM/Algebra/Octonion/ComplexLine.lean
```

Suggested declarations:

- `InChosenComplexLine`;
- `InChosenComplexComplement`;
- lemmas for zero, addition, negation, scalar multiplication, conjugation;
- closure of `InChosenComplexLine` under octonion multiplication;
- left multiplication by `e111` preserves the complement;
- left multiplication by `e111` squares to `-1` on the complement;
- right multiplication by `e111` squares to `-1` where needed for `O^2`.

If multiplication closure or complex-structure facts require component
expansion, prefer a clear component proof over a fragile tactic.

### 2. Minimal Jordan algebra vocabulary

Create a small trusted or draft module:

```text
PhysicsSM/Algebra/Jordan/Basic.lean
```

Keep it small. We do not need the full Euclidean Jordan algebra hierarchy yet.

Useful declarations:

- a typeclass or structure for a named Jordan product;
- `IsJordanProjection`;
- `JordanTraceOneProjection`;
- comments explaining why the classification theorem is source context rather
  than a near-term Lean dependency.

### 3. `h_2(O)` and spin-factor facts

Create trusted modules if feasible:

```text
PhysicsSM/Algebra/Jordan/SpinFactor.lean
PhysicsSM/Algebra/Jordan/H2O.lean
```

Targets from slides 7-16:

- concrete spin-factor product;
- determinant `t^2 - ||x||^2`;
- trace;
- projection equations;
- trace-one projection equations;
- concrete `H2O` coordinates for

```text
[[t+x, y],
 [conj y, t-x]]
```

- determinant formula:

```text
t^2 - x^2 - normSq(y)
```

- trace-square Euclidean form:

```text
1/2 * tr(a o a) = t^2 + x^2 + normSq(y)
```

If the full equivalence `h_2(O) ~= R + R^9` is too large, prove the concrete
coordinate formulas and leave the equivalence as a draft target.

### 4. True Standard Model gauge group scaffolding

If mathlib's matrix unitary-group APIs are convenient, start:

```text
PhysicsSM/Gauge/StandardModelGroup.lean
PhysicsSM/Gauge/BlockEmbeddings.lean
```

Targets from slides 17-21:

- define or draft `S(U(2) x U(3))` as a block subgroup of `SU(5)`;
- define the block map

```text
(alpha, g, h) |-> (g, block_diag(alpha * h, alpha^-3))
```

into `SU(2) x SU(4)`;

- prove determinant-one lemmas for the `SU(4)` block where feasible;
- state the `Z6` kernel / quotient theorem precisely.

If full quotient-group infrastructure is too much, leave the quotient theorem
in `Draft`, but prove any finite determinant/block arithmetic that is easy.

### 5. `h_3(O)` block decomposition and `h_3(C)` splitting

Coordinate with:

```text
PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean
```

Targets from slides 23-33:

- define the `H3O ~= Real x H2O x (Octonion x Octonion)` block projection maps;
- define `H3CInH3O` using `InChosenComplexLine`;
- define `H3COrthogonalComplement` using the trace form if available;
- prove the coordinate characterization of the complement if the Jordan product
  and trace form are available;
- define the complex structure on the complement and prove it squares to `-1`;
- state the `(SU(3) x SU(3)) / Z3` stabilizer theorem as a draft Yokota/DVT
  target if not provable.

### 6. Krasnov octonionic-qubit endpoint

Create a draft or trusted module as appropriate:

```text
PhysicsSM/Spinor/OctonionicQubit.lean
```

Targets from slides 35-36:

- define `OctonionicQubit := Octonion x Octonion`;
- define right multiplication by `e111`;
- prove it squares to `-1`;
- state the centralizer theorem:

```text
centralizer_Spin9(rightMul_e111_on_O2) ~= S(U(2) x U(3))
```

- state the left-handed one-generation representation comparison target;
- explicitly document that right-handed fermions remain open in this route.

## Deliverables

Please return:

1. Every file changed.
2. Which declarations are trusted and sorry-free.
3. Which declarations remain draft.
4. Exact verification commands run.
5. Any semantic alignment concerns with Baez 2021, DVT/Yokota, or Krasnov.

If a proof gets hard, do not churn. Leave a precise draft statement or proof
handoff note and move to another useful target.
