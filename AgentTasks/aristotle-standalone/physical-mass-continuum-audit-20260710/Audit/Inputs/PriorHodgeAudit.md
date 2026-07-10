# HODGE_CORRECTION_AUDIT.md

Independent audit of the positive-Hodge class-cost correction.

Scope: the two source modules

- `Audit/Inputs/PositiveHodgeRayleigh.lean`
  (namespace `PhysicsSM.Draft.NullEdge.PositiveHodgeRayleigh`, "the Rayleigh module")
- `Audit/Inputs/PositiveHodgeClassCostNoGo.lean`
  (namespace `PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeClassCostNoGo`, "the correction")

## Method and reproduction

Both modules were compiled from scratch under the pinned toolchain
(`leanprover/lean4:v4.28.0`, Mathlib `v4.28.0`). Compilable copies live at
`PhysicsSM/Draft/NullEdge/Carrier/PositiveHodgeRayleigh.lean` and
`.../PositiveHodgeClassCostNoGo.lean`. Every theorem in both files elaborates
with **no `sorry`/`admit`** and every declaration's `#print axioms` reports only
`[propext, Classical.choice, Quot.sound]` (the in-file `#guard_msgs` footprint
guards all pass). So the formal claims, *as stated*, are all genuinely proved.

Three additional, independently re-derived checks that back the findings below
are formalized and compiled in
`PhysicsSM/Draft/NullEdge/Carrier/HodgeAuditChecks.lean`
(`rayleigh_witness_norm_not_constant`, `rayleigh_witness_quotient_constant`,
`witnessB_e0_globally_null`), also axiom-clean.

The audit distinguishes two questions the request asks:
(i) are the theorems true? — **yes, all of them**; and
(ii) do they support the manuscript's *interpretive* sentences about mass? —
**partially**; the gaps are normalization, positivity, and non-degeneracy of the
Krein form, detailed below.

---

## Findings, ordered by severity

### F1 (HIGH, normalization gap). The Rayleigh "variational minimum" is over an *unnormalized* pairing, and the true Rayleigh quotient is already constant.

Declarations: `PositiveHodgeRayleigh.variational_mass_isLeast`,
`PositiveHodgeRayleigh.witness`, `PositiveHodgeRayleigh.norm_const_on_class`.

`variational_mass_isLeast` proves `IsLeast {c | ∃ χ, c = B (h+Qχ) (S (h+Qχ))} μ2`.
The minimized quantity is the bare bilinear pairing `B v (S v)`, **not** the
Rayleigh quotient `B v (S v) / B v v` that a "spectral cost / mass" must be.
The only result guaranteeing a constant denominator, `norm_const_on_class`,
*requires* nilpotence `Q ∘ₗ Q = 0`. The flagship `witness` uses `cexQ =
diag(1,0,0)`, a projection with `Q² = Q ≠ 0`, so `norm_const_on_class` does not
apply to it and the norm genuinely varies across the class:

- verified `rayleigh_witness_norm_not_constant`: at the harmonic rep `B h h = 1`,
  while at `h + Q e0` the norm is `2`.

Thus the "least element `μ2 = 4/25`" is selected among representatives of
*different* Krein norm, which is not a well-posed Rayleigh minimization. Worse,
once one divides by the norm the apparent minimization disappears:

- verified `rayleigh_witness_quotient_constant`: at `h + Q e0`, cost `= 8/25`,
  norm `= 2`, so the quotient is exactly `4/25` — identical to the harmonic
  value.

So the entire "nontrivial minimum attained at the harmonic representative" story
is an artifact of dropping the normalization denominator. This is the sharpest
statement of what the correction is reacting to: the defect is not merely "`Q` is
not nilpotent," it is "the functional being minimized is missing its `/ B v v`."

### F2 (HIGH, central claim — SUPPORTED). Under `Q²=0` + radicality + `[S,Q]=0` the class cost is identically `μ2`.

