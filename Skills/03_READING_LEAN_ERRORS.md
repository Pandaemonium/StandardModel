# Level 3: Reading Lean Errors

**Purpose.** This tutorial teaches you to read, classify, and respond to Lean
error messages. After finishing it you will be able to identify the type of
error from its text, name the file and line where it occurs, choose the right
one-step fix, and write a useful handoff note when the fix is beyond your
level.

**Prerequisites.** Complete `Skills/01_LEAN_READING_BASICS.md` and
`Skills/02_LEAN_WRITING_BASICS.md`.

**Key vocabulary.** error, warning, unknown identifier, type mismatch,
instance synthesis, tactic failed, unsolved goals, sorry, `.olean`,
ProofWidgets, `lake env lean`.

---

## 1. How to run Lean and read its output

On Windows, use this command to check a single file without triggering the
ProofWidgets build error:

```powershell
lake env lean PhysicsSM\Algebra\Octonion\Conjugation.lean
```

Lean prints a mix of **errors** and **warnings**. Errors prevent the file
from being trusted. Warnings are advisory but may still block CI.

A clean file prints nothing (or only informational messages with `info:`).

**Always quote the exact error text in your report.** Do not paraphrase it.

---

## 2. Error structure

Most Lean errors look like this:

```
PhysicsSM/Algebra/Octonion/Conjugation.lean:74:2: error: unknown identifier 'conj'
```

Breaking it apart:

| Part | Meaning |
|------|---------|
| `PhysicsSM/Algebra/Octonion/Conjugation.lean` | File where the error is. |
| `74` | Line number. |
| `2` | Column number (character position on the line). |
| `error:` | This is an error (vs a `warning:` or `info:`). |
| `unknown identifier 'conj'` | The error message text. |

Always check: what is on line 74 of `Conjugation.lean`? Open the file and
look at that exact line.

---

## 3. Error catalogue

### 3.1 Unknown identifier

```
error: unknown identifier 'normSq'
```

**What it means:** Lean cannot find a definition called `normSq` in scope.

**Usual cause:** The import is missing, or there is a spelling mistake, or
the definition is in a namespace that has not been opened.

**Fixes to try, in order:**
1. Is it spelled correctly? Check capitalisation.
2. Is the correct file imported? `normSq` lives in `Norm.lean`; add
   `import PhysicsSM.Algebra.Octonion.Norm`.
3. Is it in a namespace you have not opened? Try the full qualified name
   `PhysicsSM.Algebra.Octonion.normSq`.
4. Does the definition actually exist? Search: `grep -r "def normSq"
   PhysicsSM/`.

**If none of these work:** write a handoff note. Do not invent a new
definition to replace the missing one.

---

### 3.2 Type mismatch

```
error: type mismatch
  x
has type
  Octonion : Type
but is expected to have type
  ℝ : Type
```

**What it means:** you passed an `Octonion` value where a real number was
expected, or vice versa.

**Usual causes:**
- Calling `normSq` (which returns `ℝ`) as if it returned `Octonion`.
- Mixing up `.c0` (extracts a real coordinate) with the full octonion.
- Applying an operation to the wrong type.

**Fix:** read the theorem carefully and check what types the inputs and
outputs should be. Look at the definition of each function involved.

**Example:**
```lean
-- WRONG: normSq returns ℝ, not Octonion
theorem foo (x : Octonion) : normSq x = 0 := by
  simp [normSq]
  -- error if you then try to use 'ring' on a goal over ℝ and ℕ mixed up

-- RIGHT: check that both sides of '=' have the same type
theorem foo (x : Octonion) : normSq x = 0 ↔ x = 0 := normSq_eq_zero x
```

---

### 3.3 Failed to synthesize instance

```
error: failed to synthesize
  HAdd Octonion ℝ ?m.1
```

**What it means:** Lean cannot find a typeclass instance that lets it perform
an operation. Here it does not know how to add `Octonion` and `ℝ` together —
because that operation is not defined.

**Usual causes:**
- Mixing types (adding an octonion to a real number directly).
- Using a mathlib function that requires an instance you have not imported
  (e.g., `Module ℝ Octonion` needs an import from `ComplexOctonion.lean`).
- Using a function before its required instance is in scope.

**Fix:**
1. Check the types involved. If you meant `c0 + c1` (two reals), write
   `x.c0 + x.c1` not `x + c1` where `c1` is a real.
2. If an instance is missing, search for where it is defined in the project
   and add the corresponding import.
3. If you genuinely need a new instance, escalate — do not invent one.

---

### 3.4 Tactic failed

```
error: tactic 'rfl' failed, the left-hand side
  conj (conj x)
is not definitionally equal to
  x
```

**What it means:** the tactic you used was not able to close this goal.

**Usual causes:**
- `rfl` on something that is not definitionally equal (try `simp` instead).
- `ring` on a goal that still has `Octonion`-typed subexpressions (you need
  `ext <;> simp only [mul_c0, ...] <;> ring`).
- `simp` could not find the right rewrite rules (add the missing lemma
  names to `simp [...]`).
- `positivity` on a goal that is not syntactically a sum of nonneg terms.

**Response pattern:**
1. Read the exact goal Lean printed (it appears in the error).
2. Decide what kind of goal it is (structural equality, polynomial, inequality).
3. Choose the right tactic (see Level 2 cheat sheet).
4. Run again.

**If ring fails:**

```
error: ring failed, no obvious identity with goal
  conj (x * y) = conj y * conj x
```

This means `ring` sees `Octonion`-valued expressions. The fix is:
```lean
ext <;> simp [conj, Octonion.mul_c0, ..., Octonion.mul_c7] <;> ring
```
Expand with `ext` and `simp only`, then use `ring` on the resulting
`ℝ`-valued goals.

---

### 3.5 Unsolved goals

```
error: unsolved goals
  x : Octonion
  ⊢ x.c3 = 0
```

**What it means:** the proof script ran without an error, but the proof is
not finished. There is at least one goal left.

**Usual cause:** a tactic did not close all goals, or you forgot a tactic.

**Response pattern:**
1. Read what goal is left (printed after `⊢`).
2. Decide why the existing tactics did not close it.
3. Add the missing tactic at the end, or replace an incorrect one.
4. If you cannot close it, write a handoff note with the exact remaining
   goal.

---

### 3.6 Use of sorry in trusted code

```
warning: declaration uses 'sorry'
```

**What it means:** the proof uses `sorry`, which is a cheat that pretends
a proof is complete without checking it.

**Rules for this project:**
- `sorry` is **never** allowed in a file whose module docstring says "trusted".
- `sorry` is allowed only in draft files, clearly marked, with a handoff note.
- If you see this warning in a trusted file, report it immediately. Do not
  try to fix it yourself.

---

### 3.7 Unknown tactic or declaration

```
error: unknown tactic 'positivity'
```

**What it means:** the tactic `positivity` is not available. It needs to be
imported.

**Fix:** add at the top of the file:
```lean
import Mathlib.Tactic.Positivity
```

Similar imports for other missing tactics:
- `linarith`, `nlinarith` → `import Mathlib.Tactic.Linarith`
- `ring` → usually in `Mathlib.Tactic.Ring`
- `norm_num` → `import Mathlib.Tactic.NormNum`
- `simp`, `ext`, `rfl`, `rw` → always available

---

### 3.8 Import errors

```
error: cannot find module 'PhysicsSM.Algebra.Octonion.NotAFile'
```

**What it means:** an import refers to a file that does not exist at that
path.

**Fix:**
1. Check the spelling against the actual directory tree.
2. Find where the definition you need actually lives: `grep -r "def myDef"
   PhysicsSM/`.
3. Correct the import path.

---

### 3.9 Duplicate name

```
error: 'conj_c1' has already been declared
```

**What it means:** a declaration with that name already exists in this
namespace.

**Fix:**
1. Search for the existing declaration: `grep -n "conj_c1"
   PhysicsSM/Algebra/Octonion/Conjugation.lean`.
2. Either use the existing one (most likely) or choose a different name.
3. Never delete an existing declaration without being sure it is not used
   elsewhere.

