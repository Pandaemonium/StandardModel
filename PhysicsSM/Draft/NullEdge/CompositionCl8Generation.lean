import PhysicsSM.Draft.NullEdge.CompositionSU2
import PhysicsSM.Draft.NullEdge.CompositionColorCAR

/-!
# P5 stage B: the Cl(8) generator table on the Dixon carrier

This file completes the five checks requested for the three-generation stage-B
`Cl(8)` construction.  There is one correction to the proposed dictionary:
the displayed candidate slot formulae for `L1` and `L2` are the already-landed
**right** actions `R1` and `R2`.  Genuine left quaternion multiplication is

* `L1 ⟨d0,d1,d2,d3⟩ = ⟨-d1,d0,-d3,d2⟩`,
* `L2 ⟨d0,d1,d2,d3⟩ = ⟨-d2,d3,d0,-d1⟩`.

These corrected maps commute with all three right actions.  The colour volume
has square `-1`; since each corrected left quaternion action also has square
`-1`, the twisted generators `chi ∘ L1` and `chi ∘ L2` have square `+1`.
Thus **no extra complex `i` factor is required**.  The theorem `cl8_table`
is the full indexed 8×8 table, including all ordered off-diagonal slots.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionCl8Generation

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.CompositionWeakCAR
open PhysicsSM.Draft.NullEdge.CompositionSU2

set_option maxHeartbeats 64000000
set_option maxRecDepth 20000

/-! ## 1. Six colour generators -/

/-- Sparse normal forms of the six hermitian combinations. -/
def c1 : ComplexOctonion := ⟨0, ⟨0,0,0,1,0,0,0,0⟩⟩
def c2 : ComplexOctonion := ⟨0, ⟨0,1,0,0,0,0,0,0⟩⟩
def c3 : ComplexOctonion := ⟨0, ⟨0,0,1,0,0,0,0,0⟩⟩
def c4 : ComplexOctonion := ⟨0, ⟨0,0,0,0,1,0,0,0⟩⟩
def c5 : ComplexOctonion := ⟨0, ⟨0,0,0,0,0,0,-1,0⟩⟩
def c6 : ComplexOctonion := ⟨0, ⟨0,0,0,0,0,-1,0,0⟩⟩

/-- Kernel check of the candidate dictionary against the sparse forms. -/
theorem colour_dictionary :
    c1 = alpha1 + alpha1_dag ∧ c2 = alpha2 + alpha2_dag ∧
    c3 = alpha3 + alpha3_dag ∧ c4 = Complex.I • (alpha1 - alpha1_dag) ∧
    c5 = Complex.I • (alpha2 - alpha2_dag) ∧
    c6 = Complex.I • (alpha3 - alpha3_dag) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    ext <;> simp [c1, c2, c3, c4, c5, c6, alpha1,
      alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
      sub_eq_add_neg] <;> ring

def C1 (z : ComplexOctonion) := c1 * z
def C2 (z : ComplexOctonion) := c2 * z
def C3 (z : ComplexOctonion) := c3 * z
def C4 (z : ComplexOctonion) := c4 * z
def C5 (z : ComplexOctonion) := c5 * z
def C6 (z : ComplexOctonion) := c6 * z

@[local simp] theorem left_mul_add (x y z : ComplexOctonion) :
    x * (y + z) = x * y + x * z := by
  ext <;> simp [ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

@[local simp] theorem left_mul_neg (x y : ComplexOctonion) : x * (-y) = -(x * y) := by
  ext <;> simp [ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

@[local simp] theorem left_mul_smul (x y : ComplexOctonion) (c : ℂ) :
    x * (c • y) = c • (x * y) := by
  ext <;> simp [ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] <;> ring

/-- The six colour generators, indexed so that the complete table can be one
universally quantified kernel theorem. -/
def colourGen (a : Fin 6) : ComplexOctonion → ComplexOctonion :=
  match a.1 with
  | 0 => C1 | 1 => C2 | 2 => C3 | 3 => C4 | 4 => C5 | _ => C6

/-- Exact colour Clifford table: diagonal anticommutators are `2z`, and every
off-diagonal anticommutator vanishes. -/
theorem colour_clifford_table (a b : Fin 6) (z : ComplexOctonion) :
    colourGen a (colourGen b z) + colourGen b (colourGen a z) =
      if a = b then (2 : ℂ) • z else 0 := by
  fin_cases a <;> fin_cases b <;> ext <;>
    simp [colourGen, C1, C2, C3, C4, C5, C6, c1, c2, c3, c4, c5, c6,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-! ## 2. Correct left quaternion actions -/

/-- Genuine left multiplication by `i₁` (the candidate in the task docstring
was `R1`, hence had the last two signs reversed). -/
def L1 (d : Dixon) : Dixon := ⟨-d.x1, d.x0, -d.x3, d.x2⟩

/-- Genuine left multiplication by `i₂` (again corrected from the displayed
right-action formula). -/
def L2 (d : Dixon) : Dixon := ⟨-d.x2, d.x3, d.x0, -d.x1⟩

theorem L1_comm_R1 (d : Dixon) : L1 (R1 d) = R1 (L1 d) := by
  ext <;> simp [L1, R1_slots]
theorem L1_comm_R2 (d : Dixon) : L1 (R2 d) = R2 (L1 d) := by
  ext <;> simp [L1, R2_slots]
theorem L1_comm_R3 (d : Dixon) : L1 (R3 d) = R3 (L1 d) := by
  ext <;> simp [L1, R3_slots]
theorem L2_comm_R1 (d : Dixon) : L2 (R1 d) = R1 (L2 d) := by
  ext <;> simp [L2, R1_slots]
theorem L2_comm_R2 (d : Dixon) : L2 (R2 d) = R2 (L2 d) := by
  ext <;> simp [L2, R2_slots]
theorem L2_comm_R3 (d : Dixon) : L2 (R3 d) = R3 (L2 d) := by
  ext <;> simp [L2, R3_slots]

/-! ## 3. Colour volume -/

def chiC (z : ComplexOctonion) : ComplexOctonion :=
  C1 (C2 (C3 (C4 (C5 (C6 z)))))

def Chi (d : Dixon) : Dixon := co chiC d

/-- The six-dimensional colour volume anticommutes with every colour
generator. -/
theorem chiC_anticomm (a : Fin 6) (z : ComplexOctonion) :
    chiC (colourGen a z) + colourGen a (chiC z) = 0 := by
  fin_cases a <;> ext <;>
    simp [chiC, colourGen, C1, C2, C3, C4, C5, C6,
      c1, c2, c3, c4, c5, c6, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- With six positive generators, the volume square is `(-1)^15 = -1`. -/
theorem chiC_sq (z : ComplexOctonion) : chiC (chiC z) = -z := by
  ext <;> simp [chiC, C1, C2, C3, C4, C5, C6,
    c1, c2, c3, c4, c5, c6, ComplexOctonion.mul_re,
    ComplexOctonion.mul_im] <;> ring

theorem Chi_sq (d : Dixon) : Chi (Chi d) = -d := by
  ext <;> simp [Chi, co, chiC_sq]

/-! ## 4. The two twisted H-side generators and full table -/

def G7 (d : Dixon) : Dixon := Chi (L1 d)
def G8 (d : Dixon) : Dixon := Chi (L2 d)

/-- Slot lift of a colour generator. -/
def colourGenD (a : Fin 6) (d : Dixon) : Dixon := co (colourGen a) d

theorem colourGenD_table (a b : Fin 6) (d : Dixon) :
    colourGenD a (colourGenD b d) + colourGenD b (colourGenD a d) =
      if a = b then (2 : ℂ) • d else 0 := by
  by_cases h : a = b
  · subst b; ext <;> simp [colourGenD, co, colour_clifford_table]
  · ext <;> simp [colourGenD, co, colour_clifford_table, h]

@[simp] theorem L1_sq (d : Dixon) : L1 (L1 d) = -d := by
  ext <;> simp [L1]
@[simp] theorem L2_sq (d : Dixon) : L2 (L2 d) = -d := by
  ext <;> simp [L2]
theorem L12_anticomm (d : Dixon) : L1 (L2 d) + L2 (L1 d) = 0 := by
  ext <;> simp [L1, L2]

theorem colourGen_neg (a : Fin 6) (z : ComplexOctonion) :
    colourGen a (-z) = -colourGen a z := by
  fin_cases a <;> ext <;> simp [colourGen, C1, C2, C3, C4, C5, C6,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

theorem chiC_neg (z : ComplexOctonion) : chiC (-z) = -chiC z := by
  ext <;> simp [chiC, C1, C2, C3, C4, C5, C6,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

@[simp] theorem chiC_sq_neg (z : ComplexOctonion) : chiC (chiC (-z)) = z := by
  rw [chiC_neg, chiC_neg, chiC_sq]
  simp

@[simp] theorem colour_chi_anticomm (a : Fin 6) (z : ComplexOctonion) :
    colourGen a (chiC z) + chiC (colourGen a z) = 0 := by
  simpa [add_comm] using chiC_anticomm a z

@[simp] theorem neg_colour_chi_anticomm (a : Fin 6) (z : ComplexOctonion) :
    -colourGen a (chiC z) + -chiC (colourGen a z) = 0 := by
  rw [← neg_add]
  simp [colour_chi_anticomm]

@[simp] theorem colour_chi_neg_anticomm (a : Fin 6) (z : ComplexOctonion) :
    colourGen a (chiC (-z)) + chiC (colourGen a (-z)) = 0 := by
  simp [chiC_neg, colourGen_neg, neg_colour_chi_anticomm]

theorem Chi_anticomm_colour (a : Fin 6) (d : Dixon) :
    Chi (colourGenD a d) + colourGenD a (Chi d) = 0 := by
  ext <;> simp [Chi, colourGenD, co, chiC_anticomm]

@[simp] theorem G7_comp (d : Dixon) : G7 (G7 d) = d := by
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    simp [G7, Chi, L1, co, chiC_sq, chiC_neg, chiC_sq_neg]
@[simp] theorem G8_comp (d : Dixon) : G8 (G8 d) = d := by
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    simp [G8, Chi, L2, co, chiC_sq, chiC_neg, chiC_sq_neg]
theorem G7_sq (d : Dixon) : G7 (G7 d) + G7 (G7 d) = (2 : ℂ) • d := by
  simp
  module
theorem G8_sq (d : Dixon) : G8 (G8 d) + G8 (G8 d) = (2 : ℂ) • d := by
  simp
  module
theorem G7_G8 (d : Dixon) : G7 (G8 d) + G8 (G7 d) = 0 := by
  ext <;> simp [G7, G8, Chi, L1, L2, co, chiC_sq, chiC_neg]
theorem colour_G7 (a : Fin 6) (d : Dixon) :
    colourGenD a (G7 d) + G7 (colourGenD a d) = 0 := by
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    simp [colourGenD, G7, Chi, L1, co, chiC_neg, colourGen_neg,
      colour_chi_neg_anticomm, colour_chi_anticomm]
theorem colour_G8 (a : Fin 6) (d : Dixon) :
    colourGenD a (G8 d) + G8 (colourGenD a d) = 0 := by
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    simp [colourGenD, G8, Chi, L2, co, chiC_neg, colourGen_neg,
      colour_chi_neg_anticomm, colour_chi_anticomm]

/-- All eight generators on the Dixon carrier. -/
def cliffordGen (a : Fin 8) : Dixon → Dixon :=
  match a.1 with
  | 0 => colourGenD ⟨0, by omega⟩
  | 1 => colourGenD ⟨1, by omega⟩
  | 2 => colourGenD ⟨2, by omega⟩
  | 3 => colourGenD ⟨3, by omega⟩
  | 4 => colourGenD ⟨4, by omega⟩
  | 5 => colourGenD ⟨5, by omega⟩
  | 6 => G7
  | _ => G8

/-- **The full 8×8 Clifford table on the Dixon carrier.**  The right side is
exactly `2d` on the diagonal and zero off it; no normalization correction is
hidden in the statement. -/
theorem cl8_table (a b : Fin 8) (d : Dixon) :
    cliffordGen a (cliffordGen b d) + cliffordGen b (cliffordGen a d) =
      if a = b then (2 : ℂ) • d else 0 := by
  fin_cases a <;> fin_cases b <;> simp only [cliffordGen]
  case «0».«0» => exact colourGenD_table ⟨0, by omega⟩ ⟨0, by omega⟩ d
  case «0».«1» => exact colourGenD_table ⟨0, by omega⟩ ⟨1, by omega⟩ d
  case «0».«2» => exact colourGenD_table ⟨0, by omega⟩ ⟨2, by omega⟩ d
  case «0».«3» => exact colourGenD_table ⟨0, by omega⟩ ⟨3, by omega⟩ d
  case «0».«4» => exact colourGenD_table ⟨0, by omega⟩ ⟨4, by omega⟩ d
  case «0».«5» => exact colourGenD_table ⟨0, by omega⟩ ⟨5, by omega⟩ d
  case «0».«6» => simpa [add_comm] using colour_G7 ⟨0, by omega⟩ d
  case «0».«7» => simpa [add_comm] using colour_G8 ⟨0, by omega⟩ d
  case «1».«0» => exact colourGenD_table ⟨1, by omega⟩ ⟨0, by omega⟩ d
  case «1».«1» => exact colourGenD_table ⟨1, by omega⟩ ⟨1, by omega⟩ d
  case «1».«2» => exact colourGenD_table ⟨1, by omega⟩ ⟨2, by omega⟩ d
  case «1».«3» => exact colourGenD_table ⟨1, by omega⟩ ⟨3, by omega⟩ d
  case «1».«4» => exact colourGenD_table ⟨1, by omega⟩ ⟨4, by omega⟩ d
  case «1».«5» => exact colourGenD_table ⟨1, by omega⟩ ⟨5, by omega⟩ d
  case «1».«6» => simpa [add_comm] using colour_G7 ⟨1, by omega⟩ d
  case «1».«7» => simpa [add_comm] using colour_G8 ⟨1, by omega⟩ d
  case «2».«0» => exact colourGenD_table ⟨2, by omega⟩ ⟨0, by omega⟩ d
  case «2».«1» => exact colourGenD_table ⟨2, by omega⟩ ⟨1, by omega⟩ d
  case «2».«2» => exact colourGenD_table ⟨2, by omega⟩ ⟨2, by omega⟩ d
  case «2».«3» => exact colourGenD_table ⟨2, by omega⟩ ⟨3, by omega⟩ d
  case «2».«4» => exact colourGenD_table ⟨2, by omega⟩ ⟨4, by omega⟩ d
  case «2».«5» => exact colourGenD_table ⟨2, by omega⟩ ⟨5, by omega⟩ d
  case «2».«6» => simpa [add_comm] using colour_G7 ⟨2, by omega⟩ d
  case «2».«7» => simpa [add_comm] using colour_G8 ⟨2, by omega⟩ d
  case «3».«0» => exact colourGenD_table ⟨3, by omega⟩ ⟨0, by omega⟩ d
  case «3».«1» => exact colourGenD_table ⟨3, by omega⟩ ⟨1, by omega⟩ d
  case «3».«2» => exact colourGenD_table ⟨3, by omega⟩ ⟨2, by omega⟩ d
  case «3».«3» => exact colourGenD_table ⟨3, by omega⟩ ⟨3, by omega⟩ d
  case «3».«4» => exact colourGenD_table ⟨3, by omega⟩ ⟨4, by omega⟩ d
  case «3».«5» => exact colourGenD_table ⟨3, by omega⟩ ⟨5, by omega⟩ d
  case «3».«6» => simpa [add_comm] using colour_G7 ⟨3, by omega⟩ d
  case «3».«7» => simpa [add_comm] using colour_G8 ⟨3, by omega⟩ d
  case «4».«0» => exact colourGenD_table ⟨4, by omega⟩ ⟨0, by omega⟩ d
  case «4».«1» => exact colourGenD_table ⟨4, by omega⟩ ⟨1, by omega⟩ d
  case «4».«2» => exact colourGenD_table ⟨4, by omega⟩ ⟨2, by omega⟩ d
  case «4».«3» => exact colourGenD_table ⟨4, by omega⟩ ⟨3, by omega⟩ d
  case «4».«4» => exact colourGenD_table ⟨4, by omega⟩ ⟨4, by omega⟩ d
  case «4».«5» => exact colourGenD_table ⟨4, by omega⟩ ⟨5, by omega⟩ d
  case «4».«6» => simpa [add_comm] using colour_G7 ⟨4, by omega⟩ d
  case «4».«7» => simpa [add_comm] using colour_G8 ⟨4, by omega⟩ d
  case «5».«0» => exact colourGenD_table ⟨5, by omega⟩ ⟨0, by omega⟩ d
  case «5».«1» => exact colourGenD_table ⟨5, by omega⟩ ⟨1, by omega⟩ d
  case «5».«2» => exact colourGenD_table ⟨5, by omega⟩ ⟨2, by omega⟩ d
  case «5».«3» => exact colourGenD_table ⟨5, by omega⟩ ⟨3, by omega⟩ d
  case «5».«4» => exact colourGenD_table ⟨5, by omega⟩ ⟨4, by omega⟩ d
  case «5».«5» => exact colourGenD_table ⟨5, by omega⟩ ⟨5, by omega⟩ d
  case «5».«6» => simpa [add_comm] using colour_G7 ⟨5, by omega⟩ d
  case «5».«7» => simpa [add_comm] using colour_G8 ⟨5, by omega⟩ d
  case «6».«0» => simpa [add_comm] using colour_G7 ⟨0, by omega⟩ d
  case «6».«1» => simpa [add_comm] using colour_G7 ⟨1, by omega⟩ d
  case «6».«2» => simpa [add_comm] using colour_G7 ⟨2, by omega⟩ d
  case «6».«3» => simpa [add_comm] using colour_G7 ⟨3, by omega⟩ d
  case «6».«4» => simpa [add_comm] using colour_G7 ⟨4, by omega⟩ d
  case «6».«5» => simpa [add_comm] using colour_G7 ⟨5, by omega⟩ d
  case «6».«6» => exact G7_sq d
  case «6».«7» => simpa [add_comm] using G7_G8 d
  case «7».«0» => simpa [add_comm] using colour_G8 ⟨0, by omega⟩ d
  case «7».«1» => simpa [add_comm] using colour_G8 ⟨1, by omega⟩ d
  case «7».«2» => simpa [add_comm] using colour_G8 ⟨2, by omega⟩ d
  case «7».«3» => simpa [add_comm] using colour_G8 ⟨3, by omega⟩ d
  case «7».«4» => simpa [add_comm] using colour_G8 ⟨4, by omega⟩ d
  case «7».«5» => simpa [add_comm] using colour_G8 ⟨5, by omega⟩ d
  case «7».«6» => simpa [add_comm] using G7_G8 d
  case «7».«7» => exact G8_sq d

end PhysicsSM.Draft.NullEdge.CompositionCl8Generation
