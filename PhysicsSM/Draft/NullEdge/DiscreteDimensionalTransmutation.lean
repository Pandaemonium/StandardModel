import Mathlib

/-!
# Exact discrete dimensional transmutation

For the supplied positive discrete flow

```text
g(k) = g0 / (1 + k * b * g0),
```

this module proves the exact recursion, strict decrease to zero, conservation
of `1 / (b * g(k)) - k`, and the associated step-independent exponential
scale.  It also proves that the generated scale is flatter than every power
of the weak coupling, making its nonperturbative character precise.

The map and coefficient `b` are inputs.  These results establish an exact
finite transmutation mechanism; they do not derive a gauge-theory beta
function, identify a physical coupling, or predict a dimensionful value.

Provenance: target designed during the 2026-07-10 theory-completion audit.
Proofs clean-room integrated from Aristotle project
`8ec5d15e-25b3-47d6-a181-ea250d8ad7b2` and checked under Lean 4.28.0.
-/

namespace PhysicsSM.Draft.NullEdge.DiscreteDimensionalTransmutation

/-- Exact solution of the supplied positive discrete flow. -/
noncomputable def gflow (b g0 : Real) (k : Nat) : Real :=
  g0 / (1 + k * b * g0)

/-- The closed form solves the recursion and remains positive. -/
theorem flow_closed_form (b g0 : Real) (hb : 0 < b) (hg : 0 < g0)
    (k : Nat) :
    gflow b g0 (k + 1) = gflow b g0 k / (1 + b * gflow b g0 k) ∧
      0 < gflow b g0 k := by
  unfold gflow
  field_simp
  exact ⟨by push_cast; ring, by norm_num; positivity⟩

/-- The flow is strictly decreasing and tends to zero. -/
theorem asymptotic_freedom (b g0 : Real) (hb : 0 < b) (hg : 0 < g0) :
    (forall k : Nat, gflow b g0 (k + 1) < gflow b g0 k) ∧
      Filter.Tendsto (fun k : Nat => gflow b g0 k)
        Filter.atTop (nhds 0) := by
  unfold gflow
  exact ⟨
    fun k => by
      gcongr
      norm_num,
    tendsto_const_nhds.div_atTop
      (tendsto_const_nhds.add_atTop
        (tendsto_natCast_atTop_atTop.atTop_mul_const (by positivity) |>
          Filter.Tendsto.atTop_mul_const (by positivity)))⟩

/-- Exact inverse-coupling invariant of every discrete step. -/
theorem exact_invariant (b g0 : Real) (hb : 0 < b) (hg : 0 < g0)
    (k : Nat) :
    1 / (b * gflow b g0 k) - k = 1 / (b * g0) := by
  have hden : (0 : Real) < 1 + k * b * g0 := by positivity
  unfold gflow
  field_simp
  ring

/-- The associated exponential scale is independent of the step. -/
theorem invariant_scale (b g0 : Real) (hb : 0 < b) (hg : 0 < g0)
    (k : Nat) :
    Real.exp ((k : Real) - 1 / (b * gflow b g0 k)) =
      Real.exp (-(1 / (b * g0))) := by
  have h := exact_invariant b g0 hb hg k
  rw [show (k : Real) - 1 / (b * gflow b g0 k) =
      -(1 / (b * g0)) by linarith]

/-- The generated scale vanishes faster than every power of the weak
coupling. -/
theorem nonperturbative_flatness (b : Real) (hb : 0 < b) (m : Nat) :
    Filter.Tendsto
      (fun g : Real => Real.exp (-(1 / (b * g))) / g ^ m)
      (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) := by
  suffices hSubst : Filter.Tendsto
      (fun u => Real.exp (-u) * (b * u) ^ m) Filter.atTop (nhds 0) by
    have h := hSubst.comp
      (show Filter.Tendsto (fun g : Real => (b * g)⁻¹)
          (nhdsWithin 0 (Set.Ioi 0)) Filter.atTop from by
        refine Filter.Tendsto.inv_tendsto_nhdsGT_zero ?_
        exact Filter.Tendsto.inf
          (Continuous.tendsto' (by continuity) _ _ (by norm_num)) (by aesop))
    convert h using 2 <;> norm_num <;> ring
    norm_num [hb.ne']
  convert (Real.tendsto_pow_mul_exp_neg_atTop_nhds_zero m) |>
      Filter.Tendsto.const_mul (b ^ m) using 2 <;> ring!

/-- Exact rational nondegeneracy control: `1/3 -> 1/4 -> 1/5`. -/
theorem rational_witness :
    gflow 1 (1 / 3) 1 = 1 / 4 ∧
      gflow 1 (1 / 3) 2 = 1 / 5 ∧
      (forall k : Nat, k <= 2 -> 1 / gflow 1 (1 / 3) k - k = 3) := by
  exact ⟨by norm_num [gflow], by norm_num [gflow], fun k hk => by
    interval_cases k <;> norm_num [gflow]⟩

end PhysicsSM.Draft.NullEdge.DiscreteDimensionalTransmutation

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.DiscreteDimensionalTransmutation.flow_closed_form' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DiscreteDimensionalTransmutation.flow_closed_form

/-- info: 'PhysicsSM.Draft.NullEdge.DiscreteDimensionalTransmutation.asymptotic_freedom' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DiscreteDimensionalTransmutation.asymptotic_freedom

/-- info: 'PhysicsSM.Draft.NullEdge.DiscreteDimensionalTransmutation.exact_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DiscreteDimensionalTransmutation.exact_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.DiscreteDimensionalTransmutation.invariant_scale' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DiscreteDimensionalTransmutation.invariant_scale

/-- info: 'PhysicsSM.Draft.NullEdge.DiscreteDimensionalTransmutation.nonperturbative_flatness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DiscreteDimensionalTransmutation.nonperturbative_flatness

/-- info: 'PhysicsSM.Draft.NullEdge.DiscreteDimensionalTransmutation.rational_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DiscreteDimensionalTransmutation.rational_witness
