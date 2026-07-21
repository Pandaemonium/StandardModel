import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
import PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

/-!
# Finite Brillouin-corner audit for the live 3+1 split walk

This module evaluates the massless successive-axis walk exactly at all eight
high-symmetry momenta whose coordinates are `0` or `pi`.  A corner with even
parity is the identity matrix and therefore has Floquet quasienergy `0`; a
corner with odd parity is minus the identity and therefore has quasienergy
`pi` modulo `2 * pi`.  In particular, three distinct nonzero corners alias the
origin at the level of the exact one-step symbol.

The audit also finds a stronger obstruction away from those corners.  At
body-center momentum `(pi/2, pi/2, pi/2)`, the complete massive step is a
non-scalar involution for every mass angle.  Explicit nonzero `+1` and `-1`
eigenmodes show that exact quasienergies `0` and `pi` persist, so this regulator
cannot open a global Floquet gap merely by turning on its mass coin.

The continuum tangent Hamiltonian is also tied to the complex Pluecker-mass
module.  Its exact Clifford square depends only on squared spatial momentum
and squared mass, and the massless square is constant on Euclidean momentum
spheres.

Honest scope: the results are exact identities at the eight corners and one
interior high-symmetry point.  They establish decisive aliases and a global-gap
obstruction for the present split step, but do not classify the complete Bloch
zero set or establish a physical species count.

Provenance: clean-room specialization of the live split step in
`Compact3Plus1DiracRate` and its Clifford square in
`Pluecker3Plus1ComplexMass`.  The walk architecture is informed by
Mlodinow--Brun, arXiv:1802.03910; all statements below are independently
kernel-checked finite matrix identities under the project conventions.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.Finite3Plus1BrillouinAudit

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex
abbrev Momentum := Fin 3 -> Real

/-- The live four-factor step in lattice-angle variables, with zero mass. -/
def masslessWalk (qx qy qz : Real) : Mat4 :=
  Compact3Plus1DiracRate.splitStep qx qy qz 0 1

/-- The Brillouin high-symmetry angle selected by a Boolean corner bit. -/
def cornerAngle (b : Bool) : Real := if b then Real.pi else 0

/-- A Boolean-labeled corner of the three-dimensional Brillouin zone. -/
def cornerMomentum (bx by_ bz : Bool) : Momentum :=
  ![cornerAngle bx, cornerAngle by_, cornerAngle bz]

/-- The massless walk evaluated at a Boolean-labeled Brillouin corner. -/
def cornerWalk (bx by_ bz : Bool) : Mat4 :=
  masslessWalk (cornerAngle bx) (cornerAngle by_) (cornerAngle bz)

/-- Boolean parity of the number of `pi` coordinates at a corner. -/
def oddCorner (bx by_ bz : Bool) : Bool :=
  Bool.xor (Bool.xor bx by_) bz

/-- Scalar Floquet phase represented in the same `factor` convention as the
live walk. -/
def quasienergyPhase (omega : Real) : Mat4 :=
  Compact3Plus1DiracRate.factor omega (1 : Mat4)

/-- All eight massless corners are classified exactly by parity: even corners
give `+I`, while odd corners give `-I`. -/
theorem massless_corner_parity_classification (bx by_ bz : Bool) :
    cornerWalk bx by_ bz =
      if oddCorner bx by_ bz then -(1 : Mat4) else 1 := by
  cases bx <;> cases by_ <;> cases bz <;>
    simp [cornerWalk, cornerAngle, oddCorner, masslessWalk,
      Compact3Plus1DiracRate.splitStep, Compact3Plus1DiracRate.factor]

/-- Exact quasienergy reading of the parity classification.  With the phase
convention `exp (-i omega)`, even corners have `omega = 0` and odd corners
have `omega = pi` modulo `2 * pi`. -/
theorem massless_corner_quasienergy_classification (bx by_ bz : Bool) :
    cornerWalk bx by_ bz =
      quasienergyPhase (if oddCorner bx by_ bz then Real.pi else 0) := by
  cases bx <;> cases by_ <;> cases bz <;>
    simp [cornerWalk, cornerAngle, oddCorner, masslessWalk, quasienergyPhase,
      Compact3Plus1DiracRate.splitStep, Compact3Plus1DiracRate.factor]

