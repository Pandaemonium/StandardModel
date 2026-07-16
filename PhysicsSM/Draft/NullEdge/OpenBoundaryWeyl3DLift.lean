import PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift
import PhysicsSM.Draft.NullEdge.OpenDiamondCausalExhaustion

/-!
# Three-dimensional Pauli lift of the reflecting boundary-memory QCA

This module lifts the one-dimensional reflecting boundary-memory shift of
`OpenBoundaryReflectingShift.lean` to a strictly local three-dimensional unitary that
carries an internal two-component (Weyl) spinor, coupled to the three spatial
translations through the three Pauli matrices.

## Architecture (an explicit small three-coordinate register)

The register is
```
Reg N := (State N × State N × State N) × Fin 2
```
i.e. three independent copies of the one-dimensional reflecting shift (one per
spatial axis `x, y, z`, each a `Bool`-channel/`Fin (N+1)`-site pair) tensored
with a single two-dimensional spinor `Fin 2`.  It uses one internal qubit and
one memory channel per axis.  No minimality or continuum-tangent theorem is
claimed for this register.

## Ordered update (one strict time step)

```
U₃ := coinZ ∘ shiftZ ∘ coinY ∘ shiftY ∘ coinX ∘ shiftX
```
where `shiftA` is the *spinor-conditioned* reflecting shift along axis `A`
(advance the right channel / retreat the left channel when the spinor bit is
`0`, run the exact inverse substep when it is `1`), and `coinA = 1 ⊗ σ_A` is the
Pauli coin along axis `A`.  Each `shiftA` is a permutation of the register
(hence its matrix is unitary); each `coinA` is a Kronecker product of unitaries
(hence unitary).  The interleaving of the Pauli coins between the conditioned
shifts is what couples the spinor to the three coordinate updates.  A
decoupled `coin ⊗ shift` product would instead leave those two actions
factorized.  A momentum-space origin tangent is not computed in this module.

## What is proved here

* Every Pauli/coin matrix is exhibited and shown unitary and Hermitian, with
  the full Clifford algebra and the oriented product `σx σy σz = i·1`
  (a finite algebraic orientation sign, not a momentum-space charge).
* `U₃` is *exactly* unitary (an exact finite factorization — not a Hamiltonian
  exponential).
* Each conditioned shift moves each position coordinate by at most one edge
  (strict locality, giving a depth-`t` causal cone).
* Interior equality is inherited from
  `OpenDiamondCausalExhaustion.evolveAlong_eq_on_head`.
* Bare-boundary control: the one-dimensional reflecting permutation is a
  single transitive cycle, so **its** eigenvectors have constant magnitude
  across that one-dimensional register.  This rules out localization for the
  bare reflecting shift only; it does not classify the spectrum of `U₃`.

## Scope (explicit no-go boundary)

Exact unitarity, strict locality, and finite-time interior equality are proved.
This does **not** establish spectral single-species: finite-time causal
inaccessibility of the boundary is *not* spectral elimination of surface modes.
The remaining assumptions needed for a physical single-Weyl claim include a scaling
schedule in which the boundary distance grows faster than the observation time
(the exhaustion limit) and a proved continuum Weyl tangent. Neither is proved here.

Provenance: Aristotle job `6ef617a4-a5a1-4d57-8a13-b9484257ce94`, adapted to
the live project namespaces. The Pauli orientation identity below is finite
Clifford algebra; it is not itself a momentum derivative or topological charge.
-/

noncomputable section

open Matrix PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift
open scoped Kronecker

namespace PhysicsSM.Draft.NullEdge.OpenBoundaryWeyl3DLift

/-- Three spatial copies of the reflecting-shift state. -/
abbrev State3 (N : Nat) := State N × State N × State N

/-- Full register: three axis copies and one two-component spinor. -/
abbrev Reg (N : Nat) := State3 N × Fin 2

/-! ## Pauli / coin matrices -/

