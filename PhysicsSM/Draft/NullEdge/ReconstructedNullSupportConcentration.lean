import Mathlib

/-!
# Transferring primitive support concentration to a reconstructed null cone

This module isolates the deterministic estimate needed by the graph-first
metric program.  A primitive causal kernel can first be shown to concentrate
near a premetric shell described by a residual `sourceResidual`.  If the
Lorentzian metric reconstructed from the same order/count data supplies a
residual `reconstructedResidual` uniformly within `delta`, then support outside
the reconstructed `epsilon`-cone is bounded by support outside the narrower
source `(epsilon - delta)`-shell.

The theorem is finite and exact.  It does not prove the probabilistic shell
estimate, metric reconstruction, or refinement convergence; instead it gives
the noncircular composition step those two independent inputs must satisfy.

Conventions: residual zero denotes nullness; `outsideMass` uses a strict
absolute-residual threshold; weights are nonnegative real kernel masses.

Provenance: clean-room finite estimate designed for Priority 1 of
`Sources/Null_Edge_Reconstruction_Priorities_2026-07-19.md`.
-/

namespace PhysicsSM.Draft.NullEdge.ReconstructedNullSupportConcentration

open scoped BigOperators

noncomputable section

variable {X : Type*} [Fintype X]

/-- Total nonnegative weight carried outside an absolute-residual shell. -/
def outsideMass (weight residual : X → Real) (epsilon : Real) : Real :=
  by
    classical
    exact ∑ x ∈ Finset.univ.filter (fun x => epsilon < |residual x|), weight x

/-- Uniform residual control implies inclusion of the reconstructed bad set in
the narrower primitive bad set. -/
theorem reconstructed_badSet_subset_source_badSet
    (sourceResidual reconstructedResidual : X → Real)
    (epsilon delta : Real)
    (hclose : ∀ x, |reconstructedResidual x - sourceResidual x| ≤ delta) :
    Finset.univ.filter (fun x => epsilon < |reconstructedResidual x|) ⊆
      Finset.univ.filter (fun x => epsilon - delta < |sourceResidual x|) := by
  classical
  intro x hx
  simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hx ⊢
  have htriangle :
      |reconstructedResidual x| ≤
        |sourceResidual x| + |reconstructedResidual x - sourceResidual x| := by
    calc
      |reconstructedResidual x| =
          |sourceResidual x +
            (reconstructedResidual x - sourceResidual x)| := by
        congr 1
        ring
      _ ≤ |sourceResidual x| +
          |reconstructedResidual x - sourceResidual x| :=
        abs_add_le (sourceResidual x)
          (reconstructedResidual x - sourceResidual x)
  linarith [hclose x]

/-- **Null-support transfer.**  Primitive shell concentration and a uniform
metric-residual error compose without an additional physical assumption. -/
theorem outsideMass_reconstructed_le_source
    (weight sourceResidual reconstructedResidual : X → Real)
    (epsilon delta : Real)
    (hweight : ∀ x, 0 ≤ weight x)
    (hclose : ∀ x, |reconstructedResidual x - sourceResidual x| ≤ delta) :
    outsideMass weight reconstructedResidual epsilon ≤
      outsideMass weight sourceResidual (epsilon - delta) := by
  unfold outsideMass
  apply Finset.sum_le_sum_of_subset_of_nonneg
    (reconstructed_badSet_subset_source_badSet
      sourceResidual reconstructedResidual epsilon delta hclose)
  intro x _ _
  exact hweight x

/-- A quantitative corollary in the form consumed by a refinement theorem. -/
theorem reconstructed_concentration_of_source_bound
    (weight sourceResidual reconstructedResidual : X → Real)
    (epsilon delta bound : Real)
    (hweight : ∀ x, 0 ≤ weight x)
    (hclose : ∀ x, |reconstructedResidual x - sourceResidual x| ≤ delta)
    (hsource : outsideMass weight sourceResidual (epsilon - delta) ≤ bound) :
    outsideMass weight reconstructedResidual epsilon ≤ bound := by
  exact (outsideMass_reconstructed_le_source weight sourceResidual
    reconstructedResidual epsilon delta hweight hclose).trans hsource

/-! ## Nondegenerate exact witness -/

def witnessWeight : Fin 1 → Real := fun _ => 3

def witnessSourceResidual : Fin 1 → Real := fun _ => 2

def witnessReconstructedResidual : Fin 1 → Real := fun _ => 19 / 10

/-- The transfer theorem can be sharp on nonzero mass: both outside masses are
exactly the weight `3` of the third support point. -/
theorem witness_transfer_is_nondegenerate :
    outsideMass witnessWeight witnessReconstructedResidual 1 = 3 ∧
      outsideMass witnessWeight witnessSourceResidual (1 - 1 / 10) = 3 := by
  norm_num [outsideMass, witnessWeight, witnessSourceResidual,
    witnessReconstructedResidual, Fin.sum_univ_succ]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ReconstructedNullSupportConcentration.outsideMass_reconstructed_le_source' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms outsideMass_reconstructed_le_source

end

end PhysicsSM.Draft.NullEdge.ReconstructedNullSupportConcentration