/-- The four even-parity corners, including the origin, all have the exact
zero-quasienergy symbol `+I`. -/
theorem zero_quasienergy_corner_values :
    cornerWalk false false false = 1 ∧
      cornerWalk true true false = 1 ∧
      cornerWalk true false true = 1 ∧
      cornerWalk false true true = 1 := by
  simp [massless_corner_parity_classification, oddCorner]

/-- The four odd-parity corners all have the exact `pi`-quasienergy symbol
`-I`. -/
theorem pi_quasienergy_corner_values :
    cornerWalk true false false = -(1 : Mat4) ∧
      cornerWalk false true false = -(1 : Mat4) ∧
      cornerWalk false false true = -(1 : Mat4) ∧
      cornerWalk true true true = -(1 : Mat4) := by
  simp [massless_corner_parity_classification, oddCorner]

/-- The origin and `(pi, pi, 0)` are distinct momenta with exactly the same
one-step walk symbol.  This is an explicit zero-quasienergy corner alias. -/
theorem origin_alias_pi_pi_zero :
    cornerMomentum false false false ≠ cornerMomentum true true false ∧
      cornerWalk false false false = cornerWalk true true false := by
  constructor
  · intro h
    have h0 := congrFun h 0
    simp [cornerMomentum, cornerAngle] at h0
    exact (ne_of_gt Real.pi_pos) h0.symm
  · rw [zero_quasienergy_corner_values.1,
      zero_quasienergy_corner_values.2.1]

/-- The origin and `(pi, 0, pi)` are distinct momenta with exactly the same
one-step walk symbol. -/
theorem origin_alias_pi_zero_pi :
    cornerMomentum false false false ≠ cornerMomentum true false true ∧
      cornerWalk false false false = cornerWalk true false true := by
  constructor
  · intro h
    have h0 := congrFun h 0
    simp [cornerMomentum, cornerAngle] at h0
    exact (ne_of_gt Real.pi_pos) h0.symm
  · rw [zero_quasienergy_corner_values.1,
      zero_quasienergy_corner_values.2.2.1]

/-- The origin and `(0, pi, pi)` are distinct momenta with exactly the same
one-step walk symbol. -/
theorem origin_alias_zero_pi_pi :
    cornerMomentum false false false ≠ cornerMomentum false true true ∧
      cornerWalk false false false = cornerWalk false true true := by
  constructor
  · intro h
    have h1 := congrFun h 1
    simp [cornerMomentum, cornerAngle] at h1
    exact (ne_of_gt Real.pi_pos) h1.symm
  · rw [zero_quasienergy_corner_values.1,
      zero_quasienergy_corner_values.2.2.2]

/-- The live real-mass Hamiltonian is exactly the complex Pluecker Hamiltonian
on the real mass axis. -/
theorem continuum_H_agrees_with_pluecker
    (kx ky kz m : Real) :
    Compact3Plus1DiracRate.H kx ky kz m =
      Pluecker3Plus1ComplexMass.H4 kx ky kz (m : Complex) := by
  unfold Pluecker3Plus1ComplexMass.H4 Compact3Plus1DiracRate.H
  rw [Pluecker3Plus1ComplexMass.real_mass_reduces]
  rfl

/-- Exact relativistic square for the continuum tangent Hamiltonian of the
live split walk. -/
theorem continuum_H_square (kx ky kz m : Real) :
    Compact3Plus1DiracRate.H kx ky kz m *
        Compact3Plus1DiracRate.H kx ky kz m =
      (((kx ^ 2 + ky ^ 2 + kz ^ 2 + m ^ 2 : Real) : Complex)) •
        (1 : Mat4) := by
  rw [continuum_H_agrees_with_pluecker]
  simpa [Complex.normSq, pow_two] using
    Pluecker3Plus1ComplexMass.H4_sq kx ky kz (m : Complex)

