import Mathlib
import PhysicsSM.Algebra.Jordan.TraceForm
import PhysicsSM.Algebra.Octonion.ComplexTripleLinear

/-!
# Algebra.Jordan.H3OComplexMatrix

Coordinate-level equivalence between the orthogonal complement of `h₃(ℂ)`
in `h₃(𝕆)` and the space of 3×3 complex matrices `M₃(ℂ)`.

## Mathematical context

The DVT/Yokota splitting of the Albert algebra is

  `h₃(𝕆) = h₃(ℂ) ⊕ h₃(ℂ)⊥`

where `h₃(ℂ)⊥` is the 18-real-dimensional orthogonal complement under the
trace form. An element of the complement has zero diagonal and off-diagonal
octonion entries `x, y, z` in the chosen complex complement (`c0 = c7 = 0`).

Each off-diagonal entry in the complement is a `ComplexTriple ≅ ℂ³`, so the
full complement is `(ℂ³)³ ≅ M₃(ℂ)`.

## Convention

The coordinate map `complementToM3C` sends a complement element to a
3×3 complex matrix as follows:

- **Row 0** = the `x` off-diagonal entry (the `(2,3)` entry of the H3O matrix),
  converted to three complex coordinates via `ComplexTriple.toComplexVec`.
- **Row 1** = the `y` off-diagonal entry (the `(3,1)` entry of the H3O matrix).
- **Row 2** = the `z` off-diagonal entry (the `(1,2)` entry of the H3O matrix).
- **Columns** = the `Fin 3` complex coordinates `(w₁, w₂, w₃)` of
  `ComplexTriple`, following the convention in `ComplexSplitting`:
  `w₁ = c1 + i·c6`, `w₂ = c2 + i·c5`, `w₃ = c4 + i·c3`.

## Main declarations

- `complementToM3C` — map from an H3O element to `Matrix (Fin 3) (Fin 3) ℂ`
  by extracting the complement coordinates of `x, y, z`.
- `m3CToComplement` — inverse map: build a complement element from a matrix.
- `m3CToComplement_inComplementOfB` — the image lands in the complement.
- `complementToM3C_m3CToComplement` — right inverse (matrix round-trip).
- `m3CToComplement_complementToM3C_of_inComplementOfB` — left inverse on
  the complement subtype.
- `complementEquivM3C` — the equivalence on the complement subtype.

## Claim boundary

This file only provides a coordinate/vector-space bridge. It does not claim
the full DVT/Yokota theorem about the stabilizer being `(SU(3) × SU(3)) / ℤ₃`.

Source: Dubois-Violette and Todorov, "Exceptional quantum geometry and particle
physics II" (2019); Yokota, "Exceptional Lie Groups" (2009), Chapter 3.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Octonion

/-! ## Complement octonion roundtrip

If an octonion is in the chosen complex complement (`c0 = 0`, `c7 = 0`),
then projecting to `ComplexTriple` and embedding back recovers the original.
-/

/-- Projecting a complement octonion to `ComplexTriple` and embedding back
    recovers the original octonion. -/
private theorem toComplexTriple_toOctonion_of_complement
    {o : Octonion} (ho : InChosenComplexComplement o) :
    o.toComplexTriple.toOctonion = o := by
  obtain ⟨h0, h7⟩ := ho
  ext <;> simp [ComplexTriple.toOctonion, Octonion.toComplexTriple, *]

/-! ## Helper: extract the off-diagonal octonion for a given row index -/

/-- Extract the off-diagonal octonion entry of `a : H3O` indexed by `Fin 3`:
    `0 ↦ x`, `1 ↦ y`, `2 ↦ z`. -/
private def offDiag (a : H3O) (i : Fin 3) : Octonion :=
  match i with
  | ⟨0, _⟩ => a.x
  | ⟨1, _⟩ => a.y
  | ⟨2, _⟩ => a.z

/-! ## The coordinate map: complement → M₃(ℂ) -/

/--
Map an `H3O` element to a 3×3 complex matrix by extracting the complement
coordinates of its three off-diagonal entries `x, y, z`.

- Row `i = 0`: the `x` entry's complement coordinates.
- Row `i = 1`: the `y` entry's complement coordinates.
- Row `i = 2`: the `z` entry's complement coordinates.
- Column `j`: the `j`-th complex coordinate of `ComplexTriple.toComplexVec`.

This map is well-defined on all of `H3O`, but is only injective on the
complement `InComplementOfB`.
-/
noncomputable def complementToM3C
    (a : H3O) : Matrix (Fin 3) (Fin 3) ℂ :=
  Matrix.of fun i j => (offDiag a i).toComplexTriple.toComplexVec j

/--
Build an `H3O` complement element from a 3×3 complex matrix.

- Row 0 becomes the `x` off-diagonal entry.
- Row 1 becomes the `y` off-diagonal entry.
- Row 2 becomes the `z` off-diagonal entry.
- Diagonal entries `alpha, beta, gamma` are set to zero.
-/
noncomputable def m3CToComplement
    (M : Matrix (Fin 3) (Fin 3) ℂ) : H3O where
  alpha := 0
  beta := 0
  gamma := 0
  x := (ComplexTriple.ofComplexVec (M ⟨0, by omega⟩)).toOctonion
  y := (ComplexTriple.ofComplexVec (M ⟨1, by omega⟩)).toOctonion
  z := (ComplexTriple.ofComplexVec (M ⟨2, by omega⟩)).toOctonion

