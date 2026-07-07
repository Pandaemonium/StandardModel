import Mathlib

/-!
# Q11: top-form-duality real structure on `Λ(C^5)`

This module is the audited L1/L2-core lane for the Q11 construction.  It
formalizes, as finite linear algebra on the `32`-dimensional exterior basis
indexed by `Finset (Fin 5)`, the sign-table and charge-arithmetic claims for
the antilinear real structure

`J_R (lambda e_S) = conjugate(lambda) * sigma(S) * e_{S^c}`.

Here `sigma(S)` is not postulated from a closed formula.  It is defined as the
genuine top-form interleaving sign: the coefficient of `e_S wedge e_{S^c}` in
the top basis vector.  The closed formula is then proved against that
permutation definition.

The finite results landed here are:

* `JR_involutive`: `J_R^2 = +1`.
* `JR_parity_anticomm`: `J_R` anticommutes with fermion parity.
* `Btop_eq_Bstd`: the top-form-duality pairing equals the standard positive
  Hermitian metric, so the internal fiber is Hilbert rather than Krein.
* `JR_num_particle_hole`: `J_R N_i J_R = 1 - N_i`.
* `JR_charge_master`: `J_R Q J_R = trace(Q) * 1 - Q` for a real diagonal
  charge `Q = sum_i c_i N_i`.
* `even_dim_breaks_JR_sq`: the corresponding dimension-four sign table has a
  witness with square `-1`, so oddness of `5` is load-bearing.

Claim boundary: this proves the finite fiber sign and Cartan-arithmetic core.
It does not derive the group-level RC0 condition, the B-L dictionary, C3
Majorana identity, order-condition relocation, or the full KO-dimension
architecture.

Provenance: `AgentTasks/fable_parallel/Q11_answer.md`; Aristotle project
`65a9d42d`, task `31afe5cf`.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.Q11RealStructure

open Finset

/-! ## Fiber signs -/

/--
Genuine wedge/interleaving sign.  `interSign S T` is the parity of the number
of inversions when the increasing list of `S` is concatenated before the
increasing list of `T`: it counts pairs `(a in S, b in T)` with `b < a`.
-/
def interSign (S T : Finset (Fin 5)) : ℤ :=
  (-1) ^ (∑ a ∈ S, (T.filter (fun b => b < a)).card)

/-- Top-form duality sign: `e_S wedge e_{S^c} = sigma(S) * e_full`. -/
def sigmaSign (S : Finset (Fin 5)) : ℤ :=
  interSign S Sᶜ

/--
The honest wedge sign agrees with the memo's closed formula for `sigma(S)`.
The sign only depends on the exponent mod `2`, so the displayed natural-number
formula uses the addition form certified by finite decidability.
-/
theorem sigmaSign_eq_formula (S : Finset (Fin 5)) :
    sigmaSign S =
      (-1 : ℤ) ^ ((∑ s ∈ S, ((s : ℕ) + 1)) + (S.card * (S.card + 1)) / 2) := by
  revert S
  decide

/-- `J_R^2 = +1` at the sign level: `sigma(S) * sigma(S^c) = +1`. -/
theorem sigmaSign_mul_compl (S : Finset (Fin 5)) :
    sigmaSign S * sigmaSign Sᶜ = 1 := by
  revert S
  decide

/-- Parity flips under complement because the ambient dimension is odd. -/
theorem parity_compl (S : Finset (Fin 5)) :
    ((-1 : ℤ) ^ Sᶜ.card) = -((-1) ^ S.card) := by
  revert S
  decide

/-! ## The operator `J_R` -/

/-- An element of `Λ(C^5)` as a coefficient function on monomials. -/
abbrev Form :=
  Finset (Fin 5) → ℂ

/-- The antilinear top-form-duality real structure. -/
def JR (f : Form) : Form :=
  fun T => (starRingEnd ℂ) (f Tᶜ) * (sigmaSign Tᶜ : ℂ)

