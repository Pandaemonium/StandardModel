import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# Reflection positivity selects Lorentzian (signature rung 2)

This file builds the smallest explicit Osterwalder–Schrader (OS) reflection-positivity
toy and proves that reflection positivity, together with a nondegenerate physical sector,
selects a signature with **exactly one time direction**.

## The toy

We work with `4` spacetime directions `Dir := Fin 4`.  A *signature* is a Boolean
function `sig : Dir → Bool`, where `sig μ = true` means direction `μ` is a *time*
direction.  Direction `0` is the distinguished direction across which we reflect
(the "Euclidean time" of the OS construction); we always assume `sig 0 = true`,
i.e. we reflect across a time direction.

The reflected direction carries the smallest possible lattice: **two sites**
`Fin 2 = {+, -}`, with the reflection `θ` swapping them.  A free Gaussian field with a
single physical mode has Euclidean action kernel

```
K = !![ a, -1; -1, a ],   a = onSite m sig k
```

where `a` is the on-site term.  The on-site term is the discrete "energy²" of the mode
at spatial/temporal momenta `k`:

```
a = 1 + m² + Σ_{μ ≠ 0} σ(μ) · k μ,     σ(μ) = -1 if μ is time, +1 if μ is space.
```

Each *additional* time direction contributes with a **negative** sign to the energy²:
raising the momentum in an extra time direction drives `a` below the stability
threshold.

The covariance is `C = K⁻¹`, and the OS *reflection Gram* is the reflected (cross)
two-point value `C₋₊ = C 1 0`, i.e. the correlation between the reflected site `θ(+) = -`
and the site `+`.  This is the `1×1` physical-sector reflection form.

* **Reflection positivity**: `0 ≤ reflGram` for every admissible momentum (`k ≥ 0`).
* **Nondegenerate physical sector**: `0 < reflGram` (strictly), so the physical inner
  product does not degenerate.

## Results

* `reflGram_eq`: the reflection Gram equals `(a² - 1)⁻¹`.
* `oneTime_reflectionPositive`: for the `(1,3)` signature (only direction `0` is time),
  the toy is reflection positive with a strictly positive (nondegenerate) physical
  sector, and its action kernel is positive definite (stable).
* `twoTime_reflectionPositive_fails`: as soon as a **second** time direction exists
  (e.g. the `(2,2)` signature), there is an admissible momentum at which the reflection
  Gram is strictly negative — reflection positivity fails — and the action kernel is not
  positive definite.

Together these convert "exactly one time" from a probe into a finite RP-selection
statement.
-/

namespace NullEdgeRP

/-- The `4` spacetime directions. -/
abbrev Dir : Type := Fin 4

/-- On-site term (discrete energy²) of the single physical mode at momenta `k`.

Direction `0` is the reflected time direction and does not enter the on-site term.
Each remaining direction contributes `± k μ`: `+` for a space direction, `-` for a
(further) time direction. -/
def onSite (m : ℝ) (sig : Dir → Bool) (k : Dir → ℝ) : ℝ :=
  1 + m ^ 2 + ∑ μ : Dir, (if μ = 0 then (0 : ℝ) else (if sig μ then -(k μ) else k μ))

