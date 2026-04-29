# Level 4: Mathematical Language Primer

**Purpose.** This tutorial teaches the basic mathematical language needed to
read PhysicsSM task files and Lean theorem statements. It is written for agents
that may not know algebra, linear algebra, or formal proof vocabulary yet.

**Prerequisites.** Read these first:

- `Skills/00_REPOSITORY_SURVIVAL.md`
- `Skills/01_LEAN_READING_BASICS.md`
- `Skills/02_LEAN_WRITING_BASICS.md`

**Key vocabulary.** object, type, variable, function, equality, proposition,
hypothesis, conclusion, implication, iff, forall, exists, set, predicate,
structure, operation, closure, identity, inverse, associativity,
commutativity, distributivity, ring, field, module, vector space, scalar,
linear combination, span, basis, linear independence, coordinate.

**Safety rule.** If you cannot state a theorem in plain English, do not edit
its Lean proof. If a theorem involves conventions, signs, basis order, scalar
field, or physics interpretation, stop and ask for stronger review.

---

## 1. Why This Primer Exists

Low-end agents often fail because they treat mathematical words as decorative
text. In this repository, the words matter.

Examples:

- "Associative" is not the same as "commutative".
- "Linear over `C`" is not the same as "linear over `R`".
- "For all" is not the same as "there exists".
- "A product is parenthesized this way" is not optional for octonions.
- "The Lean proof passes" is not the same as "the physics interpretation is
  correct".

Your first job is to identify what kind of statement you are reading. Is it a
coordinate computation? A structural theorem? A source convention? A physics
interpretation? Different kinds of statements have different risk levels.

## 2. Objects, Types, And Variables

An **object** is a thing being discussed.

Examples:

- a real number,
- an octonion,
- a complexified octonion,
- a matrix,
- a theorem,
- a function.

A **type** is a collection or category of objects.

Lean writes:

```lean
x : Octonion
```

Read this as:

```text
x is an object of type Octonion.
```

Other examples:

```lean
r : Real
x : Octonion
f : Octonion -> Octonion
```

Plain English:

- `r` is a real number.
- `x` is an octonion.
- `f` is a function from octonions to octonions.

In actual project files, real numbers are often written with Lean's real-number
notation. This tutorial uses ASCII explanations where possible.

### Variables Are Arbitrary Unless Restricted

In a theorem:

```lean
theorem conj_conj (x : Octonion) : conj (conj x) = x := by
  ...
```

`x` is arbitrary. The theorem is not about one special octonion. It says the
statement holds for every octonion `x`.

When you see a variable in parentheses before the colon, read it as "for any".

## 3. Functions

A **function** takes an input and returns an output.

In Lean:

```lean
def conj (x : Octonion) : Octonion := ...
```

Plain English:

```text
conj is a function that takes an octonion x and returns an octonion.
```

Another example:

```lean
def normSq (x : Octonion) : Real := ...
```

Plain English:

```text
normSq is a function that takes an octonion and returns a real number.
```

### Function Application

Lean usually writes function application without parentheses around the input:

```lean
conj x
normSq x
```

Read as:

```text
conj applied to x
normSq applied to x
```

Nested application:

```lean
conj (conj x)
```

Plain English:

```text
conjugate x, then conjugate the result.
```

## 4. Equality

An equality says two expressions are the same.

Example:

```lean
conj (conj x) = x
```

Plain English:

```text
Conjugating x twice gives x back.
```

Equality is exact in Lean. It is not "morally the same", "approximately the
same", or "equal up to convention". If conventions differ, you need an explicit
conversion theorem.

### Definitional Equality Vs Theorem Equality

Some equalities are true by definition. Lean can prove these with `rfl`.

Other equalities require proof. Lean may need tactics such as `simp`, `ring`,
or `nlinarith`.

Example:

```lean
(conj x).c1 = -x.c1
```

This is true directly from the definition of `conj`.

