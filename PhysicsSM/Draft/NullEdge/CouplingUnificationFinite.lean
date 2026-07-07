import Mathlib

/-!
# Coupling unification: the finite affine/linear-algebra core (kernel grade)

This file formalizes the **finite, honest core** of one-loop gauge coupling
"unification".  We model each running coupling as an *affine* function of the
log-energy variable `t`:

```
gᵢ(t) = gᵢ(0) + bᵢ · t
```

with the standard rational one-loop Standard-Model beta coefficients
`b₁ = 41/10`, `b₂ = -19/6`, `b₃ = -7` (GUT normalization for the hypercharge).

We prove, over the exact field `ℚ`:

* `two_lines_unique_meet` — two lines with different slopes meet at a **unique**
  point (so, in particular, if the three slopes are pairwise distinct — a
  strengthening of "not all parallel" — then any two of the three meet at a
  unique point, `pairwise_meet`);
* `three_concurrent_iff` — the **exact rational condition** under which all
  three lines pass through a single point (a unification scale `t*`);
* `exact_unification` — a concrete rational instance (SM slopes, chosen
  intercepts) where the three couplings coincide at one scale `t* = 2`;
* `generic_not_concurrent` / `generic_three_distinct_meets` — the honest general
  fact that generic intercepts do **not** unify: the three lines meet pairwise
  at three *distinct* points.

**Honest label.**  This is a finite affine / linear-algebra statement about
one-loop running.  It is *not* a derivation of grand-unified-theory unification,
nor of the physical values of the Standard Model couplings, nor of anything
beyond the elementary geometry of three straight lines in the plane.
-/

namespace PhysicsSM.Draft.NullEdge.CouplingUnificationFinite

/-- A one-loop running coupling as an affine function of log-energy `t`:
`run a b t = a + b · t`, with `a = gᵢ(0)` the value at reference scale and
`b = bᵢ` the one-loop beta coefficient (slope). -/
def run (a b t : ℚ) : ℚ := a + b * t

@[simp] theorem run_apply (a b t : ℚ) : run a b t = a + b * t := rfl

/-- The candidate meeting point (in `t`) of two lines of slopes `b₁ ≠ b₂`. -/
def meetT (a₁ b₁ a₂ b₂ : ℚ) : ℚ := (a₂ - a₁) / (b₁ - b₂)

/-- At `meetT`, the two lines take the same value. -/
theorem meetT_spec {a₁ b₁ a₂ b₂ : ℚ} (h : b₁ ≠ b₂) :
    run a₁ b₁ (meetT a₁ b₁ a₂ b₂) = run a₂ b₂ (meetT a₁ b₁ a₂ b₂) := by
  have hb : b₁ - b₂ ≠ 0 := sub_ne_zero.mpr h
  unfold run meetT
  field_simp
  ring

/-- **Two non-parallel lines meet at a unique point.**  If the slopes differ,
there is exactly one `t` at which the two affine couplings coincide. -/
theorem two_lines_unique_meet {a₁ b₁ a₂ b₂ : ℚ} (h : b₁ ≠ b₂) :
    ∃! t : ℚ, run a₁ b₁ t = run a₂ b₂ t := by
  have hb : b₁ - b₂ ≠ 0 := sub_ne_zero.mpr h
  refine ⟨meetT a₁ b₁ a₂ b₂, meetT_spec h, ?_⟩
  intro y hy
  unfold run at hy
  unfold meetT
  field_simp
  linarith [hy]

