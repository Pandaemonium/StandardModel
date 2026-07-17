# Aristotle semantic context pack

Generated: 2026-07-17T06:09:21
Query: `finite diagonal contact term strict-past causal kernel massive scattering response exp(L) Higgs scalar propagator`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [7.1 The Higgs is an internal zero-form with edge-supported variation]

Score: `0.844`

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

### 2. `AutonomousLab/work/role-activations/role-20260716-201927-f0636405_deliverable.md` [4. Scalar propagation supports a path-sum Higgs architecture, not a literal path]

Score: `0.813`

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

### 3. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [7.1 The Higgs is an internal zero-form with edge-supported variation]

Score: `0.811`

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

### 4. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [7.1 The Higgs is an internal zero-form with edge-supported variation]

Score: `0.801`

```text
gation.lean` supplies the complementary positive
statement as **`M [comp]`** finite algebra. A position-dependent insertion

\[
  M_{xx}=\bigl(m_0^2+\xi R_x\bigr)\mu_x
\]

is still diagonal, so both \(KM\) and \(MK\) remain weighted strict-past
kernels, are nilpotent at the event-cardinality power, and give an exact
two-sided finite resolvent. In the three-event control, changing the supplied
curvature to \((0,2,0)\) changes the endpoint response from the flat
nonuniform value \(-3\) to \(-9\), while the direct endpoint hop remains zero.
Curvature can therefore change amplitudes without changing causal support in
this finite model. The result does not derive \(R_x\) from order or prove the
continuum curved-space equation.

`HiggsGaugeInvariantCurvedPropagation.lean` lifts this result to the leading
gauge-invariant FMS radial channel as **`M [comp]`**. The scaled composite
kernel obeys the same exact two-sided curved resolvent and, at nonzero supplied
vacuum, has exactly the same entrywise support as the elementary radial
kernel. In the nonconstant-curvature three-event control the elementary
endpoint response is \(-9\), while the leading one-component
\(H^\dagger H\) response is \(-36\); the primitive direct hop remains zero.
Thus the present finite answer is gauge-invariant at leading FMS order:
curvature changes the weight of causal chains, while neither curvature nor the
observable lift creates support outside those chains. This still does not
control higher FMS terms, derive the continuum scalar pole, or derive the
curvature profile from causal order.

`HiggsStrictPastCausalSupport.lean` makes the causal claim entrywise as exact
**`M [orig/comp]`** finite algebra. It defines common strict-past support,
proves that support is closed under matrix multiplication by tra
```

### 5. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [7.1 The Higgs is an internal zero-form with edge-supported variation]

Score: `0.788`

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

### 6. `PhysicsSM/Draft/NullEdge/HiggsLocalStressResponse.lean` [localHiggsFunctional_affine_expansion]

Score: `0.782`

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

### 7. `PhysicsSM/Draft/NullEdge/HiggsLocalStressResponse.lean` [localHiggsFunctional]

Score: `0.775`

```text
def localHiggsFunctional
    (kineticWeight potentialWeight : Real)
    (sign : I -> Real)
    (dualMatrix : Matrix I Y Real)
    (samples : Y -> Complex)
    (potentialDensity : Real) : Real :=
  kineticWeight * signedKinetic sign (extractComponents dualMatrix samples) +
    potentialWeight * potentialDensity

/-- Linear response of the local Higgs functional under simultaneous kinetic
measure, dual-frame, and potential-measure perturbations. -/
```

### 8. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [7.1 The Higgs is an internal zero-form with edge-supported variation]

Score: `0.773`

```text
gr)^2\right].
\]

For \(g^2+g'^2>0\), the same kernel-checked finite algebra rewrites this as

\[
  q(A)=\frac12m_W^2\bigl((A^1)^2+(A^2)^2\bigr)
       +\frac12m_Z^2 Z^2,
  \qquad
  m_W=\frac{gv}{2},
  \qquad
  m_Z=\frac{v}{2}\sqrt{g^2+g'^2},
\]

with \(Z=(gA^3-g'B)/\sqrt{g^2+g'^2}\); the orthogonal photon direction has
zero stiffness. These are **`M [comp]`** reconstruction identities from the
supplied group, representation, vacuum, and couplings. They do not derive
\(g,g'\), \(v\), or a continuum gauge-boson pole.

The Higgs is also special in degree-of-freedom bookkeeping. For the four real
components of one complex doublet and three broken electroweak directions,
`HiggsDofConservation.dof_conserved_general_su2_witness` verifies
\(2\cdot3+4=3\cdot3+1=10\): three scalar orbit directions become the three
longitudinal polarizations, leaving one radial scalar, while the unbroken
photon is a spectator on both sides of the count. This is exact finite counting,
not a dynamical derivation of the vacuum or vector masses.

A covariantly constant vacuum section \(H_0\) therefore does not "travel". It
supplies an internal reference preserved by the unbroken holonomy directions.
A Higgs excitation \(h\), in \(H=H_0+h\), is a vertex field whose kinetic
variation is assembled from these edge differences. Its coarse massive
propagator may be reconstructed from causal edge histories, but it is not one
null worldline.

Nor is this the fermionic Weyl "zig-zag" mechanism. The radial scalar has no
left/right chirality pair whose local conversion supplies a Dirac mass.
Its finite massive response is instead a scalar retarded path sum with local
mass insertions between causal steps. Gauge holonomies may supply phases on
loops, but neither a chiral spiral nor a chirality flip is required fo
```

## Scoped paper hits

### 1. Feynman Propagator for a Free Scalar Field on a Causal Set

Score: `0.753`
Zotero key: `T389PSF5`
arXiv: `0909.0944`
DOI: `10.1103/PhysRevLett.103.180401`
URL: https://www.zotero.org/19894138/items/T389PSF5

Abstract:

The Feynman propagator for a free bosonic scalar field on the discrete spacetime of a causal set is presented. The formalism includes scalar field operators and a vacuum state which are first steps towards scalar quantum field theory on a causal set. This work can be viewed as a novel regularisation of quantum field theory based on a Lorentz invariant discretisation of spacetime.

### 2. Correction terms for propagators and d'Alembertians due to spacetime discreteness

Score: `0.743`
Zotero key: `arxiv:1411.2614`
arXiv: `1411.2614`
DOI: `10.1088/0264-9381/32/19/195020`
URL: http://arxiv.org/abs/1411.2614

Abstract:

Finite-sprinkling correction terms for causal-set retarded propagators and d'Alembertian operators compared with continuum limits.

### 3. Scalar Field Theory on a Causal Set in Histories Form

Score: `0.739`
Zotero key: `9RF2ESFQ`
arXiv: `1107.0698`
DOI: `10.1088/1742-6596/306/1/012017`
URL: https://www.zotero.org/19894138/items/9RF2ESFQ

Abstract:

Recasts into histories-based form a quantum field theory for a free scalar field on a background causal set. The resulting decoherence-functional resembles that of the continuum theory. The counterpart of the d'Alembertian operator is nonlocal and is a generalized inverse of the discrete retarded Green function. Comments on the significance and suggests how to include interactions.

### 4. Scattering Amplitudes For All Masses and Spins

Score: `0.736`
Zotero key: `5J5XDKMN`
arXiv: `1709.04891`
DOI: `10.1007/JHEP11(2021)070`
URL: https://www.zotero.org/19894138/items/5J5XDKMN

### 5. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.736`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548
