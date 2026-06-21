import Mathlib

/-!
# Constructive permutation of a 4-element information set

This module replaces the small `n a t i v e _ d e c i d e` search used by
`PhysicsSM.Coding.Hamming844Classification.exists_perm_to_first4`.

The statement is purely finite-combinatorial: if `I` is a 4-element subset of
`Fin 8`, then some coordinate permutation sends `I` exactly to the first four
coordinates `{0, 1, 2, 3}`.

The proof is deliberately structural.  It decomposes `Fin 8` into the disjoint
sum of the subtype `I` and the subtype `Iᶜ`, identifies each half with `Fin 4`,
and then recombines the two halves as `Fin 4 ⊕ Fin 4 ≃ Fin 8`.

Provenance: Aristotle job `a0ceb4a5-d8d8-4df5-851e-e9762468e367`, reviewed
and integrated 2026-05-19.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

noncomputable section

/-- The permutation built from the sum decomposition
`Fin 8 ≃ (↥I ⊕ ↥Iᶜ) ≃ (Fin 4 ⊕ Fin 4) ≃ Fin 8`. -/
private def mkPerm (I : Finset (Fin 8)) (hI : I.card = 4) (hIc : Iᶜ.card = 4) :
    Equiv.Perm (Fin 8) :=
  (Equiv.sumCompl (· ∈ I)).symm.trans
    ((Equiv.sumCongr
      (I.orderIsoOfFin hI).toEquiv.symm
      ((Equiv.subtypeEquiv (Equiv.refl _)
        (fun _ => Finset.mem_compl.symm)).trans
        (Iᶜ.orderIsoOfFin hIc).toEquiv.symm)).trans
      finSumFinEquiv)

/-- For `x ∈ I`, `mkPerm` sends `x` to the low block `Fin.castAdd 4 _`. -/
private lemma mkPerm_apply_mem (I : Finset (Fin 8)) (hI : I.card = 4)
    (hIc : Iᶜ.card = 4) (x : Fin 8) (hx : x ∈ I) :
    mkPerm I hI hIc x =
      Fin.castAdd 4 ((I.orderIsoOfFin hI).toEquiv.symm ⟨x, hx⟩) := by
  simp only [mkPerm, Equiv.trans_apply,
    Equiv.sumCompl_symm_apply_of_pos hx,
    Equiv.sumCongr_apply, Sum.map_inl]
  rfl

/-- Any element in the image of `I` under `mkPerm` lands in `{0,1,2,3}`. -/
private lemma mkPerm_mem_first4 (I : Finset (Fin 8)) (hI : I.card = 4)
    (hIc : Iᶜ.card = 4) (x : Fin 8) (hx : x ∈ I) :
    mkPerm I hI hIc x ∈ ({0, 1, 2, 3} : Finset (Fin 8)) := by
  rw [mkPerm_apply_mem I hI hIc x hx]
  generalize (I.orderIsoOfFin hI).toEquiv.symm ⟨x, hx⟩ = j
  fin_cases j <;> decide

/-- Every element of `{0,1,2,3}` has a preimage in `I` under `mkPerm`. -/
private lemma mkPerm_surj_first4 (I : Finset (Fin 8)) (hI : I.card = 4)
    (hIc : Iᶜ.card = 4) (y : Fin 8)
    (hy : y ∈ ({0, 1, 2, 3} : Finset (Fin 8))) :
    ∃ x ∈ I, mkPerm I hI hIc x = y := by
  have hylt : y.val < 4 := by fin_cases y <;> simp_all +decide
  let j : Fin 4 := ⟨y.val, hylt⟩
  let a := (I.orderIsoOfFin hI) j
  refine ⟨↑a, a.prop, ?_⟩
  rw [mkPerm_apply_mem I hI hIc ↑a a.prop]
  have key : (I.orderIsoOfFin hI).toEquiv.symm ⟨↑a, a.prop⟩ = j := by
    have : (⟨↑a, a.prop⟩ : ↥I) = a := rfl
    rw [this]
    exact (I.orderIsoOfFin hI).toEquiv.symm_apply_apply j
  rw [key]
  exact Fin.ext (by simp [j])

/--
No-native replacement for `exists_perm_to_first4`.

The theorem intentionally does not import or use the original
`exists_perm_to_first4` finite search.  It constructs a permutation by putting
the 4 elements of `I` in the low coordinate block and the 4 elements of `Iᶜ` in
the high coordinate block.
-/
theorem exists_perm_to_first4_constructive
    (I : Finset (Fin 8)) (hI : I.card = 4) :
    ∃ sigma : Equiv.Perm (Fin 8), I.image sigma = {0, 1, 2, 3} := by
  have hIc : Iᶜ.card = 4 := by rw [Finset.card_compl, Fintype.card_fin, hI]
  refine ⟨mkPerm I hI hIc, ?_⟩
  ext y
  simp only [Finset.mem_image]
  constructor
  · rintro ⟨x, hx, hxy⟩
    rw [← hxy]
    exact mkPerm_mem_first4 I hI hIc x hx
  · intro hy
    exact mkPerm_surj_first4 I hI hIc y hy

end

end PhysicsSM.Coding
