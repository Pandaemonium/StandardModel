# Task: Octonion ring structure, ComplexOctonion Mul, and ladder operator nilpotency

**Agent**: Aristotle
**Status**: In progress
**Priority**: High
**Job ID**: `b75da66c-6a77-462c-850b-47a57130dd55`
**Submitted**: 2026-04-26
**Output**: `AgentTasks/aristotle-output/octonion-ring-and-ladder`

## Objective

Complete the algebraic infrastructure needed to define and prove properties of
Furey's ladder operators. This requires three sequential sub-tasks:

1. Add `Add`, `Zero`, `Sub`, and `One` instances to `Octonion` (in `Basic.lean`)
2. Add `Add`, `Zero`, and `Mul` to `ComplexOctonion` (in `ComplexOctonion.lean`)
3. Uncomment and prove the ladder operator definitions in `LadderOperators.lean`

## Sub-task 1: Octonion ring structure

**File**: `PhysicsSM/Algebra/Octonion/Basic.lean`
**Namespace**: `PhysicsSM.Algebra.Octonion`

Add the following instances, all component-wise:

```lean
instance : Add Octonion where
  add a b := ⟨a.c0+b.c0, a.c1+b.c1, a.c2+b.c2, a.c3+b.c3,
               a.c4+b.c4, a.c5+b.c5, a.c6+b.c6, a.c7+b.c7⟩

instance : Zero Octonion where
  zero := ⟨0,0,0,0,0,0,0,0⟩

instance : Sub Octonion where
  sub a b := ⟨a.c0-b.c0, a.c1-b.c1, a.c2-b.c2, a.c3-b.c3,
               a.c4-b.c4, a.c5-b.c5, a.c6-b.c6, a.c7-b.c7⟩

instance : One Octonion where
  one := ⟨1,0,0,0,0,0,0,0⟩

instance : SMul ℝ Octonion where
  smul r a := ⟨r*a.c0, r*a.c1, r*a.c2, r*a.c3, r*a.c4, r*a.c5, r*a.c6, r*a.c7⟩
```

Also add `@[simp]` lemmas for each instance, following the exact pattern
of the existing `neg_c0`–`neg_c7` and `mul_c0`–`mul_c7` lemmas. Name them:
`add_c0`–`add_c7`, `zero_c0`–`zero_c7`, `sub_c0`–`sub_c7`,
`one_c0`, `one_c1`–`one_c7` (all `= 0` except `one_c0 = 1`),
`smul_c0`–`smul_c7`.

Do NOT attempt to add ring/module typeclasses (e.g., `Ring`, `Module`,
`AddCommGroup`) in this task — add only the bare instances above.
The full algebraic hierarchy is a separate task.

## Sub-task 2: ComplexOctonion algebraic structure

**File**: `PhysicsSM/Algebra/Octonion/ComplexOctonion.lean`
**Namespace**: `PhysicsSM.Algebra.Octonion.ComplexOctonion`

Add:

```lean
instance : Add ComplexOctonion where
  add a b := ⟨a.re + b.re, a.im + b.im⟩

instance : Zero ComplexOctonion where
  zero := ⟨0, 0⟩

/-- ComplexOctonion multiplication: (a + i·b)(c + i·d) = (a·c - b·d) + i·(a·d + b·c)
    where · is octonion multiplication (non-associative, non-commutative). -/
instance : Mul ComplexOctonion where
  mul a b := ⟨a.re * b.re - a.im * b.im, a.re * b.im + a.im * b.re⟩
```

Add `@[simp]` lemmas:
- `mul_re (a b : ComplexOctonion) : (a * b).re = a.re * b.re - a.im * b.im`
- `mul_im (a b : ComplexOctonion) : (a * b).im = a.re * b.im + a.im * b.re`
- `add_re`, `add_im`, `zero_re`, `zero_im`

## Sub-task 3: Ladder operator definitions and nilpotency

**File**: `PhysicsSM/Algebra/Furey/LadderOperators.lean`
**Namespace**: `PhysicsSM.Algebra.Furey.LadderOperators`

Uncomment and activate the definitions (removing the `--` comment markers):

```lean
def alpha1 : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=1/2, c5:=0, c6:=0, c7:=0 }
    im := { c0:=0, c1:=0, c2:=0, c3:=1/2, c4:=0, c5:=0, c6:=0, c7:=0 } }
-- alpha1 (XOR) = (+e100 + i*e011) / 2

def alpha2 : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=0, c5:=0, c6:=-1/2, c7:=0 }
    im := { c0:=0, c1:=1/2, c2:=0, c3:=0, c4:=0, c5:=0, c6:=0, c7:=0 } }
-- alpha2 (XOR) = (-e110 + i*e001) / 2

def alpha3 : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=0, c5:=-1/2, c6:=0, c7:=0 }
    im := { c0:=0, c1:=0, c2:=1/2, c3:=0, c4:=0, c5:=0, c6:=0, c7:=0 } }
-- alpha3 (XOR) = (-e101 + i*e010) / 2
```

Then prove:

```lean
theorem alpha1_nilpotent : alpha1 * alpha1 = 0
theorem alpha2_nilpotent : alpha2 * alpha2 = 0
theorem alpha3_nilpotent : alpha3 * alpha3 = 0
```

**Proof hint for alpha1_nilpotent**:
Unfold via `simp [alpha1, mul_re, mul_im, sub_c0, ..., add_c0, ..., zero_re, zero_im]`
then `ext <;> norm_num` or `ring`. The key cancellation:
  re part: e100*e100 - e011*e011 = -1 - (-1) = 0... wait no:
  re: (e100 * e100 - e011 * e011).c0 etc.
  Actually re: (+1/2)*e100 * (+1/2)*e100 - (+1/2)*e011 * (+1/2)*e011
            = (1/4)(e100^2 - e011^2) = (1/4)(-1 - (-1)) = 0
  im: (+1/2)*e100 * (+1/2)*e011 + (+1/2)*e011 * (+1/2)*e100
    = (1/4)(e100*e011 + e011*e100) = (1/4)(+e111 + (-e111)) = 0
The proof should work as `ext <;> simp [alpha1, ...] <;> ring`.

## Constraints

- No `sorry` in the final output.
- No new axioms.
- Keep all definitions inside the correct namespaces.
- Use `@[simp]` on component lemmas so downstream proofs can use `simp`.
- The `mul` instance for `ComplexOctonion` uses octonionic (non-associative) multiplication.
  Do NOT assume associativity.
- Imports needed: existing imports in each file should suffice; add
  `Mathlib.Data.Real.Basic` if not already present.

## Verification

```bash
lake build PhysicsSM.Algebra.Octonion.Basic
lake build PhysicsSM.Algebra.Octonion.ComplexOctonion
lake build PhysicsSM.Algebra.Furey.LadderOperators
lake build
```

No `sorry` should remain.

## Handoff notes

The three nilpotency proofs are the most likely to need Aristotle's tactic search.
Strategy: `simp` with the component lemmas, then `ext`, then `norm_num` or `ring`
on each ℝ-valued component goal. The calculations are finite and should close.

If `ext <;> simp <;> ring` fails (as it did for `mul_anticomm_imag`), fall back to
`fin_cases`-style case splitting or `norm_num` on the numeric goals.