/-- Massless continuum isotropy: the squared Hamiltonian is the scalar
Euclidean squared momentum times the identity. -/
theorem massless_continuum_H_square_isotropic (kx ky kz : Real) :
    Compact3Plus1DiracRate.H kx ky kz 0 *
        Compact3Plus1DiracRate.H kx ky kz 0 =
      (((kx ^ 2 + ky ^ 2 + kz ^ 2 : Real) : Complex)) • (1 : Mat4) := by
  simpa using continuum_H_square kx ky kz 0

/-- Two massless continuum momenta with the same Euclidean squared norm have
the same squared Hamiltonian. -/
theorem massless_continuum_H_square_eq_of_norm_sq_eq
    (kx ky kz px py pz : Real)
    (hR : kx ^ 2 + ky ^ 2 + kz ^ 2 = px ^ 2 + py ^ 2 + pz ^ 2) :
    Compact3Plus1DiracRate.H kx ky kz 0 *
        Compact3Plus1DiracRate.H kx ky kz 0 =
      Compact3Plus1DiracRate.H px py pz 0 *
        Compact3Plus1DiracRate.H px py pz 0 := by
  rw [massless_continuum_H_square_isotropic,
    massless_continuum_H_square_isotropic, hR]

/-! ## A stronger interior obstruction -/

/-- The exact lattice step at the body-center momentum
`(pi/2, pi/2, pi/2)`, with arbitrary mass angle `theta`. -/
def bodyCenterWalk (theta : Real) : Mat4 :=
  Compact3Plus1DiracRate.splitStep
    (Real.pi / 2) (Real.pi / 2) (Real.pi / 2) theta 1

/-- Closed matrix form of the body-center step. -/
def bodyCenterClosed (theta : Real) : Mat4 :=
  let c : Complex := Real.cos theta
  let s : Complex := Real.sin theta
  !![0, 0, -(c + I * s), 0;
     0, 0, 0, -(c + I * s);
     -(c - I * s), 0, 0, 0;
     0, -(c - I * s), 0, 0]

set_option maxHeartbeats 800000 in
/-- The ordered split step reduces to the displayed off-diagonal closed form
at body-center momentum. -/
theorem body_center_walk_eq_closed (theta : Real) :
    bodyCenterWalk theta = bodyCenterClosed theta := by
  unfold bodyCenterWalk bodyCenterClosed
    Compact3Plus1DiracRate.splitStep Compact3Plus1DiracRate.factor
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Compact3Plus1DiracRate.alpha1,
      Compact3Plus1DiracRate.alpha2,
      Compact3Plus1DiracRate.alpha3,
      Compact3Plus1DiracRate.beta,
      Matrix.mul_apply, Fin.sum_univ_four]

/-- At body-center momentum the complete massive step is an involution for
every mass angle.  Thus its quasienergies remain confined to `0` and `pi`
rather than opening a global massive gap. -/
theorem body_center_walk_sq (theta : Real) :
    bodyCenterWalk theta * bodyCenterWalk theta = 1 := by
  have htrig :
      (Real.sin theta : Complex) ^ 2 + (Real.cos theta : Complex) ^ 2 = 1 := by
    exact_mod_cast Real.sin_sq_add_cos_sq theta
  rw [body_center_walk_eq_closed]
  unfold bodyCenterClosed
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four,
      ← Complex.ofReal_sin, ← Complex.ofReal_cos] <;>
    ring_nf <;>
    rw [Complex.I_sq] <;>
    ring_nf <;>
    linear_combination htrig

/-- The body-center involution is never the identity: an off-diagonal entry
has unit modulus for every mass angle. -/
theorem body_center_walk_ne_one (theta : Real) :
    bodyCenterWalk theta ≠ 1 := by
  intro h
  rw [body_center_walk_eq_closed] at h
  have h02 := congrFun (congrFun h 0) 2
  simp [bodyCenterClosed, Complex.ext_iff] at h02
  have hc : Real.cos theta = 0 := by simpa using h02.1
  have hs : Real.sin theta = 0 := by simpa using h02.2
  nlinarith [Real.sin_sq_add_cos_sq theta]

