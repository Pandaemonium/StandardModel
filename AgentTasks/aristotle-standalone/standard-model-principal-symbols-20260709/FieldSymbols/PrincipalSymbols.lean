import Mathlib

open Matrix Complex
open scoped BigOperators

namespace StandardModelPrincipalSymbols

abbrev Momentum3 := Fin 3 → ℚ
abbrev Spin4 := Matrix (Fin 4) (Fin 4) ℂ

def normSq3 (k : Momentum3) : ℚ := ∑ i, (k i) ^ 2
def waveQ (omega : ℚ) (k : Momentum3) : ℚ := omega ^ 2 - normSq3 k

def gamma0 : Spin4 :=
  !![1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

def gamma1 : Spin4 :=
  !![0, 0, 0, 1; 0, 0, 1, 0; 0, -1, 0, 0; -1, 0, 0, 0]

def gamma2 : Spin4 :=
  !![0, 0, 0, -I; 0, 0, I, 0; 0, I, 0, 0; -I, 0, 0, 0]

def gamma3 : Spin4 :=
  !![0, 0, 1, 0; 0, 0, 0, -1; -1, 0, 0, 0; 0, 1, 0, 0]

def gammaSpatial : Fin 3 → Spin4 := ![gamma1, gamma2, gamma3]

noncomputable def diracPrincipal (omega : ℚ) (k : Momentum3) : Spin4 :=
  (omega : ℂ) • gamma0 + ∑ i, (k i : ℂ) • gammaSpatial i

/-- The explicit gamma matrices have mostly-minus Clifford signature. -/
theorem gamma_clifford :
    gamma0 * gamma0 = 1
      ∧ (∀ i : Fin 3, gammaSpatial i * gammaSpatial i = -1)
      ∧ (∀ i : Fin 3, gamma0 * gammaSpatial i + gammaSpatial i * gamma0 = 0)
      ∧ (∀ i j : Fin 3, i ≠ j →
          gammaSpatial i * gammaSpatial j + gammaSpatial j * gammaSpatial i = 0) := by
  sorry

/-- The 3+1 Dirac principal symbol squares to the wave scalar. -/
theorem diracPrincipal_sq (omega : ℚ) (k : Momentum3) :
    diracPrincipal omega k * diracPrincipal omega k =
      (waveQ omega k : ℂ) • (1 : Spin4) := by
  sorry

/-- Its determinant is the square of the wave polynomial. -/
theorem diracPrincipal_det (omega : ℚ) (k : Momentum3) :
    (diracPrincipal omega k).det = (waveQ omega k : ℂ) ^ 2 := by
  sorry

/-- Hence the Dirac characteristic locus is exactly the null cone. -/
theorem dirac_characteristic_iff_null (omega : ℚ) (k : Momentum3) :
    (diracPrincipal omega k).det = 0 ↔ waveQ omega k = 0 := by
  sorry

/-- Gauge-fixed vector principal symbol. -/
noncomputable def vectorPrincipal (omega : ℚ) (k : Momentum3) : Spin4 :=
  (waveQ omega k : ℂ) • (1 : Spin4)

/-- Lorenz-gauge vector determinant. -/
theorem vectorPrincipal_det (omega : ℚ) (k : Momentum3) :
    (vectorPrincipal omega k).det = (waveQ omega k : ℂ) ^ 4 := by
  sorry

/-- Scalar Klein-Gordon principal symbol and determinant. -/
theorem scalar_characteristic_iff_null (omega : ℚ) (k : Momentum3) :
    (waveQ omega k : ℂ) = 0 ↔ waveQ omega k = 0 := by
  sorry

/-- Lorenz-gauge vector characteristics are exactly null. -/
theorem vector_characteristic_iff_null (omega : ℚ) (k : Momentum3) :
    (vectorPrincipal omega k).det = 0 ↔ waveQ omega k = 0 := by
  sorry

/-- A finite zero-order Dirac mass disappears under first-order principal
scaling. -/
theorem dirac_mass_lower_order
    (omega : ℚ) (k : Momentum3) (m eps : ℚ) (heps : eps ≠ 0) :
    (eps : ℂ) •
        (diracPrincipal (omega / eps) (fun i => k i / eps) -
          (m : ℂ) • (1 : Spin4)) =
      diracPrincipal omega k - (eps * m : ℚ) • (1 : Spin4) := by
  sorry

/-- A scalar mass and arbitrary finite channel matrix disappear under
second-order principal scaling. -/
theorem wave_channels_lower_order
    (omega : ℚ) (k : Momentum3) (eps : ℚ) (heps : eps ≠ 0)
    (B : Spin4) :
    (eps ^ 2 : ℂ) •
        ((waveQ (omega / eps) (fun i => k i / eps) : ℂ) • (1 : Spin4) + B) =
      (waveQ omega k : ℂ) • (1 : Spin4) + (eps ^ 2 : ℂ) • B := by
  sorry

/-- Field-by-field principal-symbol verdict: scalar, Dirac, and Lorenz-gauge
vector representatives share exactly the null characteristic cone, while
finite mass/channel matrices are lower order. -/
theorem standard_model_principal_symbol_verdict (omega : ℚ) (k : Momentum3) :
    ((waveQ omega k : ℂ) = 0 ↔ waveQ omega k = 0)
      ∧ ((diracPrincipal omega k).det = 0 ↔ waveQ omega k = 0)
      ∧ ((vectorPrincipal omega k).det = 0 ↔ waveQ omega k = 0) := by
  sorry

end StandardModelPrincipalSymbols
