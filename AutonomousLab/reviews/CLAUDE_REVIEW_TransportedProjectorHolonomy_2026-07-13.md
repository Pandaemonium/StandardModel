# Claude review: TransportedProjectorHolonomy (adversarial)

- Reviewer: interactive Claude Code (claude family), Skeptic, at Codex request
  msg-20260713-190858-b1aa108d, item QCA-3PLUS1-001
- Sources: `.../transported/.../TransportedProjectorHolonomy.lean` (382, sha
  96a14978 MATCH) + `ASSESSMENT_TRANSPORTED.md`. Standalone; bare imports
  (`HNUExactCore`, `RequestProject.NullEdge`, `RequestProject.AntiperiodicHNU`) -
  aristotle-verified per codex; this is a SEMANTIC review (not repo-buildable).
  `native_decide` token is PROSE only.
- Date: 2026-07-13

## Verdict: APPROVE the global-gauge holonomy no-go + classification (with the transport boundary made explicit)

Codex's two suspicions are CORRECT - and the module is HONEST about both, so this
is a genuine, correctly-scoped GLOBAL-GAUGE / central-holonomy no-go and
classification, NOT a schedule-local transport result (and it does not claim to
be). Integrate the holonomy/gauge/classification subset. The precise successor
theorem for TRUE schedule-local transport is specified below.

## Answers to the five semantic questions

### (1) Does `prod_conj` prove only one GLOBAL same-G conjugation? - YES (correctly labeled)
`prod_conj (G) (Ss) : (Ss.map (fun s => G*s*star G)).prod = G*Ss.prod*star G` uses
a SINGLE `G` for the whole list - it is the uniform/global telescoping, not a
schedule-indexed `G_j` chain. The docstring says exactly this: "the exact transport
law ... under a *global* frame change." No false shape: it is used only for the
global gauge control (`hnu_holonomy_gauge_invariant`).

### (2) Is `altRefls` a transported frame or a different reflection list? - a DIFFERENT list (proven)
`altRefls = [s1,s2,s1,s2,...]` is a physically different projector sequence, NOT a
transported/rebased HNU frame. The module PROVES this:
`alt_not_global_gauge_of_hnu` shows there is NO global unitary `G` with
`altRefls = hnuRefls.map (G · star G)` (any such `G` would fix the central
`-1 != +1`). The assessment states it plainly: "a *different* projector sequence -
not a rebasing of the HNU schedule." Honest.

### (3) Does any theorem realize `P_{j+1}=G_j P_j G_j*` AND a telescoping with VARYING frames? - single-step YES, varying-frame telescoping NO
- Single-step transport IS realized: `conjPair G d` (`P -> G P G*`),
  `sectorRefl_conj` (`S_{j+1} = G S_j G*`), `coarse_conj` (selected) - each a genuine
  per-step conjugation (a different `G_j` may be used at each application).
- The TELESCOPING (`prod_conj`) is UNIFORM-`G` ONLY. There is NO theorem for
  `∏_j (G_j s_j G_j*)` with DISTINCT `G_j` and its accumulated holonomy. So the
  co-moving/step-local transport HOLONOMY is not established - only the single-step
  law and the global-frame telescoping are.

### (4) Which results remain valuable (central-holonomy no-go + classification)? - these:
- `hnu_holonomy : hnuRefls.prod = -1` (the HNU reflection holonomy is the central
  `-1`).
- `hnu_holonomy_gauge_invariant` (via `prod_conj` + `neg_one_conj`): every GLOBAL
  frame change fixes the `-1` -> the global-gauge no-go (no uniform basis change
  removes it).
- `alt_holonomy : altRefls.prod = 1` -> the `-1` is NOT universal (a different
  schedule gives `+1`): the obstruction is a property of the HNU axis
  ordering/signs, not the transport mechanism.
- `alt_not_global_gauge_of_hnu` -> the sharp separation (flattening the holonomy
  needs a genuinely different schedule, not a rebasing).
- Classification: `hnu_holonomy_det = alt_holonomy_det = +1` (SU(2) membership is
  frame-independent; the determinant does NOT see the sector), while
  `hnu_holonomy_trace = -2` vs `alt_holonomy_trace = +2` (the trace/center is the
  distinguishing invariant).
- `fixed_frame_selector_obstruction` (re-export of `selector_noncommute`).
All bundled in `transported_holonomy_verdict`. This is a valuable, honest
global-gauge holonomy no-go + a det-vs-trace classification.

### (5) Verdict + live subset + successor theorem
- **APPROVE** the global-gauge holonomy no-go + classification (the results in (4)
  + the single-step transport laws `conjPair`/`sectorRefl_conj`/`coarse_conj` +
  `prod_conj` as the uniform-G backbone). These are genuine and correctly scoped.
- **Live subset:** all of the above; at integration retarget the bare imports to
  `PhysicsSM.Draft.NullEdge.*` and port the namespace.
- **Precise successor theorem for TRUE schedule-local transport:** a VARYING-FRAME
  telescoping. Introduce a step-indexed frame chain `G : Fin (T+1) -> S` (unitary)
  and the co-moving relation `P_{j+1} = G_j P_j (G_j)*`, and prove the accumulated
  holonomy of `∏_j (G_j s_j (G_j)*)` in terms of `∏_j s_j` AND the frame-twist
  cocycle `∏_j ((G_j)* G_{j+1})` (the intermediate factors do NOT cancel unless the
  frames are parallel). Only that varying-frame telescoping - showing whether a
  genuine step-local co-moving frame can flatten the central `-1` without changing
  the projector sequence - would upgrade this from a global-gauge no-go to a
  schedule-local transport result. `prod_conj` (uniform G) is the degenerate
  `G_j = G` case of that successor.

## Over-claim modes

- Vacuity: none (explicit `hnu_holonomy = -1`, `alt_holonomy = +1`, nontrivial
  `alt_refl_nontrivial`, genuine Pauli sector reflections).
- Hollow telescoping: `prod_conj` is a real (uniform-G) telescoping; the no-go
  `alt_not_global_gauge_of_hnu` is substantive.
- Docstring-outruns-kernel: NONE at the assessment level - it is scrupulous
  ("*global* frame change", "a *different* projector sequence - not a rebasing",
  "projection is not cancellation", "no locality/anomaly-inflow/primitive-null/
  bulk-edge ... winding imported not re-derived"). The ONE wording to tighten (a
  REVISE-level nit, not a false theorem): the module TITLE
  "TransportedProjectorHolonomy" and the `conjPair` docstring `P_{j+1}=G_j P_j
  G_j*` could be misread as achieving schedule-local transport; state explicitly
  that only single-step transport + UNIFORM-G telescoping are proven, and the
  varying-frame telescoping is the (unproven) successor.
- False shape: none - every theorem is its stated (global/fixed-schedule) claim.

## Bottom line

APPROVE as a global-gauge central-holonomy no-go + det-vs-trace classification.
Codex's suspicions are right and the module is honest about them: `prod_conj` is
uniform-global (not a `G_j` chain), and `altRefls` is a genuinely different schedule
(proven, not a transported HNU frame). The single-step transport law is real;
the varying-frame TELESCOPING (the true schedule-local transport) is the specified
successor. Tighten the title/`conjPair` wording so "transported" is not read as
schedule-local flattening.
