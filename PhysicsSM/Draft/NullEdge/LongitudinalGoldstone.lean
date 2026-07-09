import Mathlib

/-!
# The massive vector's third polarization IS the mass

A finite, rational (`Fin 4 → ℚ`) Minkowski linear-algebra avatar of the
Goldstone-equivalence / longitudinal-enhancement fact.

Metric `η = diag(1,-1,-1,-1)`, Minkowski product
`mdot u v = u0 v0 - u1 v1 - u2 v2 - u3 v3` in the `(+,-,-,-)` convention.

On-shell momentum `p = ![E,0,0,k]` with `E² - k² = m²` (so `mdot p p = m²`).

Longitudinal polarization `epsL = ![k/m, 0, 0, E/m]`, transverse polarizations
`epsT1 = ![0,1,0,0]`, `epsT2 = ![0,0,1,0]`.

We prove:
* `epsL` is spacelike unit-normalized (`mdot = -1`) and orthogonal to `p`;
* the two transverse modes are unit spacelike, orthogonal to `p`, and the three
  polarizations are mutually orthogonal — a valid 3-polarization frame;
* `epsL` is **singular** as `m → 0`: `m • epsL = ![k,0,0,E]`, and at `m = 0`
  (i.e. `E = k`) the momentum is null (`mdot p p = 0`), so `epsL` itself blows up
  like `1/m` and its direction collapses onto the null momentum — it cannot
  survive the massless limit, leaving only the 2 transverse modes.

Honest scope: a single on-shell momentum, finite rational avatar of the field-
theoretic statement; not the full field theory.
-/

namespace LongitudinalGoldstone

/-- Minkowski product in the `(+,-,-,-)` convention on `Fin 4 → ℚ`. -/
def mdot (u v : Fin 4 → ℚ) : ℚ := u 0 * v 0 - u 1 * v 1 - u 2 * v 2 - u 3 * v 3

/-- On-shell momentum `p = ![E, 0, 0, k]`. -/
def pMom (E k : ℚ) : Fin 4 → ℚ := ![E, 0, 0, k]

/-- Longitudinal polarization `epsL = ![k/m, 0, 0, E/m]`. -/
def epsL (E k m : ℚ) : Fin 4 → ℚ := ![k / m, 0, 0, E / m]

/-- First transverse polarization `epsT1 = ![0,1,0,0]`. -/
def epsT1 : Fin 4 → ℚ := ![0, 1, 0, 0]

/-- Second transverse polarization `epsT2 = ![0,0,1,0]`. -/
def epsT2 : Fin 4 → ℚ := ![0, 0, 1, 0]

/-- The momentum is on-shell: `mdot p p = m²` when `E² - k² = m²`. -/
theorem pMom_mdot (E k m : ℚ) (hos : E ^ 2 - k ^ 2 = m ^ 2) :
    mdot (pMom E k) (pMom E k) = m ^ 2 := by
  simp only [mdot, pMom, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val]
  linear_combination hos

/-- **Target 1.** The longitudinal polarization is spacelike and unit-normalized:
`mdot epsL epsL = -1`. -/
theorem epsL_normalized (E k m : ℚ) (hm : m ≠ 0) (hos : E ^ 2 - k ^ 2 = m ^ 2) :
    mdot (epsL E k m) (epsL E k m) = -1 := by
  simp only [mdot, epsL, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val]
  field_simp
  linear_combination -hos

/-- **Target 2.** The longitudinal polarization is orthogonal to the momentum:
`mdot epsL p = 0`. -/
theorem epsL_orthogonal_p (E k m : ℚ) :
    mdot (epsL E k m) (pMom E k) = 0 := by
  simp only [mdot, epsL, pMom, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val]
  ring

/-- **Target 3.** The two transverse modes are unit spacelike, orthogonal to `p`,
and the three polarizations are mutually orthogonal: a valid 3-polarization
spacelike frame for the massive vector. -/
theorem transverse_normalized_orthogonal (E k m : ℚ) :
    mdot epsT1 epsT1 = -1 ∧ mdot epsT2 epsT2 = -1 ∧
    mdot epsT1 (pMom E k) = 0 ∧ mdot epsT2 (pMom E k) = 0 ∧
    mdot epsT1 epsT2 = 0 ∧
    mdot (epsL E k m) epsT1 = 0 ∧ mdot (epsL E k m) epsT2 = 0 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    simp only [mdot, epsL, epsT1, epsT2, pMom, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val] <;> ring

