# Aristotle task: h₃(O) trace form positive definiteness

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `4ee25e3e-15e3-4c6e-bdad-32159b487958`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave2-20260531`
**Output**: `AgentTasks/aristotle-output/jordan-traceform-posdef-20260531`
**Type**: Euclidean Jordan algebra structural theorem

## Goal

Prove that the trace bilinear form on `h₃(𝕆)` is positive definite:

```lean
theorem traceForm_posDef (a : H3O) (ha : a ≠ 0) :
    0 < traceForm a a
```

and the non-strict version:

```lean
theorem traceForm_nonneg (a : H3O) :
    0 ≤ traceForm a a

theorem traceForm_eq_zero_iff (a : H3O) :
    traceForm a a = 0 ↔ a = 0
```

Add these theorems to:

```text
PhysicsSM/Algebra/Jordan/TraceForm.lean
```

in the namespace `PhysicsSM.Algebra.Jordan.H3O`.

If the file remains sorry-free, rebuild:

```bash
lake build PhysicsSM.Algebra.Jordan.TraceForm
```

## Mathematical context

The exceptional Jordan algebra `h₃(𝕆)` (the Albert algebra) is a
**Euclidean Jordan algebra**: its trace form `T(A, B) = tr(A ∘ B)` is a
positive-definite symmetric bilinear form. This is the key property that
makes `h₃(𝕆)` a "Euclidean" Jordan algebra (as opposed to a non-compact
one). The positive definiteness is needed for the DVT/Baez route to the
Standard Model gauge group.

## Existing infrastructure

The file `PhysicsSM/Algebra/Jordan/TraceForm.lean` already has:

- `H3O.traceForm : H3O → H3O → ℝ` — the trace bilinear form
  `T(A,B) = tr(A ∘ B)` where `∘` is the Jordan product.
- `traceForm_symm`, `traceForm_add_left`, `traceForm_smul_left` — basic
  bilinearity and symmetry.
- `traceForm_orthogonal (hb : InStandardB b) (hc : InComplementOfB c) :
    traceForm b c = 0` — `h₃(ℂ)` and its complement are orthogonal.

The file `PhysicsSM/Algebra/Jordan/H3O.lean` defines `H3O` with fields:
`alpha beta gamma : ℝ` (diagonal entries) and `x y z : Octonion`
(upper-triangular off-diagonal entries), with the self-adjointness
constraint enforced.

The Jordan product and `jordanIdentity_H3O` are in
`PhysicsSM/Algebra/Jordan/H3OJordan.lean` (and its split files).

The octonion squared norm `Octonion.normSq` is in
`PhysicsSM/Algebra/Octonion/Norm.lean`.

## Informal proof sketch

The key is to expand `traceForm a a = tr(a ∘ a) = tr(a²)` explicitly.

For `a : H3O` with diagonal entries `α, β, γ ∈ ℝ` and off-diagonal
entries `x, y, z ∈ 𝕆` (where x is entry (1,2), y is (1,3), z is (2,3)):

```
tr(a²) = (a²)₁₁ + (a²)₂₂ + (a²)₃₃
       = (α² + normSq x + normSq y)
       + (normSq x + β² + normSq z)
       + (normSq y + normSq z + γ²)
       = α² + β² + γ² + 2*normSq x + 2*normSq y + 2*normSq z
```

This is a sum of squares of reals plus non-negative terms `normSq`,
so it is:
- `≥ 0` always, and
- `= 0` iff `α = β = γ = 0` and `x = y = z = 0`, i.e., `a = 0`.

The Jordan square `a² = a ∘ a` here means `(a * a + a * a) / 2 = a * a`
(self-adjoint matrices satisfy `a ∘ a = a²` by commutativity).

The key Lean approach is:
1. Unfold `traceForm` via `jordanProduct` and the explicit `H3OJordan`
   coordinate formulas.
2. Use `Octonion.normSq_nonneg` and `sq_nonneg` to bound each term.
3. For strict positivity, case-split on which component is nonzero.

## Additional corollary to prove

```lean
/-- The trace form induces an inner product on h₃(𝕆). -/
noncomputable def traceFormInner : H3O →ₗ[ℝ] H3O →ₗ[ℝ] ℝ :=
  ... -- packaging traceForm as a bilinear map

/-- `traceForm a a = 0` implies `a = 0`. -/
theorem traceForm_zero_of_self_zero (a : H3O)
    (h : traceForm a a = 0) : a = 0
```

## Claim boundary

This file proves positive definiteness of the trace form as a finite
algebraic fact. It does **not** claim the classification of Euclidean
Jordan algebras, the Koecher–Vinberg theorem, or the Standard Model
gauge group identification.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Use explicit coordinate expansions rather than abstract ring lemmas
  where coordinates make the inequality transparent.
- Proofs may use `positivity`, `norm_num`, `nlinarith`, or `linarith`
  for the numerical inequalities.
- Do not restructure the existing `TraceForm.lean` declarations.

## Verification

```bash
lake env lean PhysicsSM/Algebra/Jordan/TraceForm.lean
lake build PhysicsSM.Algebra.Jordan.TraceForm
```
