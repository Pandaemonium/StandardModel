# Post-mortem: constrained autonomous integrator loop

Date written: 2026-06-24.

Scope:

- Main run plan:
  `AgentTasks/null-edge-constrained-autonomous-integrator-loop-plan-2026-06-24.md`.
- Main run ledger:
  `AgentTasks/null-edge-constrained-integrator-loop-ledger-2026-06-24.md`.
- Model-call folders:
  `AgentTasks/model-calls/gemini/` and `AgentTasks/model-calls/claude/`.
- Model delegation log:
  `AgentTasks/null-edge-model-delegation-evaluation-log-2026-06-23.md`.
- Main integrated Lean surface:
  `PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace`, plus adjacent P1, P2, P4,
  and P9 draft modules integrated by the same run.

This post-mortem covers the constrained loop where Codex acted mostly as the
scientific integrator, while Gemini supplied constructive hypotheses, Claude
supplied adversarial critique, Spark handled bounded triage, and Aristotle
proved focused Lean targets.

## Executive assessment

The constrained loop was successful. It used far fewer simultaneous Aristotle
lanes than the six-lane overnight run, but it produced a more coherent theorem
story. The most important outcome is the P2 branch-reflection trace ladder:

```text
one reflection:    trace zero
determinants:      parity only
two reflections:   first continuous non-parity scalar
three reflections: trace zero
four reflections:  explicit scalar formula
four witnesses:    trace is not constant
```

This is a real finite guardrail for the null-edge program. It says that local
branch-reflection products do contain continuous algebraic data, but not in a
way that is automatically topological. Any future claim that a causal diamond
has a quantized or topological trace must add an explicit closure, geometric,
or observer-channel hypothesis.

The run also made useful progress in P1 observer normalization and P9 finite
source visibility. The P1 results strengthen the frame audit around
observer-conditioned celestial data. The P9 results strengthen the finite
screen/source response story, especially boundary/exact invisibility and
screen-cardinality response bounds.

The main weakness is documentation order and integration debt. The ledger is
chronologically messy because entries were appended during interrupted
continuations. The theorem results are real and verified locally, but the P2
trace ladder should now be consolidated into a short manuscript-ready note and
the P1/P9 modules should be reviewed semantically before promotion.

## Major scientific results

### 1. P2 branch-reflection trace ladder

The strongest new result is the finite trace ladder in
`PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace`.

Banked draft declarations now include:

```lean
trace2_mul_two_branchReflections_formula
trace2_branchReflection_sq_eq_two_on_massShell
trace2_mul_three_branchReflections_eq_zero
trace2_mul_four_branchReflections_formula
trace2_four_diagWitness_eq_two
trace2_four_alternatingWitness_eq_neg_two
trace2_four_branchReflections_nonconstant
```

The key interpretation is:

- determinant products of branch reflections carry only reflection-count parity;
- the two-reflection trace is the first continuous scalar;
- the three-reflection trace vanishes identically in the real two-generator
  model;
- the four-reflection trace has an explicit scalar formula;
- two explicit on-shell witnesses show the four-reflection trace is not
  constant.

The witness pair is:

```text
A = branchReflection 1 1 0 1
B = branchReflection 1 0 1 1

trace(A A A A) = 2
trace(B A B A) = -2
```

This is valuable because it kills a tempting overclaim. A generic
four-reflection trace is not a topology-only label. The correct next target is
therefore a constrained closure theorem, not a bare "diamond trace is
topological" theorem.

### 2. P2 branch-reflection operator package

The run also integrated or confirmed several adjacent P2 operator facts:

```lean
PhysicsSM.Draft.NullEdgeP2BranchResolution
PhysicsSM.Draft.NullEdgeP2BranchReflection
PhysicsSM.Draft.NullEdgeP2BranchOrientation
PhysicsSM.Draft.NullEdgeP2PositiveBranchProjector
PhysicsSM.Draft.NullEdgeP2ChiralProjectorCoherence
PhysicsSM.Draft.NullEdgeP2ReflectionProductDetParity
```

Together these make the finite branch reflection a much cleaner object:

