import PhysicsSM.Draft.CheckerboardContinuumScaffold

/-!
# Checkerboard continuum-next finite theorem layer

This module integrates the 2026-07-01 Aristotle checkerboard continuum-next
result into the standalone package.

It proves the next finite facts needed before a serious continuum-limit
statement:

* turn-count parity determines the final velocity direction;
* fixed start/end velocity and fixed turn count have the expected binomial
  count;
* the unitary isotropic checkerboard step is a one-parameter group.

These are finite identities. They do not assert convergence to the continuum
Dirac equation.
-/

noncomputable section

namespace PhysicsSM.Draft.CheckerboardContinuumNext

open Matrix
open scoped BigOperators

open PhysicsSM.Draft.Checkerboard1D
open PhysicsSM.Draft.CheckerboardContinuumScaffold

/-- Count fixed-length velocity paths with fixed initial direction, final
direction, and exact turn count. This deliberately ignores spacetime endpoint
counts; it is the velocity-sequence count. -/
def velocityEndpointTurnClassCount (n k : Nat) (inc out : Direction) : Nat :=
  Fintype.card {v : Fin (n + 1) -> Direction //
    v 0 = inc /\ v (Fin.last n) = out /\ turnCountVec v = k}

/-- For a binary direction path, the parity of the number of turns is exactly
the indicator of whether the endpoint velocity has changed. -/
theorem turnCountVec_mod_two_eq_endpoint (n : Nat)
    (v : Fin (n + 1) -> Direction) :
    turnCountVec v % 2 =
      (if v 0 = v (Fin.last n) then 0 else 1) := by
  induction' n with n ih <;> simp_all +decide [Fin.last]
  · exact Eq.symm (Nat.eq_of_beq_eq_true rfl)
  · specialize ih (fun i => v i.succ)
    simp_all +decide
    have h_turnCountVec_cons :
        turnCountVec v =
          (if v 0 = v 1 then 0 else 1) + turnCountVec (fun i => v i.succ) := by
      convert turnCountVec_cons (v 0) (fun i => v i.succ) using 1
      exact congr_arg _ (funext fun i => by cases i using Fin.inductionOn <;> rfl)
    grind

/-- Equal endpoint directions are equivalent to an even turn count. -/
theorem endpoint_eq_iff_turnCountVec_even (n : Nat)
    (v : Fin (n + 1) -> Direction) :
    v 0 = v (Fin.last n) <-> turnCountVec v % 2 = 0 := by
  grind +suggestions

