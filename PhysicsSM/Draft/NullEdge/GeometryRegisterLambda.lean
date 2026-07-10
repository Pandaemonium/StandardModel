import Mathlib

/-!
# Superposed finite geometries and the Lambda phase on the geometry register

Finite rung of the null-edge program's "self-decoding universe" synthesis:
if the finite causal complex itself is in superposition, the cosmological
constant couples as the phase `exp (I * Λ * N̂)` where `N̂` counts elementary
null-information events of each geometry branch.  This package proves the
sharp finite statement: **Λ is observable exactly through geometry-register
coherence between branches of different event count.**

## Model

Two geometry branches `i : Fin 2` with event counts `N i : ℕ`, branch
amplitudes `a i : ℂ`, visible (direction-register) states
`ψ i : Fin 2 → ℂ`, and a geometry-record overlap matrix
`Om : Fin 2 → Fin 2 → ℂ` (`Om i i = 1`; `Om i j` with `i ≠ j` is the inner
product of the two branches' hidden geometry records: `0` = perfectly
distinguishable, `1` = identical).  The Λ-dressed reduced visible state after
tracing the geometry register is `rhoVis N Om a ψ Λ` below — each branch
carries the phase `exp (I * Λ * N i)`, and cross terms are weighted by the
record overlap, in exact parallel with the landed path-conditioned state
`rho_dir` of `PathSumSemantics` (with geometry as the hidden register).

## Targets

1. `rhoVis_isHermitian` — with a Hermitian overlap matrix, `rhoVis` is
   Hermitian (sanity structure).
2. `rhoVis_orthogonal_records_const` — decohered geometry: if the records are
   perfectly distinguishable (`Om i j = 0` off the diagonal), `rhoVis` does
   not depend on Λ at all.  A fully decohered multiverse hides Λ.
3. `rhoVis_equal_counts_const` — equal event counts: if `N 0 = N 1`, `rhoVis`
   does not depend on Λ (the phase is global).  Λ needs a code-size
   DIFFERENCE.
4. `rhoVis_offdiag_phase` — the interference coefficient carries exactly the
   relative phase `exp (I * Λ * (N 0 - N 1))` times its Λ = 0 value: Λ is
   Fourier-conjugate to event count, finitely.
5. `rhoVis_periodic` — for the witness counts `N = ![1, 3]` the visible state
   is periodic in Λ with period `π` (period `2π / |ΔN|`).
6. `rhoVis_lambda_observable` — the positive witness: with identical records
   (`Om = 1` everywhere), non-collinear visible states `ψ 0 = ![1, 0]`,
   `ψ 1 = ![0, 1]`, amplitudes `a = ![1, 1]`, and counts `![1, 3]`,
   `rhoVis` at `Λ = 0` differs from `rhoVis` at `Λ = π / 2`.  Together with
   target 2 this is the sharp claim: Λ is observable if and only if geometry
   branches of different event count stay coherent.

Honest scope: two branches, finite dimensions, overlap matrix supplied as
data; no continuum, no gravitational dynamics, no derivation of the value of
Λ.  Do not weaken the statements.  Helper lemmas are welcome.  Run the narrow
check `lake env lean GeometryRegisterLambda/GeometrySuperposition.lean`
rather than a full build.
Recovered from Aristotle project `e4aad67f-5c4d-48d6-81fe-1793cdf42c7b`; proof bodies verified locally
under the pinned toolchain before porting.
-/

namespace PhysicsSM.Draft.NullEdge.GeometryRegisterLambda

open Complex

/-- The Λ-dressed reduced visible state: the geometry register is traced out,
each branch `i` carrying the phase `exp (I * Λ * N i)`, cross terms weighted
by the geometry-record overlap `Om i j`. -/
noncomputable def rhoVis (N : Fin 2 → ℕ) (Om : Fin 2 → Fin 2 → ℂ)
    (a : Fin 2 → ℂ) (ψ : Fin 2 → Fin 2 → ℂ) (Λ : ℝ) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  ∑ i : Fin 2, ∑ j : Fin 2,
    (Complex.exp (Complex.I * (Λ : ℂ) * (N i : ℂ)) * a i *
        (starRingEnd ℂ) (Complex.exp (Complex.I * (Λ : ℂ) * (N j : ℂ)) * a j) *
          Om i j) •
      Matrix.of (fun r s => ψ i r * (starRingEnd ℂ) (ψ j s))

/-
Target 1: with a Hermitian overlap matrix, the reduced visible state is
Hermitian.
-/
theorem rhoVis_isHermitian (N : Fin 2 → ℕ) (Om : Fin 2 → Fin 2 → ℂ)
    (a : Fin 2 → ℂ) (ψ : Fin 2 → Fin 2 → ℂ) (Λ : ℝ)
    (hOm : ∀ i j, Om j i = (starRingEnd ℂ) (Om i j)) :
    (rhoVis N Om a ψ Λ).IsHermitian := by
  -- By definition of conjugate transpose, we need to show that $(\rhoVis N Om a ψ Λ)ᴴ = \rhoVis N Om a ψ Λ$.
  ext i j;
  fin_cases i <;> fin_cases j <;> simp +decide [ Fin.sum_univ_two, rhoVis ]; all_goals grind

