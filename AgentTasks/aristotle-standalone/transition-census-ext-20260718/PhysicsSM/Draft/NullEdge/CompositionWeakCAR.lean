import PhysicsSM.Draft.NullEdge.CompositionWeakLadders
import PhysicsSM.Draft.NullEdge.DixonWeakLadders
import Mathlib

/-!
# The eq-31 weak CAR, assembled algebraically on the Dixon algebra

**Status: DRAFT (item-2 endgame assembly). Built ONLY from landed kernel cores
plus small helper lemmas - no deep coordinate re-expansion.**

`CompositionWeakLadders` landed the colour cores as global kernel identities;
`DixonAlgebra` landed the `H`-unit Clifford structure. This module lifts the
colour composition operators slot-wise to the Dixon algebra `C(x)H(x)O`,
defines the faithful eq-30 weak ladders as OPERATORS (CORRECTION 6:
`beta_1 = (1/2)(-i_2 + i i_1 tau_3)`, `beta_2 = omega‡ i i_1`, all products =
composition), and derives the eq-31 CAR structure:

* GLOBAL like/cross relations: `{betaHat_1, betaHat_2} = 0`,
  `{betaHat_1, betaHat_2‡} = 0`, `betaHat_2^2 = 0`, `(betaHat_2‡)^2 = 0`
  (+ the daggered mirrors).
* GLOBAL structural diagonals: `{betaHat_1, betaHat_1‡} = (1/2)(id + M)` and
  `{betaHat_2, betaHat_2‡} = M`, where `M = lift(P_0 + P_1)` is the lifted
  omega-mode anticommutator `hatOmega hatOmegaDag + hatOmegaDag hatOmega`.
* IDEAL restriction: `M = id` on the omega-mode plane (`M v = v`, `M nu = nu`,
  kernel), so ON THE IDEAL all of eq 31 holds with `{beta_i, beta_j‡} =
  delta_ij` - Furey's CAR, faithfully.

The `H`-mult and colour-op layers commute (proved below), so every proof is
rewriting + the landed cores; the only new kernel computations are shallow
(single `H`-mult expansions and the two mode-plane literals).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionWeakCAR

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.DixonWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakLadders
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem)

set_option maxHeartbeats 1000000
set_option maxRecDepth 8000

/-! ## The slot-wise colour lift and the H-multiplications -/

/-- Slot-wise lift of a colour endomorphism to the Dixon algebra. -/
def co (g : ComplexOctonion → ComplexOctonion) (d : Dixon) : Dixon :=
  ⟨g d.x0, g d.x1, g d.x2, g d.x3⟩

@[simp] theorem co_x0 (g : ComplexOctonion → ComplexOctonion) (d : Dixon) :
    (co g d).x0 = g d.x0 := rfl
@[simp] theorem co_x1 (g : ComplexOctonion → ComplexOctonion) (d : Dixon) :
    (co g d).x1 = g d.x1 := rfl
@[simp] theorem co_x2 (g : ComplexOctonion → ComplexOctonion) (d : Dixon) :
    (co g d).x2 = g d.x2 := rfl
@[simp] theorem co_x3 (g : ComplexOctonion → ComplexOctonion) (d : Dixon) :
    (co g d).x3 = g d.x3 := rfl

/-- Right multiplication by the `H`-unit `i_1`. -/
def R1 (d : Dixon) : Dixon := d * i1
/-- Right multiplication by the `H`-unit `i_2`. -/
def R2 (d : Dixon) : Dixon := d * i2

/-! Local `ComplexOctonion` unit/annihilator simp lemmas (the `DixonAlgebra`
copies are `private`). -/
@[local simp] private theorem cmo (x : ComplexOctonion) : x * 1 = x := by
  ext <;> simp
@[local simp] private theorem com (x : ComplexOctonion) : 1 * x = x := by
  ext <;> simp
@[local simp] private theorem cmz (x : ComplexOctonion) : x * 0 = 0 := by
  ext <;> simp
