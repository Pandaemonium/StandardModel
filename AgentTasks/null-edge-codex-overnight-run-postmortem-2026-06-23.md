# Post-mortem: Codex six-lane Aristotle run

Date written: 2026-06-23.

Scope:

- Main run plan:
  `AgentTasks/null-edge-codex-overnight-six-lane-aristotle-plan-2026-06-23.md`.
- Main run ledger:
  `AgentTasks/null-edge-codex-overnight-run-ledger-2026-06-23.md`.
- Model delegation log:
  `AgentTasks/null-edge-model-delegation-evaluation-log-2026-06-23.md`.
- Main research docs updated:
  `Sources/Null_Edge_Key_Conjectures.md`,
  `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`, and
  `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`.

This post-mortem covers the Codex six-lane autonomous run, including the P9
source-visibility tranche, the observer/channel and null-step updates, the
Spark/Gemini/Claude delegation experiment, and the final positive T2
subdiamond theorem finished locally after the Aristotle strategy job.

## Executive assessment

The run made real publishable progress, especially on P9. It did not solve the
cosmological-constant problem, but it converted a broad speculative branch into
a much sharper finite theorem ladder:

```text
finite source tests
-> boundary/exact invisibility
-> projected/Hodge observer channels
-> causal-support and retarded response guardrails
-> intrinsic-order and coarse-map artifact controls
-> T1 diamond-local separation
-> negative T2 erasure under critical collapse
-> T3 locality/noise invariance
-> positive T2 preservation under Alexandrov subdiamond restriction
```

The most important scientific outcome is the P9 guardrail stack. The branch now
has both positive and negative finite facts: some coarse maps erase the local
source-visibility signal, while Alexandrov/subdiamond restriction preserves the
local interval readout. That is a more serious position than "we have a
candidate observable." It says that admissibility of the observer/coarse channel
is mathematically consequential.

The main weakness is integration debt. The run produced a very large theorem
surface, many task notes, and a huge ledger. Targeted checks passed for the
integrated modules that were touched late in the run, but the repo still needs
semantic consolidation before these draft modules become trusted public
surfaces. The next loop should narrow: fewer broad waves, more witness
corollaries, review packets, and manuscript-ready claims.

## Major scientific wins

### 1. P9 became a finite theorem program

The strongest progress was in the P9 cosmological-constant/source-visibility
lane.

Before this run, P9 had promising but diffuse ingredients: boundary-exact
bookkeeping, noise kernels, Hodge/projector language, and causal-set
motivation. After the run, P9 has several distinct finite layers:

- boundary/exact source invisibility;
- visible residual/source witnesses;
- projected-noise and PSD response guardrails;
- weighted finite Hodge identities;
- self-adjoint weighted 1-Laplacian structure;
- harmonic-kernel characterization as closed and coclosed;
- finite retarded/causal-support response scaffolds;
- selected-sector area-vs-volume arithmetic;
- block-aliasing and offset-window negative controls;
- intrinsic order-observable invariance;
- T1/T2/T3 diamond-local coarse-map ladder.

The most recent P9 results are especially valuable:

- `PhysicsSM.Draft.NullEdgeP9DiamondLocalSeparation` banks a serious T1 witness:
  matched joint degree and global interval signatures can still differ on a
  same-size diamond-local interval readout.
- `PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail` banks the negative T2
  fact: a natural critical-collapse map erases the T1 signal.
- `PhysicsSM.Draft.NullEdgeP9DiamondLocalityNoiseInvariance` banks T3: external
  relation noise cannot affect the local interval readout when the measured
  diamond and its internal relation data are fixed.
- `PhysicsSM.Draft.NullEdgeP9SubdiamondRestrictionPreservesLocalReadout` banks
  the first positive T2 result: Alexandrov/subdiamond restriction preserves the
  local interval-size readout under transitivity.

That last theorem matters because it gives the P9 branch a non-hand-tuned
positive preservation class. The thesis is now:

