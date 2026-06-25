import Mathlib

/-!
# NullEdgeP2MandelstamTraceIdentity

Standalone Aristotle target for the P2/P3 bridge.

The current P2 branch-reflection ladder has explicit two-, three-, and
four-reflection trace formulas for real `2 x 2` traceless matrices arising from
fixed-helicity chiral Hamiltonians. The next useful invariant package is the
standard `2 x 2` traceless trace reduction: the trace of a product of four
traceless matrices is determined by pairwise traces.

This is finite matrix algebra only. It does not yet assert a super-Dirac
curvature theorem, but it gives the algebraic bridge needed before mapping
four-reflection or diamond data to pairwise trace observables.
-/

noncomputable section

namespace NullEdgeP2MandelstamTraceIdentity

open Matrix

abbrev RMat2 := Matrix (Fin 2) (Fin 2) Real

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

The factor-two form avoids any unnecessary division assumptions and is the
clean finite statement that a four-trace is determined by pairwise two-traces.

The proof expands all `2 x 2` entries of the four-fold and pairwise products,
so the entry-level ring normalization needs a raised heartbeat budget.
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

end NullEdgeP2MandelstamTraceIdentity

end