Example:

```lean
normSq (x * y) = normSq x * normSq y
```

This is a real theorem. It requires expanding multiplication and proving a
large polynomial identity.

## 5. Propositions, Hypotheses, And Conclusions

A **proposition** is a statement that can be true or false.

Examples:

```text
x = 0
normSq x = 0
0 <= normSq x
conj (conj x) = x
```

A **theorem** proves a proposition.

A **hypothesis** is an assumption you are allowed to use.

A **conclusion** is what you must prove.

Example:

```lean
theorem example (h : x = 0) : normSq x = 0 := by
  ...
```

Plain English:

```text
Assume h says x is zero. Prove that normSq x is zero.
```

Here:

- `h : x = 0` is a hypothesis.
- `normSq x = 0` is the conclusion.

## 6. For All

"For all" means a statement holds for every object of a type.

Lean often represents this by putting variables before the colon:

```lean
theorem conj_conj (x : Octonion) : conj (conj x) = x := by
  ...
```

Plain English:

```text
For every octonion x, conj (conj x) equals x.
```

More variables:

```lean
theorem normSq_mul (x y : Octonion) :
    normSq (x * y) = normSq x * normSq y := by
  ...
```

Plain English:

```text
For every pair of octonions x and y, the squared norm of x * y equals the
squared norm of x times the squared norm of y.
```

## 7. There Exists

"There exists" means at least one object with a property exists.

Plain-English examples:

```text
There exists an octonion x such that x is nonzero.
There exists a basis for this vector space.
There exists a scalar c such that v = c * w.
```

Existence statements are often harder than universal statements because you
must either:

- construct the object, or
- use an existing theorem that guarantees it.

Low-end agents should not invent existence proofs unless the witness is
obvious and local.

Safe example:

```text
To prove there exists an octonion, use 0 or 1 if the statement allows it.
```

Unsafe example:

```text
There exists an isomorphism between two sophisticated structures.
```

Escalate that.

## 8. Implication

An **implication** has the form:

```text
if P, then Q
```

Lean often writes implication with `->`.

Plain-English example:

```text
If x = 0, then normSq x = 0.
```

In a proof, assuming the "if" part gives you a hypothesis. You then prove the
"then" part.

Important: an implication does not say that `P` is true. It says that if `P`
is true, then `Q` follows.

## 9. Iff

"Iff" means "if and only if". It is a two-way statement:

```text
P iff Q
```

means:

```text
if P then Q, and if Q then P.
```

Project example:

```lean
theorem normSq_eq_zero (x : Octonion) : normSq x = 0 <-> x = 0 := by
  ...
```

Plain English:

```text
The squared norm of x is zero exactly when x itself is zero.
```

To prove an iff statement, you usually prove two directions:

1. Assume the left side and prove the right side.
2. Assume the right side and prove the left side.

Low-end warning: do not use only one direction when the theorem requires both.

## 10. And, Or, Not

Mathematics combines propositions.

### And

```text
P and Q
```

means both `P` and `Q` are true.

Example:

```text
x is nonzero and normSq x is positive.
```

### Or

```text
P or Q
```

means at least one of `P` or `Q` is true.

Example:

```text
x = 0 or x is nonzero.
```

### Not

```text
not P
```

means `P` is false.

Example:

```text
x is not zero.
```

Lean may write this as `x != 0` or as a negated proposition depending on the
context.

## 11. Sets And Predicates

A **set** is a collection of objects.

A **predicate** is a property of objects.

Example predicate:

```text
isZero x means x = 0.
```

Example set:

```text
the set of all octonions x such that normSq x = 1.
```

Membership means an object is in a set.

Plain English:

```text
x belongs to S.
x is an element of S.
x satisfies the property defining S.
```

Subsets:

```text
A is a subset of B
```

means:

```text
Every element of A is also an element of B.
```

