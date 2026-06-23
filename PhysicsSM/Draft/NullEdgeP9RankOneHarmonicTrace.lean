import Mathlib.Tactic

/-!
# Rank-one harmonic trace toy model for P9

This module integrates Aristotle project
`a775c905-af53-4cba-8b49-81d5822fdc10`.

It is a finite linear-algebra spine for the P9 source-visibility program. It
models the harmonic channel of a single cycle as the mean/constant projector on
`Fin n -> Real`.

Scientific role: the numerical pilot shows that the projected-noise trace on a
cycle stays `O(1)` while the number of cells grows. The theorem below proves
the corresponding toy algebra: the trace of the rank-one mean projector is
exactly `1`, so its trace density is `1 / n`.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdgeP9RankOneHarmonicTrace

/-- Coordinate basis vector. -/
def standardBasis {n : Nat} (i : Fin n) : Fin n -> Real :=
  fun j => if j = i then 1 else 0

/-- Naive coordinate trace of an endomorphism on `Fin n -> Real`. -/
def coordinateTrace {n : Nat} (T : (Fin n -> Real) -> (Fin n -> Real)) : Real :=
  Finset.univ.sum fun i : Fin n => T (standardBasis i) i

/-- The rank-one projector onto constant vectors, written as the cell mean. -/
def meanProjector (n : Nat) (f : Fin n -> Real) : Fin n -> Real :=
  fun _ => (Finset.univ.sum fun i : Fin n => f i) / (n : Real)

/-- Each coordinate-basis vector contributes `1 / n` to the trace. -/
theorem meanProjector_basis_diag {n : Nat} [NeZero n] (i : Fin n) :
    meanProjector n (standardBasis i) i = (1 : Real) / (n : Real) := by
  unfold meanProjector standardBasis
  rw [Finset.sum_ite_eq' Finset.univ i (fun _ => (1 : Real))]
  simp

/-- The rank-one mean projector has trace `1`. -/
theorem meanProjector_trace_eq_one {n : Nat} [NeZero n] :
    coordinateTrace (meanProjector n) = (1 : Real) := by
  unfold coordinateTrace
  rw [Finset.sum_congr rfl (fun i _ => meanProjector_basis_diag i)]
  rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin]
  rw [nsmul_eq_mul]
  have hn : Not ((n : Real) = 0) := Nat.cast_ne_zero.mpr (NeZero.ne n)
  field_simp

/-- The trace density of the rank-one harmonic channel is `1 / n`. -/
theorem meanProjector_trace_density {n : Nat} [NeZero n] :
    coordinateTrace (meanProjector n) / (n : Real) = (1 : Real) / (n : Real) := by
  rw [meanProjector_trace_eq_one]

end PhysicsSM.Draft.NullEdgeP9RankOneHarmonicTrace

end
