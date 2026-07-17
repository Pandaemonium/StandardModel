import Mathlib

/-!
# Finite gauge-invariant radial FMS observable

This module isolates the finite algebra behind the scalar
Froehlich-Morchio-Strocchi expansion. For a complex unitary multiplet, the
physical local scalar candidate is the gauge-invariant radial observable

```text
O(H; H0) = ||H||^2 - ||H0||^2.
```

Writing `H = H0 + eta` gives the exact split

```text
O = 2 Re(H0^dagger eta) + ||eta||^2.
```

The module also proves the induced four-term finite connected-form
decomposition and transfers a finite elementary radial response kernel to its
leading gauge-invariant FMS kernel.

The radial coordinate used here is `eta = h * H0`, without normalizing `H0`.
Consequently `fmsRadialResidue` is the squared coefficient for that supplied
coordinate, not an LSZ residue or a convention-independent physical coupling.

Provenance: clean-room finite formalization oriented by Axel Maas,
"Observables in Higgsed Theories," arXiv:1410.2740, and Axel Maas and Rene
Sondenheimer, "Gauge-invariant description of the Higgs resonance and its
phenomenological implications," arXiv:2009.06671. The proof bodies were
completed by Aristotle task `a5cdc344-451e-4683-b3eb-1b06d4abe39a`. During
integration, two Boolean nonzero hypotheses were strengthened to the intended
proposition-level hypotheses and the returned proofs replayed unchanged.

No continuum limit, spectral measure, pole existence, perturbative hierarchy,
or observed Higgs mass is claimed. Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable

open scoped BigOperators ComplexConjugate

variable {N Omega V : Type*} [Fintype N] [Fintype Omega]

/-- Real part of the finite Hermitian pairing. -/
def realHermitianBilinear (left right : N -> Complex) : Real :=
  ∑ n, (star (left n) * right n).re

/-- Squared Hermitian norm of a finite complex multiplet vector. -/
def vectorNormSq (field : N -> Complex) : Real :=
  realHermitianBilinear field field

/-- Apply one internal unitary transformation. -/
def unitaryTransform [DecidableEq N]
    (g : Matrix.unitaryGroup N Complex) (field : N -> Complex) : N -> Complex :=
  Matrix.mulVec (g : Matrix N N Complex) field

/-- Gauge-invariant radial observable relative to a supplied vacuum norm. -/
def radialObservable (vacuumNormSq : Real) (field : N -> Complex) : Real :=
  vectorNormSq field - vacuumNormSq

/-- Linear term in the FMS radial expansion. -/
def linearRadialObservable (vacuum fluctuation : N -> Complex) : Real :=
  2 * realHermitianBilinear vacuum fluctuation

/-- Real radial fluctuation along a supplied, unnormalized vacuum direction. -/
def radialFluctuation (vacuum : N -> Complex) (h : Real) : N -> Complex :=
  fun n => (h : Complex) * vacuum n

/-- Unnormalized finite weighted expectation. -/
def weightedMean (weight : Omega -> Real) (observable : Omega -> Real) : Real :=
  ∑ omega, weight omega * observable omega

/-- Finite weighted connected-form expression. It is a connected correlator
when the supplied weights are normalized to unit total weight. -/
def weightedConnectedForm
    (weight : Omega -> Real) (left right : Omega -> Real) : Real :=
  weightedMean weight (fun omega => left omega * right omega) -
    weightedMean weight left * weightedMean weight right

/-- The real Hermitian bilinear is symmetric. -/
theorem realHermitianBilinear_symm (left right : N -> Complex) :
    realHermitianBilinear left right = realHermitianBilinear right left := by
  unfold realHermitianBilinear
  simp +decide [Complex.mul_re, mul_comm]

/-- A unitary transformation preserves the squared norm. -/
theorem vectorNormSq_unitary [DecidableEq N]
    (g : Matrix.unitaryGroup N Complex) (field : N -> Complex) :
    vectorNormSq (unitaryTransform g field) = vectorNormSq field := by
  have hUnitary : ∀ (g : Matrix N N Complex), g * star g = 1 ->
      ∀ field : N -> Complex,
        ∑ n, (star (Matrix.mulVec g field n) *
          Matrix.mulVec g field n).re =
        ∑ n, (star (field n) * field n).re := by
    intro g hg field
    have hInner : star (Matrix.mulVec g field) ⬝ᵥ Matrix.mulVec g field =
        star field ⬝ᵥ field := by
      have hStep : star (Matrix.mulVec g field) ⬝ᵥ Matrix.mulVec g field =
          star field ⬝ᵥ (star g * g).mulVec field := by
        simp +decide [Matrix.mulVec, dotProduct]
        simp +decide [Matrix.mul_apply, mul_assoc, mul_comm, mul_left_comm,
          Finset.mul_sum _ _ _, Finset.sum_mul]
        exact Finset.sum_comm.trans
          (Finset.sum_congr rfl fun _ _ => Finset.sum_comm)
      rw [hStep, mul_eq_one_comm.mp hg, Matrix.one_mulVec]
    convert congr_arg Complex.re hInner using 1 <;> simp +decide [dotProduct]
  exact hUnitary _ g.2.2 _