/-! ## The image of `m3CToComplement` lies in the complement -/

/--
Every matrix maps to a complement element: diagonal is zero and off-diagonal
entries are in the chosen complex complement.
-/
theorem m3CToComplement_inComplementOfB
    (M : Matrix (Fin 3) (Fin 3) ℂ) :
    InComplementOfB (m3CToComplement M) :=
  ⟨rfl, rfl, rfl,
   ComplexTriple.toOctonion_inComplement _,
   ComplexTriple.toOctonion_inComplement _,
   ComplexTriple.toOctonion_inComplement _⟩

/-! ## Round-trip theorems -/

/-
Right inverse: converting a matrix to a complement element and back recovers
the original matrix.
-/
theorem complementToM3C_m3CToComplement
    (M : Matrix (Fin 3) (Fin 3) ℂ) :
    complementToM3C (m3CToComplement M) = M := by
  ext i j; fin_cases i <;> simp +decide [ *, complementToM3C, m3CToComplement, offDiag ] ;
  · convert ComplexTriple.toComplexVec_ofComplexVec ( M 0 ) |> congr_fun <| j using 1;
  · convert ComplexTriple.toComplexVec_ofComplexVec ( M 1 ) |> congrFun <| j using 1;
  · convert ComplexTriple.toComplexVec_ofComplexVec ( M 2 ) |> congr_fun <| j using 1

/-
Left inverse on the complement: converting a complement element to a matrix
and back recovers the original element.
-/
theorem m3CToComplement_complementToM3C_of_inComplementOfB
    {a : H3O} (ha : InComplementOfB a) :
    m3CToComplement (complementToM3C a) = a := by
  cases a;
  rename_i alpha beta gamma x y z;
  cases ha;
  cases x ; cases y ; cases z ; simp_all +decide [ InChosenComplexComplement ];
  congr

/-! ## Subtype equivalence -/

/--
The orthogonal complement of `h₃(ℂ)` in `h₃(𝕆)` is equivalent to
`M₃(ℂ) = Matrix (Fin 3) (Fin 3) ℂ` as a type.

This packages the two round-trip theorems into a single `Equiv`.
-/
noncomputable def complementEquivM3C :
    {a : H3O // InComplementOfB a} ≃ Matrix (Fin 3) (Fin 3) ℂ where
  toFun a := complementToM3C a.val
  invFun M := ⟨m3CToComplement M, m3CToComplement_inComplementOfB M⟩
  left_inv := fun ⟨a, ha⟩ => by
    simp only
    ext1
    exact m3CToComplement_complementToM3C_of_inComplementOfB ha
  right_inv M := complementToM3C_m3CToComplement M

/-! ## Linearity of `complementToM3C` -/

/-
`complementToM3C` sends the zero element to the zero matrix.
-/
@[simp]
theorem complementToM3C_zero :
    complementToM3C (0 : H3O) = 0 := by
  ext i j;
  fin_cases i <;> fin_cases j <;> rfl

/-
`complementToM3C` is additive.
-/
theorem complementToM3C_add (a b : H3O) :
    complementToM3C (a + b) = complementToM3C a + complementToM3C b := by
  unfold complementToM3C;
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ offDiag ] ;
  all_goals unfold ComplexTriple.toComplexVec; simp +decide [ Complex.ext_iff ] ;

/-
`complementToM3C` commutes with negation.
-/
theorem complementToM3C_neg (a : H3O) :
    complementToM3C (-a) = -complementToM3C a := by
  unfold complementToM3C; ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ offDiag ] ;
  all_goals congr

/-! ## Linearity of `m3CToComplement` -/

/-
`m3CToComplement` sends the zero matrix to zero.
-/
@[simp]
theorem m3CToComplement_zero :
    m3CToComplement (0 : Matrix (Fin 3) (Fin 3) ℂ) = 0 := by
  convert m3CToComplement_complementToM3C_of_inComplementOfB zero_inComplementOfB using 1

/-
`m3CToComplement` is additive.
-/
theorem m3CToComplement_add (M N : Matrix (Fin 3) (Fin 3) ℂ) :
    m3CToComplement (M + N) = m3CToComplement M + m3CToComplement N := by
  convert m3CToComplement_complementToM3C_of_inComplementOfB
    (show InComplementOfB (m3CToComplement M + m3CToComplement N) from ?_) using 1
  exact add_mem_complementOfB
    (m3CToComplement_inComplementOfB M)
    (m3CToComplement_inComplementOfB N)

/-
`m3CToComplement` commutes with negation.
-/
theorem m3CToComplement_neg (M : Matrix (Fin 3) (Fin 3) ℂ) :
    m3CToComplement (-M) = -m3CToComplement M := by
  unfold m3CToComplement;
  congr <;> aesop ( simp_config := { decide := true } )

end PhysicsSM.Algebra.Jordan.H3O
