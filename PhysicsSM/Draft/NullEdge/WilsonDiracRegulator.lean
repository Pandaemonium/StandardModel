import PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk

/-!
# Wilson regulator for the live 3+1 Clifford Hamiltonian

The ordered finite-range walk studied in Paper I has exact corner aliases and
mass-independent body-center modes.  This module records a constructive
Hamiltonian-level alternative.  The momentum-dependent Wilson mass

`m + r * ((1 - cos qx) + (1 - cos qy) + (1 - cos qz))`

uses the same live Clifford generators.  Its square is a scalar energy, a
positive bare mass gives a uniform global gap, and in the massless case with
`r > 0` the energy vanishes exactly when all three cosines equal one.  Thus the
unwanted Brillouin corners are removed without changing the first-order Dirac
tangent at the origin.

This is a nearest-neighbor continuous-time Hamiltonian regulator.  Its exact
matrix exponential is unitary, but this module does not claim that the
finite-time exponential is a strictly finite-range one-step QCA.

Provenance: clean-room finite-dimensional Wilson-term construction, composed
with the kernel-checked Clifford square in `SuccessiveAxisDiracWalk.H_sq`.
-/

noncomputable section

open Matrix Complex Real

namespace PhysicsSM.Draft.NullEdge.WilsonDiracRegulator

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- The scalar Wilson correction to the rest coefficient. -/
def wilsonMass (qx qy qz m r : Real) : Real :=
  m + r * ((1 - Real.cos qx) + (1 - Real.cos qy) + (1 - Real.cos qz))

/-- Wilson-regularized Hamiltonian in the project's live Clifford basis. -/
def H (qx qy qz m r : Real) : Mat4 :=
  SuccessiveAxisDiracWalk.H
    (Real.sin qx : Complex) (Real.sin qy : Complex) (Real.sin qz : Complex)
    (wilsonMass qx qy qz m r : Complex)

/-- Scalar square of the Wilson-regularized Hamiltonian. -/
def energySq (qx qy qz m r : Real) : Real :=
  Real.sin qx ^ 2 + Real.sin qy ^ 2 + Real.sin qz ^ 2 +
    wilsonMass qx qy qz m r ^ 2

/-- Exact relativistic-style square, now with the momentum-dependent Wilson
rest coefficient. -/
theorem H_sq (qx qy qz m r : Real) :
    H qx qy qz m r * H qx qy qz m r =
      (energySq qx qy qz m r : Complex) • (1 : Mat4) := by
  simpa [H, energySq] using
    SuccessiveAxisDiracWalk.H_sq
      (Real.sin qx : Complex) (Real.sin qy : Complex) (Real.sin qz : Complex)
      (wilsonMass qx qy qz m r : Complex)

/-- The Wilson rest coefficient is no smaller than the nonnegative bare mass. -/
theorem bare_mass_le_wilsonMass (qx qy qz m r : Real)
    (_hm : 0 <= m) (hr : 0 <= r) :
    m <= wilsonMass qx qy qz m r := by
  have hx : 0 <= 1 - Real.cos qx := sub_nonneg.mpr (Real.cos_le_one qx)
  have hy : 0 <= 1 - Real.cos qy := sub_nonneg.mpr (Real.cos_le_one qy)
  have hz : 0 <= 1 - Real.cos qz := sub_nonneg.mpr (Real.cos_le_one qz)
  simp only [wilsonMass]
  nlinarith

/-- A positive bare mass gives a uniform all-momentum spectral gap. -/
theorem bare_mass_sq_le_energySq (qx qy qz m r : Real)
    (hm : 0 <= m) (hr : 0 <= r) :
    m ^ 2 <= energySq qx qy qz m r := by
  have hmw := bare_mass_le_wilsonMass qx qy qz m r hm hr
  have hw0 : 0 <= wilsonMass qx qy qz m r := le_trans hm hmw
  have hx := sq_nonneg (Real.sin qx)
  have hy := sq_nonneg (Real.sin qy)
  have hz := sq_nonneg (Real.sin qz)
  simp only [energySq]
  nlinarith

theorem energySq_pos_of_bare_mass_pos (qx qy qz m r : Real)
    (hm : 0 < m) (hr : 0 <= r) :
    0 < energySq qx qy qz m r := by
  have hgap := bare_mass_sq_le_energySq qx qy qz m r (le_of_lt hm) hr
  nlinarith [sq_pos_of_pos hm]

/-- In the massless theory with positive Wilson parameter, the only zeros are
the physical origin modulo `2*pi` in each momentum coordinate.  The theorem is
stated without choosing representatives: `cos qj = 1` is the exact periodic
condition. -/
theorem massless_energy_eq_zero_iff (qx qy qz r : Real) (hr : 0 < r) :
    energySq qx qy qz 0 r = 0 <->
      Real.cos qx = 1 /\ Real.cos qy = 1 /\ Real.cos qz = 1 := by
  constructor
  · intro hE
    have hx2 : 0 <= Real.sin qx ^ 2 := sq_nonneg _
    have hy2 : 0 <= Real.sin qy ^ 2 := sq_nonneg _
    have hz2 : 0 <= Real.sin qz ^ 2 := sq_nonneg _
    have hw2 : 0 <= wilsonMass qx qy qz 0 r ^ 2 := sq_nonneg _
    have hw_sq : wilsonMass qx qy qz 0 r ^ 2 = 0 := by
      simp only [energySq] at hE
      nlinarith
    have hw : wilsonMass qx qy qz 0 r = 0 := sq_eq_zero_iff.mp hw_sq
    have hsum : (1 - Real.cos qx) + (1 - Real.cos qy) +
        (1 - Real.cos qz) = 0 := by
      simp only [wilsonMass, zero_add] at hw
      exact (mul_eq_zero.mp hw).resolve_left (ne_of_gt hr)
    have hx : 0 <= 1 - Real.cos qx := sub_nonneg.mpr (Real.cos_le_one qx)
    have hy : 0 <= 1 - Real.cos qy := sub_nonneg.mpr (Real.cos_le_one qy)
    have hz : 0 <= 1 - Real.cos qz := sub_nonneg.mpr (Real.cos_le_one qz)
    constructor
    · nlinarith
    · constructor <;> nlinarith
  · rintro ⟨hx, hy, hz⟩
    have hsx : Real.sin qx = 0 := by
      nlinarith [Real.sin_sq_add_cos_sq qx]
    have hsy : Real.sin qy = 0 := by
      nlinarith [Real.sin_sq_add_cos_sq qy]
    have hsz : Real.sin qz = 0 := by
      nlinarith [Real.sin_sq_add_cos_sq qz]
    simp [energySq, wilsonMass, hx, hy, hz, hsx, hsy, hsz]

/-- Exact nondegenerate corner control: every non-origin cubic corner acquires
strictly positive energy in the massless Wilson regulator. -/
theorem pi_x_corner_energy (r : Real) :
    energySq Real.pi 0 0 0 r = 4 * r ^ 2 := by
  simp [energySq, wilsonMass]
  ring

theorem pi_x_corner_energy_pos (r : Real) (hr : 0 < r) :
    0 < energySq Real.pi 0 0 0 r := by
  rw [pi_x_corner_energy]
  positivity

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.WilsonDiracRegulator.H_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms H_sq

/-- info: 'PhysicsSM.Draft.NullEdge.WilsonDiracRegulator.massless_energy_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_energy_eq_zero_iff

/-- info: 'PhysicsSM.Draft.NullEdge.WilsonDiracRegulator.pi_x_corner_energy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pi_x_corner_energy

end PhysicsSM.Draft.NullEdge.WilsonDiracRegulator