/-- **Pairwise non-parallel ⇒ each pair meets uniquely.**  If the three slopes
are pairwise distinct (a strengthening of "not all three parallel", and exactly
the condition needed), then each of the three pairs of couplings meets at a
unique point. -/
theorem pairwise_meet {a₁ b₁ a₂ b₂ a₃ b₃ : ℚ}
    (h12 : b₁ ≠ b₂) (h13 : b₁ ≠ b₃) (h23 : b₂ ≠ b₃) :
    (∃! t : ℚ, run a₁ b₁ t = run a₂ b₂ t) ∧
    (∃! t : ℚ, run a₁ b₁ t = run a₃ b₃ t) ∧
    (∃! t : ℚ, run a₂ b₂ t = run a₃ b₃ t) :=
  ⟨two_lines_unique_meet h12, two_lines_unique_meet h13, two_lines_unique_meet h23⟩

/-- **The exact concurrency condition.**  As long as lines `1` and `2` are not
parallel (`b₁ ≠ b₂`), the three lines pass through a single common point (a
unification scale `t*`) if and only if the rational linear-algebra condition

`(a₁ - a₂)·(b₃ - b₁) = (a₁ - a₃)·(b₂ - b₁)`

holds.  This is precisely the vanishing of the `3×3` determinant expressing
consistency of the overdetermined linear system `gᵢ(t) = y` (three equations,
two unknowns `t, y`).  (The single hypothesis `b₁ ≠ b₂` suffices: it turns out
no further non-parallelism assumption is needed for the equivalence.) -/
theorem three_concurrent_iff {a₁ b₁ a₂ b₂ a₃ b₃ : ℚ}
    (h12 : b₁ ≠ b₂) :
    (∃ t : ℚ, run a₁ b₁ t = run a₂ b₂ t ∧ run a₂ b₂ t = run a₃ b₃ t) ↔
      (a₁ - a₂) * (b₃ - b₁) = (a₁ - a₃) * (b₂ - b₁) := by
  have hb12 : b₁ - b₂ ≠ 0 := sub_ne_zero.mpr h12
  constructor
  · rintro ⟨t, ht1, ht2⟩
    unfold run at ht1 ht2
    linear_combination (b₃ - b₂) * ht1 + (b₁ - b₂) * ht2
  · intro hcond
    have key : (a₂ - a₁) * (b₂ - b₃) = (a₃ - a₂) * (b₁ - b₂) := by linear_combination hcond
    refine ⟨(a₂ - a₁) / (b₁ - b₂), ?_, ?_⟩
    · unfold run; field_simp; ring
    · have expand :
          (run a₂ b₂ ((a₂ - a₁) / (b₁ - b₂)) - run a₃ b₃ ((a₂ - a₁) / (b₁ - b₂))) * (b₁ - b₂)
            = (a₂ - a₃) * (b₁ - b₂) + (b₂ - b₃) * (a₂ - a₁) := by
        unfold run; field_simp; ring
      have zero : (a₂ - a₃) * (b₁ - b₂) + (b₂ - b₃) * (a₂ - a₁) = 0 := by
        linear_combination key
      rcases mul_eq_zero.mp (expand.trans zero) with h | h
      · linarith [sub_eq_zero.mp h]
      · exact absurd h hb12

/-!
## The Standard-Model one-loop beta coefficients (GUT normalization)
-/

/-- SM one-loop coefficient for `U(1)` (GUT-normalized hypercharge). -/
def smB1 : ℚ := 41 / 10
/-- SM one-loop coefficient for `SU(2)`. -/
def smB2 : ℚ := -19 / 6
/-- SM one-loop coefficient for `SU(3)`. -/
def smB3 : ℚ := -7

theorem smB1_ne_smB2 : smB1 ≠ smB2 := by unfold smB1 smB2; norm_num
theorem smB1_ne_smB3 : smB1 ≠ smB3 := by unfold smB1 smB3; norm_num
theorem smB2_ne_smB3 : smB2 ≠ smB3 := by unfold smB2 smB3; norm_num

