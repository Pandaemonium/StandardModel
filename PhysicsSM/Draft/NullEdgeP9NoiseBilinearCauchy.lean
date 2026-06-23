import Mathlib.Tactic

/-!
# P9 bilinear noise-response Cauchy-Schwarz

The quadratic response has an associated bilinear pairing. Under nonnegative
weights it should obey Cauchy-Schwarz, making the finite noise-response API a
positive-semidefinite observer bilinear form.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9NoiseBilinearCauchy

open BigOperators

structure DiamondNoiseSource (Cell Cfg : Type) [Fintype Cell] [Fintype Cfg] where
  source : Cfg -> Cell -> Real
  weight : Cfg -> Real

variable {Cell Cfg : Type}
variable [Fintype Cell] [Fintype Cfg]

def meanSource (s : DiamondNoiseSource Cell Cfg) (c : Cell) : Real :=
  Finset.univ.sum fun w => s.weight w * s.source w c

def centered (s : DiamondNoiseSource Cell Cfg) (w : Cfg) (c : Cell) : Real :=
  s.source w c - meanSource s c

def noiseKernel (s : DiamondNoiseSource Cell Cfg) (c d : Cell) : Real :=
  Finset.univ.sum fun w => s.weight w * centered s w c * centered s w d

def noiseBilinear (s : DiamondNoiseSource Cell Cfg)
    (t u : Cell -> Real) : Real :=
  Finset.univ.sum fun c =>
    Finset.univ.sum fun d => t c * u d * noiseKernel s c d

def noiseResponse (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real) : Real :=
  noiseBilinear s t t

/-- Project the test vector `t` against the centered source for a fixed config `w`. -/
def sourceProj (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real) (w : Cfg) : Real :=
  Finset.univ.sum fun c => t c * centered s w c

/-
The bilinear form factors as a weighted inner product of the projections.
-/
lemma noiseBilinear_eq_weighted_sum (s : DiamondNoiseSource Cell Cfg) (t u : Cell -> Real) :
    noiseBilinear s t u =
      Finset.univ.sum fun w => s.weight w * sourceProj s t w * sourceProj s u w := by
  convert Finset.sum_comm using 1;
  simp +decide [ noiseKernel, sourceProj, Finset.mul_sum _ _ _, mul_assoc, mul_comm, mul_left_comm ];
  exact Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_comm )

theorem noiseBilinear_cauchy_schwarz
    (s : DiamondNoiseSource Cell Cfg) (t u : Cell -> Real)
    (hweight : forall w, 0 <= s.weight w) :
    noiseBilinear s t u ^ 2 <= noiseResponse s t * noiseResponse s u := by
  rw [ noiseBilinear_eq_weighted_sum, show noiseResponse s t = noiseBilinear s t t from rfl, show noiseResponse s u = noiseBilinear s u u from rfl, noiseBilinear_eq_weighted_sum, noiseBilinear_eq_weighted_sum ];
  have h_cauchy_schwarz : ∀ (f g : Cfg → ℝ), (∑ w, f w * g w) ^ 2 ≤ (∑ w, f w ^ 2) * (∑ w, g w ^ 2) := by
    exact fun f g => Finset.sum_mul_sq_le_sq_mul_sq Finset.univ f g
  convert h_cauchy_schwarz ( fun w => Real.sqrt ( s.weight w ) * sourceProj s t w ) ( fun w => Real.sqrt ( s.weight w ) * sourceProj s u w ) using 3 <;> ring <;> norm_num [ hweight ]; all_goals ring

end PhysicsSM.Draft.NullEdgeP9NoiseBilinearCauchy