```text
P9 source visibility depends on the observer/coarse channel.
Bad channels can erase it.
Alexandrov-local observer channels preserve it.
```

This is still not a cosmological-constant mechanism. But it is a real finite
mathematical spine for a publishable "source-visibility guardrails" paper or
section.

### 2. The discrete-first gate was corrected

The run incorporated the user's correction that "no fine-grained continuum
interpretation" is not a failure mode. The new gate is:

```text
Failure = no stable pre-specified coarse-grained, renormalized,
observer-channel, or large-scale emergent readout.

Not failure = microscopic discreteness, non-manifold-likeness, or pointwise
ill-conditioning before the declared coarse channel.
```

This was important. It stopped P9 from being judged by the wrong standard. A
fundamentally discrete theory is allowed; what it owes us is a stable readout
after the named observer/coarse-graining procedure.

### 3. The observer-channel and null-step lanes became better framed

The Pro critique and follow-up theorem batches sharpened P1/P2/P4:

- unnormalized `P_vis` carries invariant determinant mass;
- observer-conditioned normalization gives the frame-relative `m / E_u`;
- Higgs/Yukawa coupling first creates chirality coherence;
- visible mixedness appears only after a dephasing, partial trace, detector
  restriction, or observer channel;
- a single `2 x 2` Weyl space cannot host an invertible mass term
  anticommuting with all Pauli directions;
- scalar flip generators are the isotropic mass-like part, while vector flip
  components are anisotropic couplings.

This keeps the "all elementary movement is lightlike" ontology from floating
free. The publishable dynamics target is now closer to:

```text
null-step unitary walk
-> left/right doubling
-> scalar chirality flip
-> Dirac fixed point
-> invariant visible determinant mass
-> observer-conditioned m/E readout
```

The causal-set spinor-propagator version remains a harder frontier rather than
a banked result.

### 4. Higher gauge and super-Dirac lanes advanced, but are secondary

The run also strengthened non-P9 lanes:

- `PhysicsSM.Draft.NullEdgeP3CrossedModule` banks a finite crossed-module /
  fake-flatness wrapper for higher-gauge curvature.
- Super-Dirac/Krein and product-grading modules further clarified that the
  finite operator story should be Lorentzian/Krein-aware, not merely a
  positive-definite Euclidean Dirac analogy.
- Observer-channel, recoverability, and Petz-style modules reinforced the
  information-theoretic spine.

These are valuable, but P9 consumed most of the critical path because it was the
highest-upside branch and kept producing finite guardrails.

## What worked operationally

### Focused Aristotle packages were essential

The successful jobs were small, standalone, and Mathlib-facing. That avoided
the earlier failure mode where Aristotle burned its budget building the full
`PhysicsSM` graph.

The best pattern was:

```text
stage a tiny theorem file
check it has exactly the intended proof holes
prepare a focused package
submit to Aristotle
integrate by diff and targeted Lean check
record scientific role in the ledger
```

This pattern should remain the default for finite algebra, finite order theory,
matrix identities, and small API wrappers.

### Strategy jobs paid off when they changed the next theorem

The strongest strategy jobs were not generic brainstorming. They were focused
questions at branch points:

- "What is the next positive T2 coarse-map class?"
- "Which P9 coarse-map route is publishable versus merely Lean-friendly?"
- "Is the iso-histogram witness too cheap?"
- "What is the right discrete-first failure gate?"

The positive-T2 Aristotle strategy job is the best example. It directly led to
the banked Class A theorem:

```text
NullEdgeP9SubdiamondRestrictionPreservesLocalReadout
```

### Spark was useful for bounded triage

Spark performed well when the task was narrow:

- Aristotle queue/status triage;
- literature/context triage;
- extracted strategy report summaries;
- small theorem-target proposals;
- numerical-pilot artifact inspection.

Spark was less useful for broad physics synthesis. It tended to be best as a
fast "read this bounded surface and return the next action" assistant. The
model log correctly records several quality-4 Spark runs late in the P9 T2
sequence.