Declarations: `PositiveHodgeClassCostNoGo.exact_spectral_cost_zero`,
`class_cost_constant`, `class_cost_set_eq_singleton`.

The mathematics is correct and the proofs are clean:
`Q² = 0` makes every exact vector `Q χ` closed (`Q (Q χ) = 0`); descent
`S (Q χ) = Q (S χ)` makes `S (Q χ)` exact hence closed; radicality
(`RadicalProperty`, direction `.1`) then kills `B (Q χ) (S (Q χ)) = 0`. Feeding
this into the exact-cost split gives `B (h+Qχ) (S (h+Qχ)) = μ2` for all `χ`, and
the cost set is the singleton `{μ2}`. This is the strongest *supported* result in
the package and correctly refutes the variational-minimization reading of F1
under genuine cohomological hypotheses. (Nilpotence is load-bearing: it is what
promotes "exact" to "closed" so radicality can be applied.)

### F3 (MEDIUM, non-degeneracy / cohomology gap). The nilpotent positive witness uses a *degenerate* Krein form; its radical property holds vacuously.

Declarations: `PositiveHodgeClassCostNoGo.witnessB`, `witnessQ`, `witnessS`,
`nilpotent_positive_class_witness`.

`witnessB = diag(0,1,1)` is degenerate. The exact direction `e0 = witnessQ e1`
is not merely Krein-orthogonal to closed vectors — it is **globally** `B`-null:

- verified `witnessB_e0_globally_null`: `witnessB e0 v = 0` for *all* `v`.

Consequently `RadicalProperty witnessB witnessQ` is satisfied trivially — the
supplied proof discharges it by `simp` and never uses the closedness hypothesis
`hy`. The surviving "positive class" `e2` (`B e2 e2 = 1`) lives in a separate,
nondegenerate `diag(1)` block that never interacts with the exact/closed
structure. So the witness demonstrates class-cost constancy on a decoupled
positive line, but it does **not** exhibit the intended Kugo–Ojima situation
(an indefinite, nondegenerate Krein form with a genuine BRST quartet, where the
exact null vector pairs nontrivially with a *non-closed* partner). The abstract
theorems F2 are unaffected — they assume `RadicalProperty` as a hypothesis — but
the package provides no evidence that all four hypotheses (`Q²=0`, radicality,
`[S,Q]=0`, a *nondegenerate* positive Krein form) are jointly realizable.

### F4 (MEDIUM, positivity gap). Nothing in either module forces `μ2 ≥ 0`, so "positive spectral mass survives" is not established.

Declarations: `class_cost_constant`, `variational_mass_isLeast`,
`ghost_positivity_necessary`.

`μ2` is an arbitrary real throughout; `class_cost_constant` shows the class cost
*equals* `μ2` but never that it is nonnegative. Indeed `ghost_positivity_necessary`
constructs an instance with `μ2 = 0` and an exact direction of cost `−1`. The
ghost-positivity hypothesis `0 ≤ B (Q χ) (S (Q χ))` constrains only the *exact*
directions, not the harmonic value `μ2 = B h (S h)`. To claim a positive physical
mass one additionally needs `S` positive-semidefinite with respect to `B` on
closed vectors (equivalently `0 ≤ B h (S h)` with `B h h = 1`). This hypothesis
is absent, so the manuscript's "positive spectral mass survives" is unsupported
by the formal content.

### F5 (LOW, hypothesis footprint). Radicality is used one-sidedly; some listed hypotheses are decorative in specific lemmas.

- `exact_spectral_cost_zero` uses only `RadicalProperty … .1`; the symmetric
  half `.2` is never needed there.
- `class_cost_constant`/`class_cost_set_eq_singleton` thread `hnorm : B h h = 1`
  only to normalize the `B h (μ2 • h)` term; the constancy statement itself would
  hold with `B h h` in place of `1`. Not an error, but the "normalized" framing is
  cosmetic for these lemmas (contrast F1, where normalization is substantive).

### F6 (LOW, docstring overclaim). The Rayleigh module's stated "targets" overclaim relative to its own witness.

