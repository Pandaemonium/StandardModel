import Mathlib
import PhysicsSM.Draft.NullEdgeGaugeCovariantBranchProjectors
import PhysicsSM.Draft.NullEdgeProjectedGateCRelease

/-!
# C63: post-gauge ghost-safety / residue clause for the projected Route-B sector

This module instantiates **clause 6** (`GhostZeroSafe`) of the C59 projected /
species-split Gate C release certificate
(`PhysicsSM.Draft.NullEdgeProjectedGateCRelease.ProjectedGateCRelease`) for the
*projected, link-dressed* Route-B physical sector.

It does **not** invent a parallel release certificate.  It works against the
existing seven-clause API of C59:

* `ProjData` and the seven clauses `NodalSetControlled`,
  `BranchProjectorsControlled`, `ProjectedKernelOneDim`,
  `ProjectedChiralityAligned`, `ProjectedKreinPositive`, `GhostZeroSafe`,
  `SpeciesSplittingAudited` are **reused verbatim** from C59
  (`PhysicsSM.Draft.NullEdgeProjectedGateCRelease`);
* the ghost-zero calculus (`ZeroDatum`, `ZeroDatum.IsFatalGhost`,
  `GhostZeroSafe` on `List ZeroDatum`, `ghostZeroSafe_iff`,
  `ghostZeroSafe_of_no_fatal_label`, `KreinPositivePhysicalSector`,
  `PostGaugeGhostSafe`, witnesses) is **reused verbatim** from C47/C48
  (`PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety`);
* the gauge-covariant link-dressed branch projector
  (`DressedBranchProjector`, `GaugeCovariant`) is **reused verbatim** from C61
  (`PhysicsSM.Draft.NullEdgeGaugeCovariantBranchProjectors`).

## What is proved

1. A **projected physical-sector zero datum** (`ProjectedZeroSector`) bundling the
   C59 projected/species-split dataset with the C61 gauge-covariant link-dressed
   branch projector *introducing the very same classified zero spectrum*
   (`zeros_compat`).  This is the object compatible with the branch projector,
   species split, and gauge-covariant projector APIs at once.

2. The **residue-control** assumption (`ResidueControlled`) — every gauge-coupled
   propagating zero keeps a nonnegative Krein residue — is shown to be *exactly
   equivalent* to spectrum-level ghost-zero safety
   (`residueControlled_iff_ghostSafe`).  This pins down precisely what must be
   established about the projected modes.

3. **Conditional clause-6 instantiation** (`projectedSector_ghostZeroSafe`,
   `projectedSector_ghostZeroSafe_of_labels`): under the strongest assumptions
   already formalized (residue control, or honest non-fatal classification of
   every zero), the retained projected modes are not Golterman–Shamir fatal
   ghosts, i.e. C59 clause 6 holds.

4. **Reduction to the open post-gauge obligation**
   (`ghostZeroSafe_of_postGaugeConst`): clause 6 follows from the C47
   `PostGaugeGhostSafe` contract for the constant weak-coupling deformation of the
   enumerated spectrum.  This is the precise sense in which clause 6 is *reduced
   to* — not magically discharged by — the open C58 weak-coupling obligation.

5. **Full release** (`projectedSector_release`): the six other C59 clauses plus
   residue control entail the bundled `ProjectedGateCRelease`, via C59
   `projected_gateC_release`.  Non-vacuity is witnessed by `releasedSector`.

6. The **blocked-clause guardrail**
   (`chirality_index_covariance_not_ghostSafe`): projected chirality alignment, a
   nonzero flavored index, **and** gauge covariance of the link-dressed projector
   together still do **not** entail ghost-zero safety.  Hence clause 6 is genuinely
   independent and is the one clause that cannot be discharged from the kinematic
   data alone; it remains the open residue / post-gauge obligation.

## Honesty discipline

Nothing physical is assumed as fact.  The genuine content is the logical
reduction: clause 6 is equivalent to residue control and follows from the open
post-gauge contract, but is *not* implied by projected chirality + flavored index
+ gauge covariance (explicit counterexample).  Discharging residue control on the
actual projected operator data is the open C58 obligation.

All declarations live in the `Draft` namespace.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeProjectedGhostSafety

open PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety
open PhysicsSM.Draft.NullEdgeGaugeCovariantBranchProjectors
  (DressedBranchProjector)
open PhysicsSM.Draft.NullEdgeProjectedGateCRelease
  (ProjData ProjectedGateCRelease projected_gateC_release
   NodalSetControlled BranchProjectorsControlled ProjectedKernelOneDim
   ProjectedChiralityAligned ProjectedKreinPositive SpeciesSplittingAudited
   releasedData releasedData_releases dangerousData)

variable {n : ℕ} {V : Type*}

/-! ## 1. The projected physical-sector zero datum -/

/-- A **projected physical-sector zero datum**.  It bundles

* `proj` — the C59 projected / species-split dataset (`ProjData`), carrying the
  branch-projector retained set, the species-split signs, the projected kernel
  dimensions, the projected chirality and Krein signatures, the nodal gaps, and
  the enumerated classified zero spectrum; together with
* `dressed` — the C61 gauge-covariant link-dressed branch projector;

subject to the compatibility condition `zeros_compat` that the link-dressed
projector introduces *exactly* the enumerated zero spectrum of the C59 dataset.
This is the single object compatible with the branch-projector, species-split,
and gauge-covariant-projector APIs simultaneously. -/
structure ProjectedZeroSector (n : ℕ) (V : Type*) where
  /-- the C59 projected / species-split dataset. -/
  proj : ProjData
  /-- the C61 gauge-covariant link-dressed branch projector. -/
  dressed : DressedBranchProjector n V
  /-- the dressed projector introduces exactly the C59 enumerated zero spectrum. -/
  zeros_compat : dressed.zeros = proj.zeros

/-- The enumerated classified zero spectrum of a projected sector. -/
def ProjectedZeroSector.zeros (P : ProjectedZeroSector n V) : List ZeroDatum :=
  P.proj.zeros

/-- The link-dressed branch projector of a projected sector is always gauge
covariant (C61 `DressedBranchProjector.gaugeCovariant`). -/
theorem ProjectedZeroSector.dressed_gaugeCovariant (P : ProjectedZeroSector n V) :
    P.dressed.GaugeCovariant :=
  P.dressed.gaugeCovariant

/-! ## 2. Residue control = spectrum-level ghost-zero safety -/

/-- **Residue control of a spectrum.**  Every zero that becomes gauge-coupled
propagating once weak gauge coupling is switched on keeps a nonnegative Krein
residue.  This is the precise estimate a weak-coupling perturbation theorem (the
open C58 obligation) must establish for the projected modes. -/
def ResidueControlled (zs : List ZeroDatum) : Prop :=
  ∀ z ∈ zs, z.gaugeCoupledPropagating = true → 0 ≤ z.kreinResidue

/-- **Residue control is exactly ghost-zero safety.**  (Restatement of the C47
`ghostZeroSafe_iff`.) -/
theorem residueControlled_iff_ghostSafe (zs : List ZeroDatum) :
    ResidueControlled zs ↔ GhostZeroSafe zs :=
  (ghostZeroSafe_iff zs).symm

/-! ## 3. Conditional clause-6 instantiation -/

/-
**Clause-6 instantiation from residue control.**  Under residue control of the
enumerated post-gauge spectrum, the retained projected modes are not
Golterman–Shamir fatal ghosts: the C59 ghost-zero-safety clause `GhostZeroSafe`
holds for the projected dataset.
-/
theorem projectedSector_ghostZeroSafe (P : ProjectedZeroSector n V)
    (h : ResidueControlled P.proj.zeros) :
    NullEdgeProjectedGateCRelease.GhostZeroSafe P.proj := by
  convert residueControlled_iff_ghostSafe P.proj.zeros |>.1 h using 1

/-
**Clause-6 instantiation from honest classification.**  If every enumerated
zero is well-classified and none is labelled a `fatalGhostZero`, then the
projected sector is ghost-zero safe (C59 clause 6).
-/
theorem projectedSector_ghostZeroSafe_of_labels (P : ProjectedZeroSector n V)
    (hw : ∀ z ∈ P.proj.zeros, z.WellClassified)
    (hlabel : ∀ z ∈ P.proj.zeros, z.kind ≠ ZeroKind.fatalGhostZero) :
    NullEdgeProjectedGateCRelease.GhostZeroSafe P.proj := by
  convert ghostZeroSafe_of_no_fatal_label hw hlabel using 1