### Gemini and Claude worked as external critics

Gemini was useful for broad adversarial critique and numerical/pilot guardrails,
especially the block-aliasing and P9 Hodge/coarse-map concerns.

Claude was uneven, but when it hit, it hit hard. The most valuable Claude
contribution was the critique that the first iso-histogram witness was too
cheap and needed to be upgraded to a diamond-local T1 witness with T2/T3
guardrails. That advice directly improved the theorem ladder.

## What went wrong

### The run generated too much surface area

The largest operational problem is volume. The ledger is thousands of lines,
the draft import surface grew substantially, and many modules are still
semantically draft-only even though they kernel-check.

This is not wasted work, but it is a warning. The next phase should not simply
submit another huge wave. It should package, rank, and review:

```text
Which modules support P1/P2/P3/P4/P9 directly?
Which are only infrastructure?
Which duplicate definitions and should be consolidated?
Which are too toy-like to cite in a manuscript?
```

### Some work was still proof-volume rather than publication-value

Many finite lemmas are useful, but not all of them move a paper claim. The run
was at its best when it asked whether a theorem changed a failure mode. It was
weaker when it submitted natural algebraic follow-ups that were true but did
not sharpen a research decision.

The positive T2 ladder is a good model for future work because each step has a
role:

```text
T1: existence of a local separator
T2 negative: a natural coarse map erases it
T3: external noise cannot change it if local data are fixed
T2 positive: Alexandrov restriction preserves it
```

Future theorem batches should have this kind of ladder logic.

### Local proof sometimes beat Aristotle

The final positive T2 theorem was submitted to Aristotle, then solved locally
before Aristotle returned. The task was correctly canceled.

Lesson: after a strategy job reduces a target to elementary finite order
theory, Codex should spend a short local proof attempt before submitting or
while the job is still queued. Aristotle is best used where proof search is
nontrivial; not every finite lemma needs remote budget.

### The focused-package local check can accidentally create bulky state

One packaged-project local check cloned dependencies and left a `.lake`
directory inside the submission copy. That had to be removed before upload.

Rule for future loops:

```text
Check standalone source in the main repo first.
Prepare focused package.
Do not run dependency-cloning checks inside the submission copy unless needed.
If such a check creates `.lake`, remove it before upload.
```

### Encoding and prose placeholder hygiene remain friction points

Several strategy outputs contained Unicode typography or mojibake. Some
subagent summaries also repeated raw Lean placeholder tokens in prose. This did
not corrupt trusted code, but it creates grep noise and review friction.

Future prompts should explicitly say:

```text
Use ASCII in returned code and permanent prose.
Use spaced placeholder-token forms in prose.
```

## Scientific risk assessment after the run

### P9 outlook improved, but remains high risk

P9 now has a meaningful finite theorem ladder. That makes it worth continuing.
But the cosmological-constant claim is still not earned.

The remaining hard gates are:

- a geometry-dependent finite diamond metric or observer channel;
- a response law relating finite source readouts to curvature/expansion or a
  unimodular/Lambda conjugate variable;
- a stable scaling or renormalization result;
- a numerical pilot that survives intrinsic coarse maps, offset sweeps,
  boundary-exact perturbations, and flat-vs-deformed null controls;
- a comparison to everpresent-Lambda and stochastic-gravity amplitude
  constraints.

The honest post-run status is:

```text
P9 is no longer vague.
P9 is not yet a cosmology result.
P9 is now a good finite source-visibility research program.
```

### P1/P2/P4 plus P7 now look more publishable than P9

For near-term publication, the safer path is still:

- P1: Pluecker mass and observer-conditioned mixedness;
- P2: finite Dirac square root and operator block structure;
- P4: homogeneous null-step quantum-walk fixed-point theorem package;
- P7: relative-entropy observer channels and recoverability diagnostics;
- P3: causal-diamond holonomy and higher-gauge finite algebra.

