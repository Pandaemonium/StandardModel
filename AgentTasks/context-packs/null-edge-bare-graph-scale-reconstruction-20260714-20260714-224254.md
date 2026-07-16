# Aristotle semantic context pack

Generated: 2026-07-14T22:43:13
Query: `bare causal graph scale normalization density-calibrated counting volume unique positive four-dimensional conformal coframe factor`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean`

Score: `0.878`

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

Score: `0.858`

```text
def countCalibratedScale
    (density : Real) (n : Nat) (e : Coframe4) : Real :=
  calibratedConformalScale e (countingVolume density n)

/-- **Calibrated scale reconstruction.** A positive density, nonempty event
count, and nondegenerate representative coframe determine a unique positive
Weyl factor whose coframe volume equals calibrated counting volume. -/
```

### 3. `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean` [positive_conformalScale_unique]

Score: `0.843`

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

### 4. `AgentTasks/null-edge-bare-graph-scale-reconstruction-aristotle-2026-07-14.md` [Locked interpretation]

Score: `0.836`

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

### 5. `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean` [bareGraphScale_rescaling_ray]

Score: `0.833`

```text
theorem bareGraphScale_rescaling_ray
    [Nonempty V] (R : V -> V -> Prop) (s : V -> Real)
    (hs : GraphInvariant R s) (hpos : ∀ x, 0 < s x)
    (lambda : Real) (hlambda : 0 < lambda) (hne : lambda ≠ 1) :
    ∃ s' : V -> Real,
      GraphInvariant R s' ∧ (∀ x, 0 < s' x) ∧ s' ≠ s := by
  refine ⟨fun x => lambda * s x, graphInvariant_const_mul R s hs lambda,
    fun x => mul_pos hlambda (hpos x), ?_⟩
  intro heq
  let x : V := Classical.choice inferInstance
  have hx := congrFun heq x
  change lambda * s x = s x at hx
  have hsne : s x ≠ 0 := (hpos x).ne'
  apply hne
  apply mul_right_cancel₀ hsne
  simpa using hx

/-! ## Count-volume calibration -/

/-- Region volume inferred from event count at a specified positive density. -/
```

### 6. `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean` [calibratedConformalScale_pos]

Score: `0.829`

```text
theorem calibratedConformalScale_pos
    (e : Coframe4) (targetVolume : Real)
    (he : 0 < coframeVolume e) (htarget : 0 < targetVolume) :
    0 < calibratedConformalScale e targetVolume := by
  exact fourthRoot_pos (div_pos htarget he)