The Rayleigh docstring asserts target 1 makes "the Krein normalization CONSTANT
across a class" and target 3 that "mass is the least positive Hodge cost, and the
min is attained." Both readings fail for the module's own `witness`, whose `Q` is
not nilpotent: normalization is *not* constant there (F1), and the "minimum" is
an unnormalized artifact. `landed_projection_witness_not_nilpotent`
(in the correction) formally records exactly this boundary: `cexQ ∘ₗ cexQ ≠ 0`.
This declaration is correct and is the right disclaimer to attach to the Rayleigh
witness.

---

## Strongest supported vs. unsupported manuscript sentences

- **Strongest SUPPORTED sentence** (correction docstring): *"Under the actual
  cohomological hypotheses `Q² = 0`, Kugo–Ojima radicality, and descent
  `[S,Q] = 0`, an exact direction is closed and its image under `S` is exact.
  Its spectral pairing therefore vanishes, so the cost is constant across the
  cohomology class rather than nontrivially minimized by a preferred
  representative."* Fully backed by `exact_spectral_cost_zero` +
  `class_cost_constant` + `class_cost_set_eq_singleton` (verified, axiom-clean).

- **Strongest UNSUPPORTED / overstated sentence** (correction docstring):
  *"Scientific consequence: positive spectral mass survives."* Positivity of the
  invariant `μ2` is nowhere proved (F4), and the sole "positive" witness achieves
  positivity only on a decoupled nondegenerate block using a degenerate Krein
  form (F3). The formal content supports "the class cost is a well-defined
  constant `μ2`," not "that constant is a *positive* physical mass." The Rayleigh
  docstring's "mass is the least positive Hodge cost, and the min is attained" is
  similarly overstated (F1).

---

## Next theorem needed to connect the class invariant to physical mass

The results establish a constant `μ2` per fixed closed eigen-representative `h`.
To upgrade this to a physical mass one needs the invariant to be a function of
the cohomology *class* and to be positive. Concretely, the next theorem to prove
is well-definedness on the quotient plus positivity:

```lean
-- (a) descent to cohomology: the cost depends only on the class in ker Q / range Q,
--     independent of which closed unit eigen-representative is chosen.
theorem class_mass_wellDefined
    (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (Q S : V →ₗ[ℝ] V)
    (hrad : RadicalProperty B Q) (hQQ : Q ∘ₗ Q = 0) (hcomm : S ∘ₗ Q = Q ∘ₗ S)
    (h h' : V) (hcl : Q h = 0) (hcl' : Q h' = 0)
    (μ2 μ2' : ℝ) (heig : S h = μ2 • h) (heig' : S h' = μ2' • h')
    (hn : B h h = 1) (hn' : B h' h' = 1)
    (hcohom : ∃ χ, h' = h + Q χ) :        -- same class
    μ2' = μ2 := by sorry

-- (b) positivity of the mass from S being positive-semidefinite w.r.t. B on
--     closed vectors (the genuine ghost-positivity, applied to h itself):
theorem class_mass_nonneg
    (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (S : V →ₗ[ℝ] V)
    (h : V) (μ2 : ℝ) (heig : S h = μ2 • h) (hn : B h h = 1)
    (hpos : 0 ≤ B h (S h)) :
    0 ≤ μ2 := by sorry
```

Proving (a) makes the assignment `class ↦ μ2` a genuine function on
`ker Q ⧸ LinearMap.range Q` (the constraint cohomology), and (b) supplies the
`m² ≥ 0` needed to call it a mass. A faithful physical model would additionally
have to instantiate all hypotheses with a *nondegenerate* indefinite Krein form
(closing F3) — e.g. a BRST quartet where the exact null vector `Q χ` pairs
nontrivially with a non-closed partner — and provide a Hodge-decomposition
existence result guaranteeing a harmonic eigen-representative `h` exists in each
class (neither is present in Mathlib or these files, and both must be built).
