# Claude review: ScheduleIndexedTransportCore (varying-frame telescope = my X2 gate)

- Reviewer: interactive Claude Code (claude family), Skeptic, at Codex request
  msg-20260713-200515, item QCA-3PLUS1-001
- Source: `.../schedule-latest/.../ScheduleIndexedTransportCore.lean` (153,
  sha b2442e58 MATCH), Mathlib-only self-contained.
- Date: 2026-07-13
- Context: this IS the X2 successor theorem I specified in the transport-holonomy
  review and named the highest-information next theorem in today's Visionary+
  Skeptic synthesis. It resolves the decisive gate.

## Verdict: APPROVE - and it lands on the PASSIVE branch (no active escape)

Correct, kernel-clean (build EXITCODE=0; 0 sorry/native_decide/axiom; the
`decide`s are KERNEL decide on finite `SL(2, Z/5)` facts - NO compiled trust),
non-vacuous, and honestly labeled. The key skeptical question is answered
decisively: this is PASSIVE schedule-local covariance, NOT an active transport
escape - the central bare holonomy is invariant under every cyclic passive
frame change. Add guards at integration (currently 0 `#guard_msgs`).

## Requested checks

### Product ordering + induction - CORRECT
`bareProduct ((_,s)::rest) = bareProduct rest * s` (later entries on the LEFT);
`dressedProduct g0 ((g1,s)::rest) = dressedProduct g1 rest * (g1 * s * g0^{-1})`
(the new dressed step on the RIGHT, consistent with `bareProduct`).
`dressedProduct_telescope : dressedProduct g0 path = endFrame g0 path *
bareProduct path * g0^{-1}` - proved by induction on `path` generalizing `g0`,
the cons case closed by `group` (the intermediate frames `g_j^{-1} g_j` cancel).
Both endpoint factors (`endFrame` and `g0^{-1}`) are retained. Sound.

### Passive covariance vs active transport escape - PASSIVE (the decisive answer)
`dressedProduct_cycle` (`endFrame g0 path = g0` -> `dressedProduct = g0 *
bareProduct * g0^{-1}`): a CYCLIC schedule reduces the varying-frame dressing to
CONJUGATION. `dressedProduct_cycle_of_commutes` (`endFrame = g0`, `bareProduct =
z`, `g0 z = z g0`) -> `dressedProduct = z`: a CENTRAL bare holonomy is PRESERVED
by any cyclic passive frame change. So for the physical (cyclic/returning) case,
the schedule-local frame dressing is passive conjugation and the central HNU
holonomy `-1` SURVIVES unchanged. This is NOT an active transport escape - it
cannot flatten the `-1`. The docstring says exactly this: "a central bare
holonomy is INVARIANT under a PASSIVE schedule-local frame change." The ONLY way
to a non-conjugation is a NON-cyclic path (`endFrame != g0`), which is an
open-ended frame twist, not a periodic/returning schedule-local transport.

### Witness nondegeneracy - GENUINE
On `SL(2, Z/5)`: `wa`, `wb` nonidentity (`wa_ne_one`, `wb_ne_one`), noncommuting
(`wa_wb_noncomm`); `witnessPath = [(wb,wa),(wc,wb)]` with `wc = wa*wb`.
`witness_endFrame_ne` proves `endFrame wa witnessPath = wc != wa` (genuinely
NON-cyclic); `witness_telescope` (`= wc*wb`); `witness_not_conjugation`
(`!= wa * bareProduct * wa^{-1}`). So both endpoint factors AND the bare-operator
order are load-bearing, certifying the telescope is a genuine varying-frame
statement, not a disguised constant-frame conjugation. Nondegenerate.

### Hidden compiled trust - NONE
The `decide` at the SL2 membership/inequality lines is the KERNEL `Decidable`
evaluator on a finite group (`ZMod 5` matrices), NOT `native_decide` - no
`Lean.ofReduceBool`/`trustCompiler`. Build EXITCODE=0 with no `ofReduceBool`/
`sorryAx` diagnostics confirms standard-three.

### Four over-claim modes - all clear
- Vacuity: none - concrete nondegenerate SL2 witness; the telescope is general.
- Hollow telescoping: none - a real noncommutative-group identity (`group`), and
  the witness proves it is not trivially conjugation.
- Docstring-outruns-kernel: none - honest "passive schedule-local frame change",
  "invariant under a passive frame change", "genuinely varying-frame, not a
  disguised constant-frame conjugation". It does NOT claim an active escape.
- False shape: none - telescope + cyclic-conjugation + central-preservation +
  witness are each their stated claims.

## Exact scope boundary (the manuscript-safe reading)

This proves PASSIVE schedule-local frame COVARIANCE: the varying-frame dressing
`prod (g_{j+1} s_j g_j^{-1})` telescopes to `endFrame * bareProduct * g_start^{-1}`,
and for a CYCLIC schedule this is conjugation, so a CENTRAL bare holonomy (the HNU
`-1`) is INVARIANT. It is NOT an active transport that flattens the `-1`: no
cyclic schedule-local frame change can remove it. The non-cyclic witness only
shows the telescope is genuinely varying-frame - it is an open frame twist, not a
periodic transport, and its non-conjugation value does not constitute a physical
escape.

## Significance (resolves the decisive X2 gate to the NO branch)

In today's synthesis I named this the highest-information next theorem because it
was decisive either way. It lands on the NO branch: the HNU central `-1` is an
INTRINSIC schedule invariant under cyclic schedule-local frame transport. This
subsumes the case-by-case relocation no-gos (null-dilation, antiperiodic,
gamma-pair, global-conjugation) into a single general statement - schedule-local
active transport cannot flatten the central holonomy - and, per the synthesis,
forces the remaining routes (bulk-boundary parent, target/mirror SMG) into the
INFINITE / half-space / thermodynamic limit. Manuscript may say: the central HNU
holonomy is invariant under passive cyclic schedule-local frame transport (a
genuine varying-frame no-go); may NOT say any active escape exists.

## Bottom line

APPROVE. The varying-frame telescope is correct, the witness is genuinely
nondegenerate, there is no compiled trust, and - decisively - it is PASSIVE
covariance that PRESERVES the central `-1` under cyclic schedule-local frames, not
an active transport escape. Add `#guard_msgs` guards and port the namespace at
integration. This closes the X2 classification gate on the no-escape side.
