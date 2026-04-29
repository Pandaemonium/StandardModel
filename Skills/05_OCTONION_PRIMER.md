# Level 5: Project Octonion Primer

**Purpose.** This tutorial teaches the octonion concepts needed to read and
work safely in `PhysicsSM/Algebra/Octonion/`. It assumes you can already read
basic Lean syntax and basic mathematical language, but it does not assume you
already know octonions.

**Prerequisites.** Read these first:

- `Skills/00_REPOSITORY_SURVIVAL.md`
- `Skills/01_LEAN_READING_BASICS.md`
- `Skills/02_LEAN_WRITING_BASICS.md`
- `Skills/04_MATH_LANGUAGE_PRIMER.md`

**Key vocabulary.** octonion, coordinate, basis, scalar part, imaginary part,
unit, Fano plane, XOR convention, multiplication table, nonassociative,
noncommutative, conjugation, squared norm, alternativity, Moufang identity,
component proof.

**Safety rule.** Octonion multiplication is not associative. Never replace
`(x * y) * z` with `x * (y * z)` unless a theorem with exactly that
parenthesization justifies it.

---

## 1. What Is An Octonion?

An octonion is an eight-dimensional number-like object over the real numbers.
You can think of it as:

```text
x = c0 e000 + c1 e001 + c2 e010 + c3 e011
  + c4 e100 + c5 e101 + c6 e110 + c7 e111
```

The eight real numbers:

```text
c0, c1, c2, c3, c4, c5, c6, c7
```

are the coordinates of `x`.

In the project Lean code, an octonion is represented directly by these eight
coordinates:

```text
structure Octonion where
  c0 : real number
  c1 : real number
  ...
  c7 : real number
```

The coordinate `c0` is the scalar part. Coordinates `c1` through `c7` are the
imaginary parts.

## 2. The Project Basis

The project uses binary labels for the eight basis elements:

| Label | Decimal index | Role |
|-------|---------------|------|
| `e000` | 0 | unit element |
| `e001` | 1 | imaginary unit |
| `e010` | 2 | imaginary unit |
| `e011` | 3 | imaginary unit |
| `e100` | 4 | imaginary unit |
| `e101` | 5 | imaginary unit |
| `e110` | 6 | imaginary unit |
| `e111` | 7 | imaginary unit |

These labels are not decoration. They define the project convention.

The basis element `e000` is the multiplicative unit:

```text
e000 * x = x
x * e000 = x
```

Every imaginary basis element squares to negative one:

```text
e001 * e001 = -e000
e010 * e010 = -e000
...
e111 * e111 = -e000
```

## 3. The XOR Convention

For two basis elements, the project uses the XOR convention for the product
index.

If you multiply `e_a * e_b`, then:

```text
product index = a XOR b
```

Example:

```text
001 XOR 010 = 011
```

So the product of `e001` and `e010` lands on the basis direction `e011`.

But the sign is a separate question. The product could be:

```text
e001 * e010 = e011
```

or:

```text
e001 * e010 = -e011
```

The sign is determined by the project Fano orientation.

## 4. The Fano Orientation

The Fano plane records which products are positive. The project convention uses
these positive triples:

```text
e001 * e010 = e011
e001 * e101 = e100
e001 * e110 = e111
e010 * e100 = e110
e010 * e101 = e111
e011 * e101 = e110
e011 * e111 = e100
```

The last line is a user-specified anchor:

```text
e011 * e111 = e100
```

If a triple is positive in one cyclic order, cyclic rotations are also positive.

Example:

```text
e001 * e010 = e011
e010 * e011 = e001
e011 * e001 = e010
```

Reversing the order flips the sign:

```text
e010 * e001 = -e011
```

Low-end agents should not derive new signs by memory. Use the local code,
`ConventionBridge`, or the oracle validator.

## 5. Where The Convention Lives In Lean

Read:

```text
PhysicsSM/Algebra/Octonion/Basic.lean
```

Important declarations:

```text
fanoTriples
lookupSign
Octonion
basisElem
basisMul
Octonion.mul_c0 through Octonion.mul_c7
```

The multiplication is not hidden behind abstract algebra. It is written as
eight explicit coordinate formulas:

```text
(a * b).c0 = ...
(a * b).c1 = ...
...
(a * b).c7 = ...
```

