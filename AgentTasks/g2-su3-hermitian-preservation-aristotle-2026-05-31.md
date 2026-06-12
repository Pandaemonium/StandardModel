# Aristotle task: G₂ stabilizer Hermitian preservation toward SU(3)

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `68da8354-d372-4d50-b96f-625692c580c5`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave2-20260531`
**Output**: `AgentTasks/aristotle-output/g2-hermitian-preservation-20260601`
**Integrated**: 2026-06-01
**Type**: Major advance toward Stab_{G₂}(e111) ≅ SU(3)

## Goal

This is a two-part job.

**Part A**: Extend `FixingE111MulLinear` with conjugation preservation and
prove that it implies octonion norm preservation.

**Part B**: Prove that any `FixingE111MulLinear` satisfying
`PreservesComplexTripleHermitian` satisfies `ActsAsSU3OnC3`.

### Part A: Conjugation preservation

Add `map_conj` to the `FixingE111MulLinear` structure in
`PhysicsSM/Algebra/Octonion/G2ComplexLine.lean`:

```lean
structure FixingE111MulLinear where
  toFun : Octonion → Octonion
  map_add : ∀ x y, toFun (x + y) = toFun x + toFun y
  map_smul : ∀ (r : ℝ) x, toFun (r • x) = r • toFun x
  map_one : toFun 1 = 1
  map_mul : ∀ x y, toFun (x * y) = toFun x * toFun y
  fixes_e111 : toFun e111 = e111
  -- NEW:
  map_conj : ∀ x, toFun (Octonion.conj x) = Octonion.conj (toFun x)
```

Then prove:

```lean
theorem FixingE111MulLinear.normSq_preserved
    (g : FixingE111MulLinear) (x : Octonion) :
    Octonion.normSq (g.toFun x) = Octonion.normSq x
```

**Proof sketch for `normSq_preserved`**: In the project octonions,
`normSq x * 1 = x * Octonion.conj x` (this should be a lemma in
`PhysicsSM.Algebra.Octonion.Norm` or derivable from it). Apply `g.toFun`
to both sides using `map_mul`, `map_conj`, and `map_smul`. Since
`g.map_one : g.toFun 1 = 1`, conclude `normSq x = normSq (g.toFun x)`.

The key equation: `g.toFun (normSq x • 1) = normSq x • g.toFun 1 = normSq x • 1`,
and `g.toFun (x * conj x) = g.toFun x * g.toFun (conj x) = g.toFun x * conj(g.toFun x)`.
So `normSq (g.toFun x) = normSq x`.

### Part B: Hermitian preservation from norm preservation

Create a new trusted file:

```text
PhysicsSM/Algebra/Octonion/G2HermitianPreservation.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2SU3Bridge
import PhysicsSM.Algebra.Octonion.G2ComplexLine
```

and namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

Prove:

```lean
/-- A `FixingE111MulLinear` map preserves the Hermitian inner product on
    `ComplexTriple`, hence acts as an element of U(3) on ℂ³. -/
theorem fixingE111MulLinear_preservesHermitian
    (g : FixingE111MulLinear) :
    PreservesComplexTripleHermitian g
```

and package:

```lean
/-- Any `FixingE111MulLinear` acts as an element of U(3) on ℂ³. -/
theorem fixingE111MulLinear_actsAsSU3
    (g : FixingE111MulLinear) :
    ActsAsSU3OnC3 g :=
  ⟨fixingE111MulLinear_preservesHermitian g⟩
```

**Proof sketch for `fixingE111MulLinear_preservesHermitian`**:

The Hermitian form `ComplexTriple.hermitian u v` equals the restriction of
the octonion polarized inner product to the complement. Specifically, the
map `g.onComplexTriple` is the restriction of `g.toFun` to `ComplexTriple`
(via `g.onComplexTriple = Octonion.toComplexTriple ∘ g.toFun ∘ ComplexTriple.toOctonion`).

Strategy 1 (via polarization):
- For elements `u v : ComplexTriple`, embed them as octonions via `toOctonion`.
- The octonion inner product (polarization of `normSq`) is:
  `⟨x, y⟩ = (normSq(x+y) - normSq x - normSq y) / 2`
- Since g preserves `normSq` (Part A), it preserves this inner product.
- The Hermitian form on `ComplexTriple` equals the real part of the
  complexified inner product, plus the imaginary part via the chosen
  imaginary unit `e111`.

Strategy 2 (direct coordinate calculation):
- `ComplexTriple.hermitian u v = starRingEnd ℂ (u.w1 * ...) + ...`
  (sum of conjugate-linear products of components)
- Since `g.onComplexTriple` is defined by coordinate action, and g preserves
  multiplication and conjugation, expand directly.

The most reliable path for Aristotle may be Strategy 2: unfold
`ComplexTriple.hermitian` and `g.onComplexTriple`, then use `g.map_mul`,
`g.map_conj`, and the coordinate preservation.

## Context files

All in namespace `PhysicsSM.Algebra.Octonion.G2ComplexLine`:

- `G2ComplexLine.lean`: defines `FixingE111MulLinear`; add `map_conj` here.
- `G2SU3Bridge.lean`: defines `PreservesComplexTripleHermitian`,
  `PreservesComplexTripleNorm`, `ActsAsSU3OnC3`.
- `G2ComplexTripleAction.lean`: defines `onComplexTriple`.
- `Norm.lean` / `Conjugation.lean`: `normSq`, `Octonion.conj`,
  `normSq_eq_mul_conj` or similar.

## Important

If the existing `G2ComplexLine.lean` already proves conjugation-related
results (e.g. `conj_action_on_complement`) that make the approach
cleaner, use them.

If adding `map_conj` to `FixingE111MulLinear` breaks existing downstream
code, add it as a separate stronger predicate instead:

```lean
structure FixingE111MulLinearWithConj extends FixingE111MulLinear where
  map_conj : ∀ x, toFun (Octonion.conj x) = Octonion.conj (toFun x)
```

and state the theorems in terms of this stronger type.

## Claim boundary

This job proves that `FixingE111MulLinear` (with conjugation preservation)
acts as U(3) on ℂ³. It does **not** prove:
- That every element of `Stab_{G₂}(e111)` satisfies `map_conj` (that
  would need G₂ group theory not yet in the project).
- That the map has determinant 1 (that would give SU(3) vs U(3)).
- The full isomorphism `Stab_{G₂}(e111) ≅ SU(3)`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- If the proofs are long, prefer named lemmas over one large proof.
- Add the new file to `PhysicsSM.lean` if sorry-free.

## Verification

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2ComplexLine.lean
lake env lean PhysicsSM/Algebra/Octonion/G2HermitianPreservation.lean
lake build PhysicsSM.Algebra.Octonion.G2HermitianPreservation
```