/-- **Target 4.** Singularity as `m → 0`. Scaling `epsL` by `m` gives the finite
vector `![k,0,0,E]`; hence unscaled `epsL` diverges like `1/m`. And at `m = 0`
(where `E = k`) the momentum `![k,0,0,k]` is null (`mdot p p = 0`), so only the two
transverse polarizations survive. -/
theorem longitudinal_singular :
    (∀ (E k m : ℚ), m ≠ 0 → (fun i => m * epsL E k m i) = ![k, 0, 0, E]) ∧
    (∀ (k : ℚ), mdot (pMom k k) (pMom k k) = 0) := by
  constructor
  · intro E k m hm
    funext i
    fin_cases i <;> simp [epsL] <;> field_simp
  · intro k
    simp only [mdot, pMom, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val]
    ring

/-- **Non-degeneracy witness** at `E=5, k=3, m=4` (`5²-3²=16=4²`):
`epsL = ![3/4,0,0,5/4]`, `mdot epsL epsL = -1`, `mdot epsL p = 0`,
`4 • epsL = ![3,0,0,5]`; and the massless contrast `E=k=1, m=0`:
`p = ![1,0,0,1]` is null (`mdot p p = 0`). -/
theorem witness :
    epsL 5 3 4 = ![3/4, 0, 0, 5/4] ∧
    mdot (epsL 5 3 4) (epsL 5 3 4) = -1 ∧
    mdot (epsL 5 3 4) (pMom 5 3) = 0 ∧
    (fun i => (4 : ℚ) * epsL 5 3 4 i) = ![3, 0, 0, 5] ∧
    pMom 1 1 = ![1, 0, 0, 1] ∧
    mdot (pMom 1 1) (pMom 1 1) = 0 := by
  refine ⟨rfl, ?_, ?_, ?_, rfl, ?_⟩
  · simp only [mdot, epsL, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val]; norm_num
  · simp only [mdot, epsL, pMom, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val]
    norm_num
  · funext i; fin_cases i <;> simp [epsL] <;> norm_num
  · simp only [mdot, pMom, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val]; norm_num

/-- **Target 5. Verdict.** A massive vector (`m ≠ 0`, on-shell `E² - k² = m²`)
carries 3 mutually-orthogonal spacelike polarizations — the two transverse modes
`epsT1, epsT2` and the longitudinal mode `epsL` — all with `mdot = -1`, all
orthogonal to the momentum `p` (which satisfies `mdot p p = m²`). The longitudinal
mode is singular as `m → 0`: `m • epsL = ![k,0,0,E]` stays finite so `epsL ~ 1/m`
blows up, and at `m = 0` (`E = k`) the momentum is null (`mdot p p = 0`). Hence the
massless limit keeps only the 2 transverse modes: the third polarization IS the
mass, `pol = 2 (massless) + [m ≠ 0] = 3`. -/
theorem longitudinal_is_mass_verdict (E k m : ℚ) (hm : m ≠ 0) (hos : E ^ 2 - k ^ 2 = m ^ 2) :
    -- on-shell momentum
    mdot (pMom E k) (pMom E k) = m ^ 2 ∧
    -- three unit spacelike polarizations
    mdot epsT1 epsT1 = -1 ∧ mdot epsT2 epsT2 = -1 ∧
    mdot (epsL E k m) (epsL E k m) = -1 ∧
    -- all orthogonal to the momentum
    mdot epsT1 (pMom E k) = 0 ∧ mdot epsT2 (pMom E k) = 0 ∧
    mdot (epsL E k m) (pMom E k) = 0 ∧
    -- mutually orthogonal
    mdot epsT1 epsT2 = 0 ∧
    mdot (epsL E k m) epsT1 = 0 ∧ mdot (epsL E k m) epsT2 = 0 ∧
    -- longitudinal singular as m → 0: scaled stays finite, massless momentum is null
    (fun i => m * epsL E k m i) = ![k, 0, 0, E] ∧
    mdot (pMom k k) (pMom k k) = 0 := by
  obtain ⟨t1, t2, t1p, t2p, t12, l1, l2⟩ := transverse_normalized_orthogonal E k m
  obtain ⟨scaled, null⟩ := longitudinal_singular
  exact ⟨pMom_mdot E k m hos, t1, t2, epsL_normalized E k m hm hos, t1p, t2p,
    epsL_orthogonal_p E k m, t12, l1, l2, scaled E k m hm, null k⟩

-- Axiom footprint checks on every headline.
/-- info: 'LongitudinalGoldstone.pMom_mdot' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms pMom_mdot
/-- info: 'LongitudinalGoldstone.epsL_normalized' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms epsL_normalized
/-- info: 'LongitudinalGoldstone.epsL_orthogonal_p' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms epsL_orthogonal_p
/-- info: 'LongitudinalGoldstone.transverse_normalized_orthogonal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms transverse_normalized_orthogonal
/-- info: 'LongitudinalGoldstone.longitudinal_singular' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms longitudinal_singular
/-- info: 'LongitudinalGoldstone.witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms witness
/-- info: 'LongitudinalGoldstone.longitudinal_is_mass_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms longitudinal_is_mass_verdict

end LongitudinalGoldstone
