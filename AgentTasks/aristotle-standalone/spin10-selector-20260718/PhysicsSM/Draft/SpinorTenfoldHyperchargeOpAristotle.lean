import Mathlib
import PhysicsSM.Draft.SpinorTenfoldSO10ActionAristotle
import PhysicsSM.StandardModel.SpinorFockHypercharge

/-!
# Draft.SpinorTenfoldHyperchargeOpAristotle

Aristotle handoff: the physical hypercharge generator inside the
infinitesimal `so(10)` action on the Fock model.

## Mathematical intent

This is the infinitesimal heart of Proposition S3 of
`Sources/Spin10_stabilizer.txt` ("the stabilizer carries the *physical*
hypercharges, not just the abstract group"), and of its companion
proposition that passing from the marked pair `(ψ₁, ψ₂)` to the mixed
marked/projective pair `(ψ₁, [ψ₂])` enlarges the stabilizer from
`SU(2) × SU(3)` to `S(U(2) × U(3))` — the added one-dimensional freedom
*is* hypercharge.

The Cartan element is built from the number-operator bivectors:

  `Y = Σᵢ yᵢ ρ(eᵢ ∧ fᵢ)`,  `yᵢ = indexHypercharge6 i / 6`,

where `ρ(eᵢ ∧ fᵢ) = nᵢ - 1/2` (the shifted number operator). Because the
weights are traceless (`Σᵢ indexHypercharge6 i = 0`, i.e.
`3·(-2) + 2·(+3) = 0`), the `-1/2` shifts cancel and `Y` acts on the Fock
basis state `basisSpinor S` with eigenvalue exactly the GUT-normalized
hypercharge `fockHypercharge S = fockHypercharge6 S / 6` of the trusted
module `PhysicsSM.StandardModel.SpinorFockHypercharge`. In particular:

- `Y` *kills* the vacuum (`ν^c` has `Y = 0`): it fixes the marked `ψ₁`;
- `Y` scales `weakSpinor` by `+1` (`e^c` has `Y = +1`): it preserves the
  projective `[ψ₂]` but *not* the marked `ψ₂`.

So `Y` is precisely an element of the pair stabilizer that the marked-pair
stabilizer misses, realizing the determinant `U(1)` of `S(U(2) × U(3))`
with the physical Standard Model hypercharges (which match
`OneGenerationTable` by the trusted `hypercharge_matches`).

## Dependencies and constraints

This file imports the *definition* `rho` from the draft module
`PhysicsSM.Draft.SpinorTenfoldSO10ActionAristotle`. The four sorried
theorems of that draft (`rho_intertwine`, `rho_bracket`,
`chevalleyPairing_rho_skew`, `gammaBilinear_rho_equivariant`) are owned by
a separate Aristotle job and MUST NOT be used here; everything below
reduces to the trusted basis-action layer of
`PhysicsSM.Spinor.SpinorTenfoldFock` (`wedge_basisSpinor_of_not_mem`,
`contract_basisSpinor_of_mem`, …) and the sign bookkeeping of
`PhysicsSM.Spinor.SpinorTenfoldCAR`. Run `#print axioms` on the finished
theorems and confirm no `sorryAx` enters through the import.

Do not change any definition or sign convention. Helper lemmas are
welcome.

This is draft code: the statements below contain documented `s o r r y`s and
must not be imported from trusted code until the holes are eliminated.
-/

noncomputable section

namespace PhysicsSM.Draft.SpinorTenfoldHyperchargeOp

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.SpinorTenfoldSO10Action
open PhysicsSM.StandardModel.SpinorFockHypercharge

/-! ## The hyperbolic basis vectors of `V10` -/

/-- The creation basis vector `e_i ∈ V10` (first hyperbolic half). -/
def eVec (i : Fin 5) : V10 := (Pi.single i 1, 0)

/-- The annihilation basis vector `f_i ∈ V10` (second hyperbolic half). -/
def fVec (i : Fin 5) : V10 := (0, Pi.single i 1)

/-- The Clifford action of `e_i` is the creation operator. -/
theorem cliffordAction_eVec (i : Fin 5) (ψ : FockSpinor) :
    cliffordAction (eVec i) ψ = wedge i ψ := by
  funext S
  simp only [cliffordAction, eVec, Pi.zero_apply, zero_mul,
    Finset.sum_const_zero, add_zero]
  rw [Finset.sum_eq_single i]
  · rw [Pi.single_eq_same, one_mul]
  · intro j _ hji
    rw [Pi.single_eq_of_ne hji, zero_mul]
  · intro h
    exact absurd (Finset.mem_univ i) h

/-- The Clifford action of `f_i` is the annihilation operator. -/
theorem cliffordAction_fVec (i : Fin 5) (ψ : FockSpinor) :
    cliffordAction (fVec i) ψ = contract i ψ := by
  funext S
  simp only [cliffordAction, fVec, Pi.zero_apply, zero_mul,
    Finset.sum_const_zero, zero_add]
  rw [Finset.sum_eq_single i]
  · rw [Pi.single_eq_same, one_mul]
  · intro j _ hji
    rw [Pi.single_eq_of_ne hji, zero_mul]
  · intro h
    exact absurd (Finset.mem_univ i) h

/-! ## The Cartan bivectors: shifted number operators -/

/-- Creating then annihilating index `i` (in the order `wedge ∘ contract`)
returns a basis monomial containing `i` unchanged. -/
theorem wedge_contract_basisSpinor_of_mem (i : Fin 5) (T : Finset (Fin 5))
    (h : i ∈ T) : wedge i (contract i (basisSpinor T)) = basisSpinor T := by
  rw [contract_basisSpinor_of_mem i T h, wedge_smul,
    wedge_basisSpinor_of_not_mem i (T.erase i) (Finset.notMem_erase i T),
    Finset.insert_erase h, smul_smul]
  rw [show opSign i (T.erase i) = opSign i T by
    unfold opSign; rw [belowCount_erase], opSign_mul_self, one_smul]

/-- Annihilating then creating index `i` (in the order `contract ∘ wedge`)
returns a basis monomial not containing `i` unchanged. -/
theorem contract_wedge_basisSpinor_of_not_mem (i : Fin 5) (T : Finset (Fin 5))
    (h : i ∉ T) : contract i (wedge i (basisSpinor T)) = basisSpinor T := by
  rw [wedge_basisSpinor_of_not_mem i T h, contract_smul,
    contract_basisSpinor_of_mem i (insert i T) (Finset.mem_insert_self i T),
    Finset.erase_insert h, smul_smul]
  rw [show opSign i (insert i T) = opSign i T by
    unfold opSign
    rw [← belowCount_erase i (insert i T), Finset.erase_insert h],
    opSign_mul_self, one_smul]

/-- **Target 1**: the Cartan bivector `ρ(e_i ∧ f_i)` acts on a Fock basis
state as the shifted number operator `n_i - 1/2`: eigenvalue `+1/2` when
`i` is occupied, `-1/2` when it is empty.

Proof route: expand `rho`, `cliffordAction_eVec`, `cliffordAction_fVec`,
then evaluate the two compositions `wedge i (contract i ·)` and
`contract i (wedge i ·)` on `basisSpinor T` with the basis-action lemmas;
the `opSign` factors square to `1` because `belowCount i` is unchanged by
inserting or erasing `i` itself. -/
theorem rho_eVec_fVec_basisSpinor (i : Fin 5) (T : Finset (Fin 5)) :
    rho (eVec i) (fVec i) (basisSpinor T)
      = (if i ∈ T then (2⁻¹ : ℂ) else -(2⁻¹ : ℂ)) • basisSpinor T := by
  unfold rho
  rw [cliffordAction_fVec, cliffordAction_eVec, cliffordAction_eVec,
    cliffordAction_fVec]
  by_cases h : i ∈ T
  · rw [wedge_contract_basisSpinor_of_mem i T h,
      wedge_basisSpinor_of_mem i T h, contract_zero, sub_zero, if_pos h]
  · rw [contract_basisSpinor_of_not_mem i T h, wedge_zero, zero_sub,
      contract_wedge_basisSpinor_of_not_mem i T h, smul_neg, if_neg h,
      neg_smul]

/-! ## The hypercharge generator -/

/-- The hypercharge weight of the Fock index `i` as a complex scalar:
`indexHypercharge6 i / 6` (GUT normalization, so color indices weigh
`-1/3` and weak indices `+1/2`). -/
def hyperchargeCoeff (i : Fin 5) : ℂ := ((indexHypercharge6 i : ℤ) : ℂ) / 6

/-- **The hypercharge generator** `Y = Σᵢ yᵢ ρ(eᵢ ∧ fᵢ)`: the explicit
element of the infinitesimal `so(10)` action realizing the physical
hypercharge on the `16`. It lies in the span of the `ρ` bivectors by
construction. -/
def hyperchargeOp (ψ : FockSpinor) : FockSpinor :=
  ∑ i : Fin 5, hyperchargeCoeff i • rho (eVec i) (fVec i) ψ

/-- The hypercharge weights are traceless: `3·(-2) + 2·(+3) = 0`. This is
what makes the `-1/2` shifts in the number operators cancel. -/
theorem indexHypercharge6_sum_zero : ∑ i : Fin 5, indexHypercharge6 i = 0 := by
  decide

/-- **Target 2 (the main theorem)**: `Y` acts on the Fock basis state
`basisSpinor S` with eigenvalue the physical GUT-normalized hypercharge
`fockHypercharge6 S / 6`.

Proof route: expand `hyperchargeOp` with Target 1; the eigenvalue is
`Σ_{i ∈ S} yᵢ/2 - Σ_{i ∉ S} yᵢ/2 = Σ_{i ∈ S} yᵢ - (1/2) Σᵢ yᵢ`, and the
second term vanishes by `indexHypercharge6_sum_zero`. -/
theorem hyperchargeOp_basisSpinor (S : Finset (Fin 5)) :
    hyperchargeOp (basisSpinor S)
      = (((fockHypercharge6 S : ℤ) : ℂ) / 6) • basisSpinor S := by
  unfold hyperchargeOp
  have hterm : ∀ i : Fin 5,
      hyperchargeCoeff i • rho (eVec i) (fVec i) (basisSpinor S)
        = (hyperchargeCoeff i * (if i ∈ S then (2⁻¹ : ℂ) else -(2⁻¹ : ℂ)))
            • basisSpinor S := by
    intro i
    rw [rho_eVec_fVec_basisSpinor, smul_smul]
  rw [Finset.sum_congr rfl (fun i _ => hterm i), ← Finset.sum_smul]
  congr 1
  simp only [hyperchargeCoeff]
  -- Reduce to the traceless cancellation identity.
  have hA : (∑ i ∈ S, ((indexHypercharge6 i : ℤ) : ℂ))
      = ((fockHypercharge6 S : ℤ) : ℂ) := by
    rw [fockHypercharge6]; push_cast; rfl
  have hAB : (∑ i ∈ S, ((indexHypercharge6 i : ℤ) : ℂ))
      + (∑ i ∈ Sᶜ, ((indexHypercharge6 i : ℤ) : ℂ)) = 0 := by
    rw [Finset.sum_add_sum_compl, ← Int.cast_sum, indexHypercharge6_sum_zero,
      Int.cast_zero]
  rw [← Finset.sum_add_sum_compl S]
  have hS : ∀ i ∈ S,
      (((indexHypercharge6 i : ℤ) : ℂ) / 6)
          * (if i ∈ S then (2⁻¹ : ℂ) else -(2⁻¹ : ℂ))
        = ((indexHypercharge6 i : ℤ) : ℂ) * (2⁻¹ / 6) := by
    intro i hi; rw [if_pos hi]; ring
  have hSc : ∀ i ∈ Sᶜ,
      (((indexHypercharge6 i : ℤ) : ℂ) / 6)
          * (if i ∈ S then (2⁻¹ : ℂ) else -(2⁻¹ : ℂ))
        = ((indexHypercharge6 i : ℤ) : ℂ) * (-(2⁻¹) / 6) := by
    intro i hi; rw [if_neg (Finset.mem_compl.mp hi)]; ring
  rw [Finset.sum_congr rfl hS, Finset.sum_congr rfl hSc, ← Finset.sum_mul,
    ← Finset.sum_mul, eq_neg_of_add_eq_zero_right hAB, hA]
  ring

/-! ## Consequences: the marked/projective distinction -/

/-- **Target 3**: `Y` kills the vacuum: the hypercharge generator fixes the
*marked* first spinor of the Krasnov pair (`ν^c` has `Y = 0`). -/
theorem hyperchargeOp_vacuumSpinor : hyperchargeOp vacuumSpinor = 0 := by
  have h0 : fockHypercharge6 (∅ : Finset (Fin 5)) = 0 := by
    simp [fockHypercharge6]
  rw [show vacuumSpinor = basisSpinor ∅ from rfl, hyperchargeOp_basisSpinor, h0]
  simp

/-- **Target 4**: `Y` scales `weakSpinor` by `+1` (`e^c` has `Y = +1`): it
preserves the projective class `[ψ₂]` while moving the marked `ψ₂`. This is
the infinitesimal witness that the mixed marked/projective stabilizer is
strictly larger than the marked-pair stabilizer, and that the extra
direction carries hypercharge `+1` — the positron charge. -/
theorem hyperchargeOp_weakSpinor : hyperchargeOp weakSpinor = weakSpinor := by
  rw [show weakSpinor = basisSpinor ({3, 4} : Finset (Fin 5)) from rfl,
    hyperchargeOp_basisSpinor, fockHypercharge6_weak,
    show ((6 : ℤ) : ℂ) / 6 = 1 by norm_num, one_smul]

/-- `Y` does not kill `weakSpinor`: the extra stabilizer direction acts
nontrivially on the marked second spinor. Follows from Target 4 and
`basisSpinor_ne_zero`. -/
theorem hyperchargeOp_weakSpinor_ne_zero : hyperchargeOp weakSpinor ≠ 0 := by
  rw [hyperchargeOp_weakSpinor]
  exact basisSpinor_ne_zero _

end PhysicsSM.Draft.SpinorTenfoldHyperchargeOp

end
