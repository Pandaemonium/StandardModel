import Mathlib

/-!
# NullStrand.Ergodic.RefreshChain

Finite refresh-chain formulas for the exactly solvable lazy redraw kernel

```text
P = (1-r) I + r Pi
Pi_{omega omega'} = pi_{omega'}
```

These are algebraic building blocks for finite trajectory modules.  Following
Aristotle's review, row-stochasticity and mean preservation carry the explicit
simplex hypothesis on the target law.
-/

noncomputable section

namespace PhysicsSM.NullStrand.Ergodic

open scoped BigOperators
open Finset

variable {Ω : Type*} [Fintype Ω] [DecidableEq Ω]

/-- A finite one-simplex probability law for a target distribution `π`. -/
def SimplexLaw (π : Ω → ℝ) : Prop :=
  (∀ ω, 0 ≤ π ω) ∧ (∑ ω, π ω) = 1

/-- Lazy redraw kernel with refresh parameter `r`. -/
def refreshKernel (r : ℝ) (π : Ω → ℝ) : Matrix Ω Ω ℝ :=
  fun ω ω' => (1 - r) * (if ω = ω' then 1 else 0) + r * π ω'

/-- Mean with respect to the law `π`. -/
def refreshMean (π : Ω → ℝ) (f : Ω → ℝ) : ℝ :=
  ∑ ω, π ω * f ω

/-- One-step action of the refresh operator on observables. -/
def refreshStep (r : ℝ) (π : Ω → ℝ) (f : Ω → ℝ) : Ω → ℝ :=
  fun ω => ∑ ω', refreshKernel r π ω ω' * f ω'

/-- Each row is stochastic when the redraw law is normalized. -/
lemma refreshKernel_row_sum (r : ℝ) (π : Ω → ℝ) (hπ : SimplexLaw π) :
    ∀ ω, ∑ ω', refreshKernel r π ω ω' = 1 := by
  intro ω
  rcases hπ with ⟨_, hsum⟩
  have hDelta : (∑ ω', if ω = ω' then (1 : ℝ) else 0) = 1 := by
    simp
  calc
    ∑ ω', refreshKernel r π ω ω'
        = ∑ ω', ((1 - r) * (if ω = ω' then (1 : ℝ) else 0) + r * π ω') := by
          rfl
    _ = (∑ ω', (1 - r) * (if ω = ω' then (1 : ℝ) else 0)) +
          (∑ ω', r * π ω') := by
          rw [Finset.sum_add_distrib]
    _ = (1 - r) * (∑ ω', if ω = ω' then (1 : ℝ) else 0) +
          r * (∑ ω', π ω') := by
          rw [← Finset.mul_sum, ← Finset.mul_sum]
    _ = 1 := by
          rw [hDelta, hsum]
          ring

/-- Alias for row-stochasticity in convenient naming. -/
theorem refreshKernel_row_stochastic (r : ℝ) (π : Ω → ℝ) (hπ : SimplexLaw π) :
    ∀ ω, ∑ ω', refreshKernel r π ω ω' = 1 :=
  refreshKernel_row_sum r π hπ

