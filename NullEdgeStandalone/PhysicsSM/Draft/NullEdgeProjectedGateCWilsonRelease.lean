import Mathlib
import PhysicsSM.Draft.NullEdgeProjectedGateCRelease

/-!
# C72 / C90: the projected Gate C **Wilson-residue** release API (`D_phys`-only)

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

## C90 hardening pass

Wave 21 / C90 hardens the public API so that downstream users cannot accidentally
read it as a *bare* or *full / unconditional* Gate C release:

1. **Naming.**  The release verdict is now exposed under the explicit name
   `ProjectedWilsonGateCRelease`.  The old thin alias `GateCReleased` (which is
   too easy to misread as unconditional Gate C closure) is kept only as a
   `@[deprecated]` compatibility shim that forwards to the explicit name.
2. **Ghost safety.**  Scalar / Krein residue positivity of the gauge-coupled
   deformation (`PostGaugeResidueKreinPositive`) is separated from the *full*
   Golterman–Shamir safety condition (`PostGaugeGoltermanShamirSafe`), which
   additionally requires the static spectrum to have no gauge-coupled ghost zeros
   (`NoGaugeCoupledGhostZeros`) and carries an explicit BRST/Krein-cohomological
   obligation in its type.  The guardrail `kreinPositive_not_noGhostZeros` proves
   that residue positivity *alone* is strictly weaker than ghost-zero safety.
3. **Regulator audit.**  `WilsonRegulatorModuliAudit` exposes, *in its type*, the
   four regulator-moduli distinctions a black-box audit hides
   (`regulatorFixedOrCanonical`, `noNewFreeModulus`, `gaugeCovariantOrLinkDressed`,
   `originIrrelevantOrC1Compatible`), so a "new free modulus" or C1-touching
   regulator cannot be slipped in behind a single flag.
4. **C0/C1 separation.**  The C1-compatibility obligation
   (`originIrrelevantOrC1Compatible`) is an *explicit hypothesis carried in the
   type* of the hardened release theorem; it is never derived.  The guardrail
   `projectedWilsonRelease_not_bareGateCRelease` records that release coexists with
   the C21 bare-symbol chirality failure, i.e. release is read off `D_phys`, never
   off the bare symbol, and so never upgrades C0 (conditional release) to C1
   (actual construction).

## Honesty discipline

Nothing physical is assumed as fact.  The content is the *logical* reduction: the
Wilson-regulated hypotheses each project onto the corresponding clause of the
already-proven `projected_gateC_release`, so their conjunction entails the release
certificate.  Inhabiting the structures on the actual regulated operator data is
the open obligation; the concrete witnesses (`wilsonReleasedData_releases`,
`wilsonReleasedData_releases_full_audit`) show the API is not vacuous.  The four
moduli-audit fields and the BRST obligation remain **open API assumptions**:
they are carried as explicit hypotheses/parameters, never proved, and the
non-vacuity witnesses discharge them only with the trivial `True` placeholder,
which carries no physical content.
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
   ghostZeroSafe_iff ghostZeroWitness ghostZeroWitness_isFatal
   physicalPoleWitness)

/-! ## The released-sector wrapper -/

/-- **Projected Wilson Gate C release verdict for the physical dataset.**  A thin
alias of the projected release certificate of `NullEdgeProjectedGateCRelease`.  It
is *only* ever applied to `D_phys` (the projected / species-split /
Wilson-regulated dataset), never to the bare symbol `D₊`, and it is *conditional*
on the Wilson/regulator hypotheses below — it is **not** an unconditional or
"full" Gate C closure.  The explicit name is chosen so downstream citations
cannot read it as a bare release. -/
def ProjectedWilsonGateCRelease (d : ProjData) : Prop := ProjectedGateCRelease d

theorem projectedWilsonGateCRelease_iff (d : ProjData) :
    ProjectedWilsonGateCRelease d ↔ ProjectedGateCRelease d := Iff.rfl

/-- **Deprecated compatibility alias.**  The bare name `GateCReleased` reads too
easily as *unconditional* Gate C closure; use `ProjectedWilsonGateCRelease`
instead.  Kept only so existing downstream references keep compiling. -/
@[deprecated ProjectedWilsonGateCRelease (since := "2026-06-27")]
abbrev GateCReleased (d : ProjData) : Prop := ProjectedWilsonGateCRelease d

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
a propagator zero.

