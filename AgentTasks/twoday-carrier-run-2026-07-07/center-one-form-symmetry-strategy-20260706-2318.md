# Aristotle focused strategy prompt: finite one-form center symmetry layer

Metadata:
- Status: submitted 2026-07-06 23:07 -07:00
- Project: `f8cdf5c2-1990-446a-a072-49d2603b6738`
- Task: `987a9882-c129-4ef0-9b53-e1819d1a96ad`
- Stage directory: `AgentTasks/aristotle-submit/tc-center-one-form-strategy-20260706`
- Context pack: `AgentTasks/context-packs/center-one-form-symmetry-20260706-225551.md`

You are a skeptical Lean/math strategy assistant for the StandardModel Lean 4
repository. This is a strategy/audit job, not a proof job. Do not edit code.
Deliver a Markdown report with exact proposed Lean statement shapes, naming, and
claim boundaries.

## Program context

The current GateYM lane has a finite center-flux/electric-sector API and a
Tomboulis-Yaffe twist-system API. Fable suggested reframing this lane as a
finite shadow of one-form center symmetry, in the sense of generalized global
symmetries (GKSW) plus lattice gauge-theory center twists (Tomboulis-Yaffe and
Kanazawa-style SU(N) center-twist notation).

We need an honest Lean layer that connects what is already kernel-checked to
that interpretation without claiming continuum confinement, symmetry breaking,
 Ward identities, anomaly inflow, or an actual `H^2(K,Z(G))` cohomology
construction unless those objects are explicitly present.

## Existing Lean ingredients

Please inspect the staged sources and the context pack. The important files are:

- `PhysicsSM/Draft/NullEdge/GateYM/CenterFluxSector.lean`
  - `ShiftSystem`, `InElectricSector`, `ShiftInvariantObservable`,
    `inElectricSector_multiplyObservable`, `KernelInvariantUnderShifts`,
    `inElectricSector_applyKernel`
  - concrete finite torus link-field model `TorusLinkFieldG`
  - center flux shifts `xFluxShift`, `yFluxShift`, `torusCenterShiftSystem`
  - plaquette invariance under center shifts
  - `shiftInvariant_of_factorsThroughPlaquettes`
  - `inElectricSector_multiplyPlaquetteObservable`
- `PhysicsSM/Draft/NullEdge/GateYM/FluxSectorGeneral.lean`
  - abstract sector labels, projections, support, transfer label preservation
- `PhysicsSM/Draft/NullEdge/GateYM/TYAreaLawSUN.lean`
  - abstract `TwistSystem N`, ratios, `pN`, `tyBaseSUN`, `tySunTension`
  - `tyAreaLawSUN` and strict positivity under an explicit strict-twist witness
- `PhysicsSM/Draft/NullEdge/GateYM/TYTwistSystemZ2.lean`
  - concrete `Z2` one-plaquette twist system with `Z_le` derived
  - `z2AreaLaw`

The current provenance anchors are:

- GKSW generalized global symmetries: Zotero key `AXAWAGGB`, arXiv `1412.5148`,
  DOI `10.1007/JHEP02(2015)172`. Use only as framing provenance unless the
  report gives a precise finite theorem it supports.
- Tomboulis-Yaffe 1985: key `N7SIEMAC`, rigorous reflection-positivity /
  center-twist inequality lineage.
- Kanazawa finite-temperature SU(N) center-twist notation: key `K9FIBTZC`.

## Requested output

1. Truth audit. Is it mathematically honest to describe the existing finite
   center-shift/electric-sector layer as a finite one-form center-symmetry
   shadow? If yes, state exactly what is modeled and what is not. If no, give
   the counterexample or missing structure.
2. Smallest Lean API. Propose the smallest additive API that can sit on top of
   the current files. Prefer reusing `ShiftSystem` unless a new structure is
   genuinely needed. Give exact theorem/definition names and Lean statement
   sketches, including namespaces and file placement.
3. TY connection. Say whether the `TwistSystem` ratio/area-law API should be
   tied to the center-symmetry layer now, or remain a separate provenance bridge.
   If tying them is honest, give the exact statement shape. If not, explain the
   missing object.
4. Non-claims and docstring language. Provide 5-8 explicit phrases that should
   appear in docstrings to avoid overclaiming confinement, continuum one-form
   symmetry, spontaneous breaking, anomalies, or cohomology.
5. Next jobs. Rank the top 3-5 next proof or strategy jobs for Codex in the
   GateYM lane, with stale-check notes against the staged files.

Success criterion: a decision-forcing plan that tells us whether to prove a
small finite identity now, write only documentation/provenance, or park the
one-form language until a genuine background-field/cohomology object exists.
