import Mathlib
import PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy

/-!
# Gate C2: integrality of the finite overlap chiral index

This Draft module proves that the finite lattice overlap chiral index
`OverlapIndexToy.overlapIndex gamma5 eps` (defined as the trace of the Luscher
GW-modified chirality) is an **integer**, for any chirality involution `gamma5`
and any sign-like involution `eps` on a finite complex spin space.

This is the first genuinely index-theoretic (Gate C2) statement of the program:
the abstract GW index *algebra* already lives in
`GateC1.OverlapIndexToy` (`overlapIndex_eq : overlapIndex = (1/2)(Tr gamma5 - Tr
eps)`), and here we upgrade the *value* from a bare complex number to a certified
integer - the defining feature of a topological index.

## Strategy

The half-integer-looking combination collapses to a difference of eigenprojector
ranks.  Writing `specProj M = (1 + M)/2` for the `+1` spectral projector of an
involution `M`, pure trace algebra gives

    overlapIndex gamma5 eps = Tr (specProj gamma5) - Tr (specProj eps)

(`overlapIndex_eq_specProj_sub`).  Each `specProj M` is an **idempotent** matrix
(`specProj_mul_self`, from `M^2 = 1`), and the trace of an idempotent over a
characteristic-zero field is the natural-number rank of its range
(`LinearMap.IsProj.trace` transported through `Matrix.trace_toLin'_eq`).  Hence
each trace is a natural number and their difference is an integer
(`overlapIndex_isInteger`).

Note the result needs only the **involution** property `M^2 = 1`, not
Hermiticity: trace-of-idempotent = rank holds for any idempotent over `ℂ`.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (finite index integrality; no gauge
background, no functional calculus, no continuum limit).  Successor: connecting
`overlapIndex` to a gauge-decorated tetrahedral operator, where the topological
charge becomes nonzero.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace OverlapIndexIntegrality

open PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
open LinearMap

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- The `+1` spectral projector of a matrix, `(1 + M)/2`. -/
def specProj (M : Matrix Spin Spin ℂ) : Matrix Spin Spin ℂ :=
  (2 : ℂ)⁻¹ • ((1 : Matrix Spin Spin ℂ) + M)

/-- For an involution `M` (`M * M = 1`), the spectral projector `(1 + M)/2` is
idempotent. -/
theorem specProj_mul_self (M : Matrix Spin Spin ℂ)
    (hM : M * M = (1 : Matrix Spin Spin ℂ)) :
    specProj M * specProj M = specProj M := by
  unfold specProj
  rw [Matrix.smul_mul, Matrix.mul_smul, smul_smul]
  have hexp : ((1 : Matrix Spin Spin ℂ) + M) * (1 + M)
      = (2 : ℂ) • ((1 : Matrix Spin Spin ℂ) + M) := by
    have h : ((1 : Matrix Spin Spin ℂ) + M) * (1 + M)
        = 1 + M + M + M * M := by noncomm_ring
    rw [h, hM]; module
  rw [hexp, smul_smul,
    show (2 : ℂ)⁻¹ * (2 : ℂ)⁻¹ * (2 : ℂ) = (2 : ℂ)⁻¹ from by norm_num]

/-- **Index as a difference of eigenprojector traces.**  Pure trace algebra: the
`(1/2)(Tr gamma5 - Tr eps)` form of the index equals `Tr (specProj gamma5) - Tr
(specProj eps)` (the `Tr 1 = card` contributions cancel). -/
theorem overlapIndex_eq_specProj_sub (gamma5 eps : Matrix Spin Spin ℂ)
    (hg : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ)) :
    overlapIndex gamma5 eps
      = (specProj gamma5).trace - (specProj eps).trace := by
  rw [overlapIndex_eq gamma5 eps hg]
  unfold specProj
  rw [Matrix.trace_smul, Matrix.trace_smul, Matrix.trace_add, Matrix.trace_add,
    Matrix.trace_one]
  simp only [smul_eq_mul]
  ring

/-- The trace of the spectral projector of an involution is a **natural number**
(the rank of its range): `Tr (specProj M) = finrank (range (specProj M).toLin')`.
This is the trace-of-idempotent = rank fact, over the characteristic-zero field
`ℂ`. -/
theorem specProj_trace_eq_finrank (M : Matrix Spin Spin ℂ)
    (hM : M * M = (1 : Matrix Spin Spin ℂ)) :
    (specProj M).trace
      = (Module.finrank ℂ (LinearMap.range ((specProj M).toLin')) : ℂ) := by
  have hidemL : IsIdempotentElem ((specProj M).toLin') := by
    show (specProj M).toLin' * (specProj M).toLin' = (specProj M).toLin'
    rw [Module.End.mul_eq_comp, ← Matrix.toLin'_mul, specProj_mul_self M hM]
  have htr := hidemL.isProj_range.trace
  rwa [Matrix.trace_toLin'_eq] at htr

/-- **Integrality of the finite overlap chiral index.**  For any chirality
involution `gamma5` and sign-like involution `eps`, the index
`overlapIndex gamma5 eps` is an integer - it is the difference of the ranks of
the two `+1` spectral projectors.  This is the finite, algebraic core of the
statement that a Ginsparg-Wilson index is topological (integer-valued). -/
theorem overlapIndex_isInteger (gamma5 eps : Matrix Spin Spin ℂ)
    (hg : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (he : eps * eps = (1 : Matrix Spin Spin ℂ)) :
    ∃ k : ℤ, overlapIndex gamma5 eps = (k : ℂ) := by
  refine ⟨(Module.finrank ℂ (LinearMap.range ((specProj gamma5).toLin')) : ℤ)
      - (Module.finrank ℂ (LinearMap.range ((specProj eps).toLin')) : ℤ), ?_⟩
  rw [overlapIndex_eq_specProj_sub gamma5 eps hg,
    specProj_trace_eq_finrank gamma5 hg, specProj_trace_eq_finrank eps he]
  push_cast
  ring

end OverlapIndexIntegrality
end GateC2
end NullEdge
end Draft
end PhysicsSM
