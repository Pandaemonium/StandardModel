import Mathlib

/-!
# Ordered tetrahedral Weyl-projector paths

This module supplies the first order-sensitive spin-amplitude layer above
`TetrahedralNullHistory`.  Four regular-tetrahedron directions are contracted
with the Pauli matrices.  Under the exact normalization `3 * r^2 = 1`, the
associated Weyl projectors are Hermitian rank-one idempotents, resolve twice
the identity, and obey an exact bend law

```text
P_i P_j P_i = (1/3) P_i,  i != j.
```

Chronological histories multiply projectors in operator-composition order.
The ordered three-direction traces are `+I*r/3` and `-I*r/3` under reversal,
so the path amplitude remembers orientation and does not collapse to endpoint
counts.

Boundary: this is an exact ordered-projector amplitude, not an exactly unitary
massive tetrahedral update, a sum over all `3+1` histories, or a continuum
propagator.

Provenance: Aristotle project `9b4990af-d0bf-4f76-8bd8-ce5cfd12edb5`,
reviewed and checked under the pinned Lean 4.28.0 toolchain.  The Pauli and
regular-tetrahedron conventions are defined explicitly below.
-/

open Matrix Complex
open scoped BigOperators ComplexConjugate

namespace PhysicsSM.Draft.NullEdge.TetrahedralSpinProjectorPath

abbrev Dir := Fin 4
abbrev Spatial := Fin 3 → ℝ
abbrev SpinMat := Matrix (Fin 2) (Fin 2) ℂ

/-- Unnormalized regular-tetrahedron directions. -/
def w : Dir → Spatial :=
  ![![1, 1, 1], ![1, -1, -1], ![-1, 1, -1], ![-1, -1, 1]]

def sigmaX : SpinMat := !![0, 1; 1, 0]
def sigmaY : SpinMat := !![0, -I; I, 0]
def sigmaZ : SpinMat := !![1, 0; 0, -1]

/-- Pauli contraction with normalized tetrahedral direction `r * w_i`. -/
def spinDirection (r : ℝ) (i : Dir) : SpinMat :=
  (r : ℂ) •
    ((w i 0 : ℂ) • sigmaX + (w i 1 : ℂ) • sigmaY +
      (w i 2 : ℂ) • sigmaZ)

/-- Rank-one Weyl spin projector in tetrahedral direction `i`. -/
noncomputable def projector (r : ℝ) (i : Dir) : SpinMat :=
  (1 / 2 : ℂ) • (1 + spinDirection r i)

/-- Chronological histories multiply projectors in composition order. -/
noncomputable def pathProjector (r : ℝ) : List Dir → SpinMat
  | [] => 1
  | i :: is => pathProjector r is * projector r i

/-- Exact regular-tetrahedron Gram law before normalization. -/
theorem w_dot (i j : Dir) :
    (∑ a, w i a * w j a) = if i = j then 3 else -1 := by
  fin_cases i <;> fin_cases j <;> norm_num [Fin.sum_univ_succ, w]

/-- The Pauli contraction is an involution after exact normalization. -/
theorem spinDirection_sq (r : ℝ) (hr : 3 * r ^ 2 = 1) (i : Dir) :
    spinDirection r i * spinDirection r i = 1 := by
  unfold spinDirection;
  fin_cases i <;> ext a b <;> fin_cases a <;> fin_cases b <;> norm_num [ Matrix.mul_apply, sigmaX, sigmaY, sigmaZ, w ];
  all_goals repeat erw [ Matrix.cons_val_succ' ] ; norm_num ; ring_nf ; norm_num [ Complex.ext_iff, sq ] at * <;> nlinarith;
  all_goals ring!;

/-- Each tetrahedral Weyl projector is idempotent. -/
theorem projector_idempotent (r : ℝ) (hr : 3 * r ^ 2 = 1) (i : Dir) :
    projector r i * projector r i = projector r i := by
  unfold projector;
  convert congrArg
    (fun x : SpinMat => (1 / 4 : ℂ) • (1 + 2 • spinDirection r i + x))
    (spinDirection_sq r hr i) using 1 <;>
    norm_num [mul_add, add_mul, smul_smul, two_smul] ; ring;
  · abel1;
  · module

/-- Each tetrahedral Weyl projector is Hermitian. -/
theorem projector_hermitian (r : ℝ) (i : Dir) :
    (projector r i)ᴴ = projector r i := by
  fin_cases i <;> ext a b <;> simp +decide [projector, spinDirection]
  · fin_cases a <;> fin_cases b <;>
      norm_num [Complex.ext_iff, sigmaX, sigmaY, sigmaZ]
    all_goals ring
  · fin_cases a <;> fin_cases b <;>
      norm_num [Matrix.one_apply, sigmaX, sigmaY, sigmaZ]
    all_goals ring
  · fin_cases a <;> fin_cases b <;>
      norm_num [Complex.ext_iff, sigmaX, sigmaY, sigmaZ]
    all_goals ring
  · fin_cases a <;> fin_cases b <;>
      norm_num [Complex.ext_iff, sigmaX, sigmaY, sigmaZ]
    all_goals ring

/-- Each projector has trace one. -/
theorem projector_trace (r : ℝ) (i : Dir) :
    (projector r i).trace = 1 := by
  fin_cases i <;> simp +decide [projector, spinDirection, sigmaX, sigmaY, sigmaZ]

/-- The four projectors resolve twice the identity. -/
theorem projector_resolution (r : ℝ) :
    ∑ i : Dir, projector r i = (2 : ℂ) • (1 : SpinMat) := by
  unfold projector
  simp [spinDirection, w]
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply, Fin.sum_univ_succ] <;> ring

/-- Distinct tetrahedral projectors have exact overlap `1/3`. -/
theorem projector_pair_trace
    (r : ℝ) (hr : 3 * r ^ 2 = 1) (i j : Dir) (hij : i ≠ j) :
    (projector r i * projector r j).trace = 1 / 3 := by
  unfold projector spinDirection
  simp +decide [Matrix.trace, Matrix.mul_apply, sigmaX, sigmaY, sigmaZ, w]
  fin_cases i <;> fin_cases j <;> simp +decide at hij ⊢ <;>
    ring_nf <;> norm_num [Complex.ext_iff, sq] at *
  all_goals linarith

/-- A direction change attenuates the rank-one projector by exactly one third. -/
theorem projector_bend_sandwich
    (r : ℝ) (hr : 3 * r ^ 2 = 1) (i j : Dir) (hij : i ≠ j) :
    projector r i * projector r j * projector r i =
      (1 / 3 : ℂ) • projector r i := by
  have := @w_dot
  simp_all +decide [Fin.sum_univ_three]
  unfold projector spinDirection
  simp +decide [Matrix.one_fin_two, sigmaX, sigmaY, sigmaZ]
  norm_num [Complex.ext_iff, sq] at *
  grind

/-- Concatenating histories composes their ordered projector amplitudes. -/
theorem pathProjector_append (r : ℝ) (xs ys : List Dir) :
    pathProjector r (xs ++ ys) = pathProjector r ys * pathProjector r xs := by
  induction' xs with i xs ih generalizing ys
  · exact Eq.symm (mul_one _)
  · simp_all +decide [mul_assoc, pathProjector]

/-- A three-direction ordered history carries a nonzero imaginary spin phase. -/
theorem ordered_three_phase
    (r : ℝ) (hr : 3 * r ^ 2 = 1) :
    (projector r 0 * projector r 1 * projector r 2).trace = I * r / 3
      ∧ (projector r 2 * projector r 1 * projector r 0).trace = -I * r / 3 := by
  norm_num [projector, spinDirection, sigmaX, sigmaY, sigmaZ, w]
  simp +decide [Matrix.trace, Matrix.mul_apply]
  ring_nf
  norm_num [Complex.ext_iff, sq] at *
  norm_cast
  norm_num [show r ^ 3 = r * r ^ 2 by ring,
    show r ^ 2 = 1 / 3 by linarith]
  ring_nf
  norm_num
  grind

/-- Reversing three-direction order changes the amplitude. -/
theorem ordered_three_ne_reverse
    (r : ℝ) (hr : 3 * r ^ 2 = 1) (hr0 : r ≠ 0) :
    (projector r 0 * projector r 1 * projector r 2).trace ≠
      (projector r 2 * projector r 1 * projector r 0).trace := by
  have h_trace_eq :
      (projector r 0 * projector r 1 * projector r 2).trace = Complex.I * r / 3
        ∧ (projector r 2 * projector r 1 * projector r 0).trace =
          -Complex.I * r / 3 := by
    convert ordered_three_phase r hr using 1
  simp_all +decide [Complex.ext_iff, div_eq_mul_inv]
  cases lt_or_gt_of_ne hr0 <;> norm_num <;> linarith

/-- Compact exact ordered-projector verdict for the first `3+1` spin-path rung. -/
theorem tetrahedral_spin_projector_path_verdict
    (r : ℝ) (hr : 3 * r ^ 2 = 1) (hr0 : r ≠ 0) :
    (∀ i : Dir, projector r i * projector r i = projector r i)
      ∧ (∑ i : Dir, projector r i = (2 : ℂ) • (1 : SpinMat))
      ∧ (∀ i j : Dir, i ≠ j →
          projector r i * projector r j * projector r i =
            (1 / 3 : ℂ) • projector r i)
      ∧ (projector r 0 * projector r 1 * projector r 2).trace = I * r / 3
      ∧ (projector r 0 * projector r 1 * projector r 2).trace ≠
          (projector r 2 * projector r 1 * projector r 0).trace
      ∧ (∀ xs ys : List Dir,
          pathProjector r (xs ++ ys) =
            pathProjector r ys * pathProjector r xs) := by
  refine ⟨fun i => projector_idempotent r hr i, projector_resolution r,
    fun i j hij => projector_bend_sandwich r hr i j hij,
    (ordered_three_phase r hr).1, ordered_three_ne_reverse r hr hr0,
    fun xs ys => pathProjector_append r xs ys⟩

end PhysicsSM.Draft.NullEdge.TetrahedralSpinProjectorPath

/-! ## Build-enforced axiom-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.TetrahedralSpinProjectorPath.ordered_three_phase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetrahedralSpinProjectorPath.ordered_three_phase

/-- info: 'PhysicsSM.Draft.NullEdge.TetrahedralSpinProjectorPath.tetrahedral_spin_projector_path_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetrahedralSpinProjectorPath.tetrahedral_spin_projector_path_verdict