/-- The velocity-sequence count with fixed initial direction, final direction,
and exact turn count is the binomial count of turn slots when the parity matches,
and zero when it does not. -/
theorem velocityEndpointTurnClassCount_eq_choose (n k : Nat)
    (inc out : Direction) :
    velocityEndpointTurnClassCount n k inc out =
      if k % 2 = (if inc = out then 0 else 1) then Nat.choose n k else 0 := by
  simp [velocityEndpointTurnClassCount]
  by_cases hpar : k % 2 = (if inc = out then 0 else 1)
  · have h_discard : (Fintype.card {v : Fin (n + 1) → Direction // v 0 = inc ∧ v (Fin.last n) = out ∧ turnCountVec v = k}) = (Fintype.card {v : Fin (n + 1) → Direction // v 0 = inc ∧ turnCountVec v = k}) := by
      refine' Fintype.card_congr _
      refine' Equiv.subtypeEquivRight _
      grind +suggestions
    rw [h_discard, if_pos hpar]
    have h_turn_count :
        forall v : Fin (n + 1) -> Direction,
          turnCountVec v =
            Finset.card
              (Finset.filter
                (fun i : Fin n => v i.castSucc ≠ v i.succ) Finset.univ) := by
      intro v
      rw [Finset.card_filter]
      simp +decide [turnCountVec]
    have h_bij : {v : Fin (n + 1) → Direction | v 0 = inc ∧ turnCountVec v = k} ≃ {s : Finset (Fin n) | s.card = k} := by
      refine' Equiv.ofBijective ( fun v => ⟨ Finset.univ.filter fun i : Fin n => v.val ( Fin.castSucc i ) ≠ v.val ( Fin.succ i ), _ ⟩ ) ⟨ _, _ ⟩ <;> simp +decide
      grind +qlia
      · intro v w h
        simp_all +decide [ Finset.ext_iff ]
        ext i
        induction' i using Fin.inductionOn with i IH
        aesop
        grind
      · intro s
        obtain ⟨v, hv⟩ : ∃ v : Fin (n + 1) → Direction, v 0 = inc ∧ ∀ i : Fin n, v i.castSucc ≠ v i.succ ↔ i ∈ s.val := by
          use fun i => Fin.inductionOn i inc (fun i v => if i ∈ s.val then 1 - v else v)
          simp +decide [ Fin.inductionOn ]
          grind
        use ⟨ v, hv.1, by aesop ⟩
        aesop
    convert Fintype.card_congr h_bij using 1
    simp +decide [ Fintype.card_subtype ]
  · rw [if_neg hpar, Fintype.card_eq_zero_iff]
    exact ⟨ fun ⟨ v, hv₁, hv₂, hv₃ ⟩ => hpar <| by have := turnCountVec_mod_two_eq_endpoint n v; aesop ⟩

/-- The unitary isotropic checkerboard step is a one-parameter group. -/
theorem isotropicStep_mul (theta phi : Real) :
    isotropicStep theta * isotropicStep phi = isotropicStep (theta + phi) := by
  unfold isotropicStep checkerStep nullTransport massFlip reversal
  ext i j
  fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_two]
  · rw [Complex.cos_add]
    ring_nf
    rw [Complex.I_sq]
    ring
  · rw [Complex.sin_add]
    ring
  · rw [Complex.sin_add]
    ring
  · rw [Complex.cos_add]
    ring_nf
    rw [Complex.I_sq]
    ring

/-- Powers of the unitary isotropic step add the rotation angle. -/
theorem isotropicStep_pow_eq (theta : Real) (n : Nat) :
    isotropicStep theta ^ n = isotropicStep ((n : Real) * theta) := by
  induction n with
  | zero => simpa using isotropicStep_zero.symm
  | succ n ih =>
    rw [pow_succ, ih, isotropicStep_mul]
    congr 1
    push_cast
    ring

/-- Exact product/remainder form of the unitary isotropic step powers.

This combines the one-parameter group law with the packaged first-order
remainder. It is still a finite identity; quantitative bounds on the remainder
belong to the analytic scaffold layer. -/
theorem isotropicStep_pow_eq_one_add_scaled_generator_add_remainder
    (theta : Real) (n : Nat) :
    isotropicStep theta ^ n =
      (1 : Matrix Direction Direction Complex) +
        (((n : Real) * theta : Real) : Complex) • isotropicGenerator +
        isotropicStepFirstOrderRemainder ((n : Real) * theta) := by
  rw [isotropicStep_pow_eq,
    isotropicStep_eq_one_add_theta_generator_add_remainder]

/-! ## Product/remainder normed identities for step powers

Combining the exact product/remainder form of the step powers with the explicit
entrywise L1 norm gives a clean scalar identity: the entrywise L1 distance
between the exact `n`-fold step and its first-order (identity plus scaled
generator) model equals the entrywise L1 norm of the packaged remainder at
angle `n * theta`. These remain finite identities and do not assert a continuum
limit. -/

/- Exact product/remainder norm identity: the entrywise L1 distance between the
`n`-fold unitary isotropic step and its first-order model
`1 + (n * theta) • isotropicGenerator` equals the entrywise L1 norm of the
packaged first-order remainder at angle `n * theta`. -/
theorem isotropicStep_pow_sub_linear_l1Norm_eq (theta : Real) (n : Nat) :
    matrixL1Norm
        (isotropicStep theta ^ n -
          ((1 : Matrix Direction Direction Complex) +
            (((n : Real) * theta : Real) : Complex) • isotropicGenerator)) =
      matrixL1Norm
        (isotropicStepFirstOrderRemainder ((n : Real) * theta)) := by
  congr 1
  rw [isotropicStep_pow_eq_one_add_scaled_generator_add_remainder theta n]
  abel

/- Explicit closed form of the product/remainder norm identity: the entrywise
L1 distance between the `n`-fold step and its first-order model is exactly
`2 * |cos (n * theta) - 1| + 2 * |sin (n * theta) - n * theta|`. -/
theorem isotropicStep_pow_sub_linear_l1Norm_eq_explicit
    (theta : Real) (n : Nat) :
    matrixL1Norm
        (isotropicStep theta ^ n -
          ((1 : Matrix Direction Direction Complex) +
            (((n : Real) * theta : Real) : Complex) • isotropicGenerator)) =
      2 * |Real.cos ((n : Real) * theta) - 1| +
        2 * |Real.sin ((n : Real) * theta) - (n : Real) * theta| := by
  rw [isotropicStep_pow_sub_linear_l1Norm_eq theta n,
    matrixL1Norm_isotropicStepFirstOrderRemainder]

/-! ## Fixed-time subdivision guardrails

The one-parameter group law means that subdividing a fixed angle `T` into
`N + 1` equal checkerboard steps is exact: the product is `isotropicStep T`.
Consequently the first-order linear model `1 + T * generator` does not become
better merely by time subdivision at fixed `T`; its error is the fixed packaged
first-order remainder at angle `T`. This guards against a common but false
continuum-scaling reading of the product/remainder identity above. -/

/-- Equal subdivision of a fixed angle is exact for the isotropic step. -/
theorem isotropicStep_equal_subdivision_exact (T : Real) (N : Nat) :
    isotropicStep (T / (N.succ : Real)) ^ N.succ = isotropicStep T := by
  rw [isotropicStep_pow_eq]
  congr 1
  have hN : (N.succ : Real) ≠ 0 := by exact_mod_cast Nat.succ_ne_zero N
  field_simp [hN]

/-- At fixed accumulated angle `T`, the L1 error against the first-order linear
model is the fixed first-order remainder at `T`; subdivision alone does not make
this linearization error vanish. -/
theorem isotropicStep_equal_subdivision_sub_linear_l1Norm_eq
    (T : Real) (N : Nat) :
    matrixL1Norm
        (isotropicStep (T / (N.succ : Real)) ^ N.succ -
          ((1 : Matrix Direction Direction Complex) +
            (T : Complex) • isotropicGenerator)) =
      matrixL1Norm (isotropicStepFirstOrderRemainder T) := by
  have hN : (N.succ : Real) ≠ 0 := by exact_mod_cast Nat.succ_ne_zero N
  have hmul : (N.succ : Real) * (T / (N.succ : Real)) = T := by
    field_simp [hN]
  calc
    matrixL1Norm
        (isotropicStep (T / (N.succ : Real)) ^ N.succ -
          ((1 : Matrix Direction Direction Complex) +
            (T : Complex) • isotropicGenerator)) =
        matrixL1Norm
          (isotropicStep (T / (N.succ : Real)) ^ N.succ -
            ((1 : Matrix Direction Direction Complex) +
              (((N.succ : Real) * (T / (N.succ : Real)) : Real) : Complex) •
                isotropicGenerator)) := by
          rw [hmul]
    _ = matrixL1Norm
          (isotropicStepFirstOrderRemainder
            ((N.succ : Real) * (T / (N.succ : Real)))) := by
          rw [isotropicStep_pow_sub_linear_l1Norm_eq]
    _ = matrixL1Norm (isotropicStepFirstOrderRemainder T) := by
          rw [hmul]

/-- Explicit fixed-time subdivision error against the first-order linear model. -/
theorem isotropicStep_equal_subdivision_sub_linear_l1Norm_eq_explicit
    (T : Real) (N : Nat) :
    matrixL1Norm
        (isotropicStep (T / (N.succ : Real)) ^ N.succ -
          ((1 : Matrix Direction Direction Complex) +
            (T : Complex) • isotropicGenerator)) =
      2 * |Real.cos T - 1| + 2 * |Real.sin T - T| := by
  rw [isotropicStep_equal_subdivision_sub_linear_l1Norm_eq,
    matrixL1Norm_isotropicStepFirstOrderRemainder]

/-! ## Accumulated-angle smallness

The product/remainder identity does give a genuine asymptotic result when the
accumulated angle itself tends to zero. This is the correct abstract form of the
small-angle product-error estimate supported by the current finite machinery. -/

/-- If the accumulated angle `(n a) * theta a` tends to zero along a filter, then
the entrywise L1 error between the product and its first-order accumulated-angle
linear model tends to zero. -/
theorem isotropicStep_pow_sub_linear_l1Norm_tendsto_zero_of_accumulated_tendsto_zero
    {α : Type*} {l : Filter α} {theta : α → Real} {n : α → Nat}
    (hacc :
      Filter.Tendsto
        (fun a => ((n a : Nat) : Real) * theta a) l (nhds 0)) :
    Filter.Tendsto
      (fun a =>
        matrixL1Norm
          (isotropicStep (theta a) ^ n a -
            ((1 : Matrix Direction Direction Complex) +
              ((((n a : Nat) : Real) * theta a : Real) : Complex) •
                isotropicGenerator)))
      l (nhds 0) := by
  have hscalar :
      Filter.Tendsto
        (fun a =>
          2 * |Real.cos (((n a : Nat) : Real) * theta a) - 1| +
            2 * |Real.sin (((n a : Nat) : Real) * theta a) -
              ((n a : Nat) : Real) * theta a|)
        l (nhds 0) := by
    have hcont :
        ContinuousAt
          (fun x : Real => 2 * |Real.cos x - 1| + 2 * |Real.sin x - x|)
          0 := by
      fun_prop
    simpa using hcont.tendsto.comp hacc
  have hnorm :
      Filter.Tendsto
        (fun a =>
          matrixL1Norm
            (isotropicStepFirstOrderRemainder (((n a : Nat) : Real) * theta a)))
        l (nhds 0) := by
    refine hscalar.congr' ?_
    exact Filter.Eventually.of_forall fun a =>
      (matrixL1Norm_isotropicStepFirstOrderRemainder
        (((n a : Nat) : Real) * theta a)).symm
  refine hnorm.congr' ?_
  exact Filter.Eventually.of_forall fun a =>
    (isotropicStep_pow_sub_linear_l1Norm_eq (theta a) (n a)).symm

/-! ## Quantitative accumulated-angle product-error bound

Combining the exact product/remainder norm identity
`isotropicStep_pow_sub_linear_l1Norm_eq` with the quantitative Taylor bound
`isotropicStepFirstOrderRemainder_l1Norm_le_sq_add_cube` yields an explicit,
constant-carrying bound on the entrywise L1 distance between the `n`-fold
unitary isotropic step and its first-order accumulated-angle linear model,
centered on the accumulated angle `x = n * theta`. This is a finite identity
combined with an elementary scalar estimate; it does not assert a continuum
limit. -/

/-- Quantitative product-error bound centered on the accumulated angle
`x = n * theta`: the entrywise L1 distance between the `n`-fold unitary
isotropic step and its first-order model `1 + (n * theta) • isotropicGenerator`
is at most `(n * theta)^2 + (1/3) * |n * theta|^3`. -/
theorem isotropicStep_pow_sub_linear_l1Norm_le_accumulated_sq_add_cube
    (theta : Real) (n : Nat) :
    matrixL1Norm
        (isotropicStep theta ^ n -
          ((1 : Matrix Direction Direction Complex) +
            (((n : Real) * theta : Real) : Complex) • isotropicGenerator)) ≤
      ((n : Real) * theta) ^ 2 +
        (1 / 3 : Real) * |((n : Real) * theta)| ^ 3 := by
  rw [isotropicStep_pow_sub_linear_l1Norm_eq theta n]
  exact isotropicStepFirstOrderRemainder_l1Norm_le_sq_add_cube
    ((n : Real) * theta)

/-- One-step operator-facing BigO form: the L1 error between `isotropicStep x`
and its first-order generator linearization is `O(x^2)` as `x -> 0`. -/
theorem isotropicStep_sub_linear_l1Norm_isBigO_sq :
    (fun x : Real =>
      matrixL1Norm
        (isotropicStep x -
          ((1 : Matrix Direction Direction Complex) +
            (x : Complex) • isotropicGenerator)))
      =O[nhds (0 : Real)] (fun x : Real => x ^ 2) := by
  refine isotropicStepFirstOrderRemainder_l1Norm_isBigO_sq.congr_left ?_
  intro x
  congr 1
  rw [isotropicStep_eq_one_add_theta_generator_add_remainder]
  abel

/-- One-step operator-facing little-o form: the L1 error between `isotropicStep x`
and its first-order generator linearization is little-o of `x` as `x -> 0`. -/
theorem isotropicStep_sub_linear_l1Norm_isLittleO_id :
    (fun x : Real =>
      matrixL1Norm
        (isotropicStep x -
          ((1 : Matrix Direction Direction Complex) +
            (x : Complex) • isotropicGenerator)))
      =o[nhds (0 : Real)] (fun x : Real => x) := by
  refine isotropicStepFirstOrderRemainder_l1Norm_isLittleO_id.congr_left ?_
  intro x
  congr 1
  rw [isotropicStep_eq_one_add_theta_generator_add_remainder]
  abel

/-- Composed-filter accumulated-angle form: if
`(n a : Real) * theta a -> 0`, then the product error is little-o of that
accumulated angle. -/
theorem isotropicStep_pow_sub_linear_l1Norm_isLittleO_accumulated
    {α : Type*} {l : Filter α} {theta : α → Real} {n : α → Nat}
    (hacc :
      Filter.Tendsto
        (fun a => ((n a : Nat) : Real) * theta a) l (nhds 0)) :
    (fun a =>
      matrixL1Norm
        (isotropicStep (theta a) ^ n a -
          ((1 : Matrix Direction Direction Complex) +
            ((((n a : Nat) : Real) * theta a : Real) : Complex) •
              isotropicGenerator)))
      =o[l] (fun a => ((n a : Nat) : Real) * theta a) := by
  have hrem :=
    isotropicStepFirstOrderRemainder_l1Norm_isLittleO_comp (x :=
      fun a => ((n a : Nat) : Real) * theta a) hacc
  refine hrem.congr_left ?_
  intro a
  exact (isotropicStep_pow_sub_linear_l1Norm_eq (theta a) (n a)).symm

end PhysicsSM.Draft.CheckerboardContinuumNext
