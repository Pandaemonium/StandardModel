# Cross-family review request: compact-support generator analytic rung

- Work item: `CONT-FOURIER-001`
- Builder family: Codex/GPT integrating an Aristotle proof snapshot
- Requested reviewer: interactive Claude/Opus
- Source under review:
  `PhysicsSM/Draft/NullEdge/CompactSupportL2Generator.lean`
- Replay command:
  `lake env lean PhysicsSM/Draft/NullEdge/CompactSupportL2Generator.lean`

## Exact change

The Aristotle continuation snapshot supplied proof bodies for three previously
disclosed draft holes:

1. `momMult_sub_id_norm_le`: a Duhamel/matrix-exponential estimate
   `||U(t)v - v|| <= |t| ||H|| ||v||`;
2. `slope_norm_le`: the corresponding time-uniform difference-quotient bound,
   including the `t = 0` branch;
3. `genMult_apply_memLp`: bounded momentum support implies the pointwise
   generator action is a genuine `L2` representative.

The snapshot also rewrote the already-reviewed nonzero ball witness in a way
that did not compile against the current measure API. That collateral rewrite
was deliberately rejected. Only the three proof bodies above were integrated,
and the live witness and its guards were preserved.

Direct Lean replay passes with exactly two remaining disclosed draft warnings:
`orbit_slope_tendsto` and `momMultL2Isometry_hasDerivAt_zero`. Standard-three
axiom guards are active for all three newly completed declarations.

## Intended reading

This is a compact-momentum-support generator-domain theorem, not a bounded
generator on all of `L2`. It establishes the nontrivial Duhamel domination and
the `MemLp` generator representative required for a later dominated-convergence
proof. It does **not** establish strong differentiability yet, because the final
two theorems still contain explicit draft handoff markers.

## Review questions

1. Do the theorem statements and proofs represent the intended analytic facts,
   with the correct generator sign and multiplication orientation?
2. Is `MemLp.mono` being used with a legitimate measurable representative and
   an actual integrable dominator, rather than hiding the desired conclusion in
   a hypothesis?
3. Are the bounded-support and non-vacuity controls sufficient for this rung?
4. Do any docstrings outrun the kernel, especially around differentiation,
   operator-norm continuity, Stone's theorem, Fourier transport, or a
   position-space PDE claim?
5. Apply the four over-claim checks: vacuity, hollow telescoping,
   docstring-outruns-kernel, and false shape.

Return `APPROVE`, `REVISE`, or `REJECT`, with exact declaration names and any
required repair. Do not treat the two remaining draft theorems as proved.
