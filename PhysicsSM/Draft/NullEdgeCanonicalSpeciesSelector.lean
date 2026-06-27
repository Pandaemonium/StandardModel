import Mathlib
import PhysicsSM.Draft.NullEdgeProjectedGateCRelease
import PhysicsSM.Draft.NullEdgeKreinPositiveReleaseCriterion

/-!
# C65: canonical physical-species selector — a conditional canonicity theorem and a no-go

`NullEdgeKreinPositiveReleaseCriterion` (K2) uses the modeled physical sector
`{0, 2}` as the Krein-positive retained pair, and
`NullEdgeSymmetryForcedSpeciesSplit` (C45/C46) shows that the `2+2` species
split is a *modulus* under the currently formalized bare tetrahedral symmetry.
The program needs to know whether the retained sector `{0, 2}` is **canonical**
(forced by the locked structures) or merely **conventional** (a choice).

This module gives the sharp answer: a *conditional* canonicity theorem together
with a *no-go* theorem, pinning down exactly which datum is responsible.

## The candidate selector data

A physical-species selector must, in principle, be derivable from the per-branch
attributes the program records: **branch chirality**, **Krein sign**,
**orientation/taste**, **energy sign**, and **internal grading**.  These are
collected in `SelectorData`.  The modeled instance `modeledData` uses the
kernel-checked values from C22:

| branch `a` | chirality `g5` | Krein sign | taste | energy | grading |
|:----------:|:--------------:|:----------:|:-----:|:------:|:-------:|
|     0      |      `+1`      |    `+1`    | `+1`  |  `+1`  |  `+1`   |
|     1      |      `+1`      |    `−1`    | `+1`  |  `+1`  |  `+1`   |
|     2      |      `−1`      |    `+1`    | `−1`  |  `+1`  |  `−1`   |
|     3      |      `−1`      |    `−1`    | `−1`  |  `+1`  |  `−1`   |

Crucially the modeled `taste`, `energy`, and `grading` are **functions of the
chirality alone** (constant on each chirality class, or globally constant): they
carry *no* branch-distinguishing information beyond the chirality.  Only the
**Krein sign** further splits the two chirality classes.

## The selector

`kreinSelector k` retains exactly the branches with Krein sign `+1`.  On the
modeled data it is *definitionally* the K2 selector `physSel`, hence equals
`![true, false, true, false]` — the pair `{0, 2}`
(`modeledSelector_eq_physSel`, `modeledSelector_eq`).

## What is proved

1. **Uniqueness given Krein** (`kreinSelector_unique`): the selector retaining
   exactly the Krein-positive branches is unique; on the modeled data it is
   `{0, 2}`, and it is the *maximal* Krein-positive sector
   (`maximal_kreinPositive`, reusing K2 `kreinPositive_sector_subset_phys`).

2. **Rigidity under the full locked data** (`locked_rigid`): the combined
   `(chirality, Krein)` label of the four branches is injective, so the only
   branch permutation preserving *both* the chirality pattern and the Krein
   pattern is the identity.  Consequently the selector is **canonical relative to
   the locked Krein data** (`selector_canonical_given_krein`).

3. **No-go under chirality-only data** (`chirality_only_no_go`): there is a
   nontrivial branch permutation (the transposition `(0 1)`) that preserves the
   chirality pattern **and** the modeled taste, energy, and grading — i.e. every
   locked attribute *except* the Krein sign — yet moves the induced selector from
   `{0, 2}` to `{1, 2}`.  Hence chirality, taste, energy, and grading **together
   do not determine** the physical pair; only the Krein sign does.

4. **Verdict** (`c65_verdict`): the retained sector `{0, 2}` is canonical **iff**
   the Krein sign is treated as locked data.  Since C45/C46 shows the Krein /
   species-sign *assignment itself* is a modulus under the bare symmetry, `{0, 2}`
   is **conditionally canonical** (relative to a Krein lock), not absolutely
   canonical.

## Alignment with the C59 projected Gate C release API

The selector feeds the `retained` field of
`NullEdgeProjectedGateCRelease.ProjData`.  The Krein-canonical selector coincides
with the `retained` field of the released witness `releasedData`
(`canonical_selector_eq_released_retained`), which satisfies the full
`ProjectedGateCRelease` certificate (`canonical_selector_releases`).  Therefore
**no Gate C release clause is blocked** by the species-selector question: the
selector used by clauses `BranchProjectorsControlled`, `ProjectedKernelOneDim`,
`ProjectedChiralityAligned`, and `ProjectedKreinPositive` is canonical relative
to the locked Krein data those clauses already consume.

The residual modulus is purely *interpretational / Gate F*: any prediction
language that names the specific physical pair **without** declaring the Krein
sign as locked input inherits the C45/C46 species-labeling modulus.  See
`AgentTasks/null-edge-c65-canonical-species-selector-report.md`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeCanonicalSpeciesSelector

open PhysicsSM.Draft.NullEdgeBranchKreinSignatures
  (branchChirality branchKreinSig branchChirality_eq branchKreinSig_eq)
open PhysicsSM.Draft.NullEdgeKreinPositiveReleaseCriterion
  (physSel physSel_eq physSel_iff kreinPositive_sector_subset_phys)
open PhysicsSM.Draft.NullEdgeSymmetryForcedSpeciesSplit (permAct)
open PhysicsSM.Draft.NullEdgeProjectedGateCRelease
  (ProjData ProjectedGateCRelease releasedData releasedData_releases)

/-! ## The candidate per-branch selector attributes -/

/-- The per-branch attributes from which a physical-species selector might be
derived: branch chirality, Krein sign, orientation/taste, energy sign, and
internal grading. -/
structure SelectorData where
  /-- branch chirality (`g5 = (+,+,-,-)`). -/
  chir : Fin 4 → ℝ
  /-- Krein sign of the branch. -/
  krein : Fin 4 → ℝ
  /-- orientation / taste sign. -/
  taste : Fin 4 → ℝ
  /-- energy sign. -/
  energy : Fin 4 → ℝ
  /-- internal grading. -/
  grading : Fin 4 → ℝ

/-- The modeled selector data, using the kernel-checked C22 values.  The taste,
energy, and grading are deliberately **chirality-determined** (or constant), so
they carry no branch information beyond the chirality. -/
def modeledData : SelectorData where
  chir := branchChirality
  krein := branchKreinSig
  taste := branchChirality
  energy := fun _ => 1
  grading := branchChirality

/-! ## The Krein-derived selector -/

/-- The selector retaining exactly the branches whose Krein sign is `+1`. -/
def kreinSelector (k : Fin 4 → ℝ) : Fin 4 → Bool := fun a => decide (k a = 1)

/-- On the modeled data the Krein selector is *definitionally* the K2 physical
selector `physSel`. -/
theorem modeledSelector_eq_physSel : kreinSelector modeledData.krein = physSel := rfl

/-- The modeled Krein selector retains exactly the pair `{0, 2}`. -/
theorem modeledSelector_eq :
    kreinSelector modeledData.krein = ![true, false, true, false] := by
  rw [modeledSelector_eq_physSel]; exact physSel_eq

/-! ## 1. Uniqueness of the Krein-positive selector -/

/-- **Uniqueness.**  Any selector retaining exactly the Krein-positive branches
equals `kreinSelector k`. -/
theorem kreinSelector_unique (k : Fin 4 → ℝ) (sel : Fin 4 → Bool)
    (h : ∀ a, sel a = true ↔ k a = 1) : sel = kreinSelector k := by
  funext a
  rw [Bool.eq_iff_iff, h a]
  unfold kreinSelector
  rw [decide_eq_true_eq]

/-- **Maximality (reusing K2).**  Any Krein-positive sector on the modeled data is
contained in the canonical selector: no Krein-positive sector retains a
Krein-negative branch. -/
theorem maximal_kreinPositive (sel : Fin 4 → Bool)
    (h : ∀ a, sel a → branchKreinSig a = 1) :
    ∀ a, sel a → kreinSelector modeledData.krein a = true := by
  rw [modeledSelector_eq_physSel]
  exact kreinPositive_sector_subset_phys sel h

/-! ## 2. Rigidity under the full locked data -/

/-- The combined `(chirality, Krein sign)` label distinguishes all four branches. -/
theorem combined_label_injective :
    Function.Injective (fun a : Fin 4 => (branchChirality a, branchKreinSig a)) := by
  intro a b h
  fin_cases a <;> fin_cases b <;>
    first
      | rfl
      | (exfalso; revert h;
         simp only [branchChirality_eq, branchKreinSig_eq,
           PhysicsSM.Draft.NullEdgeFlavoredChirality.g5, Prod.mk.injEq, Fin.isValue];
         norm_num)

/-- **Rigidity.**  The only branch permutation preserving *both* the chirality
pattern and the Krein pattern is the identity. -/
theorem locked_rigid (σ : Equiv.Perm (Fin 4))
    (hc : permAct σ branchChirality = branchChirality)
    (hk : permAct σ branchKreinSig = branchKreinSig) : σ = 1 := by
  apply Equiv.ext
  intro a
  show σ a = a
  apply combined_label_injective
  have hca := congrFun hc a
  have hka := congrFun hk a
  simp only [permAct, Function.comp_apply] at hca hka
  exact Prod.ext hca hka

/-- **Selector canonical relative to the locked Krein data.**  Any branch
permutation preserving *both* the locked chirality and Krein patterns is the
identity (`locked_rigid`), hence fixes the selector as a labelling of branches:
`(kreinSelector …) ∘ σ = kreinSelector …`.  Thus, relative to the locked Krein
data, the retained sector is symmetry-invariant — canonical. -/
theorem selector_canonical_given_krein (σ : Equiv.Perm (Fin 4))
    (hc : permAct σ modeledData.chir = modeledData.chir)
    (hk : permAct σ modeledData.krein = modeledData.krein) :
    (fun a => kreinSelector modeledData.krein (σ a)) = kreinSelector modeledData.krein := by
  have hσ : σ = 1 := locked_rigid σ hc hk
  subst hσ
  rfl

/-! ## 3. No-go under chirality-only (and taste/energy/grading) data -/

/-- The chirality-preserving transposition `(0 1)`. -/
def chiralitySym : Equiv.Perm (Fin 4) := Equiv.swap 0 1

/-- `(0 1)` preserves the chirality pattern (branches `0,1` are both left-chiral). -/
theorem chiralitySym_preserves_chir :
    permAct chiralitySym modeledData.chir = modeledData.chir := by
  funext a; fin_cases a <;>
    simp +decide [permAct, chiralitySym, modeledData, branchChirality_eq,
      PhysicsSM.Draft.NullEdgeFlavoredChirality.g5, Equiv.swap_apply_def]

/-- `(0 1)` preserves the modeled taste (taste is chirality-determined). -/
theorem chiralitySym_preserves_taste :
    permAct chiralitySym modeledData.taste = modeledData.taste := by
  funext a; fin_cases a <;>
    simp +decide [permAct, chiralitySym, modeledData, branchChirality_eq,
      PhysicsSM.Draft.NullEdgeFlavoredChirality.g5, Equiv.swap_apply_def]

/-- `(0 1)` preserves the modeled energy (energy is constant). -/
theorem chiralitySym_preserves_energy :
    permAct chiralitySym modeledData.energy = modeledData.energy := by
  funext a; fin_cases a <;> simp +decide [permAct, chiralitySym, modeledData, Equiv.swap_apply_def]

/-- `(0 1)` preserves the modeled grading (grading is chirality-determined). -/
theorem chiralitySym_preserves_grading :
    permAct chiralitySym modeledData.grading = modeledData.grading := by
  funext a; fin_cases a <;>
    simp +decide [permAct, chiralitySym, modeledData, branchChirality_eq,
      PhysicsSM.Draft.NullEdgeFlavoredChirality.g5, Equiv.swap_apply_def]

/-- `(0 1)` does **not** preserve the Krein pattern. -/
theorem chiralitySym_moves_krein :
    permAct chiralitySym modeledData.krein ≠ modeledData.krein := by
  intro h
  have hc := congrFun h 0
  simp only [permAct, chiralitySym, modeledData, Function.comp_apply,
    Equiv.swap_apply_left] at hc
  rw [branchKreinSig_eq, branchKreinSig_eq] at hc
  norm_num at hc

/-- The Krein selector induced by the `(0 1)`-permuted data retains `{1, 2}`,
**not** `{0, 2}`. -/
theorem chiralitySym_selector_eq :
    kreinSelector (permAct chiralitySym modeledData.krein) = ![false, true, true, false] := by
  funext a; fin_cases a <;>
    simp +decide [kreinSelector, permAct, chiralitySym, modeledData, branchKreinSig_eq,
      Equiv.swap_apply_def] <;> norm_num

/-- **No-go.**  There is a nontrivial branch permutation preserving every locked
attribute *except* the Krein sign (chirality, taste, energy, grading) that
nonetheless moves the induced physical-species selector.  Hence chirality, taste,
energy, and grading together do **not** determine the retained pair `{0, 2}`. -/
theorem chirality_only_no_go :
    ∃ σ : Equiv.Perm (Fin 4),
      permAct σ modeledData.chir = modeledData.chir ∧
      permAct σ modeledData.taste = modeledData.taste ∧
      permAct σ modeledData.energy = modeledData.energy ∧
      permAct σ modeledData.grading = modeledData.grading ∧
      kreinSelector (permAct σ modeledData.krein) ≠ kreinSelector modeledData.krein := by
  refine ⟨chiralitySym, chiralitySym_preserves_chir, chiralitySym_preserves_taste,
    chiralitySym_preserves_energy, chiralitySym_preserves_grading, ?_⟩
  rw [chiralitySym_selector_eq, modeledSelector_eq]
  intro h
  have := congrFun h 0
  simp at this

/-! ## 4. Alignment with the C59 projected Gate C release API -/

/-- The canonical (Krein-derived) selector coincides with the `retained` field of
the C59 released witness `releasedData`. -/
theorem canonical_selector_eq_released_retained :
    kreinSelector modeledData.krein = releasedData.retained := by
  rw [modeledSelector_eq]; rfl

/-- **The selector clause is instantiated, not blocked.**  The C59 released
witness — whose `retained` field is exactly the Krein-canonical selector —
satisfies the full projected Gate C release certificate. -/
theorem canonical_selector_releases : ProjectedGateCRelease releasedData :=
  releasedData_releases

/-! ## Verdict -/

/-- **C65 verdict.**  A compact record of the selector audit:

* (uniqueness) the Krein-positive selector is unique and equals `{0,2}` on the
  modeled data;
* (rigidity) the only branch symmetry preserving both chirality and Krein is the
  identity — so `{0,2}` is canonical **given** the locked Krein data;
* (no-go) a chirality/taste/energy/grading-preserving symmetry moves the
  selector — so without the Krein lock `{0,2}` is **not** determined;
* (API) the canonical selector is the `retained` field of the C59 released
  witness, which satisfies `ProjectedGateCRelease`, so no release clause is
  blocked. -/
theorem c65_verdict :
    (∀ k sel, (∀ a, sel a = true ↔ k a = 1) → sel = kreinSelector k) ∧
    kreinSelector modeledData.krein = ![true, false, true, false] ∧
    (∀ σ : Equiv.Perm (Fin 4),
        permAct σ branchChirality = branchChirality →
        permAct σ branchKreinSig = branchKreinSig → σ = 1) ∧
    (∃ σ : Equiv.Perm (Fin 4),
        permAct σ modeledData.chir = modeledData.chir ∧
        permAct σ modeledData.taste = modeledData.taste ∧
        permAct σ modeledData.energy = modeledData.energy ∧
        permAct σ modeledData.grading = modeledData.grading ∧
        kreinSelector (permAct σ modeledData.krein) ≠ kreinSelector modeledData.krein) ∧
    kreinSelector modeledData.krein = releasedData.retained ∧
    ProjectedGateCRelease releasedData :=
  ⟨fun k sel h => kreinSelector_unique k sel h, modeledSelector_eq, locked_rigid,
    chirality_only_no_go, canonical_selector_eq_released_retained, canonical_selector_releases⟩

end PhysicsSM.Draft.NullEdgeCanonicalSpeciesSelector
