# Aristotle semantic context pack

Generated: 2026-07-10T00:39:05
Query: `quartet closed sector decoder pairing positive semidefinite Krein BRST cohomology`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/null-edge-p2-branch-resolution-aristotle-2026-06-24.md` [Scientific role]

Score: `0.765`

```text
## Scientific role

This task advances the `P2-R` / `P4-R` / `P7-R` bridge.

The current finite P2 chain has proved that the two-level chiral Hamiltonian

```text
H_h(p,m) = [[-h p, m], [m, h p]]
```

squares to the mass-shell scalar, that the positive branch
`P+ = (1/2)(I + H/E)` carries left/right coherence `m/(2E)`, and that `P+` is
trace one and idempotent on shell. This job adds the negative branch
`P- = (1/2)(I - H/E)` and proves the branch-resolution package:

```text
P+ + P- = I,
P+ P- = P- P+ = 0,
P-^2 = P-,
E (P+ - P-) = H.
```

The centerpiece is the finite spectral reconstruction identity. It is the
right precursor to a null-step walk coin/reflection operator and to the
super-Dirac branch interpretation.

This is finite `2 x 2` matrix algebra only. It is not a continuum Dirac limit.
```

### 2. `PhysicsSM/Draft/NullEdgeDecoherenceChannelAristotle.lean` [coherentSpinorPairMomentum_det_eq_zero]

Score: `0.764`

```text
theorem coherentSpinorPairMomentum_det_eq_zero (psi phi : CSpinor) :
    (coherentSpinorPairMomentum psi phi).det = 0 := by
  unfold coherentSpinorPairMomentum
  exact det_rankOneHermitian_eq_zero _

/-- The decohered two-alternative momentum is the trusted two-edge momentum. -/
```

### 3. `PhysicsSM/Draft/Sedenions/CocycleQuadraticPhase.lean` [establishes]

Score: `0.763`

```text
upports
- `zeroProd_iff_linearPhase` : **main theorem** — a same-strut support is a
  zero-product support iff its four-fold ω-product = +1 (linear phase)
- `plaquetteOmegaProd_on_zeroProd` : ω-product = +1 on all 42 supports
- `plaquetteOmegaProd_on_extra` : ω-product = -1 on all 21 extras
- `omega_quaternion_cocycle` : ω restricted to quaternion subalgebra is a 2-cocycle

## Mathematical significance

The four-fold ω-product `ω(lo₁,lo₂) · ω(lo₁,hi₂) · ω(hi₁,lo₂) · ω(hi₁,hi₂)`
on a same-strut plaquette `{lo₁, lo₂, hi₁, hi₂}` measures whether the
Cayley-Dickson sign restriction to the plaquette is **linear** (product = +1)
or **quadratic but not linear** (product = -1) on the affine 2-plane.

The main theorem establishes: a same-strut mixed support admits a sedenion
zero-product relation if and only if this obstruction vanishes. This cleanly
characterizes the 42 zero-product supports as the "linear-phase" plaquettes,
and is the first step toward a Z₄/quadratic refinement in the
Albuquerque-Majid twisted-group-algebra framework.
-/

set_option linter.style.nativeDecide false
```

### 4. `AgentTasks/sedenion-next-z4-kerdock-refinement-aristotle-2026-05-23.md` [Big Goal]

Score: `0.762`

```text
## Big Goal

Lift the signed sedenion plaquettes from `{+1,-1}` signs to `ZMod 4` quadratic
phase data and test whether they form a Kerdock/Barnes-Wall-style refinement.

Literature motivation:

- Stabilizer states can be described by affine supports and quadratic phases.
- Z4-valued Kerdock codewords exponentiate to stabilizer states.
- Barnes-Wall, Kerdock, Clifford, and stabilizer geometry are tightly linked.
```

### 5. `PhysicsSM/Draft/NullEdgeTwoTwistorHiddenChannelAristotle.lean` [twoTwistorPartialCoherence_det_eq_factor_mul_massInvariant]

Score: `0.761`

```text
theorem twoTwistorPartialCoherence_det_eq_factor_mul_massInvariant
    (k : Complex) (Z W : SpinorChartTwistor) :
    (twoTwistorPartialCoherenceMomentum k Z W).det =
      hiddenOverlapDetFactor k * twoTwistorMassInvariant Z W := by
  unfold twoTwistorPartialCoherenceMomentum twoTwistorMassInvariant
  unfold infinityTwistorPairing
  exact partialCoherenceMomentum_det_eq_overlap_factor_mul_plucker k Z.pi W.pi

/-- The full-coherence specialization is determinant-massless. -/
```

### 6. `PhysicsSM/Draft/Sedenions/CocycleQuadraticPhase.lean` [establishes]

Score: `0.760`

```text
/-
Copyright (c) 2026 PhysicsSM Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib

/-!
# Cocycle and Quadratic-Phase Extraction for Sedenions

This module formalizes the Cayley-Dickson sign function ω(a,b) for the
16-dimensional sedenion algebra and analyzes its restriction to the
zero-product plaquette complex.

## Convention

We use the recursive Cayley-Dickson convention documented in
`Sedenions/CayleyDickson_Convention.md`:

- Basis labels are 4-bit indices in `Fin 16`.
- Product index follows XOR: `e_a * e_b = ω(a,b) · e_{a ⊕ b}`.
- Signs are determined by the recursive Cayley-Dickson pair rule.

This convention differs from `PhysicsSM.Algebra.Octonion.Basic`; the two
must never be silently identified.

## Main definitions

