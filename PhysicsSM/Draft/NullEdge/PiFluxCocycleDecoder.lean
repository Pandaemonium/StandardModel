import Mathlib
import PhysicsSM.Draft.NullEdge.U1HistoryClosureHolonomy

/-!
# Position-dependent pi-flux translation seed

This module isolates the position-dependent escape from the
momentum-independent flavor-projector obstruction. On a finite periodic
two-dimensional cell, `translateX` is an ordinary shift while `translateY`
includes a sign depending on the x coordinate. The two translations
anticommute, so their plaquette commutator is the nontrivial central phase
`-1`.

This is only a local cocycle building block for a possible 3+1 twisted flavor
cover. It does not construct a compatible decoder, prove a doubler-free walk,
or perform a zero-and-pi Brillouin-zone census.

Provenance: clean-room finite magnetic-translation construction. The closure
interpretation is aligned with `U1HistoryClosureHolonomy`; no external code is
copied.
-/

namespace PhysicsSM.Draft.NullEdge.PiFluxCocycleDecoder

/-- A periodic two-by-two spatial cell. -/
abbrev Site := ZMod 2 × ZMod 2

/-- Complex amplitudes on the finite cell. -/
abbrev State := Site -> Complex

/-- The nonconstant sign attached to a y shift. -/
def xPhase (x : ZMod 2) : Complex :=
  if x = 0 then 1 else -1

/-- Ordinary periodic translation in the x direction. -/
def translateX (psi : State) : State :=
  fun p => psi (p.1 + 1, p.2)

/-- Periodic y translation with a position-dependent x sign. -/
def translateY (psi : State) : State :=
  fun p => xPhase p.1 * psi (p.1, p.2 + 1)

/-- The cocycle is genuinely position dependent. -/
theorem xPhase_nonconstant : xPhase 0 ≠ xPhase 1 := by
  norm_num [xPhase]

/-- The x-dependent sign flips under one x translation. -/
theorem xPhase_add_one (x : ZMod 2) :
    xPhase (x + 1) = -xPhase x := by
  fin_cases x <;> simp +decide [xPhase]

/-- Exact magnetic-translation relation: the two shifts anticommute. -/
theorem translateX_translateY_anticommute (psi : State) :
    translateX (translateY psi) = -translateY (translateX psi) := by
  ext ⟨x, y⟩
  simp [translateX, translateY, xPhase]
  fin_cases x <;> fin_cases y <;> simp +decide

/-- The ordinary periodic translation is exactly invertible. -/
theorem translateX_bijective : Function.Bijective translateX := by
  have h_inv : ∀ psi : State, translateX (translateX psi) = psi := by
    intro psi
    funext p
    simp [translateX]
    rcases p with ⟨x, y⟩
    fin_cases x <;> fin_cases y <;> rfl
  refine ⟨fun psi1 psi2 h => ?_, fun psi => ⟨translateX psi, h_inv psi⟩⟩
  rw [← h_inv psi1, ← h_inv psi2, h]

/-- The twisted periodic translation is exactly invertible. -/
theorem translateY_bijective : Function.Bijective translateY := by
  constructor
  · intro a b
    simp +decide [funext_iff, State] at *
    simp +decide [ZMod, Fin.forall_fin_two, translateY]
    unfold xPhase
    aesop
  · intro f
    use fun p => xPhase p.1 * f (p.1, p.2 - 1)
    ext ⟨x, y⟩
    fin_cases x <;> fin_cases y <;> simp +decide [translateY, xPhase]

/--
No pair of commuting global-sign translations can reproduce the nontrivial
central commutator of the position-dependent construction.
-/
theorem global_sign_translation_cannot_model_pi_flux
    (A B : State -> State) (hcomm : Function.Commute A B)
    (hA : A = translateX) (hB : B = translateY) : False := by
  contrapose! hcomm
  simp_all +decide [Function.Commute]
  intro h
  have hfun := h (fun _ => 1)
  have hsite := congr_fun hfun (0, 0)
  simp +decide [translateX, translateY, xPhase] at hsite
  norm_num at hsite

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PiFluxCocycleDecoder.xPhase_nonconstant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms xPhase_nonconstant

/-- info: 'PhysicsSM.Draft.NullEdge.PiFluxCocycleDecoder.xPhase_add_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms xPhase_add_one

/-- info: 'PhysicsSM.Draft.NullEdge.PiFluxCocycleDecoder.translateX_translateY_anticommute' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms translateX_translateY_anticommute

/-- info: 'PhysicsSM.Draft.NullEdge.PiFluxCocycleDecoder.translateX_bijective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms translateX_bijective

/-- info: 'PhysicsSM.Draft.NullEdge.PiFluxCocycleDecoder.translateY_bijective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms translateY_bijective

/-- info: 'PhysicsSM.Draft.NullEdge.PiFluxCocycleDecoder.global_sign_translation_cannot_model_pi_flux' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms global_sign_translation_cannot_model_pi_flux

end PhysicsSM.Draft.NullEdge.PiFluxCocycleDecoder
