# Null-edge causal graph next wave

Date: 2026-06-21

Status: post-Pluecker and post-spinor-geometry planning note.

Related Lean files:

- `PhysicsSM/Spinor/PluckerMass.lean`
- `PhysicsSM/Draft/NullEdgePluckerGeneralAristotle.lean`
- `PhysicsSM/Draft/NullEdgeSpinorGeometryTargets.lean`
- `PhysicsSM/Draft/TwistorPluckerMass.lean`
- `PhysicsSM/Gauge/CausalDiamondHolonomy.lean`
- `PhysicsSM/Draft/NullEdgeDiamondNonabelian.lean`
- `PhysicsSM/Draft/NullEdgeCochainDiamond.lean`
- `PhysicsSM/Draft/NullEdgeYukawaFlip.lean`
- `PhysicsSM/Draft/NullEdgeYukawaGaugeAristotle.lean`

## What has now moved from slogan to theorem

The visible null-edge mass mechanism is no longer just a motivating picture.
The finite theorem package now says:

```text
det(sum_i psi_i psi_i^dagger)
  =
sum_{i<j} |psi_i wedge psi_j|^2.
```

It also proves the equality condition:

```text
mass = 0
  iff
all spinors share one projective direction
```

with a chosen nonzero base spinor.

The spinor-geometry layer adds:

```text
|<psi,phi>|^2 + |psi wedge phi|^2 = ||psi||^2 ||phi||^2
```

and therefore, for normalized spinors,

```text
|psi wedge phi|^2 = 1 - |<psi,phi>|^2.
```

This is the clean Fubini-Study reading:

```text
mass contribution = projective angular spread.
```

Finally, `SL(2,C)` frame changes preserve both the pairwise Pluecker mass and
the determinant mass.  This makes the finite bundle mass a Lorentz-spinor
invariant rather than a coordinate artifact.

The twistor wrapper now also states the explicit normalization bridge between
the determinant convention `m^2 = det(P)` and the trace-pairing convention
`P^2 = 2 det(P)`.

The causal-diamond gauge theorem is now trusted: Abelian defects are gauge
invariant, non-Abelian defects are endpoint-conjugation covariant, and class
functions of non-Abelian defects are gauge invariant. The same trusted module
now includes path-pair composition laws for glued diamonds: vertical gluing has
the expected non-Abelian transport/conjugation correction, horizontal gluing
cancels the shared branch, and the Abelian specialization is ordinary defect
multiplication.

## Latest Aristotle integrations

Completed and integrated continuation:

```text
PhysicsSM/Draft/CheckerboardKernelClosedFormsAristotle.lean
```

Target:

```text
Endpoint-level closed forms for the finite checkerboard kernel, obtained by
combining the corner-count polynomial theorem with the closed binomial corner
counts.
```

The proved declarations are:

```text
pathSum_right_right_closed_form
pathSum_right_left_closed_form
pathSum_right_right_straight
pathSum_right_left_straight_zero
```

The earlier Yukawa gauge-legality wave has completed and is integrated in

```text
PhysicsSM/Draft/NullEdgeYukawaGaugeAristotle.lean
```

The endpoint-kernel Aristotle task was
`62a3c14d-d084-4a24-b1e6-4e86a4ec605b`.

New submitted continuation:

```text
PhysicsSM/Draft/CausalDiamondHigherGaugeAristotle.lean
```

Target: endpoint-transport/whiskering notation, transport functoriality,
vertical composition in transport form, associativity, and interchange for
finite path-pair gluing. Aristotle project:
`0897a0dd-888e-451f-97e7-e24633cd2699`, task
`a0748c78-baba-4edc-8f4e-ba71f1798110`.

## Local theorem gains after the spinor job

Finite theorem islands added or promoted without waiting for Aristotle:

1. `PhysicsSM.Gauge.CausalDiamondHolonomy` promotes Abelian diamond gauge
   invariance, non-Abelian endpoint covariance, and class-function invariance
   to trusted code, and now adds vertical/horizontal composition laws for
   glued path-pair defects.
2. The formal chain boundary theorem dualizes to an integral cochain
   coboundary theorem, `delta^2 = 0`.

These are the first clean seeds of:

```text
gauge curvature = causal-diamond holonomy defect
fermion/cochain structure = order-complex coboundary algebra
```

## Highest-value next theorem families

### 1. Trusted visible mass package

The proved draft theorem island has now been promoted to:

```text
PhysicsSM/Spinor/PluckerMass.lean
```

