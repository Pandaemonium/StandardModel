import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldCliffordGroup
import PhysicsSM.Spinor.SpinorTenfoldPurity

/-!
# Spinor.SpinorTenfoldBasisOrbit

Aristotle handoff: mode-flip action on basis spinors and **marked
transitivity** of the even Clifford group on the even wedge-monomial basis
- the normal-form core of Lemma S1 (orbit transitivity) of
`Sources/Spin10_stabilizer.txt`.

## Mathematical intent

The hyperbolic mode-flip unit `flipUnit i` (the Clifford operator of
`e_i + f_i`, `Q10 = 1`) toggles the occupation of mode `i` on a basis
spinor, with the fermionic sign `opSign i T`:

  `gammaEnd (flipVec i) (basisSpinor T) = opSign i T • basisSpinor (flipSet i T)`.

A *product of two* flips lies in `evenCliffordGroup` and toggles two modes,
staying inside one chirality. Since any two even subsets of `{0,...,4}` are
connected by toggling pairs of indices, the even Clifford group acts
transitively on even basis spinors up to a nonzero scalar - and using
`scalarUnit` (every nonzero scalar is in the group) the scalar can be fixed
to `1`: **marked** transitivity, not merely projective. The anchor
corollary carries the marked vacuum to the weak spinor - the two components
of the Krasnov-pair normal form whose common annihilator is the trusted
color axis.

## Proof guidance

- `cliffordAction_flipVec`: unfold `cliffordAction`; both index sums
  collapse at `j = i` (`flipVec` is an indicator pair;
  `Finset.sum_ite_eq'` or `Finset.sum_eq_single i`).
- `gammaEnd_flipVec_basisSpinor`: case on `i ∈ T`. For `i ∉ T`:
  `wedge_basisSpinor_of_not_mem` gives `opSign i (insert i T)` and
  `contract_basisSpinor_of_not_mem` kills the other half; then
  `belowCount i (insert i T) = belowCount i T` because
  `(insert i T).erase i = T` (`Finset.erase_insert`) and `belowCount`
  ignores `i` itself (`belowCount_erase`). For `i ∈ T`: dually with
  `contract_basisSpinor_of_mem` / `wedge_basisSpinor_of_mem` and
  `belowCount_erase`.
- `exists_evenCliffordGroup_smul_basisSpinor`: two workable routes.
  (a) Strong induction on `(symmDiff S T).card` (which is even, `0`, `2`,
  or `4`): if `S = T` take `g = 1`; otherwise pick `i ≠ j` in the symmetric
  difference and apply `flipUnit i * flipUnit j`
  (`flipUnit_mul_flipUnit_mem`, `flipUnit_mul_flipUnit_basisSpinor`), which
  reduces the symmetric difference by two; compose witnesses with `mul_mem`
  and track the accumulated nonzero scalar.
  (b) Concrete enumeration: show every even `S` reaches `basisSpinor ∅` by
  an explicit product of at most two double-flips (there are only 16 even
  subsets; each is `∅`, a pair, or a 4-set, handled by one or two
  double-flips with explicit indices), then route `S → ∅ → T` through the
  group operations (`mul_mem`, `inv_mem`) and invert the scalar.
  Route (a) is cleaner; route (b) is fully mechanical.
- The marked refinement and the vacuum-to-weak anchor are already derived
  below from the up-to-scalar statement via `scalarUnit`; only the three
  `s o r r y`s above them are open.

