# Level 2: Lean Writing Basics

**Purpose.** This tutorial teaches you to write small, safe additions to Lean
files in the PhysicsSM project. After finishing it you will be able to add
docstrings, write simple definitions, prove trivial theorems with `rfl`, and
use the eight most important proof tactics on goals that are already set up
for you. You will also know when to stop and write a handoff note.

**Prerequisites.** Complete `Skills/01_LEAN_READING_BASICS.md`.

**Key vocabulary.** tactic, goal, hypothesis, `rfl`, `simp`, `ring`,
`norm_num`, `nlinarith`, `positivity`, `ext`, `rw`, `have`, docstring,
`@[simp]`.

**Safety rule.** Before writing any Lean code, run the file with
`lake env lean <file>` to see its current state. After any change, run it
again and compare. If the file goes from zero errors to errors, undo the
change.

---

## 1. Understanding tactic mode

When a Lean proof starts with `:= by`, you are in **tactic mode**. Lean shows
you a **proof state**: the current goal(s) you need to prove, and the local
hypotheses you can use.

Example: inside the proof of `conj_conj`:

```
Goal:
  x : Octonion
  ⊢ conj (conj x) = x
```

- Items above `⊢` are **hypotheses** (things you know).
- The thing after `⊢` is the **goal** (what you must prove).

Tactics transform the proof state. When all goals are closed, the proof is
complete. If tactics leave goals unclosed, Lean reports an error.

---

## 2. The eight most important tactics

### `rfl` — true by definition

Use when the goal is true because both sides are literally the same after
expanding definitions.

```lean
@[simp] theorem conj_c1 (x : Octonion) : (conj x).c1 = -x.c1 := rfl
```

`rfl` works here because `conj` is defined so that `(conj x).c1 = -x.c1`
is just reading off the definition. Nothing to compute.

**When it fails:** if the goal is not definitionally equal, even if it is
obviously true. Try `simp` instead.

---

### `simp` — simplify with known facts

`simp` applies a large collection of rewrite rules (lemmas marked `@[simp]`)
repeatedly until nothing more can be simplified.

```lean
theorem conj_zero : conj (0 : Octonion) = 0 := by
  ext <;> simp [conj]
```

After `ext` splits the goal into eight coordinate goals, `simp [conj]` applies
the `conj_c0`...`conj_c7` simp lemmas to simplify each coordinate to `0 = 0`,
which closes immediately.

**`simp [foo]`** — tell simp to also unfold the definition or theorem `foo`.
Use this when a definition is not already in the simp set.

**When to use:** simple equalities, closure goals that follow directly from
definitions, numeric simplifications.

**When not to use:**
- When the goal involves octonion multiplication but you have not yet expanded
  all coordinates. `ring` will not work and `simp` may loop or make things
  worse.
- When you are not sure which direction `simp` will rewrite things.

---

### `ring` — polynomial identities over commutative rings

`ring` closes goals that are polynomial equalities over a commutative ring,
once everything has been reduced to scalar (real number) arithmetic.

```lean
theorem normSq_mul (x y : Octonion) :
    normSq (x * y) = normSq x * normSq y := by
  simp only [normSq, Octonion.mul_c0, ..., Octonion.mul_c7]
  ring
```

After `simp only` expands the octonion multiplication and `normSq` into
their scalar components, the goal becomes a polynomial identity over `ℝ`.
`ring` then verifies it.

**Key rule: `ring` only works on commutative ring goals.**
Octonion multiplication is not commutative and not associative, so you cannot
use `ring` on an `Octonion`-valued goal. You must first use `simp only`
with the `mul_c0`...`mul_c7` lemmas to expand everything into real coordinates,
and only then apply `ring`.

```
WRONG:
  ring   -- goal is `(x * y) * z = x * (y * z)` with Octonion values

RIGHT:
  ext <;> simp only [Octonion.mul_c0, ...] <;> ring
  -- ext splits into 8 real goals; simp expands; ring finishes each one
```

---

### `norm_num` — numeric computations

`norm_num` proves goals that are concrete arithmetic facts.

```lean
theorem normSq_one : normSq (1 : Octonion) = 1 := by
  simp [normSq]
```

When `simp` leaves a goal like `(1 : ℝ)^2 + 0^2 + ... + 0^2 = 1`, `norm_num`
or `simp` with numeric rules will close it.

Use `norm_num` for:
- `1 + 1 = 2`
- `(1/2 : ℝ) > 0`
- `(3 : ℕ) ≠ 0`
- Arithmetic facts about specific number literals

---

### `nlinarith` — nonlinear real arithmetic

`nlinarith` proves goals involving nonlinear inequalities over ordered rings.

```lean
theorem normSq_eq_zero (x : Octonion) : normSq x = 0 ↔ x = 0 := by
  ...
  have h0 : x.c0 = 0 := by nlinarith [sq_nonneg x.c0, sq_nonneg x.c1, ...]
```

When you have hypotheses like `x.c0^2 + ... = 0` and `sq_nonneg x.c0`,
`nlinarith` can deduce that each square must be zero.

