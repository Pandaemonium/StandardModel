import Mathlib

/-!
# Vector-valued Plancherel on a finite periodic lattice

Mathlib supplies a vector-valued discrete Fourier equivalence on `ZMod N`.
This module proves the corresponding energy identities in the normalization
used by the null-edge walk: the forward transform multiplies total squared
norm by `N`, while the inverse transform multiplies it by `1 / N`.

The final theorem converts a modewise relative error into an exact finite
position-space `L2` wave-packet bound without the cardinality loss of a direct
triangle-inequality synthesis estimate.  A one-mode packet fixes the
normalization nonvacuously.

Provenance: theorem statements prepared in the Paper-I continuum audit and
proofs clean-room integrated from Aristotle project
`3fb4cfc5-b4d0-4888-9472-85c0f516a3c1`, checked under Lean 4.28.0.  The DFT
convention is Mathlib's `ZMod.dft`; no continuum or infinite-volume limit is
asserted here.
-/

noncomputable section

open scoped BigOperators ZMod

namespace PhysicsSM.Draft.NullEdge.FiniteZModPlancherel

variable {N : Nat} [NeZero N]
variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace Complex E]

private lemma stdChar_conj (t : ZMod N) :
    starRingEnd Complex (ZMod.stdAddChar t) = ZMod.stdAddChar (-t) := by
  rw [ZMod.stdAddChar_apply, ZMod.stdAddChar_apply,
    <- Circle.coe_inv_eq_conj]
  congr 1
  exact (AddChar.map_neg_eq_inv ZMod.toCircle t).symm

private lemma stdChar_sum (b : ZMod N) :
    ∑ k : ZMod N, ZMod.stdAddChar (k * b) =
      if b = 0 then (N : Complex) else 0 := by
  have h := AddChar.sum_mulShift (ψ := ZMod.stdAddChar (N := N)) b
    (ZMod.isPrimitive_stdAddChar N)
  rw [h]
  split_ifs with hb <;> simp [ZMod.card]

