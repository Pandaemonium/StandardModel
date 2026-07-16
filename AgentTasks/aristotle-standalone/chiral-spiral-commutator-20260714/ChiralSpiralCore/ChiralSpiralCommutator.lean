import Mathlib

/-!
# Chiral spiral commutators for the finite null-edge Dirac avatar

Standalone Aristotle package (Mathlib-only imports). Spiral-layer wave 1,
job A, 2026-07-14.

## What this file states

Finite matrix and scalar targets isolating the "chiral spiral" content of the
null-edge mass program: in the chiral basis, each Weyl sector's transverse
velocity is a rotation ladder for the massless Dirac operator, with handedness
tied to chirality, oscillation rate 2|p| (the zitterbewegung frequency), and
the mass term as the coupling between the two counter-rotating sectors. A
scalar dictionary ties the helix picture to the on-shell budget: the
transverse momentum of a luminal helix is exactly m, and orbital angular
momentum 1/2 forces the zitter radius 1/(2m) (units hbar = c = 1).

## Conventions (declared here; the package is standalone)

- Chiral basis, 4 = 2 (chirality) x 2 (spin). Indices 0,1 form the
  chirality +1 Weyl block; indices 2,3 the chirality -1 block;
  g5 = diag(1,1,-1,-1).
- Momentum is fixed at unit size along +z, so the massless operator is
  D0 = diag(sigma3, -sigma3) = diag(1,-1,-1,1).
- betaM is the chirality-swapping mass matrix (off-diagonal 2x2 identity
  blocks); the massive operator would be D0 + m * betaM (not needed here).
- Transverse-velocity ladders: with alpha_j = diag(sigma_j, -sigma_j),
  APlus = alpha_1 + i * alpha_2 = diag(sigmaPlus, -sigmaPlus) and
  AMinus = alpha_1 - i * alpha_2 = diag(sigmaMinus, -sigmaMinus), where
  sigmaPlus = !![0,2;0,0] and sigmaMinus = !![0,0;2,0].
- comm X Y = X*Y - Y*X.

## Intended reading (spiral layer)

- `comm_D0_APlus` / `comm_D0_AMinus`: [D0, A_pm] = pm 2 (g5 * A_pm). In the
  Heisenberg picture each chirality block's transverse velocity rotates about
  the momentum axis at rate 2|p| with rotation sense given by its chirality:
  the two Weyl sectors are counter-rotating chiral spirals.
- `zitter_double_comm_APlus` / `zitter_double_comm_AMinus`:
  [D0,[D0,A_pm]] = 4 A_pm - harmonic oscillation at the zitterbewegung rate
  2E (E = |p| = 1 here).
- `mass_comm_g5_odd` / `mass_comm_ne_zero`: [betaM, APlus] is nonzero and
  purely chirality-off-diagonal - the mass term couples the two
  counter-rotating spirals and cannot torque a single Weyl sector.
- `transverse_momentum_sq_eq_mass_sq`: on-shell (E^2 = p^2 + m^2), the
  squared transverse momentum E^2 * (1 - (p/E)^2) is exactly m^2: a luminal
  helix carries transverse momentum m independent of boost.
- `spin_half_iff_zitter_radius`: r * m = 1/2 iff r = 1/(2m): demanding the
  circulation carry orbital angular momentum 1/2 fixes the radius at half the
  reduced Compton wavelength.

These are M-grade finite identities (machine-verified once proved); the
helix/spin ontology is interpretation and is NOT claimed by the statements.

## Provenance

Clean-room finite avatars of standard chiral-basis Dirac zitterbewegung
algebra (Schroedinger 1930 zitter kinematics; standard Weyl-basis gamma
conventions). Companion of the parent repo's finite fixed-momentum module
`PhysicsSM.Draft.NullEdge.HelicityChirality` (rational base field there; this
file needs the complex field for the transverse ladder). The block-order
convention (chirality +1 block first) is declared locally above and is the
binding one for this file.

## Proof guidance

All matrix goals are entrywise-finite: `ext i j; fin_cases i <;> fin_cases j`
then `simp [Matrix.mul_apply, Fin.sum_univ_succ, comm, D0, g5, betaM, APlus,
AMinus]` plus `norm_num` / `ring` should close them. For `mass_comm_ne_zero`,
exhibit one nonzero entry (row 0, column 3 works). The two scalar lemmas are
`field_simp` / `ring` level.

Do not weaken or modify any statement or definition; the placeholder proofs
are the only intended gaps.
-/

noncomputable section

namespace ChiralSpiralCore

open Matrix

/-- 4x4 complex matrices: the finite chiral-basis Dirac avatar space. -/
abbrev DiracMat := Matrix (Fin 4) (Fin 4) ℂ

