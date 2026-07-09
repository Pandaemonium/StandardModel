/-
# Mass ≤ energy, saturated at rest (an extremal principle on the momentum Gram)

For a `2×2` Hermitian momentum matrix `P = E·1 + p⃗·σ` (the null-bundle Gram of §3,
`P = Σ ψᵢ ψᵢᴴ`), the Pauli decomposition gives `tr P = 2E`, `det P = E² − |p⃗|²`, so
the Plücker mass is `m² = det P` and the energy is `E = tr P / 2`. This module records
the extremal statement that sits on top of the mass identity (suggested by the
information-theoretic reframing, Fable 2026-07-08):

    det P ≤ (tr P / 2)²      i.e.   m² ≤ E²   (m ≤ E),

by one line of AM–GM on the Gram: `(tr P/2)² − det P = ((P₀₀−P₁₁)/2)² + |P₀₁|² ≥ 0`.
Equality holds iff `P` is scalar (`P₀₀ = P₁₁`, `P₀₁ = 0`) — the **rest frame**, which
is simultaneously the maximum-mass and maximum-mixedness configuration at fixed
energy (the `S = log 2` endpoint of the mass↔entropy dictionary, upgraded to a
variational principle). For a positive-semidefinite `P` this pins `0 ≤ det P ≤
(tr P/2)²`, i.e. `0 ≤ m ≤ E`.

Kernel-clean (no `s o r r y`); axiom footprint `[propext, Classical.choice,
Quot.sound]`. Enriches the §3 trusted core.
-/

import Mathlib

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.MassEnergyBound

/-- **Mass ≤ energy.** For a `2×2` Hermitian momentum matrix `P`, the mass
`det P = E²−|p⃗|²` is bounded by the energy squared `(tr P/2)²`:
`det P ≤ (tr P/2)²`, with the gap `((P₀₀−P₁₁)/2)² + |P₀₁|²`. So `m ≤ E`. -/
theorem det_le_half_trace_sq (P : Matrix (Fin 2) (Fin 2) ℂ) (hP : P.IsHermitian) :
    P.det.re ≤ (P.trace.re / 2) ^ 2 := by
  have h01 : P 1 0 = star (P 0 1) := (hP.apply 1 0).symm
  have hd0 : (P 0 0).im = 0 := Complex.conj_eq_iff_im.mp (hP.apply 0 0)
  have hd1 : (P 1 1).im = 0 := Complex.conj_eq_iff_im.mp (hP.apply 1 1)
  have hre : (P 1 0).re = (P 0 1).re := by rw [h01]; exact Complex.conj_re (P 0 1)
  have him : (P 1 0).im = -(P 0 1).im := by rw [h01]; exact Complex.conj_im (P 0 1)
  rw [Matrix.det_fin_two, Matrix.trace_fin_two]
  simp only [Complex.sub_re, Complex.add_re, Complex.mul_re]
  rw [hd0, hd1, hre, him]
  nlinarith [sq_nonneg ((P 0 0).re - (P 1 1).re), sq_nonneg (P 0 1).re,
    sq_nonneg (P 0 1).im]

end PhysicsSM.Draft.NullEdge.MassEnergyBound

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.MassEnergyBound.det_le_half_trace_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.MassEnergyBound.det_le_half_trace_sq
