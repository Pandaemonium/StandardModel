# Aristotle semantic context pack

Generated: 2026-07-16T21:21:53
Query: `corrected weighted difference form disjoint supports positive radial line constant negative shell three-dimensional negative definite Lorentzian inertia`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/marked-shell-conditional-inertia-aristotle-2026-07-16.md` [Proof idea]

Score: `0.789`

```text
## Proof idea

Expand the weighted difference form. Disjoint support makes every cross-term
summand zero. Positive weights and one nonzero time coordinate make the time
sum strictly positive. On the shell, the spatial quadratic form is minus the
positive scale times a finite sum of squares; difference-coordinate
independence supplies a nonzero square for every nonzero coefficient vector.
```

### 2. `AgentTasks/marked-shell-conditional-inertia-aristotle-2026-07-16.md` [Objective]

Score: `0.775`

```text
## Objective

Prove the exact algebraic `(+---)` split behind the marked-Alexandrov selector.
A nonzero time probe supported on positive weights must have positive corrected
norm. A difference-coordinate independent spatial triple supported on one
constant negative shell must be negative definite. Disjoint supports must make
the time-space cross block exactly zero.
```

### 3. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.80 Difference coordinates and a finite mostly-minus witness]

Score: `0.772`

```text
### 3.80 Difference coordinates and a finite mostly-minus witness

The corrected form admits a sharper basis-free reading. Fix a marked event
(x) and restrict to zero-sum probes. The map

\[
  f\longmapsto \bigl(f(y)-f(x)\bigr)_{y\ne x}
\]

is injective: if all based differences vanish, (f) is constant, and a constant
zero-sum probe is zero. In these intrinsic coordinates the corrected form is
diagonal, with entries exactly the signed causal row weights. Thus its inertia
is controlled by a concrete graph question: how many nonzero effective past
weights are positive and how many are negative?

`CorrectedPairingDifferenceCoordinates.lean` supplies two nonvacuity controls.
First, on five events it constructs four explicit zero-sum difference probes
forming a basis and a signed star row whose Gram matrix is exactly the project
matrix (\eta=\operatorname{diag}(1,-1,-1,-1)). Second, it realizes the required
sign pattern using the actual local causal-set coefficients. The concrete
order has

\[
  0\prec a\prec4,
  \qquad a\in\{1,2,3\},
\]

At the marked top (4), the four predecessor interval counts are
((3,0,0,0)). With the project-sign local operator the corresponding weights
are

\[
  (8s,-s,-s,-s),
  \qquad s=\frac{4}{\sqrt6\,\ell^2}>0
  \quad (\ell\ne0).
\]

The kernel-checked corrected-pairing Gram entries in the explicit difference
basis are therefore (4s,-s/2,-s/2,-s/2), with all off-diagonal entries zero.
This proves that the active local coefficient architecture can realize a
strict mostly-minus finite form; Lorentzian sign is not excluded by the
retarded no-go.

`CorrectedPairingCarrierInertiaWitness.lean` closes the finite normalization
step against the production carrier API. It transports the explicit basis
through the exact induced-order isomorphism into the act
```

### 4. `docs/DOCUMENT_MAP.md` [The null-edge program: core documents]

Score: `0.763`

```text
r normalized frames
  differ from it exactly by Lorentz transformations. The existence of such a
  frame is invariant under order isomorphism and implies nondegeneracy. Frame
  existence, Lorentzian inertia on physical carriers, mode convergence, and a
  smooth tetrad remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/RetardedProbeSupportGate.lean` - formalizes the
  order-only two-sided interior and retarded-shell architecture used by the A3
  intrinsic-probe support audit. Interval-band abundance, shell membership,
  shell cardinality, and qualitative visibility of every intrinsic probe
  subspace are exactly invariant under order isomorphism. Injective restriction
  to a shell gives `finrank P <= shell.card`, so fewer than four shell events
  kernel-checkably forbid a visible rank-four sector. A four-leaf, one-top
  order realizes the sharp rank-four/cardinality-four case. This necessary
  availability gate does not prove quantitative coverage, Lorentzian inertia,
  product quality, or continuum convergence. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/RetardedShellInfraredNoGo.lean` - explicit
  arbitrary-cardinality counterweight to the shell rank obstruction. For every
  `n`, a three-level finite strict order has `n` two-sided-interior shell
  sources in one fixed minimal interval-count band, with nonzero past/future
  abundance and zero intervening events to the mark. Hence shell cardinality
  can grow without any change in local interval count. Together with the A3c
  larger-diamond oracle, this rejects the global count shell as a locality
  certificate while preserving its necessary rank bound. [DRAFT-LEAN/ORACLE]
