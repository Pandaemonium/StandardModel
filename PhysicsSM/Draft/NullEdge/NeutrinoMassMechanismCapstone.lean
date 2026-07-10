import Mathlib
import PhysicsSM.Draft.NullEdge.NeutrinoDiracMajorana
import PhysicsSM.Draft.NullEdge.NeutrinoSeesaw
import PhysicsSM.Draft.NullEdge.SchurSeesaw

/-!
# Neutrino mass mechanism — finite capstone

This file **composes** four independently kernel-checked finite avatars into a single
honest "mechanism hierarchy" for neutrino lightness.  It introduces **no new
assumptions** and **no new mathematical content**: every conjunct is discharged by an
imported, already-proven theorem.

The four branches:

* **Dirac / Majorana** (`NeutrinoDiracMajorana`): a Dirac mass links a state to an
  *independent* CPT-conjugate partner and conserves lepton number (`[M_D, Q] = 0`),
  whereas a Majorana mass is supported on the self-CPT-conjugate sector and *violates*
  lepton number (`[M_M, Q] ≠ 0`).
* **Type-I finite seesaw** (`NeutrinoSeesaw`): a heavy sterile Majorana partner
  `MR > 0` suppresses the light eigenvalue, `|ln| < mD² / MR`, with the product of the
  two masses pinned at `mD²`.
* **Schur finite seesaw** (`SchurSeesaw`): hidden-block leakage into a heavy
  positive-definite hidden block is resolvent-suppressed (`≤ ‖Bᴴ v‖² / λ_min(M)`) and
  vanishes *exactly* iff the hidden overlap is closed (`Bᴴ v = 0`).

**Honest scope.**  This is a *structural* statement.  It is not a prediction of the
physical neutrino mass, nor of whether nature realises Dirac or Majorana neutrinos.
The capstone theorem `neutrino_mass_mechanism_verdict` records that finite neutrino
lightness is *structurally supplied* by a Majorana / heavy-hidden branch plus
suppressed leakage — never by a bare mass assertion.
-/

open Matrix
open scoped ComplexOrder

set_option maxHeartbeats 8000000

namespace NeutrinoMassMechanismCapstone

/-! ## Branch 1 — Dirac / Majorana distinction -/

/-- **Dirac / Majorana branch.**  Bundles the four imported Dirac–Majorana results:
the Dirac two-state structure, the Majorana self-conjugate constraint, the lepton-number
commutator dichotomy, and the packaged neutrino verdict. -/
theorem dirac_majorana_branch_capstone :
    (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
        NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
          NeutrinoDiracMajorana.psiDPartner ∧
        NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP) ∧
      (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv = NeutrinoDiracMajorana.psiInv ∧
        NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv ≠ 0 ∧
        NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiNI ≠ NeutrinoDiracMajorana.psiNI ∧
        NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiNI = 0) ∧
      (NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
          NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD ∧
        NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q ≠
          NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM ∧
        (NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q -
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) 0 2 = -2) ∧
      ((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
          NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
            NeutrinoDiracMajorana.psiDPartner ∧
          NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP ∧
          NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD) ∧
        (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv = NeutrinoDiracMajorana.psiInv ∧
          NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv ≠ 0 ∧
          NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q ≠
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) ∧
        (∀ v : Fin 4 → ℂ, NeutrinoDiracMajorana.Theta (NeutrinoDiracMajorana.Theta v) = v)) := by
  exact ⟨NeutrinoDiracMajorana.dirac_two_states,
    NeutrinoDiracMajorana.majorana_self_conjugate,
    NeutrinoDiracMajorana.lepton_number,
    NeutrinoDiracMajorana.neutrino_verdict⟩

/-! ## Branch 2 — Type-I finite seesaw -/

/-- **Type-I finite seesaw branch.**  Bundles the general seesaw verdict (suppression
`|ln| < mD²/MR` with product pinned at `mD²`), the strong-hierarchy non-degeneracy
witness (`mD = 1, MR = 100` gives `|ln| < 1/100`), and the no-hierarchy control
(`mD = MR = 1` gives `|ln| < 1`, not small). -/
theorem typeI_seesaw_capstone :
    (∀ mD MR lp ln : ℝ,
        0 < mD → 0 < MR →
        lp * ln = -mD ^ 2 → lp + ln = MR → ln < 0 →
        0 < lp ∧ ln < 0 ∧ lp * (-ln) = mD ^ 2 ∧ -ln < mD ^ 2 / MR) ∧
      (∀ lp ln : ℝ,
        lp * ln = -(1 : ℝ) ^ 2 → lp + ln = 100 → ln < 0 →
        100 < lp ∧ -ln < (1 : ℝ) ^ 2 / 100) ∧
      (∀ lp ln : ℝ,
        lp * ln = -(1 : ℝ) ^ 2 → lp + ln = 1 → ln < 0 →
        -ln < (1 : ℝ) ^ 2 / 1) := by
  refine ⟨?_, ?_, ?_⟩
  · intro mD MR lp ln hmD hMR hprod hsum hln
    exact NeutrinoSeesaw.seesaw_verdict mD MR lp ln hmD hMR hprod hsum hln
  · intro lp ln hprod hsum hln
    exact NeutrinoSeesaw.nondegen_suppressed lp ln hprod hsum hln
  · intro lp ln hprod hsum hln
    exact NeutrinoSeesaw.nondegen_control lp ln hprod hsum hln

/-! ## Branch 3 — Schur finite seesaw -/

