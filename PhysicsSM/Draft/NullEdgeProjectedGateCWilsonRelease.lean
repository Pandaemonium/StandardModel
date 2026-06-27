import Mathlib
import PhysicsSM.Draft.NullEdgeProjectedGateCRelease

/-!
# C72: the projected Gate C **Wilson-residue** release API (`D_phys`-only)

This module is the *Wilson-regulator* packaging of the post-C21 projected Gate C
release theorem (`PhysicsSM.Draft.NullEdgeProjectedGateCRelease`).  It records the
extra discipline that comes from regulating the null-edge symbol with a Wilson
term and from turning on the gauge field:

* **regulated nodal control** — the Wilson term gives the would-be doublers a mass
  of order the regulator scale, so every branch's determinant-zero (nodal) curve
  is gapped *uniformly* by the regulator (`NullWilsonRegulatedNodalControl`);
* **post-gauge residue positivity** — after weak gauge coupling, the propagator
  zeros do not turn into wrong-sign (ghost) states; their Krein residues stay
  nonnegative on a coupling interval, so the spectrum is ghost-zero safe and stays
  ghost-zero safe (`PostGaugeResiduePositive`, built on the C47/C48
  `PostGaugeGhostSafe` contract); this is precisely the failure mode flagged for
  symmetric-mass-generation propagator zeros (arXiv:2311.12790), where zeros act
  as coupled ghost states once the gauge field is on;
* **Wilson-regulator / species moduli audit** — the species splitting carried by
  the regulator dataset `R_W` is symmetry-forced and a genuine nonzero modulus,
  and the physical dataset `D_phys` inherits the regulator's branch signs
  (`WilsonRegulatorAudited`, wrapping the C45/C46 `SpeciesSplittingAudited`).

The remaining clauses — branch-projector control, projected one-dimensional
kernel, projected chirality alignment, and projected Krein positivity — are
reused **verbatim** from `NullEdgeProjectedGateCRelease`.

The single deliverable is

```text
projectedGateCRelease_from_wilson_residue :
  NullWilsonRegulatedNodalControl D_phys →
  BranchProjectorsControlled       D_phys →
  ProjectedKernelOneDim            D_phys →
  ProjectedChiralityAligned        D_phys →
  ProjectedKreinPositive           D_phys →
  PostGaugeResiduePositive         D_phys →
  WilsonRegulatorAudited R_W       D_phys →   -- carries `SpeciesSplittingAudited R_W`
  GateCReleased                    D_phys
```

## Guardrail — releases `D_phys`, never bare `D₊`

`GateCReleased` is a thin alias of the projected release certificate
`ProjectedGateCRelease`, which reads its data off the *projected, species-split,
Wilson-regulated* dataset `D_phys`.  C21 showed the **bare** flat tetrahedral
symbol `D₊` assigns *no* single branch chirality (its per-branch kernel is
two-dimensional and chirality-balanced, `bareChirTrace = 0`).  Accordingly this
theorem can only ever conclude about `D_phys`; the guardrail
`wilson_release_only_dphys` records that a full Wilson release is *consistent* with
the bare-symbol chirality failure precisely because release is never read off the
bare symbol.

## Honesty discipline

Nothing physical is assumed as fact.  The content is the *logical* reduction: the
Wilson-regulated hypotheses each project onto the corresponding clause of the
already-proven `projected_gateC_release`, so their conjunction entails the release
certificate.  Inhabiting the structures on the actual regulated operator data is
the open obligation; the concrete witness `wilsonReleasedData_releases` shows the
API is not vacuous.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeProjectedGateCWilsonRelease

open PhysicsSM.Draft.NullEdgeProjectedGateCRelease
  (ProjData NodalSetControlled BranchProjectorsControlled ProjectedKernelOneDim
   ProjectedChiralityAligned ProjectedKreinPositive SpeciesSplittingAudited
   GhostZeroSafe ProjectedGateCRelease projected_gateC_release
   releasedData releasedData_releases BareAlignmentFails)

open PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety
  (ZeroDatum PostGaugeGhostSafe postGaugeGhostSafe_of_residue_nonneg
   physicalPoleWitness)

/-! ## The released-sector wrapper -/

