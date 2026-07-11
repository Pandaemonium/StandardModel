import PhysicsSM.Draft.NullEdge.Finite3Plus1ProductDFTCore
import PhysicsSM.Draft.NullEdge.GateC1.FiniteFourierParseval

/-!
# Normalized product DFT, Parseval, and mode expansion for the live 3+1 walk

The product-character orthogonality and normalization are proved in
`Finite3Plus1ProductDFTCore`. This module composes them into exact normalized
forward/inverse transform round trips, Parseval, finite-sum linearity, and a
complete plane-wave mode expansion.

The final theorem uses the exact mode reconstruction and the existing
single-mode action to prove operator-level conjugacy of the live local walk to
its exact finite character block. Identifying that block with an analytic Dirac
symbol requires the separately tracked momentum-sign convention bridge.
The final two corollaries give the exact inverse-transform factorization and
the finite-time evolution as powers of the same momentum block.

Provenance: theorem statements were prepared locally. The proof-complete
prefix was harvested from the in-progress snapshot of Aristotle project
`6ac7ec5e-743b-4c1e-b536-bd6cf61a1355`; statements were compared with the seed
before integration.
-/

noncomputable section

open Matrix Complex
open scoped BigOperators ZMod

namespace PhysicsSM.Draft.NullEdge.LiveDFTComposition

open Finite3Plus1FourierBridge
open Finite3Plus1ProductDFTCore

abbrev Axis := Finite3Plus1FourierBridge.Axis
abbrev Internal := Finite3Plus1FourierBridge.Internal
abbrev Position (L : Nat) := Finite3Plus1FourierBridge.Position L
abbrev State (L : Nat) := Finite3Plus1FourierBridge.State L
abbrev Vec4 := Finite3Plus1FourierBridge.Vec4

def rawFourier {L : Nat} [NeZero L] (psi : State L) : Position L -> Vec4 :=
  fun k a => ∑ p : Position L, star (planeWave k p) * psi p a

def fourier {L : Nat} [NeZero L] (psi : State L) : Position L -> Vec4 :=
  fun k a => (fourierNormFactor L : Complex) * rawFourier psi k a

def inverseFourier {L : Nat} [NeZero L]
    (phi : Position L -> Vec4) : State L :=
  fun p a => (fourierNormFactor L : Complex) *
    ∑ k : Position L, planeWave k p * phi k a

def positionNormSq {L : Nat} [NeZero L] (psi : State L) : Real :=
  ∑ p : Position L, ∑ a : Internal, Complex.normSq (psi p a)

def momentumNormSq {L : Nat} [NeZero L]
    (phi : Position L -> Vec4) : Real :=
  ∑ k : Position L, ∑ a : Internal, Complex.normSq (phi k a)

/-- Inverse after forward normalized product DFT is the identity. -/
theorem inverseFourier_fourier {L : Nat} [NeZero L] (psi : State L) :
    inverseFourier (fourier psi) = psi := by
  ext p a
  unfold inverseFourier fourier rawFourier
  have h_fubini :
      ∑ k : Position L,
          planeWave k p *
            (∑ q : Position L, star (planeWave k q) * psi q a) =
        ∑ q : Position L,
          (∑ k : Position L,
            planeWave k p * star (planeWave k q)) * psi q a := by
    simpa only [mul_assoc, Finset.mul_sum _ _ _, Finset.sum_mul] using
      Finset.sum_comm
  have h_orthog : ∀ q : Position L,
      ∑ k : Position L, planeWave k p * star (planeWave k q) =
        if p = q then (siteCard L : Complex) else 0 := by
    intro q
    convert planeWave_row_orthogonality p q using 1
    simp +decide [planeWave, mul_comm]
  simp_all +decide [Finset.mul_sum _ _ _, mul_assoc, mul_left_comm,
    Finset.sum_mul]
  convert congr_arg
    (fun x : Complex =>
      (fourierNormFactor L : Complex) *
        (fourierNormFactor L : Complex) * x) h_fubini using 1
  · simp +decide only [Finset.mul_sum _ _ _, mul_left_comm]
    ac_rfl
  · simp_all +decide [← mul_assoc, ← Finset.sum_mul]
    norm_cast
    simp +decide [fourierNormFactor_sq_mul_card]