This trusted module includes the determinant identity, a real-valued
nonnegativity wrapper, and the mass-zero/common-direction criterion.

Remaining cleanup after promotion:

- keep twistor interpretation in a separate wrapper module.

### 2. Path-amplitude theorem layer

The mass theorem is kinematic.  The next physics question is dynamic:

```text
When do null-edge histories with chirality-flip amplitudes reproduce a Dirac
propagator or dispersion relation?
```

Near-term finite targets:

- checkerboard path-sum closed forms by endpoint and corner count;
  (now integrated as `PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle`,
  pending trusted promotion);
- transfer-matrix recursion for left/right chirality sectors
  (now promoted to `PhysicsSM.Spinor.CheckerboardDynamics`);
- exact finite telegraph/Klein-Gordon recursion in which the corner amplitude
  enters through `mu^2`
  (now promoted to `PhysicsSM.Spinor.CheckerboardDynamics`);
- convention matching between `mu = i epsilon m` and the standard `1+1`
  checkerboard model
  (now promoted as `pathSum_klein_gordon_physical_corner`);
- a finite two-state chirality walk whose continuum expansion has the Dirac
  form to first nontrivial order.

These are better targets than jumping straight to a continuum theorem.

### 3. Twistor incidence beyond the chart wrapper

The twistor/Pluecker chart wrapper now lives in
`PhysicsSM.Draft.TwistorPluckerMass`, with hand-proof notes in
`Sources/Twistor_Plucker_Matching_Wrapper_2026-06-21.md`. It is intentionally
narrow: it only packages the spinor part of the infinity-twistor pairing as a
Pluecker wedge. Next steps:

- define projective rescaling of spinor columns
  (now added in `NullEdgeSpinorGeometryTargets`);
- prove how pairwise Pluecker mass scales under independent column rescalings
  (now added as `finPairwisePluckerMass_rescale`);
- identify the normalized/projective quantity that is invariant under those
  rescalings
  (now added as `projectiveWedgeSpread_smul_smul`);
- bridge common mass normalizations
  (now added in `TwistorPluckerMass`: determinant convention vs.
  trace-pairing `2 * det` convention);
- only then add incidence data `omega = i x pi`.

This avoids making premature claims about full twistor geometry.

### 4. Non-Abelian diamond composition

The trusted theorem now proves endpoint conjugation and class-function
invariance, plus the first path-pair composition API.  Next:

- package the path-pair laws as a small finite double-category/groupoid
  scaffold;
- define whiskering/basepoint transport explicitly as named operations;
- connect the finite gluing law to the Schreiber-Waldorf surface-holonomy
  gluing axioms at the level of sourced interpretation only;
- then ask for a 2-categorical API.

This is the path toward higher-gauge causal diamonds.

### 5. Order-complex and Kahler-Dirac scaffold

The current cochain theorem gives `delta^2 = 0`.  Next:

- grade simplices by length;
- define even and odd cochains;
- define a finite Hodge-star surrogate only after choosing weights;
- define a formal Dirac operator `D = delta + delta_adj`;
- prove the algebraic identity `D^2 = Laplacian` under the chosen adjoint.

The adjoint and positivity choices are where mathematical assumptions enter,
so they should be explicit.

### 6. Graph observables for gravity

Do not try to prove Einstein equations yet.  First define finite observables:

- edge crossing count for a screen;
- null momentum flux through a screen;
- additivity under disjoint screen partitions;
- invariance of flux under collinear subdivision;
- Pluecker mass contribution under non-collinear refinement.

This creates the finite vocabulary needed for a later Jacobson-style
thermodynamic argument.

## Suggested next Aristotle waves

1. Promote the checkerboard endpoint-kernel file after source and theorem
   surface cleanup.
2. Submit a projective twistor wave:
   column rescaling, normalized Pluecker spread, and chart-level projective
   invariants.
3. Submit a diamond higher-gauge wrapper wave:
   path-pair composition as whiskering, associativity/coherence laws, and
   clean basepoint transport names.
4. Submit a cochain grading wave:
   even/odd cochains and the first Hodge-Dirac algebra scaffold.

## Main research claim after this wave

The strongest current statement is:

```text
Finite bundles of visible null spinor edges have a Lorentz-spinor invariant
mass equal to their total projective angular spread.  Standard Model Higgs
insertions supply the finite representation-theoretic permission for
chirality-changing graph vertices.  Gauge curvature is represented by
causal-diamond holonomy defects, and fermionic graph structure begins with the
order-complex cochain algebra.
```

That is a coherent theorem-first spine for the program.
