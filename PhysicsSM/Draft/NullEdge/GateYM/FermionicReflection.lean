import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.WilsonDiracOperator

/-!
# QMF5 Deliverable-1 scaffold: the temporal reflection for fermionic RP

Foundation for the finite fermionic reflection-positivity (RP-F) construction
(QMF5 Deliverable 1; design DAG in
`AgentTasks/fourday-ym-run-2026-07-05/QMF5_DESIGN_HARVEST.md`, Aristotle job
`d1e7bece`). This module begins the concrete lattice scaffolding whose
linear-algebra core is already proved:

- `WilsonProjectors`: the Wilson spin projectors `P+- = (1 -+ gamma_mu)/2` are
  orthogonal Hermitian projectors, and `A^dagger P A` is PSD (the RP-F node-N5
  Gram conclusion, in abstract form).

What remains to assemble RP-F is the concrete lattice reflection data. This file
lands the first piece: the **temporal reflection involution on sites**.

## The reflection convention (LINK reflection, not site reflection)

Following the design's Risk-R2 resolution, the mirror plane passes through the
midpoints of the temporal links between time-slices `t = 0` and `t = 1`, so the
reflection is `t |-> 1 - t` on the periodic time coordinate (`0 <-> 1`,
`2 <-> L-1`, ...), NOT a site reflection `t |-> -t` (which would fix `t = 0`).
The time direction is index `timeDir` of `Site L = Fin 4 -> Fin L`.

## Status and remaining RP-F DAG

Landed here (kernel-checked, `s o r r y`-free): `timeRefl` + its involution and
link-reflection facts; the reflection operator `rpFReflection`
(`Theta = timeRefl-permutation tensor gamma_timeDir tensor color-id`), its
Hermiticity `rpFReflection_herm` (`Theta^dagger = Theta`), its involution
`rpFReflection_sq` (`Theta * Theta = 1`), and hence its unitarity
`rpFReflection_unitary` (`Theta^dagger Theta = 1`). `Theta` is the reflection
unitary for the fermionic Osterwalder-Seiler construction.

Remaining (next QMF5 cycle):

- `rpF_reflection_hermiticity` : `Theta D Theta = D^dagger` under a
  time-reflection-symmetry hypothesis on the link field `U` (the temporal-
  reflection analogue of QMF4's `gamma5_hermiticity`, same gamma lemmas). Its
  hypothesis needs pinning down (which `U`-symmetry makes the reflected operator
  the adjoint), so it is left for a focused next step rather than stated
  under-specified here.
- the reflected positive-half block factorization `reflectedWilsonBlock_eq_gram`
  (node N5), whose abstract PSD core is the already-proved
  `WilsonProjectors.conj_projector_posSemidef`, and the Berezin/measure wrap into
  `ReflectionPositivityKernel.reflectionForm_nonneg`.
- `reflectedWilsonBlock` + `reflectedWilsonBlock_eq_gram` : the reflected
  positive-half block is `M^dagger M` (node N5; its abstract PSD core is the
  already-proved `WilsonProjectors.conj_projector_posSemidef`).
- measure wrap : feed the Gram data as a factorized/mixture cut kernel into
  `ReflectionPositivityKernel.reflectionForm_nonneg`, weighted by the nonnegative
  paired-flavor determinant (`WilsonDiracOperator.pairedFlavor_det_nonneg`).

## Claim discipline

Claim label: **finite identity** (a finite involution on a finite index set; no
analysis). Draft-trust, kernel-checked, `s o r r y`-free. Prerequisites:
`WilsonDiracOperator` (for `Site`, `shiftUp`/`shiftDn` conventions). Successor:
the reflection unitary and the reflected-block factorization above.
-/

open scoped Matrix

namespace PhysicsSM.Draft.NullEdge.GateYM
namespace FermionicReflection

open PhysicsSM.Draft.NullEdge.GateYM.Qmf4bWilson

/-- The Euclidean time direction of `Site L = Fin 4 -> Fin L`. Chosen as index
`0`; the spatial directions are `1, 2, 3`. (The Wilson-Dirac operator treats all
four directions symmetrically, so any fixed choice is a convention.) -/
def timeDir : Fin 4 := 0

/-- **Temporal (link-plane) reflection on sites**: flips the time coordinate by
`t |-> 1 - t` on the periodic time axis, fixing the spatial coordinates. The
mirror plane sits between slices `t = 0` and `t = 1` (link reflection). -/
def timeRefl [NeZero L] (x : Site L) : Site L :=
  Function.update x timeDir (1 - x timeDir)

/-- The temporal reflection is an involution (`timeRefl` composed with itself is
the identity): `1 - (1 - t) = t` on the time coordinate, and the spatial
coordinates are untouched. -/
theorem timeRefl_involutive [NeZero L] : Function.Involutive (timeRefl (L := L)) := by
  intro x
  unfold timeRefl
  rw [Function.update_idem]
  rw [Function.update_self]
  rw [sub_sub_cancel]
  rw [Function.update_eq_self]

/-- The temporal reflection genuinely moves the boundary time-slice (`t = 0` maps
to `t = 1`), confirming it is a LINK reflection (no fixed `t = 0` slice), given
`L >= 2`. -/
theorem timeRefl_zero_slice [NeZero L] (h2 : 2 ≤ L) (x : Site L) (hx : x timeDir = 0) :
    (timeRefl x) timeDir = 1 := by
  unfold timeRefl
  rw [Function.update_self, hx, sub_zero]

/-- **The fermionic reflection operator** `Theta = (site permutation by timeRefl)
tensor gamma_timeDir tensor (color identity)` on the full Wilson index
`Idx L nc`. This is the RP-F analogue of QMF4's chirality operator `Gamma5`, but
with the time-reflection site permutation in place of the site-diagonal and the
temporal gamma in place of `gamma5`. Together with the antilinear `starRingEnd`
it implements Osterwalder-Seiler time reflection on the fermion algebra. -/
noncomputable def rpFReflection (L nc : ℕ) [NeZero L] : Matrix (Idx L nc) (Idx L nc) ℂ :=
  Matrix.of fun I J =>
    (if J.1 = timeRefl I.1 ∧ I.2.2 = J.2.2 then EuclideanGamma.γ timeDir I.2.1 J.2.1 else 0)

/-- **The reflection operator is Hermitian**: `Theta^dagger = Theta`. Uses that
`gamma_timeDir` is Hermitian and that `timeRefl` is an involution (so the
off-diagonal site condition is symmetric). -/
theorem rpFReflection_herm (L nc : ℕ) [NeZero L] :
    (rpFReflection L nc)ᴴ = rpFReflection L nc := by
  ext I J
  simp only [rpFReflection, Matrix.conjTranspose_apply, Matrix.of_apply]
  by_cases h : J.1 = timeRefl I.1 ∧ I.2.2 = J.2.2
  · obtain ⟨h1, h2⟩ := h
    have hrev : I.1 = timeRefl J.1 ∧ J.2.2 = I.2.2 :=
      ⟨by rw [h1, timeRefl_involutive], h2.symm⟩
    rw [if_pos hrev, if_pos (And.intro h1 h2)]
    have hij := congr_fun (congr_fun (EuclideanGamma.γ_herm timeDir) I.2.1) J.2.1
    rw [Matrix.conjTranspose_apply] at hij
    exact hij
  · rw [if_neg h, if_neg (fun hc => h ⟨by rw [hc.1, timeRefl_involutive], hc.2.symm⟩)]
    simp

/-- **The reflection operator is an involution**: `Theta * Theta = 1`. The `K`-sum
collapses because `Theta I K` pins the intermediate site to `timeRefl I.1` and the
colour to `I.2.2`, leaving a spin sum `sum_s' gamma_td I.2.1 s' * gamma_td s' J.2.1
= (gamma_td^2) I.2.1 J.2.1 = 1`, using `timeRefl` involutive and
`gamma_timeDir^2 = 1`. -/
theorem rpFReflection_sq (L nc : ℕ) [NeZero L] :
    rpFReflection L nc * rpFReflection L nc = 1 := by
  ext I J
  rw [Matrix.mul_apply]
  rw [← Finset.sum_subset (Finset.subset_univ
        (Finset.image (fun s' : Fin 4 => (timeRefl I.1, s', I.2.2)) Finset.univ))]
  · rw [Finset.sum_image (by intro a _ b _ hab; simpa using congrArg (fun z => z.2.1) hab)]
    simp only [rpFReflection, Matrix.of_apply, timeRefl_involutive I.1, true_and, and_true,
      if_true, eq_self_iff_true]
    have hsq := EuclideanGamma.γ_sq timeDir
    by_cases hJ : J.1 = I.1 ∧ I.2.2 = J.2.2
    · obtain ⟨hJ1, hJ2⟩ := hJ
      simp only [if_pos (And.intro hJ1 hJ2)]
      rw [← Matrix.mul_apply, hsq, Matrix.one_apply, Matrix.one_apply]
      obtain ⟨x, s, c⟩ := I; obtain ⟨y, t, d⟩ := J
      simp only at hJ1 hJ2
      subst hJ1; subst hJ2
      by_cases hst : s = t
      · subst hst; simp
      · rw [if_neg hst, if_neg (by simp [Prod.ext_iff, hst])]
    · simp only [if_neg hJ, mul_zero, Finset.sum_const_zero]
      rw [Matrix.one_apply, if_neg]
      rintro rfl
      exact hJ ⟨rfl, rfl⟩
  · intro K _ hK
    simp only [Finset.mem_image, Finset.mem_univ, true_and, not_exists] at hK
    simp only [rpFReflection, Matrix.of_apply]
    rw [if_neg, zero_mul]
    rintro ⟨hk1, hk2⟩
    exact hK K.2.1 (by ext <;> simp_all)

/-- **The reflection operator is unitary**: `Theta^dagger Theta = 1` (a Hermitian
involution). This is the reflection unitary for the fermionic Osterwalder-Seiler
construction. -/
theorem rpFReflection_unitary (L nc : ℕ) [NeZero L] :
    (rpFReflection L nc)ᴴ * rpFReflection L nc = 1 := by
  rw [rpFReflection_herm, rpFReflection_sq]

end FermionicReflection
end PhysicsSM.Draft.NullEdge.GateYM
