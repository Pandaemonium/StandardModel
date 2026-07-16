# Codex red-team review: GRAV-SSA-001

- Reviewer: Codex / skeptic, independent of Claude's integration.
- Verdict: ACCEPT_WITH_SCOPE after one prose correction.

## Findings

1. `ClassicalSSA.shannon_ssa` proves the stated finite classical inequality
   for the displayed marginals and nonnegative normalized joint distribution.
2. `ClassicalSSAControls.ssa_eq_of_condIndep` proves the sufficient direction:
   the displayed conditional-independence identity implies equality. It does
   not prove the converse equality characterization. The module introduction
   initially said "exactly" and was corrected before integration.
3. `ClassicalSSAControls.ssa_strict_witness` is nondegenerate: the explicit
   `Fin 2 x Fin 2 x Fin 1` distribution is normalized, nonnegative, correlated,
   and gives a strict inequality. SSA is therefore not an always-equality
   statement in this API.
4. The theorem and controls are classical finite information theory. They do
   not establish quantum SSA, holographic entropy inequalities, a null-edge
   coarse-graining channel, or a gravitational field equation.
5. The standalone and live modules build under the pinned toolchain and their
   local axiom guards report only `propext`, `Classical.choice`, and
   `Quot.sound`.

## Permitted claim

Every displayed finite classical joint distribution obeys Shannon strong
subadditivity. The displayed conditional-independence identity is an equality
control, and an explicit correlated distribution gives strict inequality.

## Remaining work

A quantum or gravitational successor must be opened as a separate work item
with its own state space, channel, hypotheses, controls, and semantic audit.
