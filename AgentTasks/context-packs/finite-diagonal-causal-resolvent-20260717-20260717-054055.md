# Aristotle semantic context pack

Generated: 2026-07-17T05:41:03
Query: `finite diagonal plus nilpotent matrix inverse massive causal propagator link exponential exp L retarded Higgs response`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [7.1 The Higgs is an internal zero-form with edge-supported variation]

Score: `0.853`

```text
ion is
\(-3\), sampling the measure \(\mu_1=3\) at the intermediate event. This
identifies one finite operator across the action and propagation descriptions;
it does not yet turn the Euclidean stiffness functional into a Lorentzian
continuum equation or derive the measure from causal order.
`HiggsStrictPastMeasuredResolvent.lean` then removes the remaining finite
algebraic condition as **`M [comp]`**. Multiplication by the diagonal local
mass matrix merely rescales source weights in \(KM\) and target weights in
\(MK\); both products remain weighted strict-past kernels and are nilpotent at
the event-cardinality power. Consequently the nonuniform measured Higgs path
sum obeys both exact finite resolvent equations with no terminal remainder on
every nonempty finite strict order. This establishes causal support and finite
invertibility algebra, not continuum hyperbolicity, pole normalization, or a
physical spectrum.
`MassiveRetardedLinkSeries.lean` and
`HiggsMassiveRetardedPropagation.lean` now make the corresponding propagation
statement exact as **`M [comp]`** finite algebra. A matrix kernel supported on a
finite strict causal order is nilpotent, so the radial mass parameter enters a
terminating retarded series

\[
  G_h(H)=\sum_{k=0}^{H-1}(-m_h^2)^k K^{k+1},
  \qquad (I+m_h^2K)G_h=G_h(I+m_h^2K)=K.
\]

The three-event control has no primitive endpoint entry, a unit two-link
amplitude, and, at the convention-specific choice \(\lambda=1/8,v=1\), a
massive endpoint amplitude \(-1\). This is the precise finite sense in which a
Higgs excitation propagates through sums of null-edge chains rather than along
one null edge. It is not yet a continuum Klein-Gordon pole or an observed-mass
prediction.
`HiggsGaugeInvariantRetardedPropagation.lean` closes the finite observable
composi
```

### 2. `PhysicsSM/Draft/NullEdgeCompositeZeroEscape.lean`

Score: `0.794`

```text
namespace PhysicsSM.Draft.NullEdgeCompositeZeroEscape

open scoped BigOperators
open Matrix
open PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety

/-! ## 0. Propagator zeros as singular symbols -/

/-- The inverse-propagator / Dirac symbol at the candidate momentum, an
`n × n` real matrix. -/
```

### 3. `AgentTasks/external/PhysLean/docs/QI_DOC.md` [Matrix Exponential]

Score: `0.794`

```text
### Matrix Exponential

**Definition:**
```lean
def exp (A : HermitianMat d 𝕜) : HermitianMat d 𝕜 :=
  A.cfc Real.exp
```

**Properties:**
- **Positivity**: `0 ≤ A.exp` always (exponential of a Hermitian matrix is PSD)
- **Exponential of zero**: `(0 : HermitianMat n 𝕜).exp = 1`
- **Exponential is always nonsingular**: `A.exp` is always invertible
- **Inverse**: `(A.exp)⁻¹ = (-A).exp`

---
```

### 4. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [7.1 The Higgs is an internal zero-form with edge-supported variation]

Score: `0.793`