/-- Commutator on the avatar space. -/
def comm (X Y : DiracMat) : DiracMat := X * Y - Y * X

/-- Massless chiral-basis Dirac operator at unit momentum along +z:
diag(sigma3, -sigma3). -/
def D0 : DiracMat := !![1, 0, 0, 0; 0, -1, 0, 0; 0, 0, -1, 0; 0, 0, 0, 1]

/-- Chirality grading diag(1, 1, -1, -1). -/
def g5 : DiracMat := !![1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

/-- Chirality-swapping mass matrix (off-diagonal 2x2 identity blocks). -/
def betaM : DiracMat := !![0, 0, 1, 0; 0, 0, 0, 1; 1, 0, 0, 0; 0, 1, 0, 0]

/-- Transverse-velocity raising ladder alpha_1 + i * alpha_2 =
diag(sigmaPlus, -sigmaPlus) with sigmaPlus = !![0,2;0,0]. -/
def APlus : DiracMat := !![0, 2, 0, 0; 0, 0, 0, 0; 0, 0, 0, -2; 0, 0, 0, 0]

/-- Transverse-velocity lowering ladder alpha_1 - i * alpha_2 =
diag(sigmaMinus, -sigmaMinus) with sigmaMinus = !![0,0;2,0]. -/
def AMinus : DiracMat := !![0, 0, 0, 0; 2, 0, 0, 0; 0, 0, 0, 0; 0, 0, -2, 0]

/-- The chirality grading squares to the identity. -/
theorem g5_sq : g5 * g5 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [g5]

/-- The massless operator commutes with the chirality grading. -/
theorem comm_D0_g5 : comm D0 g5 = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [comm, D0, g5, Matrix.mul_apply, Fin.sum_univ_succ]

/-- Chiral spiral, raising side: [D0, APlus] = 2 (g5 * APlus). The transverse
velocity is a rotation ladder whose sense is the chirality grading. -/
theorem comm_D0_APlus : comm D0 APlus = (2 : ℂ) • (g5 * APlus) := by
  apply Matrix.ext
  norm_num [Fin.forall_fin_succ, D0, APlus, g5, comm]

/-- Chiral spiral, lowering side: [D0, AMinus] = -2 (g5 * AMinus). -/
theorem comm_D0_AMinus : comm D0 AMinus = (-2 : ℂ) • (g5 * AMinus) := by
  unfold comm g5 D0 AMinus
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply]

/-- Zitterbewegung oscillator, raising side: [D0, [D0, APlus]] = 4 APlus,
i.e. the transverse velocity oscillates at rate 2|p| = 2E. -/
theorem zitter_double_comm_APlus :
    comm D0 (comm D0 APlus) = (4 : ℂ) • APlus := by
  unfold comm D0 APlus
  norm_num [← List.ofFn_inj]

/-- Zitterbewegung oscillator, lowering side. -/
theorem zitter_double_comm_AMinus :
    comm D0 (comm D0 AMinus) = (4 : ℂ) • AMinus := by
  unfold comm
  simp [D0, AMinus]
  norm_num

/-- The mass term's action on the ladder is chirality-odd: conjugation by g5
negates [betaM, APlus]. The coupling lives entirely between the two
counter-rotating Weyl sectors. -/
theorem mass_comm_g5_odd :
    g5 * comm betaM APlus * g5 = -(comm betaM APlus) := by
  unfold comm
  unfold g5 betaM APlus
  norm_num [← List.ofFn_inj, Matrix.vecMul]

/-- The mass coupling between the counter-rotating sectors is nonzero. -/
theorem mass_comm_ne_zero : comm betaM APlus ≠ 0 := by
  refine ne_of_apply_ne (fun M => M 0 3) ?_
  norm_num [Matrix.mul_apply, comm]
  simp +decide [betaM, APlus]
  norm_num [Fin.sum_univ_succ]

/-- Helix dictionary, momentum split: on-shell (E^2 = p^2 + m^2, E nonzero),
the squared transverse momentum E^2 * (1 - (p/E)^2) is exactly m^2. -/
theorem transverse_momentum_sq_eq_mass_sq (E p m : ℝ) (hE : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    E ^ 2 * (1 - (p / E) ^ 2) = m ^ 2 := by
  grind

/-- Helix dictionary, spin lock: with transverse momentum m, orbital angular
momentum r * m equals 1/2 iff the radius is the zitter radius 1/(2m). -/
theorem spin_half_iff_zitter_radius (r m : ℝ) (hm : m ≠ 0) :
    r * m = 1 / 2 ↔ r = 1 / (2 * m) := by
  grind

end ChiralSpiralCore

end
