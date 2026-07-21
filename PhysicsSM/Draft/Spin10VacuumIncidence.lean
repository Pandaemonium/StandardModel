import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldPurity

noncomputable section
namespace PhysicsSM.Draft.Spin10VacuumIncidence
open PhysicsSM.Spinor.SpinorTenfold

def OrthogonalToVacuum (psi : FockSpinor) : Prop :=
  gammaBilinear vacuumSpinor psi + gammaBilinear psi vacuumSpinor = 0

def DistinctFromVacuum (psi : FockSpinor) : Prop :=
  ¬ ∃ c : ℂ, psi = c • vacuumSpinor

def vacuumCommon (psi : FockSpinor) : Submodule ℂ V10 :=
  annihilator vacuumSpinor ⊓ annihilator psi

lemma orthogonal_vacuum_four_coeff_zero
    (psi : FockSpinor) (horth : OrthogonalToVacuum psi) :
    ∀ T : Finset (Fin 5), T.card = 4 → psi T = 0 := by
  intro T hT_card
  obtain ⟨j, hj⟩ : ∃ j : Fin 5, T = Finset.univ \ {j} := by
    fin_cases T <;> simp_all +decide
  unfold OrthogonalToVacuum at horth
  simp_all +decide [funext_iff, gammaBilinear]
  simp_all +decide [chevalleyPairing, contract, wedge]
  simp_all +decide [Finset.sum_ite, vacuumSpinor, basisSpinor]
  specialize horth j
  rw [Finset.sum_eq_single {j}] at horth <;>
    simp_all +decide [Finset.compl_eq_univ_sdiff]
  · simp_all +decide [Finset.sdiff_singleton_eq_erase, chevalleySign, opSign]
    fin_cases j <;> simp_all +decide [shuffleInversions, belowCount]
  · intro b hb1 hb2 hb3
    rw [Finset.erase_eq_iff_eq_insert] at hb2 <;> aesop

lemma genuine_vacuum_has_two_coeff
    (psi : FockSpinor) (heven : IsEvenSpinor psi)
    (hfour : ∀ T : Finset (Fin 5), T.card = 4 → psi T = 0)
    (hdist : DistinctFromVacuum psi) :
    ∃ T : Finset (Fin 5), T.card = 2 ∧ psi T ≠ 0 := by
  contrapose! hdist
  have h_form : ∀ S : Finset (Fin 5), psi S ≠ 0 → S = ∅ := by
    intro S hS
    have := heven S
    simp_all +decide
    fin_cases S <;> simp_all +decide only
  obtain ⟨c, hc⟩ : ∃ c : ℂ, psi = c • vacuumSpinor := by
    use psi ∅
    ext S
    specialize h_form S
    by_cases hS : S = ∅ <;> simp_all +decide [vacuumSpinor]
    exact Or.inr (by
      unfold basisSpinor
      aesop)
  exact fun h => h ⟨c, hc⟩

end PhysicsSM.Draft.Spin10VacuumIncidence
