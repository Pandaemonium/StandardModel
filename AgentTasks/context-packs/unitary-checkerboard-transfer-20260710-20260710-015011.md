# Aristotle semantic context pack

Generated: 2026-07-10T01:50:34
Query: `checkerboard transfer imaginary turn amplitude outgoing phases unitary matrix history`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/CheckerboardCornerCountAristotle.lean` [sequence]

Score: `0.773`

```text
tes endpoints, flips terminal directions, and preserves
  `turnCount`; transport the count along it
  (`List.length_filter`-respecting bijection, or `List.count` via an
  injective map on `histories n`).

Do not change any definition of `PhysicsSM.Spinor.Checkerboard`.  Helper
lemmas are welcome.  No `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, `u n s a f e`, and
**no `n a t i v e _ d e c i d e`** in the final state.

This is draft code: the statements below contain documented `s o r r y`s and
must not be imported from trusted code until the holes are eliminated.
-/
```

### 2. `Sources/A_null-strand_Bohm–Bell_theory.md` [5. Exact checkerboard beable process]

Score: `0.772`

```text
## 5. Exact checkerboard beable process

This should be the first closed theorem package.

Use the existing two-component checkerboard/quantum-walk evolution and add a stochastic transport through the local coin whose source and target marginals are the pre- and post-coin Born weights.

Ready targets:

```lean
coinBornTransport_isStochastic
coinBornTransport_sourceMarginal
coinBornTransport_targetMarginal
actualShift_speed_eq_c
latticeBeable_oneStep_equivariant
latticeBeable_nStep_equivariant
```

The capstone is:

```lean
theorem checkerboardBohmModel_consistent :
  EveryStepHasSpeedC M ∧
  IsUnitaryWaveEvolution M ∧
  IsBornEquivariant M
```

Then separately prove:

```lean
coinTransfer_firstOrderExpansion
quantumWalk_quasienergy_relation
quantumWalk_diracDispersion_secondOrder
```

The expansion is not yet a full continuum-limit theorem.
```

### 3. `AgentTasks/context-packs/nullstrand-wave5-selected-dynamics-20260625-161802.md` [P4. Luminal checkerboard dynamics, formalized]

Score: `0.772`

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
```

### 4. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P4-F. Luminal checkerboard dynamics, formalized]

Score: `0.769`

```text
### P4-F. Luminal checkerboard dynamics, formalized

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

For a nondegenerate eigenstate, the `z`-chirality coherence tends in the
continuum limit to `mu / sqrt(k^2 + mu^2) = m/E`. This should become the
combined P2/P4 dynamics target: luminal conditional shifts, chirality-flip
amplitude, Dirac dispersion, and observer-visible `m/E` in one finite model.
This is the strongest proposed bridge from the kinematic Plucker theorem to a
real dynamics paper, because it puts the lightlike shift, chirality flip,
dispersion relation, and proper-time ratio in one auditable finite model.

Sharpened P4 split. The publishable near-term claim should be the homogeneous
fixed-point theorem, not the full
```

### 5. `PhysicsSM/Draft/NullEdgeQWUnitarity.lean`

Score: `0.759`

```text
import Mathlib

/-!
# Null-step quantum-walk unitarity

The null-step walk uses closed-form Pauli rotations. This module certifies
unitarity of those rotations and their one-step product before treating the
walk as a genuine finite quantum evolution operator.
-/

open Complex Matrix
open scoped Matrix
```

### 6. `PhysicsSM/Draft/NullEdgeQWNormPreservation.lean`

Score: `0.757`

```text
import Mathlib

/-!
# Null-step QW norm preservation

The unitarity theorem should imply concrete norm preservation for the
two-component spinor state used by the null-step quantum walk.
-/

open Complex Matrix
open scoped Matrix
```

### 7. `PhysicsSM/Draft/NullEdgeBargmannPhaseInvariance.lean`

Score: `0.757`

```text
import PhysicsSM.Draft.NullEdgeBargmannPhasePort

/-!
# Bargmann phase invariance

This draft module proves that the closed Bargmann/Pancharatnam product and its
rank-one projector trace are invariant under independent local unit complex
phase rescalings of the three spinor vertices.
-/
```

### 8. `PhysicsSM/Draft/NullEdgeP2DephasingGap.lean`

Score: `0.753`

```text
import Mathlib.Tactic

/-!
# P2 exact dephasing determinant gap

The scalar determinant increase after explicit chirality dephasing is exactly
the squared real coherence removed by the readout channel.
-/
```

## Scoped paper hits

### 1. Spin on a 4D Feynman Checkerboard

Score: `0.734`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 2. An analysis of completely-positive trace-preserving maps on M2

Score: `0.709`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 3. Connecting the discrete- and continuous-time quantum walks

Score: `0.708`
Zotero key: `XK9ZRDNJ`
DOI: `10.1103/physreva.74.030301`
URL: https://doi.org/10.1103/physreva.74.030301

### 4. Von Neumann algebra automorphisms and time-thermodynamics relation in generally covariant quantum theories

Score: `0.704`
Zotero key: `I8XNBREW`
DOI: `10.1088/0264-9381/11/12/007`
URL: https://doi.org/10.1088/0264-9381/11/12/007

### 5. Quantum geometric tensor determines the pure-state i.i.d. conversion rate in the resource theory of asymmetry for any compact Lie group

Score: `0.698`
Zotero key: `45FTB5VF`
arXiv: `2411.04766`
URL: http://arxiv.org/abs/2411.04766

Abstract:

Shows that the quantum geometric tensor determines pure-state iid conversion rates in the resource theory of asymmetry for compact Lie groups.
