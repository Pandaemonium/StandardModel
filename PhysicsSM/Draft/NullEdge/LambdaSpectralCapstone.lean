import Mathlib
import PhysicsSM.Draft.NullEdge.LambdaUnimodular
import PhysicsSM.Draft.NullEdge.LambdaEdgeCount
import PhysicsSM.Draft.NullEdge.SpectralActionAvatar
import PhysicsSM.Draft.NullEdge.HolographicEdgeBound

open scoped BigOperators
open Matrix

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# The finite Lambda / spectral / count capstone

This file composes four already-landed finite avatars into a single honest capstone:

* `LambdaUnimodular` — the finite unimodular trade: the order-`0` (`tr 1`) coefficient
  of the finite spectral action is blind to all dynamics, and vacuum shifts are gauge on
  a fixed-count surface;
* `LambdaEdgeCount` — the pierced-null-edge count `N` and the everpresent scaling: given
  the Poisson discreteness input `deltaN² = N`, the normalized Lambda fluctuation has
  second moment `1 / N` and RMS magnitude `1 / sqrt N`;
* `SpectralActionAvatar` — the finite spectral-action avatar whose single functional
  yields BOTH a gravity (order-2) and a matter (order-4) term, with *nonzero* higher-order
  dynamical contributions;
* `HolographicEdgeBound` — the finite holographic witness: the physical sector is bounded
  by the boundary null-edge count.

The capstone asserts only the following finite facts:

1. **Channel-blindness of order-0 / gauge vacuum shifts.**  The order-`0` count term is
   invariant under every deformation of the dynamical operator, and shifting the vacuum
   coefficient on a fixed-count surface changes the action only by a state-independent
   constant.
2. **Poisson scaling.**  Given `deltaN² = N`, the normalized Lambda fluctuation has second
   moment `1 / N` and RMS `1 / sqrt N`.
3. **Nonzero dynamical contrast.**  The order-`0` blindness is *not* a fake "all terms are
   blind" statement: the same finite spectral-action avatar has strictly nonzero
   higher-order (order-2 and order-4) dynamical contributions.
4. **Finite holographic bound.**  The physical sector is bounded by the boundary edge count.

Honest scope: every claim is a finite, rational statement; nothing here derives continuum
unimodular gravity, the value of `Λ`, or the real covariant entropy bound.  See the docstrings
of the imported modules and `ARISTOTLE_SUMMARY.md`.
-/

namespace LambdaSpectralCapstone

/-! ## The composed capstone -/

/-- **`lambda_count_spectral_capstone`.**  The four landed finite verdicts hold
simultaneously:

* the finite unimodular verdict (order-0 blindness + gauge vacuum shifts + field equation);
* the finite spectral-action avatar's one-functional verdict (gravity and matter sectors);
* the everpresent Lambda scaling at the concrete edge count `N = 100`
  (`deltaN = 10`, second moment `1/100`, RMS `1/10`);
* the finite holographic edge bound (`dim Phys = 2 ≤ 3 = B`). -/
theorem lambda_count_spectral_capstone :
    ((∀ (Aop : LambdaUnimodular.Mat), Aop.IsSymm → ∀ (c : ℚ) (x : LambdaUnimodular.Vec),
          x ≠ 0 →
          (LambdaUnimodular.Stationary Aop c x ↔
            ∃ Λ : ℚ, Aop *ᵥ x + c • x = Λ • x)) ∧
        (∀ (Aop : LambdaUnimodular.Mat) (c δ v0 : ℚ) (x : LambdaUnimodular.Vec),
          LambdaUnimodular.Vol x = v0 →
          LambdaUnimodular.S Aop (c + δ) x = LambdaUnimodular.S Aop c x + δ * v0) ∧
        (∀ (Aop : LambdaUnimodular.Mat) (c δ Λ : ℚ) (x : LambdaUnimodular.Vec),
          Aop *ᵥ x + c • x = Λ • x →
          Aop *ᵥ x + (c + δ) • x = (Λ + δ) • x) ∧
        (∀ (a0 : ℚ) (D P : LambdaUnimodular.Mat),
          LambdaUnimodular.order0Term a0 (D + P) = LambdaUnimodular.order0Term a0 D) ∧
        Matrix.trace (1 : LambdaUnimodular.Mat) = (LambdaUnimodular.n : ℚ) ∧
        (LambdaUnimodular.Stationary LambdaUnimodular.A 0 (![0, 1, 0] : LambdaUnimodular.Vec) ∧
          LambdaUnimodular.Vol (![0, 1, 0] : LambdaUnimodular.Vec) = 1 ∧
          LambdaUnimodular.A *ᵥ (![0, 1, 0] : LambdaUnimodular.Vec) + (0 : ℚ) • ![0, 1, 0]
            = (2 : ℚ) • ![0, 1, 0] ∧
          LambdaUnimodular.A *ᵥ (![0, 1, 0] : LambdaUnimodular.Vec) + (0 + 5 : ℚ) • ![0, 1, 0]
            = (2 + 5 : ℚ) • ![0, 1, 0] ∧
          ¬ LambdaUnimodular.Stationary LambdaUnimodular.A 0
              (![1, 1, 0] : LambdaUnimodular.Vec)))
      ∧ (SpectralActionAvatar.S 1 1 1 2 1 3 5 = 166 ∧
          ((SpectralActionAvatar.D 2 1 3 5 ^ 2).trace - 6 = 8 ∧ (8 : ℚ) ≠ 0) ∧
          ((SpectralActionAvatar.D 2 1 3 5 ^ 4).trace
              - (SpectralActionAvatar.D 2 0 0 0 ^ 4).trace = 60 ∧ (60 : ℚ) ≠ 0) ∧
          (SpectralActionAvatar.D 3 1 3 5 ^ 2).trace
            ≠ (SpectralActionAvatar.D 2 1 3 5 ^ 2).trace ∧
          (SpectralActionAvatar.D 2 7 8 9 ^ 2).trace
            = (SpectralActionAvatar.D 2 1 3 5 ^ 2).trace ∧
          (SpectralActionAvatar.D 2 1 3 6 ^ 4).trace
            ≠ (SpectralActionAvatar.D 2 1 3 5 ^ 4).trace)
      ∧ ((LambdaEdgeCount.lambdaOf 10 100) ^ 2 = 1 / 100 ∧
          Real.sqrt ((100 : ℝ) / (100 : ℝ) ^ 2) = 1 / Real.sqrt (100 : ℝ))
      ∧ (Module.finrank ℚ HolographicEdgeBound.Phys = 2 ∧ HolographicEdgeBound.edges = 3 ∧
          0 < Module.finrank ℚ HolographicEdgeBound.Phys ∧ 0 < HolographicEdgeBound.edges ∧
          Module.finrank ℚ HolographicEdgeBound.Phys ≤ HolographicEdgeBound.edges) := by
  refine ⟨LambdaUnimodular.unimodular_verdict,
    SpectralActionAvatar.one_functional_verdict,
    LambdaEdgeCount.everpresent_verdict 10 100 100 (by norm_num) (by norm_num)
      LambdaEdgeCount.nondeg_poisson_N100,
    HolographicEdgeBound.holographic_bound_numeric⟩

/-! ## Order-0 blindness is genuine, not "all terms are blind" -/

/-- **`order0_blind_but_higher_order_not_blind`.**  The order-`0` count term is
channel-blind — invariant under every deformation `D → D + P` of the dynamical operator —
yet the higher-order terms genuinely see the dynamics:

* the order-`2` coefficient `tr(A²)` differs from `tr(0)` (Lambda-unimodular avatar);
* in the spectral-action avatar the order-`2` (gravity) contribution is the nonzero rational
  `8`, and the order-`4` (matter) contribution is the nonzero rational `60`.

So order-`0` blindness is a real, non-vacuous separation of orders. -/
theorem order0_blind_but_higher_order_not_blind :
    (∀ (a0 : ℚ) (D P : LambdaUnimodular.Mat),
        LambdaUnimodular.order0Term a0 (D + P)
          = LambdaUnimodular.order0Term a0 D)
      ∧ (Matrix.trace (LambdaUnimodular.A * LambdaUnimodular.A)
          ≠ Matrix.trace ((0 : LambdaUnimodular.Mat) * (0 : LambdaUnimodular.Mat)))
      ∧ ((SpectralActionAvatar.D 2 1 3 5 ^ 2).trace - 6 = 8 ∧ (8 : ℚ) ≠ 0)
      ∧ (((SpectralActionAvatar.D 2 1 3 5 ^ 4).trace
            - (SpectralActionAvatar.D 2 0 0 0 ^ 4).trace = 60)
          ∧ (60 : ℚ) ≠ 0) := by
  obtain ⟨_, hgrav, hmatter, _, _, _⟩ := SpectralActionAvatar.one_functional_verdict
  exact ⟨LambdaUnimodular.trace_channel_blind,
    LambdaUnimodular.a2_term_not_blind, hgrav, hmatter⟩

/-! ## Boundary / count non-vacuity at `N = 100` -/

/-- **`lambda_n100_boundary_nonvacuity`.**  The concrete non-degeneracy witnesses at edge
count `N = 100` together with the boundary controls:

* the normalized Lambda fluctuation at `N = 100` has second moment `1/100` and RMS `1/10`;
* the pierced-edge count is extensive (`5 = 3 + 2`) with nonzero component counts;
* the holographic entropy/area law `S ≤ A` holds and the interior is genuinely not
  boundary-determined (the reconstruction property is a real property of the physical
  sector, not of all interior states). -/
theorem lambda_n100_boundary_nonvacuity :
    (LambdaEdgeCount.lambdaOf 10 100) ^ 2 = 1 / 100
      ∧ Real.sqrt ((100 : ℝ) / 100 ^ 2) = 1 / 10
      ∧ (LambdaEdgeCount.edgeCount (({0, 1, 2} : Finset ℕ) ∪ {3, 4})
          = LambdaEdgeCount.edgeCount ({0, 1, 2} : Finset ℕ)
            + LambdaEdgeCount.edgeCount ({3, 4} : Finset ℕ))
      ∧ (LambdaEdgeCount.edgeCount ({0, 1, 2} : Finset ℕ) = 3
          ∧ LambdaEdgeCount.edgeCount ({3, 4} : Finset ℕ) = 2)
      ∧ HolographicEdgeBound.entropy ≤ HolographicEdgeBound.area
      ∧ (HolographicEdgeBound.interiorState ≠ 0
          ∧ HolographicEdgeBound.R HolographicEdgeBound.interiorState = 0
          ∧ HolographicEdgeBound.interiorState ∉ HolographicEdgeBound.Phys) :=
  ⟨LambdaEdgeCount.nondeg_secondMoment_N100,
    LambdaEdgeCount.nondeg_rms_N100,
    LambdaEdgeCount.nondeg_extensive,
    LambdaEdgeCount.nondeg_counts,
    HolographicEdgeBound.entropy_area_form,
    HolographicEdgeBound.interior_not_boundary_determined⟩

/-! ## Kernel-footprint guard (guard-pin pattern) -/

/-- info: 'LambdaSpectralCapstone.lambda_count_spectral_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lambda_count_spectral_capstone

/-- info: 'LambdaSpectralCapstone.order0_blind_but_higher_order_not_blind' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms order0_blind_but_higher_order_not_blind

/-- info: 'LambdaSpectralCapstone.lambda_n100_boundary_nonvacuity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lambda_n100_boundary_nonvacuity

end LambdaSpectralCapstone
