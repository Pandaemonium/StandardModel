# GOAL PROMPT - Codex, Null-Edge "So What?" closure

You are Codex, proof, composition, and adversarial-audit lead for the next
Null-Edge research phase.  Your task is not to accumulate more finite identities.
Your task is to turn the existing canonical mass construction into a theory with
distinctive mathematical and physical consequences that an ordinary Dirac walk
with an assigned mass parameter does not already possess.

Read, in order:

1. `AGENTS.md`, `docs/NULLSTRAND.md`, and `docs/CONVENTIONS.md`.
2. `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`.
3. `NULL-EDGE_TARGET_AUDIENCE.md`.
4. The completed adversarial report under Aristotle project
   `d6da22f3-2575-4552-8556-15551872d3d1` and its local disposition note
   `AgentTasks/null-edge-paper-adversarial-review-aristotle-2026-07-10.md`.
5. `PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean`,
   `PluckerMassDynamics.lean`, `Pluecker3Plus1ComplexMass.lean`,
   `ComplexPlueckerLocalWalk.lean`, `WilsonDiracRegulator.lean`,
   `StationaryAmplitudeNoGo.lean`, `Finite3Plus1BrillouinAudit.lean`,
   `CompactSupportL2WalkBridge.lean`, and the relevant Fourier/QCA modules.
6. The latest run ledger and `docs/DOCUMENT_MAP.md` before claiming a lane.

The Lean kernel is the source of truth.  Every landed flagship needs exact
semantic review, a nondegenerate witness, a negative or boundary control, a
build-enforced axiom pin, and an honest manuscript statement.  A successful
output is a theorem, a counterexample/no-go, or a sharpened missing assumption.
An isolated identity with no role in the consequence chain is not progress for
this goal.

## Governing question

A skeptical researcher asks:

> Why is `mu = |psi wedge phi|` more than a reparametrization of an arbitrary
> Dirac mass, and what can this framework calculate, force, or rule out that a
> standard massive quantum walk cannot?

Every work cycle must improve the answer.  The target answer is:

> The Pluecker origin becomes physically consequential when its full complex
> field, zeros, winding, composition law, dynamical selection, and behavior
> under locality and coarse-graining are retained.  Those structures force
> protected defects, constrain admissible QCAs and interactions, and produce
> falsifiable propagation or spectral consequences.

Do not claim that answer before the corresponding arrows below are proved.

## Mission

Close the following chain end to end:

```text
local null spinors
  -> complex Pluecker field z(x,t)
  -> canonical odd Hermitian rest operator B_z
  -> local exactly unitary dynamics
  -> defect/index and spectral consequences
  -> strict finite-range doubler-controlled 3+1 QCA
  -> changing-lattice position-space Dirac limit
  -> second-quantized local dynamics and one interacting observable
  -> coarse-graining/RG law
  -> dynamical selection of the magnitude |z|
  -> held-out benchmark or falsifier
```

The manuscript is rewritten around the strongest completed consequence, not
around the size of the theorem inventory.

## Flagship A - variable Pluecker field and protected consequences

This is the highest-value lane.  Promote the constant coordinate
`z = psi wedge phi` to local data `z(x,t)` without losing exact unitarity or
the collinearity interpretation.

### A1. Local update

Define a finite lattice API for local spinor pairs, local `z`, local `mass4 z`,
and a position-dependent unitary coin.  Prove:

- pointwise Hermiticity and scalar square;
- exact pointwise coin unitarity and inverse;
- locality/causal-cone preservation after composition with shifts;
- reduction to the landed constant-`z` walk;
- gap closure exactly at local collinearity, with explicit nonzero and
  collinear controls.

### A2. Local phase covariance

For `z(x)=rho(x) exp(i theta(x))`, prove the exact finite conjugacy law.  Track
the extra link/connection term created by a position-dependent chiral basis
change.  Do not erase it as if constant conjugacy remained global.  The target
is an exact lattice statement whose continuum tangent yields the expected
phase-gradient coupling.

### A3. Defect/index theorem

Seek a theorem of the form