/-- Pauli `σx`. -/
def pauliX : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- Pauli `σy`. -/
def pauliY : Matrix (Fin 2) (Fin 2) ℂ := !![0, -Complex.I; Complex.I, 0]

/-- Pauli `σz`. -/
def pauliZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

theorem pauliX_unitary : pauliX ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  rw [Matrix.mem_unitaryGroup_iff]; ext i j; fin_cases i <;> fin_cases j <;>
    simp [pauliX, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply,
      Matrix.star_eq_conjTranspose, Matrix.conjTranspose_apply]
theorem pauliY_unitary : pauliY ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  rw [Matrix.mem_unitaryGroup_iff]; ext i j; fin_cases i <;> fin_cases j <;>
    simp [pauliY, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply,
      Matrix.star_eq_conjTranspose, Matrix.conjTranspose_apply]
theorem pauliZ_unitary : pauliZ ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  rw [Matrix.mem_unitaryGroup_iff]; ext i j; fin_cases i <;> fin_cases j <;>
    simp [pauliZ, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply,
      Matrix.star_eq_conjTranspose, Matrix.conjTranspose_apply]

theorem pauliX_herm : pauliXᴴ = pauliX := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [pauliX, Matrix.conjTranspose_apply]
theorem pauliY_herm : pauliYᴴ = pauliY := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [pauliY, Matrix.conjTranspose_apply]
theorem pauliZ_herm : pauliZᴴ = pauliZ := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [pauliZ, Matrix.conjTranspose_apply]

theorem pauliX_sq : pauliX * pauliX = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [pauliX, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply]
theorem pauliY_sq : pauliY * pauliY = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [pauliY, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply]
theorem pauliZ_sq : pauliZ * pauliZ = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [pauliZ, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply]

/-- The three Pauli matrices anticommute pairwise. -/
theorem pauli_anticomm_xy : pauliX * pauliY + pauliY * pauliX = 0 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [pauliX, pauliY, Matrix.mul_apply, Fin.sum_univ_two, Matrix.add_apply]
theorem pauli_anticomm_yz : pauliY * pauliZ + pauliZ * pauliY = 0 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [pauliY, pauliZ, Matrix.mul_apply, Fin.sum_univ_two, Matrix.add_apply]
theorem pauli_anticomm_zx : pauliZ * pauliX + pauliX * pauliZ = 0 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [pauliZ, pauliX, Matrix.mul_apply, Fin.sum_univ_two, Matrix.add_apply]

/-- Oriented Pauli triple product with sign `+i`.

This is a finite Clifford-algebra orientation identity.  Calling it a Weyl
charge additionally requires a momentum-dependent tangent or degree theorem,
which is not supplied here. -/
theorem pauli_orientation : pauliX * pauliY * pauliZ = Complex.I • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [pauliX, pauliY, pauliZ, Matrix.mul_apply, Fin.sum_univ_two]

/-! ## Spinor-conditioned reflecting shift, per axis -/

/-- Conditioned one-axis substep: the forward substep on spinor bit `0`, its
exact inverse on spinor bit `1`. -/
def cstep {N : Nat} (c : Fin 2) (s : State N) : State N :=
  if c = 0 then step s else stepInv s

/-- Inverse of `cstep`. -/
def cstepInv {N : Nat} (c : Fin 2) (s : State N) : State N :=
  if c = 0 then stepInv s else step s

theorem cstepInv_cstep {N : Nat} (c : Fin 2) (s : State N) :
    cstepInv c (cstep c s) = s := by
      fin_cases c <;> simp +decide [ cstep, cstepInv, stepInv_step, step_stepInv ]

theorem cstep_cstepInv {N : Nat} (c : Fin 2) (s : State N) :
    cstep c (cstepInv c s) = s := by
      fin_cases c <;> simp +decide [ cstep, cstepInv, stepInv_step, step_stepInv ]

