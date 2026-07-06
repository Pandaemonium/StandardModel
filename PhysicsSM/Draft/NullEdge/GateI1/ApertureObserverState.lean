import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
import PhysicsSM.Draft.NullEdge.GateI1.ApertureEntropy
import PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge

/-!
# Gate I1 / NE-U1c: aperture observer state — mass as observer-conditioned aperture

Capstone reading of the null-edge "mass = aging / observer-conditioned aperture"
picture at **finite grade**, built on

* `CompositeApertureMass` — the keystone kinematic identity
  `M² = minkowskiSq (∑ pᵢ) = ∑_{i,j} minkDot pᵢ pⱼ ≥ 0`, `= 0 ↔ collinear`;
* `ApertureEntropy` — the energy-normalized null-direction distribution
  `wᵢ = (energy of pᵢ)/E` (`dirWeight`) and its Shannon entropy
  `H = ∑ᵢ negMulLog wᵢ` (`apertureEntropy`);
* `PluckerSpinorBridge` — `det (twoEdgeMomentum ψ φ) = |spinorWedge ψ φ|²`, hence
  `massless ↔ spinorWedge = 0 ↔ collinear spinors`.

## What is built here

### Rest frame = maximally-mixed direction state

* `IsUniformEnergy` / `IsMaximallyMixed` — the equal-energy (uniform weight)
  configuration; `maximallyMixed_iff_uniformEnergy` shows they coincide. This is
  the observer-conditioned **rest frame** in the information reading.
* `apertureEntropy_le_log_card` — `H ≤ log N` (`N = |s|`): the direction spread
  is bounded by the fully-mixed value.
* `apertureEntropy_eq_log_card_iff_maximallyMixed` — `H = log N` **iff** the
  state is maximally mixed (equal energies): the maximum-entropy direction state
  is exactly the rest frame.
* `apertureEntropy_uniform_lt` / `massive_entropy_strictlyBetween` — for a
  massive, non-uniform composite the entropy sits **strictly** between `0`
  (single direction, massless) and `log N` (fully mixed).

### Massless boundary ⟺ zero entropy ⟺ spinor wedge

* `massless_of_apertureEntropy_eq_zero` — zero entropy (pure/single-direction
  state) ⟹ massless.
* `spinorMomentum` and `twoSpinor_massless_iff_wedge` — the two-null-momentum
  composite assembled from two Weyl spinors is massless **iff** the spinor wedge
  vanishes, tying `CompositeApertureMass` masslessness to `PluckerSpinorBridge`.
* `massless_with_positive_entropy` — the **honest boundary**: the converse
  fails. Two *collinear* future-null constituents with split energy are massless
  yet carry positive entropy. So "massless ⟺ zero entropy" is a genuine *finite
  information identity on the null-direction distribution* — one implication plus
  the two clean boundaries — **not** a thermodynamic equivalence.

### Mass monotone in spread at fixed energy

* `massSq_eq_energySq_sub_spatialMomSq` — `M² = E² − |P⃗|²`.
* `spatialMomSq_le_energySq` / `massSq_nonneg` — `0 ≤ M² ≤ E²`.
* `massSq_antitone_in_alignment` — at fixed total energy `E`, `M²` is antitone in
  the spatial-momentum alignment `|P⃗|²`: **more aperture (less alignment) = more
  mass at fixed energy**.

## Claim discipline (NULLSTRAND / NERD)

**Honest label: finite information-theoretic identity on the null-direction
distribution.** Everything is a combinatorial statement about a finite
probability vector `wᵢ` and Minkowski bilinear algebra; `E`, `wᵢ`, `H` and the
"rest frame" are *frame-dependent* (energy is not Lorentz-invariant). No
ensemble, temperature, coarse-graining, arrow of time, or thermodynamics is
invoked. In particular the massless/zero-entropy link is strictly one-directional
(`massless_with_positive_entropy` witnesses the converse failure).

## Proof status

No `sorry` / `axiom` / `native_decide`. Depends on the three companion modules
and Mathlib.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.GateI1.ApertureObserverState

open PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
open PhysicsSM.Draft.NullEdge.GateI1.ApertureEntropy