- it reconstructs the two-level chiral Hamiltonian after multiplying by energy;
- it acts as the difference of positive and negative branch projectors;
- it is traceless;
- on shell, it is an involution;
- on shell, it has determinant `-1`;
- determinant products collapse to parity;
- two-sheet/projector and chiral-coherence readouts are now better separated
  from trace and determinant claims.

This is not yet a super-Dirac theorem, but it is a useful local algebra package
for P2-R and P4-R.

### 3. P1 observer-frame and scalar-readout progress

The run integrated finite P1 observer-normalization support:

```lean
PhysicsSM.Draft.NullEdgeObserverSpinFrameSU2
PhysicsSM.Draft.NullEdgeP1PluckerObserverScalarBridge
PhysicsSM.Draft.NullEdgeP1SU2NormalizedDetInvariance
PhysicsSM.Draft.NullEdgeP4MassFromNormalizedReadout
```

The scientific value:

- a fixed observer/rest Hermitian block leaves residual `SU(2)` spin-frame
  freedom;
- the two-null observer-axis model gives the scalar bridge
  `2 sqrt(det rho) = m / E` in squared finite form;
- trace-normalized determinant is invariant under the residual unitary
  determinant-one frame action;
- the normalized readout can be converted back to the unnormalized mass scalar
  when the observer energy scale is supplied.

This strengthens the publication-safe P1 distinction:

```text
det(P_vis) = invariant mass square
det(rho_{p|u}) = observer-conditioned m/E readout
```

The remaining P1 work is semantic consolidation, not another isolated scalar
identity.

### 4. P9 finite source-visibility support

The constrained run also integrated several P9 support results:

```lean
PhysicsSM.Draft.NullEdgeP9ScreenQuotientBound
PhysicsSM.Draft.NullEdgeP9ScreenVarianceBound
PhysicsSM.Draft.NullEdgeP2P9ReflectionScreenVariance
PhysicsSM.Draft.NullEdgeP2P9ReflectionIterationVariance
PhysicsSM.Draft.NullEdgeP9StochasticErasure
PhysicsSM.Draft.NullEdgeP9SJReferenceState
```

The main P9 contribution in this run was not a cosmological-constant result.
It was finite guardrail infrastructure:

- closed-test responses are invariant under exact source perturbations;
- screen-supported source response admits explicit cardinality and variance
  bounds;
- branch-reflection operations preserve relevant finite screen second moments;
- iterated branch reflections preserve those bounds;
- stochastic erasure and SJ-reference-state scaffolds provide more precise
  future observer-channel targets.

This keeps P9 honest. The branch is still high-value, but it must remain a
finite source-visibility/noise-channel program until a response law and scaling
comparison are supplied.

## Operational assessment

### What worked

The constrained cadence worked better than a broad wave for theorem quality.
Each round had:

```text
status check
Gemini constructive hypothesis
Claude adversarial critique
Spark bounded triage
one Aristotle job
local verification
ledger update
sleep
```

That rhythm prevented broad drift and kept Aristotle focused on theorem-sized
targets.

The best delegation pattern was:

```text
Gemini: generate bold candidate physics move
Claude: attack the claim and strip off overreach
Spark: map the result into the current repo API
Codex: choose and stage the exact theorem
Aristotle: prove the focused Lean target
Codex: review, integrate, verify, and document
```

This produced especially good results in the P2 trace ladder. Gemini repeatedly
overreached toward topological or geometric interpretation, but that was useful
because Claude and Spark converted the overreach into finite guardrail theorems.

The new model-call logging rule also worked. Gemini and Claude calls were
stored as one file per call under:

```text
AgentTasks/model-calls/gemini/
AgentTasks/model-calls/claude/
```

This makes the delegation record auditable.

### What did not work as well

The ledger became messy. Entries are not strictly chronological because the loop
was interrupted and resumed several times, and patches were appended after
older blocks. The content is useful, but the file is hard to scan.

Some proof modules duplicate local definitions:

```lean
RMat2
chiralHamiltonian
branchReflection
trace2
det2
```

