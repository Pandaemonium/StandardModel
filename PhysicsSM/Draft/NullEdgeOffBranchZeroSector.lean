import Mathlib
import PhysicsSM.Draft.NullEdgeNodalSetExhaustion
import PhysicsSM.Draft.NullEdgeCompositeZeroEscape

/-!
# C69 Gate C audit: the off-branch zero sector

This module is the small Lean companion to the Wave 16 / C69 audit report
`AgentTasks/null-edge-off-branch-zero-sector-audit-report.md`.

C64 (`PhysicsSM.Draft.NullEdgeNodalSetExhaustion`) proved that the certified
nodal components (origin + the four branch lines) do **not** exhaust the bare
determinant-zero locus: there is an explicit off-branch Clifford-determinant zero

```text
q⋆ = (2π/3, 0, 0, 4π/3),
```

which the `g5` species-split term does not gap.  The natural follow-up question
for Gate C is: what would it take to certify that *every* off-branch zero is
harmless (discarded by projection, resolved by a composite field, or otherwise
ghost-safe)?

This module does three honest things and **claims nothing more**:

1. it names the *off-branch zero sector* as a predicate (`OffBranchZero`);
2. it records that the sector is genuinely inhabited, reusing the C64 witness
   (`offBranch_nonempty`);
3. it states the *exact discharge obligation* needed (a composite/projection
   escape certificate à la C62 attached to every off-branch zero,
   `OffBranchSectorDischarged`) and proves the **reduction** that such a
   certificate would deliver ghost-zero safety for the whole sector
   (`offBranch_discharged_ghostSafe`), via `CompositeRemovable.not_fatal`.

No discharge certificate is provided here: inhabiting `OffBranchSectorDischarged`
on the actual projected operator data is the open C69 obligation, and the report
documents exactly which symbol/projector/residue computation is still missing.
The reduction is stated so that supplying that data is a definitional
substitution, exactly in the style of the C59/C62 release API.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeOffBranchZeroSector

open PhysicsSM.Draft.TetrahedralNullBranch (qform pCov mink pSq_mink_eq_qform)
open PhysicsSM.Draft.NullEdgeSpectralGraphNodalSet (phaseU branchLineU)
open PhysicsSM.Draft.NullEdgeNodalSetExhaustion
  (extraPhase extra_qform_zero extra_ne_origin extra_not_on_branchLine)
open PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety (ZeroDatum)
open PhysicsSM.Draft.NullEdgeCompositeZeroEscape (Sym CompositeRemovable)

/-- The **off-branch zero sector**: scalar (equivalently Clifford-determinant)
determinant-zero phase vectors that are nonzero and lie on **none** of the four
certified branch lines.  This is precisely the locus C64 showed is not controlled
by the four-branch nodal clause. -/
def OffBranchZero (q : Fin 4 → ℝ) : Prop :=
  qform (phaseU q) = 0 ∧
  phaseU q ≠ 0 ∧
  (∀ (a : Fin 4) (t : ℝ), phaseU q ≠ branchLineU a t)

/-- Every off-branch zero is also a full Clifford-symbol determinant zero
(`mink (pCov ·) = 0`), via `pSq_mink_eq_qform`. -/
theorem OffBranchZero.mink_zero {q : Fin 4 → ℝ} (h : OffBranchZero q) :
    mink (pCov (phaseU q)) = 0 := by
  rw [pSq_mink_eq_qform]; exact h.1

/-- **The off-branch zero sector is inhabited** by the C64 witness
`q⋆ = (2π/3, 0, 0, 4π/3)`.  So the sector is not vacuous: any Gate C release that
ignores it is ignoring a genuine determinant-zero point. -/
theorem offBranch_nonempty : OffBranchZero extraPhase :=
  ⟨extra_qform_zero, extra_ne_origin, extra_not_on_branchLine⟩

/-- **The exact discharge obligation** for the off-branch zero sector.

A discharge certificate is: an assignment of a Dirac/inverse-propagator symbol
`D q` and a classified `ZeroDatum` `Z q` to every off-branch zero `q`, such that
each is `CompositeRemovable` — i.e. its kernel mode is removed by a non-invertible
physical-sector projection or resolved in an enlarged elementary-plus-composite
basis (C62 `AlgebraicEscape`), **and** the physical gauge-response contract
holds (`Z q` does not propagate as a gauge-coupled state).  This is the strongest
form of "discarded / composite-removable / ghost-safe" that the C62 calculus can
certify without weakening any statement. -/
def OffBranchSectorDischarged {n : ℕ}
    (D : (Fin 4 → ℝ) → Sym n) (Z : (Fin 4 → ℝ) → ZeroDatum) : Prop :=
  ∀ q, OffBranchZero q → CompositeRemovable (D q) (Z q)

/-- **Reduction theorem.**  A discharge certificate for the off-branch sector
delivers ghost-zero safety on the whole sector: no off-branch zero is a fatal
Golterman–Shamir ghost.  (Proof: `CompositeRemovable.not_fatal`.)

This is the precise content that would let Gate C Clause 1 be honestly upgraded
from *four-branch* nodal control to *full-locus* nodal control.  It is an
implication only: producing the certificate `OffBranchSectorDischarged` on the
real projected operator data remains the open obligation. -/
theorem offBranch_discharged_ghostSafe {n : ℕ}
    (D : (Fin 4 → ℝ) → Sym n) (Z : (Fin 4 → ℝ) → ZeroDatum)
    (h : OffBranchSectorDischarged D Z) :
    ∀ q, OffBranchZero q → ¬ (Z q).IsFatalGhost :=
  fun q hq => (h q hq).not_fatal

/-- **Audit corollary.**  The off-branch sector is simultaneously (a) inhabited
and (b) reducible: it has a genuine member `q⋆`, and any discharge certificate
makes the whole sector ghost-safe.  The gap between (a) and the hypothesis of (b)
— a certificate that actually covers `q⋆` — is exactly the open C69 obligation. -/
theorem offBranch_audit_status :
    OffBranchZero extraPhase ∧
    (∀ {n : ℕ} (D : (Fin 4 → ℝ) → Sym n) (Z : (Fin 4 → ℝ) → ZeroDatum),
      OffBranchSectorDischarged D Z → ∀ q, OffBranchZero q → ¬ (Z q).IsFatalGhost) :=
  ⟨offBranch_nonempty, fun D Z h => offBranch_discharged_ghostSafe D Z h⟩

end PhysicsSM.Draft.NullEdgeOffBranchZeroSector