/-- Forward after inverse normalized product DFT is the identity. -/
theorem fourier_inverseFourier {L : Nat} [NeZero L]
    (phi : Position L -> Vec4) :
    fourier (inverseFourier phi) = phi := by
  unfold fourier inverseFourier rawFourier
  ext k a
  simp +decide [Finset.mul_sum _ _ _, mul_left_comm]
  have h_sum :
      ∑ x : Position L,
          ∑ ell : Position L,
            planeWave ell x * star (planeWave k x) * phi ell a =
        ∑ ell : Position L,
          (if ell = k then (siteCard L : Complex) else 0) * phi ell a := by
    rw [Finset.sum_comm, Finset.sum_congr rfl]
    intro ell _
    rw [← Finset.sum_mul _ _ _, planeWave_row_orthogonality]
  convert congr_arg
    (fun x : Complex => x * (fourierNormFactor L : Complex) ^ 2) h_sum using 1 <;>
    ring
  · simp +decide only [starRingEnd_apply, mul_assoc, mul_left_comm,
      Finset.mul_sum _ _ _]
  · have hnorm := fourierNormFactor_sq_mul_card L
    norm_cast at *
    simp_all +decide [mul_assoc, mul_comm, mul_left_comm]
    norm_num [show (fourierNormFactor L : Complex) ^ 2 * siteCard L = 1 by
      norm_cast
      linear_combination' hnorm]

/-- The normalized product DFT preserves the finite squared norm exactly. -/
theorem fourier_parseval {L : Nat} [NeZero L] (psi : State L) :
    momentumNormSq (fourier psi) = positionNormSq psi := by
  unfold momentumNormSq positionNormSq
  have h_ortho : ∀ k : Position L,
      ∑ a : Internal, normSq (fourier psi k a) =
        (fourierNormFactor L : ℝ) ^ 2 *
          ∑ p : Position L, ∑ q : Position L,
            star (planeWave k p) * planeWave k q *
              ∑ a : Internal, psi p a * star (psi q a) := by
    intro k
    have h_expand :
        ∑ a : Internal, normSq (fourier psi k a) =
          (fourierNormFactor L : ℝ) ^ 2 *
            ∑ a : Internal,
              (∑ p : Position L, star (planeWave k p) * psi p a) *
                (∑ q : Position L, planeWave k q * star (psi q a)) := by
      simp +decide [Complex.normSq, fourier]
      rw [Finset.mul_sum _ _ _]
      congr
      ext
      simp +decide [Complex.ext_iff, sq]
      ring
      unfold rawFourier
      norm_num [Complex.ext_iff, Finset.sum_add_distrib,
        Finset.mul_sum _ _ _, Finset.sum_mul _ _ _]
      ring
      norm_num
    rw [h_expand]
    simp +decide only [Finset.sum_mul _ _ _, Finset.mul_sum, mul_left_comm,
      mul_comm]
    exact Finset.sum_comm.trans
      (Finset.sum_congr rfl fun _ _ => Finset.sum_comm.trans
        (Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by
          ring))
  have h_ortho_simplified :
      ∑ k : Position L, ∑ p : Position L, ∑ q : Position L,
          star (planeWave k p) * planeWave k q *
            ∑ a : Internal, psi p a * star (psi q a) =
        ∑ p : Position L, ∑ a : Internal,
          psi p a * star (psi p a) * (siteCard L : ℂ) := by
    have hcols : ∀ p q : Position L,
        ∑ k : Position L, star (planeWave k p) * planeWave k q =
          if p = q then (siteCard L : ℂ) else 0 := by
      intro p q
      convert planeWave_column_orthogonality p q using 1
    rw [Finset.sum_comm, Finset.sum_congr rfl fun _ _ => Finset.sum_comm]
    simp +decide only [← Finset.sum_mul, hcols]
    simp +decide [Finset.sum_ite, Finset.filter_eq, Finset.filter_ne,
      mul_comm, Finset.mul_sum _ _ _]
  have hnorm : (fourierNormFactor L : ℝ) ^ 2 * (siteCard L : ℝ) = 1 := by
    convert fourierNormFactor_sq_mul_card L using 1
    ring
  push_cast [← @Complex.ofReal_inj] at *
  simp_all +decide [← Finset.mul_sum _ _ _, ← Finset.sum_mul,
    Complex.mul_conj, Complex.normSq_eq_norm_sq]
  linear_combination' hnorm *
    ∑ i : Position L, ∑ a : Internal, (‖psi i a‖ : ℂ) ^ 2

/-- The normalized DFT is linear over finite sums. -/
theorem fourier_sum {L : Nat} [NeZero L] {ι : Type*}
    (s : Finset ι) (f : ι -> State L) (k : Position L) :
    fourier (∑ i ∈ s, f i) k = ∑ i ∈ s, fourier (f i) k := by
  ext a
  unfold fourier rawFourier
  simp +decide [Finset.mul_sum _ _ _, mul_assoc, mul_left_comm,
    Finset.sum_mul]
  exact Finset.sum_comm

/-- The live local step is linear over finite state sums. -/
theorem localStep_sum {L : Nat} {ι : Type*}
    (m eps : Real) (s : Finset ι) (f : ι -> State L) :
    Local3Plus1RateBridge.localStep m eps (∑ i ∈ s, f i) =
      ∑ i ∈ s, Local3Plus1RateBridge.localStep m eps (f i) := by
  unfold Local3Plus1RateBridge.localStep
    CliffordDiagonalPositionBridge.cliffordAxisShift
    SuccessiveAxisPositionWalk.pointwiseCoin
    SuccessiveAxisPositionWalk.conditionalShift
  simp +decide [*, Matrix.mulVec_add, Matrix.mulVec_smul,
    Finset.sum_add_distrib]
  ext p
  simp +decide [Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _]
  simp +decide only [← Finset.sum_product']
  refine Finset.sum_bij
    (fun x _ => (x.2.2.2.2, x.1, x.2.1, x.2.2.1, x.2.2.2.1)) ?_ ?_ ?_ ?_ <;>
    simp +decide
  grobner

/-- The normalized transform of one plane-wave mode is supported at its exact
momentum label. -/
theorem fourier_modeState {L : Nat} [NeZero L]
    (k ell : Position L) (v : Vec4) :
    fourier (modeState k v) ell =
      ((fourierNormFactor L : Complex) *
        (if k = ell then (siteCard L : Complex) else 0)) • v := by
  ext a
  simp [fourier, rawFourier, modeState]
  convert congr_arg
    (fun x : Complex => (fourierNormFactor L : Complex) * x * v a)
    (planeWave_row_orthogonality k ell) using 1 <;> ring
  · simp +decide [mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _]
  · split_ifs <;> ring

/-- Every finite state is exactly the normalized sum of its plane-wave modes. -/
theorem state_eq_sum_modeState {L : Nat} [NeZero L] (psi : State L) :
    psi = ∑ q : Position L,
      modeState q (fun a =>
        (fourierNormFactor L : Complex) * fourier psi q a) := by
  convert (Eq.symm <| inverseFourier_fourier psi) using 1
  unfold inverseFourier modeState
  ext
  simp +decide [Finset.mul_sum _ _ _, mul_assoc, mul_comm, mul_left_comm]

/-- The normalized DFT exactly conjugates the live local walk to its finite
momentum symbol. -/
theorem fourier_localStep {L : Nat} [NeZero L]
    (m eps : Real) (psi : State L) (k : Position L) :
    fourier (Local3Plus1RateBridge.localStep m eps psi) k =
      (finiteLocalSymbol m eps k).mulVec (fourier psi k) := by
  conv_lhs => rw [state_eq_sum_modeState psi]
  rw [localStep_sum, fourier_sum]
  simp_rw [Finite3Plus1FourierBridge.localStep_mode, fourier_modeState]
  ext a
  simp only [Finset.sum_apply, ite_apply, Pi.smul_apply, Pi.zero_apply,
    Finset.sum_ite_eq', Finset.mem_univ, if_true]
  simp [Matrix.mulVec, dotProduct]
  have hsum :
      (∑ x : Internal,
        finiteLocalSymbol m eps k a x *
          ((fourierNormFactor L : ℂ) * fourier psi k x)) =
        (fourierNormFactor L : ℂ) *
          ∑ x : Internal,
            finiteLocalSymbol m eps k a x * fourier psi k x := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro x _
    ring
  have hnormC : (fourierNormFactor L : ℂ) ^ 2 * (siteCard L : ℂ) = 1 := by
    have hprod :
        (fourierNormFactor L : ℂ) * (fourierNormFactor L : ℂ) *
          (siteCard L : ℂ) = 1 := by
      exact_mod_cast fourierNormFactor_sq_mul_card L
    simpa [pow_two] using hprod
  rw [hsum]
  calc
    (fourierNormFactor L : ℂ) * (siteCard L : ℂ) *
          ((fourierNormFactor L : ℂ) *
            ∑ x : Internal,
              finiteLocalSymbol m eps k a x * fourier psi k x) =
        ((fourierNormFactor L : ℂ) ^ 2 * (siteCard L : ℂ)) *
          ∑ x : Internal,
            finiteLocalSymbol m eps k a x * fourier psi k x := by ring
    _ = ∑ x : Internal,
          finiteLocalSymbol m eps k a x * fourier psi k x := by
      rw [hnormC, one_mul]

/-- The live local step factors exactly through the normalized DFT and the
pointwise finite character block. -/
theorem localStep_eq_inverseFourier_symbol {L : Nat} [NeZero L]
    (m eps : Real) (psi : State L) :
    Local3Plus1RateBridge.localStep m eps psi =
      inverseFourier (fun k =>
        (finiteLocalSymbol m eps k).mulVec (fourier psi k)) := by
  rw [← inverseFourier_fourier
    (Local3Plus1RateBridge.localStep m eps psi)]
  congr
  funext k
  exact fourier_localStep m eps psi k

/-- Every finite number of live time steps is exactly the corresponding power
of the momentum block after Fourier transform. -/
theorem fourier_localStep_iterate {L : Nat} [NeZero L]
    (m eps : Real) (n : Nat) (psi : State L) (k : Position L) :
    fourier ((Local3Plus1RateBridge.localStep m eps)^[n] psi) k =
      ((finiteLocalSymbol m eps k) ^ n).mulVec (fourier psi k) := by
  induction n generalizing psi with
  | zero => simp
  | succ n ih =>
      rw [Function.iterate_succ_apply, ih, fourier_localStep, pow_succ,
        Matrix.mulVec_mulVec]

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.LiveDFTComposition.inverseFourier_fourier' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms inverseFourier_fourier

/-- info: 'PhysicsSM.Draft.NullEdge.LiveDFTComposition.fourier_inverseFourier' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_inverseFourier

/-- info: 'PhysicsSM.Draft.NullEdge.LiveDFTComposition.fourier_modeState' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_modeState

/-- info: 'PhysicsSM.Draft.NullEdge.LiveDFTComposition.fourier_parseval' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_parseval

/-- info: 'PhysicsSM.Draft.NullEdge.LiveDFTComposition.fourier_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_sum

/-- info: 'PhysicsSM.Draft.NullEdge.LiveDFTComposition.localStep_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms localStep_sum

/-- info: 'PhysicsSM.Draft.NullEdge.LiveDFTComposition.state_eq_sum_modeState' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms state_eq_sum_modeState

/-- info: 'PhysicsSM.Draft.NullEdge.LiveDFTComposition.fourier_localStep' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_localStep

/-- info: 'PhysicsSM.Draft.NullEdge.LiveDFTComposition.localStep_eq_inverseFourier_symbol' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms localStep_eq_inverseFourier_symbol

/-- info: 'PhysicsSM.Draft.NullEdge.LiveDFTComposition.fourier_localStep_iterate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_localStep_iterate

end PhysicsSM.Draft.NullEdge.LiveDFTComposition