/-- `J_R^2 = id`: the real structure squares to `+1` on the nose. -/
theorem JR_involutive (f : Form) (T : Finset (Fin 5)) :
    JR (JR f) T = f T := by
  have hc : (sigmaSign T : ℂ) * (sigmaSign Tᶜ : ℂ) = 1 := by
    rw [← Int.cast_mul, sigmaSign_mul_compl]
    norm_num
  simp only [JR, compl_compl, map_mul, Complex.conj_conj, map_intCast]
  rw [mul_assoc, hc, mul_one]

/-- The grading operator `(-1)^F` (fermion parity). -/
def parity (f : Form) : Form :=
  fun S => ((-1 : ℂ) ^ S.card) * f S

/-- `J_R` anticommutes with grading: `J_R o (-1)^F = -(-1)^F o J_R`. -/
theorem JR_parity_anticomm (f : Form) (T : Finset (Fin 5)) :
    JR (parity f) T = -parity (JR f) T := by
  have hpar : ((-1 : ℂ) ^ Tᶜ.card) = -((-1 : ℂ) ^ T.card) := by
    have := congrArg (Int.cast (R := ℂ)) (parity_compl T)
    push_cast at this
    simpa using this
  rw [JR, parity, parity, JR, map_mul,
    show (starRingEnd ℂ) ((-1 : ℂ) ^ Tᶜ.card) = (-1 : ℂ) ^ Tᶜ.card by
      simp [map_pow],
    hpar]
  ring

/-! ## The internal form `B` is the standard positive metric -/

/-- Wedge product on coefficient functions. -/
noncomputable def wedge (f g : Form) : Form :=
  fun U => ∑ S ∈ U.powerset, f S * g (U \ S) * (interSign S (U \ S) : ℂ)

/-- The internal form `B(f,g)` as the top coefficient of `(J_R f) wedge g`. -/
noncomputable def Btop (f g : Form) : ℂ :=
  wedge (JR f) g univ

/-- The standard Hermitian inner product on `Λ(C^5)`. -/
noncomputable def Bstd (f g : Form) : ℂ :=
  ∑ S : Finset (Fin 5), (starRingEnd ℂ) (f S) * g S

/--
The top-form-duality form is the standard positive Hermitian metric.  This is
the finite check that the internal fiber form is Hilbert, not Krein, and that
unimodularity is not visible to the sesquilinear form alone.
-/
theorem Btop_eq_Bstd (f g : Form) : Btop f g = Bstd f g := by
  unfold Btop Bstd wedge JR
  rw [Finset.powerset_univ]
  have hbij : Function.Bijective (compl : Finset (Fin 5) → Finset (Fin 5)) :=
    (compl_involutive).bijective
  rw [← Fintype.sum_bijective _ hbij]
  intro S
  have huniv : (univ : Finset (Fin 5)) \ Sᶜ = S := by
    ext x
    simp
  rw [huniv, compl_compl]
  have hc : (sigmaSign S : ℂ) * (interSign Sᶜ S : ℂ) = 1 := by
    rw [← Int.cast_mul]
    have : sigmaSign S * interSign Sᶜ S = 1 := by
      revert S
      decide
    rw [this]
    norm_num
  symm
  calc
    (starRingEnd ℂ) (f S) * (sigmaSign S : ℂ) * g S * (interSign Sᶜ S : ℂ)
        = (starRingEnd ℂ) (f S) * g S *
            ((sigmaSign S : ℂ) * (interSign Sᶜ S : ℂ)) := by ring
    _ = (starRingEnd ℂ) (f S) * g S := by
      rw [hc]
      ring

/-- The diagonal of `Bstd` is real and equals the sum of squared magnitudes. -/
theorem Bstd_self_re (f : Form) :
    (Bstd f f).re = ∑ S : Finset (Fin 5), Complex.normSq (f S) := by
  simp only [Bstd, Complex.re_sum]
  refine Finset.sum_congr rfl (fun S _ => ?_)
  rw [Complex.mul_re, Complex.conj_re, Complex.conj_im, Complex.normSq_apply]
  ring

/-- `Bstd` is positive semidefinite. -/
theorem Bstd_self_re_nonneg (f : Form) :
    0 ≤ (Bstd f f).re := by
  rw [Bstd_self_re]
  exact Finset.sum_nonneg fun S _ => Complex.normSq_nonneg (f S)