/-- Conditioned reflecting shift along axis `x` as a register permutation. -/
def shiftXEquiv (N : Nat) : Equiv.Perm (Reg N) where
  toFun := fun r => (((cstep r.2 r.1.1), r.1.2.1, r.1.2.2), r.2)
  invFun := fun r => (((cstepInv r.2 r.1.1), r.1.2.1, r.1.2.2), r.2)
  left_inv := by rintro ⟨⟨sx, sy, sz⟩, c⟩; simp only [cstepInv_cstep]
  right_inv := by rintro ⟨⟨sx, sy, sz⟩, c⟩; simp only [cstep_cstepInv]

/-- Conditioned reflecting shift along axis `y`. -/
def shiftYEquiv (N : Nat) : Equiv.Perm (Reg N) where
  toFun := fun r => ((r.1.1, (cstep r.2 r.1.2.1), r.1.2.2), r.2)
  invFun := fun r => ((r.1.1, (cstepInv r.2 r.1.2.1), r.1.2.2), r.2)
  left_inv := by rintro ⟨⟨sx, sy, sz⟩, c⟩; simp only [cstepInv_cstep]
  right_inv := by rintro ⟨⟨sx, sy, sz⟩, c⟩; simp only [cstep_cstepInv]

/-- Conditioned reflecting shift along axis `z`. -/
def shiftZEquiv (N : Nat) : Equiv.Perm (Reg N) where
  toFun := fun r => ((r.1.1, r.1.2.1, (cstep r.2 r.1.2.2)), r.2)
  invFun := fun r => ((r.1.1, r.1.2.1, (cstepInv r.2 r.1.2.2)), r.2)
  left_inv := by rintro ⟨⟨sx, sy, sz⟩, c⟩; simp only [cstepInv_cstep]
  right_inv := by rintro ⟨⟨sx, sy, sz⟩, c⟩; simp only [cstep_cstepInv]

/-! ## The three-dimensional update matrix -/

/-- Coin matrix along an axis: `1 ⊗ σ` on the register. -/
def coinMat (N : Nat) (σ : Matrix (Fin 2) (Fin 2) ℂ) :
    Matrix (Reg N) (Reg N) ℂ :=
  (1 : Matrix (State3 N) (State3 N) ℂ) ⊗ₖ σ

/-- Shift matrix along an axis (permutation matrix of the conditioned shift). -/
def shiftMat (N : Nat) (e : Equiv.Perm (Reg N)) : Matrix (Reg N) (Reg N) ℂ :=
  e.permMatrix ℂ

/-- The strict one-step three-dimensional update. -/
def U3 (N : Nat) : Matrix (Reg N) (Reg N) ℂ :=
  coinMat N pauliZ * shiftMat N (shiftZEquiv N) *
  (coinMat N pauliY * shiftMat N (shiftYEquiv N) *
  (coinMat N pauliX * shiftMat N (shiftXEquiv N)))

/-
Helper: a permutation matrix is unitary.
-/
theorem permMatrix_unitary {n : Type*} [DecidableEq n] [Fintype n]
    (σ : Equiv.Perm n) : σ.permMatrix ℂ ∈ Matrix.unitaryGroup n ℂ := by
      constructor;
      · ext i j;
        simp +decide [ Matrix.mul_apply, Equiv.Perm.permMatrix ];
        simp +decide [ Matrix.one_apply, Finset.sum_ite ];
        split_ifs <;> simp_all +decide [ Finset.filter_filter ];
        · exact Finset.card_eq_one.mpr ⟨ σ.symm j, by aesop ⟩;
        · tauto;
      · ext i j; simp +decide [ Matrix.mul_apply, Matrix.one_apply ] ;

/-- Helper: the Kronecker product of two unitaries is unitary. -/
theorem kron_unitary {m p : Type*} [DecidableEq m] [Fintype m] [DecidableEq p]
    [Fintype p] (A : Matrix m m ℂ) (B : Matrix p p ℂ)
    (hA : A ∈ Matrix.unitaryGroup m ℂ) (hB : B ∈ Matrix.unitaryGroup p ℂ) :
    (A ⊗ₖ B) ∈ Matrix.unitaryGroup (m × p) ℂ :=
  Matrix.kronecker_mem_unitary hA hB