/-- For a future-null momentum, energy squared equals spatial-momentum squared:
`(p 0)^2 = (p 1)^2 + (p 2)^2 + (p 3)^2` (from `IsNull p`, i.e. `minkowskiSq p = 0`
with the `(+,-,-,-)` signature). -/
theorem futureNull_energy_sq (p : Momentum4) (h : IsFutureNull p) :
    (p 0) ^ 2 = (p 1) ^ 2 + (p 2) ^ 2 + (p 3) ^ 2 := by
  have hnull : minkowskiSq p = 0 := h.1
  unfold minkowskiSq at hnull
  linarith

variable {ι : Type*}

/-! ## The rest frame as the maximally-mixed direction state -/

/-- The **uniform-energy** configuration: all constituents carry the same energy.
In the information reading this is the observer-conditioned **rest frame**. -/
def IsUniformEnergy (s : Finset ι) (p : ι → Momentum4) : Prop :=
  ∀ i ∈ s, ∀ j ∈ s, p i 0 = p j 0

/-- The **maximally-mixed** direction state: every direction weight equals
`1/N`, the fully-mixed value. -/
def IsMaximallyMixed (s : Finset ι) (p : ι → Momentum4) : Prop :=
  ∀ i ∈ s, dirWeight s p i = (s.card : ℝ)⁻¹

/-- **Maximally mixed = equal energies.** The uniform direction distribution is
exactly the equal-energy (rest-frame) configuration. -/
theorem maximallyMixed_iff_uniformEnergy (s : Finset ι) (p : ι → Momentum4)
    (hs : s.Nonempty) (htot : 0 < totalEnergy s p) :
    IsMaximallyMixed s p ↔ IsUniformEnergy s p := by
  have hcard : (0:ℝ) < s.card := by exact_mod_cast Finset.card_pos.mpr hs
  have hcardne : (s.card : ℝ) ≠ 0 := ne_of_gt hcard
  constructor
  · intro hmix i hi j hj
    have hi' := hmix i hi
    have hj' := hmix j hj
    unfold dirWeight at hi' hj'
    rw [div_eq_iff (ne_of_gt htot)] at hi' hj'
    rw [hi', hj']
  · intro huni i hi
    unfold dirWeight
    have hsum : totalEnergy s p = s.card * p i 0 := by
      unfold totalEnergy
      rw [Finset.sum_congr rfl (fun j hj => huni j hj i hi), Finset.sum_const, nsmul_eq_mul]
    have hpi : p i 0 ≠ 0 := by
      rintro h; rw [h, mul_zero] at hsum; rw [hsum] at htot; exact lt_irrefl 0 htot
    rw [hsum]
    field_simp

/-! ## Entropy upper bound and the maximum-entropy (rest-frame) state -/

/-- Per-term bound underlying the maximum-entropy inequality: for a weight
`w ∈ [0,1]` and `N > 0`, `negMulLog w ≤ w·log N + (1/N − w)`. -/
theorem negMulLog_le_uniform_term (w N : ℝ) (hw : 0 ≤ w) (hN : 0 < N) :
    Real.negMulLog w ≤ w * Real.log N + (1 / N - w) := by
  rcases eq_or_lt_of_le hw with h | hwpos
  · simp [Real.negMulLog, ← h]; positivity
  · have hlog : Real.log (1 / (w * N)) ≤ 1 / (w * N) - 1 :=
      Real.log_le_sub_one_of_pos (by positivity)
    rw [Real.negMulLog]
    have hlog2 : Real.log (1 / (w * N)) = -(Real.log w + Real.log N) := by
      rw [one_div, Real.log_inv, Real.log_mul (ne_of_gt hwpos) (ne_of_gt hN)]
    rw [hlog2] at hlog
    have hkey : w * (Real.log w + Real.log N) ≥ w - 1 / N := by
      have hml := mul_le_mul_of_nonneg_left hlog hw
      rw [mul_sub] at hml
      have hwN : w * (1 / (w * N)) = 1 / N := by field_simp
      nlinarith [hml, hwN]
    nlinarith [hkey]

