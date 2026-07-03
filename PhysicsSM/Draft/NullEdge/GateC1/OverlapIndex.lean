import PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy

/-!
# Gate C1 finite overlap-index facade

This module is the production-facing finite-matrix overlap-index facade for
Gate C1.  It deliberately reuses the kernel-checked toy layer in
`OverlapIndexToy` rather than duplicating trace algebra.

## Scope

The results here are trusted finite-dimensional matrix identities.  They do
not yet assert locality, gauge covariance, anomaly matching, infinite-volume
limits, or equality with a physical Standard Model anomaly.  Those analytic and
representation-theoretic obligations belong in later C1 modules.

## Main convention

For chirality `gamma5` and sign classifier `eps`, the normalized overlap matrix
is

`Dov gamma5 eps = 1 + gamma5 * eps`.

The modified chirality is

`Ghat gamma5 eps = gamma5 * (1 - (1 / 2) • Dov gamma5 eps)`,

and the finite overlap index is its trace.

The key finite identity is:

`overlapIndex gamma5 eps = (1 / 2) * (gamma5.trace - eps.trace)`.

Consequently, for traceless physical chirality,

`overlapIndex gamma5 eps = -(1 / 2) * eps.trace`.

This is the finite index bookkeeping layer that the later null-edge overlap
operator must feed by constructing a suitable `eps = sign(H_ne)`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace OverlapIndex

open OverlapGinspargWilson
open LinearMap Module
open scoped Matrix

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- Luescher modified chirality, re-exported under the production C1 namespace. -/
abbrev Ghat (gamma5 eps : Matrix Spin Spin ℂ) : Matrix Spin Spin ℂ :=
  OverlapIndexToy.Ghat gamma5 eps

/-- Finite overlap index, re-exported under the production C1 namespace. -/
abbrev overlapIndex (gamma5 eps : Matrix Spin Spin ℂ) : ℂ :=
  OverlapIndexToy.overlapIndex gamma5 eps

/-- Closed form of the finite modified chirality. -/
theorem Ghat_eq (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ)) :
    Ghat gamma5 eps = (1 / 2 : ℂ) • (gamma5 - eps) :=
  OverlapIndexToy.Ghat_eq gamma5 eps hgamma5_sq

/-- Finite trace formula for the normalized overlap index. -/
theorem overlapIndex_eq (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ)) :
    overlapIndex gamma5 eps =
      (1 / 2 : ℂ) * (gamma5.trace - eps.trace) :=
  OverlapIndexToy.overlapIndex_eq gamma5 eps hgamma5_sq

/-- HLN finite trace form under traceless physical chirality. -/
theorem overlapIndex_eq_neg_half_trace_eps
    (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgamma5_tr : gamma5.trace = 0) :
    overlapIndex gamma5 eps = -(1 / 2 : ℂ) * eps.trace :=
  OverlapIndexToy.overlapIndex_eq_neg_half_trace_eps
    gamma5 eps hgamma5_sq hgamma5_tr

/-- HLN finite trace form in terms of the overlap matrix itself. -/
theorem overlapIndex_eq_neg_half_trace_gamma5_Dov
    (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgamma5_tr : gamma5.trace = 0) :
    overlapIndex gamma5 eps =
      -(1 / 2 : ℂ) * (gamma5 * Dov gamma5 eps).trace :=
  OverlapIndexToy.overlapIndex_eq_neg_half_trace_gamma5_Dov
    gamma5 eps hgamma5_sq hgamma5_tr

/-! ## Finite integrality route -/