theorem coinMat_unitary (N : Nat) (σ : Matrix (Fin 2) (Fin 2) ℂ)
    (hσ : σ ∈ Matrix.unitaryGroup (Fin 2) ℂ) :
    coinMat N σ ∈ Matrix.unitaryGroup (Reg N) ℂ :=
  kron_unitary _ _ (one_mem _) hσ

theorem shiftMat_unitary (N : Nat) (e : Equiv.Perm (Reg N)) :
    shiftMat N e ∈ Matrix.unitaryGroup (Reg N) ℂ :=
  permMatrix_unitary e

/-- **Exact unitarity** of the three-dimensional lift. -/
theorem U3_unitary (N : Nat) : U3 N ∈ Matrix.unitaryGroup (Reg N) ℂ := by
  refine mul_mem (mul_mem (coinMat_unitary N pauliZ pauliZ_unitary)
    (shiftMat_unitary N (shiftZEquiv N))) ?_
  refine mul_mem (mul_mem (coinMat_unitary N pauliY pauliY_unitary)
    (shiftMat_unitary N (shiftYEquiv N))) ?_
  exact mul_mem (coinMat_unitary N pauliX pauliX_unitary)
    (shiftMat_unitary N (shiftXEquiv N))

/-! ## Strict locality / causal cone -/

/-- The position projection of the register on axis `x`. -/
def posX {N : Nat} (r : Reg N) : Fin (N + 1) := r.1.1.2

/-
Each conditioned shift moves the axis-`x` position by at most one edge.
-/
theorem shiftX_local {N : Nat} (r : Reg N) :
    Int.natAbs (((shiftXEquiv N) r).1.1.2.val - r.1.1.2.val) ≤ 1 := by
      rcases r with ⟨ ⟨ b, x ⟩, c ⟩ ; fin_cases c <;> simp +decide [ shiftXEquiv, cstep ] ;
      · exact PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift.step_local b;
      · rcases b with ⟨ b, x ⟩ ; fin_cases b <;> simp +decide [ stepInv, incClamp, decClamp ] ;
        · grind;
        · split_ifs <;> norm_num

/-
The coin does not move any position coordinate.
-/
theorem coinMat_diag_pos {N : Nat} (σ : Matrix (Fin 2) (Fin 2) ℂ)
    (r r' : Reg N) (h : coinMat N σ r r' ≠ 0) : r.1 = r'.1 := by
      contrapose! h;
      unfold coinMat; aesop;

/-! ## Interior equality (inherited from the causal-exhaustion module) -/

open PhysicsSM.Draft.NullEdge.OpenDiamondCausalExhaustion in
/-- **Interior equality.** For any bulk-declared update `B` that agrees with the
lifted update `U₃` on every backward causal layer of a chosen interior region,
the finite-time interior amplitudes coincide before the cone reaches the
boundary.  This is the three-dimensional instance of the generic finite
propagation theorem `evolveAlong_eq_on_head`. -/
theorem U3_interior_equality (N : Nat) (B : Matrix (Reg N) (Reg N) ℂ)
    (f g : Reg N → ℂ) (regions : List (Set (Reg N)))
    (hchain : CausalChain (U3 N) B f g regions) :
    ∀ i, i ∈ regions.headD ∅ →
      evolveAlong (U3 N) f regions i = evolveAlong B g regions i :=
  fun i hi => evolveAlong_eq_on_head (U3 N) B f g regions hchain i hi

/-! ## Bare reflecting-shift control: transitive cycle implies no localization -/

