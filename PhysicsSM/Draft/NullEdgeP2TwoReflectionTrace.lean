import Mathlib

/-!
# Draft.NullEdgeP2TwoReflectionTrace

This module records the first non-parity scalar for products of two finite P2
branch reflections.

The determinant parity guardrail shows that determinant-only products carry
only reflection-count parity. The trace of a two-reflection product is the next
finite scalar: here it is proved by direct real `2 x 2` matrix algebra, without
eigenvalues, phases, arccosines, Lorentz groups, path sums, or continuum proper
time.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace

open Matrix

abbrev RMat2 := Matrix (Fin 2) (Fin 2) Real

/-- Two-level chiral Hamiltonian for fixed helicity sign `h`. -/
def chiralHamiltonian (h p m : Real) : RMat2 :=
  !![-h * p, m; m, h * p]

/-- Branch reflection in scalar form. -/
def branchReflection (h p m E : Real) : RMat2 :=
  E⁻¹ • chiralHamiltonian h p m

/-- Explicit trace for a real `2 x 2` matrix. -/
def trace2 (M : RMat2) : Real :=
  M 0 0 + M 1 1

/-- General traceless real `2 x 2` matrix in coordinates. -/
def tracelessMat (a b c : Real) : RMat2 :=
  !![a, b; c, -a]

-- Expanding every entry of the four-fold and pairwise `2 x 2` products before
-- `ring` exceeds the default heartbeat budget, hence the raised limit.
set_option maxHeartbeats 2000000 in
/--
Mandelstam-style trace reduction for four real traceless `2 x 2` matrices.

The factor-two form avoids any unnecessary division assumptions and is the
clean finite statement that a four-trace is determined by pairwise two-traces.
This is the algebraic guardrail behind later P2/P3 claims: a four-step trace is
not an independent scalar in the real traceless `2 x 2` model unless extra
geometric data are added.
-/
theorem trace2_mul_four_traceless_mandelstam
    (a1 b1 c1 a2 b2 c2 a3 b3 c3 a4 b4 c4 : Real) :
    2 *
        trace2 (tracelessMat a1 b1 c1 *
          tracelessMat a2 b2 c2 *
          tracelessMat a3 b3 c3 *
          tracelessMat a4 b4 c4) =
      trace2 (tracelessMat a1 b1 c1 * tracelessMat a2 b2 c2) *
          trace2 (tracelessMat a3 b3 c3 * tracelessMat a4 b4 c4) -
        trace2 (tracelessMat a1 b1 c1 * tracelessMat a3 b3 c3) *
          trace2 (tracelessMat a2 b2 c2 * tracelessMat a4 b4 c4) +
        trace2 (tracelessMat a1 b1 c1 * tracelessMat a4 b4 c4) *
          trace2 (tracelessMat a2 b2 c2 * tracelessMat a3 b3 c3) := by
  simp only [trace2, tracelessMat, Matrix.mul_apply, Fin.sum_univ_two]
  simp
  ring

/-- A branch reflection is explicitly a traceless coordinate matrix. -/
theorem branchReflection_eq_tracelessMat_coords
    (h p m E : Real) :
    branchReflection h p m E =
      tracelessMat (-(h * p) / E) (m / E) (m / E) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [branchReflection, chiralHamiltonian, tracelessMat, Matrix.smul_apply] <;> ring

/-- Pairwise trace formula for two traceless coordinate matrices. -/
theorem trace2_mul_tracelessMat_coords
    (a1 b1 c1 a2 b2 c2 : Real) :
    trace2 (tracelessMat a1 b1 c1 * tracelessMat a2 b2 c2) =
      2 * (a1 * a2) + b1 * c2 + b2 * c1 := by
  simp only [trace2, tracelessMat, Matrix.mul_apply, Fin.sum_univ_two]
  simp
  ring

/--
Pairwise branch-reflection trace formula, proved from explicit traceless
coordinates rather than treated as a separate convention.
-/
theorem trace2_mul_two_branchReflections_from_coords
    (h1 p1 m1 E1 h2 p2 m2 E2 : Real) :
    trace2 (branchReflection h2 p2 m2 E2 *
        branchReflection h1 p1 m1 E1) =
      2 * (h1 * h2 * p1 * p2 + m1 * m2) / (E1 * E2) := by
  rw [branchReflection_eq_tracelessMat_coords, branchReflection_eq_tracelessMat_coords,
    trace2_mul_tracelessMat_coords]
  ring