**Hint:** provide `nlinarith` with the relevant `sq_nonneg` lemmas as hints
using `nlinarith [sq_nonneg x.c0, sq_nonneg x.c1, ...]`.

---

### `positivity` — prove things are ≥ 0 or > 0

`positivity` closes goals of the form `0 ≤ something` when `something` is
clearly non-negative from its structure.

```lean
theorem normSq_nonneg (x : Octonion) : 0 ≤ normSq x := by
  unfold normSq
  positivity
```

After unfolding, `normSq x` is a sum of squares. `positivity` recognises that
a sum of squares is always non-negative.

---

### `ext` — prove equality by proving field equality

`ext` is used to prove two compound values (structures, functions) are equal
by proving all their components are equal.

For `Octonion`, which is defined with `@[ext]`, writing `ext` splits one
equality goal `a = b : Octonion` into eight goals:
- `a.c0 = b.c0`
- `a.c1 = b.c1`
- ...
- `a.c7 = b.c7`

```lean
theorem conj_conj (x : Octonion) : conj (conj x) = x := by
  ext <;> simp [conj]
```

After `ext`, there are eight goals. `<;> simp [conj]` applies `simp [conj]`
to all eight goals at once.

---

### `rw` — rewrite with a theorem

`rw [h]` takes a theorem `h : A = B` (or a local hypothesis) and replaces
every occurrence of `A` in the current goal with `B`.

```lean
theorem normSq_eq_mul_conj (x : Octonion) :
    normSq x • (1 : Octonion) = x * conj x :=
  (mul_conj x).symm
```

Here `(mul_conj x).symm` uses the theorem `mul_conj x : x * conj x = normSq x • 1`
in reverse (`.symm` swaps the equality). This is like a one-step `rw`.

---

### `have` — introduce a local intermediate result

Use `have` to break a proof into smaller steps.

```lean
theorem normSq_eq_zero (x : Octonion) : normSq x = 0 ↔ x = 0 := by
  unfold normSq
  constructor
  · intro h
    have sq_nn := sq_nonneg x.c0
    have h0 : x.c0 = 0 := by nlinarith [sq_nonneg x.c0, sq_nonneg x.c1, ...]
    ...
```

Each `have name : type := by tactic` creates a local hypothesis `name` of
type `type`. Later steps can use `name` just like any other hypothesis.

---

## 3. The `<;>` combinator

`tac1 <;> tac2` means: apply `tac1`, then apply `tac2` to **every** goal
created by `tac1`.

```lean
ext <;> simp [conj]
-- apply ext, then simp [conj] to all 8 coordinate goals
```

This is very common in this project. Without `<;>`, you would have to write
`simp [conj]` eight times.

---

## 4. Adding a docstring

A docstring goes directly before a definition or theorem and uses `/-  -/`:

```lean
/-- My theorem says something interesting about octonions. -/
theorem my_theorem (x : Octonion) : ... := by ...
```

Multi-line docstrings:

```lean
/--
This theorem proves X.

The proof works by expanding Y and then using ring.

Source: Baez (2002), Section 1.
-/
theorem my_theorem ...
```

**Rules for good docstrings in this project:**
- Explain **what** the theorem says in plain English.
- Name the **source** (paper, arXiv ID, chapter/equation).
- Name the **convention** if there is a sign or basis choice.
- Say **why** the proof is valid at a high level (e.g. "by coordinate expansion
  and ring").
- Do NOT claim physical interpretation without a source and semantic review.

---

## 5. Adding a simple definition

Safe to add when explicitly asked to do so by a stronger agent or task file:

```lean
/-- The real part of an octonion (the c0 coordinate). -/
def realPart (x : Octonion) : ℝ := x.c0
```

Components of the syntax:
- `def` — this is a new definition.
- `realPart` — the name (must be a new name, not already defined).
- `(x : Octonion)` — one input of type `Octonion`.
- `: ℝ` — output type is a real number.
- `:= x.c0` — the body (what it computes).

**Before adding any definition:** search with `rg realPart` or `grep -r
realPart PhysicsSM/` to confirm the name does not already exist.

---

## 6. Adding a simple theorem

The safest theorems to add are **coordinate projection lemmas** — theorems
that just read off a specific coordinate of a definition:

```lean
@[simp] theorem realPart_c0 (x : Octonion) : realPart x = x.c0 := rfl
```

Or component lemmas for a new operation:

```lean
@[simp] theorem myOp_c2 (x y : Octonion) : (myOp x y).c2 = x.c2 + y.c2 := rfl
```

These proofs are always `rfl` (true by the definition of `myOp`).

---

## 7. When `ring` is and is not valid

**Valid:** the goal is an equation over `ℝ` (or any commutative ring/field)
and every occurrence of octonion multiplication has been expanded into scalar
operations.

```lean
-- After: simp only [Octonion.mul_c0, ...]
-- Goal becomes something like:
-- x.c0 * y.c0 - x.c1 * y.c1 - ... = (x.c0^2 + ...) * (y.c0^2 + ...)
ring  -- valid: goal is now purely over ℝ
```

**Not valid:** the goal still contains `Octonion`-typed subexpressions.

```lean
-- Goal: x * (y * z) = (x * y) * z  (Octonion multiplication)
ring  -- WRONG: ring does not know about nonassociative octonion products
```

The error will say something like "ring failed, goal is not a comm semiring
expression". The fix is to use `ext <;> simp only [mul_c0, ...] <;> ring`.

---

## 8. Adding a comment in Lean

Use `--` for single-line comments:

```lean
-- This is a comment. Lean ignores it.
def foo : ℝ := 1.0  -- inline comment
```

Use `/-` and `-/` for block comments:

```lean
/- This is a block comment.
   It can span multiple lines.
-/
```

Use `/-! ... -/` only for module docstrings (at the top of a file). Do not
use `/-! ... -/` inside a namespace or theorem.

---

## 9. Adding a component simp lemma to an existing definition

This is a common low-end task. Suppose a new definition `myThing` is in the
file but is missing the `@[simp]` lemma for coordinate `c3`. The pattern is:

```lean
@[simp] theorem myThing_c3 (x y : Octonion) : (myThing x y).c3 = <expression> := rfl
```

Steps:
1. Look at how `myThing` is defined and find what it does to `c3`.
2. Write the theorem. The proof is always `rfl` for coordinate projections of
   explicit definitions.
3. Run `lake env lean <file>` and confirm zero errors.

---

## 10. Safe proof patterns — cheat sheet

```lean
-- Prove two octonions are equal by coordinates (most common pattern)
theorem foo (x : Octonion) : f x = g x := by
  ext <;> simp [f, g]

-- Prove a real-valued identity after expansion
theorem bar (x y : Octonion) : someReal x y = otherReal x y := by
  simp only [someReal, otherReal, Octonion.mul_c0, ..., Octonion.mul_c7]
  ring

-- Prove a nonnegativity statement
theorem baz (x : Octonion) : 0 ≤ someNonnegThing x := by
  unfold someNonnegThing
  positivity

-- Prove something is zero iff x is zero, via coordinate witnesses
theorem qux (x : Octonion) : f x = 0 ↔ x = 0 := by
  constructor
  · intro h
    have h0 : x.c0 = 0 := by nlinarith [sq_nonneg x.c0, ...]
    ...
    ext <;> assumption
  · rintro rfl; simp
```

---

## Safe tasks for this level

- Add a docstring to a theorem that currently has none (in a draft file).
- Add a missing `@[simp]` coordinate lemma for a definition, if asked by a
  task file.
- Prove a `rfl` lemma for a coordinate projection.
- Write a one-sentence comment explaining why `ext` is used in a proof.
- Run `lake env lean` before and after any change and report both outputs.

## Unsafe tasks for this level

- Do not add theorems that require mathematical insight about octonion algebra.
- Do not add theorems about the physics meaning of any state.
- Do not edit existing proofs that already pass.
- Do not add new `def` without explicit instruction from a stronger agent.
- Do not use `sorry` in a trusted file (one whose module docstring says
  "trusted").
- Do not decide sign conventions.

---

## Handoff note template

If a proof does not close and you do not know why, write this and stop:

```
Handoff:
- Target file: PhysicsSM/Algebra/Octonion/Conjugation.lean
- Target declaration: my_new_theorem
- Intended statement: [copy the Lean statement here]
- Current Lean error: [paste the exact error]
- What I tried: [list tactics tried]
- Why I stopped: [e.g. ring failed, goal still has Octonion types]
- Suspected issue: [e.g. need to expand multiplication first]
- Recommended next step: use ext <;> simp only [mul_c0, ...] <;> ring
```

---

## Practice exercises

1. In a scratch file (not a project file), write:
   ```lean
   def myReal (x : Octonion) : ℝ := x.c0 + x.c1
   @[simp] theorem myReal_rfl (x : Octonion) : myReal x = x.c0 + x.c1 := rfl
   ```
   Explain why the proof is `rfl`.

2. Look at `conj_add` in `Conjugation.lean`. The proof is
   `ext <;> simp [conj] <;> ring`. Explain step by step what each tactic does.

3. Look at `normSq_mul` in `Norm.lean`. Why is `ring` valid there after the
   `simp only` step? Why would `ring` fail if you removed the `simp only` step?

4. Find a theorem in `Basic.lean` that is proved by `rfl`. Copy its statement
   and explain in one sentence why `rfl` is enough.

5. Find one theorem in the project proved by `positivity`. What does the goal
   look like after `unfold`? Why can `positivity` close it?

---

## Checklist before moving to Level 3

- [ ] I know what `rfl`, `simp`, `ring`, `norm_num`, `nlinarith`, `positivity`,
  `ext`, and `rw` each do.
- [ ] I know the difference between `simp` (unfold and rewrite) and `ring`
  (polynomial identity verifier).
- [ ] I know that `ring` only works on commutative ring goals — never on raw
  `Octonion` goals.
- [ ] I know `<;>` applies a tactic to all remaining goals.
- [ ] I can write a `@[simp]` coordinate lemma with a `rfl` proof.
- [ ] I know what a docstring looks like and the three things it must say.
- [ ] I run `lake env lean` before and after any edit and report both outputs.
- [ ] I know when to stop and write a handoff note.
