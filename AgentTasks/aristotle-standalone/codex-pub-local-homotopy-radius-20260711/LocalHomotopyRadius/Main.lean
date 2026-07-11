import Mathlib

/-!
# Locality radius of the finite physical-channel homotopy

This focused target isolates the quantitative locality statement needed after
`ChannelPhysicalCohomology`.  A matrix is `MatrixBand d r` when entries farther
than radius `r` vanish.  Under a triangle inequality, radii add under matrix
multiplication.  Consequently the explicit contraction homotopy

`S * X + (P * X) * S`

has a controlled radius whenever the contracting homotopy `S`, chain map `X`,
and physical projector `P` do.

The final two targets are an exact path-graph witness showing that radius
addition can be sharp and a countercontrol showing that locality of `P` is a
load-bearing hypothesis.

This is an abstract finite-range theorem.  It does not derive `Q`, `S`, or `P`
from the live null-edge carrier and does not prove locality of the eventual
physical automorphism group.
-/

namespace LocalHomotopyRadius

variable {I R : Type*} [Fintype I] [DecidableEq I] [Semiring R]

/-- A finite matrix has range at most `r` with respect to `d` when every entry
strictly farther than `r` vanishes. -/
def MatrixBand (d : I -> I -> Nat) (r : Nat) (A : Matrix I I R) : Prop :=
  forall i j, r < d i j -> A i j = 0

theorem MatrixBand.mono {d : I -> I -> Nat} {r t : Nat} {A : Matrix I I R}
    (hA : MatrixBand d r A) (hrt : r <= t) : MatrixBand d t A := by
  exact fun i j hij => hA i j (by linarith)

theorem MatrixBand.add {d : I -> I -> Nat} {r s : Nat} {A B : Matrix I I R}
    (hA : MatrixBand d r A) (hB : MatrixBand d s B) :
    MatrixBand d (max r s) (A + B) := by
  intro i j h
  rw [Matrix.add_apply, hA i j (by omega), hB i j (by omega), add_zero]

/-- Matrix ranges add under composition. -/
theorem MatrixBand.mul {d : I -> I -> Nat}
    (htri : forall i k j, d i j <= d i k + d k j)
    {r s : Nat} {A B : Matrix I I R}
    (hA : MatrixBand d r A) (hB : MatrixBand d s B) :
    MatrixBand d (r + s) (A * B) := by
  intro i j hij
  simp [Matrix.mul_apply, hA, hB]
  exact Finset.sum_eq_zero fun k hk => by
    by_cases h : r < d i k <;> by_cases h' : s < d k j <;>
      simp_all +decide [MatrixBand]
    linarith [htri i k j]

/-- Radius budget for the explicit contraction homotopy. -/
def homotopyRadius (rS rX rP : Nat) : Nat :=
  max (rS + rX) ((rP + rX) + rS)

/-- Quantitative locality of the explicit physical-channel homotopy
`S X + P X S`. -/
theorem explicitHomotopy_local {d : I -> I -> Nat}
    (htri : forall i k j, d i j <= d i k + d k j)
    {rS rX rP : Nat} {S X P : Matrix I I R}
    (hS : MatrixBand d rS S) (hX : MatrixBand d rX X)
    (hP : MatrixBand d rP P) :
    MatrixBand d (homotopyRadius rS rX rP) (S * X + (P * X) * S) := by
  simpa [homotopyRadius] using
    MatrixBand.add (MatrixBand.mul htri hS hX)
      (MatrixBand.mul htri (MatrixBand.mul htri hP hX) hS)

/-- An exact term `Q H + H Q` remains finite-range. -/
theorem exactCorrection_local {d : I -> I -> Nat}
    (htri : forall i k j, d i j <= d i k + d k j)
    {rQ rH : Nat} {Q H : Matrix I I R}
    (hQ : MatrixBand d rQ Q) (hH : MatrixBand d rH H) :
    MatrixBand d (rQ + rH) (Q * H + H * Q) := by
  have hQH : MatrixBand d (rQ + rH) (Q * H) := MatrixBand.mul htri hQ hH
  have hHQ : MatrixBand d (rQ + rH) (H * Q) := by
    simpa [Nat.add_comm] using MatrixBand.mul htri hH hQ
  simpa using MatrixBand.add hQH hHQ

/-! ## Exact path-graph witness and countercontrol -/

def lineDist (i j : Fin 5) : Nat := ((i : Int) - (j : Int)).natAbs

def unitMatrix (i j : Fin 5) : Matrix (Fin 5) (Fin 5) Rat :=
  fun a b => if a = i then if b = j then 1 else 0 else 0

theorem lineDist_triangle (i k j : Fin 5) :
    lineDist i j <= lineDist i k + lineDist k j := by
  unfold lineDist
  have h : ((i : Int) - (j : Int)) =
      ((i : Int) - (k : Int)) + ((k : Int) - (j : Int)) := by
    ring
  rw [h]
  exact Int.natAbs_add_le _ _

set_option maxHeartbeats 1000000 in
/-- Radius addition is genuinely attained: two nearest-neighbor matrix units
compose to a nonzero distance-two entry. Exact `Fin 5` arithmetic uses a larger
heartbeat budget. -/
theorem sharp_local_homotopy_witness :
    let S := unitMatrix 1 2
    let X := unitMatrix 2 3
    let P := unitMatrix 0 0
    let H := S * X + (P * X) * S
    MatrixBand lineDist 1 S /\
      MatrixBand lineDist 1 X /\
      MatrixBand lineDist 0 P /\
      Ne H 0 /\
      MatrixBand lineDist 2 H /\
      Not (MatrixBand lineDist 1 H) := by
  have hSX : unitMatrix 1 2 * unitMatrix 2 3 = unitMatrix 1 3 := by
    ext a b
    simp only [Matrix.mul_apply, unitMatrix]
    rw [Fin.sum_univ_five]
    fin_cases a <;> fin_cases b <;> simp
  have hPX : unitMatrix 0 0 * unitMatrix 2 3 = 0 := by
    ext a b
    simp only [Matrix.mul_apply, unitMatrix]
    rw [Fin.sum_univ_five]
    fin_cases a <;> fin_cases b <;> simp
  extract_lets S X P H
  have hHeq : H = unitMatrix 1 3 := by
    change unitMatrix 1 2 * unitMatrix 2 3 +
      unitMatrix 0 0 * unitMatrix 2 3 * unitMatrix 1 2 = unitMatrix 1 3
    rw [hSX, hPX, zero_mul, add_zero]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro i j h
    simp only [S, unitMatrix]
    fin_cases i <;> fin_cases j <;> simp_all [lineDist]
  · intro i j h
    simp only [X, unitMatrix]
    fin_cases i <;> fin_cases j <;> simp_all [lineDist]
  · intro i j h
    simp only [P, unitMatrix]
    fin_cases i <;> fin_cases j <;> simp_all [lineDist]
  · rw [hHeq]
    intro heq
    have := congrFun (congrFun heq 1) 3
    simp [unitMatrix] at this
  · rw [hHeq]
    intro i j h
    simp only [unitMatrix]
    fin_cases i <;> fin_cases j <;> simp_all [lineDist]
  · rw [hHeq]
    intro hb
    have := hb 1 3 (by decide)
    simp [unitMatrix] at this

set_option maxHeartbeats 1000000 in
/-- A projector-like factor with a distant entry can transmit the homotopy
term immediately; locality of `P` cannot be omitted. Exact `Fin 5` arithmetic
uses a larger heartbeat budget. -/
theorem nonlocal_projector_control :
    let P := unitMatrix 0 4
    let X := unitMatrix 4 4
    let S := unitMatrix 4 4
    Not (MatrixBand lineDist 1 ((P * X) * S)) := by
  have e1 : unitMatrix 0 4 * unitMatrix 4 4 = unitMatrix 0 4 := by
    ext a b
    simp only [Matrix.mul_apply, unitMatrix]
    rw [Fin.sum_univ_five]
    fin_cases a <;> fin_cases b <;> simp
  have hkey : unitMatrix 0 4 * unitMatrix 4 4 * unitMatrix 4 4 =
      unitMatrix 0 4 := by
    rw [e1, e1]
  intro P X S hb
  have hz : (P * X * S) 0 4 = 0 := hb 0 4 (by decide)
  rw [show P * X * S = unitMatrix 0 4 from hkey] at hz
  simp [unitMatrix] at hz

end LocalHomotopyRadius