```text
index(D_z) = winding(z)
```

or the strongest correct finite-walk analogue: a nonzero phase winding or a
sign/domain wall in `z` forces a protected localized mode, while a homotopically
trivial gapped profile does not.  Requirements:

- a finite exact winding/index definition;
- an explicit nontrivial profile and localized eigenvector;
- a gap hypothesis away from the defect;
- perturbation stability or a precise missing stability theorem;
- a zero-winding negative control;
- a kill condition: if the local Pluecker walk has no invariant spectral
  distinction from an independently assigned complex mass field, say so and
  identify what additional structure is required.

### A4. Direct complex history theorem

Close the adversarial-review interface: formulate the path sum with the full
complex orientation weight, prove its equality to the local transfer-matrix
history, and recover the real-mass Gaussian-rational theorem as a specialization.
Do not leave `Xi_z` solely as prose if it remains in the headline consequence.

## Flagship B - strict finite-range 3+1 QCA regulator

The Wilson Hamiltonian removes the unwanted corners but its finite-time
exponential is not a strictly finite-range one-step QCA.  Close that gap.

### B1. Harvest and classify the current obstruction

Immediately inspect Aristotle project
`c6cdee4d-e883-4122-b57e-b6672ded7b71`.  Harvest any exact full-Bloch
determinant formulas before launching replacements.  If it has stalled beyond
the repository limit, preserve the snapshot and split determinant expansion
from kernel/eigenmode equivalence.

### B2. Minimal-architecture theorem

Generalize `StationaryAmplitudeNoGo` into a theorem that states which locality
radius, internal dimension, cell enlargement, or number of substeps is
necessary for all of:

- exact unitarity at every Bloch momentum;
- a full `3+1` Dirac tangent;
- no unintended zero- or pi-quasienergy partners;
- a mass gap compatible with the Pluecker coin;
- finite propagation radius.

Return either a lower bound/minimality theorem or a concrete counterexample to
the proposed minimum.  Include a nontrivial relaxed witness at the first viable
architecture.

### B3. Construct the successor

Build an explicit candidate outside the degree-one no-go class.  Prove:

- exact all-momentum unitarity;
- explicit finite-range position-space realization and inverse;
- exact Dirac tangent and speed normalization;
- full-Bloch determinant/eigenmode classification;
- removal of the three even-parity aliases and both body-center modes;
- relation to the Wilson Hamiltonian through a controlled tangent or effective
  generator;
- compatibility with the complex Pluecker mass phase;
- perturbation robustness of the intended gap.

Do not declare victory from corner sampling.  The determinant or an equivalent
all-zone spectral criterion is mandatory.

### B4. Tetrahedral and baseline comparison

Put the successor and the tetrahedral walk into a common blocked-cell language.
State exactly whether they are onsite equivalent, block equivalent, related by
coarse-graining, or spectrally distinct.  A comparison without an explicit map
is commentary, not a theorem.

## Flagship C - changing-lattice position-space continuum theorem

The existing fixed-momentum, finite-torus, and compact-support multiplier
results are inputs.  Do not re-prove them.

Define explicit sampling `S_a`, interpolation `I_a`, lattice Hilbert spaces,
continuum spinor space, and the limiting Dirac generator.  Target:

```text
sup_{|t| <= T}
  || I_a U_a^(floor(t/a)) S_a Psi - exp(-i t D_z) Psi ||_L2
  <= C(Psi,T) * a
```

or the strongest correct rate and regularity class.  Close, separately:

1. changing finite/infinite lattice spaces;
2. Fourier-isometry and normalization conventions;
3. ultraviolet/tail control beyond compact momentum support;
4. inverse-Fourier convergence;
5. identification of the limiting multiplier with the position-space Dirac PDE;
6. extension from constant `z` to the admissible variable profiles of A.

If a full theorem requires Sobolev regularity, display it.  If only strong
convergence is available, do not advertise operator-norm convergence.

## Flagship D - second quantization and one interacting observable

Lift the one-particle update to a finite CAR/Fock-space automorphism.  Prove:

- preservation of the CAR;
- locality radius and number/parity conservation;
- compatibility of the one-particle sector with the landed walk;
- an exact positive/negative-energy or quasienergy convention;
- a nontrivial local interaction that preserves exact unitarity.

Then calculate and formalize at least one operational consequence:

- a two-particle bound-state energy;
- a scattering phase or finite S-matrix entry;
- an interaction threshold;
- a selection rule forced by the Pluecker phase;
- or a quantitative suppression/no-go for unwanted negative-energy production.

The observable must depend on the Pluecker structure in a way that cannot be
removed by replacing `z` with an unconstrained scalar mass.

## Flagship E - coarse-graining and universality

Define an explicit blocking map for the walk/QCA and determine whether the
Pluecker-derived family closes under it.

Target results:

- necessary and sufficient finite renormalizability condition for the chosen
  blocking;
- induced flow `z -> z'`, lattice spacing `a -> a'`, and any additional
  couplings generated;
- fixed points and relevant/irrelevant directions;
- preservation or controlled transformation of winding/index data;
- a counterexample if the family is not closed;
- a theorem identifying the smallest enlarged family that is closed.

Do not call a fitted recurrence an RG theorem.  The blocking map and equality
of effective updates must be explicit.

## Flagship F - dynamical selection of mass scale

The present theorem derives the form `mu = |psi wedge phi|` but does not select
the norms or relative angle of the spinors.  Close that explanatory gap.

Construct a finite action, energy, or ensemble whose variables include the
local null spinors and whose stationary states determine `z`.  Seek:

- Euler-Lagrange equations derived from the action;
- a stable nonzero stationary solution with an exact witness;
- Hessian positivity on physical directions and explicit gauge/zero modes;
- fluctuation spectrum around the selected state;
- a theorem distinguishing spontaneous selection from a supplied scale;
- a no-go if every homogeneous action in the natural class is scale-flat;
- an explicit account of which dimensionful input remains.

Never claim an absolute observed mass while an arbitrary normalization or
dimensionful coupling remains in the hypotheses.

## Flagship G - benchmark, prediction, and falsification

Build one held-out test that is downstream of the new consequence, not merely
a plot of a known Dirac dispersion.  Good targets include:

- number and chirality of defect modes from winding data;
- regulator high-momentum spectrum compared with baseline walks;
- a bound-state or scattering quantity;
- an RG scaling exponent;
- a constrained lattice correction whose coefficient is not freely fitted.

For each benchmark record:

```text
primitive input
-> theorem chain
-> numerical algorithm
-> parameter disclosure
-> baseline comparison
-> predicted output
-> kill threshold
```

The simulation is an oracle and experimental design tool, never a substitute
for the theorem.  Validate exact identities first and include negative tests
that fail under sign, ordering, branch, or normalization changes.

## Manuscript transformation

Rewrite Paper I only as theorem gates close.  The first page must answer
"What changes physically?" in one box.  Include:

1. a theorem-level baseline equivalence for constant `z`;
2. a table contrasting an arbitrary-mass Dirac walk with the Pluecker-derived
   theory and identifying the first genuinely different consequence;
3. one flagship consequence theorem, preferably the defect/index result or the
   strict-QCA minimality/construction theorem;
4. a figure showing the consequence, not only the construction pipeline;
5. explicit falsifiers;
6. a short section titled "Why the Pluecker origin matters";
7. a clear statement that no observed mass value is predicted until F closes.

Do not broaden the ontology to compensate for a missing consequence.  Do not
add Standard Model, gravity, Higgs, or cosmology headlines unless a theorem in
this run makes them necessary to the argument.

## Aristotle operating discipline

Use Aristotle early and aggressively for theorem design, proofs, no-gos, and
audits.

- Start with `aristotle list --limit 40`; harvest before submission.
- Keep approximately 5-7 high-value jobs as a cap, not a quota.
- Keep 1-2 adversarial audit/no-go jobs active when capacity permits.
- Run one whole-program grand-strategy job every 90 minutes during autonomous
  work.
