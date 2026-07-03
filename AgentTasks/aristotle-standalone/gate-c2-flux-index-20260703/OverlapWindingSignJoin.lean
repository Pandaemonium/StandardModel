import Mathlib
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexWindingWitness
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate

/-!
# Gate C2: joining the winding witness to the sign certificate

This Draft module closes the C2a -> C2b loop for the minimal toy.  The winding
witness (`OverlapIndexWindingWitness`) exhibited an explicit involution `epsW`
with overlap index `1`, but `epsW` was CONSTRUCTED with the right signature (the
honesty caveat there).  Here we show `epsW` is a genuine **certified sign**
(`OverlapSignCertificate.SignCertificate`) of an explicit gapped Hermitian
operator `HU` - a diagonal **mass-defect** operator `diag(-2,-3,-1,5)` (three
negative "masses", one positive: a domain wall).  Because `epsW` satisfies the
finite positivity certificate for `HU`, `certifiedSign_unique` makes it THE sign
of `HU`, so the index `1` is a genuine sign-of-operator (domain-wall) index, not
merely a constructed signature.

## Scope honesty

`HU` here is a DIAGONAL mass-defect operator (a domain wall), not a hopping/link
operator carrying a nonzero gauge holonomy.  The domain-wall sign change is
exactly the mechanism the design brief identified ("a Wilson mass driven across
zero"), so this is a legitimate nonzero-index certified operator - but a fuller
C2b would use a non-diagonal `HU` with genuine link phases (block-diagonal w.r.t.
the `epsW`-eigenspaces, with hopping inside the negative-mass block).  That is the
documented successor.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **finite identity / consistency witness** (certified domain-wall
sign; no link holonomy).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace OverlapWindingSignJoin

open scoped ComplexOrder
open PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexWindingWitness
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate

/-- An explicit gapped Hermitian **mass-defect** operator on the 2-site line:
three negative masses and one positive mass (a domain wall).  Its sign is exactly
the winding witness involution `epsW`. -/
def HU : Matrix (Fin 4) (Fin 4) ℂ := Matrix.diagonal ![-2, -3, -1, 5]

/-- Explicit inverse of the diagonal mass-defect operator `HU`. -/
noncomputable def HUInv : Matrix (Fin 4) (Fin 4) ℂ :=
  Matrix.diagonal ![-(1 / 2 : ℂ), -(1 / 3 : ℂ), -1, 1 / 5]

/-- The explicit mass-defect operator is invertible, so it is gapped in the
finite-dimensional algebraic sense used by `certifiedSign_unique`. -/
noncomputable instance HU_invertible : Invertible HU where
  invOf := HUInv
  invOf_mul_self := by
    rw [HUInv, HU, Matrix.diagonal_mul_diagonal, ← Matrix.diagonal_one]
    congr 1
    funext i
    fin_cases i <;> norm_num
  mul_invOf_self := by
    rw [HUInv, HU, Matrix.diagonal_mul_diagonal, ← Matrix.diagonal_one]
    congr 1
    funext i
    fin_cases i <;> norm_num

/-- The explicit mass-defect operator is Hermitian. -/
theorem HU_isHermitian : HU.IsHermitian := by
  rw [HU, Matrix.isHermitian_diagonal_iff]
  intro i
  fin_cases i <;> simp [isSelfAdjoint_iff]

/-- `epsW * HU` is the positive diagonal `diag(2,3,1,5)`. -/
theorem epsW_mul_HU : epsW * HU = Matrix.diagonal ![2, 3, 1, 5] := by
  rw [epsW, HU, Matrix.diagonal_mul_diagonal]
  congr 1
  funext i
  fin_cases i <;> norm_num

/-- **The winding witness sign `epsW` is a certified sign of `HU`.**  This makes
the winding index a genuine sign-of-operator (domain-wall) index: by
`certifiedSign_unique`, `epsW` is THE sign of the gapped Hermitian `HU`. -/
theorem signCertificate_HU_epsW : SignCertificate HU epsW where
  involution := epsW_sq
  commute := by
    rw [epsW, HU, Matrix.diagonal_mul_diagonal, Matrix.diagonal_mul_diagonal]
    congr 1
    funext i
    fin_cases i <;> ring
  posSemidef := by
    rw [epsW_mul_HU]
    apply Matrix.PosSemidef.diagonal
    intro i
    fin_cases i <;> · rw [Complex.le_def]; norm_num

/-- Any certified sign of `HU` is the winding witness sign `epsW`.

This is the promised C2a -> C2b join in theorem form: the index-one witness is
not merely a chosen signature defect, but the unique certified sign of the
explicit gapped Hermitian mass-defect operator `HU`. -/
theorem signCertificate_HU_unique
    (eps : Matrix (Fin 4) (Fin 4) ℂ) (hc : SignCertificate HU eps) :
    eps = epsW :=
  certifiedSign_unique HU eps epsW HU_isHermitian hc signCertificate_HU_epsW

end OverlapWindingSignJoin
end GateC2
end NullEdge
end Draft
end PhysicsSM