/-- The two-site Euclidean action kernel along the reflected time direction. -/
noncomputable def actionKernel (m : ℝ) (sig : Dir → Bool) (k : Dir → ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  !![onSite m sig k, -1; -1, onSite m sig k]

/-- The covariance is the inverse of the action kernel. -/
noncomputable def covariance (m : ℝ) (sig : Dir → Bool) (k : Dir → ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  (actionKernel m sig k)⁻¹

/-- The OS reflection Gram: the reflected (cross) two-point value `C 1 0`.
This is the `1×1` physical-sector reflection form. -/
noncomputable def reflGram (m : ℝ) (sig : Dir → Bool) (k : Dir → ℝ) : ℝ :=
  covariance m sig k 1 0

/-- Closed form of the reflection Gram: `(a² - 1)⁻¹` with `a = onSite`. -/
theorem reflGram_eq (m : ℝ) (sig : Dir → Bool) (k : Dir → ℝ) :
    reflGram m sig k = (onSite m sig k ^ 2 - 1)⁻¹ := by
  unfold reflGram covariance actionKernel
  rw [Matrix.inv_def, Matrix.adjugate_fin_two, Matrix.det_fin_two]
  simp [Ring.inverse_eq_inv]
  ring_nf

/-- Reflection positivity of the toy: the reflection Gram is nonnegative at every
admissible momentum. -/
def ReflectionPositive (m : ℝ) (sig : Dir → Bool) : Prop :=
  ∀ k : Dir → ℝ, (∀ μ, 0 ≤ k μ) → 0 ≤ reflGram m sig k

/-- The physical sector is nondegenerate: the reflection Gram is strictly positive at
every admissible momentum. -/
def Nondegenerate (m : ℝ) (sig : Dir → Bool) : Prop :=
  ∀ k : Dir → ℝ, (∀ μ, 0 ≤ k μ) → 0 < reflGram m sig k

/-- In the one-time (`(1,3)`) signature the on-site term is at least `1 + m²`. -/
theorem onSite_ge_oneTime (m : ℝ) (sig : Dir → Bool) (k : Dir → ℝ)
    (hk : ∀ μ, 0 ≤ k μ) (hone : ∀ μ, μ ≠ 0 → sig μ = false) :
    1 + m ^ 2 ≤ onSite m sig k := by
  unfold onSite
  have hsum : (0 : ℝ) ≤
      ∑ μ : Dir, (if μ = 0 then (0 : ℝ) else (if sig μ then -(k μ) else k μ)) := by
    apply Finset.sum_nonneg
    intro μ _
    by_cases h : μ = 0
    · simp [h]
    · simp only [h, if_false, hone μ h]
      exact hk μ
  linarith

/-- **Rung 2, positive half.**  For the `(1,3)` signature (direction `0` is the only
time direction), the OS toy is reflection positive **with a strictly positive
(nondegenerate) physical sector**.

Hypotheses: `m ≠ 0` (a genuine mass gap), `sig 0 = true` (we reflect across a time
direction), and `hone` (no other time direction), which together specify the `(1,3)`
signature. -/
theorem oneTime_reflectionPositive (m : ℝ) (sig : Dir → Bool) (hm : m ≠ 0)
    (h0 : sig 0 = true) (hone : ∀ μ, μ ≠ 0 → sig μ = false) :
    ReflectionPositive m sig ∧ Nondegenerate m sig := by
  have key : ∀ k : Dir → ℝ, (∀ μ, 0 ≤ k μ) → 0 < reflGram m sig k := by
    intro k hk
    rw [reflGram_eq]
    have ha : 1 + m ^ 2 ≤ onSite m sig k := onSite_ge_oneTime m sig k hk hone
    have hm2 : 0 < m ^ 2 := by positivity
    have ha1 : 1 < onSite m sig k := by nlinarith
    have : 0 < onSite m sig k ^ 2 - 1 := by nlinarith
    positivity
  exact ⟨fun k hk => le_of_lt (key k hk), key⟩

/-- **Rung 2, kill.**  As soon as a second time direction exists (`j ≠ 0`, `sig j = true`),
in particular for the `(2,2)` signature, reflection positivity **fails**: there is an
admissible momentum at which the reflection Gram is strictly negative.  Hence no `(2,2)`
toy passes OS positivity with a nondegenerate physical sector. -/
theorem twoTime_reflectionPositive_fails (m : ℝ) (sig : Dir → Bool)
    (j : Dir) (hj : j ≠ 0) (hjt : sig j = true) :
    ∃ k : Dir → ℝ, (∀ μ, 0 ≤ k μ) ∧ reflGram m sig k < 0 := by
  refine ⟨fun μ => if μ = j then 1 + m ^ 2 else 0, ?_, ?_⟩
  · intro μ
    by_cases h : μ = j
    · simp only [h, if_true]; positivity
    · simp [h]
  · have hzero : onSite m sig (fun μ => if μ = j then 1 + m ^ 2 else 0) = 0 := by
      unfold onSite
      have hsum : (∑ μ : Dir, (if μ = 0 then (0 : ℝ)
          else (if sig μ then -((fun μ => if μ = j then 1 + m ^ 2 else 0) μ)
                else (fun μ => if μ = j then 1 + m ^ 2 else 0) μ)))
          = -(1 + m ^ 2) := by
        rw [Finset.sum_eq_single j]
        · simp [hj, hjt]
        · intro b _ hb
          by_cases h : b = 0
          · simp [h]
          · simp [h, hb]
        · simp
      rw [hsum]; ring
    rw [reflGram_eq, hzero]
    norm_num

/-!
## Stability of the action kernel (bonus)

Reflection positivity of the full Gaussian measure also requires the action kernel to be
positive definite ("stable").  We record that the `(1,3)` toy is stable while the `(2,2)`
counterexample is not.
-/

/-
**Stability of the `(1,3)` toy.**  For the one-time signature the action kernel is
positive definite at every admissible momentum.
-/
theorem oneTime_actionKernel_posDef (m : ℝ) (sig : Dir → Bool) (k : Dir → ℝ)
    (hm : m ≠ 0) (hk : ∀ μ, 0 ≤ k μ) (hone : ∀ μ, μ ≠ 0 → sig μ = false) :
    (actionKernel m sig k).PosDef := by
  constructor;
  · ext i j; fin_cases i <;> fin_cases j <;> rfl;
  · intro x hx_ne;
    -- Since $x \neq 0$, we have $x_0^2 + x_1^2 > 0$.
    have h_pos : x 0 ^ 2 + x 1 ^ 2 > 0 := by
      exact not_le.mp fun h => hx_ne <| by ext i; fin_cases i <;> norm_num <;> nlinarith!;
    norm_num [ Finsupp.sum_fintype, actionKernel ];
    nlinarith [ sq_nonneg ( x 0 - x 1 ), mul_self_pos.2 hm, show 1 + m ^ 2 ≤ onSite m sig k from onSite_ge_oneTime m sig k hk ( by aesop ) ]

/-- **Instability at the `(2,2)` counterexample.**  At the momentum witnessing the failure
of reflection positivity, the action kernel is not positive definite. -/
theorem twoTime_actionKernel_not_posDef (m : ℝ) (sig : Dir → Bool)
    (j : Dir) (hj : j ≠ 0) (hjt : sig j = true) :
    ¬ (actionKernel m sig (fun μ => if μ = j then 1 + m ^ 2 else 0)).PosDef := by
  intro hpd
  have hdet := hpd.det_pos
  have hzero : onSite m sig (fun μ => if μ = j then 1 + m ^ 2 else 0) = 0 := by
    unfold onSite
    have hsum : (∑ μ : Dir, (if μ = 0 then (0 : ℝ)
        else (if sig μ then -((fun μ => if μ = j then 1 + m ^ 2 else 0) μ)
              else (fun μ => if μ = j then 1 + m ^ 2 else 0) μ)))
        = -(1 + m ^ 2) := by
      rw [Finset.sum_eq_single j]
      · simp [hj, hjt]
      · intro b _ hb
        by_cases h : b = 0
        · simp [h]
        · simp [h, hb]
      · simp
    rw [hsum]; ring
  rw [show (actionKernel m sig (fun μ => if μ = j then 1 + m ^ 2 else 0))
        = !![onSite m sig (fun μ => if μ = j then 1 + m ^ 2 else 0), -1;
             -1, onSite m sig (fun μ => if μ = j then 1 + m ^ 2 else 0)] from rfl,
     Matrix.det_fin_two, hzero] at hdet
  norm_num at hdet

end NullEdgeRP

-- Axiom footprint guard: only the permitted axioms are used.
/-- info: 'NullEdgeRP.reflGram_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms NullEdgeRP.reflGram_eq

/-- info: 'NullEdgeRP.oneTime_reflectionPositive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms NullEdgeRP.oneTime_reflectionPositive

/-- info: 'NullEdgeRP.twoTime_reflectionPositive_fails' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms NullEdgeRP.twoTime_reflectionPositive_fails

/-- info: 'NullEdgeRP.oneTime_actionKernel_posDef' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms NullEdgeRP.oneTime_actionKernel_posDef

/-- info: 'NullEdgeRP.twoTime_actionKernel_not_posDef' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms NullEdgeRP.twoTime_actionKernel_not_posDef