Those projection lemmas are the reason many proofs can use:

```lean
ext <;> simp <;> ring
```

Plain English:

```text
Split the octonion equality into eight real coordinate equalities, simplify the
definitions, then prove the resulting real polynomial identities.
```

## 6. Noncommutative And Nonassociative

Octonions are usually not commutative:

```text
x * y may differ from y * x
```

Octonions are also not associative:

```text
(x * y) * z may differ from x * (y * z)
```

This is the most important thing to remember.

Wrong:

```text
I will simplify by moving parentheses.
```

Right:

```text
I will keep the exact parentheses from the theorem statement.
```

Wrong:

```text
I will use ring on an octonion product.
```

Right:

```text
I will first use ext and the coordinate multiplication lemmas to reduce the
goal to real-number polynomial identities.
```

## 7. Alternativity

Octonions are not associative, but they satisfy weaker laws called
alternativity.

Left alternativity:

```text
a * (a * b) = (a * a) * b
```

Right alternativity:

```text
(a * b) * b = a * (b * b)
```

In this project these are theorems in:

```text
PhysicsSM/Algebra/Octonion/Basic.lean
```

Names:

```text
left_alternative
right_alternative
```

Do not use alternativity as if it were full associativity. It only applies to
the exact patterns stated by the theorem.

## 8. Moufang Identities

Octonions satisfy the Moufang identities. These are special reassociation laws
that hold even though full associativity fails.

Read:

```text
PhysicsSM/Algebra/Octonion/Moufang.lean
```

Important theorem names:

```text
moufang_left
moufang_right
moufang_middle
flexible
```

Example:

```text
(x * y) * (z * x) = x * ((y * z) * x)
```

This is not permission to move parentheses freely. It is one exact identity.

Low-end safe task:

```text
Explain what the theorem states in plain English.
```

Low-end unsafe task:

```text
Use Moufang identities to redesign a proof without review.
```

## 9. Conjugation

Octonion conjugation fixes the scalar part and negates the imaginary parts.

If:

```text
x = c0 e000 + c1 e001 + ... + c7 e111
```

then:

```text
conj x = c0 e000 - c1 e001 - ... - c7 e111
```

Read:

```text
PhysicsSM/Algebra/Octonion/Conjugation.lean
```

Important names:

```text
conj
conj_conj
conj_add
conj_neg
conj_smul
conj_mul
mul_conj
conj_mul_self
```

The theorem `conj_mul` says conjugation reverses multiplication order:

```text
conj (x * y) = conj y * conj x
```

Note the reversed order. This is not a typo.

## 10. Squared Norm

The squared norm is the sum of the eight coordinate squares.

Read:

```text
PhysicsSM/Algebra/Octonion/Norm.lean
```

Important names:

```text
normSq
normSq_nonneg
normSq_eq_zero
normSq_conj
normSq_eq_mul_conj
normSq_one
normSq_mul
```

Plain English for `normSq_mul`:

```text
The squared norm of a product is the product of the squared norms.
```

This is the composition-algebra property of octonions.

The proof works because multiplication and `normSq` are expanded into real
coordinate polynomial expressions, then `ring` proves the real polynomial
identity.

## 11. Component Proofs

A component proof is a proof that expands a structured equality into coordinate
equalities.

Common pattern:

```lean
ext <;> simp [some_def] <;> ring
```

Meaning:

1. `ext` splits the equality into coordinate goals.
2. `simp` unfolds definitions and projection lemmas.
3. `ring` proves scalar polynomial equalities.

Use this pattern only when the goal has been reduced to scalar arithmetic.

## 12. Why The Simp Lemmas Matter

Files in `PhysicsSM/Algebra/Octonion/` define many lemmas like:

```text
Octonion.mul_c0
Octonion.mul_c1
...
Octonion.mul_c7
```

These lemmas tell Lean what each coordinate of a product is.

Without them, `simp` cannot expose the real-number goals needed by `ring`.

Low-end agents may safely search for these lemmas and explain them. Adding new
projection lemmas in trusted code requires review unless the statement is
obvious by `rfl` and the task explicitly asks for it.

## 13. Oracle Validation

The project has a Python validator:

```text
Scripts/oracle/validate_octonion.py
```