/-- Inner-product Plancherel identity for Mathlib's unnormalized DFT. -/
theorem dft_inner_plancherel (phi psi : ZMod N -> E) :
    ∑ k : ZMod N, (inner Complex (ZMod.dft phi k) (ZMod.dft psi k) : Complex) =
      (N : Complex) *
        ∑ j : ZMod N, (inner Complex (phi j) (psi j) : Complex) := by
  have hFourier : forall k : ZMod N,
      ZMod.dft phi k =
        ∑ j : ZMod N, ZMod.stdAddChar (-(j * k)) • phi j := by
    intro k
    convert rfl
  have hFourier' : forall k : ZMod N,
      ZMod.dft psi k =
        ∑ j : ZMod N, ZMod.stdAddChar (-(j * k)) • psi j := by
    aesop
  have hInner : forall k : ZMod N,
      inner Complex (ZMod.dft phi k) (ZMod.dft psi k) =
        ∑ i : ZMod N, ∑ j : ZMod N,
          starRingEnd Complex (ZMod.stdAddChar (-(i * k))) *
            ZMod.stdAddChar (-(j * k)) * inner Complex (phi i) (psi j) := by
    intro k
    rw [hFourier k, hFourier' k]
    simp +decide [inner_sum, sum_inner, inner_smul_left, inner_smul_right]
    simp +decide only [mul_comm, Finset.mul_sum _ _ _, mul_left_comm]
    exact Finset.sum_comm.trans
      (Finset.sum_congr rfl fun _ _ =>
        Finset.sum_congr rfl fun _ _ => by ring)
  have hSimplify : forall i j : ZMod N,
      ∑ k : ZMod N,
          starRingEnd Complex (ZMod.stdAddChar (-(i * k))) *
            ZMod.stdAddChar (-(j * k)) =
        if i = j then (N : Complex) else 0 := by
    intro i j
    have hStep : ∑ k : ZMod N, ZMod.stdAddChar ((i - j) * k) =
        if i = j then (N : Complex) else 0 := by
      convert stdChar_sum (i - j) using 1
      · ac_rfl
      · simp +decide [sub_eq_zero]
    convert hStep using 2
    simp +decide [sub_mul, stdChar_conj]
    ring!
    rw [← AddChar.map_add_eq_mul]
    ring!
  simp +decide only [hInner, Finset.mul_sum _ _ _]
  rw [Finset.sum_comm, Finset.sum_congr rfl]
  intro i hi
  rw [Finset.sum_comm]
  simp +decide [<- Finset.mul_sum _ _ _, <- Finset.sum_mul, hSimplify]

/-- The unnormalized vector-valued DFT multiplies total squared norm by `N`. -/
theorem dft_energy (f : ZMod N -> E) :
    ∑ k : ZMod N, ‖ZMod.dft f k‖ ^ 2 =
      (N : Real) * ∑ j : ZMod N, ‖f j‖ ^ 2 := by
  convert congrArg Complex.re (dft_inner_plancherel f f) using 1
  · simp +decide [inner_self_eq_norm_sq_to_K]
    norm_cast
  · simp +decide [inner_self_eq_norm_sq_to_K]
    norm_cast
    norm_num

/-- Mathlib's inverse DFT carries the reciprocal normalization. -/
theorem invDFT_energy (f : ZMod N -> E) :
    ∑ x : ZMod N, ‖(ZMod.dft.symm f) x‖ ^ 2 =
      (1 / (N : Real)) * ∑ k : ZMod N, ‖f k‖ ^ 2 := by
  have hPlancherel : ∑ k : ZMod N, ‖ZMod.dft f k‖ ^ 2 =
      N * ∑ k : ZMod N, ‖f k‖ ^ 2 := by
    exact dft_energy f
  simp_all +decide [mul_comm, mul_left_comm, mul_assoc,
    Finset.mul_sum _ _ _, Finset.sum_mul, ZMod.invDFT_apply', norm_smul,
    norm_inv, Complex.norm_natCast]
  convert congrArg (fun x : Real => (N : Real)⁻¹ ^ 2 * x) hPlancherel using 1 <;>
    norm_num [Finset.mul_sum _ _ _, mul_pow]
  · exact Equiv.sum_comp (Equiv.neg (ZMod N))
      fun x => (N ^ 2 : Real)⁻¹ * ‖ZMod.dft f x‖ ^ 2
  · simp +decide [sq, mul_assoc, NeZero.ne]

/-- A modewise relative error gives a normalized finite `L2` position-space
wave-packet bound. -/
theorem inverseDFT_wavepacket_error
    (approx exact coeff : ZMod N -> E) (eps : Real)
    (heps : 0 <= eps)
    (herr : forall k, ‖approx k - exact k‖ <= eps * ‖coeff k‖) :
    ∑ x : ZMod N,
        ‖(ZMod.dft.symm (fun k => approx k - exact k)) x‖ ^ 2 <=
      (eps ^ 2 / (N : Real)) * ∑ k : ZMod N, ‖coeff k‖ ^ 2 := by
  convert invDFT_energy (fun k => approx k - exact k) |>.le |>.trans ?_ using 1
  rw [Finset.mul_sum _ _ _, Finset.mul_sum _ _ _]
  exact Finset.sum_le_sum fun i _ => by
    convert mul_le_mul_of_nonneg_left
      (pow_le_pow_left₀ (norm_nonneg _) (herr i) 2)
      (by positivity : (0 : Real) <= 1 / N) using 1
    ring

/-- A uniform modewise operator-norm estimate acts on every finite wave packet
with the same normalized `L2` rate.  This is the abstract composition theorem
needed by a walk-specific Fourier diagonalization. -/
theorem inverseDFT_operator_wavepacket_error
    (approx exact : ZMod N -> (E →L[Complex] E))
    (coeff : ZMod N -> E)
    (eps : Real) (heps : 0 <= eps)
    (herr : forall k, ‖approx k - exact k‖ <= eps) :
    ∑ x : ZMod N,
        ‖(ZMod.dft.symm
          (fun k => approx k (coeff k) - exact k (coeff k))) x‖ ^ 2 <=
      (eps ^ 2 / (N : Real)) * ∑ k : ZMod N, ‖coeff k‖ ^ 2 := by
  apply inverseDFT_wavepacket_error
    (fun k => approx k (coeff k))
    (fun k => exact k (coeff k)) coeff eps heps
  intro k
  calc
    ‖approx k (coeff k) - exact k (coeff k)‖ =
        ‖(approx k - exact k) (coeff k)‖ := by
          rw [ContinuousLinearMap.sub_apply]
    _ <= ‖approx k - exact k‖ * ‖coeff k‖ :=
      (approx k - exact k).le_opNorm (coeff k)
    _ <= eps * ‖coeff k‖ :=
      mul_le_mul_of_nonneg_right (herr k) (norm_nonneg _)

/-- A one-mode packet is a nonzero control for the inverse-transform
normalization. -/
theorem delta_mode_control [Nontrivial E] (k0 : ZMod N) (v : E) :
    ∑ x : ZMod N,
        ‖(ZMod.dft.symm (fun k => if k = k0 then v else 0)) x‖ ^ 2 =
      ‖v‖ ^ 2 / (N : Real) := by
  convert invDFT_energy _ using 1
  ring
  rw [mul_comm, Finset.sum_eq_single k0] <;> aesop

end PhysicsSM.Draft.NullEdge.FiniteZModPlancherel

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteZModPlancherel.dft_energy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteZModPlancherel.dft_energy

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteZModPlancherel.invDFT_energy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteZModPlancherel.invDFT_energy

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteZModPlancherel.inverseDFT_wavepacket_error' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteZModPlancherel.inverseDFT_wavepacket_error

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteZModPlancherel.inverseDFT_operator_wavepacket_error' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteZModPlancherel.inverseDFT_operator_wavepacket_error

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteZModPlancherel.delta_mode_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteZModPlancherel.delta_mode_control