Low-end warning: proving two sets are equal usually requires proving two subset
directions. Do not assume matching names mean equal sets.

## 12. Structures

A **structure** packages several pieces of data together.

In this project, `Octonion` is a structure with eight real coordinates:

```text
c0, c1, c2, c3, c4, c5, c6, c7
```

The coordinate `c0` is the scalar part. The other coordinates are imaginary
parts.

When Lean proves two structures are equal, it often proves their fields are
equal one by one. This is what `ext` does.

Example pattern:

```lean
ext <;> simp
```

Plain English:

```text
To prove two octonions are equal, prove all eight coordinates are equal.
```

## 13. Operations

An **operation** combines objects.

Examples:

- addition: `x + y`,
- multiplication: `x * y`,
- scalar multiplication: scalar `r` acting on vector `x`,
- negation: `-x`,
- conjugation: `conj x`.

Operations have types. For example:

```text
Octonion multiplication takes two octonions and returns an octonion.
normSq takes one octonion and returns a real number.
```

Always check the type. Many errors come from treating a real number as an
octonion, or treating an octonion as a scalar.

## 14. Closure

A set is **closed** under an operation if applying the operation to elements of
the set stays in the set.

Example:

```text
The real numbers are closed under addition.
```

means:

```text
If a and b are real numbers, then a + b is a real number.
```

In type-theoretic Lean, closure is often built into the type of the operation.
If `x y : Octonion`, then `x * y : Octonion`.

But for subsets and submodules, closure becomes a theorem or field you must
prove.

## 15. Identity

An **identity element** is an element that does nothing for an operation.

For addition:

```text
0 + x = x
x + 0 = x
```

For multiplication:

```text
1 * x = x
x * 1 = x
```

In the project octonions, `e000` is the multiplicative unit.

Low-end warning: identity laws are not the same as associativity.

## 16. Inverse

An **inverse** undoes an operation.

For addition, `-x` is the additive inverse:

```text
x + (-x) = 0
```

For multiplication, an inverse of nonzero `x` would satisfy:

```text
x * x_inv = 1
x_inv * x = 1
```

In noncommutative or nonassociative algebra, left inverses and right inverses
may need separate statements.

Do not assume inverse facts unless a theorem provides them.

## 17. Associativity

An operation is **associative** if parentheses do not matter:

```text
(x * y) * z = x * (y * z)
```

Critical project rule:

```text
Octonion multiplication is not associative.
```

Therefore, do not rewrite:

```lean
(x * y) * z
```

as:

```lean
x * (y * z)
```

unless an explicit theorem allows that exact rewrite.

This is one of the most important safety rules in the entire project.

## 18. Commutativity

An operation is **commutative** if order does not matter:

```text
x + y = y + x
```

Addition is usually commutative in this project.

Multiplication may not be commutative:

```text
x * y may differ from y * x.
```

Octonion multiplication is not commutative.

Do not swap multiplication order unless a theorem says you can.

## 19. Distributivity

Multiplication distributes over addition if:

```text
x * (y + z) = x * y + x * z
(x + y) * z = x * z + y * z
```

There are two versions:

- left distributivity,
- right distributivity.

In noncommutative algebra, left and right versions must be handled carefully.

## 20. Rings

A **ring** is a structure with addition, multiplication, zero, one, negatives,
and distributive laws.

Examples:

- integers,
- real numbers,
- many matrix algebras.

Important warning:

The Lean tactic `ring` proves polynomial identities in commutative rings or
semirings after the goal has been reduced to scalar arithmetic. It does not
magically prove octonion identities.

Safe octonion pattern:

```lean
ext <;>
  simp only [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
    Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
    Octonion.mul_c6, Octonion.mul_c7] <;>
  ring
```

Plain English:

```text
Split an octonion equality into coordinate equalities, expand multiplication
into real-number formulas, then use ring on real polynomial goals.
```

## 21. Fields

