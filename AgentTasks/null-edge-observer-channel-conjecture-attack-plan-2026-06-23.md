# Null-edge observer-channel mass conjecture attack plan

**Status:** active development, 2026-06-23.  
**Lead documents:** `Sources/Null_Edge_Key_Conjectures.md`,
`Sources/Null_Edge_Causal_Graph_Publication_Plan.md`,
`Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`.  
**New Lean wrapper:** `PhysicsSM.Draft.NullEdgeObserverChannelCore`.

## One-line conjecture

Invariant mass is the determinant of the unnormalized visible block produced by
a resolution observer,

```text
det(P_vis) = m^2,
```

while normalized celestial mixedness is a kinematic observer's frame-relative
ratio,

```text
2 sqrt(det(rho_{p|u})) = m / E_u.
```

The resolution observer traces out internal/chiral/Higgs labels. The kinematic
observer chooses the timelike energy normalization. This split is the core
correction: `P_vis` is the invariant object; `rho_{p|u}` is a filtered,
renormalized observer-facing object.

## What is now banked

`PhysicsSM.Draft.NullEdgeObserverChannelCore` now proves or packages the
finite theorem surface:

- `visibleReduced_boost_eq_congruence`: the unnormalized resolution output
  transforms as `A * P_vis * A.conjTranspose`.
- `det_visibleReduced_boost_invariant`: `SL(2,C)` congruence preserves
  `det(P_vis)`.
- `normalizedVisible_boost_is_filtering`: normalized visible data after a
  boost are filtered and renormalized, not covariant as a density matrix.
- `normalizedVisible_det_eq_filter_sq_mul_det`: scalar normalization divides
  a `2 x 2` determinant by the square of the observer scale.
- `normalizedVisible_det_eq_massRatio_sq`: scalar `2 sqrt(det rho) = m / E`
  wrapper, explicitly frame-relative.
- `twoStatePartialGram_det_eq_hiddenOverlapDetFactor`: the hidden overlap
  factor is the determinant of the two-label Gram matrix.
- `det_visibleReduced_twoLabel_eq_wedge_times_detGram`: two-label resolution
  mass factors as visible Plucker spread times hidden Gram determinant.
- `dephasing_internalGram_mass_monotone`: reducing hidden overlap magnitude
  increases the visible determinant factor.
- `unital_visibleChannel_massRatioSq_monotone`: the safe positive monotonicity
  class is unital visible contraction.
- `strict_unital_visibleChannel_massRatioSq_increases`: strict contraction
  strictly increases mass-ratio-square for nonzero Bloch radius.
- `entangling_hiddenChannel_massRatioSq_can_decrease`: scalar counterexample
  to unrestricted hidden-channel monotonicity.
- `PhysicsSM.Draft.NullEdgeSchmidtDeterminantCore` banks the real two-qubit
  Schmidt determinant bridge:
  `det(visibleReduced)=det(chiralityReduced)=(a*d-b*c)^2`.

This is enough to support a serious P1/P7 statement: the observer-channel
conjecture is not just "mass as concurrence." It is the combination of
resolution-channel Gram algebra, boost-invariant unnormalized determinant, and
frame-relative kinematic filtering.

## Missing pieces

### 1. Actual partial-trace theorem

The current wrapper treats `P_vis` as an abstract matrix or as the already
banked Gram-weighted output. The next formal step is the tensor statement:

```lean
visibleReduced_boost_eq_congruence_from_partialTrace
```

Informal theorem:

```text
Tr_int[(A tensor I) rho (A^dagger tensor I)]
  =
A (Tr_int rho) A^dagger.
```

Why it matters: this is the mathematical reason the resolution observer and
the visible boost commute.

Risk: Mathlib's tensor and partial-trace API may be too heavy for a fast proof.
If so, use a finite-index explicit matrix definition for `C^2 tensor C^n`.

### 2. Full two-label Gram equivalence

We have the product factor through the existing partial-coherence theorem. A
slightly stronger polished theorem should expose the exact determinant of `G`:

```lean
det_visibleReduced_twoLabel_eq_absWedgeSq_mul_detInternalGram
```

This should read exactly like the paper:

```text
det(V G V^dagger) = |v_1 wedge v_2|^2 det(G).
```

Why it matters: this is the cleanest finite statement of "hidden coherence
hides mass; dephasing makes mass visible."

### 3. Schmidt mixedness/coherence bridge

The determinant equality is now banked:

```lean
det_visibleReduced_eq_det_chiralityReduced
det_visibleReduced_eq_sq_detCoeff
det_chiralityReduced_eq_sq_detCoeff
```

What remains is the interpretation theorem connecting off-diagonal chirality
coherence to the determinant under a balance/frame convention:

```lean
chiralityPopulations_balanced_iff_coherence_eq_massRatio
```

Why it matters: it distinguishes the always-safe determinant identity from the
rest-frame/balanced-population reading "chirality coherence equals m / E."

### 4. Recoverability bridge

The finite relative-entropy observer-channel scaffold is classical. We need a
small mass-side theorem:

```lean
internalCoherenceLoss_eq_relativeEntropyDeficit_toy
```

or, if exact quantum relative entropy is too heavy:

```lean
hiddenOverlapRecoverable_iff_sameGramOffdiag
```

Why it matters: it links the observer-channel mass branch to P9
source-visibility. Lost hidden coherence and invisible source bookkeeping
should use the same recoverability vocabulary.

## Aristotle-ready jobs

### Job A: partial trace commutes with visible congruence

Type: focused standalone finite matrix package.
Status: submitted to Aristotle as project
`24d7e228-3636-4398-801f-32dc0cca70a6`, task
`90f52761-d9d8-4edc-b1af-98cb423a265b`.

Ask Aristotle to define finite tensor-index partial trace for visible index
`Fin 2` and hidden index `Fin n`, then prove:

```lean
partialTraceHidden_visibleCongruence
det_partialTraceHidden_visibleCongruence_invariant
```

Keep it standalone: Mathlib plus copied finite definitions only. Do not import
the full `PhysicsSM` tree.

### Job B: observer-channel audit/strategy

Type: strategy/audit, no build required.

Ask Aristotle to compare `NullEdgeObserverChannelCore` with the conjecture
statement and score each definition/theorem from 1 to 10 for physics alignment:
invariant/resolution output, kinematic filtering, internal Gram channel,
dephasing monotonicity, unital monotonicity, and entangling counterexample.

## Manuscript integration

P1 should use this order:

1. Plucker determinant theorem.
2. Resolution observer: `P_vis = V G V^dagger`.
3. Boost invariance: `det(A P_vis A^dagger)=det(P_vis)`.
4. Kinematic observer: `rho_{p|u}` as filtering/normalization.
5. Two-label Gram example: `|wedge|^2 det(G)`.
6. Interpretation: hidden coherence can erase visible mass; dephasing exposes
   it.
7. Monotonicity boundary: unital visible channels yes, entangling hidden
   channels no.

P7 should use this as the mass-side finite model before moving to relative
entropy and P9 source visibility.

## Decision thresholds

Promote the conjecture if:

- partial trace and visible boosts commute in the finite model;
- the Gram law remains the natural resolution-channel output;
- the Schmidt bridge proves visible mixedness/chirality determinant equality;
- the unital-versus-entangling monotonicity boundary survives formal review.

Demote the conjecture if:

- physical hidden labels cannot be represented by a stable Gram-bearing finite
  family;
- boosts necessarily act on the internal labels in the intended model;
- the `m / E` normalized state is treated as invariant rather than
  frame-conditioned;
- proper-time/purity monotonicity cannot be attached to a physically motivated
  channel class.