```text
e chains rather than along
one null edge. It is not yet a continuum Klein-Gordon pole or an observed-mass
prediction.
`HiggsGaugeInvariantRetardedPropagation.lean` closes the finite observable
composition as **`M [comp]`**. For the one-component control vacuum, the leading
gauge-invariant FMS radial kernel obeys the same left and right strict-past
resolvent identities as the elementary radial kernel and, at nonzero vacuum,
has exactly the same entrywise support. In the three-event control the direct
endpoint entry remains zero, the elementary two-link massive response is
\(-1\), and the leading gauge-invariant response is \(-4\) in the supplied
unnormalized radial coordinate. This supplies an observable finite path-sum
witness without upgrading it to a continuum pole.
`HiggsGaugeInvariantMeasuredPropagation.lean` extends that conclusion to the
nonuniform measured insertion as **`M [comp]`**. The leading FMS kernel obeys
the same exact two-sided measured resolvent and, at nonzero vacuum, has exactly
the elementary kernel's entrywise support. In the three-event control the
intermediate measure changes the elementary endpoint response to \(-3\), and
the leading one-component FMS response is \(-12\), while the direct endpoint
entry remains zero. Thus local measure data changes amplitudes but does not
create acausal support in this finite control.
`HiggsCompositeGap.lean` gives a one-mode mean-field seed in which radial
stiffness is derived from a fermion condensate, but neither route yet supplies
a continuum composite Higgs pole, renormalization group flow, electroweak
vacuum, or measured 125 GeV mass.

The present Higgs ontology is therefore a controlled fork, not a settled
origin theorem. The elementary branch supplies a vertex zero-form and its
potential; `HiggsCriticali
```

### 5. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [7.1 The Higgs is an internal zero-form with edge-supported variation]

Score: `0.792`

```text
ausalSupport.lean` makes the causal claim entrywise as exact
**`M [orig/comp]`** finite algebra. It defines common strict-past support,
proves that support is closed under matrix multiplication by transitivity and
under finite sums, and applies the result to the uniform, measured,
curvature-dependent, and leading gauge-invariant Higgs series. For every one
of these kernels,

\[
  \neg\bigl(y\prec x\bigr)\quad\Longrightarrow\quad G(x,y)=0.
\]

Thus local mass, measure, curvature, and the leading FMS observable lift can
change amplitudes but cannot create finite response outside the supplied
strict past. The theorem does not select the primitive weights or prove that
the supplied strict-past kernel is the continuum-calibrated null-link kernel;
that remains part of the operator-convergence gate.

`HiggsCurvatureActionResponse.lean` separates the corresponding geometry
variation as exact **`M [orig/comp]`** finite algebra. In the explicit sign
convention

\[
  S_\xi=-\mu\,\xi R\,\lVert H\rVert^2,
\]

holding the Higgs field fixed gives

\[
  \delta S_\xi=-\xi\lVert H\rVert^2
    \bigl((\delta\mu)R+\mu\,\delta R\bigr).
\]

The first term is the volume channel; the second records the independent
curvature response needed before any improved Higgs stress tensor can be
claimed. The module proves gauge invariance of both channels and an explicit
parallel-vacuum witness: the frozen-modulus Higgs has exactly zero finite link
cost while a nonzero supplied curvature response produces a nonzero local
action response. Thus “the vacuum does not move” is not “the vacuum is
gravitationally inert.” A graph-derived \(\delta R\), its coframe/metric
normalization, and the resulting conservation identity remain open.

Finally, coupling the Higgs to reconstructed gravity does not explain the
H
```

### 6. `PhysicsSM/Draft/NullEdge/HiggsLocalStressResponse.lean` [localHiggsFunctional_affine_expansion]

Score: `0.790`

```text
theorem localHiggsFunctional_affine_expansion
    (kineticWeight kineticResponse potentialWeight potentialResponse : Real)
    (sign : I -> Real)
    (dualMatrix dualVariation : Matrix I Y Real)
    (samples : Y -> Complex) (potentialDensity epsilon : Real) :
    localHiggsFunctional
        (kineticWeight + epsilon * kineticResponse)
        (potentialWeight + epsilon * potentialResponse)
        sign (dualMatrix + epsilon • dualVariation) samples potentialDensity =
      localHiggsFunctional kineticWeight potentialWeight sign dualMatrix
          samples potentialDensity +
        epsilon * localHiggsFirstResponse
          kineticWeight kineticResponse potentialResponse sign
          (extractComponents dualMatrix samples)
          (extractComponents dualVariation samples) potentialDensity +
        epsilon ^ 2 *
          (kineticWeight * signedKinetic sign
              (extractComponents dualVariation samples) +
            kineticResponse * signedKineticFirstVariation sign
              (extractComponents dualMatrix samples)
              (extractComponents dualVariation samples)) +
        epsilon ^ 3 *
          (kineticResponse * signedKinetic sign
            (extractComponents dualVariation samples)) := by
  unfold localHiggsFunctional localHiggsFirstResponse
  rw [extractedKinetic_affine_expansion]
  ring

/-- At the base of the affine path, the derivative of the complete local Higgs
functional is exactly the displayed three-channel first response. -/
```

### 7. `PhysicsSM/Draft/NullEdgeScalarGaugeNullQuadrature.lean`

Score: `0.786`

```text
A genuine Lorentzian inverse-Gram matrix keeps the
  cross terms, so the covariant Higgs kinetics is *not* ordinary graph/lattice
  Higgs theory with null labels.
-/
```

### 8. `AutonomousLab/work/role-activations/role-20260716-201927-f0636405_deliverable.md` [4. Scalar propagation supports a path-sum Higgs architecture, not a literal path]

