import Mathlib

/-!
# Momentum-rescaling consistency (Opus, verified Aristotle 8c48fafa)

Follow-up to the MC6 normalization finding (the Fourier convention forces
-I/(2 pi), not -I). If the 2 pi is absorbed by rescaling momentum rather than
carried explicitly, this is the rule that keeps the other rungs consistent:
generator and exact norm scaling; substitution into the one-step estimate giving
C(lam ||G q'||); a precise NON-INVARIANCE theorem (strict monotonicity, nonzero
generator, lam != 1) - so the estimate is NOT invariant, it is rescaled; the exact
equivalence of momentum scaling and step-size scaling inside the exponential; and
the domain transformation |q_i| <= K <-> |q'_i| <= K/lam.

Practical rule: rescaling is legitimate PROVIDED every momentum-dependent constant
is rescaled by the same lam and the compact box shrinks to K/lam. Decide once at
the top of the ladder, not per rung.

Provenance: verified at the pinned toolchain from Aristotle project 8c48fafa.
Standard three axioms. Claim grade M. -/

open scoped BigOperators
open scoped Matrix.Norms.L2Operator

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace MomentumRescaling

abbrev M4 := Matrix (Fin 4) (Fin 4) ℂ
abbrev Momentum := Fin 4 → ℝ

/-- A generator which is linear in the (real) momentum coordinates. -/
noncomputable def generator (A : Fin 4 → M4) (q : Momentum) : M4 :=
  ∑ j, (q j) • A j

/-- A coordinate box in momentum space. -/
def InBox (K : ℝ) (q : Momentum) : Prop :=
  ∀ i, |q i| ≤ K

/-
Rescaling momentum rescales its linear generator.
-/
theorem generator_smul (A : Fin 4 → M4) (lam : ℝ) (q : Momentum) :
    generator A (lam • q) = lam • generator A q := by
  unfold generator;
  simp +decide [ Finset.smul_sum, smul_smul ]

/-
For positive scale, the scoped L2 operator norm scales by the same factor.
-/
theorem norm_generator_smul (A : Fin 4 → M4) (lam : ℝ) (hlam : 0 < lam)
    (q : Momentum) :
    ‖generator A (lam • q)‖ = lam * ‖generator A q‖ := by
  convert norm_smul_of_nonneg hlam.le ( generator A q ) using 1;
  exact congr_arg Norm.norm ( generator_smul A lam q )

/-
Exact compensation: rescaling momentum by `lam` is the same as rescaling the
step size by `lam` in the exponential.
-/
theorem exp_generator_smul (A : Fin 4 → M4) (lam eps : ℝ) (q : Momentum) :
    NormedSpace.exp ((eps : ℂ) • ((Complex.I : ℂ) • generator A (lam • q))) =
      NormedSpace.exp (((lam * eps : ℝ) : ℂ) • ((Complex.I : ℂ) • generator A q)) := by
  rw [ generator_smul ] ; norm_num [ mul_assoc, mul_comm, mul_left_comm, smul_smul ] ;
  convert rfl using 2 ; ext ; norm_num ; ring

/-
A one-step estimate remains true after substitution `q = lam • q'`, but its
momentum-dependent constant is evaluated at the rescaled norm. This exact
substitution does not require monotonicity, so the theorem is slightly stronger
than the version assuming a monotone error profile.
-/
theorem oneStep_rescaled
    (A : Fin 4 → M4) (W : ℝ → Momentum → M4) (C : ℝ → ℝ)
    (lam : ℝ) (hlam : 0 < lam)
    (hstep : ∀ (eps : ℝ) (q : Momentum),
      ‖W eps q - NormedSpace.exp ((eps : ℂ) • ((Complex.I : ℂ) • generator A q))‖ ≤
        C ‖generator A q‖ * eps ^ 2) :
    ∀ (eps : ℝ) (q' : Momentum),
      ‖W eps (lam • q') -
          NormedSpace.exp ((eps : ℂ) • ((Complex.I : ℂ) • generator A (lam • q')))‖ ≤
        C (lam * ‖generator A q'‖) * eps ^ 2 := by
  intros eps q'
  specialize hstep eps (lam • q');
  rwa [ norm_generator_smul A lam hlam q' ] at hstep

/-
For a monotone error profile, scaling momentum upward can only increase the
momentum-dependent constant.
-/
theorem rescaled_constant_mono
    (A : Fin 4 → M4) (C : ℝ → ℝ) (hC : Monotone C)
    (lam : ℝ) (hlam : 1 ≤ lam) (q : Momentum) :
    C ‖generator A q‖ ≤ C (lam * ‖generator A q‖) := by
  exact hC ( le_mul_of_one_le_left ( norm_nonneg _ ) hlam )

/-
With a strictly increasing profile and a nonzero generator, a nontrivial
positive momentum rescaling really changes the displayed one-step constant.
This is the precise form of “not invariant unless `lam = 1`”; monotonicity alone
would not suffice, since a monotone profile may be constant.
-/
theorem rescaled_constant_ne
    (A : Fin 4 → M4) (C : ℝ → ℝ) (hC : StrictMono C)
    (lam : ℝ) (hlam1 : lam ≠ 1) (q : Momentum)
    (hq : ‖generator A q‖ ≠ 0) :
    C (lam * ‖generator A q‖) ≠ C ‖generator A q‖ := by
  exact hC.injective.ne ( by aesop )

/-
A box `|qᵢ| ≤ K` pulls back under `q = lam • q'` to the box
`|q'ᵢ| ≤ K / lam`.
-/
theorem inBox_smul_iff (lam K : ℝ) (hlam : 0 < lam) (q : Momentum) :
    InBox K (lam • q) ↔ InBox (K / lam) q := by
  simp [InBox]
  field_simp
  simp only [abs_of_pos hlam, mul_comm]

/-
Precise consistency statement for the momentum-rescaling repair: both the
one-step estimate and its compact momentum domain transform with the same
positive scale `lam`.
-/
theorem rescaling_consequence
    (A : Fin 4 → M4) (W : ℝ → Momentum → M4) (C : ℝ → ℝ)
    (lam K : ℝ) (hlam : 0 < lam)
    (hstep : ∀ (eps : ℝ) (q : Momentum),
      ‖W eps q - NormedSpace.exp ((eps : ℂ) • ((Complex.I : ℂ) • generator A q))‖ ≤
        C ‖generator A q‖ * eps ^ 2) :
    (∀ (eps : ℝ) (q' : Momentum),
      ‖W eps (lam • q') -
          NormedSpace.exp ((eps : ℂ) • ((Complex.I : ℂ) • generator A (lam • q')))‖ ≤
        C (lam * ‖generator A q'‖) * eps ^ 2) ∧
      (∀ q' : Momentum, InBox K (lam • q') ↔ InBox (K / lam) q') := by
  convert oneStep_rescaled A W C lam hlam hstep using 1;
  exact ⟨ fun h => h.1, fun h => ⟨ h, fun q' => inBox_smul_iff lam K hlam q' ⟩ ⟩

end MomentumRescaling
