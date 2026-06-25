import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Tactic

/-!
# NullEdgeP2BranchReflectionMandelstam

Standalone Aristotle target for the P2 branch-reflection Mandelstam
instantiation.

The previous package proved that the trace of a four-fold product of real
traceless `2 x 2` matrices is determined by pairwise two-traces. This package
specializes that finite algebra to the P2 branch reflections used in the
null-edge trace ladder.

The point is deliberately modest but important: in the real two-generator
branch-reflection model, the four-step scalar trace contains no independent
data beyond pairwise trace observables. Later causal-diamond or super-Dirac
claims must therefore add an explicit geometric substitution map rather than
promoting a generic four-trace into curvature by vocabulary alone.
-/

noncomputable section

namespace NullEdgeP2BranchReflectionMandelstam

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

-- Expanding every entry of the four-fold and pairwise `2 x 2` products before
-- `ring` exceeds the default heartbeat budget, hence the raised limit.
set_option maxHeartbeats 2000000 in
/--
Mandelstam-style trace reduction for four real traceless `2 x 2` matrices.

This theorem is copied from the proof-complete previous standalone package so
that the current Aristotle job remains focused and does not import the full
project.
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
  simp; ring

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
reflection is `2`, matching the existing P2 trace-ladder convention.
-/
theorem trace2_branchReflection_sq_eq_two_on_massShell_from_coords
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    trace2 (branchReflection h p m E * branchReflection h p m E) = 2 := by
  rw [branchReflection_eq_tracelessMat_coords, trace2_mul_tracelessMat_coords]
  field_simp
  nlinarith [hshell, hh]

end NullEdgeP2BranchReflectionMandelstam

end
