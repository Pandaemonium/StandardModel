import Mathlib

/-!
# QMF1-RP: the gauge groups `U(n)`, `SU(n)` are compact

Companion to `QMF/CompactHaarInvariance`. That module proves the compact-group
Haar expectation invariances (gauge, reflection) that the compact
reflection-positivity / transfer layer consumes, and proves compact groups are
unimodular. This module supplies the missing fact that the ACTUAL gauge groups
are compact, so those results apply to `SU(N)` - the physical Yang-Mills gauge
group (and, via step 1a `Octonion.G2FixingE111SpecialUnitaryGroup`, the octonion
`SU(3)`).

## Capability-survey finding, now CLOSED (third gap)

`CompactSpace` is NOT an instance for `Matrix.unitaryGroup (Fin n) ℂ` or
`Matrix.specialUnitaryGroup (Fin n) ℂ` in pinned Mathlib
(`leanprover/lean4:v4.28.0`). This module fills it, with no norm/metric setup on
the matrix space (which pinned Mathlib also lacks by default):

* `unitaryGroup_isCompact`: `U(n)` is compact. The set of matrices with every
  entry in the closed unit disk is compact (a product of compact disks -
  Tychonoff, `isCompact_univ_pi`); `U(n)` is a closed subset of it (the unitary
  condition `M * star M = 1` is a preimage of a point under a continuous map, and
  row-orthonormality `∑ k, ‖M i k‖² = 1` bounds each entry by `1`).
* `specialUnitaryGroup_isCompact`: `SU(n)` is compact, being the closed subset
  `det = 1` of `U(n)`.
* `unitaryGroup_compactSpace` / `specialUnitaryGroup_compactSpace`: the
  corresponding `CompactSpace` instances on the group subtypes.

Together with `CompactHaarInvariance` (compact groups are unimodular; the
gauge/reflection Haar invariances), this means the QMF compact-RP substrate now
applies unconditionally to the physical nonabelian gauge group `SU(N)`. Combined
with the earlier finding (Peter-Weyl absent), the compact-RP lane is unblocked
except for the character-expansion (`Q7`/KP) sublane.

Draft-trust, kernel-checked, `s o r r y`-free. Prerequisites: Mathlib only.
-/

namespace PhysicsSM.Draft.NullEdge.QMF.SpecialUnitaryCompact

open Matrix Metric

variable {n : ℕ}

/-- The unitary group is a closed subset of the matrix space: the condition
`M * star M = 1` is the preimage of `{1}` under the continuous map `M ↦ M * star M`. -/
theorem unitaryGroup_isClosed :
    IsClosed (Matrix.unitaryGroup (Fin n) ℂ : Set (Matrix (Fin n) (Fin n) ℂ)) := by
  have hcont : Continuous (fun M : Matrix (Fin n) (Fin n) ℂ => M * star M) := by fun_prop
  have hpre : (Matrix.unitaryGroup (Fin n) ℂ : Set (Matrix (Fin n) (Fin n) ℂ))
      = (fun M => M * star M) ⁻¹' {1} := by
    ext M; rw [SetLike.mem_coe, Matrix.mem_unitaryGroup_iff]; simp
  rw [hpre]; exact isClosed_singleton.preimage hcont

/-- **`U(n)` is compact.** A closed subset (the unitary condition) of the compact
box of matrices whose entries all lie in the closed unit disk (Tychonoff); the
entry bound `‖M i j‖ ≤ 1` comes from row-orthonormality `∑ k, ‖M i k‖² = 1`. -/
theorem unitaryGroup_isCompact :
    IsCompact (Matrix.unitaryGroup (Fin n) ℂ : Set (Matrix (Fin n) (Fin n) ℂ)) := by
  have hScompact :
      IsCompact {M : Matrix (Fin n) (Fin n) ℂ | ∀ i j, M i j ∈ closedBall (0:ℂ) 1} := by
    have hpi : {M : Matrix (Fin n) (Fin n) ℂ | ∀ i j, M i j ∈ closedBall (0:ℂ) 1}
        = Set.univ.pi (fun i => Set.univ.pi (fun j => closedBall (0:ℂ) 1)) := by
      ext M
      constructor
      · intro h i _ j _; exact h i j
      · intro h i j; exact h i (Set.mem_univ i) j (Set.mem_univ j)
    rw [hpi]
    exact isCompact_univ_pi (fun i => isCompact_univ_pi (fun j => isCompact_closedBall 0 1))
  refine hScompact.of_isClosed_subset unitaryGroup_isClosed ?_
  intro M hM i j
  rw [mem_closedBall_zero_iff]
  have hsum : (∑ k, ‖M i k‖ ^ 2 : ℝ) = 1 := by
    have h1 : ∑ k, M i k * (star M) k i = (1 : ℂ) := by
      have h0 : (M * star M) i i = (1 : Matrix (Fin n) (Fin n) ℂ) i i := by
        rw [(Matrix.mem_unitaryGroup_iff).mp (SetLike.mem_coe.mp hM)]
      rwa [Matrix.mul_apply, Matrix.one_apply_eq] at h0
    have h2 : ∑ k, ((‖M i k‖ ^ 2 : ℝ) : ℂ) = ∑ k, M i k * (star M) k i := by
      apply Finset.sum_congr rfl; intro k _
      rw [Matrix.star_apply]
      have h := RCLike.mul_conj (M i k)
      rw [starRingEnd_apply] at h
      exact_mod_cast h.symm
    rw [h1] at h2; exact_mod_cast h2
  have hle : ‖M i j‖ ^ 2 ≤ 1 := by
    rw [← hsum]
    exact Finset.single_le_sum (f := fun k => ‖M i k‖ ^ 2)
      (fun k _ => sq_nonneg _) (Finset.mem_univ j)
  nlinarith [norm_nonneg (M i j)]

