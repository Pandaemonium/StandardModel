import Mathlib
import PhysicsSM.Draft.NullEdge.WindingLowModes
import PhysicsSM.Draft.NullEdge.IndexProtectionBridge
import PhysicsSM.Draft.NullEdge.Carrier.CarrierClosurePlane
import PhysicsSM.Draft.NullEdge.Goal1Confinement
import PhysicsSM.Draft.NullEdge.Goal1Hadron

open scoped BigOperators
open scoped Real
open Matrix

set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# Structured-holonomy binding capstone

This file assembles, over the landed finite APIs, the strongest honest statement
in the structured-closure direction: a nonzero winding topologically protects
low modes, while the carrier's own nontrivial closure plane produces a
singlet-channel two-body bound state strictly below the free constituent
threshold and leaves the ground mode as a spectator.

## Honesty statement (read before interpreting)

The **winding operator** `Kw N w` (`F4Winding.windingDirac`) and the **binding
Hamiltonian** `carrierH2 d κ` live in two *separate* finite sectors.  They are
tied together only by a shared *structured-background* interpretation: both are
finite shadows of the same closure datum.  We construct **no intertwiner**
between the two sectors, so nothing here claims that the winding *causes* the
binding.  The result is the simultaneous truth of two independent finite facts —
topological protection in the index sector and below-threshold binding in the
carrier sector — for one explicit structured witness.  It is **not** QCD
confinement and **not** a continuum-topology statement.

## Contents

* **Packet 1 — structured holonomy / protection.**  For every `N` and `w`, the
  winding operator's relative finite index is exactly `w`
  (`structured_relative_index`), its protected kernel has dimension exactly `w`
  (`structured_kernel_dim`), and for `0 < w` at least one protected mode exists
  (`structured_protected_mode`).  The `w = 0` negative control
  (`structured_zero_winding_no_protection`) shows the protection is genuinely
  topological.

* **Packet 2 — carrier closure plane.**  The carrier's `carrierK` is exactly the
  landed excited-mode closure curvature (`carrier_curvature_eq`), is nonzero
  (`carrier_curvature_ne_zero`) and antisymmetric (`carrier_curvature_antisymm`),
  couples the excited pair `{1,2}` (`carrier_couples_excited`) while leaving mode
  `0` a spectator (`carrier_ground_spectator`).

* **Packet 3 — binding.**  Using the actual landed carrier closure theorem
  `carrier_closure_binds` (not an inserted defect): under its sorted-spectrum and
  positive-coupling hypotheses the least two-body energy of `carrierH2` lies
  strictly below the free two-body threshold (`structured_binding`).

* **Packet 4 — exact nondegenerate witness.**  At `N = 3`, `w = 1`, `d = dW`,
  `κ = kW` the singlet ground energy is exactly `-1 < 1 =` threshold
  (`witness_boundEnergy`, `witness_pairThreshold`), one mode is protected, the
  relative index is one, the carrier curvature is nonzero, and the colored
  control channel is bounded at or above threshold (from `Goal1Confinement`).

* **Packet 5 — structured background record.**  `StructuredClosureBackground`
  packages the hypotheses; `structured_protection_and_binding` is the final
  theorem over it, and `structuredWitness` / `structured_capstone` give the
  explicit nondegenerate instance.
-/

namespace PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone

open F4Winding
open PhysicsSM.Draft.NullEdge.Carrier.InteractingTwoBody
open PhysicsSM.Draft.NullEdge.Carrier.DerivedInteraction
open PhysicsSM.Draft.NullEdge.Carrier.CarrierClosurePlane

/-! ## Packet 1 — general structured-holonomy protection packet -/

/-- **Relative finite index equals the winding.**  The winding-`w` closure
operator has relative finite index (`dim ker − dim coker`) exactly `w`. -/
theorem structured_relative_index (N w : ℕ) :
    (Module.finrank ℂ (LinearMap.ker (Kw N w)) : ℤ)
        - (Module.finrank ℂ ((Fin N → ℂ) ⧸ LinearMap.range (Kw N w)))
      = (w : ℤ) :=
  windingDirac_index N w

