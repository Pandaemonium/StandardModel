import PhysicsSM.Draft.NullEdge.WeakIsospinChiralityProjector
import PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2Aristotle

open Matrix Complex
open scoped Matrix ComplexConjugate

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# Weak-mode fermion parity and chirality

In the two-mode finite Fock model below, the chirality grading **is the
fermion-parity grading of the weak modes; it is not an independent input**.
The weak `su(2)` bilinears conserve weak-mode number, and consequently commute
with this grading.  Their action decomposes as `1 ⊕ 2 ⊕ 1`, with the two
one-dimensional even-number sectors carrying the trivial action.

This algebraic result does **not** derive that weak-mode fermion parity is
spacetime handedness; that identification remains a supplied physical input.
In particular, no claim that this derives parity violation is made here.

The definitions `B1`, `B2`, `T3`, `TPlus`, `T1`, and `chi` below are aliases
of the repository's already-landed weak-isospin and chirality declarations.
Consequently the parity theorem closes the previous prose-only join on the live
model rather than proving the statement for a parallel copy.

Provenance: Furey, arXiv:1806.00612, motivates the two-mode Fock realization
and automatic single-chirality weak action; Todorov, arXiv:2206.06912, gives a
related chirality-as-charge-parity statement.  The explicit polynomial bridge,
number-conservation derivation, sector census, and sharpness controls were
completed in Aristotle project `8a4e09a4-d278-4ba1-9503-5d26412266c5`.

Draft-trust status: all declarations are kernel-checked.  The build-enforced
footprint is pinned in `WeakFermionParityChiralityAxiomGuard`.
-/

namespace PhysicsSM.Draft.NullEdge.WeakFermionParityChirality

abbrev C := ℂ
abbrev FockMatrix := Matrix (Fin 4) (Fin 4) C
abbrev FockVector := Fin 4 → C

noncomputable def B1 : FockMatrix :=
  !![0, 1, 0, 0; 0, 0, 0, 0; 0, 0, 0, 1; 0, 0, 0, 0]

noncomputable def B2 : FockMatrix :=
  !![0, 0, 1, 0; 0, 0, 0, -1; 0, 0, 0, 0; 0, 0, 0, 0]

noncomputable def T3 : FockMatrix := B1ᴴ * B1 - B2ᴴ * B2
noncomputable def TPlus : FockMatrix := B1ᴴ * B2
noncomputable def T1 : FockMatrix := B1ᴴ * B2 + B2ᴴ * B1
noncomputable def Nop : FockMatrix := B1ᴴ * B1 + B2ᴴ * B2

noncomputable def chi : FockMatrix :=
  !![-1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, -1]

noncomputable def PL : FockMatrix := (1 / 2 : C) • (1 + chi)
noncomputable def PR : FockMatrix := (1 / 2 : C) • (1 - chi)

noncomputable def ket00 : FockVector := ![1, 0, 0, 0]
noncomputable def ket10 : FockVector := ![0, 1, 0, 0]
noncomputable def ket01 : FockVector := ![0, 0, 1, 0]
noncomputable def ket11 : FockVector := ![0, 0, 0, 1]

/-
The weak-mode number operator has spectrum `0,1,1,2` in the ordered basis.
-/
theorem number_operator_eq_diagonal :
    Nop = Matrix.diagonal ![(0 : C), 1, 1, 2] := by
  unfold Nop B1 B2;
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ]

/-
The chirality grading **is the fermion-parity grading of the weak modes; it is
not an independent input**: on the spectrum `0,1,2`, the parity polynomial is
`2n² - 4n + 1`, and `chi` is its negative.
-/
theorem chirality_eq_neg_fermion_parity :
    chi = -(2 • Nop * Nop - 4 • Nop + 1) := by
  -- By definition of $Nop$, we know that $Nop = \text{diag}(0, 1, 1, 2)$.
  have hNop : Nop = Matrix.diagonal ![(0 : ℂ), 1, 1, 2] := by
    exact number_operator_eq_diagonal
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ hNop ] ;
  all_goals norm_num [ show ( 4 : Matrix ( Fin 4 ) ( Fin 4 ) ℂ ) = Matrix.diagonal ( fun i => if i = 0 then 4 else if i = 1 then 4 else if i = 2 then 4 else 4 ) by ext i j; fin_cases i <;> fin_cases j <;> rfl, show ( 2 : Matrix ( Fin 4 ) ( Fin 4 ) ℂ ) = Matrix.diagonal ( fun i => if i = 0 then 2 else if i = 1 then 2 else if i = 2 then 2 else 2 ) by ext i j; fin_cases i <;> fin_cases j <;> rfl, chi ] ;
  all_goals simp +decide [ Matrix.diagonal ] ;

/-
The third generator conserves weak-mode number.
-/
theorem T3_commutes_number : T3 * Nop = Nop * T3 := by
  unfold T3 Nop B1 B2;
  ext i j; norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] ;
  fin_cases i <;> fin_cases j <;> norm_num

/-
The raising generator conserves weak-mode number.
-/
theorem TPlus_commutes_number : TPlus * Nop = Nop * TPlus := by
  unfold TPlus;
  unfold B1 B2 Nop;
  unfold B1 B2; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] ;

/-
The first Hermitian generator conserves weak-mode number.
-/
theorem T1_commutes_number : T1 * Nop = Nop * T1 := by
  unfold T1 Nop B1 B2;
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] ;

/-
The lowering generator conserves weak-mode number.
-/
theorem TPlus_conjTranspose_commutes_number :
    TPlusᴴ * Nop = Nop * TPlusᴴ := by
  unfold TPlus Nop;
  unfold B1 B2; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] ;

/-
Commutation with number forces commutation with its parity polynomial.
This is the non-computational bridge from number conservation to chirality.
-/
theorem commutes_chi_of_commutes_number (T : FockMatrix)
    (hT : T * Nop = Nop * T) : T * chi = chi * T := by
  rw [ chirality_eq_neg_fermion_parity ];
  simp +decide [ mul_add, add_mul, mul_sub, sub_mul, mul_assoc, hT ];
  simp +decide [ ← mul_assoc, ← hT ];
  grind +suggestions

/-
The chirality matrix is an involution.
-/
theorem chi_sq : chi * chi = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ chi ] ;

/-
An operator commuting with `chi` has no off-diagonal chiral block.
-/
theorem chiral_cross_blocks_zero_of_commutes (T : FockMatrix)
    (hT : T * chi = chi * T) :
    PL * T * PR = 0 ∧ PR * T * PL = 0 := by
  -- Expand PL and PR using their definitions.
  simp [PL, PR];
  simp_all +decide [ mul_add, add_mul, mul_sub, sub_mul, ← mul_assoc ];
  simp_all +decide [ mul_assoc, ← eq_sub_iff_add_eq' ];
  simp_all +decide [ ← mul_assoc, chi_sq ];
  exact ⟨ by abel1, by rw [ ← smul_neg, neg_sub ] ⟩

/-
Number conservation alone forces both off-diagonal chiral blocks to vanish.
-/
theorem chiral_cross_blocks_zero_of_number_conservation (T : FockMatrix)
    (hT : T * Nop = Nop * T) :
    PL * T * PR = 0 ∧ PR * T * PL = 0 := by
  convert chiral_cross_blocks_zero_of_commutes T ( commutes_chi_of_commutes_number T hT ) using 1

/-- `T3` preserves chirality, deduced from number conservation and parity. -/
theorem T3_commutes_chi : T3 * chi = chi * T3 := by
  exact commutes_chi_of_commutes_number T3 T3_commutes_number

/-- `T+` preserves chirality, deduced from number conservation and parity. -/
theorem TPlus_commutes_chi : TPlus * chi = chi * TPlus := by
  exact commutes_chi_of_commutes_number TPlus TPlus_commutes_number

/-- `T- = T+ᴴ` preserves chirality, deduced from number conservation and parity. -/
theorem TPlus_conjTranspose_commutes_chi : TPlusᴴ * chi = chi * TPlusᴴ := by
  exact commutes_chi_of_commutes_number TPlusᴴ TPlus_conjTranspose_commutes_number

/-- `T1` preserves chirality, deduced from number conservation and parity. -/
theorem T1_commutes_chi : T1 * chi = chi * T1 := by
  exact commutes_chi_of_commutes_number T1 T1_commutes_number

/-
All four generators have zero cross-chiral blocks, by number conservation.
-/
theorem generators_cross_blocks_zero :
    (PL * T3 * PR = 0 ∧ PR * T3 * PL = 0) ∧
    (PL * TPlus * PR = 0 ∧ PR * TPlus * PL = 0) ∧
    (PL * TPlusᴴ * PR = 0 ∧ PR * TPlusᴴ * PL = 0) ∧
    (PL * T1 * PR = 0 ∧ PR * T1 * PL = 0) := by
  exact ⟨ chiral_cross_blocks_zero_of_number_conservation _ T3_commutes_number, chiral_cross_blocks_zero_of_number_conservation _ TPlus_commutes_number, chiral_cross_blocks_zero_of_number_conservation _ TPlus_conjTranspose_commutes_number, chiral_cross_blocks_zero_of_number_conservation _ T1_commutes_number ⟩

/-
The even-parity/right-handed sector is a singlet for `T3`.
-/
theorem T3_right_singlet : T3 * PR = 0 ∧ PR * T3 = 0 := by
  unfold T3 PR;
  simp +decide [ B1, B2, chi ];
  constructor <;> ext i j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ]; all_goals fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.one_apply ]

/-
The even-parity/right-handed sector is a singlet for `T+`.
-/
theorem TPlus_right_singlet : TPlus * PR = 0 ∧ PR * TPlus = 0 := by
  unfold TPlus PR;
  unfold B1 B2 chi;
  constructor <;> ext i j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ];
  · fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.one_apply ];
  · fin_cases i <;> fin_cases j <;> norm_num [ Fin.ext_iff, Matrix.one_apply ]

/-
The even-parity/right-handed sector is a singlet for `T-`.
-/
theorem TPlus_conjTranspose_right_singlet :
    TPlusᴴ * PR = 0 ∧ PR * TPlusᴴ = 0 := by
  unfold TPlus PR;
  unfold B1 B2 chi; norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] ;
  simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply, Fin.sum_univ_succ ]

/-
The even-parity/right-handed sector is a singlet for `T1`.
-/
theorem T1_right_singlet : T1 * PR = 0 ∧ PR * T1 = 0 := by
  unfold T1 PR;
  simp +decide [ B1, B2, chi ];
  simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply, Fin.sum_univ_succ ] at *

/-
Singlet annihilation is equivalent here to support entirely in the left block.
-/
theorem generators_left_block :
    T3 = PL * T3 * PL ∧ TPlus = PL * TPlus * PL ∧
    TPlusᴴ = PL * TPlusᴴ * PL ∧ T1 = PL * T1 * PL := by
  unfold T3 TPlus T1 PL;
  simp [B1, B2, chi];
  simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply, Fin.sum_univ_succ ] at *;
  norm_num

/-
A number-conserving matrix preserves every number eigenspace.
-/
theorem number_eigenspace_invariant (A : FockMatrix)
    (hA : A * Nop = Nop * A) (n : C) (v : FockVector)
    (hv : Nop *ᵥ v = n • v) : Nop *ᵥ (A *ᵥ v) = n • (A *ᵥ v) := by
  convert congr_arg ( fun x => A.mulVec x ) hv using 1 <;> simp +decide [ Matrix.mulVec_smul, Matrix.mulVec_mulVec, hA ]

/-
The zero-particle eigenspace is exactly the one-dimensional span of `|00⟩`.
-/
theorem number_zero_eigenspace_one_dim (v : FockVector) :
    Nop *ᵥ v = 0 ↔ ∃ c : C, v = c • ket00 := by
  constructor;
  · intro hv
    have h_zero : v 1 = 0 ∧ v 2 = 0 ∧ v 3 = 0 := by
      have h_zero : Nop = Matrix.diagonal ![0, 1, 1, 2] := by
        exact number_operator_eq_diagonal
      simp_all +decide [ funext_iff, Fin.forall_fin_succ ];
      simp_all +decide [ Matrix.mulVec ];
    use v 0;
    ext i; fin_cases i <;> simp +decide [ *, ket00 ] ;
  · rintro ⟨ c, rfl ⟩;
    convert congr_arg ( fun x : FockMatrix => x *ᵥ c • ket00 ) ( number_operator_eq_diagonal ) using 1;
    ext i ; fin_cases i <;> simp +decide [ ket00 ]; all_goals simp +decide [ Matrix.mulVec ]

/-
The two-particle eigenspace is exactly the one-dimensional span of `|11⟩`.
-/
theorem number_two_eigenspace_one_dim (v : FockVector) :
    Nop *ᵥ v = (2 : C) • v ↔ ∃ c : C, v = c • ket11 := by
  rw [ show Nop = Matrix.diagonal ![0, 1, 1, 2] from _ ];
  · simp +decide [ funext_iff, Fin.forall_fin_succ, Matrix.mulVec, dotProduct ];
    simp +decide [ Fin.sum_univ_succ, ket11 ];
    grind;
  · exact number_operator_eq_diagonal

/-
The one-particle eigenspace is exactly the two-dimensional middle sector.
-/
theorem number_one_eigenspace_two_dim (v : FockVector) :
    Nop *ᵥ v = v ↔ ∃ a b : C, v = a • ket10 + b • ket01 := by
  norm_num [ ← List.ofFn_inj, ket10, ket01, Nop ];
  simp +decide [ B1, B2, Matrix.mulVec ];
  simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ, dotProduct ];
  grind