/-- Position of a one-dimensional reflecting-shift state around its cycle.
The orbit visits `(true,0),…,(true,N),(false,N),…,(false,0)` and returns. -/
def cyc {N : Nat} (s : State N) : Fin (2 * (N + 1)) :=
  match s with
  | (true, x) => ⟨x.val, by omega⟩
  | (false, x) => ⟨2 * N + 1 - x.val, by omega⟩

/-- `step` advances the cycle index by exactly one (mod `2(N+1)`). -/
theorem cyc_step {N : Nat} (s : State N) : cyc (step s) = cyc s + 1 := by
  unfold cyc step;
  rcases s with ⟨ _ | _, x ⟩ <;> simp +decide [ State, incClamp, decClamp ];
  · cases x using Fin.inductionOn <;> simp +decide [ Fin.ext_iff, Fin.val_add ];
    rw [ Nat.mod_eq_of_lt ] <;> omega;
  · split_ifs <;> simp_all +decide [ Fin.add_def, Nat.mod_eq_of_lt ];
    · omega;
    · rw [ Nat.mod_eq_of_lt ( by linarith ) ];
    · omega

/-- The cycle index is a bijection: the reflecting shift is a single
transitive cycle on all `2(N+1)` register states. -/
theorem cyc_bijective (N : Nat) : Function.Bijective (cyc (N := N)) := by
  refine' ⟨ _, _ ⟩;
  · intro s t h; rcases s with ⟨ b, x ⟩ ; rcases t with ⟨ b', y ⟩ ; cases b <;> cases b' <;> simp_all +decide [ cyc ] ;
    · exact Fin.ext ( by rw [ tsub_right_inj ] at h <;> linarith [ Fin.is_lt x, Fin.is_lt y ] );
    · omega;
    · omega;
    · grind +splitImp;
  · intro x;
    by_cases hx : x.val < N + 1;
    · use (true, ⟨x.val, by omega⟩);
      exact Fin.ext ( by simp +decide [ cyc ] );
    · use (false, ⟨2 * N + 1 - x.val, by omega⟩);
      exact Fin.ext ( by simp +decide [ cyc ] ; omega )

/-
Iterating `step` advances the cycle index by `k` (as `k` copies of the
generator `1`).
-/
theorem cyc_iterate {N : Nat} (k : Nat) (s : State N) :
    cyc (step^[k] s) = cyc s + k • (1 : Fin (2 * (N + 1))) := by
      induction' k with k ih generalizing s <;> simp_all +decide [ Function.iterate_succ_apply', add_smul, add_assoc ];
      cases s ; simp_all +decide [ ← add_assoc, cyc_step ];
      rename_i b x; cases b <;> simp_all +decide [ cyc_step ] ;

/-
The reflecting shift has period `2(N+1)` at every state.
-/
theorem step_period {N : Nat} (s : State N) : step^[2 * (N + 1)] s = s := by
  convert ( cyc_bijective N ).injective _;
  rw [ cyc_iterate ];
  norm_num [ two_mul, add_assoc ];
  convert card_nsmul_eq_zero ( G := Fin ( 2 * ( N + 1 ) ) ) ( x := ( 1 : Fin ( 2 * ( N + 1 ) ) ) ) using 1 ; norm_num [ Fintype.card_fin ] ; ring