/-- Equality in the per-term bound holds **iff** `w = 1/N`. -/
theorem negMulLog_uniform_term_eq_iff (w N : ℝ) (hw : 0 ≤ w) (hN : 0 < N) :
    Real.negMulLog w = w * Real.log N + (1 / N - w) ↔ w = 1 / N := by
  constructor
  · intro heq
    rcases eq_or_lt_of_le hw with h | hwpos
    · exfalso
      rw [← h] at heq
      simp [Real.negMulLog] at heq
      have : (0:ℝ) < 1 / N := by positivity
      linarith [heq]
    · by_contra hne
      have hwN1 : w * N ≠ 1 := by
        intro hh; apply hne; field_simp; linarith [hh]
      have hlog : Real.log (1 / (w * N)) < 1 / (w * N) - 1 :=
        Real.log_lt_sub_one_of_pos (by positivity) (by
          intro hh; apply hwN1; field_simp at hh ⊢; linarith [hh])
      have hlog2 : Real.log (1 / (w * N)) = -(Real.log w + Real.log N) := by
        rw [one_div, Real.log_inv, Real.log_mul (ne_of_gt hwpos) (ne_of_gt hN)]
      rw [hlog2] at hlog
      have hml := mul_lt_mul_of_pos_left hlog hwpos
      rw [mul_sub] at hml
      have hwN : w * (1 / (w * N)) = 1 / N := by field_simp
      rw [Real.negMulLog] at heq
      nlinarith [hml, hwN, heq]
  · intro heq
    subst heq
    rw [Real.negMulLog]
    rw [one_div, Real.log_inv]
    field_simp
    ring

/-- **Maximum-entropy inequality.** The aperture entropy of a probability vector
of `N` weights is at most `log N`. -/
theorem apertureEntropy_le_log_card (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) (htot : 0 < totalEnergy s p)
    (hs : s.Nonempty) :
    apertureEntropy s p ≤ Real.log s.card := by
  have hcard : (0:ℝ) < s.card := by exact_mod_cast Finset.card_pos.mpr hs
  have hcardne : (s.card:ℝ) ≠ 0 := ne_of_gt hcard
  unfold apertureEntropy
  have hb : ∀ i ∈ s, Real.negMulLog (dirWeight s p i)
      ≤ dirWeight s p i * Real.log s.card + (1 / s.card - dirWeight s p i) :=
    fun i hi => negMulLog_le_uniform_term _ _ (dirWeight_nonneg s p hnull htot hi) hcard
  calc ∑ i ∈ s, Real.negMulLog (dirWeight s p i)
      ≤ ∑ i ∈ s, (dirWeight s p i * Real.log s.card + (1 / s.card - dirWeight s p i)) :=
        Finset.sum_le_sum hb
    _ = Real.log s.card := by
        rw [Finset.sum_add_distrib, ← Finset.sum_mul, dirWeight_sum_one s p htot,
          Finset.sum_sub_distrib, Finset.sum_const, dirWeight_sum_one s p htot, nsmul_eq_mul]
        rw [mul_one_div, div_self hcardne]; ring

/-- **The maximum-entropy direction state is the rest frame.** Entropy attains
its maximum `log N` exactly at the maximally-mixed (equal-energy) state. -/
theorem apertureEntropy_eq_log_card_iff_maximallyMixed (s : Finset ι)
    (p : ι → Momentum4) (hnull : ∀ i ∈ s, IsFutureNull (p i))
    (htot : 0 < totalEnergy s p) (hs : s.Nonempty) :
    apertureEntropy s p = Real.log s.card ↔ IsMaximallyMixed s p := by
  have hcard : (0:ℝ) < s.card := by exact_mod_cast Finset.card_pos.mpr hs
  have hcardne : (s.card:ℝ) ≠ 0 := ne_of_gt hcard
  have hb : ∀ i ∈ s, Real.negMulLog (dirWeight s p i)
      ≤ dirWeight s p i * Real.log s.card + (1 / s.card - dirWeight s p i) :=
    fun i hi => negMulLog_le_uniform_term _ _ (dirWeight_nonneg s p hnull htot hi) hcard
  have hsumRHS : ∑ i ∈ s, (dirWeight s p i * Real.log s.card + (1 / s.card - dirWeight s p i))
      = Real.log s.card := by
    rw [Finset.sum_add_distrib, ← Finset.sum_mul, dirWeight_sum_one s p htot,
      Finset.sum_sub_distrib, Finset.sum_const, dirWeight_sum_one s p htot, nsmul_eq_mul]
    rw [mul_one_div, div_self hcardne]; ring
  unfold apertureEntropy IsMaximallyMixed
  constructor
  · intro hEq i hi
    have h2 : ∑ i ∈ s, Real.negMulLog (dirWeight s p i)
        = ∑ i ∈ s, (dirWeight s p i * Real.log s.card + (1 / s.card - dirWeight s p i)) := by
      rw [hEq, hsumRHS]
    have h3 := (Finset.sum_eq_sum_iff_of_le hb).mp h2 i hi
    have hval := (negMulLog_uniform_term_eq_iff _ _
      (dirWeight_nonneg s p hnull htot hi) hcard).mp h3
    rw [hval, one_div]
  · intro hmix
    have h3 : ∀ i ∈ s, Real.negMulLog (dirWeight s p i)
        = dirWeight s p i * Real.log s.card + (1 / s.card - dirWeight s p i) := by
      intro i hi
      rw [(negMulLog_uniform_term_eq_iff _ _ (dirWeight_nonneg s p hnull htot hi) hcard).mpr]
      rw [hmix i hi, one_div]
    rw [Finset.sum_congr rfl h3, hsumRHS]