- `PhysicsSM/Draft/NullEdge/ProbeFrameWeylScaleBridge.lean` - proves that
  simultaneous rescaling of the active operator's discreteness and nonlocali
```

### 5. `PhysicsSM/Draft/NullEdge/CorrectedPairingDifferenceCoordinates.lean`

Score: `0.762`

```text
import PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator
import PhysicsSM.Draft.NullEdge.MinkowskiConvention

/-!
# Intrinsic difference coordinates for the corrected pairing

The corrected weighted-difference form is diagonal in the coordinates
`f(y) - f(x)` based at the marked event `x`.  On the zero-sum probe space these
coordinates are injective: a probe with every based difference zero is a
constant probe, and a constant zero-sum probe vanishes.

An explicit five-event control then supplies four zero-sum difference probes
whose Gram matrix is exactly the project's mostly-minus Minkowski matrix for
one signed star-weight row.  This proves that the corrected finite-difference
architecture can carry Lorentzian inertia without a supplied coordinate
frame.  It does not show that the active causal coefficients realize this
weight row, select such a five-event carrier under refinement, or produce a
stable spectral gap.

Claim grade: `M [orig/comp]`, finite algebra only.
-/
```

### 6. `PhysicsSM/Draft/NullEdge/CorrectedPairingDifferenceCoordinates.lean` [fiveEventDifferenceBasis]

Score: `0.761`

```text
def fiveEventDifferenceBasis :
    Module.Basis (Fin 4) Real (zeroSumFieldSubspace (Fin 5)) :=
  basisOfLinearIndependentOfCardEqFinrank
    fiveEventDifferenceProbe_linearIndependent (by
      norm_num [finrank_fiveEvent_zeroSum])

/-- **Lorentzian nonvacuity control.** In the explicit difference basis, the
signed weighted-difference form has Gram matrix exactly `diag(1,-1,-1,-1)`. -/
```

### 7. `NULL_EDGE_RESULTS.md` [2. The strongest result: the finite Plucker-mass theorem (TRUSTED)]

Score: `0.760`

```text
and `RankAreaMass.posDef_iff_det_pos` / related lemmas identify
  positive determinant with positive-definite finite momentum. These are
  kinematic support facts only; they do not establish the Delta binding defect,
  the carrier `D^#D|P = det P` bridge, or the S3/S4 interacting bridge.

Kernel-clean but still *draft* (need convention/semantic review before
promotion): **`SL(2,C)`/Lorentz invariance** of the determinant mass, the
**celestial moment form** `m^2 = (E^2 - |C|^2)/4` (energy monopole minus
momentum dipole), and the **static Dirac square root** that squares back to this
mass (the seam to the P2 operator program).

**Reading.** This makes the old "trapped, disagreeing light" / "mass without
mass" intuition exact and machine-checked: a finite bundle of null momenta has
invariant mass exactly to the extent its directions fail to align. Equivalently,
with `P = sum_i psi_i psi_i^dagger` and `rho = P / Tr(P)` after a chosen visible
normalization, the massless locus is the pure/projectively rank-one locus and
mass is the visible null-direction impurity. The invariant theorem remains
`det(P) = m^2`; normalized mixedness is the observer-conditioned `m/E` reading.
It is finite kinematics -- not a continuum Dirac limit, not a particle spectrum,
not QCD or Higgs dynamics.