/-- The body-center involution is never minus the identity either. -/
theorem body_center_walk_ne_neg_one (theta : Real) :
    bodyCenterWalk theta ≠ -(1 : Mat4) := by
  intro h
  rw [body_center_walk_eq_closed] at h
  have h02 := congrFun (congrFun h 0) 2
  simp [bodyCenterClosed, Complex.ext_iff] at h02
  have hc : Real.cos theta = 0 := by simpa using h02.1
  have hs : Real.sin theta = 0 := by simpa using h02.2
  nlinarith [Real.sin_sq_add_cos_sq theta]

/-- A concrete nonzero body-center mode with one-step eigenvalue `+1`. -/
def bodyCenterPlusMode (theta : Real) : Fin 4 -> Complex :=
  let u : Complex := Real.cos theta + I * Real.sin theta
  ![-u, 0, 1, 0]

/-- A concrete nonzero body-center mode with one-step eigenvalue `-1`. -/
def bodyCenterMinusMode (theta : Real) : Fin 4 -> Complex :=
  let u : Complex := Real.cos theta + I * Real.sin theta
  ![u, 0, 1, 0]

/-- The explicit plus mode is an exact fixed vector of the massive body-center
step for every mass angle. -/
theorem body_center_plus_mode_eigen (theta : Real) :
    bodyCenterWalk theta *ᵥ bodyCenterPlusMode theta = bodyCenterPlusMode theta := by
  have htrig :
      (Real.sin theta : Complex) ^ 2 + (Real.cos theta : Complex) ^ 2 = 1 := by
    exact_mod_cast Real.sin_sq_add_cos_sq theta
  rw [body_center_walk_eq_closed]
  funext i
  fin_cases i <;>
    simp [bodyCenterClosed, bodyCenterPlusMode, Matrix.mulVec, dotProduct,
      Fin.sum_univ_four, ← Complex.ofReal_sin, ← Complex.ofReal_cos] <;>
    ring_nf <;>
    rw [Complex.I_sq] <;>
    ring_nf <;>
    linear_combination htrig

/-- The explicit minus mode is an exact eigenvector with eigenvalue `-1` for
every mass angle. -/
theorem body_center_minus_mode_eigen (theta : Real) :
    bodyCenterWalk theta *ᵥ bodyCenterMinusMode theta =
      -(bodyCenterMinusMode theta) := by
  have htrig :
      (Real.sin theta : Complex) ^ 2 + (Real.cos theta : Complex) ^ 2 = 1 := by
    exact_mod_cast Real.sin_sq_add_cos_sq theta
  rw [body_center_walk_eq_closed]
  funext i
  fin_cases i <;>
    simp [bodyCenterClosed, bodyCenterMinusMode, Matrix.mulVec, dotProduct,
      Fin.sum_univ_four, ← Complex.ofReal_sin, ← Complex.ofReal_cos] <;>
    ring_nf <;>
    rw [Complex.I_sq] <;>
    ring_nf <;>
    linear_combination -htrig

/-- The explicit plus mode is not the zero vector. -/
theorem body_center_plus_mode_ne_zero (theta : Real) :
    bodyCenterPlusMode theta ≠ 0 := by
  intro h
  have h2 := congrFun h 2
  simp [bodyCenterPlusMode] at h2

/-- The explicit minus mode is not the zero vector. -/
theorem body_center_minus_mode_ne_zero (theta : Real) :
    bodyCenterMinusMode theta ≠ 0 := by
  intro h
  have h2 := congrFun h 2
  simp [bodyCenterMinusMode] at h2

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1BrillouinAudit.massless_corner_parity_classification' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_corner_parity_classification

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1BrillouinAudit.origin_alias_pi_pi_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms origin_alias_pi_pi_zero

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1BrillouinAudit.massless_continuum_H_square_eq_of_norm_sq_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_continuum_H_square_eq_of_norm_sq_eq

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1BrillouinAudit.body_center_walk_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms body_center_walk_sq

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1BrillouinAudit.body_center_plus_mode_eigen' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms body_center_plus_mode_eigen

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1BrillouinAudit.body_center_minus_mode_eigen' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms body_center_minus_mode_eigen

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1BrillouinAudit.body_center_plus_mode_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms body_center_plus_mode_ne_zero

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1BrillouinAudit.body_center_minus_mode_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms body_center_minus_mode_ne_zero

end PhysicsSM.Draft.NullEdge.Finite3Plus1BrillouinAudit
