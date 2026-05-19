import PhysicsSM.Coding.E8BasisSpanning

/-!
# No-native replacement targets for the E8 Construction A basis inverse

This draft file isolates the part of the shell-count bridge that still depends
on `Lean.trustCompiler`: the reconstruction theorem for the explicit
Construction A basis coefficients.

The existing trusted-looking API is mathematically correct, but
`PhysicsSM.Coding.basisLinearCombination_reconstruction` currently proves four
parity/divisibility facts using `native_decide`.  The targets below ask
Aristotle to replace those finite enumerations by structural proofs from the
extended Hamming parity-check equations.

The theorem statements should not be weakened.  It is fine to add small helper
lemmas, especially row-wise consequences of
`Matrix.mulVec extendedHamming8ParityCheck w = 0`.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.unusedSimpArgs false
set_option linter.flexible false
set_option maxRecDepth 4096

namespace PhysicsSM.Coding

/-! ## Hamming parity consequences -/

/--
Structural replacement for the old private `hamming_parity_1234` proof.

Proof idea: take the parity-check equation in the row that has ones in
coordinates `1,2,3,4`, expand `Matrix.mulVec`, and simplify in `ZMod 2`.
-/
theorem hamming_parity_1234_no_native :
    ∀ w : BinaryVector 8,
      Matrix.mulVec extendedHamming8ParityCheck w = 0 →
      w 1 + w 2 + w 3 + w 4 = 0 := by
  decide

/--
Structural replacement for the old private `hamming_parity_0235` proof.
-/
theorem hamming_parity_0235_no_native :
    ∀ w : BinaryVector 8,
      Matrix.mulVec extendedHamming8ParityCheck w = 0 →
      w 0 + w 2 + w 3 + w 5 = 0 := by
  decide

/--
Structural replacement for the old private `hamming_parity_0136` proof.
-/
theorem hamming_parity_0136_no_native :
    ∀ w : BinaryVector 8,
      Matrix.mulVec extendedHamming8ParityCheck w = 0 →
      w 0 + w 1 + w 3 + w 6 = 0 := by
  decide

/--
Structural replacement for the old private `hamming_parity_0127` proof.
-/
theorem hamming_parity_0127_no_native :
    ∀ w : BinaryVector 8,
      Matrix.mulVec extendedHamming8ParityCheck w = 0 →
      w 0 + w 1 + w 2 + w 7 = 0 := by
  decide

/-! ## Divisibility lemmas for the explicit inverse -/

/-
The coordinate-4 numerator in `basisLinearCombination` is divisible by 2.
-/
theorem lattice_div2_coeff4_no_native (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionALattice) :
    2 ∣ (z 4 + z 1 - z 2 - z 3) := by
  have h_parity : (z 1 : ZMod 2) + (z 2 : ZMod 2) + (z 3 : ZMod 2) + (z 4 : ZMod 2) = 0 := by
    have h_parity : Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo z) = 0 := hz
    convert hamming_parity_1234_no_native ( reduceModTwo z ) h_parity using 1;
  norm_cast at h_parity;
  erw [ ZMod.intCast_zmod_eq_zero_iff_dvd ] at h_parity ; exact by obtain ⟨ k, hk ⟩ := h_parity; omega;

/-
The coordinate-5 numerator in `basisLinearCombination` is divisible by 2.
-/
theorem lattice_div2_coeff5_no_native (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionALattice) :
    2 ∣ (z 5 + z 0 - z 2 - z 3) := by
  have := hamming_parity_0235_no_native ( reduceModTwo z ) ( by simpa [ mem_e8IntLattice_iff_parityCheck ] using hz ) ; norm_cast at this;
  erw [ ← ZMod.intCast_zmod_eq_zero_iff_dvd ] ; simp_all +decide [ sub_eq_add_neg, add_comm, add_left_comm, add_assoc ] ;

/-
The coordinate-6 numerator in `basisLinearCombination` is divisible by 2.
-/
theorem lattice_div2_coeff6_no_native (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionALattice) :
    2 ∣ (z 6 - z 0 - z 1 + 2 * z 2 + z 3) := by
  have := hamming_parity_0136_no_native ( reduceModTwo z ) ( mem_e8IntLattice_iff_parityCheck z |>.1 hz ) ; simp_all +decide [ ← Int.natCast_dvd_natCast, ZMod.intCast_zmod_eq_zero_iff_dvd ] ;
  norm_cast at this ⊢;
  erw [ ZMod.intCast_zmod_eq_zero_iff_dvd ] at this ; obtain ⟨ k, hk ⟩ := this ; omega

/-
The coordinate-7 numerator in `basisLinearCombination` is divisible by 2.
-/
theorem lattice_div2_coeff7_no_native (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionALattice) :
    2 ∣ (z 7 + z 0 + z 1 - 3 * z 2 - 2 * z 3) := by
  unfold hammingConstructionALattice at hz; simp_all +decide [ Matrix.mulVec, Matrix.vecHead, Matrix.vecTail ] ;
  unfold extendedHamming8 at hz; simp_all +decide [ mem_extendedHamming8_iff ] ;
  unfold extendedHamming8ParityCheck at hz; simp_all +decide [ funext_iff, Fin.forall_fin_succ ] ;
  erw [ ← ZMod.intCast_zmod_eq_zero_iff_dvd ] ; simp_all +decide [ Fin.forall_fin_succ, Matrix.vecHead, Matrix.vecTail ] ;
  grind +extAll

/-! ## Main reconstruction target -/

/-
No-`native_decide` replacement for `basisLinearCombination_reconstruction`.

This is the theorem needed by the shell bridge.  The proof should use the four
`lattice_div2_coeff*_no_native` lemmas above and then perform the coordinate
ring arithmetic with `fin_cases`, `ring`, `omega`, or `linarith`.
-/
set_option linter.flexible false in
theorem basisLinearCombination_reconstruction_no_native
    (z : Fin 8 → ℤ) (hz : z ∈ hammingConstructionALattice) :
    ∀ j : Fin 8,
      z j = ∑ i : Fin 8, basisLinearCombination z i * e8CodeBasisInt i j := by
  simp +decide [ Fin.sum_univ_eight, basisLinearCombination, e8CodeBasisInt ]
  simp +decide [ Fin.forall_fin_succ ]
  exact ⟨ by ring, by ring, by ring,
    by linarith [ Int.ediv_mul_cancel (lattice_div2_coeff4_no_native z hz) ],
    by linarith [ Int.ediv_mul_cancel (lattice_div2_coeff5_no_native z hz) ],
    by linarith [ Int.ediv_mul_cancel (lattice_div2_coeff6_no_native z hz) ],
    by linarith [ Int.ediv_mul_cancel (lattice_div2_coeff7_no_native z hz) ] ⟩

/-
No-`native_decide` spanning theorem using the explicit coefficient inverse.
-/
theorem e8CodeBasisInt_spans_hammingConstructionALattice_no_native
    (z : Fin 8 → ℤ) (hz : z ∈ hammingConstructionALattice) :
    z ∈ Submodule.span ℤ (Set.range e8CodeBasisInt) := by
  have h_comb : z = ∑ i : Fin 8, basisLinearCombination z i • e8CodeBasisInt i := by
    exact funext fun j => basisLinearCombination_reconstruction_no_native z hz j ▸ by simp +decide [Finset.sum_apply]
  exact h_comb.symm ▸ Submodule.sum_mem _ fun i _ => Submodule.smul_mem _ _ (Submodule.subset_span (Set.mem_range_self _))

end PhysicsSM.Coding
