import Mathlib

/-!
# Antiperiodic two-tick pi dilation

The untwisted compact-auxiliary dilation of `NullDilationConditionedShift.Core`
is exact, but degenerates in its zero-momentum block: there the auxiliary phase
is one and the complementary branch is held.  This file tests the smallest
twisted escape from that zero-mode obstruction.

On a two-site compact register `Fin 2` we use an **antiperiodic** (twisted)
translation `T`: it is a fixed-point-free coordinate swap carrying a wrap phase
`-1`, so that `T ^ 2 = -I`.  Two fine ticks then move the auxiliary branch on
*both* ticks and decode it into an explicit quasienergy-pi phase `-1`, rather
than the identity that the untwisted register produced.

## Theorem ladder

1. `T`, `T_unitary`, `T_sq` (`T * T = -1`), `T_no_fixed` (no nonzero fixed
   vector).
2. `T_mulVec_realspace`, `twistPerm_fixedpointfree`, `twistPhase_nontrivial`:
   the real-space coordinate permutation is the fixed-point-free swap, cleanly
   separated from the nontrivial boundary phase.
3. `microTwist` fine tick: moves `P` physically and applies `T` to the
   auxiliary `Q` register; `microTwist_inner_preserving` (inner-product
   preservation) and
   `microTwist_moves` (an explicit nonzero all-moving witness).
4. `microTwist_two_tick`: two fine ticks decode exactly to a two-step physical
   translation on `P` and `-1` on `Q`, with all cross terms zero.
5. `no_untwisted_zero_mode`: the two-tick auxiliary operator is `-I`, whose
   only eigenvalue is `-1`; there is **no** `+1` (untwisted zero-mode) block.
   Stated as an exact finite spectral claim.
6. Standard-three assumption-footprint guards and
   `microTwist_pi_phase_witness`.

## Semantic boundary

This is a scoped escape from the untwisted auxiliary zero-mode obstruction.  It
is a purely algebraic finite-dimensional construction.  It does **not** compose
the eight HNU spin-projector substeps, prove a three-dimensional winding number,
establish a global zero-plus-pi anomaly ledger, derive a physical compact
dimension, or exhibit primitive spacetime-null soldering.  A twisted auxiliary
edge is not automatically a physical null edge; no 3+1 completion is claimed.

Provenance: clean-room integration of Aristotle project
`6f1114f3-e46c-4282-8c51-a81803ec62e1`, independently reviewed by interactive
Claude/Opus on 2026-07-13. The proof body is retained from the approved
Mathlib-only candidate; namespace and documentation are adapted to this repo.
-/

namespace PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation

open Matrix

noncomputable section

/-- Internal spin space. -/
abbrev Spin := Fin 2 → Complex

/-- A state has a physical position `X`, a compact auxiliary site `Fin 2`, and
an internal spin. -/
def State (X : Type) := X → Fin 2 → Spin

/-! ## Step 1: the antiperiodic twisted shift `T` -/

/-- The antiperiodic (twisted) translation on the two-site compact register:
`T e₀ = e₁`, `T e₁ = -e₀`.  The wrap from site `1` back to site `0` carries the
phase `-1`. -/
def T : Matrix (Fin 2) (Fin 2) Complex := !![0, -1; 1, 0]

/-- `T` is unitary. -/
lemma T_unitary : T.conjTranspose * T = 1 ∧ T * T.conjTranspose = 1 := by
  constructor <;>
    (ext i j; fin_cases i <;> fin_cases j <;>
      simp [T, Matrix.mul_apply, Fin.sum_univ_two, Matrix.conjTranspose_apply])

/-- Two twisted ticks give the antiperiodic wrap `-I`. -/
lemma T_sq : T * T = -1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [T, Matrix.mul_apply, Fin.sum_univ_two]