/-- The rest frame (equal energies) realizes the maximal spread `H = log N`. -/
theorem apertureEntropy_eq_log_card_of_uniformEnergy (s : Finset ι)
    (p : ι → Momentum4) (hnull : ∀ i ∈ s, IsFutureNull (p i))
    (htot : 0 < totalEnergy s p) (hs : s.Nonempty)
    (huni : IsUniformEnergy s p) :
    apertureEntropy s p = Real.log s.card :=
  (apertureEntropy_eq_log_card_iff_maximallyMixed s p hnull htot hs).mpr
    ((maximallyMixed_iff_uniformEnergy s p hs htot).mpr huni)

/-- **A massive, non-maximally-mixed composite has entropy strictly between the
massless value `0` and the fully-mixed value `log N`.** -/
theorem massive_entropy_strictlyBetween (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i))
    (hpos : 0 < minkowskiSq (∑ i ∈ s, p i))
    (hs : s.Nonempty) (hmix : ¬ IsMaximallyMixed s p) :
    0 < apertureEntropy s p ∧ apertureEntropy s p < Real.log s.card := by
  have htot := totalEnergy_pos_of_massive s p hnull hpos
  refine ⟨apertureEntropy_pos_of_massive s p hnull hpos, ?_⟩
  have hle := apertureEntropy_le_log_card s p hnull htot hs
  have hne : apertureEntropy s p ≠ Real.log s.card := fun h =>
    hmix ((apertureEntropy_eq_log_card_iff_maximallyMixed s p hnull htot hs).mp h)
  exact lt_of_le_of_ne hle hne

/-! ## Massless boundary ⟺ zero entropy ⟺ spinor wedge -/

/-- **Zero entropy (pure/single-direction state) ⟹ massless.** The entropy-side
statement of the massless boundary. -/
theorem massless_of_apertureEntropy_eq_zero (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) (htot : 0 < totalEnergy s p)
    (hH : apertureEntropy s p = 0) :
    minkowskiSq (∑ i ∈ s, p i) = 0 :=
  concentrated_imp_massless s p hnull htot
    ((apertureEntropy_eq_zero_iff_concentrated s p hnull htot).mp hH)

/-- The `CompositeApertureMass` Minkowski square agrees with the
`PluckerSpinorBridge` one (identical definitions). -/
theorem minkowskiSq_eq_bridge (p : Momentum4) :
    minkowskiSq p = PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.minkowskiSq p :=
  rfl

/-- The future-null four-momentum carried by a single Weyl spinor
`λ ↦ momentumOfHerm2 (λ λ†)`. -/
noncomputable def spinorMomentum
    (lam : PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.CSpinor) : Momentum4 :=
  PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.momentumOfHerm2
    (PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.plueckerMatrix lam)

