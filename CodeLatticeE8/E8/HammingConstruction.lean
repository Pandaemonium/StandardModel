import CodeLatticeE8.Code.Hamming844
import CodeLatticeE8.ConstructionA.Even
import CodeLatticeE8.ConstructionA.Norm

/-!
# The Hamming Construction A integer lattice

This module applies Construction A to the extended Hamming `[8,4,4]` code.
The object here is the unscaled integer model

```text
{ z : Z^8 | z mod 2 belongs to H_8 }.
```

Its nonzero squared norm is at least four, and the bound is attained.  After
the conventional `1 / sqrt 2` scaling, this becomes the E8 root normalization
with minimum squared norm two.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace CodeLatticeE8.E8

open CodeLatticeE8.Code
open CodeLatticeE8.ConstructionA

/-- The Construction A integer lattice attached to the extended Hamming code. -/
def hammingConstructionA : AddSubgroup (Fin 8 → ℤ) :=
  ConstructionA.lattice extendedHamming8

/-- Membership is reduction modulo two into the extended Hamming code. -/
theorem mem_hammingConstructionA_iff (z : Fin 8 → ℤ) :
    z ∈ hammingConstructionA ↔ reduceModTwo z ∈ extendedHamming8 :=
  Iff.rfl

/-- Equivalent membership criterion via the parity-check matrix. -/
theorem mem_hammingConstructionA_iff_parityCheck (z : Fin 8 → ℤ) :
    z ∈ hammingConstructionA ↔
      Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo z) = 0 :=
  Iff.rfl

/-- Every nonzero vector in the Hamming Construction A lattice has squared norm at least four. -/
theorem hammingConstructionA_sqNorm_ge_four (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionA) (hne : z ≠ 0) :
    4 ≤ sqNorm z :=
  lattice_sqNorm_ge_four extendedHamming8
    (fun v hv hvne => extendedHamming8_minWeight_mem v hv hvne) z hz hne

/-- Every vector in the Hamming Construction A integer lattice has squared norm divisible by four. -/
theorem hammingConstructionA_sqNorm_dvd_four (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionA) :
    (4 : ℤ) ∣ sqNorm z :=
  sqNorm_dvd_four_of_doublyEven extendedHamming8
    (fun v hv => extendedHamming8_doublyEven_mem v hv) z hz

/-- A concrete vector in the Hamming Construction A lattice with squared norm four. -/
theorem hammingConstructionA_achieves_sqNorm_four :
    ∃ z : Fin 8 → ℤ, z ∈ hammingConstructionA ∧ z ≠ 0 ∧ sqNorm z = 4 := by
  let z : Fin 8 → ℤ := ![0, 0, 0, 1, 1, 1, 1, 0]
  refine ⟨z, ?_, ?_, ?_⟩
  · rw [mem_hammingConstructionA_iff, extendedHamming8_mem_iff_mulVec]
    have hz :
        reduceModTwo z = codewordOfMsg ![0, 1, 1, 1] := by
      decide
    rw [hz]
    exact codewordOfMsg_mem_code ![0, 1, 1, 1]
  · intro h
    have hcoord := congr_fun h 3
    simp [z] at hcoord
  · decide

/-- The minimum nonzero squared norm of the Hamming Construction A integer model is four. -/
theorem hammingConstructionA_minSqNorm :
    (∀ z : Fin 8 → ℤ, z ∈ hammingConstructionA → z ≠ 0 → 4 ≤ sqNorm z) ∧
    (∃ z : Fin 8 → ℤ, z ∈ hammingConstructionA ∧ z ≠ 0 ∧ sqNorm z = 4) :=
  ⟨hammingConstructionA_sqNorm_ge_four, hammingConstructionA_achieves_sqNorm_four⟩

end CodeLatticeE8.E8
