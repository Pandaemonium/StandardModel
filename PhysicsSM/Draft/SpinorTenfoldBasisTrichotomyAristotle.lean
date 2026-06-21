import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldColorAxis

/-!
# Draft.SpinorTenfoldBasisTrichotomyAristotle

Aristotle handoff: the annihilator-intersection dimension formula for pairs
of Fock basis spinors, and the resulting `d ∈ {1, 3, 5}` trichotomy on
normal forms.

## Mathematical intent

This is the normal-form backbone of Proposition 3 (the orbit trichotomy) of
`Sources/Spin10_stabilizer.txt`. Every Fock basis spinor
`basisSpinor T` is pure with maximal isotropic annihilator

  `N_T = ⟨e_i : i ∈ T⟩ ⊕ ⟨f_i : i ∉ T⟩`,

and for two basis spinors the intersection is read off index by index:

  `N_S ∩ N_T = ⟨e_i : i ∈ S ∩ T⟩ ⊕ ⟨f_i : i ∉ S ∪ T⟩`,

so `dim(N_S ∩ N_T) = |S ∩ T| + (5 - |S ∪ T|) = 5 - |S ∆ T|`. For two
*even* subsets the symmetric difference has even cardinality `0`, `2`, or
`4`, giving exactly the trichotomy `d ∈ {5, 3, 1}`:

- `d = 5`: same spinor (the trivial stratum);
- `d = 3`: the Krasnov stratum (e.g. `∅` and `{3,4}`: the witness pair,
  whose intersection is the color axis of
  `PhysicsSM.Spinor.SpinorTenfoldColorAxis` — `pairAnnihilator_vacuum_weak`
  below anchors this);
- `d = 1`: the generic stratum (e.g. `∅` and `{0,1,2,3}`).

Once the group-level `Spin(10)` action with its transitivity statements is
available, the trichotomy on basis pairs extends to all pure-spinor pairs;
this module deliberately stays at the kernel-checkable normal-form level.

## Proof guidance

- `mem_annihilator_basisSpinor_iff`: expand `cliffordAction` via
  `cliffordAction_eq_sum`; the images `wedge i (basisSpinor T)` (for
  `i ∉ T`) and `contract i (basisSpinor T)` (for `i ∈ T`) are signed
  *distinct* basis spinors (`wedge_basisSpinor_of_not_mem`,
  `contract_basisSpinor_of_mem`), so the sum vanishes iff every coefficient
  does. Evaluating the sum at the individual subsets `insert i T` and
  `T.erase i` extracts each coefficient; the model proof is
  `mem_annihilator_vacuumSpinor_iff` in
  `PhysicsSM.Spinor.SpinorTenfoldPurity` and
  `mem_annihilator_weakSpinor_iff` in
  `PhysicsSM.Spinor.SpinorTenfoldColorAxis`.
- `finrank_pairAnnihilator`: build a linear equivalence with
  `({i // i ∈ S ∩ T} → ℂ) × ({i // i ∉ S ∪ T} → ℂ)` (or with
  `Fin ((S ∩ T).card) → ℂ` etc.) following the explicit
  to/from/left-inv/right-inv pattern of `colorAxisLinearEquivC3`, then use
  `Module.finrank_pi`, `Module.finrank_prod`, and
  `Fintype.card_coe`/`Fintype.card_subtype`.
- The cardinality identity `card_inter_add_card_compl_union` is decidable
  over `Finset (Fin 5) × Finset (Fin 5)` (1024 cases) — plain kernel
  `decide` is acceptable — or provable structurally from
  `Finset.card_inter_add_card_union` and
  `Finset.card_symmDiff`-style lemmas. **No `n a t i v e _ d e c i d e`.**

Do not change any definition or sign convention. Helper lemmas are
welcome.

This is draft code: the statements below contain documented `s o r r y`s and
must not be imported from trusted code until the holes are eliminated.
-/

noncomputable section

namespace PhysicsSM.Draft.SpinorTenfoldBasisTrichotomy

open PhysicsSM.Spinor.SpinorTenfold
open scoped symmDiff

/-! ## The annihilator of a basis spinor, in coordinates -/

/-
**Target 1**: coordinate characterization of the annihilator of an
arbitrary Fock basis spinor: creation directions for occupied indices,
annihilation directions for empty ones. Generalizes
`mem_annihilator_vacuumSpinor_iff` (the case `T = ∅`) and
`mem_annihilator_weakSpinor_iff` (the case `T = {3,4}`).
-/
theorem mem_annihilator_basisSpinor_iff (T : Finset (Fin 5)) (v : V10) :
    v ∈ annihilator (basisSpinor T)
      ↔ (∀ i ∉ T, v.1 i = 0) ∧ (∀ i ∈ T, v.2 i = 0) := by
  constructor
  · intro hv
    have h_sum :
        (∑ i, v.1 i • wedge i (basisSpinor T))
          + (∑ i, v.2 i • contract i (basisSpinor T)) = 0 := by
      convert hv using 1
    constructor <;> intro i hi <;>
      have := congr_fun h_sum (if i ∈ T then T.erase i else insert i T) <;>
      simp_all +decide [Finset.sum_apply, Finset.sum_ite, Finset.filter_ne',
        Finset.filter_eq']
    · rw [Finset.sum_eq_single i, Finset.sum_eq_zero] at this <;>
        simp_all +decide [wedge, contract]
      · exact this.resolve_right fun h => by
          have := opSign_mul_self i (insert i T); aesop
      · grind +suggestions
      · grind +suggestions
    · rw [Finset.sum_eq_single i, Finset.sum_eq_single i] at this <;>
        simp_all +decide [wedge, contract]
      · exact this.resolve_right (pow_ne_zero _ (by norm_num))
      · intro j hj₁ hj₂
        contrapose! hj₂
        simp_all +decide [basisSpinor]
        exact hj₂.2.2 ▸ Finset.mem_insert_self _ _
      · intro j hj₁ hj₂
        contrapose! hj₁
        simp_all +decide [basisSpinor]
        grind
  · intro hv
    simp [annihilator, hv]
    ext S
    simp +decide [*, cliffordAction_eq_sum]
    rw [← Finset.sum_add_distrib]
    refine Finset.sum_eq_zero fun i hi => ?_
    by_cases hi' : i ∈ T <;>
      simp_all +decide [wedge_basisSpinor_of_not_mem, wedge_basisSpinor_of_mem,
        contract_basisSpinor_of_mem, contract_basisSpinor_of_not_mem]

/-! ## Pair intersections -/

/-- The common annihilator of a pair of basis spinors. For the witness pair
`(∅, {3,4})` this is the color axis `colorAxisSubmodule`. -/
abbrev pairAnnihilator (S T : Finset (Fin 5)) : Submodule ℂ V10 :=
  annihilator (basisSpinor S) ⊓ annihilator (basisSpinor T)

/-- **Target 2**: the common annihilator in coordinates: the creation half
is supported on `S ∩ T`, the annihilation half on the complement of
`S ∪ T`. Should follow formally from Target 1. -/
theorem mem_pairAnnihilator_iff (S T : Finset (Fin 5)) (v : V10) :
    v ∈ pairAnnihilator S T
      ↔ (∀ i ∉ S ∩ T, v.1 i = 0) ∧ (∀ i ∈ S ∪ T, v.2 i = 0) := by
  simp only [pairAnnihilator, Submodule.mem_inf, mem_annihilator_basisSpinor_iff]
  constructor
  · rintro ⟨⟨hS1, hS2⟩, hT1, hT2⟩
    refine ⟨fun i hi => ?_, fun i hi => ?_⟩
    · rw [Finset.mem_inter] at hi
      by_cases h : i ∈ S
      · exact hT1 i (fun hiT => hi ⟨h, hiT⟩)
      · exact hS1 i h
    · rw [Finset.mem_union] at hi
      rcases hi with h | h
      · exact hS2 i h
      · exact hT2 i h
  · rintro ⟨h1, h2⟩
    refine ⟨⟨fun i hi => ?_, fun i hi => ?_⟩, fun i hi => ?_, fun i hi => ?_⟩
    · exact h1 i (fun hh => hi (Finset.mem_inter.1 hh).1)
    · exact h2 i (Finset.mem_union_left _ hi)
    · exact h1 i (fun hh => hi (Finset.mem_inter.1 hh).2)
    · exact h2 i (Finset.mem_union_right _ hi)

/-- Consistency anchor: for the witness pair the general machinery recovers
the trusted color axis. Should be `Submodule.ext` from Target 2 and
`mem_colorAxis_iff`. -/
theorem pairAnnihilator_vacuum_weak :
    pairAnnihilator ∅ ({3, 4} : Finset (Fin 5)) = colorAxisSubmodule := rfl

/-! ## The dimension formula -/

/-- The coordinate type for the pair annihilator: creation coordinates on
`S ∩ T` and annihilation coordinates on the complement of `S ∪ T`. -/
abbrev pairCoord (S T : Finset (Fin 5)) : Type :=
  ({i : Fin 5 // i ∈ S ∩ T} → ℂ) × ({i : Fin 5 // i ∉ S ∪ T} → ℂ)

/-- Forward map: read off the supported coordinates. -/
def pairAnnihilatorToCoord (S T : Finset (Fin 5)) :
    pairAnnihilator S T →ₗ[ℂ] pairCoord S T where
  toFun v := (fun i => (v : V10).1 i.1, fun i => (v : V10).2 i.1)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- The underlying vector built from a `pairCoord` pair. -/
def pairAnnihilatorInvFun (S T : Finset (Fin 5)) (c : pairCoord S T) : V10 :=
  (fun i => if h : i ∈ S ∩ T then c.1 ⟨i, h⟩ else 0,
   fun i => if h : i ∉ S ∪ T then c.2 ⟨i, h⟩ else 0)

theorem pairAnnihilatorInvFun_mem (S T : Finset (Fin 5)) (c : pairCoord S T) :
    pairAnnihilatorInvFun S T c ∈ pairAnnihilator S T := by
  rw [mem_pairAnnihilator_iff]
  refine ⟨fun i hi => ?_, fun i hi => ?_⟩
  · simp only [pairAnnihilatorInvFun, dif_neg hi]
  · simp only [pairAnnihilatorInvFun, dif_neg (not_not_intro hi)]

theorem pairAnnihilatorInvFun_add (S T : Finset (Fin 5)) (c d : pairCoord S T) :
    pairAnnihilatorInvFun S T (c + d)
      = pairAnnihilatorInvFun S T c + pairAnnihilatorInvFun S T d := by
  apply Prod.ext <;> funext i <;>
    · simp only [pairAnnihilatorInvFun, Prod.fst_add, Prod.snd_add, Pi.add_apply]
      split_ifs <;> simp

theorem pairAnnihilatorInvFun_smul (S T : Finset (Fin 5)) (a : ℂ)
    (c : pairCoord S T) :
    pairAnnihilatorInvFun S T (a • c) = a • pairAnnihilatorInvFun S T c := by
  apply Prod.ext <;> funext i <;>
    · simp only [pairAnnihilatorInvFun, Prod.smul_fst, Prod.smul_snd, Pi.smul_apply,
        smul_eq_mul]
      split_ifs <;> simp

/-- Inverse map: build the pair-annihilator vector from a `pairCoord` pair. -/
def pairAnnihilatorFromCoord (S T : Finset (Fin 5)) :
    pairCoord S T →ₗ[ℂ] pairAnnihilator S T where
  toFun c := ⟨pairAnnihilatorInvFun S T c, pairAnnihilatorInvFun_mem S T c⟩
  map_add' c d := Subtype.ext (pairAnnihilatorInvFun_add S T c d)
  map_smul' a c := Subtype.ext (pairAnnihilatorInvFun_smul S T a c)

theorem pairAnnihilator_left_inv (S T : Finset (Fin 5))
    (v : pairAnnihilator S T) :
    pairAnnihilatorFromCoord S T (pairAnnihilatorToCoord S T v) = v := by
  apply Subtype.ext
  apply Prod.ext <;> funext i <;>
    simp only [pairAnnihilatorFromCoord, pairAnnihilatorToCoord, pairAnnihilatorInvFun,
      LinearMap.coe_mk, AddHom.coe_mk]
  · by_cases h : i ∈ S ∩ T
    · rw [dif_pos h]
    · rw [dif_neg h]
      exact (((mem_pairAnnihilator_iff S T _).1 v.2).1 i h).symm
  · by_cases h : i ∈ S ∪ T
    · rw [dif_neg (not_not_intro h)]
      exact (((mem_pairAnnihilator_iff S T _).1 v.2).2 i h).symm
    · rw [dif_pos h]

theorem pairAnnihilator_right_inv (S T : Finset (Fin 5)) (c : pairCoord S T) :
    pairAnnihilatorToCoord S T (pairAnnihilatorFromCoord S T c) = c := by
  apply Prod.ext <;> funext i <;>
    · simp only [pairAnnihilatorToCoord, pairAnnihilatorFromCoord, pairAnnihilatorInvFun,
        LinearMap.coe_mk, AddHom.coe_mk]
      rw [dif_pos i.2]

/-- The pair annihilator is linearly equivalent to its coordinate type. -/
noncomputable def pairAnnihilatorEquivCoord (S T : Finset (Fin 5)) :
    pairAnnihilator S T ≃ₗ[ℂ] pairCoord S T :=
  LinearEquiv.ofLinear (pairAnnihilatorToCoord S T) (pairAnnihilatorFromCoord S T)
    (LinearMap.ext (pairAnnihilator_right_inv S T))
    (LinearMap.ext (pairAnnihilator_left_inv S T))

/-- The cardinality bookkeeping behind the dimension formula. -/
theorem pairCoord_card (S T : Finset (Fin 5)) :
    Fintype.card {i : Fin 5 // i ∈ S ∩ T}
        + Fintype.card {i : Fin 5 // i ∉ S ∪ T}
      = (S ∩ T).card + (5 - (S ∪ T).card) := by
  have h1 : Fintype.card {i : Fin 5 // i ∈ S ∩ T} = (S ∩ T).card := by
    rw [Fintype.card_subtype]; congr 1; ext i; simp
  have h2 : Fintype.card {i : Fin 5 // i ∈ S ∪ T} = (S ∪ T).card := by
    rw [Fintype.card_subtype]; congr 1; ext i; simp
  rw [h1, Fintype.card_subtype_compl, h2, Fintype.card_fin]

/-- **Target 3 (the main theorem)**: the dimension of the common
annihilator of two basis spinors is `|S ∩ T| + (5 - |S ∪ T|)`. -/
theorem finrank_pairAnnihilator (S T : Finset (Fin 5)) :
    Module.finrank ℂ (pairAnnihilator S T)
      = (S ∩ T).card + (5 - (S ∪ T).card) := by
  rw [(pairAnnihilatorEquivCoord S T).finrank_eq, Module.finrank_prod,
    Module.finrank_pi, Module.finrank_pi, pairCoord_card]

/-- The counting identity rewriting the dimension through the symmetric
difference. (`∆` is `symmDiff`; for subsets of `Fin 5` this is decidable,
and plain kernel `decide` over the 1024 pairs is acceptable.) -/
theorem card_inter_add_card_compl_union (S T : Finset (Fin 5)) :
    (S ∩ T).card + (5 - (S ∪ T).card) = 5 - (S ∆ T).card := by
  revert S T
  decide

/-- The dimension formula in symmetric-difference form:
`dim(N_S ∩ N_T) = 5 - |S ∆ T|`. -/
theorem finrank_pairAnnihilator_symmDiff (S T : Finset (Fin 5)) :
    Module.finrank ℂ (pairAnnihilator S T) = 5 - (S ∆ T).card := by
  rw [finrank_pairAnnihilator, card_inter_add_card_compl_union]

/-! ## The trichotomy -/

/-- **Target 4 (the trichotomy)**: for two *even* basis spinors the common
annihilator has dimension `1`, `3`, or `5` — the three strata of the orbit
trichotomy (generic / Krasnov / equal), here on normal forms. The
parity argument: `|S ∆ T| ≡ |S| + |T| ≡ 0 (mod 2)` and `|S ∆ T| ≤ 5`, so
`|S ∆ T| ∈ {0, 2, 4}`. -/
theorem finrank_pairAnnihilator_trichotomy (S T : Finset (Fin 5))
    (hS : S.card % 2 = 0) (hT : T.card % 2 = 0) :
    Module.finrank ℂ (pairAnnihilator S T) = 1
      ∨ Module.finrank ℂ (pairAnnihilator S T) = 3
      ∨ Module.finrank ℂ (pairAnnihilator S T) = 5 := by
  have key := finrank_pairAnnihilator_symmDiff S T
  have huni := Finset.card_union_add_card_inter S T
  have hsymm : (S ∆ T).card + (S ∩ T).card = (S ∪ T).card := by
    have hsup : (S ∆ T) ∪ (S ∩ T) = S ∪ T := symmDiff_sup_inf S T
    have hd : Disjoint (S ∆ T) (S ∩ T) := disjoint_symmDiff_inf S T
    rw [← hsup]
    exact (Finset.card_union_of_disjoint hd).symm
  have hle : (S ∪ T).card ≤ 5 := by
    have := Finset.card_le_univ (S ∪ T)
    simpa using this
  omega

/-- Stratum witnesses: the three dimensions are all realized (by `(∅, ∅)`,
the Krasnov pair `(∅, {3,4})`, and the generic pair `(∅, {0,1,2,3})`).
Should follow from `finrank_pairAnnihilator_symmDiff` by evaluation. -/
theorem trichotomy_witnesses :
    Module.finrank ℂ (pairAnnihilator ∅ ∅) = 5
      ∧ Module.finrank ℂ (pairAnnihilator ∅ ({3, 4} : Finset (Fin 5))) = 3
      ∧ Module.finrank ℂ
          (pairAnnihilator ∅ ({0, 1, 2, 3} : Finset (Fin 5))) = 1 := by
  refine ⟨?_, ?_, ?_⟩ <;>
    rw [finrank_pairAnnihilator_symmDiff] <;> decide

end PhysicsSM.Draft.SpinorTenfoldBasisTrichotomy

end
