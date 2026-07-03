import Mathlib
import PhysicsSM.Draft.NullEdge.GateC1.OverlapGinspargWilson

/-!
# Finite overlap-index toy layer (Gate C1, job C266)

This module is the *finite-dimensional* overlap-index toy layer requested by
job C266 (companion roadmap: `null-edge-c263-index-anomaly-bridge-plan`).  It
builds directly on `OverlapGinspargWilson.Dov` and the Ginsparg–Wilson identity
`OverlapGinspargWilson.dov_ginsparg_wilson`.

Everything here is pure `Matrix` trace algebra over `ℂ`; there is **no**
functional calculus, locality, gauge covariance, or infinite-volume index
theory (those are explicitly out of scope per the prompt).

## Conventions

For chirality `gamma5` and a sign-like involution `eps`, the normalized overlap
matrix is `Dov gamma5 eps = 1 + gamma5 * eps` (Neuberger form, lattice spacing
`a = 1`, prefactor dropped).

The **Lüscher modified chirality** of the overlap is

`Ghat gamma5 eps = gamma5 * (1 - (1/2) • Dov gamma5 eps)`

and the **lattice chiral index** is its trace,

`overlapIndex gamma5 eps = (Ghat gamma5 eps).trace`.

The central exact identity (`overlapIndex_eq`) is, for `gamma5^2 = 1`,

`overlapIndex gamma5 eps = (1/2) * (gamma5.trace - eps.trace)`.

When chirality is traceless (`gamma5.trace = 0`, the physical normalization on a
balanced Dirac space) this collapses to the textbook Hasenfratz–Laliena–
Niedermayer form `overlapIndex = -(1/2) * eps.trace = -(1/2) * Tr(gamma5 * Dov)`.

## Zero / nonzero index

* `overlapIndex_eq_zero_of_anticomm`: if `eps` **anticommutes** with `gamma5`
  (both involutions) then the index vanishes.  This is the clean, always-true
  zero-index theorem.
* `overlapIndex_g5_negI_eq_one`: an explicit `Fin 2` toy with index `1`,
  realized by a `gamma5`-**commuting** `eps`.  Together these two facts show
  that the naive "commuting ⇒ zero / anticommuting ⇒ nonzero" dichotomy
  proposed in the C263 plan is *inverted*: it is *anticommutation* that forces
  the index to vanish, while a commuting classifier can carry a nonzero index.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace OverlapIndexToy

open OverlapGinspargWilson

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- Lüscher GW-modified chirality of the normalized overlap matrix. -/
def Ghat (gamma5 eps : Matrix Spin Spin ℂ) : Matrix Spin Spin ℂ :=
  gamma5 * (1 - (1/2 : ℂ) • Dov gamma5 eps)

/-- Lattice chiral index of the normalized overlap matrix. -/
def overlapIndex (gamma5 eps : Matrix Spin Spin ℂ) : ℂ :=
  (Ghat gamma5 eps).trace

/-
Closed form of the modified chirality: `Ghat = (1/2) • (gamma5 - eps)`.
-/
theorem Ghat_eq (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ)) :
    Ghat gamma5 eps = (1/2 : ℂ) • (gamma5 - eps) := by
  convert congr_arg ( fun x : Matrix Spin Spin ℂ => gamma5 * x ) _ using 1;
  rotate_left;
  exact ( 1 / 2 : ℂ ) • ( 1 - gamma5 * eps );
  · ext i j ; norm_num [ Dov ] ; ring;
  · simp +decide [ mul_sub, ← mul_assoc, hgamma5_sq ]

/-
Trace formula for the lattice chiral index.
-/
theorem overlapIndex_eq (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ)) :
    overlapIndex gamma5 eps = (1/2 : ℂ) * (gamma5.trace - eps.trace) := by
  convert congr_arg Matrix.trace ( Ghat_eq gamma5 eps hgamma5_sq ) using 1;
  simp +decide [ Matrix.trace_sub, Matrix.trace_smul ]

/-
Hasenfratz–Laliena–Niedermayer form under traceless chirality:
`overlapIndex = -(1/2) * eps.trace`.
-/
theorem overlapIndex_eq_neg_half_trace_eps (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgamma5_tr : gamma5.trace = 0) :
    overlapIndex gamma5 eps = -(1/2 : ℂ) * eps.trace := by
  rw [ overlapIndex_eq _ _ hgamma5_sq ] ; rw [ hgamma5_tr ] ; ring

