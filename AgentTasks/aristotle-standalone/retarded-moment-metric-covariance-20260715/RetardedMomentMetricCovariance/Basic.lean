import Mathlib

/-!
# Retarded-moment metric debiasing covariance

This standalone target isolates the exact matrix algebra behind numerical Stage
A29-A30. A retarded operator supplies a column moment `m`; a supplied covariant
metric evaluates its scalar norm; and the resulting rank-one temporal projector
rescales one response channel of an inverse metric.

The target proves covariance under a constant invertible probe change, including
the differentiated projector with supplied scalar and moment first jets. It
does not construct the moment, metric, inverse, response weight, probes, or a
continuum limit from a graph.
-/

open Matrix

noncomputable section

namespace RetardedMomentMetricCovariance

variable {K n : Type*} [Field K] [Fintype n] [DecidableEq n]

/-- Scalar norm of a column moment in a supplied covariant metric. -/
def momentNorm
    (gCov : Matrix n n K) (m : Matrix n (Fin 1) K) : K :=
  (mᵀ * gCov * m) 0 0

/-- Contravariant rank-one temporal projector with supplied nonzero norm. -/
def temporalProjector
    (m : Matrix n (Fin 1) K) (q : K) : Matrix n n K :=
  q⁻¹ • (m * mᵀ)

/-- Finite response correction used before determinant/count normalization. -/
def debiasedMetric
    (G : Matrix n n K) (m : Matrix n (Fin 1) K) (q response : K) :
    Matrix n n K :=
  G + (response - 1) • temporalProjector m q

/-- First jet of the temporal projector for supplied `dm`, `dq`. -/
def temporalProjectorJet
    (m dm : Matrix n (Fin 1) K) (q dq : K) : Matrix n n K :=
  q⁻¹ • (dm * mᵀ + m * dmᵀ) -
    (dq * q⁻¹ * q⁻¹) • (m * mᵀ)

/-- First jet of the response-corrected inverse metric. -/
def debiasedMetricJet
    (dG : Matrix n n K) (m dm : Matrix n (Fin 1) K)
    (q dq response : K) : Matrix n n K :=
  dG + (response - 1) • temporalProjectorJet m dm q dq

/-- The moment norm is invariant under a probe change and the corresponding
inverse-congruence transformation of the covariant metric. -/
theorem momentNorm_congr
    (A AInv gCov : Matrix n n K) (m : Matrix n (Fin 1) K)
    (hLeft : AInv * A = 1) :
    momentNorm (AInvᵀ * gCov * AInv) (A * m) = momentNorm gCov m := by
  sorry

/-- The temporal projector transforms as a contravariant two-tensor. -/
theorem temporalProjector_congr
    (A : Matrix n n K) (m : Matrix n (Fin 1) K) (q : K) :
    temporalProjector (A * m) q =
      A * temporalProjector m q * Aᵀ := by
  sorry

/-- The response-corrected inverse metric is affine-probe covariant. -/
theorem debiasedMetric_congr
    (A G : Matrix n n K) (m : Matrix n (Fin 1) K) (q response : K) :
    debiasedMetric (A * G * Aᵀ) (A * m) q response =
      A * debiasedMetric G m q response * Aᵀ := by
  sorry

/-- The differentiated temporal projector has the same covariance. -/
theorem temporalProjectorJet_congr
    (A : Matrix n n K) (m dm : Matrix n (Fin 1) K) (q dq : K) :
    temporalProjectorJet (A * m) (A * dm) q dq =
      A * temporalProjectorJet m dm q dq * Aᵀ := by
  sorry

/-- The differentiated response correction is affine-probe covariant. -/
theorem debiasedMetricJet_congr
    (A dG : Matrix n n K) (m dm : Matrix n (Fin 1) K)
    (q dq response : K) :
    debiasedMetricJet (A * dG * Aᵀ) (A * m) (A * dm) q dq response =
      A * debiasedMetricJet dG m dm q dq response * Aᵀ := by
  sorry

/-- A rational 1+1 witness where response correction maps a biased Lorentzian
form exactly to the mostly-minus Minkowski form. -/
theorem nontrivial_response_correction_witness :
    debiasedMetric
        (!![2, 0; 0, -1] : Matrix (Fin 2) (Fin 2) ℚ)
        (!![1; 0] : Matrix (Fin 2) (Fin 1) ℚ)
        (1 / 2) (1 / 2) =
      (!![1, 0; 0, -1] : Matrix (Fin 2) (Fin 2) ℚ) := by
  sorry

end RetardedMomentMetricCovariance
