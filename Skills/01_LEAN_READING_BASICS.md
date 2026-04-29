# Level 1: Lean Reading Basics

**Purpose.** This tutorial teaches you to read Lean 4 source files in the
PhysicsSM project. After finishing it you will be able to find definitions,
understand theorem statements, identify imports and namespaces, and translate
Lean syntax into plain English — without writing or editing any code.

**Prerequisites.** Read `Skills/00_REPOSITORY_SURVIVAL.md` first so you can
locate and open files.

**Key vocabulary.** `import`, `namespace`, `def`, `theorem`, `structure`,
`:`, `:=`, `by`, type, term, tactic, universe, `ℝ`, `→`.

---

## 1. What is in a Lean file?

A Lean 4 source file (`.lean`) always has the same broad structure:

```
1.  Imports
2.  Module docstring (optional, looks like /--  -/)
3.  Namespace opening
4.  Definitions, instances, and theorems
5.  Namespace closing
```

Open `PhysicsSM/Algebra/Octonion/Conjugation.lean` and read the top.
You will see:

```lean
import PhysicsSM.Algebra.Octonion.Basic

/-!
# Algebra.Octonion.Conjugation
...
-/

namespace PhysicsSM.Algebra.Octonion
```

**Imports** tell Lean which other files to load before this one. If a name is
not defined in the current file and its import is missing, you get an "unknown
identifier" error.

**The module docstring** (between `/-!` and `-/`) is documentation for humans.
It is ignored by the Lean kernel. Read it to learn the purpose of the file.

**Namespaces** are hierarchical name prefixes. Inside
`namespace PhysicsSM.Algebra.Octonion`, a theorem named `conj_conj` gets the
full qualified name `PhysicsSM.Algebra.Octonion.conj_conj`. Other files can
refer to it by that full name, or use `open PhysicsSM.Algebra.Octonion` to
use the short name.

---

## 2. Reading a definition

Here is the definition of conjugation from `Conjugation.lean`:

```lean
def conj (x : Octonion) : Octonion :=
  { c0 := x.c0
    c1 := -x.c1
    c2 := -x.c2
    ...
    c7 := -x.c7 }
```

Read this as:

> **`def`** says we are defining something new.
> **`conj`** is the name we are giving it.
> **`(x : Octonion)`** says the definition takes one input called `x`, which
> must be an `Octonion`.
> **`: Octonion`** (after the closing parenthesis) says the output type is also
> `Octonion`.
> **`:=`** means "is defined as".
> **`{ c0 := x.c0, c1 := -x.c1, ... }`** is the body: an `Octonion` record
> where the scalar part `c0` is unchanged and the seven imaginary parts
> `c1`–`c7` are negated.

**Plain English:** `conj` takes an octonion and gives back an octonion where
the scalar part is the same but all imaginary coordinates have their signs
flipped.

### The colon rule

In Lean, `:` always means "has type". Read it as "is a" or "has type":

- `x : Octonion` → "`x` is an octonion"
- `conj : Octonion → Octonion` → "`conj` is a function from Octonion to Octonion"
- `normSq : Octonion → ℝ` → "`normSq` is a function from Octonion to real numbers"
- `r : ℝ` → "`r` is a real number"

### Field access with a dot

If `x : Octonion`, then `x.c0` means "the field named `c0` inside `x`". The
`Octonion` structure has eight fields: `c0, c1, ..., c7`, each of type `ℝ`.
`c0` is the scalar (real) part; `c1` through `c7` are the imaginary parts.

---

## 3. Reading a theorem statement

Here is the involution theorem from `Conjugation.lean`:

```lean
theorem conj_conj (x : Octonion) : conj (conj x) = x := by
  ext <;> simp [conj]
```

Break it apart piece by piece:

| Piece | Meaning |
|-------|---------|
| `theorem` | This is a mathematical theorem (will be checked by the kernel). |
| `conj_conj` | The theorem's name. |
| `(x : Octonion)` | For any octonion `x` (a universally quantified variable). |
| `:` | Here comes the proposition to prove. |
| `conj (conj x) = x` | The proposition: applying conjugation twice gives back the original. |
| `:= by` | The proof starts. `by` enters tactic mode. |
| `ext <;> simp [conj]` | The proof steps (explained in Level 2). |