---
```

### 8. `PhysicsSM/Draft/NullEdge/ProbeFrameLorentzGauge.lean` [isLorentzNormalized_change_iff]

Score: `0.759`

```text
theorem isLorentzNormalized_change_iff
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b c : CarrierProbeFrame A)
    (hb : IsLorentzNormalized A ell nonlocalityScale x b) :
    IsLorentzNormalized A ell nonlocalityScale x c ↔
      (b.toMatrix c)ᵀ *
          (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ) *
          b.toMatrix c = MinkowskiConvention.eta := by
  unfold IsLorentzNormalized at hb ⊢
  rw [← carrierProbeGram_change A ell nonlocalityScale x b c, hb]

/-- Lorentzian inertia implies nondegeneracy of the reconstructed carrier
bilinear form. -/
```

### 9. `AutonomousLab/state/LEDGER.md` [2026-07-16 16:04 -0700 - codex - lab_manager - GRAV-ORDER-OPERATOR-001]

Score: `0.759`

```text
## 2026-07-16 16:04 -0700 - codex - lab_manager - GRAV-ORDER-OPERATOR-001

- Leased PhysicsSM/Draft/NullEdge/CorrectedPairingDifferenceCoordinates.lean for 2 hours. Diagonalize the corrected weighted-difference form in intrinsic difference coordinates and isolate the Lorentzian sign gate
```

### 10. `PhysicsSM/Draft/NullEdge/RankFourCarrierProbeSector.lean` [IsSectorLorentzNormalized]

Score: `0.757`

```text
def IsSectorLorentzNormalized
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : SectorFrame P) : Prop :=
  sectorGram A P ell nonlocalityScale x b =
    (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ)

/-- Corrected Lorentzian-inertia gate on a selected rank-four sector. -/
```

### 11. `PhysicsSM/Draft/NullEdge/Goal3ExactRG.lean` [is]

Score: `0.756`

```text
* **(d) Conical dispersion `z = 1` [landed].** On the massless line the pinned
  Dirac dispersion is conical `ω = ±k` (mass shell `(k·σz)² = k²·1`), and the
  group velocity saturates the light cone (`v_g² = 1`), giving `z = 1`.
* **(c) Correlation exponent `ν = 1` [landed].** The linearization `dR` at the
  critical point `(lam, lam)` is `J = !![3,-4; 1,-2]`, with **relevant
  (mass-direction) eigenvalue exactly `2`** (eigenvector `(4,1)`, transverse to
  the critical tangent `(1,1)` which carries the marginal eigenvalue `-1`).  With
  rescale `b = 2` this is `b^{1/ν} = 2`, hence `ν = 1` as exact arithmetic.

Kernel-checked: no `sorry`/`admit`/`native_decide`/new `axiom`; every headline
theorem is pinned to footprint `[propext, Classical.choice, Quot.sound]`.
-/

import Mathlib