/-
Target 2: decohered geometry hides Λ.  If the geometry records are
perfectly distinguishable, the visible state does not depend on Λ.
-/
theorem rhoVis_orthogonal_records_const (N : Fin 2 → ℕ)
    (a : Fin 2 → ℂ) (ψ : Fin 2 → Fin 2 → ℂ) (Λ Λ' : ℝ) :
    rhoVis N (fun i j => if i = j then 1 else 0) a ψ Λ =
      rhoVis N (fun i j => if i = j then 1 else 0) a ψ Λ' := by
  unfold rhoVis;
  simp +decide [ mul_assoc, mul_left_comm, mul_comm ];
  simp_all +decide [ mul_left_comm ( cexp _ ) ];
  simp +decide [ Complex.mul_conj, Complex.normSq_eq_norm_sq, Complex.norm_exp ]

/-
Target 3: equal event counts hide Λ.  If both branches have the same
event count, the Λ phase is global and cancels.
-/
theorem rhoVis_equal_counts_const (N : Fin 2 → ℕ) (Om : Fin 2 → Fin 2 → ℂ)
    (a : Fin 2 → ℂ) (ψ : Fin 2 → Fin 2 → ℂ) (Λ Λ' : ℝ)
    (hN : N 0 = N 1) :
    rhoVis N Om a ψ Λ = rhoVis N Om a ψ Λ' := by
  unfold rhoVis;
  simp_all +decide [ mul_assoc, mul_left_comm, mul_comm, Fin.sum_univ_two ];
  simp +decide [ mul_comm, ← mul_assoc, ← Complex.exp_conj, ← Complex.exp_add ]

/-
Target 4: Λ is Fourier-conjugate to event count.  The `(0,1)` interference
coefficient at Λ equals `exp (I * Λ * (N 0 - N 1))` times its value at
`Λ = 0`.  (Stated at the level of the scalar coefficient multiplying the
`i = 0, j = 1` cross block.)
-/
theorem rhoVis_offdiag_phase (N : Fin 2 → ℕ) (Λ : ℝ) :
    Complex.exp (Complex.I * (Λ : ℂ) * (N 0 : ℂ)) *
        (starRingEnd ℂ) (Complex.exp (Complex.I * (Λ : ℂ) * (N 1 : ℂ))) =
      Complex.exp (Complex.I * (Λ : ℂ) * ((N 0 : ℂ) - (N 1 : ℂ))) := by
  rw [← Complex.exp_conj, ← Complex.exp_add]
  congr 1
  simp [Complex.conj_I, mul_sub]
  ring

/-
Target 5: for counts `![1, 3]` the visible state is `π`-periodic in Λ
(period `2π / |ΔN|` with `ΔN = 2`).
-/
theorem rhoVis_periodic (Om : Fin 2 → Fin 2 → ℂ) (a : Fin 2 → ℂ)
    (ψ : Fin 2 → Fin 2 → ℂ) (Λ : ℝ) :
    rhoVis ![1, 3] Om a ψ (Λ + Real.pi) = rhoVis ![1, 3] Om a ψ Λ := by
  ext i j;
  simp +decide [ rhoVis, Complex.exp_add, mul_add, add_mul ];
  norm_num [ mul_comm Complex.I, Complex.exp_mul_I ];
  norm_num [ show ( Real.pi : ℂ ) * I * 3 = Real.pi * I + Real.pi * I + Real.pi * I by ring, Complex.exp_add ] ; ring

/-
Target 6: the positive witness.  With identical geometry records,
orthogonal visible states, unit amplitudes, and counts `![1, 3]`, the visible
state at `Λ = 0` differs from the visible state at `Λ = π / 2`: coherent
geometry branches of different event count make Λ observable.
-/
theorem rhoVis_lambda_observable :
    rhoVis ![1, 3] (fun _ _ => 1) ![1, 1] ![![1, 0], ![0, 1]] 0 ≠
      rhoVis ![1, 3] (fun _ _ => 1) ![1, 1] ![![1, 0], ![0, 1]] (Real.pi / 2) := by
  unfold rhoVis; norm_num [ Complex.ext_iff, Fin.forall_fin_two ] ;
  intro h; have := congr_fun ( congr_fun h 0 ) 1; norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, mul_div ] at this;
  norm_num [ show Real.pi / 2 * 3 = Real.pi + Real.pi / 2 by ring, Real.sin_add, Real.cos_add ] at this

end PhysicsSM.Draft.NullEdge.GeometryRegisterLambda

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GeometryRegisterLambda.rhoVis_orthogonal_records_const' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GeometryRegisterLambda.rhoVis_orthogonal_records_const

/-- info: 'PhysicsSM.Draft.NullEdge.GeometryRegisterLambda.rhoVis_lambda_observable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GeometryRegisterLambda.rhoVis_lambda_observable