/-- **Protected kernel dimension equals the winding.** -/
theorem structured_kernel_dim (N w : ℕ) :
    Module.finrank ℂ (LinearMap.ker (Kw N w)) = w :=
  windingDirac_kernel N w

/-- **At least one protected mode for positive winding.** -/
theorem structured_protected_mode (N w : ℕ) (hw : 0 < w) :
    1 ≤ Module.finrank ℂ (LinearMap.ker (Kw N w)) := by
  rw [windingDirac_kernel N w]; exact hw

/-- **`w = 0` negative control.**  At zero winding there is no protection: the
kernel of the winding operator is trivial. -/
theorem structured_zero_winding_no_protection (N : ℕ) :
    Module.finrank ℂ (LinearMap.ker (Kw N 0)) = 0 :=
  windingDirac_zero_winding N

/-! ## Packet 2 — carrier closure-plane packet -/

/-- The carrier's curvature is exactly the landed excited-mode closure
curvature. -/
theorem carrier_curvature_eq : carrierK = closureCurvature :=
  carrierK_eq_closureCurvature

/-- The carrier's closure curvature is nonzero (its `(1,2)` entry is `-1`). -/
theorem carrier_curvature_ne_zero : carrierK ≠ 0 := by
  intro h
  have := congrFun (congrFun h 1) 2
  simp [carrierK] at this

/-- The carrier's closure curvature is antisymmetric. -/
theorem carrier_curvature_antisymm : (carrierK)ᵀ = -carrierK :=
  carrierK_antisymm

/-- The carrier's closure curvature couples the excited pair `{1,2}`. -/
theorem carrier_couples_excited : carrierK 1 2 ≠ 0 := by
  simp [carrierK]

/-- The ground mode `0` is a spectator: row and column `0` of `carrierK`
vanish. -/
theorem carrier_ground_spectator : ∀ j, carrierK 0 j = 0 ∧ carrierK j 0 = 0 :=
  carrierK_ground_spectator

/-! ## Packet 3 — binding packet from the landed carrier closure theorem -/

/-- **Structured binding.**  Under the landed carrier closure theorem's
sorted-spectrum (`d 0 ≤ d 1 ≤ d 2`) and positive-coupling (`0 < κ`) hypotheses,
the least eigenvalue of the carrier's two-body Hamiltonian `carrierH2 d κ` is
`boundEnergy d κ`, and it lies strictly below the free two-body threshold
`pairThreshold d`. -/
theorem structured_binding (d : Fin 3 → ℝ) (kappa : ℝ) (hk : 0 < kappa)
    (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2) :
    IsLeast (spectrumC (carrierH2 d kappa)) (boundEnergy d kappa) ∧
      boundEnergy d kappa < pairThreshold d :=
  carrier_closure_binds d kappa hk h01 h12

/-! ## Packet 4 — the exact nondegenerate witness at `N = 3`, `w = 1` -/

/-- The witness one-particle spectrum `d = (0, 1, 1)` (sorted, exact). -/
def dW : Fin 3 → ℝ := ![0, 1, 1]

/-- The witness closure coupling `κ = 2` (exact). -/
def kW : ℝ := 2

/-- The witness spectrum is sorted. -/
theorem dW_sorted : dW 0 ≤ dW 1 ∧ dW 1 ≤ dW 2 := by
  constructor <;> simp [dW]

/-- The witness coupling is positive. -/
theorem kW_pos : 0 < kW := by norm_num [kW]