open Matrix
```

### 12. `PhysicsSM/Draft/NullEdge/CorrectedPairingCarrierInertiaWitness.lean` [fiveEventLorentzDiamond_hasLorentzianInertia]

Score: `0.756`

```text
theorem fiveEventLorentzDiamond_hasLorentzianInertia
    (ell : Real) (hell : ell ≠ 0) :
    HasLorentzianInertia fiveEventLorentzDiamond ell ell
      (carrierTop fiveEventLorentzDiamond) := by
  let s := sourceLocal4DPrefactor ell
  have hs : 0 < s := by
    dsimp [s, sourceLocal4DPrefactor]
    positivity
  let d : Fin 4 -> Real := fun i =>
    if i = 0 then Real.sqrt (4 * s) else Real.sqrt ((1 / 2 : Real) * s)
  have hd : forall i, d i ≠ 0 := by
    intro i
    dsimp [d]
    split_ifs
    · exact ne_of_gt (Real.sqrt_pos.2 (by nlinarith [hs]))
    · exact ne_of_gt (Real.sqrt_pos.2 (by nlinarith [hs]))
  let u : Fin 4 -> Units Real := fun i => (Units.mk0 (d i) (hd i))⁻¹
  refine ⟨fiveEventCarrierProbeBasis.unitsSMul u, ?_⟩
  unfold IsLorentzNormalized
  ext i j
  rw [carrierProbeGram_apply]
  simp only [Module.Basis.unitsSMul_apply, Units.smul_def]
  rw [← carrierProbeBilinForm_apply]
  rw [map_smul, map_smul, LinearMap.smul_apply]
  simp only [smul_eq_mul, carrierProbeBilinForm_apply]
  rw [fiveEventCarrierProbeBasis_gram ell hell i j]
  fin_cases i <;> fin_cases j <;>
    simp [u, d, s, MinkowskiConvention.eta]
  all_goals
    have hsqrt_s_ne : Real.sqrt (sourceLocal4DPrefactor ell) ≠ 0 :=
      ne_of_gt (Real.sqrt_pos.2 hs)
    have hsqrt_s_sq :
        Real.sqrt (sourceLocal4DPrefactor ell) *
            Real.sqrt (sourceLocal4DPrefactor ell) =
          sourceLocal4DPrefactor ell :=
      Real.mul_self_sqrt hs.le
    have hsqrt_two_sq : Real.sqrt (2 : Real) * Real.sqrt 2 = 2 :=
      Real.mul_self_sqrt (by norm_num)
    have hsqrt_four : Real.sqrt (4 : Real) = 2 := by norm_num
    try rw [hsqrt_four]
    field_simp [hsqrt_s_ne]
    nlinarith

end PhysicsSM.Draft.NullEdge.CorrectedPairingCarrierInertiaWitness

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.Null
```

## Scoped paper hits

### 1. On the definition of spacetimes in Noncommutative Geometry, part II

Score: `0.723`
Zotero key: `RADF3RUP`
arXiv: `1611.07842`
DOI: `10.48550/arXiv.1611.07842`
URL: https://arxiv.org/abs/1611.07842

Abstract:

Defines spectral spacetimes with time-orientation forms, stable causality, finite graph examples, split Dirac structures, and Lorentzian discretized Dirac operators.

### 2. Temporal Lorentzian Spectral Triples

Score: `0.723`
Zotero key: `JKDD4KGC`
arXiv: `1210.6575`
DOI: `10.48550/arXiv.1210.6575`
URL: https://arxiv.org/abs/1210.6575

Abstract:

Introduces temporal Lorentzian spectral triples, corresponding to a 3+1 decomposition and global time structure for noncommutative Lorentzian spaces.

### 3. Locality properties of Neuberger's lattice Dirac operator

Score: `0.717`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 4. Quantum Gravity Phenomenology, Lorentz Invariance and Discreteness

Score: `0.701`
Zotero key: `arxiv:gr-qc/0311055`
arXiv: `gr-qc/0311055`
DOI: `10.1142/S0217732304015026`
URL: http://arxiv.org/abs/gr-qc/0311055

Abstract:

Explains why causal-set discreteness need not break Lorentz invariance and discusses Lorentz-invariant diffusion of massive particles from an underlying causal set.

### 5. On the Dirac Theory of Spin 1/2 Particles and Its Non-Relativistic Limit

Score: `0.700`
Zotero key: `NFMI3A99`
DOI: `10.1103/physrev.78.29`
URL: https://doi.org/10.1103/physrev.78.29

### 6. Discrete physics and the Dirac equation

Score: `0.700`
Zotero key: `WBGEISNI`
arXiv: `hep-th/9603202`
DOI: `10.1016/0375-9601(96)00436-7`
URL: https://www.zotero.org/19894138/items/WBGEISNI

Abstract:

We rewrite the 1+1 Dirac equation in light cone coordinates in two significant forms, and solve them exactly using the classical calculus of finite differences. The complex form yields ``Feynman's Checkerboard''---a weighted sum over lattice paths. The rational, real form can also be interpreted in terms of bit-strings.