---

## 4. Warnings vs errors

Lean also produces **warnings**, which do not prevent compilation but may be
flagged by CI. Common warnings in this project:

### Unused simp argument

```
warning: simp argument is unused: Fin.reduceFinMk
```

This means you passed a lemma to `simp` that was not actually used. It is
cosmetic. The proof still works. Report it but do not block on it.

### Duplicate namespace

```
warning: The namespace 'Octonion' is duplicated in the declaration
'PhysicsSM.Algebra.Octonion.Octonion.c0'
```

This appears when the `Octonion` structure is defined inside the
`PhysicsSM.Algebra.Octonion` namespace, creating the full name
`PhysicsSM.Algebra.Octonion.Octonion`. It is cosmetic. Do not try to fix it
unless explicitly asked.

### Unreachable tactic

```
warning: 'ring' tactic does nothing
```

This means `ring` was in the proof but there was nothing left for it to do.
Remove it. Example fix:
```lean
-- Before:
  ext <;> simp [alpha1] <;> ring
-- After (if ring does nothing):
  ext <;> simp [alpha1]
```

---

## 5. The Windows ProofWidgets error

When you run `lake build PhysicsSM.Algebra.Octonion.Conjugation` (with a
module name), you may see:

```
error: ProofWidgets not up-to-date. Please run `lake exe cache get`
```

**This is a known Windows-only issue.** The ProofWidgets JavaScript bundle
was built on Linux and its trace file contains Linux paths that do not match
Windows.

**This does not affect correctness.** The Lean proofs are still verified.

**Workaround:** use `lake env lean <file.lean>` instead of
`lake build <module>`. The file-based check works correctly on Windows.

```powershell
# WRONG on Windows (may fail with ProofWidgets error):
lake build PhysicsSM.Algebra.Octonion.Conjugation

# CORRECT on Windows:
lake env lean PhysicsSM\Algebra\Octonion\Conjugation.lean
```

Full discussion is in `AGENTS.md` under "Toolchain freeze".

---

## 6. Stale `.olean` files

If a file passes a check but another file that imports it fails unexpectedly,
the `.olean` (compiled Lean object) may be stale. This is rare but possible
after switching branches or running `lake clean`.

**Fix:**
1. Run `lake clean` to clear all cached objects.
2. Run `lake exe cache get` to re-fetch mathlib's prebuilt objects.
3. Run the file check again.

Warn a senior agent before running `lake clean` — it clears all cached
compilations and the rebuild takes time.

---

## 7. The five-step error response

When you encounter any Lean error, follow this process exactly:

**Step 1.** Quote the exact error text. Do not paraphrase.

**Step 2.** Name the file, line number, and column number.

**Step 3.** Classify the error:
- Unknown identifier (missing name or import)
- Type mismatch (wrong type passed to function)
- Instance synthesis (missing typeclass instance or import)
- Tactic failed (wrong tactic for this goal)
- Unsolved goals (proof incomplete)
- Sorry warning (in trusted code: escalate immediately)
- Windows ProofWidgets (use `lake env lean` instead)
- Duplicate name (declaration already exists)

**Step 4.** Try one focused fix from the relevant section above.

**Step 5.** Run `lake env lean <file>` again and report whether the error is
gone, changed, or the same.

If after one attempt the error persists, write a handoff note.

---

## 8. Handoff note for an error

When you are stuck, write this and stop:

```
Handoff:
- File: PhysicsSM/Algebra/Octonion/Conjugation.lean
- Line: 74
- Error (exact): unknown identifier 'normSq'
- Error class: unknown identifier
- What I tried: added import PhysicsSM.Algebra.Octonion.Norm
- Result: still fails with the same error
- Suspected cause: normSq might be in a different namespace
- Recommended next step: have a senior agent search for the correct
  qualified name with grep -r "def normSq" PhysicsSM/
```

---

## 9. Interpreting proof state in error messages

When a tactic fails, Lean sometimes prints the proof state at the failure
point. This looks like:

```
error: tactic 'ring' failed

case h
x y : Octonion
⊢ conj (x * y) = conj y * conj x
```

Read this as:
- `case h` — which sub-goal was being proved (ignore for now).
- `x y : Octonion` — local variables in scope.
- `⊢ conj (x * y) = conj y * conj x` — the goal that `ring` could not close.

The goal is `Octonion`-typed. `ring` fails because it only works over
commutative rings, and `Octonion`-valued goals are not commutative. The fix:

```lean
ext <;> simp [conj, Octonion.mul_c0, ...] <;> ring
```

---

## 10. Two examples from this project

### Example A: Ring tactic applied too early

**Error:**
```
PhysicsSM/Algebra/Furey/LadderOperators.lean:90:28: warning: 'ring' tactic does nothing
```

**Diagnosis:** `ring` was applied after `simp` already closed all goals. It is
unreachable.

**Fix:** remove `<;> ring` from that proof line.

**Correct proof:**
```lean
theorem alpha1_nilpotent : alpha1 * alpha1 = 0 := by
  ext <;> simp [alpha1]      -- ring was removed
```

---

### Example B: Noncomputable definition required

**Error:**
```
error: failed to compile definition, consider marking it as 'noncomputable'
because it depends on 'Real.instDivInvMonoid', which is 'noncomputable'
```

**Diagnosis:** a definition uses `1/2` (real division), which Lean treats as
noncomputable because real division is not decidable.

**Fix:** add `noncomputable` before `def`:

```lean
noncomputable def alpha1 : ComplexOctonion :=
  { re := { ..., c4 := 1/2, ... }  ... }
```

This is a safe mechanical fix. Do not change the definition's content.

---

## Safe tasks for this level

- Given an error log, classify it using the catalogue in Section 3.
- Find the missing import for an "unknown identifier" error.
- Explain in one sentence why `ring` failed on a given goal.
- Write a handoff note for an error you cannot fix.
- Run `lake env lean` on a file and report the exact output.

## Unsafe tasks for this level

- Do not attempt to fix type mismatch errors by changing theorem statements.
- Do not attempt to fix instance synthesis errors by inventing new instances.
- Do not remove `sorry` from trusted code — escalate.
- Do not run `lake clean` without warning a senior agent.
- Do not change imports without understanding what definitions they provide.

---

## Practice exercises

1. Read the following error. Classify it, name the file and line, and write
   what one fix to try:
   ```
   PhysicsSM/Algebra/Octonion/Norm.lean:62:2: error: unknown identifier 'positivity'
   ```

2. Read this error. What type does Lean think `normSq x` has? What type does
   the goal expect? What went wrong?
   ```
   error: type mismatch
     normSq x
   has type
     ℝ : Type
   but is expected to have type
     Octonion : Type
   ```

3. Read this proof state from a tactic failure. What tactic would you try?
   ```
   case h.c0
   x y : Octonion
   ⊢ x.c0 ^ 2 + x.c1 ^ 2 + ... + x.c7 ^ 2 = 0 → x.c0 = 0
   ```

4. You are on Windows and get the ProofWidgets error when running
   `lake build PhysicsSM.Algebra.Octonion.Norm`. Write the corrected
   command that avoids this issue.

5. A theorem is proved with:
   ```lean
   ext <;> simp [conj, mul_c0, mul_c1] <;> ring
   ```
   Lean shows `warning: 'ring' tactic does nothing` on one goal and no
   error on others. What does this mean, and what is the safe minimal fix?

---

## Checklist before moving to Level 4

- [ ] I can read a Lean error and identify its file and line number.
- [ ] I can classify errors into: unknown identifier, type mismatch, instance
  synthesis, tactic failed, unsolved goals, or ProofWidgets.
- [ ] I know the Windows ProofWidgets workaround (`lake env lean`).
- [ ] I know that `ring` on an Octonion-valued goal always fails.
- [ ] I know that `sorry` in a trusted file must be escalated immediately.
- [ ] I can write a complete handoff note with exact error text.
- [ ] I follow the five-step response pattern for every error.
- [ ] I run `lake env lean` before and after every edit.
