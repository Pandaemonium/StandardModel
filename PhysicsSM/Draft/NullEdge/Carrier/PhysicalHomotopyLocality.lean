import Mathlib

/-!
# Finite-range locality of physical channel homotopies

`ChannelPhysicalCohomology` identifies a chain map with zero physical action as
an exact endomorphism using the explicit homotopy

`S * X + (P * X) * S`.

This module supplies the missing quantitative locality theorem.  A finite
matrix is `MatrixBand d r` when entries farther than radius `r` vanish.  Under
a triangle inequality for `d`, radii add under matrix multiplication.  The
explicit physical homotopy and its exact correction therefore remain
finite-range with displayed radius budgets.

An exact rational path-graph witness attains the distance-two bound.  A second
fixture uses a distant projector entry and violates the radius-one conclusion,
showing that locality of the physical projector is load-bearing.

Scope: abstract finite matrix locality.  The theorem does not derive the
constraint, contraction, projector, or metric from the full null-edge carrier.
It states exactly what must be checked once those data are supplied.

Provenance: theorem shape supplied in Pro's 2026-07-11 blocker response.
Generic band algebra and exact fixtures were returned in Aristotle project
`d683a0c4-5272-4ca1-9260-d7df18d48a2c`; the two composition corollaries were
completed locally and the whole file was independently kernel-checked.

Lean 4.28.0.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.PhysicalHomotopyLocality

variable {I R : Type*} [Fintype I] [DecidableEq I] [Semiring R]

/-- A finite matrix has range at most `r` with respect to `d` when every entry
strictly farther than `r` vanishes. -/
def MatrixBand (d : I -> I -> Nat) (r : Nat) (A : Matrix I I R) : Prop :=
  forall i j, r < d i j -> A i j = 0

omit [Fintype I] [DecidableEq I] in
theorem MatrixBand.mono {d : I -> I -> Nat} {r t : Nat} {A : Matrix I I R}
    (hA : MatrixBand d r A) (hrt : r <= t) : MatrixBand d t A := by
  exact fun i j hij => hA i j (by linarith)

omit [Fintype I] [DecidableEq I] in
theorem MatrixBand.add {d : I -> I -> Nat} {r s : Nat} {A B : Matrix I I R}
    (hA : MatrixBand d r A) (hB : MatrixBand d s B) :
    MatrixBand d (max r s) (A + B) := by
  intro i j h
  rw [Matrix.add_apply, hA i j (by omega), hB i j (by omega), add_zero]

omit [DecidableEq I] in
/-- Matrix ranges add under composition. -/
theorem MatrixBand.mul {d : I -> I -> Nat}
    (htri : forall i k j, d i j <= d i k + d k j)
    {r s : Nat} {A B : Matrix I I R}
    (hA : MatrixBand d r A) (hB : MatrixBand d s B) :
    MatrixBand d (r + s) (A * B) := by
  intro i j hij
  simp [Matrix.mul_apply]
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
compose to a nonzero distance-two entry. -/
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
term immediately; locality of `P` cannot be omitted. -/
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

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PhysicalHomotopyLocality.explicitHomotopy_local' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms explicitHomotopy_local

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PhysicalHomotopyLocality.exactCorrection_local' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactCorrection_local

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PhysicalHomotopyLocality.sharp_local_homotopy_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sharp_local_homotopy_witness

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PhysicalHomotopyLocality.nonlocal_projector_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlocal_projector_control

end PhysicsSM.Draft.NullEdge.Carrier.PhysicalHomotopyLocality