/-- The three SM slopes are pairwise distinct, so **any two** SM couplings (with
arbitrary intercepts) meet at a unique point. -/
theorem sm_pairwise_meet (a₁ a₂ a₃ : ℚ) :
    (∃! t : ℚ, run a₁ smB1 t = run a₂ smB2 t) ∧
    (∃! t : ℚ, run a₁ smB1 t = run a₃ smB3 t) ∧
    (∃! t : ℚ, run a₂ smB2 t = run a₃ smB3 t) :=
  pairwise_meet smB1_ne_smB2 smB1_ne_smB3 smB2_ne_smB3

/-!
## A concrete exact-unification instance

With the SM slopes and intercepts chosen as `aᵢ = -2·bᵢ`, all three couplings
vanish (and hence coincide) at the single scale `t* = 2`.
-/

/-- Chosen intercept for line 1 giving exact unification at `t* = 2`. -/
def uA1 : ℚ := -2 * smB1
/-- Chosen intercept for line 2 giving exact unification at `t* = 2`. -/
def uA2 : ℚ := -2 * smB2
/-- Chosen intercept for line 3 giving exact unification at `t* = 2`. -/
def uA3 : ℚ := -2 * smB3

/-- **Exact unification instance.**  For the SM slopes and the intercepts
`uA₁, uA₂, uA₃`, the three couplings coincide (all equal to `0`) at the single
unification scale `t* = 2`. -/
theorem exact_unification :
    ∃ t : ℚ, run uA1 smB1 t = run uA2 smB2 t ∧
             run uA2 smB2 t = run uA3 smB3 t ∧
             run uA1 smB1 t = 0 := by
  refine ⟨2, ?_, ?_, ?_⟩ <;>
    simp only [run_apply, uA1, uA2, uA3, smB1, smB2, smB3] <;> norm_num

/-- The unification is also *unique* in `t` (as it must be, the slopes being
pairwise distinct): `t* = 2` is the only common scale. -/
theorem exact_unification_unique :
    ∃! t : ℚ, run uA1 smB1 t = run uA2 smB2 t ∧ run uA2 smB2 t = run uA3 smB3 t := by
  refine ⟨2, ?_, ?_⟩
  · refine ⟨?_, ?_⟩ <;>
      simp only [run_apply, uA1, uA2, uA3, smB1, smB2, smB3] <;> norm_num
  · rintro y ⟨hy, -⟩
    have := (two_lines_unique_meet (a₁ := uA1) (b₁ := smB1) (a₂ := uA2) (b₂ := smB2)
      smB1_ne_smB2).unique (y₁ := y) (y₂ := 2) hy
    apply this
    simp only [run_apply, uA1, uA2, smB1, smB2]; norm_num

/-!
## Generic non-unification (honest general fact)

With the SM slopes but *generic* intercepts (`a₁, a₂, a₃ = 1, 2, 3`) the three
lines do **not** pass through a common point: they meet pairwise at three
*distinct* scales.
-/

/-- **Generic intercepts do not unify.**  With SM slopes and intercepts
`1, 2, 3` there is no common scale `t` at which all three couplings agree. -/
theorem generic_not_concurrent :
    ¬ ∃ t : ℚ, run 1 smB1 t = run 2 smB2 t ∧ run 2 smB2 t = run 3 smB3 t := by
  rw [three_concurrent_iff smB1_ne_smB2]
  simp only [smB1, smB2, smB3]
  norm_num

/-- **Three distinct pairwise meeting points.**  With SM slopes and intercepts
`1, 2, 3`, the three pairwise intersection scales are pairwise distinct. -/
theorem generic_three_distinct_meets :
    meetT 1 smB1 2 smB2 ≠ meetT 1 smB1 3 smB3 ∧
    meetT 1 smB1 2 smB2 ≠ meetT 2 smB2 3 smB3 ∧
    meetT 1 smB1 3 smB3 ≠ meetT 2 smB2 3 smB3 := by
  refine ⟨?_, ?_, ?_⟩ <;>
    simp only [meetT, smB1, smB2, smB3] <;> norm_num

end PhysicsSM.Draft.NullEdge.CouplingUnificationFinite
