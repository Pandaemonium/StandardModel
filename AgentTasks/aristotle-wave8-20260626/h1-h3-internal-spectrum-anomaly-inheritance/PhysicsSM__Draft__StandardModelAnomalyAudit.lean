import Mathlib

/-!
# Standard Model one-generation anomaly cancellation (numeric audit)

Aristotle draft target for the null-edge open convention target wave (task T18,
the anomaly-sum part). See `PROMPT.md`, `docs/CONVENTIONS.md`, and
`AgentTasks/null-edge-unified-mass-proof-chain.md` (entry T18).

## What this file proves

For **one** Standard Model generation we record the conventional left-handed
Weyl fields, each with a colour multiplicity (`SU(3)` dimension), a weak
multiplicity (`SU(2)` dimension), and a hypercharge `Y` (in the convention
`Q = T_3 + Y/2`, i.e. `Y(Q_L) = 1/6`). We then discharge, by exact rational
arithmetic, the standard gauge / gauge-gravitational anomaly cancellation
conditions:

* `U(1)` (gravitational) anomaly: `∑ (mult) · Y = 0`.
* `U(1)^3` anomaly: `∑ (mult) · Y^3 = 0`.
* mixed `SU(2)^2 U(1)` anomaly: `∑_{weak doublets} (colour) · Y = 0`.
* mixed `SU(3)^2 U(1)` anomaly: `∑_{colour triplets} (weak) · Y = 0`.

Here `mult = colour · weak` is the total multiplicity of the field.

## Conventions and scope (guardrails)

* All fields are written as **left-handed Weyl fields**; right-handed fields
  appear as their left-handed charge conjugates (`u_R^c`, `d_R^c`, `e_R^c`),
  with the sign-flipped hypercharge.
* **Right-handed neutrino:** *not* included. A right-handed neutrino enters as a
  left-handed conjugate `ν_R^c` with colour 1, weak 1, and `Y = 0`, so it
  contributes `0` to every sum above and does not affect any of these results.
* This file proves **only** the standard one-generation anomaly arithmetic. It
  does **not** prove that the null-edge construction realises the chiral Standard
  Model, nor anything about doubling / Nielsen–Ninomiya evasion.
* Per the prompt, this stays in `PhysicsSM/Draft/` until semantic review.

The conventional hypercharge assignments used:

```text
Q_L     : colour 3, weak 2, Y =  1/6
L_L     : colour 1, weak 2, Y = -1/2
u_R^c   : colour 3, weak 1, Y = -2/3
d_R^c   : colour 3, weak 1, Y =  1/3
e_R^c   : colour 1, weak 1, Y =  1
(ν_R^c) : colour 1, weak 1, Y =  0   -- optional, omitted; harmless
```
-/

namespace PhysicsSM
namespace Draft
namespace SMAnomaly

/-- A left-handed Weyl multiplet of one Standard Model generation, recorded by
its colour (`SU(3)`) multiplicity, weak (`SU(2)`) multiplicity, and hypercharge
`Y` (convention `Q = T_3 + Y/2`). -/
structure Field where
  /-- Colour (`SU(3)`) multiplicity. -/
  color : ℕ
  /-- Weak (`SU(2)`) multiplicity. -/
  weak : ℕ
  /-- Hypercharge `Y`. -/
  Y : ℚ
  deriving DecidableEq, Repr

namespace Field

/-- Total multiplicity `colour · weak` of a field. -/
def mult (f : Field) : ℕ := f.color * f.weak

end Field

open Field

/-- Left-handed quark doublet `Q_L`. -/
def QL : Field := ⟨3, 2, 1/6⟩
/-- Left-handed lepton doublet `L_L`. -/
def LL : Field := ⟨1, 2, -1/2⟩
/-- Conjugate up-type quark singlet `u_R^c`. -/
def uRc : Field := ⟨3, 1, -2/3⟩
/-- Conjugate down-type quark singlet `d_R^c`. -/
def dRc : Field := ⟨3, 1, 1/3⟩
/-- Conjugate charged-lepton singlet `e_R^c`. -/
def eRc : Field := ⟨1, 1, 1⟩