/-- **Gate C release verdict for the physical dataset.**  A thin alias of the
projected release certificate of `NullEdgeProjectedGateCRelease`.  It is *only*
ever applied to `D_phys` (the projected / species-split / Wilson-regulated
dataset), never to the bare symbol `D₊`. -/
def GateCReleased (d : ProjData) : Prop := ProjectedGateCRelease d

theorem gateCReleased_iff (d : ProjData) :
    GateCReleased d ↔ ProjectedGateCRelease d := Iff.rfl

/-! ## Clause 1 — Wilson-regulated nodal control -/

/-- **Regulated nodal control.**  A Wilson regulator of mass `wilsonMass > 0`
lifts the would-be doublers, opening a gap on every branch's determinant-zero
(nodal) curve that is *bounded below uniformly* by the regulator scale.  This is
the Wilson-term strengthening of the bare `NodalSetControlled` clause: not merely
"every gap is positive", but "every gap is at least the regulator scale". -/
structure NullWilsonRegulatedNodalControl (d : ProjData) where
  /-- the Wilson regulator scale lifting the doublers. -/
  wilsonMass : ℝ
  /-- the regulator scale is strictly positive. -/
  wilsonMass_pos : 0 < wilsonMass
  /-- every branch's nodal gap is at least the regulator scale. -/
  nodalGap_lb : ∀ a, wilsonMass ≤ d.nodalGap a

/-- A regulated nodal control certificate yields the bare nodal-control clause. -/
theorem NullWilsonRegulatedNodalControl.toNodalSetControlled
    {d : ProjData} (h : NullWilsonRegulatedNodalControl d) :
    NodalSetControlled d :=
  fun a => lt_of_lt_of_le h.wilsonMass_pos (h.nodalGap_lb a)

/-! ## Clause 6 — post-gauge residue positivity -/

/-- **Post-gauge residue positivity.**  Bundles two facts about the gauge-coupled
spectrum:

* at zero coupling the enumerated zeros are already ghost-zero safe (`ghostSafe`);
* there is a one-parameter gauge-coupled deformation `deformed g i` of the zeros
  over an index family `S`, and a coupling threshold `threshold > 0`, below which
  every gauge-coupled deformed zero keeps a **nonnegative** Krein residue
  (`residue_nonneg`).

By the C47/C48 estimate `postGaugeGhostSafe_of_residue_nonneg`, the second fact
gives the post-gauge-coupling ghost-safety contract `PostGaugeGhostSafe`: turning
on the gauge field never manufactures a wrong-sign (ghost) propagating state from
a propagator zero. -/
structure PostGaugeResiduePositive (d : ProjData) where
  /-- the index family of gauge-coupled zeros. -/
  ι : Type
  /-- the gauge-coupled deformation of the zero spectrum. -/
  deformed : ℝ → ι → ZeroDatum
  /-- the finite index set of monitored zeros. -/
  S : Finset ι
  /-- at zero coupling the spectrum is ghost-zero safe (Golterman–Shamir). -/
  ghostSafe : GhostZeroSafe d
  /-- the weak-coupling threshold. -/
  threshold : ℝ
  /-- the threshold is strictly positive. -/
  threshold_pos : 0 < threshold
  /-- post-gauge residue positivity: below threshold every gauge-coupled deformed
  zero keeps a nonnegative Krein residue. -/
  residue_nonneg : ∀ g : ℝ, 0 < g → g ≤ threshold → ∀ i ∈ S,
    (deformed g i).gaugeCoupledPropagating = true → 0 ≤ (deformed g i).kreinResidue

/-- Post-gauge residue positivity supplies the (zero-coupling) ghost-zero safety
clause. -/
theorem PostGaugeResiduePositive.toGhostZeroSafe
    {d : ProjData} (h : PostGaugeResiduePositive d) : GhostZeroSafe d :=
  h.ghostSafe

/-- Post-gauge residue positivity supplies the C47/C48 post-gauge-coupling
ghost-safety contract: the gauge-coupled deformation is ghost-safe below the
threshold. -/
theorem PostGaugeResiduePositive.toPostGaugeGhostSafe
    {d : ProjData} (h : PostGaugeResiduePositive d) :
    PostGaugeGhostSafe h.deformed h.S :=
  postGaugeGhostSafe_of_residue_nonneg h.deformed h.S h.threshold_pos h.residue_nonneg