/-- **Exact singlet ground energy.**  At the witness data the carrier's least
two-body energy is exactly `-1`. -/
theorem witness_boundEnergy : boundEnergy dW kW = -1 := by
  unfold boundEnergy PhysicsSM.Draft.NullEdge.Carrier.InteractingTwoBody.discr
  have hsqrt : Real.sqrt (((dW 0 + dW 1) - (dW 0 + dW 2)) ^ 2 / 4 + kW ^ 2) = 2 := by
    have : ((dW 0 + dW 1) - (dW 0 + dW 2)) ^ 2 / 4 + kW ^ 2 = (2 : ℝ) ^ 2 := by
      simp [dW, kW]
    rw [this, Real.sqrt_sq (by norm_num)]
  rw [hsqrt]
  simp only [dW, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
    Matrix.cons_val_two, Matrix.tail_cons]
  norm_num

/-- **Exact free threshold.**  At the witness data the free two-body threshold
is exactly `1`. -/
theorem witness_pairThreshold : pairThreshold dW = 1 := by
  unfold pairThreshold
  simp only [dW, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
    Matrix.cons_val_two, Matrix.tail_cons]
  norm_num

/-- **Exact singlet binding at the witness.**  The carrier's least two-body
energy `-1` lies strictly below the free threshold `1`. -/
theorem witness_singlet_below_threshold :
    boundEnergy dW kW = -1 ∧ pairThreshold dW = 1 ∧ (-1 : ℝ) < 1 :=
  ⟨witness_boundEnergy, witness_pairThreshold, by norm_num⟩

/-! ## Packet 5 — structured-background record and final theorem -/

/-- A finite **structured closure background**: a winding sector `(N, w)` with
`1 ≤ N` and `0 < w`, together with a carrier one-particle spectrum `d` (sorted)
and a positive closure coupling `κ`.  The two sectors share only this structured
interpretation; there is no intertwiner between them. -/
structure StructuredClosureBackground where
  /-- Lattice size of the winding sector. -/
  N : ℕ
  /-- Integer winding / topological charge. -/
  w : ℕ
  /-- Carrier one-particle spectrum. -/
  d : Fin 3 → ℝ
  /-- Closure coupling strength. -/
  kappa : ℝ
  /-- The lattice is nonempty. -/
  hN : 1 ≤ N
  /-- The winding is positive (so protection is non-vacuous). -/
  hw : 0 < w
  /-- The coupling is positive (attractive closure). -/
  hk : 0 < kappa
  /-- The spectrum is sorted (`d 0 ≤ d 1`). -/
  h01 : d 0 ≤ d 1
  /-- The spectrum is sorted (`d 1 ≤ d 2`). -/
  h12 : d 1 ≤ d 2

/-- **Final theorem over the structured background.**  For any structured closure
background the winding sector shows exact topological protection (relative index
`w`, kernel dimension `w`, at least one protected mode) and the carrier sector
shows the closure plane structure (curvature `= closureCurvature`, nonzero,
antisymmetric, coupling the excited pair, ground mode a spectator) together with
below-threshold two-body binding.  The two sectors are simultaneously true for
the same background; no intertwiner is asserted. -/
theorem structured_protection_and_binding (B : StructuredClosureBackground) :
    -- protection sector
    ((Module.finrank ℂ (LinearMap.ker (Kw B.N B.w)) : ℤ)
        - (Module.finrank ℂ ((Fin B.N → ℂ) ⧸ LinearMap.range (Kw B.N B.w)))
        = (B.w : ℤ))
    ∧ Module.finrank ℂ (LinearMap.ker (Kw B.N B.w)) = B.w
    ∧ 1 ≤ Module.finrank ℂ (LinearMap.ker (Kw B.N B.w))
    -- carrier closure plane
    ∧ carrierK = closureCurvature
    ∧ carrierK ≠ 0
    ∧ (carrierK)ᵀ = -carrierK
    ∧ carrierK 1 2 ≠ 0
    ∧ (∀ j, carrierK 0 j = 0 ∧ carrierK j 0 = 0)
    -- binding sector
    ∧ IsLeast (spectrumC (carrierH2 B.d B.kappa)) (boundEnergy B.d B.kappa)
    ∧ boundEnergy B.d B.kappa < pairThreshold B.d :=
  ⟨structured_relative_index B.N B.w,
   structured_kernel_dim B.N B.w,
   structured_protected_mode B.N B.w B.hw,
   carrier_curvature_eq,
   carrier_curvature_ne_zero,
   carrier_curvature_antisymm,
   carrier_couples_excited,
   carrier_ground_spectator,
   (structured_binding B.d B.kappa B.hk B.h01 B.h12).1,
   (structured_binding B.d B.kappa B.hk B.h01 B.h12).2⟩

