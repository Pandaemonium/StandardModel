# Task: Finish the conjBy Converse Criterion

**Agent**: Aristotle
**Status**: Complete; integrated
**Job ID**: `6065091b-6f6b-4de4-9590-501d6c3ab742`
**Submitted**: 2026-04-30
**Reviewed**: 2026-04-30
**Integrated**: 2026-04-30
**Priority**: Focused hard proof follow-up to job `270e946c-7615-49ff-aded-15f9a2c68c15`
**Output**: `AgentTasks/aristotle-output/g2-conjby-converse-followup`

## Result review

Aristotle completed the focused follow-up. The result was downloaded, extracted,
and reviewed from `AgentTasks/aristotle-output/g2-conjby-converse-followup`.

Integrated trusted declarations:

- `conjBy_preservesMul_implies_cube_eq_one_or_neg_one`
- `conjBy_preservesMul_iff_cube_eq_one_or_neg_one`

The raw Aristotle output also contained cube-coordinate helper lemmas, but those
were not needed by the final theorem and were not copied into trusted source.
The integrated proof keeps the finite basis-pair reduction and replaces the raw
`exact?` tactic in the iff theorem with an explicit reference to the converse
lemma.

---

## Prompt

You are working in the Lean 4 project `PhysicsSM`.

The project is pinned to Lean `v4.28.0`. The Lean kernel is the source of truth.
Do not introduce `axiom`, `opaque`, `unsafe def`, `admit`, or unresolved `sorry`
in trusted code.

## Target file

Primary file:

```text
PhysicsSM/Algebra/Octonion/TrialityCompanions.lean
```

Namespace:

```lean
namespace PhysicsSM.Algebra.Octonion
```

## Project conventions

The octonion model is the concrete real coordinate model in
`PhysicsSM.Algebra.Octonion.Basic`.

Important conventions:

- Octonions are not associative.
- The basis uses the project XOR/Fano convention from
  `PhysicsSM.Algebra.Octonion.Basic`.
- The fixed cube is `cube a = (a * a) * a`.
- The conjugation action is `conjBy a x = (a * x) * conj a`.
- Do not silently reassociate products. Use existing named reassociation,
  Moufang, alternativity, cancellation, and coordinate lemmas.

## Existing trusted declarations

The target file already contains:

```lean
def cube (a : Octonion) : Octonion := (a * a) * a
def conjBy (a x : Octonion) : Octonion := (a * x) * conj a
def PreservesMul (gamma : Octonion -> Octonion) : Prop :=
  forall x y : Octonion, gamma (x * y) = gamma x * gamma y
```

Useful existing theorems include:

```lean
conjBy_mul_of_unit_cube_eq_one
conjBy_mul_of_unit_cube_eq_neg_one
conjBy_iter_three_of_unit_cube_eq_one
conjBy_iter_three_of_unit_cube_eq_neg_one
conjBy_normSq_of_unit
conjBy_commutes_conjugation
conjBy_leftInverse_conj_of_unit
conjBy_bijective_of_unit
conjBy_automorphismData_of_unit_cube_eq_one
conjBy_automorphismData_of_unit_cube_eq_neg_one
unit_mul_conj_eq_one
unit_conj_mul_eq_one
unit_mul_conj_cancel_right
unit_conj_mul_cancel_left
unit_mul_conj_cancel_left
unit_conj_mul_conj_cancel_right
mul_assoc_with_conj_right
conj_mul_assoc_with_right
mul_conj_cancel_right
conj_mul_cancel_left
conj_mul_conj_cancel_right
mul_conj_cancel_left
normSq_mul
normSq_conj
left_alternative
right_alternative
flexible
moufang_left
moufang_right
moufang_middle
```

The project also has explicit coordinate simp lemmas such as:

```lean
Octonion.ext_iff
Octonion.mul_c0
Octonion.mul_c1
...
Octonion.mul_c7
```

## Main task

Prove the hard converse direction:

```lean
theorem conjBy_preservesMul_implies_cube_eq_one_or_neg_one
    {a : Octonion} (ha_unit : normSq a = 1)
    (h_preserves_mul : PreservesMul (conjBy a)) :
    cube a = 1 ∨ cube a = -1 := by
  ...
```

Then add the full iff theorem:

```lean
theorem conjBy_preservesMul_iff_cube_eq_one_or_neg_one
    {a : Octonion} (ha_unit : normSq a = 1) :
    PreservesMul (conjBy a) ↔ cube a = 1 ∨ cube a = -1 := by
  ...
```

The easy direction should use the already trusted multiplication theorems:

```lean
conjBy_mul_of_unit_cube_eq_one
conjBy_mul_of_unit_cube_eq_neg_one
```

## Suggested proof strategies

Try the structural proof first:

1. Use `h_preserves_mul` on carefully chosen inputs, especially basis elements,
   `a`, `conj a`, `a * a`, and products involving `cube a`.
2. Use the unit-norm cancellation lemmas to remove adjacent `a` and `conj a`.
3. Use Moufang identities and alternativity only through named project lemmas.
4. Show that multiplicativity forces `cube a` to be a real scalar or central
   enough that the unit-norm condition leaves only `1` or `-1`.

If the structural route stalls, use the finite coordinate route:

1. Specialize `h_preserves_mul` to a finite set of basis-pair equations.
2. Project those equations through `Octonion.ext_iff` and the coordinate simp
   lemmas.
3. Use `ring`/`nlinarith`/`native_decide`-style finite arithmetic if feasible.
4. Keep helper lemmas small and descriptively named.

## Constraints

- Do not weaken the theorem statement.
- Do not change the definitions of `cube`, `conjBy`, or `PreservesMul`.
- Do not import all of Mathlib.
- Trusted code must remain free of `sorry`, `admit`, new `axiom`, `opaque`, or
  `unsafe def`.
- If the full proof cannot be completed, do not add a placeholder theorem to
  trusted code. Instead, create a clearly marked draft/handoff file under
  `PhysicsSM/Draft/` with a proof plan, failed approaches, and any complete
  helper lemmas.

## Verification request

After editing, run the smallest relevant check:

```bash
lake env lean PhysicsSM/Algebra/Octonion/TrialityCompanions.lean
```

If you create a draft file, check that file too.

Report exactly:

- which theorem(s) were proved,
- which file(s) changed,
- whether any draft `sorry` remains,
- which Lean commands were run,
- and whether any new imports were added.