Do not change any definition or sign convention of
`PhysicsSM.Spinor.SpinorTenfoldCliffordGroup` or the trusted Fock layer.
Helper lemmas are welcome (e.g. sign bookkeeping for double flips,
`flipSet` cardinality facts). Plain kernel `decide` on `Finset (Fin 5)`
bookkeeping is fine. No `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, `u n s a f e`, and
**no `n a t i v e _ d e c i d e`** in the final state.

This is draft code: the statements below contain documented `s o r r y`s and
must not be imported from trusted code until the holes are eliminated.
-/

noncomputable section

namespace PhysicsSM.Spinor.SpinorTenfold

open PhysicsSM.Spinor.SpinorTenfold

/-! ## Target 1: the Clifford action of a mode-flip vector -/

/-- The Clifford action of `flipVec i` is creation plus annihilation at the
single index `i`. -/
theorem cliffordAction_flipVec (i : Fin 5) (psi : FockSpinor) :
    cliffordAction (flipVec i) psi = wedge i psi + contract i psi := by
  unfold cliffordAction;
  ext S; simp_all +decide [ Fin.sum_univ_succ, flipVec ] ;

/-! ## Target 2: mode flips toggle basis spinors with the fermionic sign -/

/-- A mode flip toggles the occupation of mode `i` on a wedge monomial,
with the uniform fermionic sign `opSign i T` (the sign does not depend on
whether `i` is being created or annihilated, because `belowCount` ignores
`i` itself). -/
theorem gammaEnd_flipVec_basisSpinor (i : Fin 5) (T : Finset (Fin 5)) :
    gammaEnd (flipVec i) (basisSpinor T)
      = opSign i T • basisSpinor (flipSet i T) := by
  unfold flipSet gammaEnd opSign
  simp [cliffordAction_flipVec];
  split_ifs <;> simp_all +decide [ wedge_basisSpinor_of_not_mem, wedge_basisSpinor_of_mem, contract_basisSpinor_of_mem, contract_basisSpinor_of_not_mem ];
  · rw [ opSign, belowCount_erase ];
  · simp +decide [ belowCount, opSign ];
    rw [ Finset.filter_insert ] ; aesop

/-- A double flip toggles two modes; multiplication in `Module.End` is
composition, so `flipUnit j` acts first. -/
theorem flipUnit_mul_flipUnit_basisSpinor (i j : Fin 5) (T : Finset (Fin 5)) :
    ((flipUnit i * flipUnit j : (Module.End ℂ FockSpinor)ˣ) :
        Module.End ℂ FockSpinor) (basisSpinor T)
      = (opSign j T * opSign i (flipSet j T))
          • basisSpinor (flipSet i (flipSet j T)) := by
  have := @gammaEnd_flipVec_basisSpinor;
  simp_all +decide [ mul_comm, smul_smul ]

/-! ## Target 3: transitivity on even basis spinors, up to a scalar -/

/-- The fermionic ordering sign is a nonzero scalar (it is `±1`). -/
lemma opSign_ne_zero (i : Fin 5) (S : Finset (Fin 5)) : opSign i S ≠ 0 :=
  pow_ne_zero _ (by norm_num)

/-- Every even basis spinor can be carried to a nonzero multiple of the
vacuum `basisSpinor ∅` by an element of the even Clifford group, by
repeatedly removing pairs of occupied modes with double flips. Stated with
a cardinality bound `n` to allow induction. -/
lemma exists_evenCliffordGroup_smul_basisSpinor_empty (n : ℕ)
    (S : Finset (Fin 5)) (hn : S.card ≤ n) (hpar : S.card % 2 = 0) :
    ∃ g ∈ evenCliffordGroup, ∃ c : ℂ, c ≠ 0 ∧
      (g : Module.End ℂ FockSpinor) (basisSpinor S) = c • basisSpinor ∅ := by
  induction' n with n ih generalizing S;
  · refine' ⟨ 1, _, 1, _, _ ⟩ <;> aesop_cat;
  · by_cases hS : S = ∅;
    · exact ⟨ 1, Subgroup.one_mem _, 1, one_ne_zero, by aesop ⟩;
    · have hcard : 1 < S.card :=
        lt_of_le_of_ne (Finset.card_pos.2 (Finset.nonempty_of_ne_empty hS))
          (Ne.symm (by aesop))
      obtain ⟨i, j, hij, hi, hj⟩ : ∃ i j : Fin 5, i ≠ j ∧ i ∈ S ∧ j ∈ S :=
        Exists.imp (by aesop) (Finset.one_lt_card.1 hcard)
      obtain ⟨g1, hg1, c1, hc1, hg1⟩ :
          ∃ g1 ∈ evenCliffordGroup, ∃ c1 : ℂ, c1 ≠ 0 ∧
            (g1 : Module.End ℂ FockSpinor)
                (basisSpinor (flipSet i (flipSet j S))) = c1 • basisSpinor ∅ := by
        apply ih;
        · unfold flipSet; simp +decide [ *, Finset.card_erase_of_mem ] ;
          linarith;
        · unfold flipSet; simp +decide [ *, Finset.card_erase_of_mem ] ;
          omega;
      refine' ⟨ g1 * ( flipUnit i * flipUnit j ), _, _ ⟩;
      · exact Subgroup.mul_mem _ ‹_› ( flipUnit_mul_flipUnit_mem i j );
      · refine' ⟨ opSign j S * opSign i ( flipSet j S ) * c1, _, _ ⟩ <;>
          simp_all +decide [ mul_assoc, mul_left_comm, mul_comm ];
        · exact ⟨ opSign_ne_zero _ _, opSign_ne_zero _ _ ⟩;
        · convert congr_arg ( fun x => ( opSign j S * opSign i ( flipSet j S ) ) • x ) hg1 using 1;
          · rw [ ← map_smul ];
            congr! 1;
            convert flipUnit_mul_flipUnit_basisSpinor i j S using 1;
          · simp +decide [ mul_assoc, mul_comm, mul_left_comm, smul_smul ]

/-- **Up-to-scalar orbit transitivity** on the even basis: for any two
even-cardinality subsets, some even-Clifford-group element carries
`basisSpinor S` to a nonzero multiple of `basisSpinor T`. -/
theorem exists_evenCliffordGroup_smul_basisSpinor (S T : Finset (Fin 5))
    (hS : S.card % 2 = 0) (hT : T.card % 2 = 0) :
    ∃ g ∈ evenCliffordGroup, ∃ c : ℂ, c ≠ 0 ∧
      (g : Module.End ℂ FockSpinor) (basisSpinor S) = c • basisSpinor T := by
  obtain ⟨gS, hgS, cS, hcS, hSeq⟩ :=
    exists_evenCliffordGroup_smul_basisSpinor_empty S.card S le_rfl hS
  obtain ⟨gT, hgT, cT, hcT, hTeq⟩ :=
    exists_evenCliffordGroup_smul_basisSpinor_empty T.card T le_rfl hT
  have hinv : ((gT⁻¹ : (Module.End ℂ FockSpinor)ˣ) : Module.End ℂ FockSpinor)
      (basisSpinor ∅) = cT⁻¹ • basisSpinor T := by
    have h1 : ((gT⁻¹ : (Module.End ℂ FockSpinor)ˣ) : Module.End ℂ FockSpinor)
        ((gT : Module.End ℂ FockSpinor) (basisSpinor T)) = basisSpinor T :=
      congr_arg (fun f : Module.End ℂ FockSpinor => f (basisSpinor T)) (Units.inv_mul gT)
    rw [hTeq, map_smul] at h1
    rw [← h1, smul_smul, inv_mul_cancel₀ hcT, one_smul]
  refine ⟨gT⁻¹ * gS, mul_mem (inv_mem hgT) hgS, cS * cT⁻¹,
    mul_ne_zero hcS (inv_ne_zero hcT), ?_⟩
  rw [Units.val_mul, Module.End.mul_apply, hSeq, map_smul, hinv, smul_smul]

/-! ## Derived: marked transitivity (complete modulo the targets above) -/

/-- **Marked transitivity** on the even basis: the scalar can be fixed to
`1` using `scalarUnit`. This is the normal-form core of Lemma S1. -/
theorem exists_evenCliffordGroup_basisSpinor (S T : Finset (Fin 5))
    (hS : S.card % 2 = 0) (hT : T.card % 2 = 0) :
    ∃ g ∈ evenCliffordGroup,
      (g : Module.End ℂ FockSpinor) (basisSpinor S) = basisSpinor T := by
  obtain ⟨g, hg, c, hc, hgc⟩ :=
    exists_evenCliffordGroup_smul_basisSpinor S T hS hT
  refine ⟨scalarUnit c⁻¹ (inv_ne_zero hc) * g,
    mul_mem (scalarUnit_mem _ _) hg, ?_⟩
  rw [Units.val_mul, Module.End.mul_apply, hgc, map_smul, scalarUnit_val]
  simp [smul_smul, mul_inv_cancel₀ hc]

/-- **Anchor**: some even-Clifford-group element carries the marked vacuum
exactly to the weak spinor - the two members of the witness Krasnov pair
whose common annihilator is the trusted color axis
(`PhysicsSM.Spinor.SpinorTenfoldColorAxis`). -/
theorem exists_evenCliffordGroup_vacuum_weak :
    ∃ g ∈ evenCliffordGroup,
      (g : Module.End ℂ FockSpinor) vacuumSpinor = weakSpinor := by
  have h := exists_evenCliffordGroup_basisSpinor ∅ ({3, 4} : Finset (Fin 5))
    (by decide) (by decide)
  simpa [vacuumSpinor, weakSpinor] using h

end PhysicsSM.Spinor.SpinorTenfold

end