/-- `momentumOfHerm2` is additive on `2×2` blocks. -/
theorem momentumOfHerm2_add
    (A B : PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.Mat2) :
    PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.momentumOfHerm2 (A + B)
      = PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.momentumOfHerm2 A
        + PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.momentumOfHerm2 B := by
  funext k
  fin_cases k <;>
    simp [PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.momentumOfHerm2,
      Matrix.add_apply, Complex.add_re, Complex.add_im] <;> ring

/-- The spinor four-momentum is future-null. -/
theorem spinorMomentum_isFutureNull
    (lam : PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.CSpinor) :
    IsFutureNull (spinorMomentum lam) := by
  refine ⟨?_, ?_⟩
  · show minkowskiSq (spinorMomentum lam) = 0
    rw [minkowskiSq_eq_bridge]
    have hcomplex :
        (PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.minkowskiSq
          (spinorMomentum lam) : ℂ) = 0 := by
      rw [← PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.det_minkHerm_eq_minkowskiSq]
      unfold spinorMomentum
      rw [PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.minkHerm_momentumOfHerm2 _
        (PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.plueckerMatrix_isHermitian lam)]
      exact PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.det_plueckerMatrix_eq_zero lam
    exact_mod_cast hcomplex
  · show 0 ≤ (spinorMomentum lam) 0
    have h : (spinorMomentum lam) 0
        = (((PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.plueckerMatrix lam) 0 0).re
            + ((PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.plueckerMatrix lam) 1 1).re) / 2 :=
      rfl
    rw [h]
    have key : ∀ z : ℂ, 0 ≤ (z * star z).re := by
      intro z; rw [Complex.star_def, Complex.mul_conj]; simp [Complex.normSq_nonneg]
    have e0 : (PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.plueckerMatrix lam) 0 0
        = lam 0 * star (lam 0) := by
      simp [PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.plueckerMatrix, Matrix.vecMulVec]
    have e1 : (PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.plueckerMatrix lam) 1 1
        = lam 1 * star (lam 1) := by
      simp [PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.plueckerMatrix, Matrix.vecMulVec]
    rw [e0, e1]
    have k0 := key (lam 0); have k1 := key (lam 1)
    linarith

/-- **Two-spinor massless boundary ⟺ spinor wedge.** The composite of the two
future-null momenta built from Weyl spinors `ψ, φ` is massless exactly when the
spinor wedge vanishes. This ties `CompositeApertureMass` masslessness to
`PluckerSpinorBridge`. -/
theorem twoSpinor_massless_iff_wedge
    (psi phi : PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.CSpinor) :
    minkowskiSq (∑ i : Fin 2, ![spinorMomentum psi, spinorMomentum phi] i) = 0
      ↔ PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.spinorWedge psi phi = 0 := by
  have hsum : (∑ i : Fin 2, ![spinorMomentum psi, spinorMomentum phi] i)
      = PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.momentumOfHerm2
          (PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.twoEdgeMomentum psi phi) := by
    rw [Fin.sum_univ_two]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one]
    unfold spinorMomentum
    rw [← momentumOfHerm2_add]
    rfl
  rw [hsum, minkowskiSq_eq_bridge]
  exact PhysicsSM.Draft.NullEdge.GateI1.PluckerSpinorBridge.massless_iff_wedge_zero psi phi

/-- **The honest boundary: the converse fails.** There exist two *collinear*
future-null constituents (split energy along one null direction) whose composite
is massless yet whose direction-spread entropy is strictly positive. Hence
"massless ⟺ zero entropy" is a one-directional finite information identity, not a
thermodynamic equivalence. -/
theorem massless_with_positive_entropy :
    ∃ p : Fin 2 → Momentum4, (∀ i, IsFutureNull (p i)) ∧
      minkowskiSq (∑ i : Fin 2, p i) = 0 ∧
      0 < apertureEntropy (Finset.univ : Finset (Fin 2)) p := by
  refine ⟨fun _ => ![1, 1, 0, 0], ?_, ?_, ?_⟩
  · intro i
    refine ⟨?_, ?_⟩
    · show minkowskiSq _ = 0
      unfold minkowskiSq; simp [Matrix.cons_val]
    · simp
  · have hsum : (∑ i : Fin 2, (fun _ => (![1, 1, 0, 0] : Momentum4)) i) = ![2, 2, 0, 0] := by
      funext k; fin_cases k <;> simp [Matrix.cons_val]
    rw [hsum]; unfold minkowskiSq; simp [Matrix.cons_val]
  · have htot : totalEnergy (Finset.univ : Finset (Fin 2))
        (fun _ => (![1, 1, 0, 0] : Momentum4)) = 2 := by
      unfold totalEnergy; simp
    unfold apertureEntropy dirWeight
    rw [Fin.sum_univ_two, htot]
    simp only [Matrix.cons_val]
    norm_num
    rw [Real.negMulLog]
    have h2 : Real.log (2⁻¹) < 0 := by rw [Real.log_inv]; simp [Real.log_pos]
    nlinarith [h2]