/-- A common unitary transformation preserves the full real bilinear. -/
theorem realHermitianBilinear_unitary [DecidableEq N]
    (g : Matrix.unitaryGroup N Complex) (left right : N -> Complex) :
    realHermitianBilinear (unitaryTransform g left)
        (unitaryTransform g right) =
      realHermitianBilinear left right := by
  unfold unitaryTransform realHermitianBilinear
  have hUnitary : ∀ u v : N -> Complex,
      (∑ n, star (u n) * v n) =
        ∑ n, star ((g.val.mulVec u) n) * (g.val.mulVec v) n := by
    intro u v
    have hMatrix : Matrix.conjTranspose (g : Matrix N N Complex) *
        (g : Matrix N N Complex) = 1 := g.2.1
    have hInner : star u ⬝ᵥ v =
        star (g.val.mulVec u) ⬝ᵥ g.val.mulVec v := by
      simp +decide [Matrix.dotProduct_mulVec]
      simp +decide [Matrix.star_mulVec, hMatrix]
    convert hInner using 1
  convert congr_arg Complex.re (hUnitary left right).symm using 1
  · rw [← Complex.re_sum]
  · simp +decide

/-- The radial observable is exactly invariant under internal unitary gauge
transformations. -/
theorem radialObservable_unitary [DecidableEq N]
    (g : Matrix.unitaryGroup N Complex) (vacuumNormSq : Real)
    (field : N -> Complex) :
    radialObservable vacuumNormSq (unitaryTransform g field) =
      radialObservable vacuumNormSq field := by
  unfold radialObservable
  rw [vectorNormSq_unitary]

/-- Exact pointwise FMS expansion around an arbitrary supplied vacuum. -/
theorem radialObservable_add_expansion
    (vacuum fluctuation : N -> Complex) :
    radialObservable (vectorNormSq vacuum) (vacuum + fluctuation) =
      linearRadialObservable vacuum fluctuation +
        vectorNormSq fluctuation := by
  unfold radialObservable linearRadialObservable vectorNormSq
    realHermitianBilinear
  simp +decide [Complex.add_re, mul_add, add_mul, mul_comm,
    Finset.mul_sum _ _ _, Finset.sum_add_distrib]
  simpa only [← Finset.sum_mul _ _ _] using by ring

/-- Weighted covariance is exactly additive in both observable slots. -/
theorem weightedConnectedForm_add_add
    (weight : Omega -> Real)
    (leftLinear leftQuadratic rightLinear rightQuadratic : Omega -> Real) :
    weightedConnectedForm weight (leftLinear + leftQuadratic)
        (rightLinear + rightQuadratic) =
      weightedConnectedForm weight leftLinear rightLinear +
        weightedConnectedForm weight leftLinear rightQuadratic +
        weightedConnectedForm weight leftQuadratic rightLinear +
        weightedConnectedForm weight leftQuadratic rightQuadratic := by
  unfold weightedConnectedForm weightedMean
  simp +decide [Finset.sum_add_distrib, mul_add, mul_comm, mul_left_comm,
    Finset.mul_sum _ _ _]
  ring