A **field** is a number system where you can add, subtract, multiply, and divide
by nonzero elements.

Examples:

- rational numbers,
- real numbers,
- complex numbers.

This project commonly uses:

- real scalars for octonions,
- complex scalars for complexified octonion and Furey constructions.

Low-end warning: do not switch scalar fields. A theorem over real numbers is
not automatically a theorem over complex numbers.

## 22. Modules And Vector Spaces

A **vector space** is a type of vectors with addition and scalar multiplication
by a field.

A **module** is a similar idea where scalars may come from a more general ring.

In Lean/mathlib, many vector-space-like things are expressed with `Module`.

Plain-English examples:

```text
Octonions are an 8-dimensional real vector space.
Complexified octonions are an 8-dimensional complex vector space, or a
16-dimensional real vector space, depending on how scalars are chosen.
```

The scalar field matters.

If a theorem says:

```text
linearly independent over C
```

do not restate it as:

```text
linearly independent over R
```

Those are different statements.

## 23. Linear Combination

A **linear combination** is a sum of scalar multiples of vectors.

Example:

```text
a1 * v1 + a2 * v2 + a3 * v3
```

Here:

- `a1`, `a2`, `a3` are scalars,
- `v1`, `v2`, `v3` are vectors.

In Lean, linear combinations often involve finite sums indexed by `Fin n`.

Low-end warning: finite sums have tricky notation and typeclass requirements.
Escalate if you are not already given a local proof pattern.

## 24. Span

The **span** of some vectors is the set of all linear combinations of those
vectors.

Plain English:

```text
span {v1, v2, v3}
```

means:

```text
all vectors of the form a1 * v1 + a2 * v2 + a3 * v3.
```

If a vector is in the span, it can be built from the listed vectors using
scalars and addition.

Project relevance:

The Furey minimal ideal should eventually be packaged as a linear object. That
means we must carefully define which vectors span it and over which scalar
field.

## 25. Linear Independence

A list of vectors is **linearly independent** if the only linear combination
that gives zero is the trivial one, where every scalar coefficient is zero.

Plain English:

```text
v1, v2, v3 are linearly independent
```

means:

```text
If a1 * v1 + a2 * v2 + a3 * v3 = 0, then a1 = 0, a2 = 0, and a3 = 0.
```

Project example:

```lean
theorem basis_linear_independent :
    LinearIndependent Complex (fun i : Fin 8 => ...)
```

Plain English:

```text
The eight listed Furey states are linearly independent over the complex
numbers.
```

Low-end warning: do not prove linear independence by saying the vectors "look
different". You need a formal coordinate or abstract proof.

## 26. Basis

A **basis** is a collection of vectors that is both:

1. linearly independent,
2. spanning.

Plain English:

```text
A basis gives unique coordinates for every vector in the space.
```

If a theorem proves linear independence only, it does not automatically prove
the vectors are a basis. You also need spanning.

Low-end warning: do not call something a basis unless both parts are proved or
the Lean declaration actually constructs a `Basis`.

## 27. Coordinates And Matrices

Coordinates describe a vector by numbers relative to a basis.

For project octonions:

```text
x = c0 e000 + c1 e001 + ... + c7 e111
```

The coordinates are:

```text
c0, c1, c2, c3, c4, c5, c6, c7
```

Matrices are often coordinate bookkeeping. A linear map can be represented by
a matrix once bases are chosen.

Low-end safe task:

```text
Read a coordinate table and explain which coordinate is nonzero.
```

Low-end unsafe task:

```text
Decide that a matrix represents the correct physics transformation without
checking conventions.
```

## 28. Important Translation Table

Use this table to translate ordinary mathematical English into Lean-shaped
thinking. This is not a full Lean syntax reference.