/-! ## Clause 7 — Wilson-regulator / species moduli audit -/

/-- **Wilson-regulator / species moduli audit.**  The Wilson-regulated dataset
`R_W` carries a symmetry-forced, genuinely nonzero species splitting
(`SpeciesSplittingAudited R_W`, reused verbatim from C45/C46), and the physical
dataset `D_phys` inherits the regulator's branch signs (`signs_match`).  Together
these certify that `D_phys` has the audited splitting too — in particular a
nonzero flavored index. -/
structure WilsonRegulatorAudited (R_W D_phys : ProjData) where
  /-- the regulator's species splitting is symmetry-forced and a nonzero modulus. -/
  speciesAudited : SpeciesSplittingAudited R_W
  /-- the physical dataset inherits the regulator's branch signs. -/
  signs_match : D_phys.signs = R_W.signs

/-- The audit transports the species-splitting certificate from the regulator
dataset `R_W` to the physical dataset `D_phys` (it depends only on the branch
signs, which agree). -/
theorem WilsonRegulatorAudited.toSpeciesSplittingAudited
    {R_W D_phys : ProjData} (h : WilsonRegulatorAudited R_W D_phys) :
    SpeciesSplittingAudited D_phys := by
  have hsp := h.speciesAudited
  unfold SpeciesSplittingAudited at hsp ⊢
  rw [h.signs_match]
  exact hsp

/-! ## The main Wilson-residue release theorem -/

/-- **Projected Gate C release from the Wilson residue (C72).**  The Wilson-
regulated hypotheses each project onto the corresponding clause of the proven
`projected_gateC_release`:

* `NullWilsonRegulatedNodalControl D_phys` ⟶ nodal-set control;
* the four projected clauses are reused verbatim;
* `PostGaugeResiduePositive D_phys` ⟶ ghost-zero safety (post-gauge robust);
* `WilsonRegulatorAudited R_W D_phys` ⟶ `SpeciesSplittingAudited D_phys`.

Their conjunction therefore entails `GateCReleased D_phys`.

**Guardrail.**  The conclusion is about `D_phys` only.  Nothing here releases the
bare symbol `D₊`: every clause and the certificate read the *projected /
species-split / Wilson-regulated* data. -/
theorem projectedGateCRelease_from_wilson_residue
    {R_W D_phys : ProjData}
    (hNodal : NullWilsonRegulatedNodalControl D_phys)
    (hProj  : BranchProjectorsControlled D_phys)
    (hKer   : ProjectedKernelOneDim D_phys)
    (hChir  : ProjectedChiralityAligned D_phys)
    (hKrein : ProjectedKreinPositive D_phys)
    (hResid : PostGaugeResiduePositive D_phys)
    (hAudit : WilsonRegulatorAudited R_W D_phys) :
    GateCReleased D_phys :=
  projected_gateC_release D_phys
    hNodal.toNodalSetControlled hProj hKer hChir hKrein
    hResid.toGhostZeroSafe hAudit.toSpeciesSplittingAudited

/-! ## Non-vacuity: a concrete released Wilson dataset -/

/-- Wilson-regulated nodal control for the canonical released dataset: regulator
scale `1`, and every nodal gap equals `1 ≥ 1`. -/
def wilsonReleasedNodalControl : NullWilsonRegulatedNodalControl releasedData where
  wilsonMass := 1
  wilsonMass_pos := one_pos
  nodalGap_lb := fun _ => le_refl 1

/-- Post-gauge residue positivity for the canonical released dataset: the single
physical pole is ghost-zero safe, and a coupling-independent benign deformation
keeps a positive Krein residue. -/
def wilsonReleasedResidue : PostGaugeResiduePositive releasedData where
  ι := Fin 1
  deformed := fun _ _ => physicalPoleWitness
  S := Finset.univ
  ghostSafe := by
    intro z hz
    simp only [releasedData, List.mem_singleton] at hz; subst hz
    rintro ⟨-, hlt⟩; norm_num [physicalPoleWitness] at hlt
  threshold := 1
  threshold_pos := one_pos
  residue_nonneg := by intro g _ _ i _ _; norm_num [physicalPoleWitness]