/--
Four-branch-reflection Mandelstam reduction in the exact trace-ladder order
`R4 * R3 * R2 * R1`.
-/
theorem trace2_mul_four_branchReflections_mandelstam_ordered
    (h1 p1 m1 E1 h2 p2 m2 E2 h3 p3 m3 E3 h4 p4 m4 E4 : Real) :
    let R1 := branchReflection h1 p1 m1 E1
    let R2 := branchReflection h2 p2 m2 E2
    let R3 := branchReflection h3 p3 m3 E3
    let R4 := branchReflection h4 p4 m4 E4
    2 * trace2 (R4 * R3 * R2 * R1) =
      trace2 (R4 * R3) * trace2 (R2 * R1) -
        trace2 (R4 * R2) * trace2 (R3 * R1) +
        trace2 (R4 * R1) * trace2 (R3 * R2) := by
  simp only [branchReflection_eq_tracelessMat_coords]
  exact trace2_mul_four_traceless_mandelstam _ _ _ _ _ _ _ _ _ _ _ _

/--
On-shell audit for the coordinate bridge: the square trace of one branch
reflection is `2`, matching the P2 trace-ladder convention.
-/
theorem trace2_branchReflection_sq_eq_two_on_massShell_from_coords
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    trace2 (branchReflection h p m E * branchReflection h p m E) = 2 := by
  rw [branchReflection_eq_tracelessMat_coords, trace2_mul_tracelessMat_coords]
  field_simp
  nlinarith [hshell, hh]

/-- First branch coordinate: signed spatial/chiral part. -/
def branchA (h p E : Real) : Real :=
  -(h * p) / E

/-- Second branch coordinate: mass/chirality-flip part. -/
def branchB (m E : Real) : Real :=
  m / E

/-- Pairwise trace in branch-coordinate form. -/
def coordPairTrace (a1 b1 a2 b2 : Real) : Real :=
  2 * (a1 * a2 + b1 * b2)

/-- Pairwise trace for two branch reflections, in trace-ladder order. -/
def branchPairTrace
    (h1 p1 m1 E1 h2 p2 m2 E2 : Real) : Real :=
  trace2 (branchReflection h2 p2 m2 E2 *
    branchReflection h1 p1 m1 E1)

/-- The matrix pair trace is exactly the coordinate dot-product trace. -/
theorem branchPairTrace_eq_coordPairTrace
    (h1 p1 m1 E1 h2 p2 m2 E2 : Real) :
    branchPairTrace h1 p1 m1 E1 h2 p2 m2 E2 =
      coordPairTrace (branchA h1 p1 E1) (branchB m1 E1)
        (branchA h2 p2 E2) (branchB m2 E2) := by
  unfold branchPairTrace
  rw [trace2_mul_two_branchReflections_from_coords]
  unfold coordPairTrace branchA branchB
  ring

/--
Closed unit coordinate vectors obey the six-pair Mandelstam sum rule.

This is the pure finite-algebra core: if four unit vectors in the branch
coordinate plane sum to zero, the sum of their six pairwise trace invariants is
fixed.
-/
theorem coordPairTrace_sum_eq_neg_four_of_closed_unit
    (a1 b1 a2 b2 a3 b3 a4 b4 : Real)
    (hcloseA : a1 + a2 + a3 + a4 = 0)
    (hcloseB : b1 + b2 + b3 + b4 = 0)
    (hunit1 : a1 ^ 2 + b1 ^ 2 = 1)
    (hunit2 : a2 ^ 2 + b2 ^ 2 = 1)
    (hunit3 : a3 ^ 2 + b3 ^ 2 = 1)
    (hunit4 : a4 ^ 2 + b4 ^ 2 = 1) :
    coordPairTrace a1 b1 a2 b2 +
      coordPairTrace a1 b1 a3 b3 +
      coordPairTrace a1 b1 a4 b4 +
      coordPairTrace a2 b2 a3 b3 +
      coordPairTrace a2 b2 a4 b4 +
      coordPairTrace a3 b3 a4 b4 = -4 := by
  unfold coordPairTrace
  linear_combination (a1 + a2 + a3 + a4) * hcloseA + (b1 + b2 + b3 + b4) * hcloseB
    - hunit1 - hunit2 - hunit3 - hunit4

