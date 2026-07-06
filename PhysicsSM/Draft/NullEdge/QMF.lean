import PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance
import PhysicsSM.Draft.NullEdge.QMF.SpecialUnitaryCompact
import PhysicsSM.Draft.NullEdge.QMF.GaugeHaarInvariance
import PhysicsSM.Draft.NullEdge.QMF.ProductHaarConfig
import PhysicsSM.Draft.NullEdge.QMF.AxiomGuard

/-!
# QMF aggregator: the compact-group reflection-positivity substrate (QMF1-RP)

Pure import aggregator for the QMF (QCD mass formalism) ladder's first rung -
the compact-group Haar / reflection-positivity substrate that the day-2
capability survey identified as the "cheap, Haar only" lane (see
`AgentTasks/fourday-ym-run-2026-07-05/RUN_PLAN.md`, threads `replan:qmf-ladder`,
`qmf1a:capability-survey`, and `qmf1b`-`qmf1e`).

Contents (draft-trust, kernel-checked; the single-link substrate is
`s o r r y`-free, and the multi-link rung `ProductHaarConfig` carries exactly one
clearly-labelled FROZEN handoff `s o r r y` - the RP-positivity bilinear-form
target `reflForm_self_nonneg`, whose proof needs the out-of-scope
Wilson-slab / Peter-Weyl input; its measure-theoretic symmetries are proved):

* `CompactHaarInvariance` - gauge (conjugation) and reflection (inversion)
  invariance of the single-link compact-group Haar expectation; a proof that
  compact groups are UNIMODULAR (`compactGroup_haar_isMulRightInvariant`,
  `..._isInvInvariant`), closing a genuine pinned-Mathlib gap for nonabelian
  groups; and an unconditional finite-group (`Measure.count`) model.
* `ProductHaarConfig` - the multi-link rung: the product Haar measure
  `Measure.pi` over a finite edge set `∏_e SU(N)` is again Haar
  (`productHaar_isHaarMeasure`), with per-link/endpoint gauge invariance and the
  measure-preserving link-reflection involution PROVED (`s o r r y`-free); the RP
  bilinear form is DEFINED and its positivity is the single FROZEN handoff
  (needs Peter-Weyl / the Wilson slab).
* `SpecialUnitaryCompact` - the physical gauge groups `U(n)`, `SU(n)` are
  COMPACT (`specialUnitaryGroup_isCompact`, via a Tychonoff box + closedness +
  row-orthonormality entry bound) and are TOPOLOGICAL GROUPS
  (`specialUnitaryGroup_isTopologicalGroup`, inversion continuity from
  `A⁻¹ = star A`) - both missing from pinned Mathlib.
* `GaugeHaarInvariance` - the capstone: gauge and reflection invariance of the
  `SU(N)` Haar expectation (`specialUnitaryGroup_haar_gauge_invariant`,
  `..._reflection_invariant`), the two Osterwalder-Seiler link symmetries for the
  physical nonabelian gauge group, with `specialUnitaryGroup_exists_isHaarMeasure`
  recording non-vacuousness.

Kernel-check the whole substrate in one command:

    lake build PhysicsSM.Draft.NullEdge.QMF

Draft-trust; not added to the default trusted build target. Four genuine
pinned-Mathlib capability gaps are found and closed here (right- and
inv-invariance from compactness; `U(n)`/`SU(n)` compactness; `U(n)`/`SU(n)`
topological-group
structure). Scope (per the QMF-RP load-bearing audit, `bb6b33c3`): this is the
`SU(N)` single-link LINK-SYMMETRY substrate - the gauge/reflection-invariance
ingredients an OS reflection positivity needs at each link. It is NOT itself RP:
there is no lattice, no reflection operator on configurations, no positivity
statement, and no transfer operator here. The RP bilinear form and the finite
lattice / product-Haar construction (`Measure.pi` over `∏_e SU(N)`) are the
pending next rung; the Peter-Weyl character-expansion (`Q7`/KP) sublane is a
separate gap, correctly parked and nowhere assumed.
-/
