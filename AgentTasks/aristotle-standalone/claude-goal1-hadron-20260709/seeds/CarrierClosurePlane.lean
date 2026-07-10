import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.DerivedInteraction

/-!
# Does the carrier's OWN closure curvature `K` land in the binding plane? (F5)

The companion file `DerivedInteraction.lean` proves a **conditional** binding
result: the second-quantized closure interaction `Vderived = dΓ(i·κ·K)` binds a
two-body state strictly below the constituent threshold **iff** the closure
curvature `K` acts among the *excited* modes (`closureCurvature`, giving
`derived_boundState_below_threshold`) rather than in a plane containing the
ground mode (`closureCurvature2`, giving `derived_wrongPlane_no_binding`).

The one grade-**C** gap flagged there is: *which plane does the carrier's actual
`K` occupy?*  The carrier's one-particle mass block is

  `B(λ,κ) = λ·I + i·κ·K`  on `Fin 3`

with aperture `λ` on the diagonal and the (real, antisymmetric) closure curvature
`K` supplying the off-diagonal closure part.  This file closes the gap by a
finite, concrete matrix computation.

## What is proved

* **The carrier `K` (`carrierK`).**  Reading the closure (off-diagonal) part off
  the mass block gives the explicit real antisymmetric generator
  `carrierK = !![0,0,0; 0,0,-1; 0,1,0]`.
  `massBlock_eq_carrierK` proves `B(λ,κ) = λ·I + i·κ·carrierK` exactly, so
  `carrierK` is genuinely the closure generator of the carrier block, and
  `carrierK_isReal` / `carrierK_antisymm` confirm it is real and antisymmetric.

* **Which plane it occupies.**  `carrierK_eq_closureCurvature` proves
  `carrierK = closureCurvature`: the carrier's curvature is the *excited-mode*
  (binding-plane) curvature.  `carrierK_ground_spectator` shows the ground mode
  `0` is a spectator (row/column `0` of `carrierK` vanish), so the curvature acts
  purely in the excited plane `{1,2}`.  Conversely
  `carrierK_ne_closureCurvature2` proves `carrierK ≠ closureCurvature2`, and
  `closureCurvature2_couples_ground` shows the ground-plane curvature *does*
  couple mode `0` — the decisive geometric difference.

* **The C → M upgrade (`carrier_closure_binds`).**  Because the carrier's own `K`
  is the binding-plane curvature, `derived_boundState_below_threshold` fires for
  the carrier's own mass-block data with **no** extra "if the closure acts among
  excited modes" hypothesis.  We build the carrier's second-quantized two-body
  Hamiltonian `carrierH2` directly from the mass block (`carrierH2_eq_H2der`
  identifies it with `H2der`) and conclude it has a bound state strictly below
  the free two-body threshold.

## Verdict

The carrier's closure curvature `K` lands in the **binding plane**: it is the
excited-mode curvature `closureCurvature`, coupling modes `{1,2}` with the ground
mode as a spectator.  Hence **this carrier binds**: its closure geometry produces
a genuine two-body bound state strictly below the constituent threshold,
unconditionally.
-/

open scoped BigOperators
open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.Carrier.CarrierClosurePlane

open PhysicsSM.Draft.NullEdge.Carrier.InteractingTwoBody
open PhysicsSM.Draft.NullEdge.Carrier.DerivedInteraction

/-! ## 1. The carrier's own closure curvature `K` -/

/-- **The carrier's closure curvature `K`.**  This is the real antisymmetric
generator obtained by reading the off-diagonal *closure* part off the carrier
mass block `B(λ,κ) = λ·I + i·κ·K`.  Explicitly it acts in the plane of the two
excited modes `{1,2}` with the ground mode `0` as a spectator. -/
def carrierK : Matrix (Fin 3) (Fin 3) ℂ := !![0,0,0; 0,0,-1; 0,1,0]

/-- **Extraction of `K` from the mass block.**  The carrier block decomposes
*exactly* as `B(λ,κ) = λ·I + i·κ·carrierK`, so `carrierK` is genuinely the
closure generator of the block (the aperture `λ` sits on the diagonal, the
closure `κ` multiplies `i·carrierK`). -/
theorem massBlock_eq_carrierK (lam kappa : ℝ) :
    massBlock lam kappa
      = (lam : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)
        + (kappa : ℂ) • (Complex.I • carrierK) := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [massBlock, oneBodyClosure, closureCurvature, carrierK, Matrix.smul_apply]

/-- The closure part `B(λ,κ) - λ·I` of the mass block is exactly `i·κ·carrierK`. -/
theorem massBlock_closurePart (lam kappa : ℝ) :
    massBlock lam kappa - (lam : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)
      = (kappa : ℂ) • (Complex.I • carrierK) := by
  rw [massBlock_eq_carrierK]; abel