It checks the multiplication convention and identities such as Moufang
identities.

Important rule:

```text
Oracle output is evidence, not a trusted proof.
```

Trusted Lean theorems still need Lean proofs.

Safe task:

```text
Run or summarize the validator output.
```

Unsafe task:

```text
Add an unproved trusted theorem because the oracle says it is true.
```

## 14. Local Files To Study

Study these in order:

1. `PhysicsSM/Algebra/Octonion/Basic.lean`
2. `PhysicsSM/Algebra/Octonion/Conjugation.lean`
3. `PhysicsSM/Algebra/Octonion/Norm.lean`
4. `PhysicsSM/Algebra/Octonion/Alternativity.lean`
5. `PhysicsSM/Algebra/Octonion/Moufang.lean`
6. `Scripts/oracle/validate_octonion.py`
7. `AgentTasks/octonion-norm-moufang-moonshot.md`

## 15. Safe Tasks For Low-End Agents

Safe:

- Summarize `Basic.lean`.
- Explain the basis labels.
- Explain why the product index uses XOR.
- Find the anchor product `e011 * e111 = e100`.
- Translate a theorem statement into plain English.
- Identify which coordinate lemmas a proof uses.
- Run a targeted Lean check.
- Add comments to markdown tutorials.

Safe with review:

- Add a theorem that is exactly a coordinate projection and proved by `rfl`.
- Add a small docstring to a trusted Lean declaration.
- Prove a tiny coordinate equality in a draft file.

Not safe:

- Change multiplication formulas.
- Change basis labels.
- Change Fano triples.
- Change signs.
- Reassociate octonion products.
- Port a formula from Baez or Furey directly.
- Add abstract algebraic structures without review.

## 16. Common Mistakes

Mistake:

```text
Assuming `x * y = y * x`.
```

Correction:

```text
Octonion multiplication is not commutative.
```

Mistake:

```text
Assuming `(x * y) * z = x * (y * z)`.
```

Correction:

```text
Octonion multiplication is not associative.
```

Mistake:

```text
Using Baez/Furey basis formulas directly.
```

Correction:

```text
Use `ConventionBridge` first.
```

Mistake:

```text
Using `ring` on an octonion-valued goal.
```

Correction:

```text
Use `ext`, expand coordinates, then use `ring`.
```

## 17. Practice Exercise 1: Basis Labels

Task:

1. Open `PhysicsSM/Algebra/Octonion/Basic.lean`.
2. Find the basis-label table in the module docstring.
3. Write the decimal index for each basis label.

Expected answer:

```text
e000 -> 0
e001 -> 1
...
e111 -> 7
```

## 18. Practice Exercise 2: Product Index

Task:

For each pair, compute the XOR product index only. Do not guess the sign.

```text
e001 * e010
e011 * e111
e101 * e110
```

Expected shape:

```text
001 XOR 010 = 011, so the product lands on e011.
```

## 19. Practice Exercise 3: Parentheses

Task:

Explain why these are not automatically equal:

```text
(x * y) * z
x * (y * z)
```

Expected answer:

```text
Octonion multiplication is nonassociative, so parentheses affect the value.
An explicit theorem is needed to rewrite between parenthesizations.
```

## 20. Practice Exercise 4: Theorem Translation

Find `moufang_left` in `Moufang.lean`.

Write:

1. the theorem name,
2. the variables,
3. the exact parenthesized identity,
4. a one-sentence plain-English explanation.

Do not edit the Lean file.

## 21. Practice Exercise 5: Proof Pattern

Find a proof that uses:

```lean
ext <;> simp <;> ring
```

Answer:

1. Which theorem uses it?
2. What does `ext` split?
3. Why is `ring` allowed at the end?

## Final Checklist

Before working on octonion code, confirm:

- I know the basis labels.
- I know `e000` is the unit.
- I know the product index uses XOR.
- I know the sign comes from the Fano orientation.
- I know octonion multiplication is not associative.
- I know octonion multiplication is not commutative.
- I know not to copy Baez/Furey formulas directly.
- I know `ring` is only safe after reducing to scalar coordinate goals.
- I know which file contains the theorem or definition I am touching.

## One-Sentence Rule

In octonion code, parentheses and signs are mathematics, not formatting.
