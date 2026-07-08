# LIT-PROV SourceTrace closeout - 2026-07-07

Local Codex waiting-lane work while Fable owns dynamics and Aristotle continues
the hard-piece lanes.

## Result

Expanded `PhysicsSM/Meta/SourceTrace.lean` from a stub into a lightweight
provenance metadata vocabulary:

- `SourceKind`: paper, book, repo, oracle, cleanroom.
- `SourceRole`: theorem support, convention, comparison, inspiration,
  computational evidence.
- `VerificationStatus`: pending, identifier-only, no-full-text, verified,
  rejected.
- `ClaimGrade`: `T`, `T|H`, `M`, `C`, memo.
- `SourceRef`: source key, kind, title, identifier, locator, verification
  status.
- `ConventionCheck`: named convention checks such as metric signature,
  octonion basis, chirality, scalar field, normalization, or linearity.
- `TraceRecord`: a source/provenance record for a Lean declaration, Markdown
  section, or oracle fixture.

The file also supplies small constructors:

- `SourceRef.pendingPaper`
- `SourceRef.identifierOnlyPaper`
- `SourceRef.cleanroom`
- `ConventionCheck.pending`
- `ConventionCheck.verified`
- `TraceRecord.cleanroom`
- `TraceRecord.comparison`

## Claim Boundary

This does not add, verify, or promote any bibliography item.  It is intentionally
only a typed shape for future provenance records.  It helps close the source-gap
audit by making the difference explicit between:

- a source that genuinely supports a theorem after statement/convention match,
- a source used only for convention or terminology,
- a comparison/background source,
- a clean-room formalization,
- computational evidence or an oracle fixture.

## Related Source Map

`Sources/Null_Edge_References.md` already exists as the live conservative
null-edge reference map.  The new `SourceTrace` vocabulary is the Lean-side
metadata companion to that Markdown map.

## Verification

Passed:

- `lake env lean PhysicsSM/Meta/SourceTrace.lean`
- `lake build PhysicsSM.Meta.SourceTrace`

No project theorem statements were changed.