This was acceptable for focused Aristotle packages, but the live draft surface
now needs consolidation. The P2 modules should eventually share a small common
API before any paper or promotion.

Gemini often generated physically attractive claims faster than the definitions
could support them. This was productive only because Claude/Spark/Codex filtered
the claims aggressively. Without that filter, the loop would have produced
overclaimed theorem targets.

### Verification posture

For integrated modules, targeted checks were run repeatedly:

```text
lake env lean <standalone Core.lean>
lake env lean <live draft module>
lake build <specific module>
lake env lean PhysicsSMDraft.lean
git diff --check
focused placeholder scans
```

The latest integrated P2 trace surface passed:

```text
lake env lean AgentTasks\aristotle-standalone\null-edge-p2-four-trace-nonconstant-20260624\NullEdgeP2FourTraceNonconstant\Core.lean
lake env lean PhysicsSM\Draft\NullEdgeP2TwoReflectionTrace.lean
lake build PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace
lake env lean PhysicsSMDraft.lean
```

Full `lake build` was not run at the end of this constrained loop.

## Main lessons

### 1. The next valuable P2 theorem is constrained closure

The unconstrained trace ladder is now strong enough. The next P2 job should not
be "five reflections" or another bare product identity. It should be a closure
or admissibility theorem, for example:

```text
given an explicit closure relation on four branch reflections,
characterize when the four-reflection product is identity or has trace 2
```

This should be stated in the current `h,p,m,E` API first. Angle-parametrized
versions can come later if the convention bridge is explicit.

### 2. P1 should move from theorem accumulation to paper packaging

P1 now has enough finite scalar/readout support to start paper consolidation:

- Plucker determinant mass;
- observer-conditioned normalization;
- residual `SU(2)` frame freedom;
- scalar bridge `m/E`;
- normalized determinant invariance.

The next P1 work should be a theorem index and manuscript-ready statement map,
not a pile of new scalar lemmas unless they close an identified referee gap.

### 3. P9 needs a response-law gate

P9 finite source visibility has useful support modules, but the branch should
not claim cosmological-constant leverage yet. The next meaningful P9 theorem or
pilot should name all three:

```text
source functional
observer/recoverability criterion
response or scaling law
```

Without that, additional boundary/noise lemmas remain infrastructure.

### 4. The constrained integrator loop is a good budget mode

This loop was slower than the six-lane run but higher signal. It is a good mode
when the goal is to accumulate publication-grade finite theorems without
burning Codex budget on long proof search.

Best use:

- one target at a time;
- explicit model-call logs;
- Spark for duplicate and API triage;
- Aristotle for proof;
- Codex for claim discipline.

Worst use:

- broad strategy prompts every round;
- long literature dumps;
- speculative theorem targets without a fixed Lean API.

## Recommended next actions

1. Integrate a P2 constrained-closure theorem if the exact relation can be
   stated without angle-convention drift.
2. Write a short P2 trace-ladder note for the publication plan:

   ```text
   determinant parity is too weak;
   trace carries the first even-length scalar;
   odd three-reflection trace vanishes;
   four-reflection trace is explicit and nonconstant;
   closure is the missing extra hypothesis for diamond topology.
   ```

3. Consolidate repeated P2 local definitions into a shared draft API after the
   trace-ladder theorem cluster stabilizes.
4. Update `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` to mention the
   P2 trace ladder as a concrete P2-R result and as a guardrail for future
   diamond/super-Dirac claims.
5. For P1, prepare a theorem index and reproducibility appendix rather than
   chasing more isolated scalar identities.
6. For P9, require the next job to include a response-law or recoverability
   component, not merely another abstract source/noise algebra lemma.

## Bottom line

This was a good run. It did not solve the full null-edge dynamics problem, but
it turned a tempting speculative phrase - "four-reflection diamond trace might
be topological" - into a rigorous finite conclusion:

```text
generic four-reflection trace is explicit and nonconstant;
topology requires extra closure structure.
```

That is exactly the kind of progress the program needs: small, verified, and
sharp enough to prevent future overclaiming.
