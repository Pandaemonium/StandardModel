import Mathlib
import PhysicsSM.NullStrand.Conventions

/-!
# NullStrand.NullFiber.FluxFinite

Manifest nodes KIN-006 and KIN-009: the abstract finite flux theorems. For any
finite null resolution with barycenter `U`, the flux-reweighted mean observer
direction is the relative velocity `U/(n·U) − n` (KIN-006, the key kinematic
theorem), and the flux-averaged strand rate `E[1/(n·k)]` is `1/(n·U)` (KIN-009).
Both hold from the barycenter alone — the flux factor `(n·k)` cancels pointwise.

Uses the shared `Conventions.minkowskiInner` (+---).

Provenance: clean-room statements; proofs from Aristotle projects
`0bd56d9e-...` (KIN-006) and `c5923fb8-...` (KIN-009), verified `sorry`/`axiom`-free
and statement-identical (modulo reusing the shared `minkowskiInner`), integrated
2026-06-25.
-/

namespace PhysicsSM.NullStrand.NullFiber

open scoped BigOperators
open Finset PhysicsSM.NullStrand

/-- KIN-006. The flux-weighted mean observer direction equals `U/(n·U) − n`. -/
theorem finiteFluxDirectionMean_eq_relativeVelocity
    {Ω : Type*} [Fintype Ω]
    (n U : Fin 4 → ℝ) (ν : Ω → ℝ) (k : Ω → (Fin 4 → ℝ))
    (hbary : ∑ w, ν w • k w = U)
    (hnU : minkowskiInner n U ≠ 0)
    (hnk : ∀ w, minkowskiInner n (k w) ≠ 0) :
    (∑ w, (ν w * minkowskiInner n (k w) / minkowskiInner n U) •
        (fun i => k w i / minkowskiInner n (k w) - n i))
      = (fun i => U i / minkowskiInner n U - n i) := by
  ext i
  have key : ∀ j, ∑ w, ν w * k w j = U j := by
    intro j
    have h := congrFun hbary j
    simpa [Finset.sum_apply, Pi.smul_apply] using h
  have h_sum : ∑ w, ν w * minkowskiInner n (k w) = minkowskiInner n U := by
    simp only [minkowskiInner]
    rw [← key 0, ← key 1, ← key 2, ← key 3, Finset.mul_sum, Finset.mul_sum,
      Finset.mul_sum, Finset.mul_sum, ← Finset.sum_sub_distrib, ← Finset.sum_sub_distrib,
      ← Finset.sum_sub_distrib]
    exact Finset.sum_congr rfl fun w _ => by ring
  have expand : ∀ w, (ν w * minkowskiInner n (k w) / minkowskiInner n U)
      * (k w i / minkowskiInner n (k w) - n i)
      = ν w * k w i / minkowskiInner n U
        - (n i / minkowskiInner n U) * (ν w * minkowskiInner n (k w)) := by
    intro w
    have h1 := hnk w
    have h2 := hnU
    field_simp
  simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul]
  rw [Finset.sum_congr rfl fun w _ => expand w, Finset.sum_sub_distrib, ← Finset.sum_div,
    key i, ← Finset.mul_sum, h_sum, div_mul_cancel₀ _ hnU]

/-- KIN-009. The flux-weighted mean of the strand rate `1/(n·k)` is `1/(n·U)`. -/
theorem finiteFluxMean_dsdt_eq_invGamma
    {Ω : Type*} [Fintype Ω]
    (n U : Fin 4 → ℝ) (ν : Ω → ℝ) (k : Ω → (Fin 4 → ℝ))
    (hνsum : ∑ w, ν w = 1)
    (hnU : minkowskiInner n U ≠ 0)
    (hnk : ∀ w, minkowskiInner n (k w) ≠ 0) :
    (∑ w, (ν w * minkowskiInner n (k w) / minkowskiInner n U)
        * (1 / minkowskiInner n (k w)))
      = 1 / minkowskiInner n U := by
  have hterm : ∀ w ∈ (Finset.univ : Finset Ω),
      (ν w * minkowskiInner n (k w) / minkowskiInner n U)
        * (1 / minkowskiInner n (k w))
        = ν w / minkowskiInner n U := by
    intro w _
    field_simp [hnk w]
  rw [Finset.sum_congr rfl hterm, ← Finset.sum_div, hνsum]

end PhysicsSM.NullStrand.NullFiber
