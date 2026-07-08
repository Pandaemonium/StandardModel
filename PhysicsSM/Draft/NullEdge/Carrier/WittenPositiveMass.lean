/-
# Finite Witten / Lichnerowicz positivity for the soldering (gravity) channel

Proof job (Aristotle). Roadmap item **F4**: a finite analogue of the
Lichnerowicz–Weitzenböck argument at the heart of Witten's positive-energy
theorem, giving the gravity-shaped E-channel (manuscript §7) its first genuine
positivity + rigidity theorem.

Setup (Mathlib-only). Finite-dimensional complex inner product spaces `H`, `K`.
`A : H ->L[C] K` is the covariant gradient (the soldering derivative); `C : H
->L[C] H` is a self-adjoint, positive-semidefinite "curvature" term (the finite
dominant-energy condition, `0 <= <v, C v>`). The Weitzenböck operator square is
`S := (adjoint A) * A + C` (spelled here with composition `∘L`, since `adjoint A`
maps `K → H` and `A` maps `H → K`, so the honest endomorphism is `adjoint A ∘L A`
plus `C`). In Witten's proof, `<v, S v>` is a boundary (ADM mass) term for a
harmonic spinor; the dominant energy condition makes the curvature term
nonnegative, so the mass is nonnegative, and vanishes iff the spinor is
covariantly constant. The finite images:

## Targets (prove kernel-clean, no `sorry`)

- **W-psd:** for all `v : H`, `0 <= (inner (v) (S v)).re`, i.e. `S` is positive-
  semidefinite (`0 <= ‖A v‖^2 + (inner v (C v)).re`).
- **W-selfadjoint:** `S` is self-adjoint (`IsSelfAdjoint S`), given `C` self-adjoint.
- **W-vanish (Lichnerowicz rigidity, the headline):** the mass form vanishes iff
  the spinor is BOTH covariantly constant AND curvature-annihilated:
  `(inner v (S v)).re = 0  <->  A v = 0  ∧  C v = 0`.
- **W-kernel:** `S v = 0 <-> A v = 0 ∧ C v = 0` (kernel form of the same statement).

The `C v = 0` clause (not just `<v,Cv> = 0`) is the load-bearing rigidity content:
since `C` is self-adjoint and PSD, `(inner v (C v)).re = 0 <-> C v = 0`
(`AllMassWitten.psd_re_inner_eq_zero_iff`), and `‖A v‖^2 = 0 <-> A v = 0`.
-/

import Mathlib

/-!
PROJECT PROVENANCE (landed 2026-07-08). Roadmap item **F4**; Aristotle round-3
job `70ab0730-421f-46e8-a2ff-1c349d920c2c`, re-checked under the pinned toolchain.
The finite Witten / Lichnerowicz positivity + rigidity theorem for the
gravity-shaped E-channel (§7): the Weitzenbock square `S = AᴴA + C` (`C` a
positive-semidefinite finite dominant-energy curvature) is PSD, and the mass
form vanishes iff the spinor is covariantly constant AND curvature-null
(`A v = 0 ∧ C v = 0`) - §7's first GR-shaped positivity theorem.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.WittenPositiveMass

open ContinuousLinearMap RCLike
open scoped ComplexConjugate

