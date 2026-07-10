import Mathlib
import PhysicsSM.Draft.NullEdge.ChiralProjectorsDirac
import PhysicsSM.Draft.NullEdge.MassShellProjectors

/-!
# Audit: chirality-energy noncommutation is not a mass detector

A tempting proposed slogan was "mass is the failure of the chirality and energy
splits to commute." The finite Dirac matrices reject that reading. For nonzero
`m`, the positive-energy projector satisfies

```text
2m [P_L, Lambda_+] = [P_L, pslash].
```

The right side is already nonzero on the massless null momentum `(E,kz)=(1,1)`.
At `m=0`, `Lambda_+` itself is singular and therefore cannot supply a vanishing
control. Noncommutation records the standard anticommutation of chirality with
the Dirac slash; it is not equivalent to nonzero mass.

This is a finite rational-matrix no-go, not a statement about interacting
chiral symmetry breaking.
-/

namespace PhysicsSM.Draft.NullEdge.ChiralityEnergyCommutatorAudit

open Matrix

/-- Matrix commutator. -/
def commutator (A B : Matrix (Fin 4) (Fin 4) ℚ) : Matrix (Fin 4) (Fin 4) ℚ :=
  A * B - B * A

/-- The rescaled chirality-energy commutator is the chirality-slash commutator.
The scalar mass term drops out because it commutes with `P_L`. -/
theorem rescaled_energy_commutator
    (E kz m : ℚ) (hm : m ≠ 0) :
    (2 * m) • commutator ChiralProjectorsDirac.PL (MassShellProjectors.Lp E kz m) =
      commutator ChiralProjectorsDirac.PL (MassShellProjectors.pslash E kz) := by
  calc
    (2 * m) • commutator ChiralProjectorsDirac.PL (MassShellProjectors.Lp E kz m) =
        commutator ChiralProjectorsDirac.PL
          ((2 * m) • MassShellProjectors.Lp E kz m) := by
      simp [commutator, Matrix.mul_smul, Matrix.smul_mul, smul_sub]
    _ = commutator ChiralProjectorsDirac.PL
          (MassShellProjectors.pslash E kz +
            m • (1 : Matrix (Fin 4) (Fin 4) ℚ)) := by
      rw [MassShellProjectors.massless_singular E kz m hm]
    _ = commutator ChiralProjectorsDirac.PL
          (MassShellProjectors.pslash E kz) := by
      simp [commutator, Matrix.mul_smul, Matrix.smul_mul, mul_add, add_mul]

/-- The `(0,0)` entry of `[P_L, pslash]` is exactly `-kz`. -/
theorem chirality_slash_commutator_00 (E kz : ℚ) :
    commutator ChiralProjectorsDirac.PL (MassShellProjectors.pslash E kz) 0 0 = -kz := by
  simp +decide [commutator, ChiralProjectorsDirac.PL, ChiralProjectorsDirac.g5,
    MassShellProjectors.pslash, MassShellProjectors.g0, MassShellProjectors.g3,
    Matrix.mul_apply, Matrix.vecMul, dotProduct, Fin.sum_univ_four, Matrix.one_apply,
    Matrix.smul_apply, Matrix.sub_apply, Matrix.add_apply]
  ring

/-- The `(0,2)` entry of `[P_L, pslash]` is exactly `E`. -/
theorem chirality_slash_commutator_02 (E kz : ℚ) :
    commutator ChiralProjectorsDirac.PL (MassShellProjectors.pslash E kz) 0 2 = E := by
  simp +decide [commutator, ChiralProjectorsDirac.PL, ChiralProjectorsDirac.g5,
    MassShellProjectors.pslash, MassShellProjectors.g0, MassShellProjectors.g3,
    Matrix.mul_apply, Matrix.vecMul, dotProduct, Fin.sum_univ_four, Matrix.one_apply,
    Matrix.smul_apply, Matrix.sub_apply, Matrix.add_apply]
  ring

/-- **Massless negative control.** The null momentum `(1,1)` has
`E^2-kz^2=0`, yet the rescaled commutator is nonzero. -/
theorem massless_rescaled_commutator_nonzero :
    (1 : ℚ) ^ 2 - (1 : ℚ) ^ 2 = 0 ∧
      commutator ChiralProjectorsDirac.PL (MassShellProjectors.pslash 1 1) ≠ 0 := by
  constructor
  · norm_num
  · intro h
    have h00 :
        commutator ChiralProjectorsDirac.PL (MassShellProjectors.pslash 1 1) 0 0 = 0 := by
      simpa using congrArg (fun M : Matrix (Fin 4) (Fin 4) ℚ => M 0 0) h
    rw [chirality_slash_commutator_00] at h00
    norm_num at h00

/-- The standard massive witness also has a nonzero projector commutator; its
`(0,0)` entry is `-3/8`. This is a positive check, not a mass iff. -/
theorem massive_projector_commutator_witness :
    (5 : ℚ) ^ 2 - (3 : ℚ) ^ 2 = (4 : ℚ) ^ 2 ∧
      commutator ChiralProjectorsDirac.PL (MassShellProjectors.Lp 5 3 4) 0 0 = -3 / 8 := by
  constructor
  · norm_num
  · have h := congrArg (fun M : Matrix (Fin 4) (Fin 4) ℚ => M 0 0)
      (rescaled_energy_commutator 5 3 4 (by norm_num))
    simp only [Matrix.smul_apply] at h
    rw [chirality_slash_commutator_00] at h
    norm_num at h ⊢
    linarith

/-- **Audit verdict.** The rescaled identity holds, both a massive on-shell
projector and a massless null slash have nonzero chirality commutators, and the
commutator therefore cannot characterize nonzero mass. -/
theorem chirality_energy_commutator_no_mass_iff :
    (∀ E kz m : ℚ, m ≠ 0 ->
      (2 * m) • commutator ChiralProjectorsDirac.PL (MassShellProjectors.Lp E kz m) =
        commutator ChiralProjectorsDirac.PL (MassShellProjectors.pslash E kz)) ∧
      ((1 : ℚ) ^ 2 - (1 : ℚ) ^ 2 = 0 ∧
        commutator ChiralProjectorsDirac.PL (MassShellProjectors.pslash 1 1) ≠ 0) ∧
      ((5 : ℚ) ^ 2 - (3 : ℚ) ^ 2 = (4 : ℚ) ^ 2 ∧
        commutator ChiralProjectorsDirac.PL (MassShellProjectors.Lp 5 3 4) 0 0 = -3 / 8) :=
  ⟨rescaled_energy_commutator, massless_rescaled_commutator_nonzero,
    massive_projector_commutator_witness⟩

/-! ## Kernel-footprint guard pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralityEnergyCommutatorAudit.rescaled_energy_commutator' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rescaled_energy_commutator

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralityEnergyCommutatorAudit.massless_rescaled_commutator_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_rescaled_commutator_nonzero

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralityEnergyCommutatorAudit.chirality_energy_commutator_no_mass_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chirality_energy_commutator_no_mass_iff

end PhysicsSM.Draft.NullEdge.ChiralityEnergyCommutatorAudit
