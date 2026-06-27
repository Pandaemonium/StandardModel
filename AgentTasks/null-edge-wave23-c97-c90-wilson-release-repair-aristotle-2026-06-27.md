# Aristotle C97: repair/validate reconstructed C90 Wilson-release hardening

Date: 2026-06-27
Type: focused Lean repair/integration job
Target file: `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean`

## Background

Aristotle job C90 (`d53724a6-a0aa-4f8a-9c85-5285177fd16b`) returned a raw task summary claiming it hardened `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean`, but the downloadable archive omitted that changed file. Codex reconstructed the C90 hardening manually from the raw task summary.

Because the hand reconstruction was not build-checked locally, this job asks Aristotle to repair/validate the target module without changing the intended semantics.

## Task

Make `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean` compile, preserving the C90 hardening intent. Do not weaken the theorem statements just to pass. If the hand reconstruction contains a semantic or type-level problem, fix it with the smallest local edit and report the issue.

## Intended C90 API surface

Preserve or implement these declarations if possible:

```text
ProjectedWilsonGateCRelease
GateCReleased                  -- compatibility shim, preferably deprecated
projectedWilsonGateCRelease_iff
gateCReleased_iff

PostGaugeResidueKreinPositive
NoGaugeCoupledGhostZeros
PostGaugeGoltermanShamirSafe
PostGaugeGoltermanShamirSafe.toGhostZeroSafe
PostGaugeResiduePositive.toKreinPositive
PostGaugeResiduePositive.toGoltermanShamirSafe_trivialBRST

WilsonRegulatorModuliAudit
WilsonRegulatorModuliAudit.toWilsonRegulatorAudited

projectedGateCRelease_from_wilson_residue
projectedWilsonGateCRelease_under_full_audit

wilsonReleasedModuliAudit
wilsonReleasedData_releases_full_audit
projectedWilsonRelease_not_bareGateCRelease

wilsonDangerousData
kreinPositive_not_noGhostZeros
c90_wilson_release_summary
c72_wilson_release_summary
```

## Semantic constraints

- `ProjectedWilsonGateCRelease d` should be a thin alias of `ProjectedGateCRelease d`.
- The old `GateCReleased` name should remain available for compatibility, but the preferred name should be `ProjectedWilsonGateCRelease`.
- `PostGaugeResidueKreinPositive` is residue positivity only and must not imply ghost-zero safety.
- `NoGaugeCoupledGhostZeros d` should be the static ghost-zero safety clause for `d`.
- `PostGaugeGoltermanShamirSafe d BRSTSafe` should include residue positivity, no ghost zeros, and an explicit `BRSTSafe` obligation.
- `projectedWilsonGateCRelease_under_full_audit` should require the full Golterman-Shamir package and hardened regulator moduli audit.
- `WilsonRegulatorModuliAudit` should make the moduli-policy clauses explicit parameters or fields, and should forget to the legacy `WilsonRegulatorAudited`.
- `kreinPositive_not_noGhostZeros` should be a concrete non-implication witness: residue/Krein positivity alone does not supply `NoGaugeCoupledGhostZeros`.
- The old C72 theorem names should remain usable as compatibility shims.

## Guardrails

Do not introduce `s o r r y`, `a d m i t`, new `a x i o m`, `o p a q u e`, or `u n s a f e` code.

Do not delete the old API unless unavoidable; prefer compatibility shims.

Do not turn ghost safety into a theorem from residue positivity alone.

Do not add a theorem implying C1 release from C0 species/regulator health.

Keep edits local to `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean` unless an import is genuinely missing.

## Verification requested

Run at least a targeted check/build for the module if possible, and report the command/output. If a broader build is blocked by unrelated repo issues, say so explicitly and provide the targeted result.

## Output summary requested

Please report:

- whether the target file compiles;
- which C90 declarations were preserved, renamed, or could not be made to typecheck;
- any semantic mismatch found in Codex's reconstruction;
- any remaining open obligations that are hypotheses rather than proved physics.
## Cycle 5 packaging note

A full `aristotle submit --project-dir .` attempt failed because Aristotle refuses the repo's local `SpherePacking` dependency. The live submission `789e2eab-7432-4558-af5a-c757cf43512b` was therefore prompt-only. Treat its return as a proof-specialist repair/report, not as a kernel-checked full-repo build, unless the return explicitly demonstrates a check in a reconstructed context.
