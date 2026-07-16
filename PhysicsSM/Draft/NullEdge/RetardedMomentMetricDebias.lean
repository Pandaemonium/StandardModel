import Mathlib

/-!
# Retarded-moment metric debiasing covariance

This module isolates the exact matrix algebra behind numerical Stages A29-A30.
A retarded operator supplies a column moment `m`; a supplied covariant metric
evaluates its scalar norm; and the resulting rank-one temporal projector
rescales one response channel of a contravariant inverse metric.

The module proves covariance under a constant invertible probe change,
including the differentiated projector with supplied scalar and moment first
jets. It does not construct the moment, metric, inverse, response weight,
probes, chart, or continuum limit from a graph. The statements are conditional
finite identities with claim grade `M [comp]`.

Conventions: moments are columns and transform as `m -> A * m`; inverse metrics
transform as `G -> A * G * A^T`; covariant metrics transform as
`g -> AInv^T * g * AInv`. The one-sided hypothesis `AInv * A = 1` is used in
exactly that order.

Provenance: theorem statements and conventions were prepared locally from the
A29-A30 numerical construction. Aristotle project
`ffa543b4-ffa1-4dac-bb12-da77ac2bc68d` supplied the six proof bodies without
changing any public signature. Local integration retained the nonidentity
rational witness and reviewed the conditional geometric boundary.
-/

open Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias

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
  unfold momentNorm
  simp +decide [← Matrix.mul_assoc]
  simp +decide [Matrix.mul_assoc, hLeft]
  simp +decide [← Matrix.mul_assoc, ← Matrix.transpose_mul, hLeft]

/-- The temporal projector transforms as a contravariant two-tensor. -/
theorem temporalProjector_congr
    (A : Matrix n n K) (m : Matrix n (Fin 1) K) (q : K) :
    temporalProjector (A * m) q =
      A * temporalProjector m q * Aᵀ := by
  unfold temporalProjector
  simp +decide [Matrix.mul_assoc]

/-- The response-corrected inverse metric is affine-probe covariant. -/
theorem debiasedMetric_congr
    (A G : Matrix n n K) (m : Matrix n (Fin 1) K) (q response : K) :
    debiasedMetric (A * G * Aᵀ) (A * m) q response =
      A * debiasedMetric G m q response * Aᵀ := by
  unfold debiasedMetric
  simp +decide [temporalProjector_congr, Matrix.mul_add, Matrix.add_mul,
    Matrix.mul_assoc]

/-- The differentiated temporal projector has the same covariance. -/
theorem temporalProjectorJet_congr
    (A : Matrix n n K) (m dm : Matrix n (Fin 1) K) (q dq : K) :
    temporalProjectorJet (A * m) (A * dm) q dq =
      A * temporalProjectorJet m dm q dq * Aᵀ := by
  unfold temporalProjectorJet
  simp +decide [Matrix.mul_add, Matrix.add_mul, Matrix.mul_assoc, Matrix.mul_sub,
    Matrix.sub_mul]

/-- The differentiated response correction is affine-probe covariant. -/
theorem debiasedMetricJet_congr
    (A dG : Matrix n n K) (m dm : Matrix n (Fin 1) K)
    (q dq response : K) :
    debiasedMetricJet (A * dG * Aᵀ) (A * m) (A * dm) q dq response =
      A * debiasedMetricJet dG m dm q dq response * Aᵀ := by
  convert congrArg (fun x => A * dG * Aᵀ + (response - 1) • x)
    (temporalProjectorJet_congr A m dm q dq) using 1
  simp +decide [debiasedMetricJet, Matrix.mul_add, Matrix.add_mul,
    Matrix.mul_assoc]

/-- A rational 1+1 witness where response correction maps a biased Lorentzian
form exactly to the mostly-minus Minkowski form. -/
theorem nontrivial_response_correction_witness :
    debiasedMetric
        (!![2, 0; 0, -1] : Matrix (Fin 2) (Fin 2) ℚ)
        (!![1; 0] : Matrix (Fin 2) (Fin 1) ℚ)
        (1 / 2) (1 / 2) =
      (!![1, 0; 0, -1] : Matrix (Fin 2) (Fin 2) ℚ) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [debiasedMetric, temporalProjector, Matrix.mul_apply,
      Matrix.transpose_apply, Fin.sum_univ_two]
  · norm_num [vecHead, vecTail]
  · rfl

end PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias
