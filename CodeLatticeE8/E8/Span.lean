import CodeLatticeE8.E8.Basis

/-!
# Spanning theorem for the Hamming Construction A basis

The file `CodeLatticeE8.E8.Basis` introduces eight concrete lattice vectors
and computes their Gram matrix.  This module proves that those vectors generate
the whole Hamming Construction A integer lattice.

The proof is intentionally explicit.  Given a lattice vector `z`, we write down
integer coefficients for `z` in the displayed basis.  Four coefficients involve
division by `2`; the exactness of those divisions is forced by the parity-check
equations of the extended Hamming code.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.E8

open CodeLatticeE8.Code
open CodeLatticeE8.ConstructionA

/-! ## Submodule wrapper -/

/--
The Hamming Construction A lattice as a `Z`-submodule.

The underlying data was introduced as an additive subgroup, which is the most
direct way to express the preimage under reduction modulo two.  For spanning
statements it is more convenient to view the same carrier as a submodule.
-/
def hammingConstructionASubmodule : Submodule ℤ (Fin 8 → ℤ) where
  carrier := hammingConstructionA
  zero_mem' := hammingConstructionA.zero_mem
  add_mem' := fun ha hb => hammingConstructionA.add_mem ha hb
  smul_mem' := fun c _z hz => hammingConstructionA.zsmul_mem hz c

@[simp]
theorem mem_hammingConstructionASubmodule (z : Fin 8 → ℤ) :
    z ∈ hammingConstructionASubmodule ↔ z ∈ hammingConstructionA :=
  by
    change z ∈ hammingConstructionA ↔ z ∈ hammingConstructionA
    rfl

/-! ## Explicit coefficient function -/

/--
Coefficients expressing a Hamming Construction A lattice vector in the displayed
basis.  The last four entries contain exact divisions by `2`; exactness is
proved in the divisibility lemmas below.
-/
def hammingConstructionBasisCoeffs (z : Fin 8 → ℤ) : Fin 8 → ℤ :=
  ![z 2,
    -z 1 + z 2 + z 3,
    -z 0 + z 2 + z 3,
    z 0 + z 1 - 2 * z 2 - z 3,
    (z 4 + z 1 - z 2 - z 3) / 2,
    (z 5 + z 0 - z 2 - z 3) / 2,
    (z 6 - z 0 - z 1 + 2 * z 2 + z 3) / 2,
    (z 7 + z 0 + z 1 - 3 * z 2 - 2 * z 3) / 2]

/-! ## Divisibility of the four half-coefficients -/

private theorem hamming_parity_coeff4 (msg : Fin 4 → ZMod 2) :
    codewordOfMsg msg 4 + codewordOfMsg msg 1 -
      codewordOfMsg msg 2 - codewordOfMsg msg 3 = 0 := by
  simp [codewordOfMsg]
  ring_nf

private theorem hamming_parity_coeff5 (msg : Fin 4 → ZMod 2) :
    codewordOfMsg msg 5 + codewordOfMsg msg 0 -
      codewordOfMsg msg 2 - codewordOfMsg msg 3 = 0 := by
  simp [codewordOfMsg]
  ring_nf

private theorem hamming_parity_coeff6 (msg : Fin 4 → ZMod 2) :
    codewordOfMsg msg 6 - codewordOfMsg msg 0 - codewordOfMsg msg 1 +
      2 * codewordOfMsg msg 2 + codewordOfMsg msg 3 = 0 := by
  decide +revert

private theorem hamming_parity_coeff7 (msg : Fin 4 → ZMod 2) :
    codewordOfMsg msg 7 + codewordOfMsg msg 0 + codewordOfMsg msg 1 -
      3 * codewordOfMsg msg 2 - 2 * codewordOfMsg msg 3 = 0 := by
  decide +revert

private theorem reduceModTwo_eq_codewordOfMsg (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionA) :
    codewordOfMsg (msgOfCodeword (reduceModTwo z)) = reduceModTwo z :=
  codeword_msg_right_inv (reduceModTwo z)
    ((extendedHamming8_mem_iff_mulVec _).mp ((mem_hammingConstructionA_iff z).mp hz))