/-- `T` has no nonzero fixed vector: `1` is not an eigenvalue. -/
lemma T_no_fixed : ∀ v : Fin 2 → Complex, T *ᵥ v = v → v = 0 := by
  intro v h
  have h0 := congrFun h 0
  have h1 := congrFun h 1
  simp only [T, Matrix.mulVec, Fin.sum_univ_two, dotProduct, Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.of_apply, Matrix.cons_val', Matrix.empty_val',
    Matrix.cons_val_fin_one, one_mul, zero_mul, neg_mul, add_zero, zero_add] at h0 h1
  have hv1 : v 1 = 0 := by linear_combination (-1/2 : ℂ) * h0 + (-1/2 : ℂ) * h1
  have hv0 : v 0 = 0 := by linear_combination h1 + hv1
  funext i; fin_cases i
  · exact hv0
  · exact hv1

/-! ## Step 2: real-space description -/

/-- The underlying coordinate permutation of the twisted shift: the swap. -/
def twistPerm : Fin 2 ≃ Fin 2 := Equiv.swap 0 1

/-- The boundary phase carried by the twisted shift. -/
def twistPhase : Fin 2 → Complex := ![-1, 1]

/-- Real-space form of `T`: coordinate motion by the swap, weighted by the
boundary phase. -/
lemma T_mulVec_realspace (v : Fin 2 → Complex) :
    ∀ i, (T *ᵥ v) i = twistPhase i * v (twistPerm i) := by
  intro i; fin_cases i <;>
    simp [T, twistPhase, twistPerm, Matrix.mulVec, Fin.sum_univ_two, dotProduct]

/-- The coordinate permutation underlying `T` is fixed-point-free. -/
lemma twistPerm_fixedpointfree : ∀ i, twistPerm i ≠ i := by
  intro i; fin_cases i <;> decide

/-- The boundary phase is genuinely nontrivial (a sign flip on the wrap): it is
not constant, distinguishing the twisted shift from a plain coordinate shift. -/
lemma twistPhase_nontrivial :
    twistPhase 0 = - twistPhase 1 ∧ twistPhase 0 ≠ twistPhase 1 := by
  refine ⟨by simp [twistPhase], by simp [twistPhase]; norm_num⟩

/-! ## Step 3: the fine tick and its auxiliary action -/

/-- Action of a `2×2` matrix on the compact auxiliary register of a
spin-valued state, spin component by spin component. -/
def auxApply (Tw : Matrix (Fin 2) (Fin 2) Complex) (f : Fin 2 → Spin) :
    Fin 2 → Spin :=
  fun a α => (Tw *ᵥ (fun b => f b α)) a

lemma auxApply_add (Tw : Matrix (Fin 2) (Fin 2) Complex) (f g : Fin 2 → Spin) :
    auxApply Tw (f + g) = auxApply Tw f + auxApply Tw g := by
  funext a α
  simp only [auxApply, Pi.add_apply]
  rw [show (fun b => f b α + g b α) = (fun b => f b α) + (fun b => g b α) from rfl,
    Matrix.mulVec_add, Pi.add_apply]

/-- Auxiliary action composes as matrix multiplication. -/
lemma auxApply_comp (Tw Uw : Matrix (Fin 2) (Fin 2) Complex) (f : Fin 2 → Spin) :
    auxApply Tw (auxApply Uw f) = auxApply (Tw * Uw) f := by
  funext a α
  simp only [auxApply]
  rw [← Matrix.mulVec_mulVec]

/-- The auxiliary action (on the compact register) commutes with a spin
operator applied pointwise. -/
lemma auxApply_mulVec_comm (Tw M : Matrix (Fin 2) (Fin 2) Complex)
    (f : Fin 2 → Spin) :
    auxApply Tw (fun b => M *ᵥ f b) = fun a => M *ᵥ auxApply Tw f a := by
  funext a α
  simp only [auxApply, Matrix.mulVec, dotProduct, Finset.mul_sum]
  rw [Finset.sum_comm]
  congr 1; funext b; congr 1; funext c; ring