/-
The negative-chirality sector is the sum of the two even-number lines.
-/
theorem chi_negative_sector (v : FockVector) :
    chi *ᵥ v = -v ↔
      ∃ a b : C, v = a • ket00 + b • ket11 := by
  constructor;
  · intro hv
    unfold chi at hv;
    simp_all +decide [ ← List.ofFn_inj, Matrix.mulVec ];
    unfold ket00 ket11; norm_num [ vecHead, vecTail ] at *;
    simp_all +decide [ eq_neg_iff_add_eq_zero ];
  · rintro ⟨ a, b, rfl ⟩;
    unfold chi ket00 ket11;
    ext i; fin_cases i <;> norm_num [ Matrix.mulVec ] ;

/-
The positive-chirality sector is the two-dimensional one-particle sector.
-/
theorem chi_positive_sector (v : FockVector) :
    chi *ᵥ v = v ↔ ∃ a b : C, v = a • ket10 + b • ket01 := by
  constructor <;> intro h;
  · unfold chi at h;
    simp_all +decide [ ← List.ofFn_inj, Matrix.mulVec ];
    unfold ket10 ket01; simp_all +decide [ vecHead, vecTail ] ;
    grind;
  · obtain ⟨ a, b, rfl ⟩ := h;
    unfold chi ket10 ket01;
    ext i; fin_cases i <;> norm_num [ Matrix.mulVec ] ;

/-
The number-zero and number-two lines carry the trivial weak action.
-/
theorem even_number_sectors_trivial (v : FockVector)
    (hv : Nop *ᵥ v = 0 ∨ Nop *ᵥ v = (2 : C) • v) :
    T3 *ᵥ v = 0 ∧ TPlus *ᵥ v = 0 ∧ TPlusᴴ *ᵥ v = 0 := by
  rcases hv with ( hv | hv );
  · -- By number_zero_eigenspace_one_dim, there exists a scalar $c$ such that $v = c • ket00$.
    obtain ⟨c, hc⟩ : ∃ c : C, v = c • ket00 := by
      exact number_zero_eigenspace_one_dim v |>.1 hv;
    unfold T3 TPlus; norm_num [ hc, Matrix.mulVec ] ; ring;
    unfold B1 B2; norm_num [ Matrix.mulVec, ← List.ofFn_inj ] ;
    simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ, dotProduct, ket00 ];
  · -- By number_two_eigenspace_one_dim, there exists a scalar $c$ such that $v = c • ket11$.
    obtain ⟨c, hc⟩ : ∃ c : C, v = c • ket11 := by
      exact (number_two_eigenspace_one_dim v).mp hv
    simp_all +decide [ Matrix.mulVec_smul ];
    unfold T3 TPlus; norm_num [ Matrix.mulVec ] ;
    unfold B1 B2; norm_num [ Matrix.mulVec, ← List.ofFn_inj ] ;
    simp +decide [ Matrix.mul_apply, dotProduct, Fin.sum_univ_succ, ket11 ]

/-
Structural `1 ⊕ 2 ⊕ 1` content: the `chi = -1` sector consists precisely of
the one-dimensional number-`0` and number-`2` sectors, both annihilated by the
three `su(2)` generators, while the number-`1` sector is the two-dimensional
`chi = +1` sector.  Thus the singlets and doublet are conclusions of the finite
Fock construction, not assumptions.
-/
theorem one_plus_two_plus_one_content :
    (∀ v : FockVector, chi *ᵥ v = -v ↔
      ∃ a b : C, v = a • ket00 + b • ket11) ∧
    (∀ v : FockVector, chi *ᵥ v = v ↔
      ∃ a b : C, v = a • ket10 + b • ket01) ∧
    (∀ v : FockVector,
      (Nop *ᵥ v = 0 ∨ Nop *ᵥ v = (2 : C) • v) →
      T3 *ᵥ v = 0 ∧ TPlus *ᵥ v = 0 ∧ TPlusᴴ *ᵥ v = 0) := by
  refine' ⟨ _, _, _ ⟩;
  · convert chi_negative_sector;
  · convert chi_positive_sector;
  · convert even_number_sectors_trivial using 1

/-
`B1` has an odd part: it sends `|11⟩` to `|01⟩`.
-/
theorem B1_maps_ket11_to_ket01 : B1 *ᵥ ket11 = ket01 := by
  unfold B1 ket11 ket01;
  ext i; fin_cases i <;> norm_num [ Matrix.mulVec ] ;

/-
Sharpness: `B1` connects the right sector to the left sector.
-/
theorem B1_right_action_nonzero : B1 * PR ≠ 0 := by
  unfold B1 PR;
  unfold chi;
  intro h; have := congr_fun ( congr_fun h 2 ) 3; norm_num [ Matrix.mul_apply ] at this;
  simp +decide [ Fin.sum_univ_succ, Matrix.one_apply ] at this

/-
Sharpness: the odd operator `B1` fails both number and chirality conservation.
-/
theorem B1_not_number_conserving_and_not_chirality_conserving :
    B1 * Nop ≠ Nop * B1 ∧ B1 * chi ≠ chi * B1 := by
  unfold Nop chi;
  constructor <;> intro h <;> have := congr_fun ( congr_fun h 0 ) 1 <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] at this;
  · simp +decide [ B1, B2 ] at this;
  · unfold B1 at this ; norm_num at this

/-! ## Bridges to the previously landed live weak-isospin declarations -/

/-- The number operator built from the repository's live weak ladders. -/
noncomputable def liveNumberOperator : FockMatrix :=
  PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.B1ᴴ *
      PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.B1 +
    PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.B2ᴴ *
      PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.B2

/-- The live chirality declaration is exactly minus the weak-mode fermion
parity polynomial of the live number operator.  This closes the former
prose-only join rather than establishing the identity for an unrelated copy. -/
theorem live_chirality_eq_neg_fermion_parity :
    PhysicsSM.Draft.NullEdge.WeakIsospinChiralityProjector.chirality =
      -(2 • liveNumberOperator * liveNumberOperator -
        4 • liveNumberOperator + 1) := by
  exact chirality_eq_neg_fermion_parity

/-- The already-landed live weak generators are supported entirely on the
already-landed live chirality projector, now with that projector derived from
weak-mode fermion parity by `live_chirality_eq_neg_fermion_parity`. -/
theorem live_generators_left_block :
    PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.T3 =
        PhysicsSM.Draft.NullEdge.WeakIsospinChiralityProjector.PL *
          PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.T3 *
          PhysicsSM.Draft.NullEdge.WeakIsospinChiralityProjector.PL ∧
    PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.TPlus =
        PhysicsSM.Draft.NullEdge.WeakIsospinChiralityProjector.PL *
          PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.TPlus *
          PhysicsSM.Draft.NullEdge.WeakIsospinChiralityProjector.PL ∧
    PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.TPlusᴴ =
        PhysicsSM.Draft.NullEdge.WeakIsospinChiralityProjector.PL *
          PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.TPlusᴴ *
          PhysicsSM.Draft.NullEdge.WeakIsospinChiralityProjector.PL ∧
    PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.T1 =
        PhysicsSM.Draft.NullEdge.WeakIsospinChiralityProjector.PL *
          PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.T1 *
          PhysicsSM.Draft.NullEdge.WeakIsospinChiralityProjector.PL := by
  exact generators_left_block

#print axioms number_operator_eq_diagonal
#print axioms chirality_eq_neg_fermion_parity
#print axioms T3_commutes_number
#print axioms TPlus_commutes_number
#print axioms T1_commutes_number
#print axioms TPlus_conjTranspose_commutes_number
#print axioms commutes_chi_of_commutes_number
#print axioms chi_sq
#print axioms chiral_cross_blocks_zero_of_commutes
#print axioms chiral_cross_blocks_zero_of_number_conservation
#print axioms T3_commutes_chi
#print axioms TPlus_commutes_chi
#print axioms TPlus_conjTranspose_commutes_chi
#print axioms T1_commutes_chi
#print axioms generators_cross_blocks_zero
#print axioms T3_right_singlet
#print axioms TPlus_right_singlet
#print axioms TPlus_conjTranspose_right_singlet
#print axioms T1_right_singlet
#print axioms generators_left_block
#print axioms number_eigenspace_invariant
#print axioms number_zero_eigenspace_one_dim
#print axioms number_two_eigenspace_one_dim
#print axioms number_one_eigenspace_two_dim
#print axioms chi_negative_sector
#print axioms chi_positive_sector
#print axioms even_number_sectors_trivial
#print axioms one_plus_two_plus_one_content
#print axioms B1_maps_ket11_to_ket01
#print axioms B1_right_action_nonzero
#print axioms B1_not_number_conserving_and_not_chirality_conserving
#print axioms live_chirality_eq_neg_fermion_parity
#print axioms live_generators_left_block
end PhysicsSM.Draft.NullEdge.WeakFermionParityChirality
