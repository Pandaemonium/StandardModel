# Level 7: Complex Octonions And Furey Layer Primer

**Purpose.** This tutorial explains the project files that build Furey-style
ladder operators and minimal-left-ideal finite arithmetic from complexified
octonions. It is for agents that already understand basic octonions and the
ConventionBridge safety rules.

**Prerequisites.** Read these first:

- `Skills/00_REPOSITORY_SURVIVAL.md`
- `Skills/04_MATH_LANGUAGE_PRIMER.md`
- `Skills/05_OCTONION_PRIMER.md`
- `Skills/06_CONVENTION_BRIDGE_PRIMER.md`

**Key vocabulary.** complexified octonion, real part, imaginary part, scalar,
complex scalar, pair representation, ladder operator, dagger, nilpotent,
anticommutator, Clifford algebra, primitive idempotent, ideal, minimal left
ideal, action table, number operator, charge sum, semantic interpretation.

**Safety rule.** The Lean kernel checks the explicit algebraic equalities in
the project convention. It does not check that a state has the intended
Standard Model particle interpretation. Treat particle names as source-guided
interpretation requiring review.

---

## 1. The Files In This Layer

Study these files in order:

```text
PhysicsSM/Algebra/Octonion/ComplexOctonion.lean
PhysicsSM/Algebra/Furey/LadderOperators.lean
PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean
AgentTasks/furey-minimal-ideal-moonshot.md
Sources/README.md
```

The dependency order is:

```text
Octonion.Basic
  -> ComplexOctonion
      -> Furey.LadderOperators
          -> Furey.MinimalLeftIdeal
```

Do not edit a downstream file without understanding the definitions it imports.

## 2. What Is A Complexified Octonion?

A project octonion has eight real coordinates.

A complexified octonion lets those coordinates become complex, but the project
represents it as a pair of real octonions:

```text
ComplexOctonion = re + i im
```

where:

```text
re : Octonion
im : Octonion
```

The file:

```text
PhysicsSM/Algebra/Octonion/ComplexOctonion.lean
```

defines:

```text
structure ComplexOctonion where
  re : Octonion
  im : Octonion
```

Plain English:

```text
A complexified octonion is a real octonion plus i times another real octonion.
```

## 3. Why The Pair Representation Is Useful

The pair representation keeps everything explicit.

If:

```text
a = a.re + i a.im
b = b.re + i b.im
```

then multiplication is:

```text
a * b =
  (a.re * b.re - a.im * b.im)
  + i (a.re * b.im + a.im * b.re)
```

The multiplication inside each part is still octonion multiplication. Therefore
it is still noncommutative and nonassociative.

Low-end warning:

```text
Complexified octonions are not ordinary complex numbers.
```

They have a complex scalar direction, but their octonion multiplication remains
nonassociative.

## 4. Coordinates In ComplexOctonion

A `ComplexOctonion` has 16 real coordinates:

```text
re.c0, re.c1, ..., re.c7
im.c0, im.c1, ..., im.c7
```

This is why many proofs use:

```lean
ext <;> simp [some_defs] <;> ring
```

Plain English:

```text
Split equality of complexified octonions into real and imaginary octonion
coordinates, then split those into scalar coordinate equations.
```

## 5. Important ComplexOctonion Declarations

Read `ComplexOctonion.lean` and find:

```text
ComplexOctonion
I
ofOctonion
ofComplex
complexConj
mul_re
mul_im
add_re
add_im
zero_re
zero_im
neg_re
neg_im
one_re
one_im
```

The projection lemmas such as `mul_re` and `mul_im` are used by `simp` to
expand complexified multiplication.

## 6. What Are Furey Ladder Operators?

In this project, the Furey ladder operators are three explicit elements of
`ComplexOctonion`:

```text
alpha1
alpha2
alpha3
```

They live in:

```text
PhysicsSM/Algebra/Furey/LadderOperators.lean
```

They are translated from Furey's source convention into the project XOR
convention through `ConventionBridge`.

Project formulas in plain ASCII:

```text
alpha1 = (+e100 + i e011) / 2
alpha2 = (-e110 + i e001) / 2
alpha3 = (-e101 + i e010) / 2
```

Do not change these signs unless a strong reviewer explicitly tells you to.

## 7. What Is Dagger?

The file also defines:

```text
alpha1_dag
alpha2_dag
alpha3_dag
```

The dagger operation here is the Clifford adjoint used for the ladder-operator
relations. For these pure imaginary octonion components, the project rule is:

```text
negate the real octonion part, keep the imaginary octonion part.
```

Project formulas in plain ASCII:

```text
alpha1_dag = (-e100 + i e011) / 2
alpha2_dag = (+e110 + i e001) / 2
alpha3_dag = (+e101 + i e010) / 2
```

Low-end warning:

```text
Dagger is not the same as simply replacing i by -i in these formulas.
```

The docstring in `LadderOperators.lean` explains why the naive formula gives
the wrong anticommutation sign.

## 8. Nilpotency

An element is nilpotent if a power of it is zero. Here the ladder operators
satisfy:

```text
alpha1 * alpha1 = 0
alpha2 * alpha2 = 0
alpha3 * alpha3 = 0
```

and similarly for the dagger operators.

Lean theorem names:

```text
alpha1_nilpotent
alpha2_nilpotent
alpha3_nilpotent
alpha1_dag_nilpotent
alpha2_dag_nilpotent
alpha3_dag_nilpotent
```

These are finite coordinate computations in the explicit algebra.

## 9. Anticommutators

The anticommutator of two elements `a` and `b` is:

```text
a * b + b * a
```

For the Furey ladder operators, important relations include:

```text
alpha_i * alpha_i_dag + alpha_i_dag * alpha_i = 1
alpha_i * alpha_j_dag + alpha_j_dag * alpha_i = 0 when i != j
alpha_i * alpha_j + alpha_j * alpha_i = 0
alpha_i_dag * alpha_j_dag + alpha_j_dag * alpha_i_dag = 0
```

The file proves all 27 Cl(6)-style anticommutation relations.

Low-end safe task:

```text
Find a theorem name and translate its statement.
```

Low-end unsafe task:

```text
Change an anticommutation theorem statement to make a proof pass.
```

## 10. What Is Omega?

In `MinimalLeftIdeal.lean`, `omega` is a primitive idempotent:

```text
omega = (1 - i e111) / 2
```

The important theorem is:

```text
omega_idempotent : omega * omega = omega
```

Plain English:

```text
Multiplying omega by itself gives omega back.
```

The definition depends on the privileged source basis element `e7`, which maps
to project `e111` under the convention bridge.

## 11. What Is An Ideal?

An ideal is a subspace that is stable under multiplication in a specified way.

This project is currently doing explicit finite arithmetic first. It has not
fully packaged every statement as an abstract `Submodule` or ideal API.

For low-end agents, treat "minimal left ideal" as:

```text
a source-guided algebraic structure represented here by explicit states and
verified action-table equations.
```

Do not assume all abstract ideal facts are already available in Lean.

## 12. The Eight States

`MinimalLeftIdeal.lean` defines eight explicit states:

```text
omega
v1
v2
v3
v4
v5
v6
nu
```

They are built from ladder operators acting on `omega`.

Examples:

```text
v1 = alpha1 * omega
v4 = alpha1 * (alpha2 * omega)
nu = alpha1 * (alpha2 * (alpha3 * omega))
```

The parentheses matter. Do not change them.

The file also proves equations such as:

```text
v1_eq
v2_eq
...
nu_eq
```

These verify that the explicit coordinate definitions match the ladder-operator
products.

## 13. Physical Names Are Interpretive

Some docstrings mention particle names such as:

```text
neutrino
anti-up quark
anti-down quark
electron
```

These names come from Furey's interpretation and convention choices.

The Lean kernel checks statements such as:

```text
alpha1 * omega = v1
```

It does not check:

```text
v1 is physically an anti-up quark.
```

Treat physical names as source-guided comments requiring semantic review.

## 14. The Action Table

`MinimalLeftIdeal.lean` proves how each ladder operator acts on each of the
eight states.

Example theorem shape:

```text
act_a1_v2 : alpha1 * v2 = v4
```

Plain English:

```text
Applying alpha1 on the left to state v2 gives state v4.
```

The table is a collection of finite coordinate computations.

Low-end safe task:

```text
Summarize an action theorem in plain English.
```

Low-end unsafe task:

```text
Infer a new physics rule from the action table without source review.
```

## 15. Number Operators And Charge Sums

The file defines or proves facts involving number operators such as:

```text
N1
N2
N3
```

In this finite arithmetic layer, many theorems say that applying a combination
of ladder operators to a state gives either zero or the state back.

Charge-sum lemmas then verify source-guided charge patterns.

Low-end warning:

```text
Do not change a charge convention. Hypercharge and electric charge conventions
must be reviewed carefully.
```

## 16. Common Proof Pattern

Many proofs in the Furey files look like:

```lean
ext <;> simp [alpha1, omega, v1] <;> ring
```

Plain English:

1. Split equality of complexified octonions into coordinates.
2. Expand all explicit definitions.
3. Reduce to real polynomial equations.
4. Let `ring` prove the scalar equations.

This works because the statement is concrete finite arithmetic.

It does not mean arbitrary nonassociative algebra can be simplified freely.

## 17. Good Low-End Tasks

Safe:

- Summarize `ComplexOctonion.lean`.
- Explain `ComplexOctonion` as `re + i im`.
- Find the definition of `alpha1`.
- Explain why `alpha1` has `+e100`.
- Translate an anticommutation theorem into plain English.
- Identify which source note justifies a ladder operator.
- Summarize the eight states in `MinimalLeftIdeal.lean`.
- Add markdown tutorial content.
- Create a focused task file for stronger review.

Safe with review:

- Add a docstring to an existing theorem.
- Add comments explaining a repetitive coordinate proof.
- Add a simple theorem that is exactly a known coordinate computation.

Not safe:

- Change ladder operator signs.
- Change dagger formulas.
- Change `omega`.
- Change parentheses in state definitions.
- Change charge conventions.
- Decide physical particle interpretation.
- Add abstract `Submodule` or `Basis` API without strong review.
- Refactor complexified multiplication.

## 18. How To Read A Furey Theorem

When reading a theorem, write:

```text
Theorem name:
Inputs:
Left side:
Right side:
Product order:
Parentheses:
Definitions used:
Plain-English meaning:
Physical interpretation claimed in comments:
Does Lean prove the interpretation, or only the algebraic equality?
```

This checklist prevents overclaiming.

## 19. Example Reading

Theorem:

```text
act_a1_v2 : alpha1 * v2 = v4
```

Plain English:

```text
Left multiplication by alpha1 sends v2 to v4.
```

Lean proves:

```text
the exact algebraic equality in ComplexOctonion.
```

Lean does not prove by itself:

```text
the full Standard Model interpretation of v2 and v4.
```

## 20. Practice Exercise 1: Pair Representation

Task:

1. Open `ComplexOctonion.lean`.
2. Find the `ComplexOctonion` structure.
3. Explain what `re` and `im` mean.

Expected answer:

```text
`re` is the real octonion part.
`im` is the octonion coefficient of the complex imaginary unit.
Together they represent re + i im.
```

## 21. Practice Exercise 2: Ladder Operators

Task:

1. Open `LadderOperators.lean`.
2. Find `alpha1`, `alpha2`, and `alpha3`.
3. Write their project XOR formulas in plain ASCII.
4. Explain which one visibly uses the Baez e5 sign flip.

Expected answer:

```text
alpha1 uses the sign flip: source -e5 becomes project +e100.
```

## 22. Practice Exercise 3: Dagger Warning

Task:

Explain why the dagger formulas are not just complex conjugation.

Expected answer:

```text
For these operators, dagger negates the real octonion part and keeps the
imaginary octonion part. The naive i -> -i rule gives the wrong canonical
anticommutation sign according to the file comments and oracle validation.
```

## 23. Practice Exercise 4: State Definitions

Task:

1. Open `MinimalLeftIdeal.lean`.
2. Find `omega`, `v1`, `v4`, and `nu`.
3. Write the ladder-product description of each.
4. Keep the parentheses exactly as written.

## 24. Practice Exercise 5: Action Table

Task:

1. Find one theorem whose name begins with `act_`.
2. Translate it into plain English.
3. State whether it is an algebraic equality or a physics interpretation.

Expected answer shape:

```text
Theorem:
Plain English:
Lean proves:
Lean does not prove:
```

## 25. Practice Exercise 6: Proof Pattern

Find a theorem in `MinimalLeftIdeal.lean` proved by:

```lean
ext <;> simp [...] <;> ring
```

Answer:

1. Which definitions are expanded?
2. How many real coordinate goals are hidden behind `ext`?
3. Why is `ring` allowed at the end?

Expected idea:

```text
ComplexOctonion equality reduces to real and imaginary octonion equality, then
to scalar coordinates. Once the goal is real arithmetic, `ring` is appropriate.
```

## Final Checklist

Before working in the Furey layer, confirm:

- I understand `ComplexOctonion` as a pair `re + i im`.
- I remember octonion multiplication remains nonassociative.
- I know the ladder operators depend on ConventionBridge.
- I know the dagger formulas are special and reviewed.
- I will not change signs or parentheses.
- I can distinguish algebraic equality from physical interpretation.
- I know which theorem names already exist.
- I know when to escalate to a stronger model or Aristotle.

## One-Sentence Rule

In the Furey layer, low-end agents may explain and check finite arithmetic, but
must not invent conventions or physics interpretation.
