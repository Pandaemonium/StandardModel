import Mathlib

/-!
# Finite Jordan-Clifford exterior and fermion-kernel backbone

This module verifies the pure finite-dimensional and central-phase arithmetic
underlying three proposed Jordan-Clifford bridge rungs:

* the color exterior degrees have dimensions `1 + 3 + 3 + 1 = 8`;
* the even exterior degrees of a five-mode space have dimensions
  `1 + 10 + 5 = 16`;
* for the six even weak/color bidegrees and the convention
  `6Y = 3 N_W - 2 N_V`, the center of the covering group has exactly the
  standard six-element kernel.

The kernel is not inferred from cardinality alone: it is proved equal to the
injective image of the six standard powers `(m mod 3, m mod 2, m)`. Nearby
pure `SU(2)`, `SU(3)`, and `U(1)` center elements are explicit controls.

Scope: finite exterior-degree and modular arithmetic. This module does not yet
construct the actual `SU(3) x SU(2) x U(1)` representation, transport the
kernel to a Lie-group homomorphism, identify the Furey left-action module
equivariantly with an exterior algebra, or derive the weak/color spaces from a
Jordan flag. In particular, the `Z6` here is the kernel of the proposed cover
action, not a kernel of the faithful group `S(U(2) x U(3))`.

Provenance: Aristotle project `c56bb440-74b2-41e0-b9ed-7b6a7714cc9a`,
independently compiled and semantically strengthened on 2026-07-11. Exterior
dimension conventions follow the standard `Spin(10)` Fock organization; the
phase formula is clean-room finite arithmetic. No external source code was
copied.

Lean 4.28.0.
-/

namespace PhysicsSM.Draft.JordanCliffordFermionKernel

open scoped ExteriorAlgebra

/-- Coordinate color space, used only to pin complex dimension three. -/
abbrev Vcolor : Type := Fin 3 -> Complex

/-- Coordinate weak space, used only to pin complex dimension two. -/
abbrev Wweak : Type := Fin 2 -> Complex

/-- Coordinate five-mode space, used only to pin complex dimension five. -/
abbrev Egen : Type := Fin 5 -> Complex

theorem finrank_Vcolor : Module.finrank Complex Vcolor = 3 := by simp

theorem finrank_Wweak : Module.finrank Complex Wweak = 2 := by simp

theorem finrank_Egen : Module.finrank Complex Egen = 5 := by simp

theorem color_dim_deg0 : Module.finrank Complex (⋀[Complex]^0 Vcolor) = 1 := by
  rw [exteriorPower.finrank_eq, finrank_Vcolor]
  rfl

theorem color_dim_deg1 : Module.finrank Complex (⋀[Complex]^1 Vcolor) = 3 := by
  rw [exteriorPower.finrank_eq, finrank_Vcolor]
  rfl

theorem color_dim_deg2 : Module.finrank Complex (⋀[Complex]^2 Vcolor) = 3 := by
  rw [exteriorPower.finrank_eq, finrank_Vcolor]
  rfl

theorem color_dim_deg3 : Module.finrank Complex (⋀[Complex]^3 Vcolor) = 1 := by
  rw [exteriorPower.finrank_eq, finrank_Vcolor]
  rfl

/-- The four color exterior degrees have total complex dimension eight. -/
theorem color_exterior_total_dim :
    Module.finrank Complex (⋀[Complex]^0 Vcolor) +
      Module.finrank Complex (⋀[Complex]^1 Vcolor) +
      Module.finrank Complex (⋀[Complex]^2 Vcolor) +
      Module.finrank Complex (⋀[Complex]^3 Vcolor) = 8 := by
  rw [color_dim_deg0, color_dim_deg1, color_dim_deg2, color_dim_deg3]

theorem generation_dim_deg0 : Module.finrank Complex (⋀[Complex]^0 Egen) = 1 := by
  rw [exteriorPower.finrank_eq, finrank_Egen]
  rfl

theorem generation_dim_deg2 : Module.finrank Complex (⋀[Complex]^2 Egen) = 10 := by
  rw [exteriorPower.finrank_eq, finrank_Egen]
  rfl

theorem generation_dim_deg4 : Module.finrank Complex (⋀[Complex]^4 Egen) = 5 := by
  rw [exteriorPower.finrank_eq, finrank_Egen]
  rfl