variable {H K : Type*}
  [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
  [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K]

/-- The finite Weitzenböck operator square `S := adjoint A ∘L A + C`. -/
noncomputable def weitzenbock (A : H →L[ℂ] K) (C : H →L[ℂ] H) : H →L[ℂ] H :=
  adjoint A ∘L A + C

@[simp] theorem weitzenbock_apply (A : H →L[ℂ] K) (C : H →L[ℂ] H) (v : H) :
    weitzenbock A C v = adjoint A (A v) + C v := rfl

/-
The mass form of `S` splits as gradient-energy plus curvature-energy:
`(inner v (S v)).re = ‖A v‖^2 + (inner v (C v)).re`.
-/
theorem re_inner_weitzenbock (A : H →L[ℂ] K) (C : H →L[ℂ] H) (v : H) :
    (inner ℂ v (weitzenbock A C v)).re = ‖A v‖ ^ 2 + (inner ℂ v (C v)).re := by
  have := ContinuousLinearMap.adjoint_inner_right A v ( A v ) ; norm_num at this;
  simp_all +decide [ Complex.ext_iff, sq ]

/-
**Rigidity upgrade.** For a self-adjoint, PSD operator `C`, the curvature
energy `(inner v (C v)).re` vanishes iff `C v = 0` itself. This is the
load-bearing step of the Lichnerowicz vanishing theorem.
-/
theorem psd_re_inner_eq_zero_iff (C : H →L[ℂ] H) (hCsa : IsSelfAdjoint C)
    (hCpsd : ∀ v, 0 ≤ (inner ℂ v (C v)).re) (v : H) :
    (inner ℂ v (C v)).re = 0 ↔ C v = 0 := by
  refine ⟨fun h => ?_, fun h => by simp [h]⟩
  -- For every `t : ℝ` and `w : H`, PSD applied to `v + t • w` gives a nonnegative
  -- quadratic in `t` whose constant term is `(inner ℂ v (C v)).re = 0`.
  have h_expand : ∀ t : ℝ, ∀ w : H,
      0 ≤ t ^ 2 * (inner ℂ w (C w)).re + 2 * t * (inner ℂ w (C v)).re := by
    intro t w
    specialize hCpsd (v + t • w)
    have := hCsa.adjoint_eq
    simp_all
    have := ContinuousLinearMap.adjoint_inner_right C w v
    simp_all
    convert hCpsd using 1; ring
    rw [← inner_conj_symm, Complex.conj_re]; ring
  -- Nonnegativity of the quadratic for all `t` forces the linear coefficient to vanish.
  have h_linear_coeff_zero : ∀ w : H, (inner ℂ w (C v)).re = 0 := by
    intro w
    contrapose! h_expand
    refine ⟨-(inner ℂ w (C v)).re / ((inner ℂ w (C w)).re + 1), w, ?_⟩
    nlinarith [mul_div_cancel₀ (-(inner ℂ w (C v)).re)
        (show (inner ℂ w (C w)).re + 1 ≠ 0 from by linarith [hCpsd w]),
      hCpsd w, mul_self_pos.2 h_expand]
  -- Replacing `w` by `Complex.I • w` extracts the imaginary part as well.
  have h_imaginary_part_zero : ∀ w : H, (inner ℂ w (C v)).im = 0 := by
    intro w; specialize h_linear_coeff_zero (Complex.I • w); simp_all
  exact ext_inner_left ℂ fun w => by
    simpa [Complex.ext_iff] using And.intro (h_linear_coeff_zero w) (h_imaginary_part_zero w)

/-
**W-psd.** The Weitzenböck square is positive-semidefinite: the finite
positive-mass inequality under the dominant-energy condition on `C`.
-/
theorem weitzenbock_re_inner_nonneg (A : H →L[ℂ] K) (C : H →L[ℂ] H)
    (hCpsd : ∀ v, 0 ≤ (inner ℂ v (C v)).re) (v : H) :
    0 ≤ (inner ℂ v (weitzenbock A C v)).re := by
  convert add_nonneg ( sq_nonneg ( ‖A v‖ ) ) ( hCpsd v ) using 1 ; rw [ re_inner_weitzenbock ]

/-
**W-selfadjoint.** The Weitzenböck square is self-adjoint whenever `C` is.
-/
theorem weitzenbock_isSelfAdjoint (A : H →L[ℂ] K) (C : H →L[ℂ] H)
    (hCsa : IsSelfAdjoint C) : IsSelfAdjoint (weitzenbock A C) := by
  convert IsSelfAdjoint.add _ hCsa;
  ext;
  simp +decide [ star, ContinuousLinearMap.comp_apply ]

/-
**W-vanish (headline).** The mass form vanishes iff the spinor is both
covariantly constant (`A v = 0`) and curvature-annihilated (`C v = 0`).
-/
theorem weitzenbock_re_inner_eq_zero_iff (A : H →L[ℂ] K) (C : H →L[ℂ] H)
    (hCsa : IsSelfAdjoint C) (hCpsd : ∀ v, 0 ≤ (inner ℂ v (C v)).re) (v : H) :
    (inner ℂ v (weitzenbock A C v)).re = 0 ↔ A v = 0 ∧ C v = 0 := by
  rw [re_inner_weitzenbock]
  constructor
  · intro h
    refine ⟨norm_eq_zero.mp (by nlinarith [hCpsd v]), ?_⟩
    exact (psd_re_inner_eq_zero_iff C hCsa hCpsd v).1 (by nlinarith [hCpsd v])
  · aesop

/-
**W-kernel.** Kernel form of the vanishing theorem: `S v = 0` iff both
`A v = 0` and `C v = 0`.
-/
theorem weitzenbock_eq_zero_iff (A : H →L[ℂ] K) (C : H →L[ℂ] H)
    (hCsa : IsSelfAdjoint C) (hCpsd : ∀ v, 0 ≤ (inner ℂ v (C v)).re) (v : H) :
    weitzenbock A C v = 0 ↔ A v = 0 ∧ C v = 0 := by
  refine ⟨fun h => ?_, fun h => ?_⟩
  · refine (weitzenbock_re_inner_eq_zero_iff A C hCsa hCpsd v).mp ?_
    aesop
  · unfold weitzenbock; aesop

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WittenPositiveMass.weitzenbock_re_inner_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weitzenbock_re_inner_nonneg

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WittenPositiveMass.weitzenbock_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weitzenbock_eq_zero_iff

end PhysicsSM.Draft.NullEdge.Carrier.WittenPositiveMass