**C90 note.**  This predicate is *retained* for backward compatibility but is
only the residue-positivity ingredient of Golterman–Shamir safety.  The hardened
API below (`PostGaugeGoltermanShamirSafe`) separates the residue-positivity part
(`PostGaugeResidueKreinPositive`) from the no-ghost-zeros part
(`NoGaugeCoupledGhostZeros`) and the BRST obligation, and proves residue
positivity alone is strictly weaker. -/
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

/-! ## C90 — strengthened ghost-safety split

The adversarial review flagged that scalar Krein residue positivity of the
gauge-coupled deformation is *necessary but not sufficient* for the
Golterman–Shamir ghost-zero warning.  We therefore split the ghost-safety side
into independent pieces and assemble the full condition explicitly. -/

/-- **(Necessary, not sufficient) Krein-residue positivity of the gauge-coupled
deformation.**  Below a positive threshold every gauge-coupled deformed zero keeps
a nonnegative Krein residue.  This is *one* ingredient of Golterman–Shamir
safety: it constrains only the enumerated deformed residues and says nothing about
BRST/Krein-cohomological consistency or about gauge-coupled ghost zeros already
present in the static spectrum. -/
structure PostGaugeResidueKreinPositive (d : ProjData) where
  /-- the index family of gauge-coupled zeros. -/
  ι : Type
  /-- the gauge-coupled deformation of the zero spectrum. -/
  deformed : ℝ → ι → ZeroDatum
  /-- the finite index set of monitored zeros. -/
  S : Finset ι
  /-- the weak-coupling threshold. -/
  threshold : ℝ
  /-- the threshold is strictly positive. -/
  threshold_pos : 0 < threshold
  /-- below threshold every gauge-coupled deformed zero keeps a nonnegative Krein
  residue. -/
  residue_nonneg : ∀ g : ℝ, 0 < g → g ≤ threshold → ∀ i ∈ S,
    (deformed g i).gaugeCoupledPropagating = true → 0 ≤ (deformed g i).kreinResidue

/-- Krein-residue positivity gives the C47/C48 post-gauge-coupling ghost-safety
contract for its own deformation family. -/
theorem PostGaugeResidueKreinPositive.toPostGaugeGhostSafe
    {d : ProjData} (h : PostGaugeResidueKreinPositive d) :
    PostGaugeGhostSafe h.deformed h.S :=
  postGaugeGhostSafe_of_residue_nonneg h.deformed h.S h.threshold_pos h.residue_nonneg

/-- The old `PostGaugeResiduePositive` carries (at least) the residue-positivity
ingredient. -/
def PostGaugeResiduePositive.toKreinPositive
    {d : ProjData} (h : PostGaugeResiduePositive d) :
    PostGaugeResidueKreinPositive d where
  ι := h.ι
  deformed := h.deformed
  S := h.S
  threshold := h.threshold
  threshold_pos := h.threshold_pos
  residue_nonneg := h.residue_nonneg

/-- **No gauge-coupled ghost zeros in the static spectrum.**  Every enumerated
zero that is gauge-coupled-propagating carries a nonnegative Krein residue
(equivalently, the spectrum is `GhostZeroSafe`).  This is the second, independent
ingredient of Golterman–Shamir safety: residue positivity of a *deformation*
family does not constrain the static spectrum, and conversely. -/
def NoGaugeCoupledGhostZeros (d : ProjData) : Prop :=
  ∀ z ∈ d.zeros, z.gaugeCoupledPropagating = true → 0 ≤ z.kreinResidue

/-- No gauge-coupled ghost zeros is exactly ghost-zero safety of the spectrum. -/
theorem NoGaugeCoupledGhostZeros.toGhostZeroSafe
    {d : ProjData} (h : NoGaugeCoupledGhostZeros d) : GhostZeroSafe d :=
  (ghostZeroSafe_iff d.zeros).mpr h

/-- **Full post-gauge Golterman–Shamir safety.**  Strictly stronger than scalar /
Krein residue positivity: in addition to residue positivity of the gauge-coupled
deformation (`kreinPositive`) it requires the static spectrum to have no
gauge-coupled ghost zeros (`noGhostZeros`, i.e. `GhostZeroSafe`) **and** a
BRST/Krein-cohomological consistency obligation (`brstSafe`), carried explicitly
in the type as the proposition parameter `BRSTSafe`.  The BRST obligation is an
*open API assumption*: it is never proved here, only required. -/
structure PostGaugeGoltermanShamirSafe (d : ProjData) (BRSTSafe : Prop) where
  /-- the (necessary, not sufficient) Krein-residue positivity ingredient. -/
  kreinPositive : PostGaugeResidueKreinPositive d
  /-- the static spectrum has no gauge-coupled ghost zeros (`GhostZeroSafe`). -/
  noGhostZeros : NoGaugeCoupledGhostZeros d
  /-- the BRST/Krein-cohomological consistency obligation (open API assumption). -/
  brstSafe : BRSTSafe

/-- Full Golterman–Shamir safety supplies the ghost-zero safety clause needed by
`projected_gateC_release`. -/
theorem PostGaugeGoltermanShamirSafe.toGhostZeroSafe
    {d : ProjData} {BRSTSafe : Prop} (h : PostGaugeGoltermanShamirSafe d BRSTSafe) :
    GhostZeroSafe d :=
  h.noGhostZeros.toGhostZeroSafe

/-- The old `PostGaugeResiduePositive`, paired with a *trivial* (`True`) BRST
clause, gives a C0-level `PostGaugeGoltermanShamirSafe`.  This documents that the
old predicate already carried the residue-positivity and no-ghost-zeros
ingredients, while making explicit that it asserts **no** BRST content (the BRST
field is the contentless `True`). -/
def PostGaugeResiduePositive.toGoltermanShamirSafe_trivialBRST
    {d : ProjData} (h : PostGaugeResiduePositive d) :
    PostGaugeGoltermanShamirSafe d True where
  kreinPositive := h.toKreinPositive
  noGhostZeros := (ghostZeroSafe_iff d.zeros).mp h.ghostSafe
  brstSafe := trivial

/-! ## Clause 7 — Wilson-regulator / species moduli audit -/

/-- **Wilson-regulator / species moduli audit.**  The Wilson-regulated dataset
`R_W` carries a symmetry-forced, genuinely nonzero species splitting
(`SpeciesSplittingAudited R_W`, reused verbatim from C45/C46), and the physical
dataset `D_phys` inherits the regulator's branch signs (`signs_match`).  Together
these certify that `D_phys` has the audited splitting too — in particular a
nonzero flavored index.

**C90 note.**  This black-box predicate is *retained* for backward compatibility.
The hardened `WilsonRegulatorModuliAudit` below exposes the regulator-moduli
distinctions in its type. -/
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

/-- **C90 hardened Wilson-regulator / species moduli audit.**  Distinguishes, *in
its type*, the regulator-moduli properties a black-box audit hides.  The four
proposition parameters are explicit obligations carried by whoever builds the
audit, so a downstream theorem's type records exactly which regulator conditions
are assumed:

* `regulatorFixedOrCanonical` — the regulator is fixed/canonical, not silently
  tunable;
* `noNewFreeModulus` — the species splitting introduces no new free modulus (it is
  symmetry-forced, as already witnessed by `speciesAudited`);
* `gaugeCovariantOrLinkDressed` — the regulator is gauge-covariant / link-dressed,
  not a gauge-breaking insertion;
* `originIrrelevantOrC1Compatible` — the regulator's origin term is irrelevant /
  C1-compatible.  This is the **only** C1-touching clause and it is an *input*,
  never derived (see the C0/C1 guardrail).

These four are *open API assumptions*: they are never proved here, only required,
and the non-vacuity witness discharges them with the contentless `True`. -/
structure WilsonRegulatorModuliAudit
    (R_W D_phys : ProjData)
    (regulatorFixedOrCanonical noNewFreeModulus
     gaugeCovariantOrLinkDressed originIrrelevantOrC1Compatible : Prop) where
  /-- the regulator's species splitting is symmetry-forced and a nonzero modulus. -/
  speciesAudited : SpeciesSplittingAudited R_W
  /-- the physical dataset inherits the regulator's branch signs. -/
  signs_match : D_phys.signs = R_W.signs
  /-- the regulator is fixed / canonical (open API assumption). -/
  regulatorFixedOrCanonical_holds : regulatorFixedOrCanonical
  /-- the splitting introduces no new free modulus (open API assumption). -/
  noNewFreeModulus_holds : noNewFreeModulus
  /-- the regulator is gauge-covariant / link-dressed (open API assumption). -/
  gaugeCovariantOrLinkDressed_holds : gaugeCovariantOrLinkDressed
  /-- the regulator's origin term is irrelevant / C1-compatible (open API
  assumption; the only C1-touching clause, always an input). -/
  originIrrelevantOrC1Compatible_holds : originIrrelevantOrC1Compatible

