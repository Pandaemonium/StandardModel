# Aristotle semantic context pack

Generated: 2026-07-15T03:54:39
Query: `null edge bare graph relative scale reconstruction common density event counts conformal coframe Weyl factor plaquette area inverse area curvature holonomy continuum Einstein general relativity`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean`

Score: `0.856`

```text
import Mathlib

/-!
# Bare-graph scale boundary and calibrated four-dimensional reconstruction

This module isolates the scale half of the Malament/order-number split used by
the null-edge GR program.

The bare finite relation supplies relabeling orbits. A positive scalar field
that is invariant under relation automorphisms remains invariant after every
positive global rescaling, so relabeling invariance alone cannot select an
absolute normalization. On a vertex-transitive relation it cannot even select
an inhomogeneous invariant scalar field.

Event number supplies volume only after a density calibration `density` is
specified: `countingVolume density n = n / density`. Distinct positive
calibrations give distinct volumes for every nonempty region.

The constructive half then specializes to four dimensions. Given a
nondegenerate representative coframe `e` and a positive target volume, the
positive conformal factor is the fourth root of the target/base volume ratio.
The resulting coframe has exactly the target volume, and this positive factor
is unique. Taking the target to be calibrated counting volume closes the finite
scale equation exactly.

This is a reconstruction boundary, not a derivation of density, a coframe, or
manifoldlikeness from a bare graph. It records precisely which extra datum
breaks the global scale degeneracy. The graph statements are clean-room finite
algebra. The continuum interpretation follows the standard causal
order-plus-volume reconstruction principle; metric signature is not used in
the determinant-volume calculation.
-/

open Matrix
```

### 2. `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean` [countCalibratedScale]

Score: `0.844`

```text
def countCalibratedScale
    (density : Real) (n : Nat) (e : Coframe4) : Real :=
  calibratedConformalScale e (countingVolume density n)

/-- **Calibrated scale reconstruction.** A positive density, nonempty event
count, and nondegenerate representative coframe determine a unique positive
Weyl factor whose coframe volume equals calibrated counting volume. -/
```

### 3. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]

Score: `0.828`

```text
## 10. Current theorem ledger

| Statement | Grade | What is actually established | Missing bridge |
|---|---|---|---|
| Causal structure fixes continuum conformal geometry under causality hypotheses | T [import] | Light cones and conformal class | Finite-order reconstruction and scale |
| Counting can represent spacetime volume in a manifoldlike causal set | T|H [import] | Order-number reconstruction principle | Density, manifold approximation, fluctuations |
| Causal conformal class plus smooth positive volume fixes the metric uniquely | T|H [interp] | Explicit positive conformal factor \(\Omega=(d\mu/d\operatorname{Vol}_{\bar g})^{1/d}\) | Prove the null-edge order/count limit supplies both inputs |
| Bare-relation invariance does not fix absolute scale | M [orig] | Every positive invariant scale has distinct positive global rescalings; transitive relations force invariant scalar fields to be constant | Derive symmetry-breaking calibration data from the physical ensemble |
| Calibrated count fixes a positive four-dimensional Weyl factor on a supplied coframe ray | M [orig] | Exact fourth-root reconstruction and positive-factor uniqueness, with nonzero witnesses | Derive density, manifoldlikeness, and the conformal coframe representative |
| Noncollinear null sums can be timelike | T [import] | Positive invariant norm from null cross terms | Dynamical selection of histories |
| Two-direction 1+1 null ticks obey \(\tau^2=4\varepsilon^2N_+N_-\), with a null/timelike dichotomy and balanced maximum | M [comp] | Exact endpoint algebra and nonzero two-tick witness | Curved-spacetime reconstruction and history dynamics |
| Null-spinor exterior area gives a finite mass operator | M [orig] | Exact finite algebra and gap-closing locus | Absolute scale and interacting renormaliz
```

### 4. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G2. Unique scale reconstruction]

Score: `0.827`

```text
### G2. Unique scale reconstruction

Relate counting volume to the soldering Gram volume.

The finite boundary is now exact. Bare-relation invariance alone leaves a
positive global rescaling ray, and a nonzero event count determines volume only
after a positive density calibration is supplied. Given that calibration and a
nondegenerate four-dimensional conformal coframe representative, the unique
positive Weyl factor is the fourth root of the target/base volume ratio. This
closes the algebraic scale equation but derives none of its geometric inputs.

**Success:** one local conformal factor is determined, with no double counting.  
**Kill:** incompatible count and decoration volumes or an unfixed Weyl mode.
```

### 5. `AgentTasks/null-edge-bare-graph-scale-reconstruction-aristotle-2026-07-14.md` [Locked interpretation]

Score: `0.819`

```text
## Locked interpretation

1. `RelationAutomorphism R T` means only that a vertex equivalence preserves
   the directed relation in both directions.
2. `GraphInvariant R s` is invariance of a real scalar field under every such
   relabeling. It is not a claim that every physically admissible graph
   observable has this form.
3. `bareGraphScale_rescaling_ray` proves only that relabeling invariance and
   positivity do not select an absolute normalization: every positive global
   multiple is still invariant, and a nonunit multiple differs from the
   original field.
4. `countingVolume density n = n / density` treats density as an independent
   calibration. The theorem must not imply that raw count derives density.