/-- **Transitivity.** The reflecting shift is a single cycle: every state can be
reached from every other state by iterating `step`. -/
theorem step_transitive {N : Nat} (s t : State N) :
    ∃ k : Nat, step^[k] s = t := by
      have h_cycle : ∃ k : ℕ, k < 2 * (N + 1) ∧ cyc (step^[k] s) = cyc t := by
        have h_cycle : ∃ k : Fin (2 * (N + 1)), cyc (step^[k.val] s) = cyc t := by
          have h_cycle : ∀ x : Fin (2 * (N + 1)), ∃ k : Fin (2 * (N + 1)), cyc (step^[k] s) = x := by
            intro x
            have h_cycle : ∀ k : Fin (2 * (N + 1)), cyc (step^[k] s) = cyc s + k := by
              intro k; induction k; simp_all +decide [ Fin.add_def ] ;
              rename_i k hk;
              induction' k with k ih;
              · norm_num [ Fin.ext_iff, Nat.mod_eq_of_lt ];
              · rw [ Function.iterate_succ_apply', cyc_step, ih ( Nat.lt_of_succ_lt hk ) ] ; norm_num [ Fin.add_def, Nat.mod_eq_of_lt hk ] ; ring;
            exact ⟨ x - cyc s, by simp +decide [ h_cycle ] ⟩;
          exact h_cycle _;
        exact ⟨ _, Fin.is_lt h_cycle.choose, h_cycle.choose_spec ⟩;
      exact ⟨ h_cycle.choose, ( cyc_bijective N ).injective h_cycle.choose_spec.2 ⟩

/-
**Bare-shift accounting.** Any eigenvector `v` (with eigenvalue `lam`) of
the reflecting-shift permutation operator `v ∘ stepInv = lam • v` has constant
magnitude across the whole one-dimensional register.  Hence no eigenmode of
that bare permutation is boundary-localized.  This theorem does not apply
directly to the interleaved three-dimensional operator `U₃`, whose spectral
boundary analysis remains open.
-/
theorem eigen_uniform_magnitude {N : Nat} (v : State N → ℂ) (lam : ℂ)
    (hv : ∃ s, v s ≠ 0)
    (heig : ∀ s, v (stepInv s) = lam * v s) :
    ∀ s t, ‖v s‖ = ‖v t‖ := by
      -- By induction on $k$, we can show that $v(s) = lam^k * v(step^[k] s)$ for any $s$ and $k$.
      have h_ind : ∀ k : ℕ, ∀ s : State N, v s = lam^k * v (step^[k] s) := by
        have hfwd : ∀ x : State N, v x = lam * v (step x) := by
          intro x; have h := heig (step x); rwa [ stepInv_step ] at h
        intro k;
        induction' k with k ih;
        · norm_num;
        · intro s;
          rw [ Function.iterate_succ_apply', pow_succ, mul_assoc, ← hfwd, ih s ];
      -- Since `step` is a permutation, its order divides `2 * (N + 1)`, so `lam^(2 * (N + 1)) = 1`.
      have h_order : lam^(2 * (N + 1)) = 1 := by
        obtain ⟨ s, hs ⟩ := hv;
        specialize h_ind ( 2 * ( N + 1 ) ) s;
        rw [ step_period ] at h_ind ; exact mul_left_cancel₀ hs <| by linear_combination' h_ind.symm;
      -- Since `lam^(2 * (N + 1)) = 1`, we have `‖lam‖ = 1`.
      have h_norm : ‖lam‖ = 1 := by
        simpa [ pow_eq_one_iff_of_nonneg ] using congr_arg Norm.norm h_order;
      -- By induction on $k$, we can show that $‖v s‖ = ‖v (step^[k] s)‖$ for any $s$ and $k$.
      have h_norm_ind : ∀ k : ℕ, ∀ s : State N, ‖v s‖ = ‖v (step^[k] s)‖ := by
        intro k s; specialize h_ind k s; replace h_ind := congr_arg Norm.norm h_ind; simp_all +decide ;
      intro s t; obtain ⟨ k, hk ⟩ := step_transitive s t; specialize h_norm_ind k s; aesop;

/-! ### Build-enforced standard-axiom reports -/

/-- info: 'PhysicsSM.Draft.NullEdge.OpenBoundaryWeyl3DLift.U3_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms U3_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.OpenBoundaryWeyl3DLift.U3_interior_equality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms U3_interior_equality

/-- info: 'PhysicsSM.Draft.NullEdge.OpenBoundaryWeyl3DLift.eigen_uniform_magnitude' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms eigen_uniform_magnitude

end PhysicsSM.Draft.NullEdge.OpenBoundaryWeyl3DLift