/--
Branch-coordinate closure and unit normalization imply the six-pair
branch-reflection trace sum rule.
-/
theorem branchPairTrace_sum_eq_neg_four_of_coordClosed_unit
    (h1 p1 m1 E1 h2 p2 m2 E2 h3 p3 m3 E3 h4 p4 m4 E4 : Real)
    (hcloseA :
      branchA h1 p1 E1 + branchA h2 p2 E2 +
        branchA h3 p3 E3 + branchA h4 p4 E4 = 0)
    (hcloseB :
      branchB m1 E1 + branchB m2 E2 +
        branchB m3 E3 + branchB m4 E4 = 0)
    (hunit1 : branchA h1 p1 E1 ^ 2 + branchB m1 E1 ^ 2 = 1)
    (hunit2 : branchA h2 p2 E2 ^ 2 + branchB m2 E2 ^ 2 = 1)
    (hunit3 : branchA h3 p3 E3 ^ 2 + branchB m3 E3 ^ 2 = 1)
    (hunit4 : branchA h4 p4 E4 ^ 2 + branchB m4 E4 ^ 2 = 1) :
    branchPairTrace h1 p1 m1 E1 h2 p2 m2 E2 +
      branchPairTrace h1 p1 m1 E1 h3 p3 m3 E3 +
      branchPairTrace h1 p1 m1 E1 h4 p4 m4 E4 +
      branchPairTrace h2 p2 m2 E2 h3 p3 m3 E3 +
      branchPairTrace h2 p2 m2 E2 h4 p4 m4 E4 +
      branchPairTrace h3 p3 m3 E3 h4 p4 m4 E4 = -4 := by
  simp only [branchPairTrace_eq_coordPairTrace]
  exact coordPairTrace_sum_eq_neg_four_of_closed_unit _ _ _ _ _ _ _ _
    hcloseA hcloseB hunit1 hunit2 hunit3 hunit4

/-- On shell with `h*h = 1`, a branch coordinate vector has unit norm. -/
theorem branchCoord_norm_sq_eq_one_onMassShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    branchA h p E ^ 2 + branchB m E ^ 2 = 1 := by
  unfold branchA branchB
  field_simp
  linear_combination p ^ 2 * hh - hshell

/--
Mass-shell closure theorem: if four on-shell branch-coordinate vectors close,
their six pairwise branch-reflection traces sum to `-4`.
-/
theorem branchPairTrace_sum_eq_neg_four_of_closed_onMassShell
    (h1 p1 m1 E1 h2 p2 m2 E2 h3 p3 m3 E3 h4 p4 m4 E4 : Real)
    (hcloseA :
      branchA h1 p1 E1 + branchA h2 p2 E2 +
        branchA h3 p3 E3 + branchA h4 p4 E4 = 0)
    (hcloseB :
      branchB m1 E1 + branchB m2 E2 +
        branchB m3 E3 + branchB m4 E4 = 0)
    (hh1 : h1 * h1 = 1) (hE1 : E1 ≠ 0)
    (hshell1 : E1 ^ 2 = p1 ^ 2 + m1 ^ 2)
    (hh2 : h2 * h2 = 1) (hE2 : E2 ≠ 0)
    (hshell2 : E2 ^ 2 = p2 ^ 2 + m2 ^ 2)
    (hh3 : h3 * h3 = 1) (hE3 : E3 ≠ 0)
    (hshell3 : E3 ^ 2 = p3 ^ 2 + m3 ^ 2)
    (hh4 : h4 * h4 = 1) (hE4 : E4 ≠ 0)
    (hshell4 : E4 ^ 2 = p4 ^ 2 + m4 ^ 2) :
    branchPairTrace h1 p1 m1 E1 h2 p2 m2 E2 +
      branchPairTrace h1 p1 m1 E1 h3 p3 m3 E3 +
      branchPairTrace h1 p1 m1 E1 h4 p4 m4 E4 +
      branchPairTrace h2 p2 m2 E2 h3 p3 m3 E3 +
      branchPairTrace h2 p2 m2 E2 h4 p4 m4 E4 +
      branchPairTrace h3 p3 m3 E3 h4 p4 m4 E4 = -4 := by
  refine branchPairTrace_sum_eq_neg_four_of_coordClosed_unit
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ hcloseA hcloseB ?_ ?_ ?_ ?_
  · exact branchCoord_norm_sq_eq_one_onMassShell h1 p1 m1 E1 hh1 hE1 hshell1
  · exact branchCoord_norm_sq_eq_one_onMassShell h2 p2 m2 E2 hh2 hE2 hshell2
  · exact branchCoord_norm_sq_eq_one_onMassShell h3 p3 m3 E3 hh3 hE3 hshell3
  · exact branchCoord_norm_sq_eq_one_onMassShell h4 p4 m4 E4 hh4 hE4 hshell4

/--
Explicit trace formula for a product of two branch reflections. This is the
finite scalar that remains after determinant data collapses to parity.
-/
theorem trace2_mul_two_branchReflections_formula
    (h1 p1 m1 E1 h2 p2 m2 E2 : Real) :
    trace2 (branchReflection h2 p2 m2 E2 * branchReflection h1 p1 m1 E1) =
      2 * (h1 * h2 * p1 * p2 + m1 * m2) / (E1 * E2) := by
  simp [trace2, branchReflection, chiralHamiltonian, Matrix.mul_apply, Fin.sum_univ_two]
  ring

/-- The two-reflection trace scalar is symmetric under reversing the pair. -/
theorem trace2_mul_two_branchReflections_symm
    (h1 p1 m1 E1 h2 p2 m2 E2 : Real) :
    trace2 (branchReflection h2 p2 m2 E2 * branchReflection h1 p1 m1 E1) =
      trace2 (branchReflection h1 p1 m1 E1 * branchReflection h2 p2 m2 E2) := by
  rw [trace2_mul_two_branchReflections_formula]
  rw [trace2_mul_two_branchReflections_formula]
  ring

/-- On shell, the trace of a reflection composed with itself is `2`. -/
theorem trace2_branchReflection_sq_eq_two_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    trace2 (branchReflection h p m E * branchReflection h p m E) = 2 := by
  rw [trace2_mul_two_branchReflections_formula]
  field_simp
  nlinarith [hh, hshell]

/--
Three branch reflections have zero trace in the real two-generator P2 model.

This is the odd-length companion to the two-reflection trace formula. It says
that the next length after the two-reflection scalar does not by itself provide
a new trace observable. Any later four-reflection or causal-diamond trace claim
therefore needs explicit closure/geometric constraints rather than a generic
topological-invariance assumption.
-/
theorem trace2_mul_three_branchReflections_eq_zero
    (h1 p1 m1 E1 h2 p2 m2 E2 h3 p3 m3 E3 : Real) :
    trace2 (branchReflection h3 p3 m3 E3 *
        branchReflection h2 p2 m2 E2 *
        branchReflection h1 p1 m1 E1) = 0 := by
  simp only [branchReflection, chiralHamiltonian, smul_mul_assoc, mul_smul_comm,
    Matrix.mul_fin_two, trace2, Matrix.smul_apply, Matrix.of_apply, Matrix.cons_val',
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.empty_val',
    Matrix.cons_val_fin_one, smul_eq_mul]
  ring

/--
Explicit trace formula for four branch reflections in the current
`h,p,m,E` convention.

This is the finite capstone of the local trace ladder before adding separate
closure or causal-diamond hypotheses. The cross terms record orientation in the
real two-generator plane; the theorem does not assert any topological
invariance.
-/
theorem trace2_mul_four_branchReflections_formula
    (h1 p1 m1 E1 h2 p2 m2 E2 h3 p3 m3 E3 h4 p4 m4 E4 : Real) :
    trace2 (branchReflection h4 p4 m4 E4 *
        branchReflection h3 p3 m3 E3 *
        branchReflection h2 p2 m2 E2 *
        branchReflection h1 p1 m1 E1) =
      2 * ((((h1 * p1) * (h2 * p2) + m1 * m2) *
            ((h3 * p3) * (h4 * p4) + m3 * m4)) -
          ((m1 * (h2 * p2) - (h1 * p1) * m2) *
            (m3 * (h4 * p4) - (h3 * p3) * m4))) /
        (E1 * E2 * E3 * E4) := by
  unfold branchReflection trace2 chiralHamiltonian
  norm_num [Matrix.mul_apply]
  ring

/-- The diagonal four-reflection witness has trace `2`. -/
theorem trace2_four_diagWitness_eq_two :
    trace2 (branchReflection 1 1 0 1 *
        branchReflection 1 1 0 1 *
        branchReflection 1 1 0 1 *
        branchReflection 1 1 0 1) = 2 := by
  simp only [trace2, branchReflection, chiralHamiltonian]
  norm_num [Matrix.mul_fin_two, Matrix.smul_apply, Matrix.cons_val_zero,
    Matrix.cons_val_one]

/-- The alternating witness `B A B A` has trace `-2`. -/
theorem trace2_four_alternatingWitness_eq_neg_two :
    trace2 (branchReflection 1 0 1 1 *
        branchReflection 1 1 0 1 *
        branchReflection 1 0 1 1 *
        branchReflection 1 1 0 1) = -2 := by
  simp only [trace2, branchReflection, chiralHamiltonian]
  norm_num [Matrix.mul_fin_two, Matrix.smul_apply, Matrix.cons_val_zero,
    Matrix.cons_val_one]

/--
The unconstrained four-reflection trace is not constant on the simplest
on-shell branch-reflection witnesses.
-/
theorem trace2_four_branchReflections_nonconstant :
    trace2 (branchReflection 1 1 0 1 *
        branchReflection 1 1 0 1 *
        branchReflection 1 1 0 1 *
        branchReflection 1 1 0 1) ≠
      trace2 (branchReflection 1 0 1 1 *
        branchReflection 1 1 0 1 *
        branchReflection 1 0 1 1 *
        branchReflection 1 1 0 1) := by
  rw [trace2_four_diagWitness_eq_two, trace2_four_alternatingWitness_eq_neg_two]
  norm_num

end PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace

end