/-- The hardened audit forgets its moduli fields down to the black-box
`WilsonRegulatorAudited`. -/
def WilsonRegulatorModuliAudit.toWilsonRegulatorAudited
    {R_W D_phys : ProjData} {p q r s : Prop}
    (h : WilsonRegulatorModuliAudit R_W D_phys p q r s) :
    WilsonRegulatorAudited R_W D_phys where
  speciesAudited := h.speciesAudited
  signs_match := h.signs_match

/-- The hardened audit transports the species-splitting certificate to `D_phys`. -/
theorem WilsonRegulatorModuliAudit.toSpeciesSplittingAudited
    {R_W D_phys : ProjData} {p q r s : Prop}
    (h : WilsonRegulatorModuliAudit R_W D_phys p q r s) :
    SpeciesSplittingAudited D_phys :=
  h.toWilsonRegulatorAudited.toSpeciesSplittingAudited

/-! ## The main Wilson-residue release theorem (retained, C72) -/

/-- **Projected Gate C release from the Wilson residue (C72).**  The Wilson-
regulated hypotheses each project onto the corresponding clause of the proven
`projected_gateC_release`:

* `NullWilsonRegulatedNodalControl D_phys` ⟶ nodal-set control;
* the four projected clauses are reused verbatim;
* `PostGaugeResiduePositive D_phys` ⟶ ghost-zero safety (post-gauge robust);
* `WilsonRegulatorAudited R_W D_phys` ⟶ `SpeciesSplittingAudited D_phys`.

Their conjunction therefore entails `ProjectedWilsonGateCRelease D_phys`.

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
    ProjectedWilsonGateCRelease D_phys :=
  projected_gateC_release D_phys
    hNodal.toNodalSetControlled hProj hKer hChir hKrein
    hResid.toGhostZeroSafe hAudit.toSpeciesSplittingAudited

/-! ## C90 — the hardened Wilson-residue release theorem -/

/-- **Hardened projected Wilson Gate C release (C90).**  Identical logical
reduction to `projectedGateCRelease_from_wilson_residue`, but stated against the
*hardened* ghost-safety and regulator-audit interfaces so that the assumed
content is visible in the type:

* ghost safety is supplied by the full `PostGaugeGoltermanShamirSafe D_phys
  BRSTSafe` (residue positivity **and** no gauge-coupled ghost zeros **and** an
  explicit BRST obligation `BRSTSafe`), not by scalar residue positivity alone;
* the regulator audit is the hardened `WilsonRegulatorModuliAudit`, whose four
  moduli propositions (`regFixed`, `noNewModulus`, `gaugeCov`, `originC1`) appear
  as explicit hypotheses in the type.

**C0/C1 separation.**  The C1-touching clause `originC1`
(`originIrrelevantOrC1Compatible`) is an *input* hypothesis; the theorem never
derives it.  The conclusion is the *conditional* `ProjectedWilsonGateCRelease
D_phys` about `D_phys`, never a bare or unconditional Gate C closure. -/
theorem projectedWilsonGateCRelease_under_full_audit
    {R_W D_phys : ProjData}
    {regFixed noNewModulus gaugeCov originC1 BRSTSafe : Prop}
    (hNodal : NullWilsonRegulatedNodalControl D_phys)
    (hProj  : BranchProjectorsControlled D_phys)
    (hKer   : ProjectedKernelOneDim D_phys)
    (hChir  : ProjectedChiralityAligned D_phys)
    (hKrein : ProjectedKreinPositive D_phys)
    (hGS    : PostGaugeGoltermanShamirSafe D_phys BRSTSafe)
    (hAudit : WilsonRegulatorModuliAudit R_W D_phys
                regFixed noNewModulus gaugeCov originC1) :
    ProjectedWilsonGateCRelease D_phys :=
  projected_gateC_release D_phys
    hNodal.toNodalSetControlled hProj hKer hChir hKrein
    hGS.toGhostZeroSafe hAudit.toSpeciesSplittingAudited