/-
HLN form in terms of the overlap matrix itself (traceless chirality):
`overlapIndex = -(1/2) * Tr(gamma5 * Dov)`.
-/
theorem overlapIndex_eq_neg_half_trace_gamma5_Dov (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgamma5_tr : gamma5.trace = 0) :
    overlapIndex gamma5 eps = -(1/2 : ℂ) * (gamma5 * Dov gamma5 eps).trace := by
  convert overlapIndex_eq_neg_half_trace_eps gamma5 eps hgamma5_sq hgamma5_tr using 1;
  norm_num [ Matrix.trace_mul_comm gamma5, mul_add, add_mul, hgamma5_tr, hgamma5_sq, Dov ];
  rw [ ← Matrix.trace_mul_comm ] ; simp +decide [ ← mul_assoc, hgamma5_sq ] ;

/-
An involution that anticommutes with the chirality involution `gamma5` is
traceless.
-/
theorem trace_eq_zero_of_anticomm (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hanti : eps * gamma5 = -(gamma5 * eps)) :
    eps.trace = 0 := by
  apply_fun fun m => gamma5 * m * gamma5 at hanti;
  simp_all +decide [ Matrix.mul_assoc ];
  simp_all +decide [ ← mul_assoc ];
  have h_trace : (gamma5 * eps * gamma5).trace = eps.trace := by
    rw [ ← Matrix.trace_mul_comm ] ; simp +decide [ ← mul_assoc, hgamma5_sq ] ;
  simp_all +decide [ mul_assoc, Matrix.trace_neg ];
  linear_combination' -h_trace / 2

/-
Zero-index theorem: if the sign-like classifier `eps` **anticommutes** with
chirality `gamma5` (both involutions), the lattice chiral index vanishes.

This is the correct finite-matrix zero-index statement.  Note it is
*anticommutation*, not commutation, that kills the index.
-/
theorem overlapIndex_eq_zero_of_anticomm (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (heps_sq : eps * eps = (1 : Matrix Spin Spin ℂ))
    (hanti : eps * gamma5 = -(gamma5 * eps)) :
    overlapIndex gamma5 eps = 0 := by
  rw [ overlapIndex_eq _ _ hgamma5_sq ];
  rw [ trace_eq_zero_of_anticomm gamma5 eps hgamma5_sq hanti, trace_eq_zero_of_anticomm eps gamma5 heps_sq ] ; ring;
  rw [ hanti, neg_neg ]

/-! ### Concrete `Fin 2` toy witnesses -/

/-- Toy chirality on `Fin 2`: `diag(1, -1)`. -/
def g5 : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- Toy classifier (anticommuting with `g5`): the off-diagonal flip. -/
def epsFlip : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- Toy classifier (commuting with `g5`): `-1`. -/
def epsNegI : Matrix (Fin 2) (Fin 2) ℂ := !![-1, 0; 0, -1]

theorem g5_sq : g5 * g5 = (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ g5 ]

theorem g5_trace : g5.trace = 0 := by
  norm_num [ g5, Matrix.trace_fin_two ]

theorem epsFlip_sq : epsFlip * epsFlip = (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ epsFlip ]

theorem epsFlip_anticomm : epsFlip * g5 = -(g5 * epsFlip) := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ epsFlip, g5 ]

theorem epsNegI_sq : epsNegI * epsNegI = (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ epsNegI ] ;

theorem epsNegI_comm : epsNegI * g5 = g5 * epsNegI := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ epsNegI, g5 ]

/-
Zero-index witness: anticommuting classifier gives index `0`.
-/
theorem overlapIndex_g5_epsFlip_eq_zero : overlapIndex g5 epsFlip = 0 := by
  apply overlapIndex_eq_zero_of_anticomm g5 epsFlip g5_sq epsFlip_sq epsFlip_anticomm

/-
Nonzero-index witness: a `gamma5`-commuting classifier with index `1`.
This refutes the "commuting ⇒ zero index" expectation.
-/
theorem overlapIndex_g5_epsNegI_eq_one : overlapIndex g5 epsNegI = 1 := by
  convert overlapIndex_eq _ _ g5_sq using 1;
  norm_num [ g5, epsNegI, Matrix.trace ]

end OverlapIndexToy
end GateC1
end NullEdge
end Draft
end PhysicsSM