/-- The one-generation Standard Model spectrum (no right-handed neutrino). -/
def generation : List Field := [QL, LL, uRc, dRc, eRc]

/-- `U(1)` (gravitational) anomaly sum: `∑ mult · Y`. -/
def gravSum (fs : List Field) : ℚ :=
  (fs.map (fun f => (f.mult : ℚ) * f.Y)).sum

/-- `U(1)^3` anomaly sum: `∑ mult · Y^3`. -/
def cubeSum (fs : List Field) : ℚ :=
  (fs.map (fun f => (f.mult : ℚ) * f.Y ^ 3)).sum

/-- Mixed `SU(2)^2 U(1)` anomaly sum: over weak doublets, weighted by colour
multiplicity, `∑ colour · Y`. -/
def su2Sum (fs : List Field) : ℚ :=
  ((fs.filter (fun f => f.weak = 2)).map (fun f => (f.color : ℚ) * f.Y)).sum

/-- Mixed `SU(3)^2 U(1)` anomaly sum: over colour triplets, weighted by weak
multiplicity, `∑ weak · Y`. -/
def su3Sum (fs : List Field) : ℚ :=
  ((fs.filter (fun f => f.color = 3)).map (fun f => (f.weak : ℚ) * f.Y)).sum

/-- `U(1)` (gravitational) anomaly cancellation for one generation. -/
theorem grav_anomaly_zero : gravSum generation = 0 := by
  simp [gravSum, generation, QL, LL, uRc, dRc, eRc, Field.mult]
  norm_num

/-- `U(1)^3` anomaly cancellation for one generation. -/
theorem cube_anomaly_zero : cubeSum generation = 0 := by
  simp [cubeSum, generation, QL, LL, uRc, dRc, eRc, Field.mult]
  norm_num

/-- Mixed `SU(2)^2 U(1)` anomaly cancellation: `3·(1/6) + (-1/2) = 0`. -/
theorem su2_anomaly_zero : su2Sum generation = 0 := by
  simp [su2Sum, generation, QL, LL, uRc, dRc, eRc]
  norm_num

/-- Mixed `SU(3)^2 U(1)` anomaly cancellation:
`2·(1/6) + (-2/3) + (1/3) = 0`. -/
theorem su3_anomaly_zero : su3Sum generation = 0 := by
  simp [su3Sum, generation, QL, LL, uRc, dRc, eRc]
  norm_num

/-- Full one-generation anomaly cancellation package. -/
theorem sm_anomaly_cancellation :
    gravSum generation = 0 ∧
    cubeSum generation = 0 ∧
    su2Sum generation = 0 ∧
    su3Sum generation = 0 :=
  ⟨grav_anomaly_zero, cube_anomaly_zero, su2_anomaly_zero, su3_anomaly_zero⟩

/-! ### Right-handed neutrino is harmless

Including a right-handed neutrino as a left-handed conjugate `ν_R^c` with
colour 1, weak 1, `Y = 0` changes none of the sums. -/

/-- Conjugate right-handed neutrino singlet `ν_R^c` (`Y = 0`). -/
def nuRc : Field := ⟨1, 1, 0⟩

/-- One generation extended with a right-handed neutrino. -/
def generationWithNu : List Field := generation ++ [nuRc]

/-- The right-handed neutrino does not affect any anomaly sum. -/
theorem sm_anomaly_cancellation_with_nu :
    gravSum generationWithNu = 0 ∧
    cubeSum generationWithNu = 0 ∧
    su2Sum generationWithNu = 0 ∧
    su3Sum generationWithNu = 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;>
    simp [gravSum, cubeSum, su2Sum, su3Sum, generationWithNu, generation,
      QL, LL, uRc, dRc, eRc, nuRc, Field.mult] <;>
    norm_num

end SMAnomaly
end Draft
end PhysicsSM