/-- `U(n)` as a group subtype is a compact space. -/
instance unitaryGroup_compactSpace : CompactSpace (Matrix.unitaryGroup (Fin n) ℂ) :=
  isCompact_iff_compactSpace.mp unitaryGroup_isCompact

/-- **`SU(n)` is compact.** The closed subset `det = 1` of the compact `U(n)`. -/
theorem specialUnitaryGroup_isCompact :
    IsCompact (Matrix.specialUnitaryGroup (Fin n) ℂ : Set (Matrix (Fin n) (Fin n) ℂ)) := by
  refine unitaryGroup_isCompact.of_isClosed_subset ?_ ?_
  · have hcont : Continuous (fun M : Matrix (Fin n) (Fin n) ℂ => M.det) := by fun_prop
    have heq : (Matrix.specialUnitaryGroup (Fin n) ℂ : Set (Matrix (Fin n) (Fin n) ℂ))
        = (Matrix.unitaryGroup (Fin n) ℂ : Set _) ∩ (fun M => M.det) ⁻¹' {1} := by
      ext M
      simp only [SetLike.mem_coe, Matrix.mem_specialUnitaryGroup_iff, Set.mem_inter_iff,
        Set.mem_preimage, Set.mem_singleton_iff]
    rw [heq]
    exact unitaryGroup_isClosed.inter (isClosed_singleton.preimage hcont)
  · intro M hM
    exact SetLike.mem_coe.mpr (Matrix.mem_specialUnitaryGroup_iff.mp hM).1

/-- `SU(n)` as a group subtype is a compact space - the physical Yang-Mills gauge
group is compact. -/
instance specialUnitaryGroup_compactSpace :
    CompactSpace (Matrix.specialUnitaryGroup (Fin n) ℂ) :=
  isCompact_iff_compactSpace.mp specialUnitaryGroup_isCompact

/-! ## `U(n)`, `SU(n)` are (compact) topological groups

`ContinuousMul` and `ContinuousInv` for the unitary group are already in Mathlib
(`Topology.Algebra.Star.Unitary`); `IsTopologicalGroup` then follows. For `SU(n)`
multiplication is inherited but inversion needs the identity `A⁻¹ = star A`
(`Matrix.star_eq_inv`), which is continuous. With the compactness above, `SU(n)`
is a COMPACT topological group - all that is needed for a (bi-invariant, by
`CompactHaarInvariance`) Haar measure to exist on the physical gauge group. -/

/-- `U(n)` is a topological group (from Mathlib's continuity of `*` and `star`). -/
instance unitaryGroup_isTopologicalGroup :
    IsTopologicalGroup (Matrix.unitaryGroup (Fin n) ℂ) := ⟨⟩

/-- Inversion on `SU(n)` is continuous: `A⁻¹ = star A`, and `star` is continuous
on matrices, so the map into the ambient matrix space is `star ∘ (coe)`. -/
instance specialUnitaryGroup_continuousInv :
    ContinuousInv (Matrix.specialUnitaryGroup (Fin n) ℂ) where
  continuous_inv := by
    apply continuous_induced_rng.2
    have heq : (fun s : Matrix.specialUnitaryGroup (Fin n) ℂ =>
          ((s⁻¹ : Matrix.specialUnitaryGroup (Fin n) ℂ) : Matrix (Fin n) (Fin n) ℂ))
        = fun s : Matrix.specialUnitaryGroup (Fin n) ℂ =>
          star ((s : Matrix (Fin n) (Fin n) ℂ)) := by
      funext s
      rw [← Matrix.star_eq_inv]
      exact Matrix.specialUnitaryGroup.coe_star s
    show Continuous fun s : Matrix.specialUnitaryGroup (Fin n) ℂ =>
      ((s⁻¹ : Matrix.specialUnitaryGroup (Fin n) ℂ) : Matrix (Fin n) (Fin n) ℂ)
    rw [heq]
    exact continuous_star.comp continuous_induced_dom

/-- **`SU(n)` is a (compact) topological group** - the physical Yang-Mills gauge
group, with the compactness proved above and inversion continuity from
`A⁻¹ = star A`. -/
instance specialUnitaryGroup_isTopologicalGroup :
    IsTopologicalGroup (Matrix.specialUnitaryGroup (Fin n) ℂ) := ⟨⟩

end PhysicsSM.Draft.NullEdge.QMF.SpecialUnitaryCompact
