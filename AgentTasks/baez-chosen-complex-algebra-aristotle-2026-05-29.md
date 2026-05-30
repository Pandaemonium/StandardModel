# Aristotle task: chosen complex line algebra

**Agent**: Aristotle
**Status**: Complete and integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `f0eefde9-b546-4cc4-a4d4-503734201541`
**Submission project**: `AgentTasks/aristotle-submit/baez-parallel-c3-20260529-project`
**Output**: `AgentTasks/aristotle-output/baez-chosen-complex-algebra-20260529`
**Extracted output**: `AgentTasks/aristotle-output/baez-chosen-complex-algebra-20260529-extracted`
**Integrated file**: `PhysicsSM/Algebra/Octonion/ChosenComplexAlgebra.lean`
**Type**: Baez octonion complex-line algebra / finite coordinate proof

## Integration result

Integrated Aristotle job `f0eefde9-b546-4cc4-a4d4-503734201541` into trusted
source as `PhysicsSM.Algebra.Octonion.ChosenComplexAlgebra`.

Main declarations added:

- `One`, `Sub`, and `Mul` instances for `ChosenComplex`.
- `ChosenComplex.toOctonion_mul`, proving that the chosen-line multiplication
  agrees with octonion multiplication restricted to `span_R {1, e111}`.
- `toChosenComplex_toOctonion_of_inLine`.
- `ChosenComplex.toComplex`, `ChosenComplex.ofComplex`, and round-trip /
  multiplication-compatibility theorems.

Verification run during integration:

```bash
lake env lean PhysicsSM\Algebra\Octonion\ChosenComplexAlgebra.lean
```

Status: trusted integration. The only placeholder-token hit is the word
`sorry` in the module status docstring.

## Goal

Strengthen the Baez `C = span_R {1, e111}` scaffold by making the chosen
complex line into an explicit copy of the ordinary complex numbers.

The project already has:

- `PhysicsSM.Algebra.Octonion.ComplexLine`
- `PhysicsSM.Algebra.Octonion.ComplexSplitting`
- `ChosenComplex`, `ChosenComplex.toOctonion`, and
  `Octonion.toChosenComplex`
- `InChosenComplexLine`
- `mul_inChosenComplexLine`

This job should add a small trusted module proving that the coordinate model
`ChosenComplex` has the expected complex-number multiplication and that its
embedding into the project octonions respects multiplication.

## Sources and claim boundary

Source motivation:

- John Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
- Baez, "The Octonions", Bull. Amer. Math. Soc. 2002.

Claim boundary:

- This is only the chosen complex line inside the project octonions.
- Do not claim a `G2/SU(3)` theorem or any Standard Model representation
  theorem.
- Use the project XOR basis and the chosen unit `e111`.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Octonion/ChosenComplexAlgebra.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.ComplexSplitting
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Add explicit algebra operations on `ChosenComplex` if they are not already
available:

```lean
instance : One ChosenComplex
instance : Sub ChosenComplex
instance : Mul ChosenComplex
```

Use the ordinary formula

```text
(a + i b) * (c + i d) = (a*c - b*d) + i*(a*d + b*c).
```

Prove coordinate and embedding lemmas:

```lean
@[simp] theorem ChosenComplex.one_toOctonion :
    (1 : ChosenComplex).toOctonion = (1 : Octonion)

@[simp] theorem ChosenComplex.toOctonion_zero :
    (0 : ChosenComplex).toOctonion = (0 : Octonion)

@[simp] theorem ChosenComplex.toOctonion_add (z w : ChosenComplex) :
    (z + w).toOctonion = z.toOctonion + w.toOctonion

@[simp] theorem ChosenComplex.toOctonion_neg (z : ChosenComplex) :
    (-z).toOctonion = -z.toOctonion

@[simp] theorem ChosenComplex.toOctonion_sub (z w : ChosenComplex) :
    (z - w).toOctonion = z.toOctonion - w.toOctonion

@[simp] theorem ChosenComplex.toOctonion_smul (r : Real) (z : ChosenComplex) :
    (r • z).toOctonion = r • z.toOctonion

@[simp] theorem ChosenComplex.toOctonion_mul (z w : ChosenComplex) :
    (z * w).toOctonion = z.toOctonion * w.toOctonion
```

Prove the line-coordinate characterization:

```lean
theorem Octonion.toChosenComplex_toOctonion_of_inLine
    {x : Octonion} (hx : InChosenComplexLine x) :
    x.toChosenComplex.toOctonion = x
```

Define maps to and from ordinary Lean complex numbers:

```lean
noncomputable def ChosenComplex.toComplex (z : ChosenComplex) : Complex
noncomputable def ChosenComplex.ofComplex (z : Complex) : ChosenComplex
```

Prove round trips and operation compatibility where feasible:

```lean
theorem ChosenComplex.toComplex_ofComplex (z : Complex) :
    (ChosenComplex.ofComplex z).toComplex = z

theorem ChosenComplex.ofComplex_toComplex (z : ChosenComplex) :
    ChosenComplex.ofComplex z.toComplex = z

theorem ChosenComplex.toComplex_mul (z w : ChosenComplex) :
    (z * w).toComplex = z.toComplex * w.toComplex
```

Optional if convenient: prove `add`, `neg`, `sub`, `one`, and `zero`
compatibility for `toComplex`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change existing octonion multiplication conventions.
- Keep all multiplication parenthesization explicit where octonions are used.
- Prefer coordinate `ext <;> simp [...] <;> ring` proofs.
- Keep the module small and reviewable.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/ChosenComplexAlgebra.lean
lake build PhysicsSM.Algebra.Octonion.ChosenComplexAlgebra
lake build PhysicsSM
```

## Deliverable

Return files changed, theorem names proved, whether the file is sorry-free,
and exact verification commands run.
