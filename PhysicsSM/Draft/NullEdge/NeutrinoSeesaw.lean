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

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# The type-I seesaw (finite rational 2×2 avatar)

A `2×2` real symmetric neutrino mass matrix mixes a light **active** state (no bare Majorana mass,
active–active entry `0`) with a heavy **sterile** partner (Majorana mass `MR > 0`) through a Dirac
mass `mD > 0`:

```
M = !![0, mD; mD, MR]
```

Its eigenvalues `lam` solve the characteristic equation `lam^2 - MR*lam - mD^2 = 0`.  We work with
the two eigenvalues purely through their **symmetric functions** (Vieta: product = det, sum = trace),
never through the square-root root formula, so everything is finite order/field arithmetic and
kernel-checked (no `Real.sqrt`, no `Complex`).

The payload is the *seesaw suppression*: the light eigenvalue has magnitude `< mD^2 / MR`, i.e. the
heavier the Majorana partner `MR`, the lighter the active neutrino.
-/

namespace NeutrinoSeesaw

/-- The explicit real symmetric seesaw mass matrix
`M = !![0, mD; mD, MR]`: active–active entry `0` (no bare Majorana), Dirac off-diagonal `mD`,
sterile Majorana `MR`. -/
def M (mD MR : ℝ) : Matrix (Fin 2) (Fin 2) ℝ := !![0, mD; mD, MR]

/-!
## 1. Characteristic data via `det` / `trace` (Vieta)
-/

/-- `char_vieta`: the determinant and trace of `M` (the Vieta data of its characteristic polynomial
`X^2 - MR*X - mD^2`) are, from the explicit entries, `det M = -mD^2` and `trace M = MR`. -/
theorem char_vieta (mD MR : ℝ) :
    (M mD MR).det = -mD ^ 2 ∧ (M mD MR).trace = MR := by
  refine ⟨?_, ?_⟩
  · simp [M, Matrix.det_fin_two]; ring
  · simp [M, Matrix.trace_fin_two]

/-- From two distinct roots `lp ≠ ln` of the characteristic equation
`lam^2 - MR*lam - mD^2 = 0`, Vieta's relations follow: the product is `det M = -mD^2` and the sum is
`trace M = MR`. -/
theorem eig_vieta (mD MR lp ln : ℝ)
    (hp : lp ^ 2 - MR * lp - mD ^ 2 = 0)
    (hn : ln ^ 2 - MR * ln - mD ^ 2 = 0)
    (hne : lp ≠ ln) :
    lp * ln = -mD ^ 2 ∧ lp + ln = MR := by
  have hsub : (lp - ln) * (lp + ln - MR) = 0 := by linear_combination hp - hn
  have hd : lp - ln ≠ 0 := sub_ne_zero.mpr hne
  have hsum : lp + ln = MR := by
    have := (mul_eq_zero.mp hsub).resolve_left hd
    linarith
  refine ⟨?_, hsum⟩
  -- `ln = MR - lp`, so `lp * ln = lp*(MR - lp) = MR*lp - lp^2 = -mD^2` by `hp`.
  have hln' : ln = MR - lp := by linarith
  subst hln'
  linear_combination -hp

/-!
## 2. Opposite signs: the light neutrino and its heavy partner
-/

/-- `opposite_signs`: since the product of the eigenvalues is `-mD^2 < 0` (with `mD ≠ 0`), the two
eigenvalues have **opposite signs** — one positive, one negative. -/
theorem opposite_signs (mD lp ln : ℝ) (hmD : mD ≠ 0)
    (hprod : lp * ln = -mD ^ 2) :
    (0 < lp ∧ ln < 0) ∨ (lp < 0 ∧ 0 < ln) := by
  have hpos : (0 : ℝ) < mD ^ 2 := by positivity
  have : lp * ln < 0 := by rw [hprod]; linarith
  exact mul_neg_iff.mp this

/-!
## 3. The seesaw bound (payload)
-/

/-- `seesaw_bound`: labelling `ln` the light (negative) eigenvalue, its magnitude is **suppressed**:
`|ln| = -ln < mD^2 / MR`.

Proof (no square roots): from the trace relation `lp = MR - ln`, and `ln < 0`, we get
`lp > MR > 0`.  From the product relation `lp * ln = -mD^2` we get `-ln = mD^2 / lp`, and since
`0 < MR < lp` this is `< mD^2 / MR`. -/
theorem seesaw_bound (mD MR lp ln : ℝ)
    (hmD : 0 < mD) (hMR : 0 < MR)
    (hprod : lp * ln = -mD ^ 2) (hsum : lp + ln = MR)
    (hln : ln < 0) :
    -ln < mD ^ 2 / MR := by
  have hmD2 : (0 : ℝ) < mD ^ 2 := by positivity
  -- heavy eigenvalue exceeds `MR`
  have hlp : MR < lp := by linarith
  have hlp0 : 0 < lp := lt_trans hMR hlp
  -- `-ln = mD^2 / lp`
  have hkey : -ln = mD ^ 2 / lp := by
    rw [eq_div_iff (ne_of_gt hlp0)]
    linear_combination -hprod
  rw [hkey]
  exact div_lt_div_of_pos_left hmD2 hMR hlp

/-!
## 4. The seesaw verdict (package)
-/

/-- `seesaw_verdict`: the packaged statement.  A heavy Majorana partner `MR > 0` seesaws the active
neutrino to a light eigenvalue `ln < 0` of magnitude `< mD^2 / MR`, of opposite sign to its heavy
partner `lp > 0`, with the **product of the two masses pinned** at `mD^2` (`lp * |ln| = mD^2`).

Honest scope: this is a finite real `2×2` avatar of the type-I seesaw.  The product of the two
masses is fixed at `mD^2` and the light one is bounded by `mD^2/MR` — a structural suppression driven
by `MR`, not a prediction of the physical neutrino mass. -/
theorem seesaw_verdict (mD MR lp ln : ℝ)
    (hmD : 0 < mD) (hMR : 0 < MR)
    (hprod : lp * ln = -mD ^ 2) (hsum : lp + ln = MR)
    (hln : ln < 0) :
    0 < lp ∧ ln < 0 ∧ lp * (-ln) = mD ^ 2 ∧ -ln < mD ^ 2 / MR := by
  have hlp : MR < lp := by linarith
  have hlp0 : 0 < lp := lt_trans hMR hlp
  refine ⟨hlp0, hln, ?_, seesaw_bound mD MR lp ln hmD hMR hprod hsum hln⟩
  have : lp * (-ln) = -(lp * ln) := by ring
  rw [this, hprod]; ring

/-!
## Non-degeneracy checks (in-theorem)

* Suppression regime `mD = 1, MR = 100`: `lp*ln = -1`, `lp+ln = 100`, hence `lp > 100` and the light
  mass `|ln| < 1/100` — strongly suppressed.
* Control `mD = MR = 1` (no hierarchy): the bound `|ln| < 1` still holds, but is **not small**,
  showing the suppression is genuinely `MR`-driven.
-/

/-- Suppression regime: `mD = 1, MR = 100` gives `|ln| < 1/100`. -/
theorem nondegen_suppressed (lp ln : ℝ)
    (hprod : lp * ln = -(1 : ℝ) ^ 2) (hsum : lp + ln = 100)
    (hln : ln < 0) :
    100 < lp ∧ -ln < (1 : ℝ) ^ 2 / 100 := by
  have h := seesaw_verdict 1 100 lp ln (by norm_num) (by norm_num) hprod hsum hln
  obtain ⟨hlp0, _, _, hb⟩ := h
  refine ⟨by linarith, hb⟩

/-- Control (no hierarchy): `mD = MR = 1` gives `|ln| < 1`, which holds but is not small. -/
theorem nondegen_control (lp ln : ℝ)
    (hprod : lp * ln = -(1 : ℝ) ^ 2) (hsum : lp + ln = 1)
    (hln : ln < 0) :
    -ln < (1 : ℝ) ^ 2 / 1 := by
  exact seesaw_bound 1 1 lp ln (by norm_num) (by norm_num) hprod hsum hln

/-!
## Axiom footprint of every headline result
-/

/-- info: 'NeutrinoSeesaw.char_vieta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms char_vieta

/-- info: 'NeutrinoSeesaw.eig_vieta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms eig_vieta

/-- info: 'NeutrinoSeesaw.opposite_signs' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms opposite_signs

/-- info: 'NeutrinoSeesaw.seesaw_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms seesaw_bound

/-- info: 'NeutrinoSeesaw.seesaw_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms seesaw_verdict

/-- info: 'NeutrinoSeesaw.nondegen_suppressed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nondegen_suppressed

/-- info: 'NeutrinoSeesaw.nondegen_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nondegen_control

end NeutrinoSeesaw
