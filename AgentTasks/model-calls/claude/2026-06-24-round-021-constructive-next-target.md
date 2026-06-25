# Claude call: round 021 constructive next target

Date: 2026-06-24
Provider: Claude CLI
Model requested: opus
Model used: opus
Command status: 0
Context/gestalt packet: AgentTasks/model-calls/context-packs/2026-06-24-round-021-context.md
Later usefulness rating: pending

## Query

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


# Claude task for round 021

Role: constructive scientific collaborator.

Given the current theorem state and publication pressure in the context packet, propose exactly one next Aristotle job. Make it concrete enough to stage as a focused Lean package or as a precise audit/design job. Give theorem shape/API, why it matters physically, likely failure mode, and one source/literature check. If the best move is to stop extending P2 and pivot, say so and name the finite target in the new lane.

## Response

# Round 021 Recommendation: Pivot to P2/P3 Super-Dirac Bridge (Candidate 2)  ## Top-line call  **Stop extending the generic P2 reflection-product ladder.** The 4-reflection counterexample (`trace(AAAA)=2` vs `trace(BABA)=-2`) already establishes that *unconstrained* products carry no invariant, and Candidate 1 (constrained closure) is blocked by unfixed angle/closure conventions — committing to one now risks a wasted round. Candidate 3 risks duplicating existing quotient bounds. Candidate 4 needs a channel API selection first.  The remaining move that *changes a manuscript target* with a single focused proof is **Candidate 2**, narrowed sharply.  ## Proposed Aristotle job: `NullEdgeP2SuperDiracTraceBridge`  ### Job type **Proof** (with a small audit sub-step naming the diamond holonomy block being used).  ### Theorem shape  Connect the two-reflection trace identity to the super-Dirac diamond curvature scalar by a single algebraic bridge lemma. Concretely, in Lean:  ```lean namespace PhysicsSM.Draft.NullEdgeP2SuperDiracTraceBridge  open NullEdgeP2TwoReflectionTrace open NullEdgeSuperDiracDiamondCurvature  /-- The two-reflection trace, normalized by 2, equals the "right" factor     of the diamond curvature additive/multiplicative identity for a specific     assignment of (left,right) from the branch data. -/ theorem twoReflTrace_eq_diamond_right     (h1 h2 p1 p2 m1 m2 E1 E2 : ℝ)     (hE1 : E1 ≠ 0) (hE2 : E2 ≠ 0) :     (trace (branchReflection h2 p2 m2 E2 *             branchReflection h1 p1 m1 E1)) / 2       = diamondRight h1 h2 p1 p2 m1 m2 E1 E2 := by   -- unfold both sides to (h1*h2*p1*p2 + m1*m2)/(E1*E2)   ...  /-- Corollary: multiplicative holonomy triviality of the one-diamond gate     is equivalent to the two-reflection trace equaling 2. -/ theorem diamond_trivial_iff_twoReflTrace_eq_two     (...) :     diamondHolonomyTrivial ↔     trace (branchReflection h2 p2 m2 E2 *            branchReflection h1 p1 m1 E1) = 2 := by   rw [← diamond_additive_defect_zero_iff_multiplicative_trivial]   ... ```  The bridge lemma is a pure algebraic rewrite over `ℝ` with one nonvanishing-denominator hypothesis; the corollary chains the existing `NullEdgeSuperDiracDiamondCurvature` equivalence.  ### Why this changes a manuscript target  - It converts the P2 trace ladder from "interesting identity collection" into a **named bridge into the super-Dirac one-diamond gate**, which is exactly what the publication plan asks for ("connect to the super-Dirac one-diamond curvature gate"). - For P1-F / P2-R: it gives the manuscript a *single observable scalar* — the two-reflection trace — that is simultaneously (a) the natural observer-frame readout in `(h,p,m,E)` and (b) the curvature-triviality witness on a diamond. That is a publishable physical statement, not a generic linear-algebra identity. - For P2/P4/P7 bundling: it pins down the chirality/holonomy bookkeeping needed before any proper-time readout claim.  ### Physical content  The two-reflection trace formula `2(h1 h2 p1 p2 + m1 m2)/(E1 E2)` already reads like a normalized inner product of two null-edge momenta with a mass cross-term. The bridge says: *one diamond's holonomy is trivial iff this normalized inner product equals 1*, i.e. iff the two branch legs match on the (helicity-momentum, mass) bilinear at the diamond corners. That is the finite analogue of "flat parallel transport around a null plaquette" without invoking a continuum connection.  ### Failure / demotion mode  - **Primary failure**: the existing `diamondRight` (or whatever it is named in `NullEdgeSuperDiracDiamondCurvature`) is parameterized in variables that do *not* algebraically match `(h1 h2 p1 p2 + m1 m2)/(E1 E2)` without an additional substitution. **Demotion**: turn the job into an audit/design job that produces the explicit substitution map (one Lean `def` + one `example` showing the substitution lands in the right normal form). That alone unblocks a future round. - **Secondary failure**: the bridge holds only up to a sign tied to reflection-count parity (we already know parity is the only determinant invariant). **Demotion**: state the bridge for *even* reflection count and record the odd case as a separate one-line corollary.  ### Source / literature check  Cross-check against **Kauffman & Noyes / Bialynicki-Birula-style discrete checkerboard-Dirac literature**, specifically the formulation where a 2x2 step matrix's trace over a closed null plaquette gives the discrete curvature/holonomy phase (see also Arrighi–Nesme–Forets, *Discrete Lorentz covariance for quantum walks*, J. Phys. A, for the trace-as-holonomy framing on null plaquettes). The check we need: confirm that in that literature the *normalized* plaquette trace, not the raw product, is what plays the role of holonomy. If yes, our normalization-by-2 is the right one and the bridge lemma is the standard finite-walk fact in our API; if the literature uses a determinant-normalized version instead, we should adjust the bridge to `trace / (2 * sqrt(det))` before committing.  ### Scope guard  One file, one main theorem, one corollary, no new physical axioms, no new imports beyond `NullEdgeP2TwoReflectionTrace` and `NullEdgeSuperDiracDiamondCurvature`. If it does not close in one round at this scope, demote to the audit/design variant above rather than expanding the import surface.