/-! ## Mass monotone in direction spread at fixed energy -/

/-- The squared magnitude of the total spatial momentum `|P⃗|²`. -/
def spatialMomSq (s : Finset ι) (p : ι → Momentum4) : ℝ :=
  (∑ i ∈ s, p i 1) ^ 2 + (∑ i ∈ s, p i 2) ^ 2 + (∑ i ∈ s, p i 3) ^ 2

/-- **Energy/aperture split of the mass.** `M² = E² − |P⃗|²`. -/
theorem massSq_eq_energySq_sub_spatialMomSq (s : Finset ι) (p : ι → Momentum4) :
    minkowskiSq (∑ i ∈ s, p i) = (totalEnergy s p) ^ 2 - spatialMomSq s p := by
  unfold minkowskiSq totalEnergy spatialMomSq
  simp only [Finset.sum_apply]
  ring

/-
The spatial-momentum alignment is bounded by the total energy squared.
-/
theorem spatialMomSq_le_energySq (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    spatialMomSq s p ≤ (totalEnergy s p) ^ 2 := by
  classical
  induction s using Finset.induction with
  | empty => simp [spatialMomSq, totalEnergy]
  | insert i s hi ih =>
    have hnull' : ∀ j ∈ s, IsFutureNull (p j) :=
      fun j hj => hnull j (Finset.mem_insert_of_mem hj)
    have hnulli : IsFutureNull (p i) := hnull i (Finset.mem_insert_self i s)
    have h_null : (p i 0) ^ 2 = (p i 1) ^ 2 + (p i 2) ^ 2 + (p i 3) ^ 2 :=
      futureNull_energy_sq _ hnulli
    have hEs : 0 ≤ ∑ j ∈ s, p j 0 := Finset.sum_nonneg fun j hj => (hnull' j hj).2
    have ih' := ih hnull'
    simp only [spatialMomSq, totalEnergy, Finset.sum_insert hi] at ih' ⊢
    nlinarith [ih', hEs, hnulli.2, h_null,
      sq_nonneg (p i 1 * ∑ j ∈ s, p j 2 - p i 2 * ∑ j ∈ s, p j 1),
      sq_nonneg (p i 1 * ∑ j ∈ s, p j 3 - p i 3 * ∑ j ∈ s, p j 1),
      sq_nonneg (p i 2 * ∑ j ∈ s, p j 3 - p i 3 * ∑ j ∈ s, p j 2),
      mul_nonneg hnulli.2 hEs]

/-- The composite mass squared is nonnegative. -/
theorem massSq_nonneg (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    0 ≤ minkowskiSq (∑ i ∈ s, p i) := by
  rw [massSq_eq_energySq_sub_spatialMomSq]
  have := spatialMomSq_le_energySq s p hnull
  linarith

/-- **More aperture = more mass at fixed energy.** At a fixed total energy, the
composite mass squared is antitone in the spatial-momentum alignment `|P⃗|²`:
less alignment (more direction spread) yields more mass. -/
theorem massSq_antitone_in_alignment (s : Finset ι) (p q : ι → Momentum4)
    (hE : totalEnergy s p = totalEnergy s q)
    (halign : spatialMomSq s p ≤ spatialMomSq s q) :
    minkowskiSq (∑ i ∈ s, q i) ≤ minkowskiSq (∑ i ∈ s, p i) := by
  rw [massSq_eq_energySq_sub_spatialMomSq, massSq_eq_energySq_sub_spatialMomSq, hE]
  linarith

end PhysicsSM.Draft.NullEdge.GateI1.ApertureObserverState