/-- The selected conformal factor reconstructs the target volume exactly. -/
```

### 7. `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean` [calibrated_count_fixes_positive_conformal_scale]

Score: `0.825`

```text
theorem calibrated_count_fixes_positive_conformal_scale
    (density : Real) (n : Nat) (e : Coframe4)
    (hdensity : 0 < density) (hn : 0 < n) (he : 0 < coframeVolume e) :
    let omega := countCalibratedScale density n e
    0 < omega ∧
      coframeVolume (conformalCoframe omega e) = countingVolume density n ∧
      ∀ omega' : Real, 0 < omega' ->
        coframeVolume (conformalCoframe omega' e) = countingVolume density n ->
        omega' = omega := by
  dsimp only
  have htarget : 0 < countingVolume density n :=
    countingVolume_pos hdensity hn
  refine ⟨calibratedConformalScale_pos e _ he htarget,
    calibratedConformalScale_reconstructs e _ he htarget, ?_⟩
  intro omega' homega' hvolume'
  exact positive_conformalScale_unique e _ omega' _
    he homega' (calibratedConformalScale_pos e _ he htarget)
    hvolume' (calibratedConformalScale_reconstructs e _ he htarget)

/-! ## Nonvacuity controls -/

/-- A two-vertex bare relation has a genuine positive rescaling family. -/
```

### 8. `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean` [calibratedConformalScale]

Score: `0.824`

```text
def calibratedConformalScale (e : Coframe4) (targetVolume : Real) : Real :=
  fourthRoot (targetVolume / coframeVolume e)

/-- Positive base and target volumes give a positive selected scale. -/
```

### 9. `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean` [coframeVolume_conformalCoframe]

Score: `0.821`

```text
theorem coframeVolume_conformalCoframe
    (omega : Real) (e : Coframe4) (homega : 0 ≤ omega) :
    coframeVolume (conformalCoframe omega e) =
      omega ^ 4 * coframeVolume e := by
  unfold coframeVolume conformalCoframe
  rw [Matrix.det_smul]
  simp [abs_mul, abs_pow, abs_of_nonneg homega]

/-- Positive conformal factor selected by a target/base volume ratio. -/
```

### 10. `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean` [bareGraphScale_nonvacuous_witness]

Score: `0.821`

```text
theorem bareGraphScale_nonvacuous_witness :
    ∃ s' : Fin 2 -> Real,
      GraphInvariant (fun _ _ : Fin 2 => True) s' ∧
      (∀ x, 0 < s' x) ∧
      s' ≠ (fun _ => 1) := by
  apply bareGraphScale_rescaling_ray
      (fun _ _ : Fin 2 => True) (fun _ => 1) (lambda := 2)
  · intro T _ x
    rfl
  · intro x
    norm_num
  · norm_num
  · norm_num

/-- Eight events represent different volumes at densities one and two. -/
```

### 11. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.2 The scale half]

Score: `0.820`

```text
### 3.2 The scale half

If

\[
  g_{\mu\nu}=\Omega^2\bar g_{\mu\nu}
\]

in \(d\) dimensions, then

\[
  \sqrt{|g|}\,d^dx=\Omega^d\sqrt{|\bar g|}\,d^dx.
\]

A local volume measure therefore fixes the missing conformal factor. In causal
set language, number can approximate volume,

\[
  N(R)\approx \rho\,\operatorname{Vol}(R),
\]

when a density \(\rho\) and a manifold approximation are supplied. This is the
content behind the useful slogan "order plus number equals geometry."

The scale recovery can be written exactly. Let \(\bar g\) be any representative
of the causally reconstructed conformal class in dimension \(d\), and suppose
the counting limit supplies a smooth positive measure \(d\mu\). Define

\[
  r(x)=\frac{d\mu}{d\operatorname{Vol}_{\bar g}}(x),
  \qquad
  \Omega(x)=r(x)^{1/d},
  \qquad
  g=\Omega^2\bar g.
\]

Then

\[
  d\operatorname{Vol}_{g}
    =\Omega^d d\operatorname{Vol}_{\bar g}
    =d\mu.
\]

The positive \(\Omega\) is unique. Thus, **T|H [interp]**, a recovered causal
relation plus a recovered smooth volume measure determines a unique Lorentzian
metric, provided the continuum causality and manifold-approximation hypotheses
hold. The hard null-edge problem is proving that its order and counts have
exactly such a joint limit.

For the null-edge program, two scale mechanisms are logically possible:

1. **counting scale:** event or interval counts reconstruct local volume;
2. **decoration scale:** the Gram data of a soldering coframe supplies local
   lengths and volume.

The framework must say whether these are equivalent, complementary, or
redundant. Using both independently would double-count scale. A serious
reconstruction theorem should prove that the decorated Gram volume agrees
asymptotically with the counting volume, or should select one as prim
```

### 12. `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean` [calibratedConformalScale_reconstructs]

Score: `0.818`

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

## Scoped paper hits

### 1. Local d'Alembertian for causal sets

Score: `0.754`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`

### 2. Charting causal set configuration space with graph observables

Score: `0.739`
Zotero key: `RC5XF8RD`
arXiv: `2605.27514`
URL: http://arxiv.org/abs/2605.27514v1

Abstract:

The configuration space of causal sets is vast. The authors investigate manifoldlike and non-manifoldlike causal-set classes, including classes expected to become manifoldlike after coarse graining, and find that link-degree distributions, symmetrized-Hasse-graph Laplacian spectra, and causal-interval abundance distinguish classes with relatively small fluctuations.

### 3. Space-time as a causal set

Score: `0.730`
Zotero key: `I8DJ26QC`
DOI: `10.1103/PhysRevLett.59.521`
URL: https://www.zotero.org/19894138/items/I8DJ26QC

### 4. Higher-order Laplacian renormalization

Score: `0.729`
Zotero key: `RA8QNNKW`
arXiv: `2401.11298`
DOI: `10.1038/s41567-025-02784-1`
URL: https://doi.org/10.1038/s41567-025-02784-1

### 5. Is the cosmological constant a nonlocal quantum residue of discreteness of the causal set type?

Score: `0.725`
Zotero key: `G3FT8BXC`
arXiv: `0710.1675`
URL: http://arxiv.org/abs/0710.1675v1

### 6. Quantum Field Theory On Causal Sets

Score: `0.723`
Zotero key: `arxiv:2306.04800`
arXiv: `2306.04800`
URL: http://arxiv.org/abs/2306.04800

Abstract:

Overview of matter QFT on fixed causal-set backgrounds, including Green functions, Sorkin-Johnston two-point functions, and fermion/interacting-theory directions.

### 7. The Scalar Curvature of a Causal Set

Score: `0.722`
Zotero key: `JUVWME9X`
arXiv: `1001.2725`
DOI: `10.1103/PhysRevLett.104.181301`
URL: https://www.zotero.org/19894138/items/JUVWME9X

Abstract:

A one parameter family of retarded linear operators on scalar fields on causal sets is introduced. When the causal set is well-approximated by 4 dimensional Minkowski spacetime, the operators are Lorentz invariant but nonlocal, are parametrised by the scale of the nonlocality and approximate the continuum scalar D'Alembertian, $\Box$, when acting on fields that vary slowly on the nonlocality scale. The same operators can be applied to scalar fields on causal sets which are well-approximated by curved spacetimes in which case they approximate $\Box - {{1/2}}R$ where $R$ is the Ricci scalar curvature. This can used to define an approximately local action functional for causal sets.

### 8. Implementing causality in the spin foam quantum geometry

Score: `0.718`
Zotero key: `UHBZSNE2`
arXiv: `gr-qc/0210064`
DOI: `10.1016/S0550-3213(03)00378-X`
URL: https://www.zotero.org/19894138/items/UHBZSNE2

Abstract:

We analyze the classical and quantum geometry of the Barrett–Crane spin foam model for four-dimensional quantum gravity, explaining why it has to be considering as a covariant realization of the projector operator onto physical quantum gravity states. We discuss how causality requirements can be consistently implemented in this framework, and construct causal transition amplitudes between quantum gravity states, i.e., realizing in the spin foam context the Feynman propagator between states. The resulting causal spin foam model can be seen as a path integral quantization of Lorentzian first order Regge calculus, and represents a link between several approaches to quantum gravity as canonical loop quantum gravity, sum-over-histories formulations, dynamical triangulations and causal sets. In particular, we show how the resulting model can be rephrased within the framework of quantum causal sets (or histories).