- Apply the two-hour stall rule; preserve completed pieces and resubmit only the
  smallest blocked tail.
- Prefer focused standalone Mathlib packages for hard finite algebra.
- Use full-repo packages only when the target genuinely depends on the project
  composition.
- Every job includes exact theorem statements, seed imports, a nondegenerate
  witness, a boundary control, semantic success criteria, and permission to
  return a counterexample without weakening the target.

Recommended first wave:

1. harvest/split the full-Bloch determinant job;
2. variable-`z` local covariance and phase-gradient strategy;
3. finite defect/winding index theorem;
4. strict-QCA minimal architecture audit;
5. changing-lattice PDE theorem design;
6. CAR lift and interacting-observable strategy;
7. scale-selection action/no-go audit.

## Literature and reference packages

Run a focused literature and Lean-package pass before inventing each flagship
API.  Use Spark subagents when responsive; search directly when Spark is
unavailable or out of budget.  For claims depending on a paper, inspect the
full text or relevant chunks rather than an abstract alone.

Required reference lanes:

- quantum walks/QCAs: doubling, split-step and tetrahedral walks, QCA
  classification, renormalization, interacting fermionic automata;
- index/defects: domain-wall Dirac operators, chiral/topological walks,
  Floquet invariants;
- continuum: strong convergence of lattice Dirac walks, sampling/interpolation,
  Trotter-Kato/Chernoff and Fourier methods;
- field theory: CAR lifts, local automorphisms, finite scattering/bound states;
- dynamics: variational calculus, symmetry breaking, Hessian stability;
- Lean: Mathlib and PhysLean first, then SciLean, lean-quantum, CSLib,
  testing-lower-bounds, Kraft, Plausible, and relevant combinatorics packages.

Record source, theorem shape, conventions, license, and Lean-version gap.
Reference and clean-room port; do not add a dependency without a version and
license audit.

## Composition and audit protocol

Maintain a consequence matrix with one row per arrow:

```text
arrow | exact statement | Lean anchor | assumptions | nonzero witness
      | negative control | simulation | literature baseline | kill condition
      | manuscript status
```

For every landing, perform the four over-claim checks:

1. vacuity;
2. hollow telescoping;
3. prose outrunning the kernel;
4. correct proof of the wrong mathematical shape.

Also check convention drift, hidden scale input, branch choices, locality
radius, finite versus infinite volume, Hamiltonian versus discrete-time QCA,
and one-particle versus field-theoretic language.

Before any headline promotion, commission an independent Aristotle adversarial
review containing the exact manuscript passage and verbatim supporting Lean
declarations.  Fix substantive findings, then rerun guards and manuscript
structure checks.

## Completion gates

This goal is complete only when all of the following have landed or have been
closed by a theorem-level no-go with the next required assumption identified:

- [ ] Variable local `z` walk with exact covariance, unitarity, and locality.
- [ ] A protected defect/index consequence or a decisive no-go.
- [ ] Direct complex-orientation path-sum bridge.
- [ ] Full-Bloch classification of the current walk.
- [ ] Minimal architecture theorem for a doubler-controlled strict QCA.
- [ ] Explicit strict finite-range `3+1` successor or a proved obstruction.
- [ ] Changing-lattice position-space continuum theorem.
- [ ] CAR/Fock lift and one nontrivial interacting observable or no-go.
- [ ] Explicit coarse-graining law and RG closure result or counterexample.
- [ ] Dynamical scale-selection theorem or scale-flatness no-go.
- [ ] One held-out benchmark with a pre-registered kill condition.
- [ ] Paper I rewritten around the strongest distinctive consequence.
- [ ] Independent adversarial review, axiom audit, targeted builds, full
      applicable build, reproducible simulations, and clean artifact manifest.

## The rule that matters most

Do not confuse a canonical representation of mass with an explanation of mass.
The project earns its "so what?" only when the Pluecker origin forces a
consequence, constraint, protected structure, or falsifiable output unavailable
to a walk with an independently assigned scalar mass.  Build that consequence,
or prove exactly why additional physics is required.
