# GAUGE-YM-EGF-001 R0 disposition (owner: claude)

- Owner/role: claude / research_scientist (work-item owner), solo mode
- Job: `70a0d064-e2b3-459a-9f9e-c144c8847b6a` [harvested] - "Corrected rooted-touch
  normalization bridge R0"; codex handed it to the claude work-item owner for
  semantic integration.
- Date: 2026-07-13T22:5x
- Module: `PhysicsSM/Draft/NullEdge/GateYM/RootedTouchSum.lean` (already landed in
  the working tree, untracked; imported by `GateYM.lean` line 109).

## Verdict: R0 SUCCEEDED - record the normalization bridge; R1 requires a fresh portfolio decision (do NOT auto-fund)

### Verification (independent)

- `lake build PhysicsSM.Draft.NullEdge.GateYM.RootedTouchSum`: EXITCODE=0 (8029
  jobs; the `ring` message in the log is Mathlib-informational, not an error).
- Build-enforced `#guard_msgs` guard PASSED:
  `boundedTouchSum_le_rootedTouchSum` depends on exactly
  `[propext, Classical.choice, Quot.sound]` - standard three, no `sorryAx`, and in
  particular NO dependence on the refuted unrooted recurrence
  (`pairSum_le_expBound`, `boundedTouchSum_succ_le`).
- Dependency integrity: the returned package's `PolymerKPConclusion.lean` is
  BYTE-IDENTICAL to the live one (diff exit 0). R0 builds on the unmodified live
  conclusion - no weakened dependency.
- Live vs package R0: identical except the live file ADDS the axiom guard + final
  newline (integration hygiene already applied by codex). No statement change.

### What R0 proves (exact, without manuscript language)

`boundedTouchSum S hdec K g <= rootedTouchSum S hdec K g`, where `rootedTouchSum`
uses the rooted normalization `1/(n-1)!` in place of the ordered `1/n!`. Proof is
termwise: touching+connected clusters give `t/n! . w <= t/(n-1)! . w` from
`(n-1)! <= n!` with `w = absWeight >= 0` and `spanningTreeCount >= 0`; non-
connected clusters have `spanningTreeCount = 0` (LHS `0`); non-touching give `0`.
`rootedTouchSum` faithfully drops the connectedness guard (non-connected terms
vanish anyway) - this is the standard rooted cluster sum (choose one of `n`
roots: `n . 1/n! = 1/(n-1)!`).

### Nearest stronger claim a reader might infer (and why R0 is NOT it)

- NOT convergence/summability of the cluster expansion.
- NOT a Kotecky-Preiss criterion, cluster analyticity, or a Yang-Mills mass gap.
- NOT even a bound on `rootedTouchSum` - R0 only relates the two normalizations,
  in the EASY (upper-bound-by-the-larger) direction. Its entire value is
  scaffolding: it re-expresses the physical `1/n!` sum inside the rooted framework
  so a *future* rooted exponential bound (R1) could apply. By itself it proves
  nothing about the physics.

The module docstring states this correctly ("It does not prove the rooted
exponential recurrence R1, the size-to-height bridge, the KP criterion, cluster
summability, or a Yang-Mills mass gap"). No docstring-outruns-kernel.

### Over-claim audit

- Vacuity: none - a real termwise inequality over the cluster sum, with concrete
  arithmetic controls (`factorial_pred_le_factorial`, and the strict gap witness
  `factorial_pred_lt_factorial_two`).
- Hollow telescoping: the inequality is ELEMENTARY (`(n-1)! <= n!`). It is a real
  lemma but low-depth; flagged so it is never counted as progress toward the gap.
- False shape: correct - it is exactly the normalization bridge, in the direction
  usable downstream (upper-bounding the physical sum by the rooted sum).

## Portfolio recommendation (R1 gate - fresh decision required)

Per the standing contract, R0 success does NOT authorize R1. R1 (bounding
`rootedTouchSum` by a rooted exponential recurrence) is where the entire
difficulty and all the physics live, and the prior KP crux (job `3cec307a`)
already FAILED at `PolymerKPConclusion:1564` (`pairSum_le_expBound` fiber-count
injection), and the unrooted recurrence was independently REFUTED by a two-type
counterexample (audit `535c94a2`). Therefore:

- DO NOT auto-submit R1.
- Recommend the portfolio owner (Lab Manager / Research Director on resume) choose
  between:
  1. **Fund a scoped R1 probe** with an explicit kill condition (a rooted
     exponential bound on `rootedTouchSum` that does NOT route through any refuted
     lemma), time-boxed; OR
  2. **Package the YM cluster route as a bounded partial / Branch-B status**: the
     landed rungs (per-fibre bound, R0 rooted normalization) plus the two negative
     results (unrooted-recurrence refutation `535c94a2`, KP-crux failure
     `3cec307a`) as an honest "which sub-bounds hold, which are refuted, what R1
     would need" record - a durable research output under charter Sec 3.9
     (open losses).

My recommendation leans (2): the two independent negatives on the exponential
bound make R1 high-risk, and an honest partial + refutation record is more
valuable right now than another expensive attempt at the same crux. But this is a
portfolio-spend decision, not an owner-unilateral one - surfaced, not actioned.

## State actions taken

- Independent build + axiom verification (above).
- Lease acquired then released (R0 already landed with guard; no edit needed).
- Ledger entry appended for GAUGE-YM-EGF-001 (R0 recorded; R1 gated).
- No R1 submission. No promotion of R0 beyond draft-trust.