/-- `carrierK` is real (every entry has zero imaginary part). -/
theorem carrierK_isReal : ∀ i j, (carrierK i j).im = 0 := by
  intro i j; fin_cases i <;> fin_cases j <;> simp [carrierK]

/-- `carrierK` is antisymmetric: `Kᵀ = -K`. -/
theorem carrierK_antisymm : (carrierK)ᵀ = -carrierK := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [carrierK, Matrix.transpose]

/-! ## 2. Which plane does `K` occupy? -/

/-- **The carrier's `K` is the excited-mode (binding-plane) curvature.**
`carrierK = closureCurvature`, the curvature acting among the excited modes
`{1,2}` for which `DerivedInteraction` proves binding. -/
theorem carrierK_eq_closureCurvature : carrierK = closureCurvature := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [carrierK, closureCurvature]

/-- **The ground mode is a spectator.**  Row and column `0` of `carrierK` vanish:
the closure curvature does not touch the ground mode, so it acts purely in the
excited plane `{1,2}`. -/
theorem carrierK_ground_spectator : ∀ j, carrierK 0 j = 0 ∧ carrierK j 0 = 0 := by
  intro j; fin_cases j <;> exact ⟨by simp [carrierK], by simp [carrierK]⟩

/-- **The carrier's `K` is NOT the ground-plane curvature.**
`carrierK ≠ closureCurvature2`. -/
theorem carrierK_ne_closureCurvature2 : carrierK ≠ closureCurvature2 := by
  intro h
  have := congrFun (congrFun h 0) 1
  simp [carrierK, closureCurvature2] at this

/-- The decisive contrast: the ground-plane curvature `closureCurvature2` *does*
couple the ground mode `0` (its `(0,1)` entry is nonzero), unlike the carrier's
`carrierK`. -/
theorem closureCurvature2_couples_ground : closureCurvature2 0 1 ≠ 0 := by
  simp [closureCurvature2]

/-! ## 3. The C → M upgrade: the carrier binds unconditionally -/

/-- The carrier's one-body operator on the three modes: the diagonal energies `d`
plus the closure part `i·κ·carrierK` read off the mass block (independent of the
overall aperture shift `λ`). -/
noncomputable def carrierOneBody (d : Fin 3 → ℝ) (kappa : ℝ) :
    Matrix (Fin 3) (Fin 3) ℂ :=
  (Matrix.diagonal d).map Complex.ofReal + (kappa : ℂ) • (Complex.I • carrierK)

/-- The carrier's second-quantized two-body Hamiltonian: `dΓ` of the carrier's
own one-body operator (diagonal energies + the mass-block closure curvature). -/
noncomputable def carrierH2 (d : Fin 3 → ℝ) (kappa : ℝ) :
    Matrix (Fin 3) (Fin 3) ℂ :=
  dGamma2 (carrierOneBody d kappa)

/-- The carrier's two-body Hamiltonian is exactly the derived Hamiltonian
`H2der`: the carrier's own `K` is the curvature whose second quantization is the
binding interaction. -/
theorem carrierH2_eq_H2der (d : Fin 3 → ℝ) (kappa : ℝ) :
    carrierH2 d kappa = H2der d kappa := by
  unfold carrierH2 carrierOneBody H2der
  rw [carrierK_eq_closureCurvature]
  rfl

/-- **The carrier binds — unconditionally.**

Because the carrier's own closure curvature `K = carrierK` lands in the binding
plane (`carrierK_eq_closureCurvature`), the conditional binding theorem
`derived_boundState_below_threshold` fires with the carrier's own mass-block
data, with **no** extra "if the closure acts among the excited modes"
hypothesis.  For a sorted one-particle spectrum `d 0 ≤ d 1 ≤ d 2` and closure
strength `κ > 0`, the carrier's second-quantized two-body Hamiltonian
`carrierH2 = dΓ(diag d + i·κ·carrierK)` has least eigenvalue `boundEnergy d κ`
lying strictly below the free two-body threshold `pairThreshold d`.

This is the decisive C → M upgrade: *this* carrier's closure geometry produces a
genuine hadronic bound state below the constituent threshold. -/
theorem carrier_closure_binds
    (d : Fin 3 → ℝ) (kappa : ℝ) (hk : 0 < kappa)
    (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2) :
    IsLeast (spectrumC (carrierH2 d kappa)) (boundEnergy d kappa) ∧
      boundEnergy d kappa < pairThreshold d := by
  rw [carrierH2_eq_H2der]
  exact derived_boundState_below_threshold d kappa hk h01 h12

/-! ## Axiom footprint -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierClosurePlane.massBlock_eq_carrierK' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massBlock_eq_carrierK

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierClosurePlane.carrierK_eq_closureCurvature' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms carrierK_eq_closureCurvature

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierClosurePlane.carrier_closure_binds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms carrier_closure_binds

end PhysicsSM.Draft.NullEdge.Carrier.CarrierClosurePlane