private theorem lattice_div2_coeff4 (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionA) :
    2 ∣ (z 4 + z 1 - z 2 - z 3) := by
  refine (ZMod.intCast_zmod_eq_zero_iff_dvd (z 4 + z 1 - z 2 - z 3) 2).mp ?_
  push_cast
  change (z 4 : ZMod 2) + (z 1 : ZMod 2) -
      (z 2 : ZMod 2) - (z 3 : ZMod 2) = 0
  let msg := msgOfCodeword (reduceModTwo z)
  have h := reduceModTwo_eq_codewordOfMsg z hz
  have h0 : codewordOfMsg msg 4 = (z 4 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 4
  have h1 : codewordOfMsg msg 1 = (z 1 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 1
  have h2 : codewordOfMsg msg 2 = (z 2 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 2
  have h3 : codewordOfMsg msg 3 = (z 3 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 3
  rw [← h0, ← h1, ← h2, ← h3]
  exact hamming_parity_coeff4 msg

private theorem lattice_div2_coeff5 (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionA) :
    2 ∣ (z 5 + z 0 - z 2 - z 3) := by
  refine (ZMod.intCast_zmod_eq_zero_iff_dvd (z 5 + z 0 - z 2 - z 3) 2).mp ?_
  push_cast
  change (z 5 : ZMod 2) + (z 0 : ZMod 2) -
      (z 2 : ZMod 2) - (z 3 : ZMod 2) = 0
  let msg := msgOfCodeword (reduceModTwo z)
  have h := reduceModTwo_eq_codewordOfMsg z hz
  have h0 : codewordOfMsg msg 5 = (z 5 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 5
  have h1 : codewordOfMsg msg 0 = (z 0 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 0
  have h2 : codewordOfMsg msg 2 = (z 2 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 2
  have h3 : codewordOfMsg msg 3 = (z 3 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 3
  rw [← h0, ← h1, ← h2, ← h3]
  exact hamming_parity_coeff5 msg

private theorem lattice_div2_coeff6 (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionA) :
    2 ∣ (z 6 - z 0 - z 1 + 2 * z 2 + z 3) := by
  refine
    (ZMod.intCast_zmod_eq_zero_iff_dvd
      (z 6 - z 0 - z 1 + 2 * z 2 + z 3) 2).mp ?_
  push_cast
  change (z 6 : ZMod 2) - (z 0 : ZMod 2) - (z 1 : ZMod 2) +
      2 * (z 2 : ZMod 2) + (z 3 : ZMod 2) = 0
  let msg := msgOfCodeword (reduceModTwo z)
  have h := reduceModTwo_eq_codewordOfMsg z hz
  have h0 : codewordOfMsg msg 6 = (z 6 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 6
  have h1 : codewordOfMsg msg 0 = (z 0 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 0
  have h2 : codewordOfMsg msg 1 = (z 1 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 1
  have h3 : codewordOfMsg msg 2 = (z 2 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 2
  have h4 : codewordOfMsg msg 3 = (z 3 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 3
  rw [← h0, ← h1, ← h2, ← h3, ← h4]
  exact hamming_parity_coeff6 msg

private theorem lattice_div2_coeff7 (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionA) :
    2 ∣ (z 7 + z 0 + z 1 - 3 * z 2 - 2 * z 3) := by
  refine
    (ZMod.intCast_zmod_eq_zero_iff_dvd
      (z 7 + z 0 + z 1 - 3 * z 2 - 2 * z 3) 2).mp ?_
  push_cast
  change (z 7 : ZMod 2) + (z 0 : ZMod 2) + (z 1 : ZMod 2) -
      3 * (z 2 : ZMod 2) - 2 * (z 3 : ZMod 2) = 0
  let msg := msgOfCodeword (reduceModTwo z)
  have h := reduceModTwo_eq_codewordOfMsg z hz
  have h0 : codewordOfMsg msg 7 = (z 7 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 7
  have h1 : codewordOfMsg msg 0 = (z 0 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 0
  have h2 : codewordOfMsg msg 1 = (z 1 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 1
  have h3 : codewordOfMsg msg 2 = (z 2 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 2
  have h4 : codewordOfMsg msg 3 = (z 3 : ZMod 2) := by
    simpa [msg, reduceModTwo] using congr_fun h 3
  rw [← h0, ← h1, ← h2, ← h3, ← h4]
  exact hamming_parity_coeff7 msg

/-! ## Reconstruction and span theorem -/

private theorem ediv_two_mul_two_cancel {a : ℤ} (h : 2 ∣ a) :
    a / 2 * 2 = a :=
  Int.ediv_mul_cancel h

set_option linter.flexible false in
/--
The explicit coefficient function reconstructs each Hamming Construction A
lattice vector from the displayed basis.
-/
theorem hammingConstructionBasis_reconstruction
    (z : Fin 8 → ℤ) (hz : z ∈ hammingConstructionA) :
    ∀ j : Fin 8,
      z j = ∑ i : Fin 8,
        hammingConstructionBasisCoeffs z i * hammingConstructionBasis i j := by
  intro j
  fin_cases j
  · simp [Fin.sum_univ_eight, hammingConstructionBasisCoeffs, hammingConstructionBasis]
    ring
  · simp [Fin.sum_univ_eight, hammingConstructionBasisCoeffs, hammingConstructionBasis]
    ring
  · simp [Fin.sum_univ_eight, hammingConstructionBasisCoeffs, hammingConstructionBasis]
  · simp [Fin.sum_univ_eight, hammingConstructionBasisCoeffs, hammingConstructionBasis]
    ring
  · simp [Fin.sum_univ_eight, hammingConstructionBasisCoeffs, hammingConstructionBasis]
    rw [ediv_two_mul_two_cancel (lattice_div2_coeff4 z hz)]
    ring
  · simp [Fin.sum_univ_eight, hammingConstructionBasisCoeffs, hammingConstructionBasis]
    rw [ediv_two_mul_two_cancel (lattice_div2_coeff5 z hz)]
    ring
  · simp [Fin.sum_univ_eight, hammingConstructionBasisCoeffs, hammingConstructionBasis]
    rw [ediv_two_mul_two_cancel (lattice_div2_coeff6 z hz)]
    ring
  · simp [Fin.sum_univ_eight, hammingConstructionBasisCoeffs, hammingConstructionBasis]
    rw [ediv_two_mul_two_cancel (lattice_div2_coeff7 z hz)]
    ring

/-- Every integer linear combination of the displayed basis vectors lies in the lattice. -/
theorem hammingConstructionBasis_span_subset :
    ∀ z, z ∈ Submodule.span ℤ (Set.range hammingConstructionBasis) →
      z ∈ hammingConstructionA := by
  intro z hz
  apply Submodule.span_induction at hz
  rotate_left
  · exact fun x _ => x ∈ hammingConstructionA
  · rintro _ ⟨i, rfl⟩
    exact hammingConstructionBasis_mem i
  · exact hammingConstructionA.zero_mem
  · exact fun _ _ _ _ hx hy => hammingConstructionA.add_mem hx hy
  · exact fun a _ _ hx => hammingConstructionA.zsmul_mem hx a
  · exact hz

/-- Every Hamming Construction A lattice vector lies in the span of the displayed basis. -/
theorem hammingConstructionBasis_spans
    (z : Fin 8 → ℤ) (hz : z ∈ hammingConstructionA) :
    z ∈ Submodule.span ℤ (Set.range hammingConstructionBasis) := by
  have hcomb :
      z = ∑ i : Fin 8,
        hammingConstructionBasisCoeffs z i • hammingConstructionBasis i := by
    exact funext fun j =>
      hammingConstructionBasis_reconstruction z hz j ▸ by simp +decide [Finset.sum_apply]
  exact hcomb.symm ▸
    Submodule.sum_mem _ fun i _ =>
      Submodule.smul_mem _ _ (Submodule.subset_span (Set.mem_range_self i))

/-- The displayed basis spans exactly the Hamming Construction A submodule. -/
theorem hammingConstructionASubmodule_eq_span :
    hammingConstructionASubmodule =
      Submodule.span ℤ (Set.range hammingConstructionBasis) := by
  ext z
  constructor
  · intro hz
    exact hammingConstructionBasis_spans z hz
  · intro hz
    exact hammingConstructionBasis_span_subset z hz

end CodeLatticeE8.E8
