# Task: Triality Companions and the Octonion Conjugation Criterion

**Agent**: Aristotle
**Status**: Integrated
**Priority**: MOONSHOT
**Type**: proof / nonassociative algebra / triality
**Job ID**: `d76adda3-911d-43d2-ac78-6d122fcda89c`
**Submitted**: 2026-04-29
**Output artifact**: `AgentTasks/aristotle-output/triality-companions-conjugation-moonshot`
**Submission project**: `AgentTasks/aristotle-submit/triality-companions-conjugation-moonshot-project`
**Target file**: `PhysicsSM/Algebra/Octonion/TrialityCompanions.lean`

## Integration result

Integrated on 2026-04-29.

The Aristotle artifact was downloaded to:

```text
AgentTasks/aristotle-output/triality-companions-conjugation-moonshot
```

The trusted repo module is:

```text
PhysicsSM/Algebra/Octonion/TrialityCompanions.lean
```

Kernel-checked results now in trusted source:

- `cube` and `conjBy`, with fixed parenthesization conventions.
- `unit_mul_conj_eq_one`, `unit_conj_mul_eq_one`, and four unit cancellation
  lemmas for multiplying by `a` and `conj a`.
- `mul_assoc_with_conj_right` and `conj_mul_assoc_with_right`, the specific
  reassociation facts allowed for the pair `a`, `conj a`.
- `conjBy_mul_of_unit_cube_eq_one` and
  `conjBy_mul_of_unit_cube_eq_neg_one`, the forward automorphism direction.
- `conjBy_iter_three_of_unit_cube_eq_one` and
  `conjBy_iter_three_of_unit_cube_eq_neg_one`, the order-three consequence.
- `HasCompanions` and `PreservesMul`, as predicates for the next companion-map
  and converse work.

Remaining work:

- Prove actual companion identities such as `conjBy_has_companions`.
- Prove the converse direction, or a useful partial converse:
  multiplication preservation of `conjBy a` should force `cube a` into the
  relevant scalar cases.

## Goal

Push the octonion formalization past coordinate identities into a genuinely
conceptual theorem connecting Moufang identities, triality companion maps, and
the exceptional order-three behavior of octonion conjugation maps.

The stretch theorem is the Conway-Smith/Yokota criterion:

> For a unit octonion `a`, the map `x |-> (a * x) * conj a` is an algebra
> automorphism exactly in the cases where `a^3 = +/- 1`. In those nontrivial
> cases, the induced automorphism has order three.

This is deliberately ambitious. The best outcome is a kernel-checked Lean file
which proves the automorphism direction using the Moufang identities and then
packages the order-three result. A strong partial outcome is a clean trusted
file proving the companion-map identities and the restricted `a^3 = +/-1`
automorphism statements. If the full proof is too hard, leave precise handoff
notes, not weakened theorems.

## Current Trusted Inputs

Use the existing project modules:

- `PhysicsSM.Algebra.Octonion.Basic`
- `PhysicsSM.Algebra.Octonion.Conjugation`
- `PhysicsSM.Algebra.Octonion.Norm`
- `PhysicsSM.Algebra.Octonion.Moufang`

Important declarations already available:

- type: `Octonion`
- multiplication: `(*)`
- unit: `(1 : Octonion)`
- real scalar action: `r • x`
- basis convention: project XOR/Fano convention
- conjugation: `conj`
- norm: `normSq`
- conjugation facts: `conj_conj`, `conj_mul`, `mul_conj`, `conj_mul_self`
- norm facts: `normSq_one`, `normSq_conj`, `normSq_mul`,
  `normSq_eq_mul_conj`
- alternativity: `left_alternative`, `right_alternative`
- Moufang identities: `moufang_left`, `moufang_right`, `moufang_middle`,
  `flexible`

## Critical Convention Warning

Octonions are not associative. Every theorem statement must keep all
parentheses explicit.

For this task, use the fixed convention:

```lean
def conjBy (a x : Octonion) : Octonion := (a * x) * conj a
```

Do not silently replace `(a * x) * conj a` with `a * (x * conj a)` unless you
have proved the specific reassociation lemma needed at that point.

Use `cube a := (a * a) * a` as the canonical parenthesization of `a^3`. If you
prove `a * (a * a) = (a * a) * a`, record it as a named lemma and then use it
only through that lemma.

## Requested File

Create:

```text
PhysicsSM/Algebra/Octonion/TrialityCompanions.lean
```

with imports:

```lean
import PhysicsSM.Algebra.Octonion.Norm
import PhysicsSM.Algebra.Octonion.Moufang
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion
```

Use verbose comments. This file is meant to become the reviewable handhold for
the Baez/Yokota/Conway-Smith triality question.

## Phase 1: Power, Inverse, and Conjugation-Map Infrastructure

Define:

```lean
def cube (a : Octonion) : Octonion := (a * a) * a

def conjBy (a x : Octonion) : Octonion := (a * x) * conj a
```

Prove basic lemmas, with names close to:

```lean
theorem cube_assoc (a : Octonion) :
    a * (a * a) = cube a := ...

theorem unit_mul_conj_eq_one {a : Octonion} (ha : normSq a = 1) :
    a * conj a = 1 := ...

theorem unit_conj_mul_eq_one {a : Octonion} (ha : normSq a = 1) :
    conj a * a = 1 := ...

theorem conjBy_one (a : Octonion) :
    conjBy a 1 = a * conj a := ...

theorem conjBy_one_of_unit {a : Octonion} (ha : normSq a = 1) :
    conjBy a 1 = 1 := ...
```

Also prove real-linearity facts if they are easy:

```lean
theorem conjBy_add (a x y : Octonion) :
    conjBy a (x + y) = conjBy a x + conjBy a y := ...

theorem conjBy_smul (a : Octonion) (r : Real) (x : Octonion) :
    conjBy a (r • x) = r • conjBy a x := ...
```

These linearity facts are not the main theorem, but they make the later
automorphism packaging more honest.

## Phase 2: Direct Automorphism Theorems for `a^3 = +/- 1`

The first moonshot target is the multiplication-preservation direction:

```lean
theorem conjBy_mul_of_unit_cube_eq_one
    {a : Octonion} (ha_unit : normSq a = 1)
    (ha_cube : cube a = 1) (x y : Octonion) :
    conjBy a (x * y) = conjBy a x * conjBy a y := ...

theorem conjBy_mul_of_unit_cube_eq_neg_one
    {a : Octonion} (ha_unit : normSq a = 1)
    (ha_cube : cube a = -1) (x y : Octonion) :
    conjBy a (x * y) = conjBy a x * conjBy a y := ...
```

These are the core challenge. Prefer a proof using Moufang identities. If that
stalls, a coordinate proof is acceptable, but keep the comments clear that it
is a coordinate verification of the Conway-Smith/Yokota criterion rather than
the conceptual final proof.

Important: do not drop `ha_unit`. The theorem is about normalized octonions.
Do not replace `conj a` with an abstract inverse unless you have defined and
proved the inverse facts.

## Phase 3: Order-Three Consequences

If Phase 2 succeeds, prove that the induced map has order three:

```lean
theorem conjBy_iter_three_of_unit_cube_eq_one
    {a : Octonion} (ha_unit : normSq a = 1)
    (ha_cube : cube a = 1) (x : Octonion) :
    conjBy a (conjBy a (conjBy a x)) = x := ...

theorem conjBy_iter_three_of_unit_cube_eq_neg_one
    {a : Octonion} (ha_unit : normSq a = 1)
    (ha_cube : cube a = -1) (x : Octonion) :
    conjBy a (conjBy a (conjBy a x)) = x := ...
```

This may require proving that repeated conjugation composes as expected under
the hypotheses, or proving it directly by Moufang/coordinate expansion.

## Phase 4: Triality Companion Maps

This phase is the most ambitious and the most mathematically interesting.
Define a companion-map predicate:

```lean
def HasCompanions
    (gamma : Octonion -> Octonion) (p q : Octonion) : Prop :=
  forall x y : Octonion, gamma (x * y) = (gamma x * p) * (q * gamma y)
```

Then prove Conway-Smith-style companion identities for unit octonions.
The intended shape is:

```lean
theorem leftMul_has_companions
    {a : Octonion} (ha_unit : normSq a = 1) :
    HasCompanions (fun x => a * x) a ((conj a * conj a)) := ...

theorem rightMul_has_companions
    {a : Octonion} (ha_unit : normSq a = 1) :
    HasCompanions (fun x => x * a) ((conj a * conj a)) a := ...

theorem conjBy_has_companions
    {a : Octonion} (ha_unit : normSq a = 1) :
    HasCompanions (conjBy a) (cube a) (cube (conj a)) := ...
```

If the exact left/right companion order above is wrong for this project's
parentheses, find the Lean-true corrected version, prove it, and document the
correction. Do not force a false statement by changing definitions silently.

Once `conjBy_has_companions` is proved, Phase 2 should become easy when
`cube a = 1` or `cube a = -1`, because the companions are central scalars and
cancel.

## Phase 5: Optional Converse or Counterexample Infrastructure

If the forward direction is done and there is still room, attempt a precise
statement of the converse:

```lean
def PreservesMul (gamma : Octonion -> Octonion) : Prop :=
  forall x y : Octonion, gamma (x * y) = gamma x * gamma y

theorem cube_eq_scalar_of_conjBy_preserves_mul
    {a : Octonion} (ha_unit : normSq a = 1)
    (h_mul : PreservesMul (conjBy a)) :
    cube a = 1 \/ cube a = -1 := ...
```

This is likely very hard. A useful partial result is enough:

- prove the statement for `a` in the real span of `1` and a fixed basis
  imaginary unit;
- or prove finite basis constraints showing that multiplication preservation
  forces `cube a` to commute with all basis elements;
- or leave a detailed handoff note explaining the exact stuck goal.

## Acceptable Fallbacks

If the full companion route is too hard, still try to deliver trusted progress:

1. `cube`, `conjBy`, unit inverse lemmas, and linearity.
2. At least one of the two direct automorphism theorems.
3. At least one order-three theorem.
4. A small finite-basis lemma demonstrating that arbitrary imaginary-unit
   conjugation is not the target theorem, e.g. an explicit counterexample or
   warning theorem if easy.

Do not insert `sorry` into trusted code. If a proof is not finished, put the
attempt in a comment or in an explicitly marked draft section in the task
output, not in a trusted Lean file.

## Verification Requirements

Run at least:

```bash
lake env lean PhysicsSM/Algebra/Octonion/TrialityCompanions.lean
lake env lean PhysicsSM/Algebra/Octonion/Moufang.lean
lake env lean PhysicsSM/Algebra/Octonion/Norm.lean
```

If possible, also run:

```bash
lake build
```

No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe def` in trusted code.

## Success Criteria

Minimum useful success:

- A trusted `TrialityCompanions.lean` module with `cube`, `conjBy`, unit
  inverse lemmas, and several clean Moufang-powered reassociation lemmas.

Strong success:

- The direct `conjBy_mul_of_unit_cube_eq_one` and
  `conjBy_mul_of_unit_cube_eq_neg_one` theorems are kernel-checked.
- At least one order-three theorem is proved.

Excellent success:

- `HasCompanions` is defined and the left/right/conjugation companion theorems
  are proved with documented parenthesization.

Moonshot success:

- The forward Conway-Smith/Yokota criterion is proved conceptually from
  companion maps, and a serious partial converse is formalized or isolated with
  a precise handoff note.

## Sources

- John C. Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), Sections 1
  and 4.
- John C. Baez, "A Shadow of Triality?", n-Category Cafe, September 2025.
- J. H. Conway and D. A. Smith, "On Quaternions and Octonions", Chapter 8.
- Ichiro Yokota, "Exceptional Lie Groups", triality and octonion conjugation
  criteria.

## Final Report Requested From Aristotle

Please report:

- files changed;
- theorem names proved;
- whether any theorem was proved by coordinate expansion rather than Moufang
  reasoning;
- exact commands run;
- any failed theorem statements and why they failed;
- any remaining handoff goals.
