# Round 021 context / gestalt packet

Date: 2026-06-24.

We are restarting a constrained autonomous integrator loop for the null-edge
causal graph program. Codex is the integrator; Gemini and Claude should act as
serious scientific collaborators; Spark handles bounded repo/API triage; and
Aristotle proves one focused Lean target per round.

## Program lanes

- `P1-F`: formal/artifact paper for Plucker mass and
  observer-conditioned normalization. Core invariant is `det(P_vis)=m^2`;
  observer normalization gives a frame-relative `m/E` readout.
- `P1-R`: research interpretation of mass as coarse-grained null structure.
- `P2-R`: finite Dirac / branch-reflection / super-Dirac operator lane. Current
  emphasis is small finite gates, not a broad continuum Dirac claim.
- `P4-R`: null-step checkerboard / quantum-walk dynamics lane.
- `P7-R`: observer-channel / relative-entropy / proper-time-readout lane.
- `P9-F`: finite source-visibility, screen/noise, Hodge/coarse-map guardrails.
- `P9-R`: cosmological-constant/source-response research lane, still gated on
  an explicit response law and scaling comparison.

## Current integrated theorem state

Recent P2 branch-reflection results in
`PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace`:

- one branch reflection is trace zero;
- determinant products of branch reflections carry only reflection-count parity;
- two-reflection trace:
  `trace(R2 R1) = 2 * (h1*h2*p1*p2 + m1*m2)/(E1*E2)`;
- three-reflection trace is zero;
- four-reflection trace has an explicit scalar formula in the current
  `h,p,m,E` API;
- concrete witnesses prove unconstrained four-reflection trace is not constant:
  `trace(A A A A)=2` and `trace(B A B A)=-2` for
  `A = branchReflection 1 1 0 1`,
  `B = branchReflection 1 0 1 1`.

Recent P2/P3 super-Dirac gate:

- `PhysicsSM.Draft.NullEdgeSuperDiracDiamondCurvature` proves finite scalar
  identities relating additive one-diamond defect and multiplicative holonomy
  defect:
  `left - right = (left / right - 1) * right` when `right != 0`;
  multiplicative triviality is equivalent to additive defect zero.

Recent P9 source-visibility results:

- `PhysicsSM.Draft.NullEdgeP9DiamondScreenVisibility` proves exact local screen
  bookkeeping pairs to zero with closed tests, rank-one exact-source noise also
  vanishes, and any source with nonzero closed-test response cannot be exact.
- `PhysicsSM.Draft.NullEdgeP9ScreenQuotientBound`,
  `NullEdgeP9ScreenVarianceBound`, and P2/P9 reflection-screen variance modules
  provide screen-cardinality and variance support.

Recent P1 observer-normalization support:

- fixed observer/rest Hermitian data leaves residual `SU(2)` spin-frame
  freedom;
- two-null observer-axis scalar bridge relates unnormalized mass square and
  trace-normalized determinant;
- residual unitary determinant-one congruence preserves the trace-normalized
  determinant;
- normalized readout can recover `m^2` when observer energy is supplied.

## Current publication pressure

The publication plan currently prioritizes:

1. P1-F as the first formal theorem/artifact paper.
2. P2/P4/P7 together around null-step/chirality/proper-time dynamics.
3. P9-F as finite source-visibility/noise-channel mathematics, while P9-R
   remains gated by a response law and scaling comparison.

The latest P2 ladder is useful, but we should avoid endlessly proving generic
reflection-product identities. A next P2 target should add a closure/admissible
diamond constraint or connect to the super-Dirac one-diamond curvature gate.

## Current decision

We need exactly one next Aristotle job. Good candidates include:

1. P2 constrained-closure theorem:
   using the current branch-reflection API, state an explicit closure/admissible
   condition under which a four-reflection product is trivial or has trace `2`.
   Risk: angle/closure conventions are not yet fixed.

2. P2/P3/P2-R super-Dirac bridge:
   build on `NullEdgeSuperDiracDiamondCurvature` and connect the scalar
   additive/multiplicative identity to a one-diamond curvature block or existing
   causal-diamond holonomy API.
   Risk: may require more project imports or a broader API than one focused job.

3. P9-F quotient/source-visibility packaging:
   turn exact-source invisibility to closed tests into a quotient/well-defined
   response theorem.
   Risk: may duplicate `NullEdgeP9ScreenQuotientBound`.

4. P1/P7 observer-channel bridge:
   package the current P1 scalar readout and P7 channel idea into a finite
   theorem about dephasing/coherence/readout.
   Risk: may be underdefined unless the exact channel API is selected first.

## Requested model output

Given this context, recommend one next finite Aristotle target. Be concrete:

- theorem/counterexample/design target;
- exact Lean shape or API if possible;
- why it changes a manuscript target;
- failure/demotion mode;
- source/literature check;
- whether the job should be proof, counterexample, or audit/design.

Avoid broad continuum claims. Prefer one focused theorem that would still matter
if the broader ontology were set aside.