/-- **Schur finite seesaw branch.**  Bundles the resolvent-suppression bound on the
protected mode (`|⟨v, (A − B M⁻¹ Bᴴ) v⟩.re| ≤ ‖Bᴴ v‖² / λ_min(M)`) and the exact
protection criterion (the induced mass vanishes iff `Bᴴ v = 0`, i.e. the hidden overlap
is closed). -/
theorem schur_seesaw_payload_capstone :
    (∀ {nv nh : Type} [Fintype nv] [DecidableEq nv] [Fintype nh]
        [DecidableEq nh] [Nonempty nh]
        (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ)
        (hM : M.PosDef) (v : nv → ℂ), A *ᵥ v = 0 →
      |(star v ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ v).re|
        ≤ (star (Bᴴ *ᵥ v) ⬝ᵥ (Bᴴ *ᵥ v)).re /
          PhysicsSM.Draft.NullEdge.SchurSeesaw.leastEigen hM) ∧
    (∀ {nv nh : Type} [Fintype nv] [DecidableEq nv] [Fintype nh]
        [DecidableEq nh]
        (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ)
        (hM : M.PosDef) (v : nv → ℂ), A *ᵥ v = 0 →
      (star v ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ v = 0 ↔ Bᴴ *ᵥ v = 0)) := by
  refine ⟨?_, ?_⟩
  · intro nv nh _ _ _ _ _ A B M hM v hprot
    exact PhysicsSM.Draft.NullEdge.SchurSeesaw.seesaw_suppression A B M hM v hprot
  · intro nv nh _ _ _ _ A B M hM v hprot
    exact PhysicsSM.Draft.NullEdge.SchurSeesaw.seesaw_zero_iff_no_overlap A B M hM v hprot

/-! ## Capstone verdict -/

/-- **Neutrino mass mechanism verdict.**

The honest mechanism hierarchy: finite neutrino lightness is *structurally supplied* by

* a lepton-number–violating **Majorana** / self-conjugate branch,
* a **heavy-hidden** (type-I / Schur) branch whose light eigenvalue is suppressed by the
  heavy scale (`mD²/MR`, resp. `‖Bᴴ v‖²/λ_min(M)`),
* with the suppressed **leakage** vanishing exactly when the hidden overlap is closed —

and **not** by a bare mass assertion.  Every conjunct is an imported kernel-checked
theorem; the capstone merely records their conjunction.  Finite structural statement;
not a physical prediction. -/
theorem neutrino_mass_mechanism_verdict :
    ((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
        NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
          NeutrinoDiracMajorana.psiDPartner ∧
        NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP) ∧
      (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv = NeutrinoDiracMajorana.psiInv ∧
        NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv ≠ 0 ∧
        NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiNI ≠ NeutrinoDiracMajorana.psiNI ∧
        NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiNI = 0) ∧
      (NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
          NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD ∧
        NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q ≠
          NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM ∧
        (NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q -
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) 0 2 = -2) ∧
      ((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
          NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
            NeutrinoDiracMajorana.psiDPartner ∧
          NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP ∧
          NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD) ∧
        (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv = NeutrinoDiracMajorana.psiInv ∧
          NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv ≠ 0 ∧
          NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q ≠
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) ∧
        (∀ v : Fin 4 → ℂ, NeutrinoDiracMajorana.Theta (NeutrinoDiracMajorana.Theta v) = v))) ∧
      ((∀ mD MR lp ln : ℝ,
        0 < mD → 0 < MR →
        lp * ln = -mD ^ 2 → lp + ln = MR → ln < 0 →
        0 < lp ∧ ln < 0 ∧ lp * (-ln) = mD ^ 2 ∧ -ln < mD ^ 2 / MR) ∧
      (∀ lp ln : ℝ,
        lp * ln = -(1 : ℝ) ^ 2 → lp + ln = 100 → ln < 0 →
        100 < lp ∧ -ln < (1 : ℝ) ^ 2 / 100) ∧
      (∀ lp ln : ℝ,
        lp * ln = -(1 : ℝ) ^ 2 → lp + ln = 1 → ln < 0 →
        -ln < (1 : ℝ) ^ 2 / 1)) ∧
      ((∀ {nv nh : Type} [Fintype nv] [DecidableEq nv] [Fintype nh]
        [DecidableEq nh] [Nonempty nh]
        (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ)
        (hM : M.PosDef) (v : nv → ℂ), A *ᵥ v = 0 →
      |(star v ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ v).re|
        ≤ (star (Bᴴ *ᵥ v) ⬝ᵥ (Bᴴ *ᵥ v)).re /
          PhysicsSM.Draft.NullEdge.SchurSeesaw.leastEigen hM) ∧
    (∀ {nv nh : Type} [Fintype nv] [DecidableEq nv] [Fintype nh]
        [DecidableEq nh]
        (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ)
        (hM : M.PosDef) (v : nv → ℂ), A *ᵥ v = 0 →
      (star v ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ v = 0 ↔ Bᴴ *ᵥ v = 0))) := by
  exact ⟨dirac_majorana_branch_capstone, typeI_seesaw_capstone, schur_seesaw_payload_capstone⟩

/-! ## Axiom footprint of every headline result -/

/-- info: 'NeutrinoMassMechanismCapstone.dirac_majorana_branch_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dirac_majorana_branch_capstone

/-- info: 'NeutrinoMassMechanismCapstone.typeI_seesaw_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms typeI_seesaw_capstone

/-- info: 'NeutrinoMassMechanismCapstone.schur_seesaw_payload_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms schur_seesaw_payload_capstone

/-- info: 'NeutrinoMassMechanismCapstone.neutrino_mass_mechanism_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms neutrino_mass_mechanism_verdict

end NeutrinoMassMechanismCapstone
