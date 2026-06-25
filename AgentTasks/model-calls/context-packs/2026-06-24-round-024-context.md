# Round 024 context: after closed branch-coordinate sum rule

Date: 2026-06-24.

## Program gestalt

We are running a constrained autonomous loop: each round queries Gemini and
Claude with enough context, delegates bounded repo checks to Spark when useful,
submits one high-value Aristotle job, records everything, then sleeps. Codex is
the integrator and scientific filter.

Main lanes:

- `P1-F`: Plucker mass and observer-conditioned normalization.
- `P2-R`: finite Dirac / branch-reflection / super-Dirac bridge.
- `P4-R`: null-step quantum-walk/chirality dynamics.
- `P7-R`: observer channels and relative-entropy/proper-time readout.
- `P9-F`: source-visibility, screen/harmonic projection, and noise guardrails.

## Latest P2 theorem state

Live module:

```text
PhysicsSM/Draft/NullEdgeP2TwoReflectionTrace.lean
```

Recent integrated declarations:

```text
trace2_mul_four_traceless_mandelstam
branchReflection_eq_tracelessMat_coords
trace2_mul_tracelessMat_coords
trace2_mul_two_branchReflections_from_coords
trace2_mul_four_branchReflections_mandelstam_ordered
trace2_branchReflection_sq_eq_two_on_massShell_from_coords
branchA
branchB
coordPairTrace
branchPairTrace
branchPairTrace_eq_coordPairTrace
coordPairTrace_sum_eq_neg_four_of_closed_unit
branchPairTrace_sum_eq_neg_four_of_coordClosed_unit
branchCoord_norm_sq_eq_one_onMassShell
branchPairTrace_sum_eq_neg_four_of_closed_onMassShell
```

Key facts now banked:

1. A branch reflection has explicit coordinates

```text
a = -(h*p)/E
b = m/E
```

2. The pairwise two-trace is the coordinate dot-product readout:

```text
trace2(R_j * R_i) = 2 * (a_i*a_j + b_i*b_j)
```

3. A four-reflection trace is determined by pairwise two-traces.

4. If four on-shell branch-coordinate vectors close, then the six-pair trace
   sum is fixed:

```text
sum_{i<j} trace2(R_j * R_i) = -4
```

This is a real finite closure constraint, not just a renamed generic trace.

## Open decision

Aristotle's latest recommendation was to continue toward a one-diamond
geometric substitution map, now that there is a nontrivial invariant for such a
map to preserve.

But Gemini's previous critique remains important: a bare substitution map is
empty unless it encodes real geometry, closure, holonomy, source visibility, or
observer-channel content.

Possible next jobs:

1. `P2/P3 strategy/audit job`: ask Aristotle to design the one-diamond
   substitution-map API, explicitly specifying state space, constraints,
   invariants preserved, theorem targets, and failure modes. No code required.
2. `P2 proof job`: stage a small constrained structure, e.g.
   `ClosedBranchDiamond`, whose fields are branch data plus closure/on-shell
   assumptions, and prove the existing closure sum rule in structure form.
3. `P2/P3 bridge proof`: define a candidate diamond readout from pairwise
   traces and prove compatibility with the closure sum rule and four-trace
   Mandelstam identity.
4. `P1/P7 pivot`: define a concrete observer/dephasing channel with `m/E`
   readout, now that branch coordinates and on-shell normalization are banked.
5. `P9-F pivot`: return to source visibility/noise/harmonic projection.

We need exactly one next Aristotle job. It may be a proof job or a strategy/audit
job, but it must be publication-worthy and should avoid empty formal wrappers.