**Plain English:** "For any octonion `x`, if you apply conjugation twice you
get `x` back." This is the involution property.

### More examples from the project

```lean
theorem conj_add (x y : Octonion) : conj (x + y) = conj x + conj y
```
Plain English: "Conjugation of a sum equals the sum of the conjugations." Two
inputs, `x` and `y`, both octonions.

```lean
theorem conj_smul (r : ℝ) (x : Octonion) : conj (r • x) = r • conj x
```
Plain English: "Scalar multiplication and conjugation commute." Two inputs:
`r` is a real number, `x` is an octonion. `r • x` means "scalar `r` times
octonion `x`".

```lean
theorem normSq_mul (x y : Octonion) : normSq (x * y) = normSq x * normSq y
```
Plain English: "The squared norm is multiplicative. The squared norm of the
product equals the product of the squared norms." This is the key theorem that
makes octonions a normed division algebra.

---

## 4. Reading an `@[simp]` theorem

```lean
@[simp] theorem conj_c1 (x : Octonion) : (conj x).c1 = -x.c1 := rfl
```

The `@[simp]` annotation means Lean's `simp` tactic is allowed to use this
theorem automatically as a rewrite rule (left-to-right). This one says:
"the `c1` field of `conj x` equals the negative of the `c1` field of `x`."

The proof is `rfl`, which means "true by definition" — you do not need to do
anything because Lean can see this directly from how `conj` is defined.

---

## 5. Reading `iff` and `→`

```lean
theorem normSq_eq_zero (x : Octonion) : normSq x = 0 ↔ x = 0
```

`↔` means "if and only if". The proposition `normSq x = 0 ↔ x = 0` says the
squared norm is zero if and only if the octonion itself is zero.

```lean
theorem some_theorem (h : normSq x = 0) : x = 0
```

`h : normSq x = 0` inside parentheses is a **hypothesis** — an assumption
that the caller must provide. Read it as "assuming `normSq x = 0`, prove
`x = 0`."

---

## 6. Reading structures

The `Octonion` type is defined in `Basic.lean` as a **structure**:

```lean
@[ext]
structure Octonion where
  c0 : ℝ
  c1 : ℝ
  c2 : ℝ
  c3 : ℝ
  c4 : ℝ
  c5 : ℝ
  c6 : ℝ
  c7 : ℝ
  deriving Inhabited
```

A `structure` is a record type — a bundle of named fields. Each field is a
real number (`ℝ`). The `@[ext]` annotation allows the `ext` tactic to prove
two octonions are equal by proving all their coordinates are equal.
`deriving Inhabited` tells Lean there is a default value (all zeros).

---

## 7. Reading module docstrings

Each file starts with a `/-! ... -/` block. Read it carefully before
anything else. It tells you:

- **What the file defines** (the definitions).
- **What source it follows** (paper, book, or arXiv reference).
- **What convention it uses** (sign choices, basis order).
- **What is trusted vs draft** (whether `sorry` is expected).
- **What files come before and after** in the dependency chain.

Example from `Norm.lean`:

```
Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), Section 1.
Convention: positive-definite Euclidean norm in the XOR basis ...
Status: trusted. The file contains no `sorry`; ...
```

If a file says "trusted" and "no sorry", it has been kernel-checked. If it
says "stub" or "draft", the theorems may be incomplete.

---

## 8. Reading imports

At the top of `Norm.lean`:

```lean
import PhysicsSM.Algebra.Octonion.Conjugation
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
```

- `PhysicsSM.Algebra.Octonion.Conjugation` is our own file. The dot-separated
  name corresponds to the file path `PhysicsSM/Algebra/Octonion/Conjugation.lean`.
- `Mathlib.Tactic.Linarith` and `Mathlib.Tactic.Positivity` are from the
  mathlib library (not our files).

**If a name is used in a file but its import is missing, Lean reports
"unknown identifier" or "function expected". The fix is to add the import.**