/-- The Wilson-regulator audit for the canonical released dataset: the species
splitting is the `g5` direction (block-constant, traceless, nonzero), and the
physical signs trivially match. -/
def wilsonReleasedAudit : WilsonRegulatorAudited releasedData releasedData where
  speciesAudited := by
    constructor
    · constructor
      · simp [releasedData, NullEdgeGateCGhostZeroSafety.g5pattern,
          NullEdgeSymmetryForcedSpeciesSplit.BlockConstant]
      · simp [releasedData, NullEdgeGateCGhostZeroSafety.g5pattern,
          NullEdgeSymmetryForcedSpeciesSplit.Traceless]
    · intro h
      have := congrFun h 0
      simp [releasedData, NullEdgeGateCGhostZeroSafety.g5pattern] at this
  signs_match := rfl

/-- Branch-projector control for the canonical released dataset. -/
theorem wilsonReleasedBranch : BranchProjectorsControlled releasedData :=
  ⟨⟨0, by decide⟩, by intro a ha; fin_cases a <;> simp_all [releasedData]⟩

/-- Projected one-dimensional kernel for the canonical released dataset. -/
theorem wilsonReleasedKer : ProjectedKernelOneDim releasedData := by
  intro a ha; fin_cases a <;> simp_all [releasedData]

/-- Projected chirality alignment for the canonical released dataset. -/
theorem wilsonReleasedChir : ProjectedChiralityAligned releasedData :=
  fun _ _ => rfl

/-- Projected Krein positivity for the canonical released dataset. -/
theorem wilsonReleasedKrein : ProjectedKreinPositive releasedData := by
  refine ⟨?_, ?_⟩
  · intro a ha; fin_cases a <;> simp_all [releasedData]
  · intro z hz _
    simp only [releasedData, List.mem_singleton] at hz; subst hz
    norm_num [physicalPoleWitness]

/-- **Non-vacuity.**  The Wilson-residue release API is inhabited: the canonical
released dataset satisfies all the Wilson hypotheses and is released. -/
theorem wilsonReleasedData_releases : GateCReleased releasedData :=
  projectedGateCRelease_from_wilson_residue
    wilsonReleasedNodalControl
    wilsonReleasedBranch
    wilsonReleasedKer
    wilsonReleasedChir
    wilsonReleasedKrein
    wilsonReleasedResidue
    wilsonReleasedAudit

/-! ## Guardrail — `D_phys` only, never bare `D₊` -/

/-- **Guardrail: Wilson release is about `D_phys`, never bare `D₊`.**  A full
Wilson-residue release is *consistent* with the C21 bare-symbol chirality failure
(`BareAlignmentFails`, the balanced two-dimensional bare kernel), precisely
because the release certificate is read off the projected `D_phys` data and never
off the bare symbol. -/
theorem wilson_release_only_dphys :
    ∃ d : ProjData, BareAlignmentFails d ∧ GateCReleased d :=
  ⟨releasedData, fun _ => rfl, wilsonReleasedData_releases⟩

/-! ## Summary -/

/-- **C72 summary.**  The Wilson-residue projected Gate C release API:

1. the three Wilson structures (`NullWilsonRegulatedNodalControl`,
   `PostGaugeResiduePositive`, `WilsonRegulatorAudited`) together with the four
   reused projected clauses imply `GateCReleased D_phys`
   (`projectedGateCRelease_from_wilson_residue`);
2. the API is non-vacuous (`wilsonReleasedData_releases`);
3. release is granted only for `D_phys`, consistently with the bare-symbol
   chirality failure (`wilson_release_only_dphys`). -/
theorem c72_wilson_release_summary :
    (∀ R_W D_phys : ProjData,
        NullWilsonRegulatedNodalControl D_phys →
        BranchProjectorsControlled D_phys →
        ProjectedKernelOneDim D_phys →
        ProjectedChiralityAligned D_phys →
        ProjectedKreinPositive D_phys →
        PostGaugeResiduePositive D_phys →
        WilsonRegulatorAudited R_W D_phys →
        GateCReleased D_phys) ∧
    GateCReleased releasedData ∧
    (∃ d : ProjData, BareAlignmentFails d ∧ GateCReleased d) :=
  ⟨fun _ _ => projectedGateCRelease_from_wilson_residue,
    wilsonReleasedData_releases, wilson_release_only_dphys⟩

end PhysicsSM.Draft.NullEdgeProjectedGateCWilsonRelease