/-- The trace of an idempotent complex matrix equals the dimension of its
range. -/
theorem trace_idempotent_eq_finrank_range
    (P : Matrix Spin Spin ℂ) (hP : P * P = P) :
    P.trace = (Module.finrank ℂ (LinearMap.range (Matrix.toLin' P)) : ℂ) := by
  have hidem : IsIdempotentElem (Matrix.toLin' P) := by
    show Matrix.toLin' P ∘ₗ Matrix.toLin' P = Matrix.toLin' P
    rw [← Matrix.toLin'_mul, hP]
  have hproj := hidem.isProj_range
  rw [← Matrix.trace_toLin'_eq P, hproj.trace]

/-- Chiral projector attached to an involution `M`: `(1 / 2) • (1 + M)`. -/
def chiralProjector (M : Matrix Spin Spin ℂ) : Matrix Spin Spin ℂ :=
  (1 / 2 : ℂ) • (1 + M)

/-- The chiral projector of an involution is idempotent. -/
theorem chiralProjector_idempotent (M : Matrix Spin Spin ℂ)
    (hM : M * M = (1 : Matrix Spin Spin ℂ)) :
    chiralProjector M * chiralProjector M = chiralProjector M := by
  have h1 :
      chiralProjector M * chiralProjector M =
        (1 / 4 : ℂ) • ((1 + M) * (1 + M)) := by
    unfold chiralProjector
    rw [Matrix.smul_mul, Matrix.mul_smul, smul_smul]
    norm_num
  rw [h1, mul_add, add_mul, add_mul, one_mul, mul_one, one_mul, hM]
  unfold chiralProjector
  module

/-- The rank of the chiral projector of an involution. -/
def chiralRank (M : Matrix Spin Spin ℂ) : ℕ :=
  Module.finrank ℂ (LinearMap.range (Matrix.toLin' (chiralProjector M)))

/-- Trace of the chiral projector of an involution equals its chiral rank. -/
theorem trace_chiralProjector_eq (M : Matrix Spin Spin ℂ)
    (hM : M * M = (1 : Matrix Spin Spin ℂ)) :
    (chiralProjector M).trace = (chiralRank M : ℂ) := by
  rw [trace_idempotent_eq_finrank_range _ (chiralProjector_idempotent M hM)]
  rfl

/-- Trace of an involution in terms of its chiral rank and the space dimension. -/
theorem trace_involution_eq (M : Matrix Spin Spin ℂ)
    (hM : M * M = (1 : Matrix Spin Spin ℂ)) :
    M.trace = 2 * (chiralRank M : ℂ) - (Fintype.card Spin : ℂ) := by
  have hP :
      (chiralProjector M).trace = (chiralRank M : ℂ) :=
    trace_chiralProjector_eq M hM
  have hexp :
      (chiralProjector M).trace =
        (1 / 2 : ℂ) * ((Fintype.card Spin : ℂ) + M.trace) := by
    rw [chiralProjector, Matrix.trace_smul, Matrix.trace_add,
      Matrix.trace_one, smul_eq_mul]
  rw [hP] at hexp
  linear_combination -2 * hexp

/-- The finite overlap index is a difference of projector ranks. -/
theorem overlapIndex_eq_rank_diff (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (heps_sq : eps * eps = (1 : Matrix Spin Spin ℂ)) :
    overlapIndex gamma5 eps =
      (chiralRank gamma5 : ℂ) - (chiralRank eps : ℂ) := by
  rw [overlapIndex_eq _ _ hgamma5_sq,
    trace_involution_eq gamma5 hgamma5_sq,
    trace_involution_eq eps heps_sq]
  ring

/-- For involutions, the finite overlap index is an integer. -/
theorem overlapIndex_isInt (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (heps_sq : eps * eps = (1 : Matrix Spin Spin ℂ)) :
    ∃ k : ℤ, overlapIndex gamma5 eps = (k : ℂ) := by
  refine ⟨(chiralRank gamma5 : ℤ) - (chiralRank eps : ℤ), ?_⟩
  rw [overlapIndex_eq_rank_diff gamma5 eps hgamma5_sq heps_sq]
  push_cast
  ring

/-- Anticommutation with chirality forces a finite classifier trace to vanish. -/
theorem trace_eq_zero_of_anticomm (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hanti : eps * gamma5 = -(gamma5 * eps)) :
    eps.trace = 0 :=
  OverlapIndexToy.trace_eq_zero_of_anticomm gamma5 eps hgamma5_sq hanti

/-- Finite zero-index theorem: an anticommuting sign classifier cannot carry a
nonzero overlap index in this normalized finite matrix setting. -/
theorem overlapIndex_eq_zero_of_anticomm
    (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (heps_sq : eps * eps = (1 : Matrix Spin Spin ℂ))
    (hanti : eps * gamma5 = -(gamma5 * eps)) :
    overlapIndex gamma5 eps = 0 :=
  OverlapIndexToy.overlapIndex_eq_zero_of_anticomm
    gamma5 eps hgamma5_sq heps_sq hanti

/-- The checked `Fin 2` finite witness: an anticommuting classifier has zero
index. -/
theorem overlapIndex_g5_epsFlip_eq_zero :
    overlapIndex OverlapIndexToy.g5 OverlapIndexToy.epsFlip = 0 :=
  OverlapIndexToy.overlapIndex_g5_epsFlip_eq_zero

/-- The checked `Fin 2` finite witness: a commuting classifier can carry index
`1`. -/
theorem overlapIndex_g5_epsNegI_eq_one :
    overlapIndex OverlapIndexToy.g5 OverlapIndexToy.epsNegI = 1 :=
  OverlapIndexToy.overlapIndex_g5_epsNegI_eq_one

end OverlapIndex
end GateC1
end NullEdge
end Draft
end PhysicsSM