---

## 9. Reading namespaces

```lean
namespace PhysicsSM.Algebra.Octonion

def conj ...
theorem conj_conj ...

end PhysicsSM.Algebra.Octonion
```

Everything between `namespace` and `end` lives inside that namespace. The
full qualified name of `conj_conj` is
`PhysicsSM.Algebra.Octonion.conj_conj`.

In another file, you can write either:

```lean
open PhysicsSM.Algebra.Octonion in
-- now use `conj_conj` directly
```

or use the full name `PhysicsSM.Algebra.Octonion.conj_conj`.

---

## 10. The difference between a type and a term

This distinction matters everywhere in Lean.

- A **type** describes what kind of thing something is. `Octonion`, `ℝ`,
  `ℕ`, `Prop` are types.
- A **term** is an actual value of a type. `conj x`, `normSq x`, `42`,
  `x + y` are terms.

In `x : Octonion`:
- `x` is a term (a specific octonion).
- `Octonion` is its type.

In `normSq : Octonion → ℝ`:
- `normSq` is a term (a function).
- `Octonion → ℝ` is its type (a function type).

When a theorem says `(x : Octonion)`, it means `x` is a universally
quantified term of type `Octonion`.

---

## 11. Reading a proof (high level)

You do not need to understand proofs to read theorems. But recognise this
pattern:

```lean
theorem conj_mul (x y : Octonion) : conj (x * y) = conj y * conj x := by
  ext <;> simp [conj, Octonion.mul_c0, ...] <;> ring
```

- `:= by` enters tactic mode.
- `ext` breaks the octonion equality into 8 real-coordinate goals.
- `simp [conj, ...]` unfolds definitions and simplifies.
- `ring` finishes polynomial goals.
- `<;>` means "apply the next tactic to all remaining goals".

You do not need to reconstruct the proof. You need to understand what the
**theorem statement** says.

---

## Safe tasks for this level

- Open a `.lean` file and identify every import.
- Find the namespace every theorem lives in.
- Translate five theorem statements into plain English.
- Find the full qualified name for `normSq_mul`.
- Explain what `@[simp]` means on `conj_c1`.
- Read the module docstring of `Moufang.lean` and summarise in two sentences.

## Unsafe tasks for this level

- Do not edit any file.
- Do not run any build commands yet (that is Level 0).
- Do not try to understand proof tactics in detail (that is Level 2).
- Do not make any claim about what a theorem means for physics.

---

## Files to study

Open each one in order and read the module docstring plus the first five
theorems.

1. `PhysicsSM/Algebra/Octonion/Basic.lean` — the `Octonion` structure,
   multiplication table, component simp lemmas.
2. `PhysicsSM/Algebra/Octonion/Conjugation.lean` — `conj` definition and
   properties.
3. `PhysicsSM/Algebra/Octonion/Norm.lean` — `normSq` and
   `normSq_mul`.
4. `PhysicsSM/Algebra/Octonion/Moufang.lean` — the four Moufang identities.

---

## Practice exercises

1. Open `Conjugation.lean`. Write down the exact Lean statement of
   `mul_conj` and translate it into plain English.

2. Open `Norm.lean`. What does the statement of `normSq_eq_zero` say?
   What are its two directions?

3. Open `Moufang.lean`. List all four theorem names and write one sentence
   for each describing what it says. Pay attention to the parentheses.

4. Open `Basic.lean`. What are the eight field names of the `Octonion`
   structure? Which one is the scalar part?

5. Find all files imported by `Norm.lean`. For each import, say whether
   it is a project file or a mathlib file.

---

## Checklist before moving to Level 2

- [ ] I can identify every import in a file.
- [ ] I can find the namespace a theorem lives in.
- [ ] I can read `(x : Octonion)` as "for any octonion x".
- [ ] I can translate a theorem statement into plain English.
- [ ] I know what `@[simp]` means on a theorem.
- [ ] I know the difference between a type and a term.
- [ ] I can find the full qualified name of a declaration.
- [ ] I read the module docstring before anything else.
- [ ] I have not edited any file.