/-! ## 4. Reduction to the open post-gauge obligation -/

/-
**Reduction to the post-gauge contract.**  If the C47 `PostGaugeGhostSafe`
contract holds for the *constant* weak-coupling deformation of the enumerated
spectrum (the free-field zeros are stable — no zero promotes to a fatal ghost —
under switching on weak gauge coupling), then the spectrum is ghost-zero safe.
This isolates clause 6 as a consequence of the open C58 weak-coupling
obligation.
-/
theorem ghostZeroSafe_of_postGaugeConst (zs : List ZeroDatum)
    (hpg : PostGaugeGhostSafe (fun (_ : ℝ) (i : Fin zs.length) => zs.get i)
            (Finset.univ : Finset (Fin zs.length))) :
    GhostZeroSafe zs := by
  obtain ⟨ g₀, hg₀, hprop ⟩ := hpg;
  intro z hz;
  obtain ⟨ i, hi ⟩ := List.mem_iff_get.mp hz; specialize hprop g₀ hg₀ le_rfl i; aesop;

/-- The projected-sector form of the post-gauge reduction. -/
theorem projectedSector_ghostZeroSafe_of_postGaugeConst (P : ProjectedZeroSector n V)
    (hpg : PostGaugeGhostSafe
            (fun (_ : ℝ) (i : Fin P.proj.zeros.length) => P.proj.zeros.get i)
            (Finset.univ : Finset (Fin P.proj.zeros.length))) :
    NullEdgeProjectedGateCRelease.GhostZeroSafe P.proj :=
  ghostZeroSafe_of_postGaugeConst P.proj.zeros hpg

/-! ## 5. Full projected release and non-vacuity -/

/-
**Conditional full release (C63).**  The six other C59 clauses together with
residue control of the spectrum entail the bundled C59 projected Gate C release
certificate, via `projected_gateC_release`.
-/
theorem projectedSector_release (P : ProjectedZeroSector n V)
    (hNodal : NodalSetControlled P.proj)
    (hProj : BranchProjectorsControlled P.proj)
    (hKer : ProjectedKernelOneDim P.proj)
    (hChir : ProjectedChiralityAligned P.proj)
    (hKrein : ProjectedKreinPositive P.proj)
    (hRes : ResidueControlled P.proj.zeros)
    (hSpecies : SpeciesSplittingAudited P.proj) :
    ProjectedGateCRelease P.proj := by
  convert projected_gateC_release P.proj hNodal hProj hKer hChir hKrein ( projectedSector_ghostZeroSafe P hRes ) hSpecies using 1

/-- A canonical released projected sector: the C59 `releasedData` together with a
trivial (empty-shift) link-dressed projector carrying the same benign single
physical-pole spectrum. -/
def releasedSector : ProjectedZeroSector 1 Unit where
  proj := releasedData
  dressed := { base := (), shifts := [], zeros := releasedData.zeros }
  zeros_compat := rfl

/-
The canonical released sector is ghost-zero safe.
-/
theorem releasedSector_ghostZeroSafe :
    NullEdgeProjectedGateCRelease.GhostZeroSafe releasedSector.proj := by
  convert releasedData_releases.2.2.2.2.1 using 1

/-- The canonical released sector satisfies the full C59 projected Gate C release
(so the conditional release predicate is not vacuous). -/
theorem releasedSector_releases : ProjectedGateCRelease releasedSector.proj :=
  releasedData_releases

/-! ## 6. The blocked clause: covariance + chirality + index ⇏ ghost safety -/

/-- A dangerous projected sector: the C59 `dangerousData` (aligned projected
chirality, maximal flavored index `4`) together with a trivial gauge-covariant
link-dressed projector carrying a single Golterman–Shamir fatal ghost zero. -/
def dangerousSector : ProjectedZeroSector 1 Unit where
  proj := dangerousData
  dressed := { base := (), shifts := [], zeros := dangerousData.zeros }
  zeros_compat := rfl