- `cdMulBasis` : recursive Cayley-Dickson basis multiplication
- `omega` : ω : Fin 16 → Fin 16 → ℤ, the sedenion sign function
- `plaquetteOmegaProd` : four-fold ω-product on a mixed plaquette
- `isZeroProdSupport` : predicate for zero-product supports
- `sameStrutList` : the 63 same-strut mixed supports
- `zeroProdSupportList` : the 42 zero-product supports

## Main results

- `omega_values` : ω(a,b) ∈ {-1, 1}
- `cdMulIdx_eq_xor` : product index = bitwise XOR
- `omega_zero_left/right` : normalization at identity
- `omega_antisym` : ω(a,b) = -ω(b,a) for distinct nonzero a, b
- `omega_sq` : ω(a,b)² = 1
- `sameStrutList_length` : exactly 63 same-strut supports
- `zeroProdSupportList_length` : exactly 42 zero-product supports
- `extraStrutList_length` : exactly 21 extra same-strut supports
- `zeroProd_iff_linearPhase` : **main theorem** — a same-strut support is a
  zero-product support iff its four-fold ω-product = +1 (linear phase)
- `plaquetteOmegaProd_on_zeroProd` : ω-produc
```

### 7. `PhysicsSM/Draft/NullEdgeDecoherenceChannelAristotle.lean` [partialCoherenceMomentum_zero_det_eq_plucker]

Score: `0.760`

```text
theorem partialCoherenceMomentum_zero_det_eq_plucker
    (psi phi : CSpinor) :
    (partialCoherenceMomentum 0 psi phi).det =
      complexAbsSq (spinorWedge psi phi) := by
  rw [partialCoherenceMomentum_zero_eq_decohered,
    decoheredSpinorPairMomentum_det_eq_plucker]

/-- The partial-coherence formula specializes to zero mass at `k = 1`. -/
```

### 8. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Already proved or kernel-checked]

Score: `0.760`

```text
ther with the
  orthonormal-Gram reduction to the trusted Pluecker theorem, the rank-one
  internal coherence massless limit, and the two-state partial-coherence
  bridge. This is the strongest finite algebra currently supporting the
  flavor-overlap/Yukawa-hierarchy line.

- **Finite hidden-isometry invariance.**
  `PhysicsSM.Draft.NullEdgeTwoTwistorHiddenChannelAristotle` now proves that a
  finite column-isometric hidden-basis change preserves the visible reduced
  density of a hidden-labeled spinor family, and therefore preserves the
  twistor/Pluecker determinant-mass wrappers downstream.

- **Finite quantum-measure core.**
  `PhysicsSM.Draft.NullEdgeQuantumMeasureFiniteAristotle` now proves finite
  event-amplitude additivity, decoherence-functional additivity, the
  grade-2 quantum-measure sum rule for three disjoint events, strong
  positivity of the rank-one decoherence Gram form, and tensor-product
  closure on rectangular events.

- **Finite Dirac square-root core.**
  `PhysicsSM.Draft.NullEdgeDiracSlashCore` now proves the explicit static
  `(+---)` Weyl-block calculation: `det(p.sigma)` is the Minkowski scalar,
  `sigma(p) barSigma(p)` and `barSigma(p) sigma(p)` are that scalar times the
  identity, and the chiral `4 x 4` Dirac slash squares to the same scalar.
  This is the first kernel-checked operator-level square root of the program's
  determinant-mass spine.

- **Finite bundle Dirac-Pluecker bridge.**
  `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore` now composes the trusted
  `PhysicsSM.Spinor.PluckerMass.fin_bundle_plucker_mass_identity` with the
  static chiral Dirac slash. It extracts Weyl coordinates from the finite
  bundle momentum and proves
  `chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass`: the slash built from
  the bundle momentum squa
```

## Scoped paper hits

### 1. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.759`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 2. On Noncommutative and semi-Riemannian Geometry

Score: `0.738`
Zotero key: `F877GT5B`
arXiv: `math-ph/0110001`
DOI: `10.48550/arXiv.math-ph/0110001`
URL: https://arxiv.org/abs/math-ph/0110001

Abstract:

Introduces semi-Riemannian spectral triples using Krein spaces and Krein-selfadjoint Dirac operators, with recovery of signature data from spectral data.

### 3. An Argument for Strong Positivity of the Decoherence Functional

Score: `0.734`
Zotero key: `arxiv:2011.06120`
arXiv: `2011.06120`
URL: http://arxiv.org/abs/2011.06120

Abstract:

Argues that strong positivity is the correct physical positivity condition for path-integral/decoherence-functional quantum theory, via closure and maximality under tensor products.

### 4. Krein spectral triples and the fermionic action

Score: `0.733`
Zotero key: `PFAG59D4`
arXiv: `1505.01939`
DOI: `10.1007/s11040-016-9207-z`
URL: https://www.zotero.org/19894138/items/PFAG59D4

Abstract:

Motivated by the space of spinors on a Lorentzian manifold, we define Krein spectral triples, which generalise spectral triples from Hilbert spaces to Krein spaces. This Krein space approach allows for an improved formulation of the fermionic action for almost-commutative manifolds. We show by explicit calculation that this action functional recovers the correct Lagrangians for the cases of electrodynamics, the electro-weak theory, and the Standard Model. The description of these examples does not require a real structure, unless one includes Majorana masses, in which case the internal spaces also exhibit a Krein space structure.

### 5. An analysis of completely-positive trace-preserving maps on M2

Score: `0.726`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`