@[local simp] private theorem czm (x : ComplexOctonion) : (0 : ComplexOctonion) * x = 0 := by
  ext <;> simp

/-- The slot form of `R1` (kernel; the Hamilton right-`i_1` slot permutation
with signs). -/
theorem R1_slots (d : Dixon) : R1 d = ⟨-d.x1, d.x0, d.x3, -d.x2⟩ := by
  unfold R1
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp [i1, mul]

/-- The slot form of `R2`. -/
theorem R2_slots (d : Dixon) : R2 d = ⟨-d.x2, -d.x3, d.x0, d.x1⟩ := by
  unfold R2
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp [i2, mul]

/-! ## Helper kernel lemmas (shallow: single H-mult layer) -/

/-- `R1` squares to minus the identity (`i_1^2 = -1` acting from the right). -/
theorem R1_R1 (d : Dixon) : R1 (R1 d) = -d := by
  rw [R1_slots, R1_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp

/-- `R2` squares to minus the identity. -/
theorem R2_R2 (d : Dixon) : R2 (R2 d) = -d := by
  rw [R2_slots, R2_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp

/-- The right `H`-mults anticommute (`{i_1, i_2} = 0` from the right). -/
theorem R1_R2_anticomm (d : Dixon) : R1 (R2 d) + R2 (R1 d) = 0 := by
  rw [R1_slots, R2_slots, R2_slots, R1_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp

/-- A colour lift commutes with `R1` provided the colour map respects `0` and
negation. -/
theorem co_comm_R1 (g : ComplexOctonion → ComplexOctonion)
    (hneg : ∀ x, g (-x) = -g x) (d : Dixon) :
    co g (R1 d) = R1 (co g d) := by
  rw [R1_slots, R1_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp [co, hneg]

/-- A colour lift commutes with `R2` provided the colour map respects `0` and
negation. -/
theorem co_comm_R2 (g : ComplexOctonion → ComplexOctonion)
    (hneg : ∀ x, g (-x) = -g x) (d : Dixon) :
    co g (R2 d) = R2 (co g d) := by
  rw [R2_slots, R2_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp [co, hneg]

set_option maxHeartbeats 16000000 in
/-- `hatOmega` respects negation (depth-3 coordinate check). -/
theorem hatOmega_neg (x : ComplexOctonion) : hatOmega (-x) = -hatOmega x := by
  unfold hatOmega
  ext <;>
    simp [alpha1, alpha2, alpha3, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

set_option maxHeartbeats 16000000 in
/-- `hatOmegaDag` respects negation. -/
theorem hatOmegaDag_neg (x : ComplexOctonion) :
    hatOmegaDag (-x) = -hatOmegaDag x := by
  unfold hatOmegaDag
  ext <;>
    simp [alpha1_dag, alpha2_dag, alpha3_dag, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- `hatTau3` respects negation - ALGEBRAIC from the shallow lemmas (never
expand `hatTau3` coordinates: depth 12 defeats the elaborator). -/
theorem hatTau3_neg (x : ComplexOctonion) : hatTau3 (-x) = -hatTau3 x := by
  unfold hatTau3
  rw [hatOmegaDag_neg, hatOmega_neg, hatOmega_neg, hatOmegaDag_neg]
  abel

/-! ## Additivity / smul layer (all shallow kernel) -/

theorem R1_add (a b : Dixon) : R1 (a + b) = R1 a + R1 b := by
  unfold R1
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    ext <;>
      simp [i1, mul, ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

theorem R2_add (a b : Dixon) : R2 (a + b) = R2 a + R2 b := by
  unfold R2
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    ext <;>
      simp [i2, mul, ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

theorem R1_neg (a : Dixon) : R1 (-a) = -R1 a := by
  unfold R1
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    ext <;>
      simp [i1, mul, ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

theorem R2_neg (a : Dixon) : R2 (-a) = -R2 a := by
  unfold R2
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    ext <;>
      simp [i2, mul, ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

theorem R1_smul (c : ℂ) (a : Dixon) : R1 (c • a) = c • R1 a := by
  unfold R1
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    ext <;>
      simp [i1, mul, ComplexOctonion.mul_re, ComplexOctonion.mul_im,
        ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] <;>
      ring

theorem R2_smul (c : ℂ) (a : Dixon) : R2 (c • a) = c • R2 a := by
  unfold R2
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    ext <;>
      simp [i2, mul, ComplexOctonion.mul_re, ComplexOctonion.mul_im,
        ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] <;>
      ring

/-! ## The weak ladders as operators (faithful eq 29-30, CORRECTION 6) -/

/-- `betaHat_1 = (1/2)(-i_2 + i i_1 tau_3)` as an operator: `H`-units act by
right multiplication, `tau_3` by the lifted colour composition operator, `i` by
the central complex scalar. -/
def betaHat1 (d : Dixon) : Dixon :=
  (1 / 2 : ℂ) • (-(R2 d) + Complex.I • R1 (co hatTau3 d))

/-- `betaHat_2 = omega‡ i i_1` as an operator. -/
def betaHat2 (d : Dixon) : Dixon :=
  Complex.I • R1 (co hatOmegaDag d)

/-- `betaHat_1‡ = (1/2)(i_2 + i i_1 tau_3)` (`‡`: `i -> -i`, `i_k -> -i_k`,
`tau_3‡ = tau_3`, composition order reversed - self-reversing here). -/
def betaHat1dag (d : Dixon) : Dixon :=
  (1 / 2 : ℂ) • (R2 d + Complex.I • R1 (co hatTau3 d))

/-- `betaHat_2‡ = i i_1 omega`. -/
def betaHat2dag (d : Dixon) : Dixon :=
  Complex.I • R1 (co hatOmega d)

/-- The lifted omega-mode anticommutator
`M = lift(hatOmega hatOmegaDag + hatOmegaDag hatOmega)` - the structural
right-hand side of both diagonal CARs; equals the identity exactly on the
omega-mode plane. -/
def modeM (d : Dixon) : Dixon :=
  co hatOmega (co hatOmegaDag d) + co hatOmegaDag (co hatOmega d)

/-! Group/module instances live upstream in `DixonAlgebra` (moved 2026-07-18). -/

/-! ## Colour-op linearity at the `ComplexOctonion` level (shallow kernel) -/

set_option maxHeartbeats 16000000 in
theorem hatOmega_add (x y : ComplexOctonion) :
    hatOmega (x + y) = hatOmega x + hatOmega y := by
  unfold hatOmega
  ext <;>
    simp [alpha1, alpha2, alpha3, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

set_option maxHeartbeats 16000000 in
theorem hatOmegaDag_add (x y : ComplexOctonion) :
    hatOmegaDag (x + y) = hatOmegaDag x + hatOmegaDag y := by
  unfold hatOmegaDag
  ext <;>
    simp [alpha1_dag, alpha2_dag, alpha3_dag, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- Algebraic (no `hatTau3` coordinate expansion). -/
theorem hatTau3_add (x y : ComplexOctonion) :
    hatTau3 (x + y) = hatTau3 x + hatTau3 y := by
  unfold hatTau3
  rw [hatOmegaDag_add, hatOmega_add, hatOmega_add, hatOmegaDag_add]
  abel

set_option maxHeartbeats 16000000 in
theorem hatOmega_smul (c : ℂ) (x : ComplexOctonion) :
    hatOmega (c • x) = c • hatOmega x := by
  unfold hatOmega
  ext <;>
    simp [alpha1, alpha2, alpha3, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im, ComplexOctonion.complex_smul_re,
      ComplexOctonion.complex_smul_im] <;> ring

set_option maxHeartbeats 16000000 in
theorem hatOmegaDag_smul (c : ℂ) (x : ComplexOctonion) :
    hatOmegaDag (c • x) = c • hatOmegaDag x := by
  unfold hatOmegaDag
  ext <;>
    simp [alpha1_dag, alpha2_dag, alpha3_dag, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im, ComplexOctonion.complex_smul_re,
      ComplexOctonion.complex_smul_im] <;> ring

/-- Algebraic (no `hatTau3` coordinate expansion). -/
theorem hatTau3_smul (c : ℂ) (x : ComplexOctonion) :
    hatTau3 (c • x) = c • hatTau3 x := by
  unfold hatTau3
  rw [hatOmegaDag_smul, hatOmega_smul, hatOmega_smul, hatOmegaDag_smul,
    smul_add, smul_neg]

/-! ## Lift wrappers: `co` distributes and transfers the landed cores -/

theorem co_add (g : ComplexOctonion → ComplexOctonion)
    (hadd : ∀ x y, g (x + y) = g x + g y) (a b : Dixon) :
    co g (a + b) = co g a + co g b := by
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> exact hadd _ _

theorem co_neg (g : ComplexOctonion → ComplexOctonion)
    (hneg : ∀ x, g (-x) = -g x) (a : Dixon) :
    co g (-a) = -co g a := by
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> exact hneg _

theorem co_smul (g : ComplexOctonion → ComplexOctonion)
    (hsmul : ∀ (c : ℂ) x, g (c • x) = c • g x) (c : ℂ) (a : Dixon) :
    co g (c • a) = c • co g a := by
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> exact hsmul _ _

/-- The landed global core `hatOmega^2 = 0`, lifted. -/
theorem co_hatOmega_sq (d : Dixon) : co hatOmega (co hatOmega d) = 0 := by
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    simp only [co_x0, co_x1, co_x2, co_x3, zero_x0, zero_x1, zero_x2, zero_x3] <;>
    apply hatOmega_sq_zero

/-- The landed global core `hatOmegaDag^2 = 0`, lifted. -/
theorem co_hatOmegaDag_sq (d : Dixon) :
    co hatOmegaDag (co hatOmegaDag d) = 0 := by
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    simp only [co_x0, co_x1, co_x2, co_x3, zero_x0, zero_x1, zero_x2, zero_x3] <;>
    apply hatOmegaDag_sq_zero

/-- The landed global core `{hatTau3, hatOmegaDag} = 0`, lifted. -/
theorem co_tau3_omegaDag_anticomm (d : Dixon) :
    co hatTau3 (co hatOmegaDag d) + co hatOmegaDag (co hatTau3 d) = 0 := by
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    simp only [co_x0, co_x1, co_x2, co_x3, add_x0, add_x1, add_x2, add_x3,
      zero_x0, zero_x1, zero_x2, zero_x3] <;>
    apply tau3_omegaDag_anticomm_zero

/-- The landed global core `{hatTau3, hatOmega} = 0`, lifted. -/
theorem co_tau3_omega_anticomm (d : Dixon) :
    co hatTau3 (co hatOmega d) + co hatOmega (co hatTau3 d) = 0 := by
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    simp only [co_x0, co_x1, co_x2, co_x3, add_x0, add_x1, add_x2, add_x3,
      zero_x0, zero_x1, zero_x2, zero_x3] <;>
    apply tau3_omega_anticomm_zero

/-! ## Instantiated wrappers (simp-usable orientations: smuls out, `co` in) -/

theorem coT3_add (a b : Dixon) :
    co hatTau3 (a + b) = co hatTau3 a + co hatTau3 b := co_add _ hatTau3_add a b
theorem coT3_neg (a : Dixon) : co hatTau3 (-a) = -co hatTau3 a :=
  co_neg _ hatTau3_neg a
theorem coT3_smul (c : ℂ) (a : Dixon) :
    co hatTau3 (c • a) = c • co hatTau3 a := co_smul _ hatTau3_smul c a
theorem coT3_R1 (d : Dixon) : co hatTau3 (R1 d) = R1 (co hatTau3 d) :=
  co_comm_R1 _ hatTau3_neg d
theorem coT3_R2 (d : Dixon) : co hatTau3 (R2 d) = R2 (co hatTau3 d) :=
  co_comm_R2 _ hatTau3_neg d

theorem coOm_add (a b : Dixon) :
    co hatOmega (a + b) = co hatOmega a + co hatOmega b :=
  co_add _ hatOmega_add a b
theorem coOm_neg (a : Dixon) : co hatOmega (-a) = -co hatOmega a :=
  co_neg _ hatOmega_neg a
theorem coOm_smul (c : ℂ) (a : Dixon) :
    co hatOmega (c • a) = c • co hatOmega a := co_smul _ hatOmega_smul c a
theorem coOm_R1 (d : Dixon) : co hatOmega (R1 d) = R1 (co hatOmega d) :=
  co_comm_R1 _ hatOmega_neg d
theorem coOm_R2 (d : Dixon) : co hatOmega (R2 d) = R2 (co hatOmega d) :=
  co_comm_R2 _ hatOmega_neg d

theorem coOmD_add (a b : Dixon) :
    co hatOmegaDag (a + b) = co hatOmegaDag a + co hatOmegaDag b :=
  co_add _ hatOmegaDag_add a b
theorem coOmD_neg (a : Dixon) : co hatOmegaDag (-a) = -co hatOmegaDag a :=
  co_neg _ hatOmegaDag_neg a
theorem coOmD_smul (c : ℂ) (a : Dixon) :
    co hatOmegaDag (c • a) = c • co hatOmegaDag a :=
  co_smul _ hatOmegaDag_smul c a
theorem coOmD_R1 (d : Dixon) : co hatOmegaDag (R1 d) = R1 (co hatOmegaDag d) :=
  co_comm_R1 _ hatOmegaDag_neg d
theorem coOmD_R2 (d : Dixon) : co hatOmegaDag (R2 d) = R2 (co hatOmegaDag d) :=
  co_comm_R2 _ hatOmegaDag_neg d

/-- `I • I • a = -a` (the central complex unit squares to `-1`; stated as a
smul lemma because `ring` cannot reduce the atom `Complex.I`). -/
theorem I_smul_I (a : Dixon) : Complex.I • Complex.I • a = -a := by
  rw [← mul_smul, Complex.I_mul_I, neg_one_smul]

/-! ## The eq-31 CAR: global like and cross relations

The historically-blocked relations, now derived ALGEBRAICALLY from the landed
cores. Normal form: scalars outermost, `R`'s next, `co`'s innermost; the
`module` tactic closes the residual module-algebra reshuffles. -/

/-- Normal form of `betaHat1 (betaHat2 d)`. -/
theorem betaHat1_betaHat2_eq (d : Dixon) :
    betaHat1 (betaHat2 d) =
      (1 / 2 : ℂ) •
        (-(Complex.I • R2 (R1 (co hatOmegaDag d))) +
          co hatTau3 (co hatOmegaDag d)) := by
  unfold betaHat1 betaHat2
  simp only [coT3_smul, coT3_R1, R2_smul, R1_smul, R1_R1, smul_neg, smul_add,
    I_smul_I, neg_neg]

/-- Normal form of `betaHat2 (betaHat1 d)`. -/
theorem betaHat2_betaHat1_eq (d : Dixon) :
    betaHat2 (betaHat1 d) =
      (1 / 2 : ℂ) •
        (-(Complex.I • R1 (R2 (co hatOmegaDag d))) +
          co hatOmegaDag (co hatTau3 d)) := by
  unfold betaHat1 betaHat2
  simp only [coOmD_smul, coOmD_add, coOmD_neg, coOmD_R1, coOmD_R2, R1_smul,
    R1_add, R1_neg, R1_R1, smul_add, smul_neg, I_smul_I, neg_neg]
  match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num

/-- **eq-31 cross-CAR (GLOBAL): `{betaHat_1, betaHat_2} = 0`** - the relation
whose element-level failure drove the whole investigation, now an operator
identity on all of `C(x)H(x)O`. -/
theorem betaHat_cross_anticomm_12 (d : Dixon) :
    betaHat1 (betaHat2 d) + betaHat2 (betaHat1 d) = 0 := by
  rw [betaHat1_betaHat2_eq, betaHat2_betaHat1_eq]
  have h1 := R1_R2_anticomm (co hatOmegaDag d)
  have h2 := co_tau3_omegaDag_anticomm d
  rw [eq_neg_of_add_eq_zero_left h1, eq_neg_of_add_eq_zero_left h2]
  module

/-- Normal form of `betaHat1 (betaHat2dag d)`. -/
theorem betaHat1_betaHat2dag_eq (d : Dixon) :
    betaHat1 (betaHat2dag d) =
      (1 / 2 : ℂ) •
        (-(Complex.I • R2 (R1 (co hatOmega d))) +
          co hatTau3 (co hatOmega d)) := by
  unfold betaHat1 betaHat2dag
  simp only [coT3_smul, coT3_R1, R2_smul, R1_smul, R1_R1, smul_neg, smul_add,
    I_smul_I, neg_neg]

/-- Normal form of `betaHat2dag (betaHat1 d)`. -/
theorem betaHat2dag_betaHat1_eq (d : Dixon) :
    betaHat2dag (betaHat1 d) =
      (1 / 2 : ℂ) •
        (-(Complex.I • R1 (R2 (co hatOmega d))) +
          co hatOmega (co hatTau3 d)) := by
  unfold betaHat1 betaHat2dag
  simp only [coOm_smul, coOm_add, coOm_neg, coOm_R1, coOm_R2, R1_smul,
    R1_add, R1_neg, R1_R1, smul_add, smul_neg, I_smul_I, neg_neg]
  match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num

/-- **eq-31 mixed cross-CAR (GLOBAL): `{betaHat_1, betaHat_2‡} = 0`**
(`delta_12 = 0`). -/
theorem betaHat_mixed_anticomm_12 (d : Dixon) :
    betaHat1 (betaHat2dag d) + betaHat2dag (betaHat1 d) = 0 := by
  rw [betaHat1_betaHat2dag_eq, betaHat2dag_betaHat1_eq]
  have h1 := R1_R2_anticomm (co hatOmega d)
  have h2 := co_tau3_omega_anticomm d
  rw [eq_neg_of_add_eq_zero_left h1, eq_neg_of_add_eq_zero_left h2]
  module

/-- **eq-31 like-diagonal (GLOBAL): `betaHat_2^2 = 0`.** -/
theorem betaHat2_sq (d : Dixon) : betaHat2 (betaHat2 d) = 0 := by
  unfold betaHat2
  simp only [coOmD_smul, coOmD_R1, R1_smul, R1_R1, smul_neg, I_smul_I,
    neg_neg]
  rw [co_hatOmegaDag_sq]

/-- **eq-31 like-diagonal (GLOBAL): `(betaHat_2‡)^2 = 0`.** -/
theorem betaHat2dag_sq (d : Dixon) : betaHat2dag (betaHat2dag d) = 0 := by
  unfold betaHat2dag
  simp only [coOm_smul, coOm_R1, R1_smul, R1_R1, smul_neg, I_smul_I, neg_neg]
  rw [co_hatOmega_sq]

/-- Normal form of `betaHat2 (betaHat2dag d)`. -/
theorem betaHat2_betaHat2dag_eq (d : Dixon) :
    betaHat2 (betaHat2dag d) = co hatOmegaDag (co hatOmega d) := by
  unfold betaHat2 betaHat2dag
  simp only [coOmD_smul, coOmD_R1, R1_smul, R1_R1, smul_neg, I_smul_I,
    neg_neg]

/-- Normal form of `betaHat2dag (betaHat2 d)`. -/
theorem betaHat2dag_betaHat2_eq (d : Dixon) :
    betaHat2dag (betaHat2 d) = co hatOmega (co hatOmegaDag d) := by
  unfold betaHat2 betaHat2dag
  simp only [coOm_smul, coOm_R1, R1_smul, R1_R1, smul_neg, I_smul_I, neg_neg]

/-- **eq-31 diagonal, structural (GLOBAL):
`{betaHat_2, betaHat_2‡} = M` with `M` the lifted omega-mode anticommutator.**
`M = id` exactly on the omega-mode plane (`M v-lift = v-lift`,
`M nu-lift = nu-lift` - the ideal home of Furey's `delta_22 = 1`). -/
theorem betaHat2_mixed_anticomm_eq_modeM (d : Dixon) :
    betaHat2 (betaHat2dag d) + betaHat2dag (betaHat2 d) = modeM d := by
  rw [betaHat2_betaHat2dag_eq, betaHat2dag_betaHat2_eq]
  unfold modeM
  match_scalars <;> simp [Complex.I_sq]

/-- **eq-31 diagonal, structural (GLOBAL):
`{betaHat_1, betaHat_1‡} = (1/2)(id + lift(hatTau3^2))`.** On the omega-mode
plane `hatTau3^2 = id` (landed `tau3_sq_on_vIdem`/`tau3_sq_on_nuState`), so
there this is Furey's `delta_11 = 1`. -/
theorem betaHat1_mixed_anticomm_structural (d : Dixon) :
    betaHat1 (betaHat1dag d) + betaHat1dag (betaHat1 d) =
      (1 / 2 : ℂ) • (d + co hatTau3 (co hatTau3 d)) := by
  unfold betaHat1 betaHat1dag
  simp only [coT3_smul, coT3_add, coT3_neg, coT3_R1, coT3_R2, R1_smul, R2_smul,
    R1_add, R2_add, R1_neg, R2_neg, R1_R1, R2_R2, smul_add, smul_neg,
    I_smul_I, neg_neg]
  have h := R1_R2_anticomm (co hatTau3 d)
  rw [eq_neg_of_add_eq_zero_left h]
  match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num

/-- **eq-31 like-diagonal, structural (GLOBAL):
`betaHat_1^2 = (1/4)(lift(hatTau3^2) - id)`** - zero exactly where
`hatTau3^2 = id`, i.e. on the omega-mode plane (Furey's `{beta_1,beta_1} = 0`
on the ideal). -/
theorem betaHat1_sq_structural (d : Dixon) :
    betaHat1 (betaHat1 d) =
      (1 / 4 : ℂ) • (co hatTau3 (co hatTau3 d) + -d) := by
  unfold betaHat1
  simp only [coT3_smul, coT3_add, coT3_neg, coT3_R1, coT3_R2, R1_smul, R2_smul,
    R1_add, R2_add, R1_neg, R2_neg, R1_R1, R2_R2, smul_add, smul_neg,
    I_smul_I, neg_neg]
  have h := R1_R2_anticomm (co hatTau3 d)
  rw [eq_neg_of_add_eq_zero_left h]
  match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num

/-! ## The omega-mode plane atoms and the ideal-restricted diagonal CAR

Four SHALLOW kernel atoms determine the whole mode-plane action; `M = id` on
the plane then follows algebraically (no deep Fock identities needed). -/

set_option maxHeartbeats 8000000 in
/-- `hatOmega 0 = 0` (trivial kernel). -/
theorem hatOmega_zero : hatOmega 0 = 0 := by
  unfold hatOmega
  ext <;>
    simp [alpha1, alpha2, alpha3, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im]

set_option maxHeartbeats 8000000 in
/-- `hatOmegaDag 0 = 0` (trivial kernel). -/
theorem hatOmegaDag_zero : hatOmegaDag 0 = 0 := by
  unfold hatOmegaDag
  ext <;>
    simp [alpha1_dag, alpha2_dag, alpha3_dag, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im]

set_option maxHeartbeats 16000000 in
/-- **Annihilation atom (kernel, depth 3):** `hatOmegaDag v = 0` - the
idempotent is the composition-operator vacuum-side state (matches the landed
`MinimalLeftIdeal.alpha1_dag_kills_omega`). -/
theorem hatOmegaDag_on_vIdem : hatOmegaDag vIdem = 0 := by
  unfold hatOmegaDag
  ext <;>
    simp [PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, alpha1_dag,
      alpha2_dag, alpha3_dag, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

set_option maxHeartbeats 64000000 in
/-- **Lowering atom (kernel, depth 6):** `hatOmegaDag nu = v` - with
`hatOmega v = nu` this closes the plain-Pauli mode-plane picture
(`hatOmega = [[0,0],[1,0]]`, `hatOmegaDag = [[0,1],[0,0]]` on `(v, nu)`). -/
theorem hatOmegaDag_on_nuState : hatOmegaDag nuState = vIdem := by
  rw [nuState_eq_hatOmega_vIdem]
  unfold hatOmega hatOmegaDag
  ext <;>
    simp [PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, alpha1, alpha2,
      alpha3, alpha1_dag, alpha2_dag, alpha3_dag, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- `(P_0 + P_1) v = v`: the mode anticommutator is the identity on the lower
leg (algebraic from the atoms). -/
theorem mode_anticomm_on_vIdem :
    hatOmega (hatOmegaDag vIdem) + hatOmegaDag (hatOmega vIdem) = vIdem := by
  rw [hatOmegaDag_on_vIdem, hatOmega_zero]
  rw [show hatOmega vIdem = nuState from (nuState_eq_hatOmega_vIdem).symm,
    hatOmegaDag_on_nuState]
  exact zero_add vIdem

/-- `(P_0 + P_1) nu = nu`: and on the upper leg (algebraic from the atoms +
the landed `hatOmega^2 = 0` core). -/
theorem mode_anticomm_on_nuState :
    hatOmega (hatOmegaDag nuState) + hatOmegaDag (hatOmega nuState) = nuState := by
  have h1 : hatOmega (hatOmegaDag nuState) = nuState := by
    rw [hatOmegaDag_on_nuState, ← nuState_eq_hatOmega_vIdem]
  have h2 : hatOmegaDag (hatOmega nuState) = 0 := by
    rw [nuState_eq_hatOmega_vIdem, hatOmega_sq_zero, hatOmegaDag_zero]
  rw [h1, h2, add_zero]

/-- **The ideal-restricted diagonal CAR, second mode (kernel + algebra):**
`{betaHat_2, betaHat_2‡} = id` on the colour-`v` line of the Dixon algebra
(stated on the `ofColour`-style lift with all four `H`-slots carrying `v`
multiples is unnecessary - slot-wise it suffices that every colour slot lies
on the mode plane; here the generating case). Together with the global
structural theorem this is Furey's `delta_22 = 1` where eq 32 lives. -/
theorem betaHat2_diag_CAR_on_vSlots (a b c e : ℂ)
    (d : Dixon)
    (h0 : d.x0 = a • vIdem) (h1 : d.x1 = b • vIdem)
    (h2 : d.x2 = c • vIdem) (h3 : d.x3 = e • vIdem) :
    betaHat2 (betaHat2dag d) + betaHat2dag (betaHat2 d) = d := by
  rw [betaHat2_mixed_anticomm_eq_modeM]
  unfold modeM co
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    simp only [h0, h1, h2, h3, add_x0, add_x1, add_x2, add_x3,
      hatOmega_smul, hatOmegaDag_smul, hatOmegaDag_on_vIdem, smul_zero,
      hatOmega_zero, hatOmegaDag_zero] <;>
    rw [show hatOmega vIdem = nuState from (nuState_eq_hatOmega_vIdem).symm,
      hatOmegaDag_on_nuState] <;>
    simp

end PhysicsSM.Draft.NullEdge.CompositionWeakCAR

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionWeakCAR.betaHat_cross_anticomm_12' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionWeakCAR.betaHat_cross_anticomm_12

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionWeakCAR.betaHat_mixed_anticomm_12' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionWeakCAR.betaHat_mixed_anticomm_12

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionWeakCAR.betaHat2_mixed_anticomm_eq_modeM' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionWeakCAR.betaHat2_mixed_anticomm_eq_modeM