/-! ## C90 — ghost-safety separation guardrail -/

/-- A dangerous dataset: the canonical released data but with a fatal
gauge-coupled ghost zero substituted into the static spectrum. -/
def wilsonDangerousData : ProjData :=
  { releasedData with zeros := [ghostZeroWitness] }

/-- **Guardrail: scalar / Krein residue positivity is strictly weaker than
ghost-zero safety.**  There is a dataset whose gauge-coupled *deformation* has
nonnegative residues (`PostGaugeResidueKreinPositive`) yet whose static spectrum
*does* contain a gauge-coupled ghost zero (`¬ NoGaugeCoupledGhostZeros`).  Hence
the ghost problem is **not** solved by a bare positivity field: full
Golterman–Shamir safety needs the no-ghost-zeros clause too. -/
theorem kreinPositive_not_noGhostZeros :
    ∃ d, Nonempty (PostGaugeResidueKreinPositive d) ∧ ¬ NoGaugeCoupledGhostZeros d := by
  refine ⟨wilsonDangerousData, ?_, ?_⟩
  · exact ⟨
      { ι := Fin 1
        deformed := fun _ _ => physicalPoleWitness
        S := Finset.univ
        threshold := 1
        threshold_pos := one_pos
        residue_nonneg := by intro g _ _ i _ _; norm_num [physicalPoleWitness] }⟩
  · intro h
    have hmem : ghostZeroWitness ∈ wilsonDangerousData.zeros := by
      simp [wilsonDangerousData]
    have := h ghostZeroWitness hmem rfl
    norm_num [ghostZeroWitness] at this

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

/-- **Non-vacuity (C72).**  The Wilson-residue release API is inhabited: the
canonical released dataset satisfies all the Wilson hypotheses and is released. -/
theorem wilsonReleasedData_releases : ProjectedWilsonGateCRelease releasedData :=
  projectedGateCRelease_from_wilson_residue
    wilsonReleasedNodalControl
    wilsonReleasedBranch
    wilsonReleasedKer
    wilsonReleasedChir
    wilsonReleasedKrein
    wilsonReleasedResidue
    wilsonReleasedAudit

/-! ## C90 — non-vacuity of the hardened interfaces -/

/-- No gauge-coupled ghost zeros for the canonical released dataset (its only
zero is a positive-residue physical pole). -/
theorem wilsonReleasedNoGhostZeros : NoGaugeCoupledGhostZeros releasedData := by
  intro z hz _
  simp only [releasedData, List.mem_singleton] at hz; subst hz
  norm_num [physicalPoleWitness]

/-- The hardened full Golterman–Shamir safety for the canonical released dataset,
with the BRST obligation discharged only by the contentless `True`. -/
def wilsonReleasedGoltermanShamir : PostGaugeGoltermanShamirSafe releasedData True where
  kreinPositive := wilsonReleasedResidue.toKreinPositive
  noGhostZeros := wilsonReleasedNoGhostZeros
  brstSafe := trivial

/-- The hardened regulator-moduli audit for the canonical released dataset, with
the four moduli obligations discharged only by the contentless `True`. -/
def wilsonReleasedModuliAudit :
    WilsonRegulatorModuliAudit releasedData releasedData True True True True where
  speciesAudited := wilsonReleasedAudit.speciesAudited
  signs_match := rfl
  regulatorFixedOrCanonical_holds := trivial
  noNewFreeModulus_holds := trivial
  gaugeCovariantOrLinkDressed_holds := trivial
  originIrrelevantOrC1Compatible_holds := trivial

/-- **Non-vacuity (C90).**  The hardened Wilson-residue release API is inhabited:
the canonical released dataset satisfies the hardened ghost-safety and
regulator-audit hypotheses and is released. -/
theorem wilsonReleasedData_releases_full_audit :
    ProjectedWilsonGateCRelease releasedData :=
  projectedWilsonGateCRelease_under_full_audit
    wilsonReleasedNodalControl
    wilsonReleasedBranch
    wilsonReleasedKer
    wilsonReleasedChir
    wilsonReleasedKrein
    wilsonReleasedGoltermanShamir
    wilsonReleasedModuliAudit

