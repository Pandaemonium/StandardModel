import PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance
import PhysicsSM.Draft.NullEdge.QMF.SpecialUnitaryCompact
import PhysicsSM.Draft.NullEdge.QMF.GaugeHaarInvariance
import PhysicsSM.Draft.NullEdge.QMF.ProductHaarConfig
import PhysicsSM.Draft.NullEdge.QMF.ProductHaarZ2RP
import PhysicsSM.Draft.NullEdge.QMF.AxiomGuard

/-!
# QMF aggregator: the compact-group reflection-positivity substrate (QMF1-RP)

Pure import aggregator for the QMF (QCD mass formalism) ladder's first rung -
the compact-group Haar / reflection-positivity substrate that the day-2
capability survey identified as the "cheap, Haar only" lane (see
`AgentTasks/fourday-ym-run-2026-07-05/RUN_PLAN.md`, threads `replan:qmf-ladder`,
`qmf1a:capability-survey`, and `qmf1b`-`qmf1e`).

Contents (draft-trust, kernel-checked; the single-link substrate and the
multi-link bare product-Haar rung are `s o r r y`-free. The remaining pending
physics rung is reflection positivity for the **interacting** Wilson measure,
where the Boltzmann weight couples the two sides of the cut and the bare
product-factorization proof no longer applies):

* `CompactHaarInvariance` - gauge (conjugation) and reflection (inversion)
  invariance of the single-link compact-group Haar expectation; a proof that
  compact groups are UNIMODULAR (`compactGroup_haar_isMulRightInvariant`,
  `..._isInvInvariant`), closing a genuine pinned-Mathlib gap for nonabelian
  groups; and an unconditional finite-group (`Measure.count`) model.
* `ProductHaarConfig` - the multi-link rung: the product Haar measure
  `Measure.pi` over a finite edge set `∏_e SU(N)` is again Haar
  (`productHaar_isHaarMeasure`), with per-link/endpoint gauge invariance and the
  measure-preserving link-reflection involution PROVED; the RP bilinear form
  `reflForm` is DEFINED and its bare product-Haar diagonal nonnegativity
  `reflForm_self_nonneg` is PROVED by disjoint-block product-measure
  factorization, with no Peter-Weyl / character orthogonality input.
* `ProductHaarZ2RP` - a concrete finite ABELIAN instance `G = Z2`
  (Peter-Weyl-free): `productHaarZ2_reflForm_self_nonneg_oneLink` and
  `..._twoLink` prove `0 <= reflForm F F` on the `Fin 1` and `Fin 2` (genuine
  cut) lattices as explicit sums of squares - `s o r r y`-free.
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
`SU(N)` link-symmetry substrate plus the bare multi-link product-Haar
reflection form. It is NOT RP for the interacting Wilson theory and NOT a
transfer operator: no Wilson Boltzmann weight, no character-expansion slab, and
no OS Hamiltonian are constructed here. Interacting-measure RP and the
Peter-Weyl character-expansion (`Q7`/KP) sublane remain separate gaps, correctly
parked and nowhere assumed.
-/