5. The constructive scale theorem is four-dimensional and conditional on a
   nondegenerate real coframe representative. It selects the unique positive
   Weyl factor whose absolute determinant equals calibrated counting volume.
6. No theorem here derives manifoldlikeness, a coframe, Lorentz signature,
   spin structure, curvature, or Einstein dynamics from the bare relation.
```

### 6. `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean` [positive_conformalScale_unique]

Score: `0.816`

```text
theorem positive_conformalScale_unique
    (e : Coframe4) (targetVolume omega1 omega2 : Real)
    (he : 0 < coframeVolume e)
    (homega1 : 0 < omega1) (homega2 : 0 < omega2)
    (hvolume1 :
      coframeVolume (conformalCoframe omega1 e) = targetVolume)
    (hvolume2 :
      coframeVolume (conformalCoframe omega2 e) = targetVolume) :
    omega1 = omega2 := by
  have hpows : omega1 ^ 4 = omega2 ^ 4 := by
    rw [coframeVolume_conformalCoframe omega1 e homega1.le] at hvolume1
    rw [coframeVolume_conformalCoframe omega2 e homega2.le] at hvolume2
    apply mul_right_cancel₀ he.ne'
    exact hvolume1.trans hvolume2.symm
  exact (pow_left_inj₀ homega1.le homega2.le
    (by norm_num : (4 : Nat) ≠ 0)).mp hpows

/-- Conformal factor obtained from a calibrated event count. -/
```

### 7. `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean` [calibratedConformalScale_reconstructs]

Score: `0.814`

```text
theorem calibratedConformalScale_reconstructs
    (e : Coframe4) (targetVolume : Real)
    (he : 0 < coframeVolume e) (htarget : 0 < targetVolume) :
    coframeVolume
        (conformalCoframe (calibratedConformalScale e targetVolume) e) =
      targetVolume := by
  rw [coframeVolume_conformalCoframe _ _
    (calibratedConformalScale_pos e targetVolume he htarget).le]
  unfold calibratedConformalScale
  rw [fourthRoot_pow_four (div_nonneg htarget.le he.le)]
  exact div_mul_cancel₀ targetVolume he.ne'

/-- Two positive Weyl factors producing the same nonzero coframe volume are
equal. -/
```

### 8. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [Abstract]

Score: `0.809`

```text
## Abstract

The null-edge program starts from causal events, primitive null support, local
soldering data, and amplitudes or transports assigned to finite histories.
General relativity starts from a smooth Lorentzian metric whose null cones,
proper times, volume form, connection, and curvature are dynamical. The two
descriptions meet at a sharp reconstruction problem.

The strongest established bridge is kinematical. Causal structure determines
the continuum conformal geometry under standard causality hypotheses, while a
volume element fixes the missing conformal scale. Sums of noncollinear null
displacements become timelike and acquire positive endpoint proper time; sums
of noncollinear null momenta become timelike and acquire invariant mass. The
same Lorentzian cross terms underlie both facts.

The current null-edge formalization adds finite coframes, local-frame
covariance, induced metrics, transport defects, holonomy, Clifford soldering,
and exact Dirac-square decompositions. It also contains finite variational,
thermodynamic, spectral, and teleparallel avatars of gravitational equations.
These are useful algebraic tests, but they do not yet derive the Einstein
equation, a continuum tetrad, Newton's constant, or gravitational backreaction.

This note separates established general relativity, machine-checked finite
identities, conditional reconstructions, and conjectural dynamics. Its central
proposal is:

> A viable null-edge route to general relativity must reconstruct the metric in
> two stages: causal order supplies the conformal class, while counting or
> soldering supplies exactly one scale field. Connection and curvature must
> then arise from covariant transport, and an independently justified action or
> equation-of-state principle must select Einstein dyna
```

## Scoped paper hits

### 1. Regge Calculus in Teleparallel Gravity

Score: `0.751`
Zotero key: `T5ZH4WC8`
arXiv: `gr-qc/0208036`
DOI: `10.1088/0264-9381/19/19/301`
URL: http://arxiv.org/abs/gr-qc/0208036

Abstract:

In the context of the teleparallel equivalent of general relativity, the Weitzenbock manifold is considered as the limit of a suitable sequence of discrete lattices composed of an increasing number of smaller an smaller simplices, where the interior of each simplex (Delaunay lattice) is assumed to be flat. The link lengths between any pair of vertices serve as independent variables, so that torsion turns out to be localized in the two dimensional hypersurfaces (dislocation triangle, or hinge) of the lattice. Assuming that a vector undergoes a dislocation in relation to its initial position as it is parallel transported along the perimeter of the dual lattice (Voronoi polygon), we obtain the discrete analogue of the teleparallel action, as well as the corresponding simplicial vacuum field equations.

### 2. Higher gauge theory

Score: `0.751`
DOI: `10.1090/conm/431/08264`
URL: https://doi.org/10.1090/conm/431/08264

### 3. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.751`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.

### 4. Stochastic Gravity: Theory and Applications

Score: `0.749`
Zotero key: `TXN5JSZ5`
DOI: `10.12942/lrr-2008-3`
URL: https://doi.org/10.12942/lrr-2008-3

### 5. Noise kernel in stochastic gravity and stress energy bitensor of quantum fields in curved spacetimes

Score: `0.747`
Zotero key: `5T5BQ6PT`
DOI: `10.1103/physrevd.63.104001`