/-- Applying the twist `T` twice to the auxiliary register is the `-1` (pi) phase. -/
lemma auxApply_T_sq (f : Fin 2 → Spin) : auxApply T (auxApply T f) = -f := by
  rw [auxApply_comp, T_sq]
  funext a α
  simp only [auxApply, Matrix.neg_mulVec, Matrix.one_mulVec, Pi.neg_apply]

/-- One fine tick: `P` moves physically along `tx`, while `Q` moves the compact
auxiliary register by the twisted shift `Tw`. -/
def microTwist {X : Type} (P Q : Matrix (Fin 2) (Fin 2) Complex)
    (tx : X ≃ X) (Tw : Matrix (Fin 2) (Fin 2) Complex) (psi : State X) : State X :=
  fun x a => P *ᵥ psi (tx.symm x) a + Q *ᵥ auxApply Tw (psi x) a

/-- The coarse two-step decode: `P` has translated twice, `Q` has picked up the
pi phase `-1`. -/
def coarseTwist {X : Type} (P Q : Matrix (Fin 2) (Fin 2) Complex)
    (tx : X ≃ X) (psi : State X) : State X :=
  fun x a => P *ᵥ psi (tx.symm (tx.symm x)) a - Q *ᵥ psi x a

/-- Aux-index unitarity of `T`: the twisted shift preserves the finite dot
product on the compact register. -/
lemma T_dot (u v : Fin 2 → Complex) :
    star (T *ᵥ u) ⬝ᵥ (T *ᵥ v) = star u ⬝ᵥ v := by
  rw [star_mulVec, dotProduct_mulVec, vecMul_vecMul, T_unitary.1, vecMul_one]

/-- Applying `T` to the compact auxiliary register preserves the aux-summed spin
inner product weighted by any spin operator `M`.  This is the auxiliary
counterpart of unitarity: the twist rotates the two aux sites into each other
with the wrap phase, an operation that leaves the total norm invariant. -/
lemma aux_unitary (M : Matrix (Fin 2) (Fin 2) Complex) (f g : Fin 2 → Spin) :
    (∑ a, star (auxApply T f a) ⬝ᵥ (M *ᵥ auxApply T g a))
      = ∑ a, star (f a) ⬝ᵥ (M *ᵥ g a) := by
  simp only [auxApply, dotProduct, Matrix.mulVec, Fin.sum_univ_two, Pi.star_apply,
    RCLike.star_def, T, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.of_apply,
    Matrix.cons_val', Matrix.empty_val', Matrix.cons_val_fin_one, one_mul, zero_mul,
    add_zero, zero_add, neg_mul, mul_neg, map_neg]
  ring

/-- One fine tick preserves the finite inner product, i.e. it is unitary, for
complementary Hermitian projectors `P, Q` (`P + Q = 1`), a bijective physical
shift `tx`, and the unitary twist `T`.