/-! ## Particle-hole and the unimodularity master identity -/

/-- Number operator `N_i` on `Λ(C^5)`. -/
def num (i : Fin 5) (f : Form) : Form :=
  fun S => (if i ∈ S then (1 : ℂ) else 0) * f S

/-- Klein-twisted particle-hole identity: `J_R N_i J_R = 1 - N_i`. -/
theorem JR_num_particle_hole (i : Fin 5) (f : Form) (T : Finset (Fin 5)) :
    JR (num i (JR f)) T = f T - num i f T := by
  have hc : (sigmaSign T : ℂ) * (sigmaSign Tᶜ : ℂ) = 1 := by
    rw [← Int.cast_mul, sigmaSign_mul_compl]
    norm_num
  simp only [JR, num, compl_compl]
  by_cases hi : i ∈ Tᶜ
  · have hiT : i ∉ T := by
      simpa using hi
    simp only [hi, hiT, if_true, if_false, one_mul, map_mul, Complex.conj_conj,
      map_intCast, zero_mul, sub_zero]
    calc
      f T * (sigmaSign T : ℂ) * (sigmaSign Tᶜ : ℂ)
          = f T * ((sigmaSign T : ℂ) * (sigmaSign Tᶜ : ℂ)) := by ring
      _ = f T := by
        rw [hc]
        ring
  · have hiT : i ∈ T := by
      simpa using hi
    simp [hi, hiT]

/-- Diagonal charge operator `Q = sum_i c_i N_i` with real charges `c_i`. -/
noncomputable def chargeOp (c : Fin 5 → ℝ) (f : Form) : Form :=
  fun S => ((∑ i ∈ S, c i : ℝ)) * f S

/--
The unimodularity master identity: `J_R Q J_R = trace(Q) * 1 - Q`, where
`trace(Q) = sum_i c_i`.  Thus charge conjugation at this Cartan level requires
the displayed trace-zero arithmetic condition.
-/
theorem JR_charge_master (c : Fin 5 → ℝ) (f : Form) (T : Finset (Fin 5)) :
    JR (chargeOp c (JR f)) T = ((∑ i, c i : ℝ)) * f T - chargeOp c f T := by
  have hc : (sigmaSign T : ℂ) * (sigmaSign Tᶜ : ℂ) = 1 := by
    rw [← Int.cast_mul, sigmaSign_mul_compl]
    norm_num
  have hsum : (∑ i ∈ Tᶜ, c i) = (∑ i, c i) - (∑ i ∈ T, c i) := by
    have := Finset.sum_add_sum_compl T c
    linarith [this]
  simp only [JR, chargeOp, compl_compl, map_mul, Complex.conj_conj, map_intCast,
    Complex.conj_ofReal]
  rw [hsum]
  push_cast
  linear_combination ((∑ i, (c i : ℂ)) - (∑ i ∈ T, (c i : ℂ))) * f T * hc

/-! ## Adversarial contrast: oddness of `5` is load-bearing -/

/-- The wedge sign in dimension `4`. -/
def interSign4 (S T : Finset (Fin 4)) : ℤ :=
  (-1) ^ (∑ a ∈ S, (T.filter (fun b => b < a)).card)

/-- Top-form duality sign in dimension `4`. -/
def sigmaSign4 (S : Finset (Fin 4)) : ℤ :=
  interSign4 S Sᶜ

/--
For even dimension `4`, there is a monomial with
`sigma(S) * sigma(S^c) = -1`.  This witnesses that oddness of `5` is
load-bearing for the uniform `J_R^2 = +1` sign table.
-/
theorem even_dim_breaks_JR_sq :
    ∃ S : Finset (Fin 4), sigmaSign4 S * sigmaSign4 Sᶜ = -1 := by
  decide

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11RealStructure.JR_involutive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms JR_involutive

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11RealStructure.Btop_eq_Bstd' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Btop_eq_Bstd

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11RealStructure.JR_charge_master' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms JR_charge_master

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11RealStructure.even_dim_breaks_JR_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms even_dim_breaks_JR_sq

end PhysicsSM.Draft.NullEdge.GateI1.Q11RealStructure