/-! ## Guardrail — `D_phys` only, never bare `D₊` (and C0, never C1) -/

/-- **Guardrail: Wilson release is about `D_phys`, never bare `D₊`.**  A full
Wilson-residue release is *consistent* with the C21 bare-symbol chirality failure
(`BareAlignmentFails`, the balanced two-dimensional bare kernel), precisely
because the release certificate is read off the projected `D_phys` data and never
off the bare symbol.

This is also the **C0/C1 separation** witness: release coexists with the
bare-symbol obstruction, so the conditional release (C0) never manufactures the
actual bare/full construction (C1). -/
theorem projectedWilsonRelease_not_bareGateCRelease :
    ∃ d : ProjData, BareAlignmentFails d ∧ ProjectedWilsonGateCRelease d :=
  ⟨releasedData, fun _ => rfl, wilsonReleasedData_releases⟩

/-- Retained C72 name (now an alias of the C90 guardrail). -/
theorem wilson_release_only_dphys :
    ∃ d : ProjData, BareAlignmentFails d ∧ ProjectedWilsonGateCRelease d :=
  projectedWilsonRelease_not_bareGateCRelease

/-! ## Summary -/

/-- **C72 / C90 summary.**  The hardened Wilson-residue projected Gate C release
API:

1. (C72) the three Wilson structures with the four reused projected clauses imply
   `ProjectedWilsonGateCRelease D_phys`
   (`projectedGateCRelease_from_wilson_residue`);
2. (C90) the *hardened* theorem `projectedWilsonGateCRelease_under_full_audit`
   reaches the same conclusion from the full Golterman–Shamir safety structure and
   the hardened regulator-moduli audit, exposing the assumed content in its type;
3. scalar / Krein residue positivity is strictly weaker than ghost-zero safety
   (`kreinPositive_not_noGhostZeros`);
4. both APIs are non-vacuous (`wilsonReleasedData_releases`,
   `wilsonReleasedData_releases_full_audit`);
5. release is granted only for `D_phys`, consistently with the bare-symbol
   chirality failure (`projectedWilsonRelease_not_bareGateCRelease`), so it is
   never a bare or C1 release. -/
theorem c90_wilson_release_summary :
    (∀ R_W D_phys : ProjData,
        NullWilsonRegulatedNodalControl D_phys →
        BranchProjectorsControlled D_phys →
        ProjectedKernelOneDim D_phys →
        ProjectedChiralityAligned D_phys →
        ProjectedKreinPositive D_phys →
        PostGaugeResiduePositive D_phys →
        WilsonRegulatorAudited R_W D_phys →
        ProjectedWilsonGateCRelease D_phys) ∧
    (∀ (R_W D_phys : ProjData) (regFixed noNewModulus gaugeCov originC1 BRSTSafe : Prop),
        NullWilsonRegulatedNodalControl D_phys →
        BranchProjectorsControlled D_phys →
        ProjectedKernelOneDim D_phys →
        ProjectedChiralityAligned D_phys →
        ProjectedKreinPositive D_phys →
        PostGaugeGoltermanShamirSafe D_phys BRSTSafe →
        WilsonRegulatorModuliAudit R_W D_phys regFixed noNewModulus gaugeCov originC1 →
        ProjectedWilsonGateCRelease D_phys) ∧
    (∃ d, Nonempty (PostGaugeResidueKreinPositive d) ∧ ¬ NoGaugeCoupledGhostZeros d) ∧
    ProjectedWilsonGateCRelease releasedData ∧
    (∃ d : ProjData, BareAlignmentFails d ∧ ProjectedWilsonGateCRelease d) :=
  ⟨fun _ _ => projectedGateCRelease_from_wilson_residue,
    fun _ _ _ _ _ _ _ => projectedWilsonGateCRelease_under_full_audit,
    kreinPositive_not_noGhostZeros,
    wilsonReleasedData_releases_full_audit,
    projectedWilsonRelease_not_bareGateCRelease⟩

end PhysicsSM.Draft.NullEdgeProjectedGateCWilsonRelease