The hypotheses kept are those the proof actually needs: `P` Hermitian
idempotent, `Q` Hermitian, and completeness `P + Q = 1`.  Orthogonality
(`P * Q = Q * P = 0`) and idempotency of `Q` are *derivable* from these, so
they are omitted; the statement is thereby the exact complementary-projector
claim, only stated more economically. -/
theorem microTwist_inner_preserving {X : Type} [Fintype X]
    (P Q : Matrix (Fin 2) (Fin 2) Complex) (tx : X ≃ X)
    (hP : P.conjTranspose = P) (hQ : Q.conjTranspose = Q)
    (hPP : P * P = P)
    (hId : P + Q = 1)
    (psi phi : State X) :
    (∑ x, ∑ a, ∑ α,
      starRingEnd Complex (microTwist P Q tx T psi x a α) *
        microTwist P Q tx T phi x a α) =
    ∑ x, ∑ a, ∑ α, starRingEnd Complex (psi x a α) * phi x a α := by
  -- Orthogonality and idempotency of `Q` follow from completeness and `P`
  -- being a Hermitian idempotent (`Q = 1 - P`).
  have hQeq : Q = 1 - P := by rw [eq_sub_iff_add_eq, add_comm]; exact hId
  have hPQ : P * Q = 0 := by rw [hQeq, mul_sub, mul_one, hPP, sub_self]
  have hQP : Q * P = 0 := by rw [hQeq, sub_mul, one_mul, hPP, sub_self]
  have hQQ : Q * Q = Q := by
    have h : Q * Q = Q * (1 - P) := by rw [← hQeq]
    rw [h, mul_sub, mul_one, hQP, sub_zero]
  -- rewrite the innermost spin sum as a starred dot product
  have hdot : ∀ w1 w2 : Fin 2 → Complex,
      (∑ a, starRingEnd Complex (w1 a) * w2 a) = star w1 ⬝ᵥ w2 := by
    intro w1 w2; simp only [dotProduct, Pi.star_apply, starRingEnd_apply]
  -- cross terms vanish by Hermiticity and orthogonality
  have crossPQ : ∀ u v : Fin 2 → Complex, star (P *ᵥ u) ⬝ᵥ (Q *ᵥ v) = 0 := by
    intro u v
    rw [star_mulVec, dotProduct_mulVec, vecMul_vecMul, hP, hPQ, vecMul_zero,
      zero_dotProduct]
  have crossQP : ∀ u v : Fin 2 → Complex, star (Q *ᵥ u) ⬝ᵥ (P *ᵥ v) = 0 := by
    intro u v
    rw [star_mulVec, dotProduct_mulVec, vecMul_vecMul, hQ, hQP, vecMul_zero,
      zero_dotProduct]
  -- per-(x,a) evaluation: cross terms drop, diagonal terms use idempotence
  have hterm : ∀ x a,
      (∑ α, starRingEnd Complex (microTwist P Q tx T psi x a α) *
          microTwist P Q tx T phi x a α)
      = (star (psi (tx.symm x) a) ⬝ᵥ (P *ᵥ phi (tx.symm x) a))
        + (star (auxApply T (psi x) a) ⬝ᵥ (Q *ᵥ auxApply T (phi x) a)) := by
    intro x a
    rw [hdot]
    simp only [microTwist, star_add, add_dotProduct, dotProduct_add]
    rw [crossPQ, crossQP, add_zero, zero_add]
    rw [star_mulVec, star_mulVec, dotProduct_mulVec, dotProduct_mulVec,
      vecMul_vecMul, vecMul_vecMul, hP, hQ, hPP, hQQ, dotProduct_mulVec,
      dotProduct_mulVec]
  -- completeness splits the unshifted inner product into P and Q parts
  have hsplit : ∀ u v : Fin 2 → Complex,
      star u ⬝ᵥ v = star u ⬝ᵥ (P *ᵥ v) + star u ⬝ᵥ (Q *ᵥ v) := by
    intro u v
    rw [← dotProduct_add, ← add_mulVec, hId, one_mulVec]
  have hrhs : (∑ x, ∑ a, ∑ α, starRingEnd Complex (psi x a α) * phi x a α)
      = ∑ x, ∑ a, star (psi x a) ⬝ᵥ (phi x a) := by simp_rw [hdot]
  have hrhs2 : (∑ x, ∑ a, star (psi x a) ⬝ᵥ phi x a)
      = (∑ x, ∑ a, star (psi x a) ⬝ᵥ (P *ᵥ phi x a))
        + (∑ x, ∑ a, star (psi x a) ⬝ᵥ (Q *ᵥ phi x a)) := by
    rw [← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl (fun x _ => ?_)
    rw [← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl (fun a _ => hsplit (psi x a) (phi x a))
  rw [hrhs, hrhs2]
  simp_rw [hterm, Finset.sum_add_distrib]
  congr 1
  · -- physical branch: reindex the x-sum along the bijection tx
    exact Equiv.sum_comp tx.symm (fun x => ∑ a, star (psi x a) ⬝ᵥ (P *ᵥ phi x a))
  · -- auxiliary branch: T-unitarity on the compact register
    exact Finset.sum_congr rfl (fun x _ => aux_unitary Q (psi x) (phi x))

/-! ## Step 4: exact two-tick decode -/

/-- Two fine ticks decode exactly to a two-step physical translation on `P` and
the pi phase `-1` on `Q`, with all cross terms vanishing. -/
theorem microTwist_two_tick {X : Type} (P Q : Matrix (Fin 2) (Fin 2) Complex)
    (tx : X ≃ X)
    (hPP : P * P = P) (hQQ : Q * Q = Q)
    (hPQ : P * Q = 0) (hQP : Q * P = 0)
    (psi : State X) :
    microTwist P Q tx T (microTwist P Q tx T psi) = coarseTwist P Q tx psi := by
  funext x a
  change P *ᵥ (microTwist P Q tx T psi (tx.symm x) a)
      + Q *ᵥ auxApply T (microTwist P Q tx T psi x) a
      = P *ᵥ psi (tx.symm (tx.symm x)) a - Q *ᵥ psi x a
  have e1 : P *ᵥ (microTwist P Q tx T psi (tx.symm x) a)
      = P *ᵥ psi (tx.symm (tx.symm x)) a := by
    simp only [microTwist, Matrix.mulVec_add, Matrix.mulVec_mulVec, hPP, hPQ,
      Matrix.zero_mulVec, add_zero]
  have hsplit : (microTwist P Q tx T psi x)
      = (fun b => P *ᵥ psi (tx.symm x) b)
        + (fun b => Q *ᵥ auxApply T (psi x) b) := by
    funext b; simp only [microTwist, Pi.add_apply]
  have e2 : Q *ᵥ auxApply T (microTwist P Q tx T psi x) a = - (Q *ᵥ psi x a) := by
    rw [hsplit, auxApply_add, auxApply_mulVec_comm, auxApply_mulVec_comm]
    simp only [Pi.add_apply, Matrix.mulVec_add]
    rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, hQP, Matrix.zero_mulVec,
      zero_add, hQQ, auxApply_T_sq]
    simp only [Pi.neg_apply, Matrix.mulVec_neg]
  rw [e1, e2, sub_eq_add_neg]

/-! ## Step 5: exact finite spectral no-zero-mode claim -/

/-- The two-tick auxiliary operator `T * T = -I` has no `+1` eigenvector: there
is no untwisted zero-mode block.  (Contrast the untwisted register, whose
two-tick operator is `+I` with a full `+1` block.) -/
theorem no_untwisted_zero_mode :
    ∀ v : Fin 2 → Complex, (T * T) *ᵥ v = v → v = 0 := by
  intro v h
  rw [T_sq, Matrix.neg_mulVec, Matrix.one_mulVec] at h
  funext i
  have hi := congrFun h i
  simp only [Pi.neg_apply] at hi
  have h2 : v i = 0 := by linear_combination (-(1:ℂ)/2) * hi
  simpa using h2

/-! ## Step 6: complementary projectors and nonzero all-moving witnesses -/

/-- Top diagonal rank-one spin projector. -/
def projTop : Matrix (Fin 2) (Fin 2) Complex := !![1, 0; 0, 0]

/-- Complementary bottom diagonal rank-one spin projector. -/
def projBot : Matrix (Fin 2) (Fin 2) Complex := !![0, 0; 0, 1]

/-- `projTop, projBot` are nonzero complementary Hermitian orthogonal
idempotents. -/
theorem proj_facts :
    (projTop.conjTranspose = projTop) ∧ (projBot.conjTranspose = projBot) ∧
    (projTop * projTop = projTop) ∧ (projBot * projBot = projBot) ∧
    (projTop * projBot = 0) ∧ (projBot * projTop = 0) ∧
    (projTop + projBot = 1) ∧ (projTop ≠ 0) ∧ (projBot ≠ 0) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [projTop, Matrix.conjTranspose_apply]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [projBot, Matrix.conjTranspose_apply]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [projTop, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [projBot, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [projTop, projBot, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [projTop, projBot, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j; fin_cases i <;> fin_cases j <;> simp [projTop, projBot]
  · intro h; have := congrFun (congrFun h 0) 0; simp [projTop] at this
  · intro h; have := congrFun (congrFun h 1) 1; simp [projBot] at this

/-- Explicit nonzero all-moving witness on `Fin 2` physical positions with the
swap `sw` as physical shift.  Starting from a state supported at physical/aux
site `(0,0)` with spin `![1,1]`, the first fine tick moves the physical (`P`)
sector to site `x = 1` and moves the auxiliary (`Q`) sector to site `a = 1`,
while vacating the original site `(0,0)`. -/
theorem microTwist_moves :
    let sw : Fin 2 ≃ Fin 2 := Equiv.swap 0 1
    let psi : State (Fin 2) :=
      fun x a => if x = 0 ∧ a = 0 then (![1, 1] : Spin) else 0
    (microTwist projTop projBot sw T psi 1 0 ≠ 0) ∧
    (microTwist projTop projBot sw T psi 0 1 ≠ 0) ∧
    (microTwist projTop projBot sw T psi 0 0 = 0) := by
  intro sw psi
  refine ⟨?_, ?_, ?_⟩
  · intro hcon
    have h0 := congrFun hcon 0
    simp [microTwist, auxApply, projTop, projBot, T, psi, sw, Matrix.mulVec,
      dotProduct, vecHead, vecTail] at h0
  · intro hcon
    have h1 := congrFun hcon 1
    simp [microTwist, auxApply, projTop, projBot, T, psi, sw, Matrix.mulVec,
      dotProduct] at h1
  · funext α
    fin_cases α <;>
    simp [microTwist, auxApply, projTop, projBot, T, psi, sw, Matrix.mulVec,
      dotProduct]

/-- Explicit pi-phase witness: after two fine ticks the auxiliary (`Q`) sector
carries the phase `-1`.  Here the spin-`1` component at site `(0,0)` reads `-1`,
while the physical (`P`) spin-`0` component reads `1`. -/
theorem microTwist_pi_phase_witness :
    let sw : Fin 2 ≃ Fin 2 := Equiv.swap 0 1
    let psi : State (Fin 2) :=
      fun x a => if x = 0 ∧ a = 0 then (![1, 1] : Spin) else 0
    (microTwist projTop projBot sw T (microTwist projTop projBot sw T psi) 0 0 1
        = -1) ∧
    (microTwist projTop projBot sw T (microTwist projTop projBot sw T psi) 0 0 0
        = 1) := by
  intro sw psi
  constructor <;>
  · simp [microTwist, auxApply, projTop, projBot, T, psi, sw, Matrix.mulVec,
      dotProduct, Fin.sum_univ_two, vecHead, vecTail]

end

/-! ## Standard-three assumption-footprint guards

Every result depends only on `propext`, `Classical.choice`, `Quot.sound`. -/

/-- info: 'PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.T_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.T_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.T_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.T_sq

/-- info: 'PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.T_no_fixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.T_no_fixed

/-- info: 'PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.T_mulVec_realspace' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.T_mulVec_realspace

/-- info: 'PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.microTwist_inner_preserving' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.microTwist_inner_preserving

/-- info: 'PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.microTwist_two_tick' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.microTwist_two_tick

/-- info: 'PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.no_untwisted_zero_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.no_untwisted_zero_mode

/-- info: 'PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.microTwist_moves' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.microTwist_moves

/-- info: 'PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.microTwist_pi_phase_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation.microTwist_pi_phase_witness

end PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation
