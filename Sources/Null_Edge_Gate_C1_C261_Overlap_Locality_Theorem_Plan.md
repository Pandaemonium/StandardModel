# Gate C1 — task C261: overlap locality theorem plan

Date: 2026-06-29

Status: **discharged** as a finite-dimensional Lean theorem stack.

Lean module:

```text
PhysicsSM/Draft/NullEdge/GateC1/OverlapLocality.lean
```

## 1. Goal

The non-ultralocal release plan
(`Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md`) fixes the posture for
the overlap / Ginsparg–Wilson / sign-kernel lane:

> Overlap/Ginsparg-Wilson/sign kernels: treat exponential locality as a
> *sufficient theorem under gap/smoothness hypotheses*, not as the primitive
> null-edge control notion.

Task C261 turns that slogan into a precise, machine-checked statement: the
overlap sign kernel built from a finite-range lattice operator is exponentially
local, *as a theorem* derived from polynomial sign-approximation control.

## 2. Setting

Work over a finite set of `Site`s equipped with an abstract integer
pseudo-distance `D : SiteDist Site` (only `D.refl : d i i = 0` and the triangle
inequality `D.triangle` are used). Locality is measured against `D`.

* `IsRange D r M` — the finite-range predicate: `M i j = 0` whenever
  `r < D.d i j`.
* `ExpLocal D C q M` — the exponential-locality predicate:
  `‖M i j‖ ≤ C * q ^ (D.d i j)` for all `i j`.

## 3. Theorem stack (all proved, no `s o r r y`, only standard assumptions)

Finite-range algebra (the algebraic mechanism behind overlap locality):

```text
isRange_mono     range is monotone in r
isRange_zero     0 is range r
isRange_one      1 is range 0           (uses D.refl)
isRange_add      range r closed under +
isRange_smul     range r closed under • 
isRange_neg      range r closed under negation
isRange_sum      range r closed under finite sums
isRange_mul      IsRange r M → IsRange s N → IsRange (r+s) (M*N)   (uses D.triangle)
isRange_pow      IsRange r M → IsRange (n*r) (M^n)
isRange_aeval    deg p ≤ n → IsRange (n*r) (aeval M p)             (polynomial functional calculus)
```

Overlap surrogate:

```text
overlap_surrogate_finite_range
    gamma5 on-site (range 0), H range r, deg p ≤ n
  ⟹ Dov gamma5 (aeval H p)  is range  n*r
```

Locality vocabulary and the main theorem:

```text
expLocal_of_finite_range          finite range ⟹ exponential locality (q = 1 packaging)

sign_kernel_exp_locality_target   C261 main theorem
    H range r (r ≥ 1),
    p : ℕ → polynomials, deg (p n) ≤ n (linearly growing degree),
    ‖(eps - aeval H (p n)) i j‖ ≤ A · exp(-κ n)   (exponentially good approximants, κ from the gap)
  ⟹ ∃ C q, 0 < C ∧ 0 ≤ q ∧ q < 1 ∧ ExpLocal D C q eps
```

## 4. Proof mechanism of the main theorem

The degree-`n` polynomial approximant `aeval H (p n)` is forced by
`isRange_aeval` to vanish whenever `n*r < D.d i j`. Choosing the truncation
level `n ≈ dist(i,j)/r` makes the approximant entry vanish, so the exponential
approximation bound `A·exp(-κ n)` bounds `eps i j` itself. Optimizing `n`
converts that into geometric decay with rate `q = exp(-κ/r) < 1`; the
near-diagonal entries are bounded by the (finite) sum of all entry norms. This
is exactly "degree grows like gap⁻¹·log(1/ε) ⟹ exponential locality", made
rigorous in finite dimensions.

## 5. Relation to the broader release plan

* This is the overlap-lane companion to the algebraic Ginsparg–Wilson identity
  already in `OverlapGinspargWilson.lean` (`dov_ginsparg_wilson`).
* It supplies the "exponential locality as a sufficient theorem" brick the plan
  asks for, without making it the primitive control notion: locality here is a
  *consequence* of finite-range structure plus spectral (gap-driven)
  approximation data.
* The remaining physics inputs (that a genuine gapped Hermitian `H` has such
  exponentially good, linearly-growing-degree polynomial sign approximants) are
  the spectral-analysis hypotheses packaged as the theorem's premises; the
  kinematic conversion to locality is now fully verified.