/-- The explicit nondegenerate witness background at `N = 3`, `w = 1`, `d = dW`,
`κ = kW`. -/
def structuredWitness : StructuredClosureBackground where
  N := 3
  w := 1
  d := dW
  kappa := kW
  hN := by norm_num
  hw := by norm_num
  hk := kW_pos
  h01 := dW_sorted.1
  h12 := dW_sorted.2

/-- **Capstone witness.**  At the explicit nondegenerate witness (`N = 3`,
`w = 1`, `d = dW`, `κ = kW`):

* the relative finite index is exactly `1` and there is at least one protected
  mode (winding sector);
* the carrier closure curvature is nonzero (carrier sector);
* the singlet ground two-body energy is exactly `-1`, strictly below the free
  threshold `1` (binding sector);
* the colored control channel is bounded at or above the threshold `1`
  (`Goal1Confinement.colored_ground_ge_threshold`).

All rational/integer values are preserved exactly.  The winding and binding
sectors are simultaneously true for one background; no causal intertwiner is
claimed. -/
theorem structured_capstone :
    -- one protected mode and relative index one (winding sector)
    ((Module.finrank ℂ (LinearMap.ker (Kw structuredWitness.N structuredWitness.w)) : ℤ)
        - (Module.finrank ℂ
            ((Fin structuredWitness.N → ℂ) ⧸ LinearMap.range (Kw structuredWitness.N structuredWitness.w)))
        = 1)
    ∧ 1 ≤ Module.finrank ℂ (LinearMap.ker (Kw structuredWitness.N structuredWitness.w))
    -- carrier curvature nonzero (carrier sector)
    ∧ carrierK ≠ 0
    -- singlet ground energy exactly -1 < 1 (binding sector)
    ∧ boundEnergy dW kW = -1
    ∧ pairThreshold dW = 1
    ∧ boundEnergy dW kW < pairThreshold dW
    -- colored control at or above threshold
    ∧ (∀ μ ∈ Goal1Confinement.spec Goal1Confinement.Hcol, (1 : ℝ) ≤ μ) := by
  refine ⟨?_, ?_, carrier_curvature_ne_zero, witness_boundEnergy, witness_pairThreshold,
    ?_, Goal1Confinement.colored_ground_ge_threshold.1⟩
  · have := structured_relative_index structuredWitness.N structuredWitness.w
    simpa [structuredWitness] using this
  · have := structured_protected_mode structuredWitness.N structuredWitness.w (by norm_num [structuredWitness])
    simpa [structuredWitness] using this
  · rw [witness_boundEnergy, witness_pairThreshold]; norm_num

/-! ## Guard pins for every headline -/

/-- info: 'PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone.structured_relative_index' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms structured_relative_index

/-- info: 'PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone.structured_kernel_dim' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms structured_kernel_dim

/-- info: 'PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone.structured_protected_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms structured_protected_mode

/-- info: 'PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone.structured_zero_winding_no_protection' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms structured_zero_winding_no_protection

/-- info: 'PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone.carrier_curvature_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms carrier_curvature_eq

/-- info: 'PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone.carrier_curvature_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms carrier_curvature_ne_zero

/-- info: 'PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone.structured_binding' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms structured_binding

/-- info: 'PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone.witness_boundEnergy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_boundEnergy

/-- info: 'PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone.witness_pairThreshold' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_pairThreshold

/-- info: 'PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone.structured_protection_and_binding' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms structured_protection_and_binding

/-- info: 'PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone.structured_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms structured_capstone

end PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone
