import Mathlib
import PhysicsSM.Draft.NullEdgeBranchKreinSignatures

/-!
# K2: a Krein-positive *physical-sector* release criterion after C22

C22 (`NullEdgeBranchKreinSignatures`) established, for the modeled Krein metric
`kreinJ`, that the four high-momentum null branches carry the Krein-signature
pattern `(+,−,+,−)` (`branchKreinSig_eq`), so the *full* branch sector is
Krein-**indefinite** (`branchKreinSig_sum_zero`, `exists_krein_negative_branch`).
Consequently the C22 residual predicate

```text
ReleasesKreinPositive chir krein := (chir = g5) ∧ (∀ a, krein a = 1)
```

is **false** on the modeled data (`modeled_release_not_kreinPositive`): one
cannot honestly assert positivity of *all* branches.

This module gives the *correct* conditional release criterion.  The cure is a
**physical-sector projection**: instead of asking every branch to be
Krein-positive, retain only the Krein-positive branches and project out the
Krein-negative ones.  We make the species splitting fully explicit.

## The physical-sector construction

* `sectorProj sel` — the projector onto the branches selected by
  `sel : Fin 4 → Bool` (a sum of per-branch projectors `Pbranch`).
* `KreinPositiveSector P` — the property that the modeled Krein metric acts as
  the identity (`+1`, positive-definite) on the range of `P`: `kreinJ * P = P`.
* `physSel` — the canonical physical selector, retaining exactly the
  Krein-positive branches (`branchKreinSig a = 1`).
* `Pphys = sectorProj physSel = Pbranch 0 + Pbranch 2` — the physical-sector
  projector.

## Species splitting (which branches are retained vs. projected out)

The branch Krein signature is `(+,−,+,−)` and the branch chirality is
`g5 = (+,+,−,−)`:

| branch `a` | `branchKreinSig a` | `g5 a` (chirality) | status |
|:----------:|:------------------:|:------------------:|:-------|
|     0      |        `+1`        |        `+1`        | **retained** (Krein-positive, left-chiral) |
|     1      |        `−1`        |        `+1`        | projected out (Krein-negative ghost) |
|     2      |        `+1`        |        `−1`        | **retained** (Krein-positive, right-chiral) |
|     3      |        `−1`        |        `−1`        | projected out (Krein-negative ghost) |

So the *physical species* is the pair `{0, 2}`: one left-chiral and one
right-chiral mode, **both Krein-positive** — a healthy Dirac pair.  The *mirror /
doubler species* `{1, 3}` carry negative Krein norm and are explicitly projected
out; they are **not** swept under the rug, they are the discarded sector
(`discarded_krein_negative`).

## The criterion (the deliverable)

* `sectorProj_kreinPositive` (general sufficient condition): **any** sector whose
  retained branches all have Krein signature `+1` is Krein-positive.
* `Pphys_kreinPositive` / `Pphys_krein_form`: the canonical physical sector is
  Krein-positive; the modeled Krein metric restricts to the identity on it.
* `physical_sector_releases`: the physical sector satisfies the sector-restricted
  release predicate `ReleasesKreinPositiveOnSector` (aligned chirality **and**
  Krein-positivity on every *retained* branch).
* `Pnull_krein_indefinite` and `full_sector_not_releases`: the contrast — the
  full null sector is *not* Krein-positive, so the projection is necessary.
* `releasesKreinPositive_iff_full`: the C22 predicate `ReleasesKreinPositive` is
  exactly the unsatisfiable "retain-everything" instance, pinpointing why C22's
  negative result is not contradicted but *refined*.
* `kreinPositive_sector_subset_phys`: `physSel` is the **maximal**
  Krein-positive sector — no Krein-positive sector can retain a negative branch.

Everything is proved for the modeled gradings of the Wave-8 finite model, exactly
as in C22; this module adds the missing *positive* statement that survives C22's
negative facts.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeKreinPositiveReleaseCriterion

open Matrix
open PhysicsSM.Draft.NullEdgeFlavoredChirality
open PhysicsSM.Draft.NullEdgeGateCReleaseCriterion
open PhysicsSM.Draft.NullEdgeBranchKreinSignatures

/-! ## The sector projector and the Krein-positivity predicate -/

/-- The projector onto the branches selected by `sel`: the sum of the per-branch
projectors `Pbranch a` over the retained branches `sel a = true`. -/
def sectorProj (sel : Fin 4 → Bool) : RMat :=
  ∑ a, (if sel a then (1 : ℝ) else 0) • Pbranch a

/-- A projector `P` defines a **Krein-positive sector** when the modeled Krein
metric `kreinJ` acts as the identity (`+1`, positive-definite) on its range,
i.e. `kreinJ * P = P`. -/
def KreinPositiveSector (P : RMat) : Prop := kreinJ * P = P

/-- The sector-restricted release predicate: on every *retained* branch the
chirality is aligned (`chir a = g5 a`) and the Krein signature is positive
(`krein a = 1`).  This is the physical-sector refinement of C22's
`ReleasesKreinPositive`. -/
def ReleasesKreinPositiveOnSector
    (sel : Fin 4 → Bool) (chir krein : Fin 4 → ℝ) : Prop :=
  (∀ a, sel a → chir a = g5 a) ∧ (∀ a, sel a → krein a = 1)

/-! ## The Krein metric acts on each branch by its signature -/

/-- The modeled Krein metric acts on branch `a` by its Krein signature:
`kreinJ * P_a = branchKreinSig a • P_a`. -/
theorem kreinJ_Pbranch (a : Fin 4) :
    kreinJ * Pbranch a = branchKreinSig a • Pbranch a := by
  rw [branchKreinSig_eq]
  ext ⟨i, j⟩ ⟨k, l⟩
  simp only [kreinJ, Pbranch, Matrix.mul_apply, Matrix.diagonal, Matrix.smul_apply,
    Matrix.of_apply, smul_eq_mul]
  by_cases hk : (k = a ∧ l = a) <;> by_cases hik : ((i, j) = (k, l)) <;> (simp_all; try aesop)

/-! ## General sufficient condition for Krein positivity -/

/-- **General sufficient condition.**  If every retained branch of `sel` is
Krein-positive (`branchKreinSig a = 1`), then the sector projector
`sectorProj sel` defines a Krein-positive sector. -/
theorem sectorProj_kreinPositive (sel : Fin 4 → Bool)
    (h : ∀ a, sel a → branchKreinSig a = 1) :
    KreinPositiveSector (sectorProj sel) := by
  unfold KreinPositiveSector sectorProj
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro a _
  rw [Matrix.mul_smul, kreinJ_Pbranch, smul_smul]
  congr 1
  by_cases ha : sel a
  · simp [ha, h a ha]
  · simp [ha]

/-! ## The canonical physical sector -/

/-- The canonical physical selector: retain exactly the Krein-positive branches
(those with `branchKreinSig a = 1`). -/
def physSel : Fin 4 → Bool := fun a => decide (branchKreinSig a = 1)

/-- The physical-sector projector. -/
def Pphys : RMat := sectorProj physSel

/-- A branch is retained iff it is Krein-positive. -/
theorem physSel_iff (a : Fin 4) : physSel a = true ↔ branchKreinSig a = 1 := by
  simp [physSel]

/-- The physical selector retains exactly branches `0` and `2`. -/
theorem physSel_eq : physSel = ![true, false, true, false] := by
  funext a
  rw [Bool.eq_iff_iff, physSel_iff, branchKreinSig_eq]
  fin_cases a <;> norm_num

/-- Every retained branch is Krein-positive. -/
theorem retained_krein_positive (a : Fin 4) (h : physSel a = true) :
    branchKreinSig a = 1 := (physSel_iff a).1 h

/-- **The negatives are not swept under the rug.**  Every *discarded* branch is
Krein-negative (`branchKreinSig a = −1`): the projected-out sector is exactly the
ghost sector. -/
theorem discarded_krein_negative (a : Fin 4) (h : physSel a = false) :
    branchKreinSig a = -1 := by
  rw [branchKreinSig_eq]
  simp only [physSel, decide_eq_false_iff_not] at h
  rw [branchKreinSig_eq] at h
  split_ifs at h ⊢ with hh
  · simp at h
  · rfl

/-- The physical-sector projector is the sum of the two Krein-positive branch
projectors. -/
theorem Pphys_eq : Pphys = Pbranch 0 + Pbranch 2 := by
  rw [Pphys, sectorProj, physSel_eq]; simp [Fin.sum_univ_four]

/-! ## Projector algebra of the physical sector -/

/-- The physical-sector projector is idempotent. -/
theorem Pphys_idem : Pphys * Pphys = Pphys := by
  rw [Pphys_eq, Matrix.add_mul, Matrix.mul_add, Matrix.mul_add,
    Pbranch_idem, Pbranch_idem, Pbranch_orthogonal (by decide : (0 : Fin 4) ≠ 2),
    Pbranch_orthogonal (by decide : (2 : Fin 4) ≠ 0)]
  abel

/-- The physical-sector projector is symmetric. -/
theorem Pphys_symm : (Pphys)ᵀ = Pphys := by
  rw [Pphys_eq, Matrix.transpose_add, Pbranch_symm, Pbranch_symm]

/-- The physical sector has rank two (it retains two branch modes). -/
theorem Pphys_trace : Pphys.trace = 2 := by
  rw [Pphys_eq, Matrix.trace_add, Pbranch_trace, Pbranch_trace]; norm_num

/-- **The physical sector is Krein-positive.**  The modeled Krein metric acts as
the identity on the physical sector. -/
theorem Pphys_kreinPositive : KreinPositiveSector Pphys := by
  apply sectorProj_kreinPositive
  intro a h
  exact retained_krein_positive a h

/-- The modeled Krein metric restricts to the identity (positive-definite quadratic
form) on the physical sector: `Pphys · J · Pphys = Pphys`. -/
theorem Pphys_krein_form : Pphys * kreinJ * Pphys = Pphys := by
  rw [Matrix.mul_assoc, show kreinJ * Pphys = Pphys from Pphys_kreinPositive, Pphys_idem]

/-! ## Contrast: the full null sector is Krein-indefinite -/

/-- **The full null sector is Krein-indefinite.**  In contrast to the physical
sector, the modeled Krein metric does *not* restrict to the identity on the full
null sector: `Pnull · J · Pnull ≠ Pnull` (the Krein-negative branches survive). -/
theorem Pnull_krein_indefinite : Pnull * kreinJ * Pnull ≠ Pnull := by
  intro h
  have hcontra := congrFun (congrFun h (1, 1)) (1, 1)
  simp [Pnull, kreinJ, Matrix.mul_apply, Matrix.diagonal] at hcontra
  norm_num at hcontra

/-! ## Species splitting made explicit -/

/-- **Retained physical pair.**  The two retained branches carry opposite
chirality (`g5 0 = +1`, `g5 2 = −1`) and are both Krein-positive: a healthy
left/right Dirac pair. -/
theorem retained_dirac_pair :
    branchChirality 0 = 1 ∧ branchChirality 2 = -1 ∧
      branchKreinSig 0 = 1 ∧ branchKreinSig 2 = 1 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> simp [branchChirality_eq, branchKreinSig_eq, g5]

/-- **Projected-out ghost pair.**  The two discarded branches are exactly the
Krein-negative modes (`branchKreinSig 1 = branchKreinSig 3 = −1`). -/
theorem discarded_ghost_pair :
    branchKreinSig 1 = -1 ∧ branchKreinSig 3 = -1 := by
  constructor <;> rw [branchKreinSig_eq] <;> norm_num

/-! ## The sector release theorem (the deliverable) -/

/-- **General sector release.**  If the operator forces aligned chirality
(`chir = g5`) and every retained branch is Krein-positive, the sector-restricted
release holds. -/
theorem releasesOnSector_of_aligned (sel : Fin 4 → Bool)
    (chir krein : Fin 4 → ℝ) (hchir : chir = g5)
    (hk : ∀ a, sel a → krein a = 1) :
    ReleasesKreinPositiveOnSector sel chir krein :=
  ⟨fun a _ => congrFun hchir a, hk⟩

/-- **The physical sector releases Krein-positively.**  On every retained branch
the modeled chirality is aligned and the modeled Krein signature is `+1`. -/
theorem physical_sector_releases :
    ReleasesKreinPositiveOnSector physSel branchChirality branchKreinSig := by
  refine ⟨fun a _ => branchChirality_eq a, fun a h => retained_krein_positive a h⟩

