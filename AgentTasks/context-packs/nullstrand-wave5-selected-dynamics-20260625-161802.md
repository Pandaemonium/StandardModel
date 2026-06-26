# Aristotle semantic context pack

Generated: 2026-06-25T16:18:08
Query: `finite least action minimal rates refresh chain selected dynamics invariant law equivariant null lift Markov kernel`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P4. Luminal checkerboard dynamics, formalized]

Score: `0.750`

```text
### P4. Luminal checkerboard dynamics, formalized

Core claim. Relativistic `1+1` propagation has an exact finite description by
lightlike microscopic steps with a corner chirality-flip amplitude, with the
Klein-Gordon-style recurrence appearing after squaring the first-order transfer.

Banked Lean. `PhysicsSM.Spinor.Checkerboard` and
`PhysicsSM.Spinor.CheckerboardDynamics` (trusted): history counts, corner-weight
powers, last-step recursion, iterated transfer-operator evolution, finite
Klein-Gordon-style recurrence. Kernel-clean closed forms in
`PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle`.

Remaining. This candidate can either stand alone or merge with the existing
`Luminal_Motion_Checkerboard_Publication_Advance_2026-06-11.md` advance note.
The higher-dimensional universality statement is explicitly out of scope here
(it belongs to the dynamics program, not a banked paper).

New dynamics target. The Pro critique identifies a discrete null-step quantum
walk as the cleanest bridge from checkerboard kinematics to chirality coherence:

```text
U_a(k) = exp(-i k a sigma_z) exp(-i mu a sigma_x),
cos(omega a) = cos(k a) cos(mu a).
```

For a nondegenerate
...[truncated]
```

### 2. `Sources/Null_Edge_Interaction_Ontology.md` [Null-step dynamics and chirality coherence]

Score: `0.737`

```text
## Null-step dynamics and chirality coherence

The ontology becomes much more credible when the null-edge story is tied to a
finite dynamics, not only to a kinematic decomposition. A promising exact model
is the discrete null-step quantum walk

```text
U_a(k) = exp(-i k a sigma_z) exp(-i mu a sigma_x).
```

Its quasienergy satisfies

```text
cos(omega a) = cos(k a) cos(mu a).
```

For a nondegenerate eigenstate, the `z`-chirality coherence is

```text
C_z = |sin(mu a)| / |sin(omega a)|.
```

In the continuum limit this tends to

```text
mu / sqrt(k^2 + mu^2) = m / E.
```

This is exactly the kind of bridge the ontology needs: luminal conditional
shifts, chirality-flip amplitude, Dirac dispersion, and the observer-visible
proper-time ratio appear in one finite model. It should be treated as a
priority theorem target for the P2/P4 dynamics paper. The interpretive slogan
"all elementary visible movement is lightlike" is strongest when it can be
backed by this kind of first-order transfer operator, not merely by the fact
that any timelike momentum admits null decompositions.
```

### 3. `PhysicsSM/Draft/Sedenions/FanoComplementGeneration.lean` [kernelList]

Score: `0.731`

```text
def kernelList : List (Fin 8 × Fin 8 × Fin 8) :=
  stabilizerList.filter fun t =>
    actOnMatching t matching0 = matching0 &&
    actOnMatching t matching1 = matching1 &&
    actOnMatching t matching2 = matching2

/-- The kernel of the action on matchings has order four. -/
```

### 4. `AgentTasks/dvt-matrix-left-right-kernel-aristotle-2026-06-01.md` [Aristotle task: DVT two-sided matrix action kernel converse]

Score: `0.725`

```text
# Aristotle task: DVT two-sided matrix action kernel converse

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Moonshot
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `2e516f5b-761e-44a7-aa89-dad22fd2b77d`
**Submission project**: `AgentTasks/aristotle-submit/paper-stretch-wave8-20260601-project`
**Output**: `AgentTasks/aristotle-output/dvt-matrix-left-right-kernel-20260601`
**Integrated**: 2026-06-01
**Type**: DVT/Yokota central-kernel converse
```

### 5. `PhysicsSM/Draft/NullEdgeP9RetardedNilpotentReach.lean`

Score: `0.721`

```text
import Mathlib.Tactic

/-!
# P9 retarded nilpotent reach scaffold

This draft module records a finite retarded-support theorem for the P9
source-visibility route.

If a response kernel is supported on a finite relation that strictly decreases
a rank function, then exact propagation has a finite horizon: after more steps
than the available rank height, no point is reachable and the iterated response
kernel vanishes.

This is a discrete-first theorem. It does not require a microscopic continuum
interpretation; it supplies a finite acyclic-retarded guardrail for later
causal-diamond response models.
-/
```

## Scoped paper hits

No paper hits returned.