Score: `0.784`

```text
### 4. Scalar propagation supports a path-sum Higgs architecture, not a literal path

**Primary sources:**

- Steven Johnston, *Particle propagators on discrete spacetime*,
  arXiv:0806.3083, DOI:10.1088/0264-9381/25/20/202001. New key:
  `3FEVHQJA`.
- Nomaan X, Fay Dowker, and Sumati Surya, *Scalar Field Green Functions on
  Causal Sets*, arXiv:1701.07212, DOI:10.1088/1361-6382/aa6bc7. New key:
  `4IHIDDGX`.

**Full-text verification:** Johnston's stored chunks 140, 151, and 155-157, and
the later paper's chunks 2, 6-7, and 11-15. The massive retarded scalar Green
function is represented as a mass-scattering series built from the massless
one; on the causal set this becomes a sum over chains or paths with hop and
stop weights. Stated continuum agreements are dimension- and background-
dependent. The curved paper proves or proposes extensions in Riemann normal
neighborhoods and selected conformally flat constant-curvature spacetimes.

**Consequence for the Higgs question:** this literature supports treating a
massive Higgs excitation as aggregate causal-set propagation assembled from a
massless causal kernel plus local mass insertions. It does not show that a Higgs
quantum follows one unique null edge, that every hop is a Hasse link in every
dimension, or that the interacting Standard Model Higgs sector is recovered.
The null-edge model's safest ontology remains: Higgs values on vertices,
covariant changes on causal edges, local Yukawa flips, and an emergent massive
propagator after summing histories.
```

## Scoped paper hits

### 1. Correction terms for propagators and d'Alembertians due to spacetime discreteness

Score: `0.737`
Zotero key: `arxiv:1411.2614`
arXiv: `1411.2614`
DOI: `10.1088/0264-9381/32/19/195020`
URL: http://arxiv.org/abs/1411.2614

Abstract:

Finite-sprinkling correction terms for causal-set retarded propagators and d'Alembertian operators compared with continuum limits.

### 2. Scalar Field Green Functions on Causal Sets

Score: `0.733`
Zotero key: `4IHIDDGX`
arXiv: `1701.07212`
DOI: `10.1088/1361-6382/aa6bc7`
URL: http://arxiv.org/abs/1701.07212

Abstract:

We examine the validity and scope of Johnston's models for scalar field retarded Green functions on causal sets in 2 and 4 dimensions. As in the continuum, the massive Green function can be obtained from the massless one, and hence the key task in causal set theory is to first identify the massless Green function. We propose that the 2-d model provides a Green function for the massive scalar field on causal sets approximated by any topologically trivial 2 dimensional spacetime. We explicitly demonstrate that this is indeed the case in a Riemann normal neighbourhood. In 4-d the model can again be used to provide a Green function for the massive scalar field in a Riemann normal neighbourhood which we compare to Bunch and Parker's continuum Green function. We find that the same prescription can also be used for deSitter spacetime and the conformally flat patch of anti deSitter spacetime. Our analysis then allows us to suggest a generalisation of Johnston's model for the Green function for a causal set approximated by 3 dimensional flat spacetime.

### 3. Feynman Propagator for a Free Scalar Field on a Causal Set

Score: `0.730`
Zotero key: `T389PSF5`
arXiv: `0909.0944`
DOI: `10.1103/PhysRevLett.103.180401`
URL: https://www.zotero.org/19894138/items/T389PSF5

Abstract:

The Feynman propagator for a free bosonic scalar field on the discrete spacetime of a causal set is presented. The formalism includes scalar field operators and a vacuum state which are first steps towards scalar quantum field theory on a causal set. This work can be viewed as a novel regularisation of quantum field theory based on a Lorentz invariant discretisation of spacetime.

### 4. Particle propagators on discrete spacetime

Score: `0.729`
Zotero key: `3FEVHQJA`
arXiv: `0806.3083`
DOI: `10.1088/0264-9381/25/20/202001`
URL: http://arxiv.org/abs/0806.3083

Abstract:

A quantum mechanical description of particle propagation on the discrete spacetime of a causal set is presented. The model involves a discrete path integral in which trajectories within the causal set are summed over to obtain a particle propagator. The sum-over-trajectories is achieved by a matrix geometric series. For causal sets generated by sprinkling points into 1+1 and 3+1 dimensional Minkowski spacetime the propagator calculated on the causal set is shown to agree, in a suitable sense, with the causal retarded propagator for the Klein-Gordon equation. The particle propagator described here is a step towards quantum field theory on causal set spacetime.

### 5. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.726`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548
