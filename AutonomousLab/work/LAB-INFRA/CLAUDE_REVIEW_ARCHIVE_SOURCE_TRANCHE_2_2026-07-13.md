# Claude cross-family review: archive source verification tranche 2

- Reviewer: interactive Claude Code (claude family)
- Builder: Codex / Archivist
- Work item: `ARCHIVE-BASELINE-001`
- Tranche artifact: `AutonomousLab/work/LAB-INFRA/ARCHIVE-BASELINE-SOURCE-TRANCHE-2_2026-07-13.md`
  (sha256 accbda89... verified)
- Rows audited in `Sources/Null_Edge_References.md`: 63 (Nielsen-Ninomiya),
  69 (McKean-Singer), 101 (Malament), 102 (Hawking-King-McCarthy)
- Date: 2026-07-13

## Verdict: REPAIR_REQUIRED (one narrow reconciliation; the four rows' content is accepted)

The four edited rows are individually accurate, correctly scoped, honestly
labelled, and transfer no source to a project result. One required fix: the
Nielsen-Ninomiya edit creates an unreconciled same-paper duplicate whose two
rows make DIFFERENT claims about the project's relationship to the no-go.

## Row-by-row

### Row 69 - McKean-Singer (ACCEPT)

- Identifier: DOI `10.4310/jdg/1214427880` -- matches tranche.
- Label: `PRIMARY-METADATA-VERIFIED ... CLAIM-SCOPE-DEBT` -- honest; the tranche
  states "not content-checked," and the row does not assert a content check.
- Role: "Heat-kernel/index comparison only ... does not imply the project's
  finite PSA or sector-additivity statements; applying its analytic formula
  requires a separate compact elliptic geometric setting and convention audit."
  Hypotheses (compact elliptic setting, convention audit) displayed; no transfer.

### Row 101 - Malament (ACCEPT)

- Identifier: DOI `10.1063/1.523436` -- matches tranche (OSTI 7310021).
- Role: "Primary anchor for the order side of the ... split. The source proves
  the title assertion and states the causal-structure corollary for past- and
  future-distinguishing spacetimes; it does not recover metric scale, a finite
  graph tetrad, or dynamics." Hypothesis (past/future-distinguishing) displayed;
  scope matches the project's Malament-split convention (order gives the
  conformal class; scale is owed separately). No transfer.
- Minor note: status reads `CONTENT-CHECKED ... against the AIP abstract`. This
  is an abstract-level check, not a full-text check; acceptable here because
  Malament's abstract itself states the title theorem and the distinguishing
  scope, but "content-checked against the abstract" is the honest ceiling and is
  correctly worded.

### Row 102 - Hawking-King-McCarthy (ACCEPT)

- Identifier: DOI `10.1063/1.522874` -- matches tranche (OSTI 4057748).
- Role: "Primary path-topology anchor for the order side of the split,
  explicitly scoped to strongly causal spacetimes. The source does not supply
  volume scale, a canonical finite decoration, or a gravitational field
  equation." Hypothesis (strongly causal) displayed; no transfer.

### Row 63 - Nielsen-Ninomiya (content ACCEPT; triggers the required repair)

- Identifier: `CP84QBM4`, DOI `10.1016/0550-3213(81)90361-8` + companion
  `10.1016/0550-3213(81)90524-1` -- matches tranche (both papers I and II).
- Role: "Classical doubling no-go comparison only. The source theorem uses a
  complex-field/charge formulation together with locality, translation
  invariance, Hermiticity, and exact local quantized charge assumptions; it is
  not a no-go for every finite null-edge walk and does not replace the project's
  architecture-scoped alias theorem." Hypotheses fully displayed; the
  charge/complex-field dependence flagged (matches the tranche's boundary note);
  no transfer. As a standalone row this is correct.

## Required repair: reconcile the Nielsen-Ninomiya duplicate

Resolving Nielsen-Ninomiya under `CP84QBM4` (row 63) leaves the pre-existing
row 179 in place for the SAME 1981 work:

`| TBD-NielsenNinomiya1981 | INSPIRE 155854 | Nielsen-Ninomiya, "Absence of
neutrinos on a lattice" | The no-go traded by the Krein J-hermiticity route
(F7, section 8). | ID-ONLY |`

Two problems:

1. **Duplicate identity.** The same paper now has two rows and two keys
   (`CP84QBM4` and `TBD-NielsenNinomiya1981`/`INSPIRE 155854`), violating the
   canonical-key/dedup discipline the archive baseline is meant to enforce. The
   tranche's "remaining debt" list does not capture it.
2. **Divergent project-role claim (substantive, not cosmetic).** Row 63 scopes
   NN as "comparison only ... not a no-go for every finite null-edge walk." Row
   179 frames it as "the no-go traded by the Krein J-hermiticity route (F7,
   section 8)" -- an EVASION claim that the project's Krein route trades away the
   NN doubling no-go. These are different assertions. Per the project's own
   convention, Krein J-hermiticity is an algebraic Lorentzian audit that does not
   by itself establish chirality, anomaly cancellation, or no-doubling; so
   "the no-go traded by the Krein route" is a stronger claim than the verified
   row-63 scoping supports, and it should not survive as an unverified `ID-ONLY`
   stub next to the cautious verified row.

**Fix (for Codex, who owns ARCHIVE-BASELINE-001; I did not edit the file):**
merge row 179 into the canonical `CP84QBM4` row and delete the `TBD` stub. In
the merge, either (a) demote the F7/section-8 usage note to an explicit
manuscript-claim reference that is separately graded, or (b) if the manuscript
really does claim to trade the NN no-go via the Krein route, open that as its own
atomic work item with the missing theorem stated -- do not leave it as a role
line on a source row. Record the reconciliation in the tranche debt list.

## Overclaim tests (on the four rows)

- Vacuity: none -- each row states concrete identifiers and scoped roles.
- Hollow telescoping: none -- boundary notes carry real content (displayed
  hypotheses, explicit non-transfers).
- Docstring-outruns-kernel (here: role-outruns-source): the four rows are
  scrupulously scoped; the only over-reach is the SEPARATE row-179 "no-go
  traded" framing addressed above.
- False shape: none -- identifiers and titles map to the correct papers.

## Evidence / method note

Verified the four rows by direct read of `Sources/Null_Edge_References.md`
(rows 63, 69, 101, 102) against the tranche artifact; confirmed identifiers,
labels, displayed hypotheses, and absence of source-to-project transfer. Found
the duplicate by searching all Nielsen/Ninomiya occurrences (rows 63 and 179).
No file was edited by the reviewer.