| Math phrase | Lean-shaped reading |
|-------------|---------------------|
| for all x | a variable before the theorem colon, such as `(x : A)` |
| there exists x | an existential statement with a witness |
| if P then Q | an implication, often written with `->` |
| P iff Q | two implications, one in each direction |
| x is in S | a membership statement |
| A is a subset of B | every element of A is also an element of B |
| f maps x to y | `f x = y` |
| x is zero | `x = 0` |
| x is nonzero | `x != 0` or a negated equality |
| vectors are linearly independent | `LinearIndependent K v` |
| vectors span a space | a span or submodule statement |
| x and y commute | `x * y = y * x` |
| multiplication is associative | `(x * y) * z = x * (y * z)` |

## 29. How To Classify A Theorem

Before editing a theorem, classify it.

### Coordinate computation

Example:

```lean
theorem conj_conj (x : Octonion) : conj (conj x) = x := by
  ext <;> simp [conj]
```

Risk: low, if the statement is already correct.

Typical proof tools:

- `rfl`,
- `ext`,
- `simp`,
- `norm_num`,
- `ring`.

### Algebraic structure theorem

Example:

```text
The octonions form a composition algebra.
```

Risk: medium to high.

This may require packaging many coordinate facts into an abstract interface.

### Convention theorem

Example:

```text
Baez basis element e7 corresponds to project basis element e111.
```

Risk: high.

Requires source checking and convention bridge review.

### Physics interpretation

Example:

```text
This state is a neutrino.
```

Risk: high.

Lean may prove the algebraic state has certain coordinates or charge values,
but the physical naming still needs semantic review.

## 30. Project Examples

### `conj_conj`

Statement:

```lean
theorem conj_conj (x : Octonion) : conj (conj x) = x
```

Plain English:

```text
For every octonion x, conjugating twice returns x.
```

Classification:

```text
Coordinate computation.
```

### `normSq_nonneg`

Statement:

```lean
theorem normSq_nonneg (x : Octonion) : 0 <= normSq x
```

Plain English:

```text
For every octonion x, the squared norm of x is nonnegative.
```

Classification:

```text
Scalar arithmetic theorem.
```

### `normSq_eq_zero`

Statement:

```lean
theorem normSq_eq_zero (x : Octonion) : normSq x = 0 <-> x = 0
```

Plain English:

```text
The squared norm of x is zero exactly when x is the zero octonion.
```

Classification:

```text
Iff statement with two directions.
```

### `normSq_mul`

Statement:

```lean
theorem normSq_mul (x y : Octonion) :
    normSq (x * y) = normSq x * normSq y
```

Plain English:

```text
The squared norm of a product is the product of the squared norms.
```

Classification:

```text
Coordinate polynomial identity after expanding octonion multiplication.
```

### `moufang_left`

Statement:

```lean
theorem moufang_left (x y z : Octonion) :
    (x * y) * (z * x) = x * ((y * z) * x)
```

Plain English:

```text
For all octonions x, y, and z, this exact parenthesized product identity holds.
```

Classification:

```text
Nonassociative algebra identity.
```

Safety note:

```text
The parentheses are part of the theorem.
```

## 31. Common Misreadings

### Misreading 1: "The names are similar, so the theorems are the same."

Wrong.

Example:

```text
mul_conj
conj_mul
conj_mul_self
```

These names are similar but may have different statements. Always read the
actual theorem statement.

### Misreading 2: "The proof passed, so the physics is correct."

Wrong.

Lean checks formal statements. It does not know whether `v1` should be called a
particle, antiparticle, neutrino, or electron. That interpretation requires
source and convention review.

### Misreading 3: "I can use ring on octonions."

Wrong.

Use `ring` only after reducing to scalar coordinate goals.

### Misreading 4: "A linearly independent list is automatically a basis."

Wrong.

A basis also needs spanning.

### Misreading 5: "The real and complex versions are interchangeable."

Wrong.

Changing scalar fields changes the theorem.

## 32. Safe Work For Low-End Agents

Safe tasks:

- Translate theorem statements into plain English.
- Identify variables, hypotheses, and conclusions.
- Classify the theorem type.
- Find whether a theorem is about coordinates, structure, convention, or
  physics interpretation.
- Add glossary entries.
- Add comments explaining existing theorem statements.
- Create task files that say what must be proved.

Usually safe with review:

- Add simple coordinate comments.
- Add a small example in a draft file.
- Prove a projection lemma by `rfl`.
- Prove a coordinate equality by `ext <;> simp`.

Not safe:

- Change theorem statements.
- Choose conventions.
- Introduce new structures.
- Package a basis without review.
- Translate paper formulas into trusted Lean.
- Interpret algebraic states as physical particles without source review.

## 33. Reading A Task File

When reading an `AgentTasks/` file, extract:

1. Target file.
2. Mathematical object.
3. Scalar field.
4. Variables.
5. Exact theorem statement.
6. Source.
7. Convention.
8. Whether `sorry` is allowed.
9. Verification command.

Example checklist:

```text
Target file:
Object:
Scalar field:
Statement in plain English:
Statement in Lean:
Source:
Convention:
Allowed proof style:
Verification command:
Escalation concerns:
```

## 34. Practice Exercise 1: Identify Variables

Read this statement:

```lean
theorem normSq_mul (x y : Octonion) :
    normSq (x * y) = normSq x * normSq y
```

Answer:

1. What are the variables?
2. What type do they have?
3. What is the conclusion?
4. Is this a statement about one octonion or all octonions?

Expected answer:

```text
Variables: x and y.
Type: both are Octonion.
Conclusion: normSq (x * y) equals normSq x times normSq y.
Scope: all octonions x and y.
```

## 35. Practice Exercise 2: Identify Iff Directions

Read this statement:

```lean
theorem normSq_eq_zero (x : Octonion) : normSq x = 0 <-> x = 0
```

Write the two directions in plain English.

Expected answer:

```text
Direction 1: If normSq x = 0, then x = 0.
Direction 2: If x = 0, then normSq x = 0.
```

## 36. Practice Exercise 3: Parentheses Matter

Compare:

```text
(x * y) * z
x * (y * z)
```

Answer:

1. Are these automatically equal for octonions?
2. What theorem would you need to rewrite one into the other?
3. Why is this risky?

Expected answer:

```text
They are not automatically equal for octonions. Octonion multiplication is not
associative. A specific theorem, with the exact needed parenthesization, would
be required. It is risky because changing parentheses can change the value.
```

## 37. Practice Exercise 4: Classify A Statement

Classify each statement as coordinate computation, structural theorem,
convention theorem, or physics interpretation.

```text
1. conj (conj x) = x
2. normSq (x * y) = normSq x * normSq y
3. Baez e7 maps to project e111
4. This state is a neutrino
5. The eight Furey states are linearly independent over C
```

Suggested answers:

```text
1. Coordinate computation.
2. Coordinate polynomial identity, later useful as structural theorem.
3. Convention theorem.
4. Physics interpretation.
5. Linear algebra theorem.
```

## 38. Practice Exercise 5: Write A Plain-English Translation

Find one theorem in:

```text
PhysicsSM/Algebra/Octonion/Moufang.lean
```

Write:

1. The theorem name.
2. The variables.
3. The conclusion.
4. Why the parentheses matter.

Do not edit the Lean file.

## Final Checklist

Before touching a math-heavy task, confirm:

- I can name the objects involved.
- I can name the scalar field.
- I can identify variables, hypotheses, and conclusion.
- I can tell whether the statement is universal, existential, implication, or
  iff.
- I know whether the task is coordinate computation, structural packaging,
  convention translation, or physics interpretation.
- I know whether octonion associativity or commutativity would be unsafe.
- I know when to stop and ask for review.

## One-Sentence Rule

If you cannot translate the theorem into plain English, do not try to prove it.