theorem dangerousSector_chirality_aligned :
    ProjectedChiralityAligned dangerousSector.proj := by
  intro a ha; fin_cases a <;> simp_all +decide [ dangerousSector, releasedData, g5pattern ] ;
  · rfl;
  · rfl

theorem dangerousSector_index_ne_zero : dangerousSector.proj.index ≠ 0 := by
  exact releasedData_releases.1

theorem dangerousSector_gaugeCovariant : dangerousSector.dressed.GaugeCovariant :=
  dangerousSector.dressed.gaugeCovariant

theorem dangerousSector_not_ghostZeroSafe :
    ¬ NullEdgeProjectedGateCRelease.GhostZeroSafe dangerousSector.proj := by
  unfold NullEdgeProjectedGateCRelease.GhostZeroSafe;
  unfold GhostZeroSafe; simp +decide [ dangerousSector ] ;
  exact ⟨ _, List.mem_singleton_self _, ghostZeroWitness_isFatal ⟩

theorem dangerousSector_not_release :
    ¬ ProjectedGateCRelease dangerousSector.proj := by
  intro h;
  cases h;
  grind +suggestions

/-- **The blocked clause (C63 negative result).**  There is a projected zero
sector whose projected chirality is aligned, whose flavored index is nonzero, and
whose link-dressed branch projector is gauge covariant, yet which is **not**
ghost-zero safe and therefore does **not** release Gate C.  Hence clause 6
(`GhostZeroSafe`) is genuinely independent of the kinematic data and is the one
clause that cannot be discharged from projected chirality + flavored index +
gauge covariance; it remains the open residue / post-gauge obligation. -/
theorem chirality_index_covariance_not_ghostSafe :
    ∃ P : ProjectedZeroSector 1 Unit,
      ProjectedChiralityAligned P.proj ∧ P.proj.index ≠ 0 ∧
      P.dressed.GaugeCovariant ∧
      ¬ NullEdgeProjectedGateCRelease.GhostZeroSafe P.proj ∧
      ¬ ProjectedGateCRelease P.proj :=
  ⟨dangerousSector, dangerousSector_chirality_aligned, dangerousSector_index_ne_zero,
    dangerousSector_gaugeCovariant, dangerousSector_not_ghostZeroSafe,
    dangerousSector_not_release⟩

/-! ## 7. Summary -/

/-- **C63 summary.**  Against the C59 seven-clause projected Gate C release API:

1. residue control of the enumerated spectrum is exactly ghost-zero safety
   (`residueControlled_iff_ghostSafe`);
2. it instantiates C59 clause 6 (`projectedSector_ghostZeroSafe`), and so does
   honest non-fatal classification (`projectedSector_ghostZeroSafe_of_labels`);
3. clause 6 follows from the open C47 post-gauge contract for the constant
   weak-coupling deformation (`ghostZeroSafe_of_postGaugeConst`);
4. with the other six clauses it gives the full `ProjectedGateCRelease`
   (`projectedSector_release`), non-vacuously (`releasedSector_releases`);
5. but projected chirality + nonzero flavored index + gauge covariance still do
   **not** entail ghost safety (`chirality_index_covariance_not_ghostSafe`), so
   clause 6 is the genuinely blocked clause. -/
theorem c63_projected_ghost_safety_summary :
    (∀ zs : List ZeroDatum, ResidueControlled zs ↔ GhostZeroSafe zs) ∧
    (∀ P : ProjectedZeroSector n V, ResidueControlled P.proj.zeros →
        NullEdgeProjectedGateCRelease.GhostZeroSafe P.proj) ∧
    (ProjectedGateCRelease releasedSector.proj) ∧
    (∃ P : ProjectedZeroSector 1 Unit,
      ProjectedChiralityAligned P.proj ∧ P.proj.index ≠ 0 ∧
      P.dressed.GaugeCovariant ∧
      ¬ NullEdgeProjectedGateCRelease.GhostZeroSafe P.proj ∧
      ¬ ProjectedGateCRelease P.proj) :=
  ⟨residueControlled_iff_ghostSafe, fun P h => projectedSector_ghostZeroSafe P h,
    releasedSector_releases, chirality_index_covariance_not_ghostSafe⟩

end PhysicsSM.Draft.NullEdgeProjectedGhostSafety
