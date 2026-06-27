# C63 — Post-gauge ghost-safety / residue clause for Route-B Gate C

**Status:** completed, kernel-checkable Lean module, `sorry`-free.

**Module:** `PhysicsSM/Draft/NullEdgeProjectedGhostSafety.lean`
(namespace `PhysicsSM.Draft.NullEdgeProjectedGhostSafety`).

**Aligned against:** the C59 seven-clause projected Gate C release certificate in
`PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean`
(`PhysicsSM.Draft.NullEdgeProjectedGateCRelease.ProjectedGateCRelease`).

## Headline answer

Gate C is **still blocked at exactly one clause: clause 6, `GhostZeroSafe`
(ghost-zero safety / residue positivity).**

The other six C59 clauses (nodal-set control, branch-projector control, projected
kernel one-dimensionality, projected chirality alignment, projected Krein
positivity, species-splitting audited) are all instantiated non-vacuously on the
C59 `releasedData` witness. Clause 6 is **not** unconditionally dischargeable:
this module proves a counterexample showing that projected chirality alignment, a
nonzero flavored index, **and** gauge covariance of the link-dressed branch
projector *together* still fail to imply ghost-zero safety. Clause 6 is reduced
**exactly** to a residue-positivity assumption, equivalently the C47/C48
`PostGaugeGhostSafe` weak-coupling contract, which remains the open C58
obligation on the actual projected operator data.

## What the module adds (no parallel certificate invented)

It works entirely against the existing APIs:

* C59 `ProjData` and its seven clauses, and the C59 main theorem
  `projected_gateC_release`, are reused verbatim;
* the C47/C48 ghost-zero calculus (`ZeroDatum`, `ZeroDatum.IsFatalGhost`,
  `GhostZeroSafe`, `ghostZeroSafe_iff`, `ghostZeroSafe_of_no_fatal_label`,
  `KreinPositivePhysicalSector`, `PostGaugeGhostSafe`, witnesses) is reused
  verbatim;
* the C61 gauge-covariant link-dressed projector (`DressedBranchProjector`,
  `GaugeCovariant`) is reused verbatim.

### 1. The projected physical-sector zero datum

`ProjectedZeroSector n V` bundles the C59 projected/species-split dataset
(`proj : ProjData`) with the C61 gauge-covariant link-dressed branch projector
(`dressed : DressedBranchProjector n V`), subject to `zeros_compat`: the dressed
projector introduces *exactly* the C59 enumerated zero spectrum. This single
object is compatible with the branch-projector, species-split, and
gauge-covariant-projector APIs at once. Its link-dressed projector is always
gauge covariant (`ProjectedZeroSector.dressed_gaugeCovariant`).

### 2. Residue control = ghost-zero safety

`ResidueControlled zs` ("every gauge-coupled propagating zero keeps a nonnegative
Krein residue") is proved exactly equivalent to spectrum-level ghost-zero safety
(`residueControlled_iff_ghostSafe`). This pins down precisely what a weak-coupling
estimate must establish about the projected modes.

### 3. Conditional clause-6 instantiation

* `projectedSector_ghostZeroSafe` — residue control of the spectrum instantiates
  C59 clause 6.
* `projectedSector_ghostZeroSafe_of_labels` — honest non-fatal classification
  (well-classified, no `fatalGhostZero` label) also instantiates clause 6.

### 4. Reduction to the open post-gauge obligation

`ghostZeroSafe_of_postGaugeConst` — clause 6 follows from the C47
`PostGaugeGhostSafe` contract for the constant weak-coupling deformation of the
enumerated spectrum (free-field zeros stable under switching on weak gauge
coupling). `projectedSector_ghostZeroSafe_of_postGaugeConst` is the sector form.
This is the precise sense in which clause 6 is *reduced to* — not magically
discharged by — the open C58 weak-coupling residue obligation.

### 5. Full release and non-vacuity

`projectedSector_release` — the six other clauses plus residue control entail the
bundled C59 `ProjectedGateCRelease`, through `projected_gateC_release`.
`releasedSector` / `releasedSector_releases` witness non-vacuity (the canonical
released sector with a benign single physical-pole spectrum).

### 6. The blocked-clause guardrail (the sharp negative result)

`chirality_index_covariance_not_ghostSafe`: there is a `ProjectedZeroSector`
(`dangerousSector`) whose projected chirality is aligned, whose flavored index is
nonzero (in fact maximal `= 4`), and whose link-dressed branch projector is gauge
covariant, yet which is **not** ghost-zero safe (it harbours a Golterman–Shamir
fatal ghost zero) and therefore does **not** release Gate C. Hence clause 6 is
genuinely independent of the kinematic data and is the one clause that cannot be
discharged from projected chirality + flavored index + gauge covariance alone.

### 7. Summary theorem

`c63_projected_ghost_safety_summary` packages: the residue-control equivalence,
the clause-6 instantiation, the non-vacuous full release of `releasedSector`, and
the blocked-clause counterexample.

## Conventions reused

* four high-momentum null branches indexed by `Fin 4`;
* spacetime-chirality pattern `g5 = (+,+,-,-)` (`g5pattern`);
* flavored index `∑_a s_a · g5_a` (`flavoredIndex`);
* Krein residue convention `> 0` physical, `< 0` ghost, `= 0` non-propagating;
* fatal ghost = gauge-coupled propagating **and** negative Krein residue
  (`ZeroDatum.IsFatalGhost`).

## Honesty discipline

No new axioms, no `native_decide`, no opaque placeholders. The genuine content is
the logical reduction: clause 6 is equivalent to residue control and follows from
the open post-gauge contract, but is *not* implied by projected chirality +
flavored index + gauge covariance (explicit kernel-checked counterexample).
Discharging residue control / `PostGaugeGhostSafe` on the actual projected
operator data is the open C58 obligation.

## Repository note

The C59 file was found at the repository root
(`NullEdgeProjectedGateCRelease.lean`) where Lake could not resolve it as an
importable module. It was moved to the location stated in the task,
`PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean` (its declared namespace
already being `PhysicsSM.Draft.NullEdgeProjectedGateCRelease`), so that the C63
module can import it. No other module referenced it from the root path.
