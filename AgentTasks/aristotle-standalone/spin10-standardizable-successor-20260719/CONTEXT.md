# Aristotle semantic context pack

Generated: 2026-07-19T18:14:46
Query: `pure spinor affine chart exponential two-form Pluecker quadrics reconstruction`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/Carrier/ArbitrarySpinorHodgeBridge.lean` [spinorSelectedDecoder]

Score: `0.829`

```text
noncomputable def spinorSelectedDecoder (psi phi : CSpinor) :
    Quartet →ₗ[ℝ] Quartet :=
  quartetSAt (turnScale psi phi)

/-- **Arbitrary-pair Hodge-Pluecker bridge.** Every exact representative has
```

### 2. `PhysicsSM/Draft/NullEdgeSpinorGeometryTargets.lean` [multiTwistorChartMomentum]

Score: `0.819`

```text
def multiTwistorChartMomentum {n : Nat} (Z : SpinorChartMultiTwistor n) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  finBundleMomentum Z.column

/-- The pairwise Pluecker spread of the spinor columns of the chart. -/
```

### 3. `PhysicsSM/Draft/NullEdge/Carrier/HodgePluckerMassBridge.lean` [quartet_class_cost_eq_canonical_plucker]

Score: `0.816`

```text
theorem quartet_class_cost_eq_canonical_plucker (chi : Quartet) :
    ((quartetB (qe2 + quartetQ chi)
        (quartetS (qe2 + quartetQ chi)) : ℝ) : ℂ) =
      complexAbsSq (spinorWedge edge0 (edge1 (2 / 5))) := by
  rw [(nondegenerate_quartet_witness).2.2.2.2.2.2.2.2 chi,
    canonical_plucker_mass]
  norm_num

/-- **Parameterized nondegenerate Hodge-Pluecker bridge.** The decoder family
`quartetSAt m` derives the same `m^2` carried by the canonical spinor pair for
every real scale and every exact representative. Unlike
`class_cost_eq_canonical_plucker`, this theorem has no separate `mu2=m^2`
hypothesis; the equality is built into and proved for the explicit decoder
family. -/
```

### 4. `PhysicsSM/Draft/NullEdgeGenerationBlindnessPort.lean` [to]

Score: `0.814`

```text
theorem to the canonical trusted Pluecker definitions in
`PhysicsSM.Spinor.PluckerMass`.

The mathematical claim is deliberately narrow: relabeling the finite visible
spinor family by a permutation does not change the visible pairwise Pluecker
mass. This does not assert anything about nonorthogonal hidden Gram data.
-/
```

## Scoped paper hits

### 1. Twisted geometries: A geometric parametrisation of SU(2) phase space

Score: `0.739`
Zotero key: `63MQ6KC3`
arXiv: `1001.2748v3`
URL: http://arxiv.org/abs/1001.2748v3

Abstract:

Twisted-geometry parametrization of SU(2) loop-gravity phase space, including face areas, normals, extrinsic angle, gauge-invariant reduced phase space, and connection to closure/geometricity constraints.

### 2. Spinors and Twistors in Loop Gravity and Spin Foams

Score: `0.737`
Zotero key: `TCC2N3U6`
arXiv: `1201.2120`
URL: http://arxiv.org/abs/1201.2120

Abstract:

Spinorial tools have recently come back to fashion in loop gravity and spin foams. They provide an elegant tool relating the standard holonomy-flux algebra to the twisted geometry picture of the classical phase space on a fixed graph, and to twistors. In these lectures we provide a brief and technical introduction to the formalism and some of its applications.

### 3. Momentum bispinor, two-qubit entanglement and twistor space

Score: `0.732`
Zotero key: `3VBEK82X`
arXiv: `1407.2492`
URL: http://arxiv.org/abs/1407.2492

Abstract:

Re-examines massive momentum bispinor symmetry and connects unit-energy future-lightcone geometry with two-qubit entanglement and twistor-space normalization. Important prior-art guardrail for observer-conditioned Pluecker mixedness.
