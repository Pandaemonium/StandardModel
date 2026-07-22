# Independent red-team: EDU-OVERVIEW-001

Reviewer: Codex / GPT family  
Builder: Claude / Opus family  
Verdict: **REVISE**

## Findings

### 1. Major: the general-reader entropy headline drops theorem hypotheses

In `Sources/Null_Edge_Program_Overview_Packet_2026-07-12.tex`, the subsection
"Null edges do not age" says that the entropy of the block is zero exactly
when the momentum is null, but does not state locally that the theorem assumes
`0 < p_0` and `spatialNormSq p <= p_0^2`.

The registry row and both technical anchors include those assumptions.  The
undergraduate and adjacent-researcher briefs state them correctly.  The
general-reader sentence should therefore read, in substance:

> For the displayed normalized two-level block of a positive-energy,
> future-cone momentum, the entropy vanishes exactly on the null boundary.

This preserves accessibility while keeping the theorem's domain visible.

### 2. Major: `entanglement` outruns the formal statement

The packet and undergraduate brief interpret the displayed von Neumann entropy
as "entanglement between null constituents."  The formal module defines the
binary entropy of an observer-conditioned normalized visible-momentum block.
It does not define a bipartite state, a partial trace, a purification, or an
entanglement measure.  Von Neumann entropy of a mixed block is not by itself an
entanglement theorem.

Replace `entanglement` with `directional mixing`, `visible-state entropy`, or
similarly neutral language.  A footnote may say that an entanglement reading
would require a specified bipartition and a theorem relating this block to its
reduced state.

## Checks that passed

- All ten named claim-registry rows exist and their grades agree with the two
  new briefs: nine grade `M`, with `E-SPEC` at `M+E`.
- The pair-only square law is correctly separated from the arbitrary-family
  cube law in the shared visual and caption.
- The doubling census does not claim an evasion.
- The covariance-forcing claim remains static and conditional on the two
  displayed probes.
- The Lambda item keeps the physical count identification open.
- The chiral projector item explicitly denies gauge, index, anomaly, and
  interacting conclusions.
- The frozen 2026-07-12 scope is stated, so later results are not silently
  absorbed into the old claim map.

## Required disposition

Make the two phrase-level corrections at every affected audience level, rerun
the shared-claim search, and return for a bounded re-review.  Actual human
comprehension testing remains a residual empirical task and is not supplied by
either model family's document audit.
