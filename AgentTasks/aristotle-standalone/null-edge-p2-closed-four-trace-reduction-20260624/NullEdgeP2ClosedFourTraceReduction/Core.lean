import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Tactic

/-!
# NullEdgeP2ClosedFourTraceReduction

Standalone Aristotle target for the closure-reduced four-trace theorem.

The P2 branch-coordinate sum rule says that four closed on-shell branch
coordinate vectors have six-pair trace sum `-4`. This file asks for the next
non-empty consequence: closure and unit normalization force opposite-pair trace
coincidences, and the ordered four-reflection trace reduces to a polynomial in
two independent pairwise trace channels.

This is still finite algebra, not yet a causal-diamond holonomy theorem. The
value is that a future diamond substitution map has a nontrivial closure-reduced
trace invariant to preserve.
-/

noncomputable section

namespace NullEdgeP2ClosedFourTraceReduction

open Matrix

abbrev RMat2 := Matrix (Fin 2) (Fin 2) Real

/-- Two-level chiral Hamiltonian for fixed helicity sign `h`. -/
def chiralHamiltonian (h p m : Real) : RMat2 :=
  !![-h * p, m; m, h * p]

/-- Branch reflection in scalar form. -/
def branchReflection (h p m E : Real) : RMat2 :=
  (1 / E) • chiralHamiltonian h p m

/-- Explicit real trace for a `2 x 2` matrix. -/
def trace2 (M : RMat2) : Real :=
  M 0 0 + M 1 1

/-- General traceless real `2 x 2` matrix in coordinates. -/
def tracelessMat (a b c : Real) : RMat2 :=
  !![a, b; c, -a]

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

/-- A branch reflection is explicitly a traceless coordinate matrix. -/
theorem branchReflection_eq_tracelessMat_coords
    (h p m E : Real) :
    branchReflection h p m E =
      tracelessMat (branchA h p E) (branchB m E) (branchB m E) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [branchReflection, chiralHamiltonian, tracelessMat, branchA, branchB,
      Matrix.smul_apply] <;> ring

/-- Pairwise trace formula for two traceless coordinate matrices. -/
theorem trace2_mul_tracelessMat_coords
    (a1 b1 c1 a2 b2 c2 : Real) :
    trace2 (tracelessMat a1 b1 c1 * tracelessMat a2 b2 c2) =
      2 * (a1 * a2) + b1 * c2 + b2 * c1 := by
  simp only [trace2, tracelessMat, Matrix.mul_apply, Fin.sum_univ_two]
  simp
  ring

/-- The matrix pair trace is exactly the coordinate dot-product trace. -/
theorem branchPairTrace_eq_coordPairTrace
    (h1 p1 m1 E1 h2 p2 m2 E2 : Real) :
    branchPairTrace h1 p1 m1 E1 h2 p2 m2 E2 =
      coordPairTrace (branchA h1 p1 E1) (branchB m1 E1)
        (branchA h2 p2 E2) (branchB m2 E2) := by
  sorry

-- Expanding every entry of the four-fold and pairwise `2 x 2` products before
-- `ring` exceeds the default heartbeat budget, hence the raised limit.
set_option maxHeartbeats 2000000 in
/-- Mandelstam-style trace reduction for four real traceless `2 x 2` matrices. -/
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

/-- Closure and unit normalization force opposite pair traces to coincide. -/
theorem coordPairTrace_opposite_pairs_eq_of_closed_unit
    (a1 b1 a2 b2 a3 b3 a4 b4 : Real)
    (hcloseA : a1 + a2 + a3 + a4 = 0)
    (hcloseB : b1 + b2 + b3 + b4 = 0)
    (hunit1 : a1 ^ 2 + b1 ^ 2 = 1)
    (hunit2 : a2 ^ 2 + b2 ^ 2 = 1)
    (hunit3 : a3 ^ 2 + b3 ^ 2 = 1)
    (hunit4 : a4 ^ 2 + b4 ^ 2 = 1) :
    coordPairTrace a1 b1 a2 b2 = coordPairTrace a3 b3 a4 b4 ∧
      coordPairTrace a1 b1 a3 b3 = coordPairTrace a2 b2 a4 b4 ∧
      coordPairTrace a1 b1 a4 b4 = coordPairTrace a2 b2 a3 b3 := by
  sorry

/--
Closed unit branch coordinates reduce the ordered four-reflection trace to
three opposite-pair channel traces.
-/
theorem trace2_mul_four_branchReflections_mandelstam_ordered_closed_unit
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
    let s12 := branchPairTrace h1 p1 m1 E1 h2 p2 m2 E2
    let s13 := branchPairTrace h1 p1 m1 E1 h3 p3 m3 E3
    let s14 := branchPairTrace h1 p1 m1 E1 h4 p4 m4 E4
    trace2 (branchReflection h4 p4 m4 E4 *
        branchReflection h3 p3 m3 E3 *
        branchReflection h2 p2 m2 E2 *
        branchReflection h1 p1 m1 E1) =
      (s12 ^ 2 - s13 ^ 2 + s14 ^ 2) / 2 := by
  sorry

/--
Closed unit branch coordinates reduce the ordered four-reflection trace to a
two-channel polynomial using the closure sum rule.
-/
theorem trace2_mul_four_branchReflections_mandelstam_ordered_closed_unit_two_channel
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
    let s12 := branchPairTrace h1 p1 m1 E1 h2 p2 m2 E2
    let s13 := branchPairTrace h1 p1 m1 E1 h3 p3 m3 E3
    trace2 (branchReflection h4 p4 m4 E4 *
        branchReflection h3 p3 m3 E3 *
        branchReflection h2 p2 m2 E2 *
        branchReflection h1 p1 m1 E1) =
      s12 ^ 2 + s12 * s13 + 2 * s12 + 2 * s13 + 2 := by
  sorry

end NullEdgeP2ClosedFourTraceReduction

end