/-- **Bridge to the matrix-level positivity.**  A sector that releases
Krein-positively (with the modeled branch Krein signatures) is a Krein-positive
sector at the matrix level. -/
theorem releasesOnSector_imp_kreinPositive (sel : Fin 4 → Bool)
    (h : ReleasesKreinPositiveOnSector sel branchChirality branchKreinSig) :
    KreinPositiveSector (sectorProj sel) :=
  sectorProj_kreinPositive sel h.2

/-! ## Sharpness: maximality and the full-sector obstruction -/

/-- **Maximality of the physical sector.**  Any Krein-positive sector is
contained in `physSel`: no Krein-positive sector can retain a Krein-negative
branch. -/
theorem kreinPositive_sector_subset_phys (sel : Fin 4 → Bool)
    (h : ∀ a, sel a → branchKreinSig a = 1) :
    ∀ a, sel a → physSel a = true :=
  fun a ha => (physSel_iff a).2 (h a ha)

/-- The C22 predicate `ReleasesKreinPositive` is exactly the "retain-everything"
instance of the sector predicate. -/
theorem releasesKreinPositive_iff_full (chir krein : Fin 4 → ℝ) :
    ReleasesKreinPositive chir krein ↔
      ReleasesKreinPositiveOnSector (fun _ => true) chir krein := by
  constructor
  · rintro ⟨h1, h2⟩
    exact ⟨fun a _ => congrFun h1 a, fun a _ => h2 a⟩
  · rintro ⟨h1, h2⟩
    exact ⟨funext fun a => h1 a (by simp), fun a => h2 a (by simp)⟩

/-- **The full sector cannot release Krein-positively.**  Retaining every branch
fails the criterion, because the Krein-negative branches are present.  This is
the obstruction that forces the physical-sector projection (it re-expresses C22's
`modeled_release_not_kreinPositive`). -/
theorem full_sector_not_releases :
    ¬ ReleasesKreinPositiveOnSector (fun _ => true) branchChirality branchKreinSig := by
  rw [← releasesKreinPositive_iff_full]
  exact modeled_release_not_kreinPositive

/-! ## Summary -/

/-- **K2 summary.**  A precise Krein-positive *physical-sector* release criterion
after C22:

1. (general criterion) any sector whose retained branches are all Krein-positive
   is Krein-positive (`sectorProj_kreinPositive`);
2. the canonical physical sector `Pphys = Pbranch 0 + Pbranch 2` retains exactly
   the Krein-positive branches `{0,2}` and is Krein-positive
   (`Pphys_kreinPositive`, `Pphys_krein_form`), satisfying the sector release
   predicate (`physical_sector_releases`);
3. the discarded branches `{1,3}` are exactly the Krein-negative ghosts
   (`discarded_krein_negative`) — not swept under the rug;
4. the full null sector is Krein-indefinite (`Pnull_krein_indefinite`) and the
   "retain-everything" C22 predicate is unsatisfiable
   (`full_sector_not_releases`), so the projection is necessary;
5. `physSel` is the maximal Krein-positive sector
   (`kreinPositive_sector_subset_phys`). -/
theorem k2_physical_sector_release_summary :
    (∀ sel : Fin 4 → Bool, (∀ a, sel a → branchKreinSig a = 1) →
      KreinPositiveSector (sectorProj sel)) ∧
    KreinPositiveSector Pphys ∧
    Pphys * kreinJ * Pphys = Pphys ∧
    ReleasesKreinPositiveOnSector physSel branchChirality branchKreinSig ∧
    (∀ a, physSel a = false → branchKreinSig a = -1) ∧
    Pnull * kreinJ * Pnull ≠ Pnull ∧
    ¬ ReleasesKreinPositiveOnSector (fun _ => true) branchChirality branchKreinSig ∧
    (∀ sel : Fin 4 → Bool, (∀ a, sel a → branchKreinSig a = 1) →
      ∀ a, sel a → physSel a = true) :=
  ⟨sectorProj_kreinPositive, Pphys_kreinPositive, Pphys_krein_form,
    physical_sector_releases, discarded_krein_negative, Pnull_krein_indefinite,
    full_sector_not_releases, kreinPositive_sector_subset_phys⟩

end PhysicsSM.Draft.NullEdgeKreinPositiveReleaseCriterion