The most attractive new bridge is the proper-time/purity rate target connecting
P1/P2/P4/P7. The static identity `2 sqrt(det rho) = m/E` is useful, but the
rate law would make it dynamical: chirality or flip dynamics produce a visible
entropy/coherence rate, and the observer-conditioned proper-time ratio appears
after integration and normalization.

P9 should be framed as an ambitious finite source-visibility/noise-channel paper
or a later section, unless the next numerical/response-law layer lands and beats
the everpresent-Lambda `1 / sqrt(V)` benchmark in amplitude or correlation
structure.

## Best next actions

### 1. Build the relative-entropy observer-channel bridge

The highest-leverage next package is now:

```text
internalCoherenceLoss_eq_relativeEntropyDeficit
coherenceDeficit_not_determined_by_mass_alone
linearEntropyRate_visible_eq_flipFrequency
```

This is the common spine for the origin-of-mass paper, the null-step dynamics
paper, P9 source visibility, and later stable particle sectors. It is also the
cleanest way to avoid treating observer-channel mass as a static rewrite of
time dilation.

### 2. Finish the P9 T1/T2 witness package

The immediate next theorem should instantiate the generic Class A preservation
theorem on the six-point T1 witness:

```text
NullEdgeP9SubdiamondRestrictionSeparatesWitness
```

The paper-facing statement should contrast:

```text
critical collapse erases the T1 signal
Alexandrov subdiamond restriction preserves the local readout
```

This gives a clean publishable subsection on admissible versus inadmissible
coarse maps.

### 3. Consolidate P9 APIs

There are now many P9 modules with related definitions of source tests, kernels,
projectors, local diamonds, and coarse maps. Before another large P9 proof wave,
write a short API map:

```text
source/test API
noise-kernel API
Hodge/projector API
causal-support API
diamond-local readout API
coarse-map API
```

This will reduce duplicate definitions and make manuscript claims easier to
state.

### 4. Draft a P9 guardrails manuscript section

Do not wait for the cosmology solution. A useful section can already be written:

```text
Finite guardrails for source visibility in causal diamonds
```

It should be explicit that the result is finite/source-observer theory, not a
solution to Lambda.

### 5. Use fewer, sharper Aristotle jobs

The next autonomous loop should submit fewer jobs unless each job is tied to a
specific ladder step. Good examples:

- finite witness corollary for Class A;
- Class B threshold dichotomy;
- spectral/Laplacian no-go pair;
- explicit diamond-local API consolidation theorem;
- P1 observer-channel frame-audit cleanup;
- P4 quantum-walk fixed-point proof target;
- P7 relative-entropy/recoverability deficit target.

Avoid broad waves whose results will require days of semantic cleanup.

### 6. Keep Spark/Gemini/Claude, but with stricter prompts

Use Spark for:

- diff triage;
- bounded literature/source reports;
- task-note cleanup;
- theorem-target ranking from a fixed file set.

Use Gemini for:

- numerical-pilot critique;
- broad P9/P4 strategy;
- spotting hidden assumptions.

Use Claude for:

- adversarial theorem critique;
- "is this too cheap?" judgments;
- failure-mode and claim-boundary language.

Every prompt should ask for:

```text
what changes a theorem target?
what would demote the claim?
what is the smallest next proof?
```

## Final judgment

This was a productive run, but not a clean one. It succeeded scientifically
because it repeatedly converted critiques into finite theorem ladders,
especially in P9. It struggled operationally because the volume of generated
artifacts grew faster than semantic consolidation.

The most significant new result from the run is not any single algebraic lemma.
It is the P9 coarse-channel lesson:

```text
Local source-visibility signals are not automatically meaningful or meaningless.
They depend on the admissible observer/coarse map.
Some natural maps erase them.
Alexandrov-local maps preserve them.
```

That is a real research-program sharpening. The next phase should turn it into
a compact, reviewable theorem package and then decide whether it can support a
physics-facing P9 paper, or whether it should remain a finite guardrail section
inside the broader null-edge program.
