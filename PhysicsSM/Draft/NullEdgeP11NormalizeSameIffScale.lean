import Mathlib.Tactic

/-!
# P11 normalized state equality is scale equality up to trace

This package sharpens the calibrated-readout point: normalization alone loses
scale, and equality of normalized momentum blocks means the unnormalized blocks
are trace-scaled versions of each other.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP11NormalizeSameIffScale

abbrev MomentumBlock := Matrix (Fin 2) (Fin 2) Real

noncomputable def normalize (P : MomentumBlock) : MomentumBlock :=
  (P.trace)⁻¹ • P

theorem trace_smul_normalize (P : MomentumBlock) (h : P.trace ≠ 0) :
    P.trace • normalize P = P := by
  -- By definition of normalize, we have normalize P = (P.trace)⁻¹ • P.
  simp only [normalize]
  -- Since $Matrix.trace P \neq 0$, we can simplify the expression to $P$.
  simp [h, smul_smul]

theorem same_normalize_iff_trace_scaled
    (P Q : MomentumBlock) (hP : P.trace ≠ 0) (hQ : Q.trace ≠ 0) :
    normalize P = normalize Q <->
      Q.trace • P = P.trace • Q := by
  constructor <;> intro h <;> simp_all only [normalize]
  · apply_fun fun x => Matrix.trace P • Matrix.trace Q • x at h
    simp_all [smul_smul, mul_comm]
  · convert congr_arg (fun x => (Matrix.trace Q)⁻¹ • (Matrix.trace P)⁻¹ • x) h using 1 <;>
      simp [hP, hQ, smul_smul, mul_comm]

theorem same_normalize_of_scalar_multiple
    (P : MomentumBlock) (r : Real) (_hP : P.trace ≠ 0) (hr : r ≠ 0) :
    normalize (r • P) = normalize P := by
  -- By definition of normalize, we have normalize (r • P) = (1 / (r *Trace P)) * (r • P).
  simp only [normalize]
  simp [hr, smul_smul]

end PhysicsSM.Draft.NullEdgeP11NormalizeSameIffScale