/-- Stationarity of the target law `π` for the refresh kernel. -/
theorem refreshKernel_invariant
    (r : ℝ) (π : Ω → ℝ) (hπ : SimplexLaw π) :
    ∀ ω', ∑ ω, π ω * refreshKernel r π ω ω' = π ω' := by
  intro ω'
  rcases hπ with ⟨_, hsum⟩
  have hDelta :
      (∑ ω, π ω * (if ω = ω' then (1 : ℝ) else 0)) = π ω' := by
    calc
      (∑ ω, π ω * (if ω = ω' then (1 : ℝ) else 0))
          = ∑ ω, if ω = ω' then π ω else 0 := by
            refine Finset.sum_congr rfl ?_
            intro ω _hω
            by_cases h : ω = ω' <;> simp [h]
      _ = π ω' := by simp
  have hConst :
      (∑ ω, π ω * π ω') = π ω' * (∑ ω, π ω) := by
    rw [← Finset.sum_mul]
    ring
  calc
    ∑ ω, π ω * refreshKernel r π ω ω'
        = ∑ ω, π ω *
            ((1 - r) * (if ω = ω' then (1 : ℝ) else 0) + r * π ω') := by
          rfl
    _ = (1 - r) * (∑ ω, π ω * (if ω = ω' then (1 : ℝ) else 0)) +
          r * (∑ ω, π ω * π ω') := by
          calc
            ∑ ω, π ω *
                ((1 - r) * (if ω = ω' then (1 : ℝ) else 0) + r * π ω')
                = ∑ ω,
                    ((1 - r) * (π ω * (if ω = ω' then (1 : ℝ) else 0)) +
                      r * (π ω * π ω')) := by
                  refine Finset.sum_congr rfl ?_
                  intro ω _hω
                  ring
            _ = (∑ ω, (1 - r) * (π ω * (if ω = ω' then (1 : ℝ) else 0))) +
                  (∑ ω, r * (π ω * π ω')) := by
                  rw [Finset.sum_add_distrib]
            _ = (1 - r) * (∑ ω, π ω * (if ω = ω' then (1 : ℝ) else 0)) +
                  r * (∑ ω, π ω * π ω') := by
                  rw [← Finset.mul_sum, ← Finset.mul_sum]
    _ = (1 - r) * π ω' + r * (π ω' * (∑ ω, π ω)) := by
          rw [hDelta, hConst]
    _ = π ω' := by
          rw [hsum]
          ring

/-- Exact detailed-balance identity for a fixed `r` and target `π`. -/
theorem refreshKernel_reversible
    (r : ℝ) (π : Ω → ℝ) :
    ∀ ω ω', π ω * refreshKernel r π ω ω' =
      π ω' * refreshKernel r π ω' ω := by
  intro ω ω'
  by_cases h : ω = ω'
  · subst h
    simp [refreshKernel]
  · have h' : ω' ≠ ω := fun hrev => h hrev.symm
    have hzero : (if ω = ω' then (1 : ℝ) else 0) = 0 := by simp [h]
    have hzero' : (if ω' = ω then (1 : ℝ) else 0) = 0 := by simp [h']
    rw [refreshKernel, refreshKernel, hzero, hzero']
    ring

/-- Pointwise refresh decomposition into damping and mean part. -/
theorem refreshKernel_apply
    (r : ℝ) (π : Ω → ℝ) (f : Ω → ℝ) (ω : Ω) :
    refreshStep r π f ω = (1 - r) * f ω + r * refreshMean π f := by
  have hDelta :
      (∑ ω', (if ω = ω' then (1 : ℝ) else 0) * f ω') = f ω := by
    calc
      (∑ ω', (if ω = ω' then (1 : ℝ) else 0) * f ω')
          = ∑ ω', if ω = ω' then f ω' else 0 := by
            refine Finset.sum_congr rfl ?_
            intro ω' _hω'
            by_cases h : ω = ω' <;> simp [h]
      _ = f ω := by simp
  calc
    refreshStep r π f ω
        = ∑ ω', ((1 - r) * (if ω = ω' then (1 : ℝ) else 0) + r * π ω') * f ω' := by
          rfl
    _ = ∑ ω',
          ((1 - r) * ((if ω = ω' then (1 : ℝ) else 0) * f ω') +
            r * (π ω' * f ω')) := by
          refine Finset.sum_congr rfl ?_
          intro ω' _hω'
          ring
    _ = (1 - r) * (∑ ω', (if ω = ω' then (1 : ℝ) else 0) * f ω') +
          r * (∑ ω', π ω' * f ω') := by
          rw [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum]
    _ = (1 - r) * f ω + r * refreshMean π f := by
          rw [hDelta]
          rfl

/-- Mean-zero observables are multiplied by `(1-r)` pointwise under refresh. -/
theorem refreshKernel_onMeanZero_eq_smul
    (r : ℝ) (π : Ω → ℝ) {f : Ω → ℝ}
    (hf : refreshMean π f = 0) :
    refreshStep r π f = (1 - r) • f := by
  ext ω
  rw [refreshKernel_apply (r := r) (π := π) (f := f) (ω := ω)]
  simp [hf]

/-- Mean is preserved by one refresh step. -/
theorem refreshMean_invariant
    (r : ℝ) (π : Ω → ℝ) (hπ : SimplexLaw π) (f : Ω → ℝ) :
    refreshMean π (refreshStep r π f) = refreshMean π f := by
  rcases hπ with ⟨_, hsum⟩
  set m : ℝ := ∑ ω, π ω * f ω
  calc
    refreshMean π (refreshStep r π f)
        = ∑ ω, π ω * ((1 - r) * f ω + r * m) := by
          unfold refreshMean
          refine Finset.sum_congr rfl ?_
          intro ω _hω
          rw [refreshKernel_apply]
          rfl
    _ = (1 - r) * m + (r * m) * (∑ ω, π ω) := by
          calc
            ∑ ω, π ω * ((1 - r) * f ω + r * m)
                = ∑ ω, ((1 - r) * (π ω * f ω) + (r * m) * π ω) := by
                  refine Finset.sum_congr rfl ?_
                  intro ω _hω
                  ring
            _ = (∑ ω, (1 - r) * (π ω * f ω)) +
                  (∑ ω, (r * m) * π ω) := by
                  rw [Finset.sum_add_distrib]
            _ = (1 - r) * (∑ ω, π ω * f ω) + (r * m) * (∑ ω, π ω) := by
                  rw [← Finset.mul_sum, ← Finset.mul_sum]
            _ = (1 - r) * m + (r * m) * (∑ ω, π ω) := by
                  rw [show (∑ ω, π ω * f ω) = m by rfl]
    _ = refreshMean π f := by
          rw [hsum]
          dsimp [m, refreshMean]
          ring

/-- Mean-zero centered update identity used by iterates. -/
theorem refreshKernel_centered_formula
    (r : ℝ) (π : Ω → ℝ) (f : Ω → ℝ) (ω : Ω) :
    refreshStep r π f ω - refreshMean π f =
      (1 - r) * (f ω - refreshMean π f) := by
  rw [refreshKernel_apply (r := r) (π := π) (f := f) (ω := ω)]
  ring

/-- Finite-iterate mean invariance. -/
theorem refreshKernel_centered_iterate
    (r : ℝ) (π : Ω → ℝ) (hπ : SimplexLaw π) (n : ℕ) (f : Ω → ℝ) :
    refreshMean π ((refreshStep r π)^[n] f) = refreshMean π f := by
  induction n with
  | zero =>
      simp
  | succ n ih =>
      simpa [Function.iterate_succ_apply', ih] using
        refreshMean_invariant (r := r) (π := π) hπ
          (f := (refreshStep r π)^[n] f)

/-- Exact power decay of centered fluctuations under the iterate. -/
theorem refreshKernel_correlation_eq_pow
    (r : ℝ) (π : Ω → ℝ) (hπ : SimplexLaw π) (n : ℕ) (f : Ω → ℝ) (ω : Ω) :
    ((refreshStep r π)^[n] f) ω - refreshMean π f =
      (1 - r) ^ n * (f ω - refreshMean π f) := by
  induction n with
  | zero =>
      simp
  | succ n ih =>
      calc
        ((refreshStep r π)^[Nat.succ n] f) ω - refreshMean π f
            = refreshStep r π ((refreshStep r π)^[n] f) ω -
                refreshMean π ((refreshStep r π)^[n] f) := by
              rw [Function.iterate_succ_apply']
              rw [refreshKernel_centered_iterate (r := r) (π := π) hπ (n := n) (f := f)]
        _ = (1 - r) *
              (((refreshStep r π)^[n] f) ω -
                refreshMean π ((refreshStep r π)^[n] f)) := by
              rw [refreshKernel_centered_formula (r := r) (π := π)
                (f := (refreshStep r π)^[n] f) (ω := ω)]
        _ = (1 - r) *
              (((refreshStep r π)^[n] f) ω - refreshMean π f) := by
              rw [refreshKernel_centered_iterate (r := r) (π := π) hπ (n := n) (f := f)]
        _ = (1 - r) * ((1 - r) ^ n * (f ω - refreshMean π f)) := by
              rw [ih]
        _ = (1 - r) ^ (Nat.succ n) * (f ω - refreshMean π f) := by
              rw [pow_succ]
              ring

/-- Centered-energy identity giving a finite-chain contraction factor. -/
theorem refreshKernel_spectralGap_eq_r
    (r : ℝ) (π : Ω → ℝ) (f : Ω → ℝ) :
    ∑ ω, (refreshStep r π f ω - refreshMean π f) ^ 2 =
      (1 - r) ^ 2 * (∑ ω, (f ω - refreshMean π f) ^ 2) := by
  calc
    ∑ ω, (refreshStep r π f ω - refreshMean π f) ^ 2
        = ∑ ω, ((1 - r) * (f ω - refreshMean π f)) ^ 2 := by
          refine Finset.sum_congr rfl ?_
          intro ω _hω
          rw [refreshKernel_centered_formula (r := r) (π := π) (f := f) (ω := ω)]
    _ = ∑ ω, (1 - r) ^ 2 * (f ω - refreshMean π f) ^ 2 := by
          refine Finset.sum_congr rfl ?_
          intro ω _hω
          ring
    _ = (1 - r) ^ 2 * (∑ ω, (f ω - refreshMean π f) ^ 2) := by
          rw [← Finset.mul_sum]

/-! ## Finite ergodic consequences (ERG-002/ERG-003/ERG-004)

The centered power-decay identity `refreshKernel_correlation_eq_pow` upgrades to
genuine finite ergodic statements once the contraction factor is strict,
`|1 - r| < 1` (equivalently `0 < r < 2`): every observable relaxes pointwise to
its `π`-mean, the centered energy collapses to zero, the only fixed observables
are the `π`-mean constants, and the law-level pushforward keeps `π` (and total
mass) invariant along every finite iterate. -/

/-- ERG-002. Under the strict contraction `|1 - r| < 1`, every observable relaxes
pointwise to its `π`-mean along the refresh iteration. -/
theorem refreshKernel_iterate_tendsto
    (r : ℝ) (π : Ω → ℝ) (hπ : SimplexLaw π) (hr : |1 - r| < 1) (f : Ω → ℝ) (ω : Ω) :
    Filter.Tendsto (fun n : ℕ => ((refreshStep r π)^[n] f) ω) Filter.atTop
      (nhds (refreshMean π f)) := by
  have hpow : Filter.Tendsto (fun n : ℕ => (1 - r) ^ n * (f ω - refreshMean π f))
      Filter.atTop (nhds 0) := by
    have := (tendsto_pow_atTop_nhds_zero_of_abs_lt_one hr).mul_const (f ω - refreshMean π f)
    simpa using this
  have hshift : Filter.Tendsto (fun n : ℕ => ((refreshStep r π)^[n] f) ω - refreshMean π f)
      Filter.atTop (nhds 0) := by
    simpa [refreshKernel_correlation_eq_pow r π hπ] using hpow
  have := hshift.add_const (refreshMean π f)
  simpa using this

/-- ERG-003. The centered energy of the iterate collapses to zero under the strict
contraction `|1 - r| < 1`. -/
theorem refreshKernel_energy_tendsto_zero
    (r : ℝ) (π : Ω → ℝ) (hπ : SimplexLaw π) (hr : |1 - r| < 1) (f : Ω → ℝ) :
    Filter.Tendsto (fun n : ℕ => ∑ ω, (((refreshStep r π)^[n] f) ω - refreshMean π f) ^ 2)
      Filter.atTop (nhds 0) := by
  have hsum : ∀ n : ℕ,
      (∑ ω, (((refreshStep r π)^[n] f) ω - refreshMean π f) ^ 2)
        = ((1 - r) ^ n) ^ 2 * (∑ ω, (f ω - refreshMean π f) ^ 2) := by
    intro n
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl ?_
    intro ω _
    rw [refreshKernel_correlation_eq_pow r π hπ]
    ring
  have hg : Filter.Tendsto (fun n : ℕ => (1 - r) ^ n) Filter.atTop (nhds 0) :=
    tendsto_pow_atTop_nhds_zero_of_abs_lt_one hr
  have hg2 : Filter.Tendsto (fun n : ℕ => ((1 - r) ^ n) ^ 2) Filter.atTop (nhds 0) := by
    simpa using hg.pow 2
  have hpow := hg2.mul_const (∑ ω, (f ω - refreshMean π f) ^ 2)
  simpa [hsum] using hpow

/-- ERG-004 (observable level). For a genuine refresh (`r ≠ 0`) the only fixed
observables of one refresh step are the ones constantly equal to their `π`-mean. -/
theorem refreshStep_fixedPoint_iff_eq_mean
    (r : ℝ) (hr : r ≠ 0) (π : Ω → ℝ) (f : Ω → ℝ) :
    refreshStep r π f = f ↔ ∀ ω, f ω = refreshMean π f := by
  constructor
  · intro hfix ω
    have h := refreshKernel_centered_formula r π f ω
    rw [congrFun hfix ω] at h
    have hz : r * (f ω - refreshMean π f) = 0 := by nlinarith [h]
    have := (mul_eq_zero.mp hz).resolve_left hr
    linarith
  · intro hf
    funext ω
    have h := refreshKernel_centered_formula r π f ω
    rw [hf ω] at h ⊢
    nlinarith [h]

/-- Law-level pushforward `(ν P)_{ω'} = ∑_ω ν_ω P_{ω ω'}` of a finite law `ν`
through the refresh kernel. -/
def refreshPush (r : ℝ) (π : Ω → ℝ) (ν : Ω → ℝ) : Ω → ℝ :=
  fun ω' => ∑ ω, ν ω * refreshKernel r π ω ω'

/-- ERG-004 (law level). The target law `π` is invariant for the pushforward. -/
theorem refreshPush_invariant (r : ℝ) (π : Ω → ℝ) (hπ : SimplexLaw π) :
    refreshPush r π π = π := by
  funext ω'
  exact refreshKernel_invariant r π hπ ω'

/-- The invariant law `π` is preserved along every finite iterate of the
pushforward. -/
theorem refreshPush_iterate_invariant (r : ℝ) (π : Ω → ℝ) (hπ : SimplexLaw π) (n : ℕ) :
    (refreshPush r π)^[n] π = π := by
  induction n with
  | zero => simp
  | succ n ih => rw [Function.iterate_succ_apply', ih, refreshPush_invariant r π hπ]

/-- The pushforward preserves total mass (a stochastic-kernel conservation law). -/
theorem refreshPush_total_mass (r : ℝ) (π : Ω → ℝ) (hπ : SimplexLaw π) (ν : Ω → ℝ) :
    ∑ ω', refreshPush r π ν ω' = ∑ ω, ν ω := by
  rcases hπ with ⟨_, hπsum⟩
  unfold refreshPush
  rw [Finset.sum_comm]
  calc
    ∑ ω, ∑ ω', ν ω * refreshKernel r π ω ω'
        = ∑ ω, ν ω * (∑ ω', refreshKernel r π ω ω') := by
          refine Finset.sum_congr rfl ?_; intro ω _; rw [Finset.mul_sum]
    _ = ∑ ω, ν ω * 1 := by
          refine Finset.sum_congr rfl ?_; intro ω _
          congr 1
          unfold refreshKernel
          rw [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum]
          simp [hπsum]
    _ = ∑ ω, ν ω := by simp

end PhysicsSM.NullStrand.Ergodic