/-- Exact finite two-point FMS decomposition: leading-linear, two mixed, and
quadratic-quadratic connected terms. -/
theorem radialObservable_covariance_expansion
    (weight : Omega -> Real) (vacuum : N -> Complex)
    (leftFluctuation rightFluctuation : Omega -> N -> Complex) :
    weightedConnectedForm weight
        (fun omega => radialObservable (vectorNormSq vacuum)
          (vacuum + leftFluctuation omega))
        (fun omega => radialObservable (vectorNormSq vacuum)
          (vacuum + rightFluctuation omega)) =
      weightedConnectedForm weight
          (fun omega => linearRadialObservable vacuum (leftFluctuation omega))
          (fun omega => linearRadialObservable vacuum (rightFluctuation omega)) +
        weightedConnectedForm weight
          (fun omega => linearRadialObservable vacuum (leftFluctuation omega))
          (fun omega => vectorNormSq (rightFluctuation omega)) +
        weightedConnectedForm weight
          (fun omega => vectorNormSq (leftFluctuation omega))
          (fun omega => linearRadialObservable vacuum (rightFluctuation omega)) +
        weightedConnectedForm weight
          (fun omega => vectorNormSq (leftFluctuation omega))
          (fun omega => vectorNormSq (rightFluctuation omega)) := by
  convert weightedConnectedForm_add_add weight
    (fun omega => linearRadialObservable vacuum (leftFluctuation omega))
    (fun omega => vectorNormSq (leftFluctuation omega))
    (fun omega => linearRadialObservable vacuum (rightFluctuation omega))
    (fun omega => vectorNormSq (rightFluctuation omega)) using 1
  exact congr_arg₂ _
    (funext fun _ => radialObservable_add_expansion _ _)
    (funext fun _ => radialObservable_add_expansion _ _)

/-- Along the supplied real radial direction, the FMS linear term is a nonzero
scalar multiple of the radial coordinate whenever the vacuum norm is nonzero. -/
theorem linearRadialObservable_radialFluctuation
    (vacuum : N -> Complex) (h : Real) :
    linearRadialObservable vacuum (radialFluctuation vacuum h) =
      2 * vectorNormSq vacuum * h := by
  unfold linearRadialObservable vectorNormSq
  ring
  unfold realHermitianBilinear
  norm_num [Complex.ext_iff, radialFluctuation]
  ring
  rw [Finset.mul_sum _ _ _]
  exact Finset.sum_congr rfl fun _ _ => by ring

/-- Squared leading coefficient for the supplied unnormalized radial
coordinate. -/
def fmsRadialResidue (vacuum : N -> Complex) : Real :=
  (2 * vectorNormSq vacuum) ^ 2

/-- A propositionally nonzero vacuum gives a strictly positive leading radial
coefficient squared. -/
theorem fmsRadialResidue_pos
    (vacuum : N -> Complex) (hVacuum : vacuum ≠ 0) :
    0 < fmsRadialResidue vacuum := by
  contrapose! hVacuum
  simp_all +decide [fmsRadialResidue, vectorNormSq]
  simp_all +decide [funext_iff, realHermitianBilinear]
  exact fun n => by
    rw [Finset.sum_eq_zero_iff_of_nonneg fun _ _ =>
      add_nonneg (mul_self_nonneg _) (mul_self_nonneg _)] at hVacuum
    simp_all +decide [Complex.ext_iff, add_eq_zero_iff_of_nonneg,
      mul_self_nonneg]

/-- Leading gauge-invariant FMS response kernel. -/
def fmsLeadingKernel [Fintype V]
    (vacuum : N -> Complex) (kernel : Matrix V V Real) : Matrix V V Real :=
  fmsRadialResidue vacuum • kernel

/-- Multiplication by the positive FMS coefficient preserves every zero and
nonzero entry of a finite response kernel. -/
theorem fmsLeadingKernel_entry_eq_zero_iff
    [Fintype V] (vacuum : N -> Complex) (kernel : Matrix V V Real)
    (hVacuum : vacuum ≠ 0) (i j : V) :
    fmsLeadingKernel vacuum kernel i j = 0 <-> kernel i j = 0 := by
  simp [fmsLeadingKernel]
  exact fun h => absurd h (ne_of_gt (fmsRadialResidue_pos vacuum hVacuum))

/-- The leading FMS coefficient scales, but does not move, a finite resolvent
identity. -/
theorem fmsLeadingKernel_resolvent
    [Fintype V]
    (vacuum : N -> Complex) (operator kernel source : Matrix V V Real)
    (hResolvent : operator * kernel = source) :
    operator * fmsLeadingKernel vacuum kernel =
      fmsLeadingKernel vacuum source := by
  classical
  unfold fmsLeadingKernel
  rw [← hResolvent, Matrix.mul_smul]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable.radialObservable_add_expansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms radialObservable_add_expansion

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable.radialObservable_covariance_expansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms radialObservable_covariance_expansion

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable.fmsRadialResidue_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fmsRadialResidue_pos

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable.fmsLeadingKernel_resolvent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fmsLeadingKernel_resolvent

end PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable

end
