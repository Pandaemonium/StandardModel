/-
# Finite canonical ensemble for carrier spectra

DRAFT (kernel-clean). This module is the first D5 thermodynamic brick for the
carrier dynamics lane. It is a clean-room, minimal finite analogue of the
canonical-ensemble API exposed in PhysLean's
`Physlib.StatisticalMechanics.CanonicalEnsemble.Basic`: partition function,
Boltzmann probability, expected energy, Helmholtz free energy, and entropy.

It does not prove a thermodynamic limit, condensate, Banks-Casher relation,
continuum field theory, or physical QCD statement. The purpose is narrower:
make finite carrier-spectrum simulations check the kernel-backed invariant
`sum_i p_i = 1`, then use this as the D5 seed for later thermodynamic-limit
questions.

Provenance: clean-room D5 formalization from the 2026-07-08 dynamics guidance,
after consulting PhysLean declaration names
`CanonicalEnsemble.partitionFunction`,
`CanonicalEnsemble.probability`, and
`CanonicalEnsemble.helmholtzFreeEnergy` as API reference points. No PhysLean
source is imported.
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.Carrier.FiniteCanonicalEnsemble

open scoped BigOperators

variable {α : Type*} [Fintype α]

/-- Dimensionless finite partition function `Z(beta) = sum_i exp(-beta E_i)`. -/
noncomputable def partitionFunction (beta : ℝ) (energy : α → ℝ) : ℝ :=
  ∑ i : α, Real.exp (-(beta * energy i))

/-- Boltzmann probability of state `i`. -/
noncomputable def probability (beta : ℝ) (energy : α → ℝ) (i : α) : ℝ :=
  Real.exp (-(beta * energy i)) / partitionFunction beta energy

/-- Expected energy in the finite canonical ensemble. -/
noncomputable def expectedEnergy (beta : ℝ) (energy : α → ℝ) : ℝ :=
  ∑ i : α, probability beta energy i * energy i

/-- Energy variance / fluctuation in the finite canonical ensemble. -/
noncomputable def energyVariance (beta : ℝ) (energy : α → ℝ) : ℝ :=
  ∑ i : α, probability beta energy i * (energy i - expectedEnergy beta energy) ^ 2

/-- Helmholtz free energy `F = -(1/beta) log Z`.

For `beta = 0` this is only a formal finite definition, not a physical
thermodynamic assertion. Later work should gate physical statements with
`beta > 0`. -/
noncomputable def helmholtzFreeEnergy (beta : ℝ) (energy : α → ℝ) : ℝ :=
  -(1 / beta) * Real.log (partitionFunction beta energy)

/-- Gibbs entropy of the finite probability vector. -/
noncomputable def thermodynamicEntropy (beta : ℝ) (energy : α → ℝ) : ℝ :=
  -∑ i : α, probability beta energy i * Real.log (probability beta energy i)

/-- The finite partition function is strictly positive when the state space is
nonempty. -/
theorem partitionFunction_pos [Nonempty α] (beta : ℝ) (energy : α → ℝ) :
    0 < partitionFunction beta energy := by
  unfold partitionFunction
  exact Finset.sum_pos (fun _ _ => Real.exp_pos _) (by simp)

/-- Every Boltzmann probability is positive for a nonempty finite state space. -/
theorem probability_pos [Nonempty α] (beta : ℝ) (energy : α → ℝ) (i : α) :
    0 < probability beta energy i := by
  unfold probability
  exact div_pos (Real.exp_pos _) (partitionFunction_pos beta energy)

/-- **D5 normalization.** The finite canonical probabilities sum to one. -/
theorem sum_probability_eq_one [Nonempty α] (beta : ℝ) (energy : α → ℝ) :
    ∑ i : α, probability beta energy i = 1 := by
  have hZ : partitionFunction beta energy ≠ 0 :=
    ne_of_gt (partitionFunction_pos beta energy)
  unfold probability partitionFunction
  rw [← Finset.sum_div]
  exact div_self hZ

/-- At `beta = 0`, the finite partition function is just the number of states. -/
theorem partitionFunction_zero (energy : α → ℝ) :
    partitionFunction 0 energy = Fintype.card α := by
  simp [partitionFunction]

/-- At `beta = 0`, every state has the uniform finite probability. -/
theorem probability_zero (energy : α → ℝ) (i : α) :
    probability 0 energy i = 1 / (Fintype.card α : ℝ) := by
  simp [probability, partitionFunction_zero]

/-- A constant-energy finite ensemble has that same expected energy. -/
theorem expectedEnergy_const [Nonempty α] (beta E0 : ℝ) :
    expectedEnergy beta (fun _ : α => E0) = E0 := by
  unfold expectedEnergy
  rw [← Finset.sum_mul]
  rw [sum_probability_eq_one]
  ring

/-- The finite energy variance is nonnegative. -/
theorem energyVariance_nonneg [Nonempty α] (beta : ℝ) (energy : α → ℝ) :
    0 ≤ energyVariance beta energy := by
  unfold energyVariance
  exact Finset.sum_nonneg (fun i _ =>
    mul_nonneg (le_of_lt (probability_pos beta energy i)) (sq_nonneg _))

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteCanonicalEnsemble.sum_probability_eq_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sum_probability_eq_one

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteCanonicalEnsemble.energyVariance_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms energyVariance_nonneg

end PhysicsSM.Draft.NullEdge.Carrier.FiniteCanonicalEnsemble