/-- The even exterior degrees of five modes have total complex dimension
sixteen. -/
theorem generation_even_total_dim :
    Module.finrank Complex (⋀[Complex]^0 Egen) +
      Module.finrank Complex (⋀[Complex]^2 Egen) +
      Module.finrank Complex (⋀[Complex]^4 Egen) = 16 := by
  rw [generation_dim_deg0, generation_dim_deg2, generation_dim_deg4]

/-- Integer phase exponent modulo six for a central cover element on weak
degree `p` and color degree `q`:
`2 k3 q + 3 k2 p + m (3 p - 2 q)`. -/
def centralPhase (k3 k2 m p q : Int) : Int :=
  2 * k3 * q + 3 * k2 * p + m * (3 * p - 2 * q)

/-- Central cover labels acting trivially on all six even weak/color
bidegrees `(0,0)`, `(2,0)`, `(0,2)`, `(1,1)`, `(1,3)`, `(2,2)`. -/
def fermionCentralKernel : Finset (Fin 3 × Fin 2 × Fin 6) :=
  Finset.univ.filter (fun t =>
    let k3 : Int := t.1.val
    let k2 : Int := t.2.1.val
    let m : Int := t.2.2.val
    centralPhase k3 k2 m 0 0 % 6 = 0 /\
      centralPhase k3 k2 m 2 0 % 6 = 0 /\
      centralPhase k3 k2 m 0 2 % 6 = 0 /\
      centralPhase k3 k2 m 1 1 % 6 = 0 /\
      centralPhase k3 k2 m 1 3 % 6 = 0 /\
      centralPhase k3 k2 m 2 2 % 6 = 0)

/-- The standard six generator powers, reduced into the centers of `SU(3)`,
`SU(2)`, and the sixth roots in `U(1)`. -/
def standardKernelPower (m : Fin 6) : Fin 3 × Fin 2 × Fin 6 :=
  (⟨m.val % 3, Nat.mod_lt _ (by decide)⟩,
    ⟨m.val % 2, Nat.mod_lt _ (by decide)⟩,
    m)

/-- The standard-power parametrization is injective because its third
coordinate retains the power itself. -/
theorem standardKernelPower_injective : Function.Injective standardKernelPower := by
  intro a b hab
  exact congrArg (fun t : Fin 3 × Fin 2 × Fin 6 => t.2.2) hab

/-- The finite fermion central kernel is exactly the six standard generator
powers. This is stronger than a cardinality count. -/
theorem fermionCentralKernel_eq_standardPowers :
    fermionCentralKernel = Finset.univ.image standardKernelPower := by
  decide

/-- The finite fermion central kernel has exactly six elements. -/
theorem fermionCentralKernel_card : fermionCentralKernel.card = 6 := by
  rw [fermionCentralKernel_eq_standardPowers, Finset.card_image_of_injective]
  · simp
  · exact standardKernelPower_injective

/-- The first standard generator power lies in the kernel. -/
theorem standard_generator_mem :
    ((1 : Fin 3), (1 : Fin 2), (1 : Fin 6)) ∈ fermionCentralKernel := by
  decide

/-- Pure `SU(2)` center is not in the kernel. -/
theorem pure_su2_control_not_mem :
    ((0 : Fin 3), (1 : Fin 2), (0 : Fin 6)) ∉ fermionCentralKernel := by
  decide

/-- Pure `SU(3)` center is not in the kernel. -/
theorem pure_su3_control_not_mem :
    ((1 : Fin 3), (0 : Fin 2), (0 : Fin 6)) ∉ fermionCentralKernel := by
  decide

/-- A primitive sixth-root `U(1)` phase without compensating `SU(3)` and
`SU(2)` centers is not in the kernel. -/
theorem pure_u1_control_not_mem :
    ((0 : Fin 3), (0 : Fin 2), (1 : Fin 6)) ∉ fermionCentralKernel := by
  decide

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.JordanCliffordFermionKernel.color_exterior_total_dim' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms color_exterior_total_dim

/-- info: 'PhysicsSM.Draft.JordanCliffordFermionKernel.generation_even_total_dim' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms generation_even_total_dim

/-- info: 'PhysicsSM.Draft.JordanCliffordFermionKernel.fermionCentralKernel_eq_standardPowers' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fermionCentralKernel_eq_standardPowers

/-- info: 'PhysicsSM.Draft.JordanCliffordFermionKernel.standard_generator_mem' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms standard_generator_mem

/-- info: 'PhysicsSM.Draft.JordanCliffordFermionKernel.pure_u1_control_not_mem' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pure_u1_control_not_mem

end PhysicsSM.Draft.JordanCliffordFermionKernel
