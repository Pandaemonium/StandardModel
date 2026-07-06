import Mathlib

/-!
# Gate YM: a concrete finite NONABELIAN instantiation of the character bound

This file is the concrete, self-contained companion to `CharacterExpansion.lean`.
That file proves the nonabelian strong-coupling dominance
`charCoeff_abs_le_dim_mul_trivCoeff` for an arbitrary `FDRep ℂ G` (its honest
nonabelian bound carries the dimension factor `dim R = (χ_R 1).re`, in contrast
to the abelian-only `charCoeff_abs_le_trivCoeff`, whose hypothesis
`∀ g, ‖χ_R g‖ ≤ 1` forces `dim R = 1`).

Here we **instantiate that machinery on a genuine finite nonabelian group with a
real 2-dimensional irreducible representation**: the quaternion group
`Q₈ = QuaternionGroup 2` (order `8`), with its 2-dimensional complex irrep
`ρ : Q₈ → GL₂(ℂ)` built from the Pauli-type matrices
`a₁ ↦ diag(i,-i)`, `x ↦ [[0,1],[-1,0]]` (Gaussian-integer entries, so all
computations are exact in `ℂ`).

What is established (no `sorry`, no new `axiom`, no `native_decide`):

1. **The group + its 2-dim irrep.**  `MQ8 : Q₈ → Matrix (Fin 2) (Fin 2) ℂ` is a
   genuine monoid homomorphism (`MQ8_one`, `MQ8_mul`), packaged as
   `rhoQ8 : Representation ℂ Q₈ (Fin 2 → ℂ)` and `R2 : FDRep ℂ Q₈`.  Its
   character is computed explicitly (`R2_char_a`, `R2_char_xa`) and
   `R2.character 1 = 2` (`R2_char_one`), i.e. `dim R2 = 2`.

2. **Finite character orthogonality** between the trivial character and `χ₂`:
   `∑_g χ₂(g)·conj(1) = 0` (`char_orthogonality_triv`), and the self product
   `∑_g χ₂(g)·conj(χ₂(g)) = 8 = |Q₈|` (`char_norm_sq_eq_card`), the numerical
   Schur relation certifying that `χ₂` is a genuine irreducible character.

3. **Non-vacuity of the nonabelian bound.**  `‖χ₂(-1)‖ = 2 > 1` at the central
   element `-1 = a 2 ≠ 1` (`char_norm_gt_one`), so the abelian-only bound
   `charCoeff_abs_le_trivCoeff` does **not** apply
   (`abelian_bound_not_applicable`), while the dimension-weighted bound with the
   `dim = 2` factor **does** apply:
   `‖charCoeff β MQ8 R2‖ ≤ 2 · trivCoeff β MQ8` (`q8_charCoeff_abs_le_dim_mul_trivCoeff`).

The `charCoeff` character-expansion machinery of `CharacterExpansion.lean` is
reproduced here self-contained (that file's project dependencies are not present
in this workspace).  The one general ingredient of the dimension-weighted bound
that in Mathlib `v4.28.0` is not available off the shelf — the character-norm
bound `‖χ_R g‖ ≤ (χ_R 1).re` coming from unitarizability — is carried as an
explicit hypothesis in the general lemma `charCoeff_abs_le_charOne_mul_trivCoeff`
and then **discharged by direct finite computation** for the concrete `R2`
(`R2_char_norm_le`), so the final instantiation has no extra hypotheses.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace FiniteNonabelianChar

open scoped ComplexConjugate BigOperators Matrix
open CategoryTheory QuaternionGroup

/-! ## Section A. The 2-dimensional complex irrep of `Q₈ = QuaternionGroup 2` -/

/-- Diagonal entry `i ↦ i^k` (as a power of `Complex.I`), `k = val`. -/
noncomputable def cI (i : ZMod 4) : ℂ := Complex.I ^ i.val
/-- Diagonal entry `i ↦ (-i)^k`, the complex-conjugate character. -/
noncomputable def cIb (i : ZMod 4) : ℂ := (-Complex.I) ^ i.val

theorem cI_add (i j : ZMod 4) : cI (i + j) = cI i * cI j := by
  unfold cI; rw [ZMod.val_add, ← pow_add]
  have hI : Complex.I ^ 4 = 1 := by norm_num [pow_succ, Complex.I_sq]
  conv_rhs => rw [← Nat.div_add_mod (i.val + j.val) 4, pow_add, pow_mul, hI, one_pow, one_mul]

theorem cIb_add (i j : ZMod 4) : cIb (i + j) = cIb i * cIb j := by
  unfold cIb; rw [ZMod.val_add, ← pow_add]
  have hI : (-Complex.I) ^ 4 = 1 := by norm_num [pow_succ, Complex.I_sq]
  conv_rhs => rw [← Nat.div_add_mod (i.val + j.val) 4, pow_add, pow_mul, hI, one_pow, one_mul]

theorem cI_zero : cI 0 = 1 := by unfold cI; simp
theorem cIb_zero : cIb 0 = 1 := by unfold cIb; simp

theorem cI_mul_cIb (i : ZMod 4) : cI i * cIb i = 1 := by
  unfold cI cIb; rw [← mul_pow]; norm_num
theorem cIb_mul_cI (i : ZMod 4) : cIb i * cI i = 1 := by rw [mul_comm]; exact cI_mul_cIb i

theorem cI_two : cI 2 = -1 := by
  unfold cI; rw [show (ZMod.val (2 : ZMod 4)) = 2 from by decide]; norm_num [pow_succ, Complex.I_sq]
theorem cIb_two : cIb 2 = -1 := by
  unfold cIb; rw [show (ZMod.val (2 : ZMod 4)) = 2 from by decide]; norm_num [pow_succ, Complex.I_sq]

theorem cIb_sub (i j : ZMod 4) : cIb (j - i) = cI i * cIb j := by
  have h := cIb_add (j - i) i; rw [sub_add_cancel] at h
  have : cIb (j - i) = cIb j * cI i := by
    field_simp at h ⊢; rw [h, mul_assoc, cIb_mul_cI, mul_one]
  rw [this]; ring
theorem cI_sub (i j : ZMod 4) : cI (j - i) = cIb i * cI j := by
  have h := cI_add (j - i) i; rw [sub_add_cancel] at h
  have : cI (j - i) = cI j * cIb i := by
    field_simp at h ⊢; rw [h, mul_assoc, cI_mul_cIb, mul_one]
  rw [this]; ring

/-- The 2-dimensional complex representation of `Q₈` as an explicit matrix, in
the "monomial" form (diagonal on the cyclic part `a i`, anti-diagonal on the
`xa i` coset). -/
noncomputable def MQ8 (g : QuaternionGroup 2) : Matrix (Fin 2) (Fin 2) ℂ :=
  match g with
  | .a i => !![cI i, 0; 0, cIb i]
  | .xa i => !![0, cIb i; -(cI i), 0]

theorem MQ8_one : MQ8 1 = 1 := by
  show MQ8 (a 0) = 1
  rw [MQ8, cI_zero, cIb_zero]
  ext r c; fin_cases r <;> fin_cases c <;> simp

theorem MQ8_mul (g h : QuaternionGroup 2) : MQ8 (g * h) = MQ8 g * MQ8 h := by
  obtain (i | i) := g <;> obtain (j | j) := h
  · rw [a_mul_a]; show MQ8 (a (i + j)) = MQ8 (a i) * MQ8 (a j)
    rw [MQ8, MQ8, MQ8, cI_add, cIb_add]
    ext r c; fin_cases r <;> fin_cases c <;> simp
  · rw [a_mul_xa]; show MQ8 (xa (j - i)) = MQ8 (a i) * MQ8 (xa j)
    rw [MQ8, MQ8, MQ8, cIb_sub, cI_sub]
    ext r c; fin_cases r <;> fin_cases c <;> simp
  · rw [xa_mul_a]; show MQ8 (xa (i + j)) = MQ8 (xa i) * MQ8 (a j)
    rw [MQ8, MQ8, MQ8, cI_add, cIb_add]
    ext r c; fin_cases r <;> fin_cases c <;> simp
  · rw [xa_mul_xa]; show MQ8 (a ((2 : ZMod 4) + j - i)) = MQ8 (xa i) * MQ8 (xa j)
    rw [MQ8, MQ8, MQ8]
    have e1 : (2 : ZMod 4) + j - i = 2 + (j - i) := by ring
    rw [e1, cI_add, cIb_add, cI_two, cIb_two, cIb_sub, cI_sub]
    ext r c; fin_cases r <;> fin_cases c <;> simp

/-- `MQ8` as a monoid homomorphism into `Matrix (Fin 2) (Fin 2) ℂ`. -/
noncomputable def MQ8hom : QuaternionGroup 2 →* Matrix (Fin 2) (Fin 2) ℂ where
  toFun := MQ8
  map_one' := MQ8_one
  map_mul' := MQ8_mul

/-- The genuine 2-dimensional complex representation `ρ : Q₈ → GL(ℂ²)`. -/
noncomputable def rhoQ8 : Representation ℂ (QuaternionGroup 2) (Fin 2 → ℂ) :=
  (Matrix.toLinAlgEquiv' (R := ℂ) (n := Fin 2)).toAlgHom.toMonoidHom.comp MQ8hom

/-- The 2-dimensional irrep of `Q₈` as an object of `FDRep ℂ Q₈`. -/
noncomputable def R2 : FDRep ℂ (QuaternionGroup 2) := FDRep.of rhoQ8

/-- The character of `R2` is the matrix trace of the model `MQ8`. -/
theorem R2_character_eq_trace (g : QuaternionGroup 2) :
    R2.character g = Matrix.trace (MQ8 g) := by
  rw [FDRep.character]
  show LinearMap.trace ℂ (Fin 2 → ℂ) (rhoQ8 g) = _
  rw [LinearMap.trace_eq_matrix_trace ℂ (Pi.basisFun ℂ (Fin 2))]
  congr 1
  show (LinearMap.toMatrix (Pi.basisFun ℂ (Fin 2)) (Pi.basisFun ℂ (Fin 2)))
      (Matrix.toLinAlgEquiv' (MQ8 g)) = MQ8 g
  exact (LinearEquiv.eq_symm_apply
    (LinearMap.toMatrix (Pi.basisFun ℂ (Fin 2)) (Pi.basisFun ℂ (Fin 2)))).mp rfl

/-- Norm of the diagonal entries is `1` (they are powers of unit-modulus `±i`). -/
theorem cI_norm (i : ZMod 4) : ‖cI i‖ = 1 := by
  unfold cI; rw [norm_pow, Complex.norm_I, one_pow]
theorem cIb_norm (i : ZMod 4) : ‖cIb i‖ = 1 := by
  unfold cIb; rw [norm_pow]; simp

/-- Character on the cyclic part: `χ₂(aⁱ) = iⁱ + (-i)ⁱ`. -/
theorem R2_char_a (i : ZMod 4) : R2.character (a i) = cI i + cIb i := by
  rw [R2_character_eq_trace]
  show Matrix.trace (!![cI i, 0; 0, cIb i]) = cI i + cIb i
  simp [Matrix.trace_fin_two]

/-- Character on the `xa` coset vanishes: `χ₂(x·aⁱ) = 0`. -/
theorem R2_char_xa (i : ZMod 4) : R2.character (xa i) = 0 := by
  rw [R2_character_eq_trace]
  show Matrix.trace (!![0, cIb i; -(cI i), 0]) = 0
  simp [Matrix.trace_fin_two]

/-- `dim R2 = 2`: the character at the identity is `2`. -/
theorem R2_char_one : R2.character 1 = 2 := by
  rw [show (1 : QuaternionGroup 2) = a 0 from rfl, R2_char_a, cI_zero, cIb_zero]; norm_num

theorem R2_char_one_re : (R2.character 1).re = 2 := by rw [R2_char_one]; norm_num

/-! ## Section B. Enumeration over `Q₈` and character orthogonality -/

/-- Explicit bijection `Q₈ ≃ ZMod 4 ⊕ ZMod 4` used to enumerate sums. -/
def q8equiv : QuaternionGroup 2 ≃ (ZMod 4 ⊕ ZMod 4) where
  toFun g := match g with | .a i => Sum.inl i | .xa i => Sum.inr i
  invFun s := match s with | .inl i => a i | .inr i => xa i
  left_inv g := by cases g <;> rfl
  right_inv s := by cases s <;> rfl

/-- Any sum over `Q₈` expands into its `8` terms. -/
theorem sum_Q8 (f : QuaternionGroup 2 → ℂ) :
    ∑ g, f g = f (a 0) + f (a 1) + f (a 2) + f (a 3)
             + f (xa 0) + f (xa 1) + f (xa 2) + f (xa 3) := by
  have h4 : ∀ (g : ZMod 4 → ℂ), ∑ x, g x = g 0 + g 1 + g 2 + g 3 :=
    fun g => Fin.sum_univ_four g
  rw [← Equiv.sum_comp q8equiv.symm f, Fintype.sum_sum_type]
  simp only [q8equiv, Equiv.symm, Equiv.coe_fn_mk]
  rw [h4 (fun x => f (a x)), h4 (fun x => f (xa x))]
  ring

/-- Values of `iⁱ` and `(-i)ⁱ` used to evaluate the character sums. -/
theorem cI_one : cI 1 = Complex.I := by
  unfold cI; rw [show (ZMod.val (1 : ZMod 4)) = 1 from by decide]; simp
theorem cIb_one : cIb 1 = -Complex.I := by
  unfold cIb; rw [show (ZMod.val (1 : ZMod 4)) = 1 from by decide]; simp
theorem cI_three : cI 3 = -Complex.I := by
  unfold cI; rw [show (ZMod.val (3 : ZMod 4)) = 3 from by decide]; norm_num [pow_succ, Complex.I_sq]
theorem cIb_three : cIb 3 = Complex.I := by
  unfold cIb; rw [show (ZMod.val (3 : ZMod 4)) = 3 from by decide]; norm_num [pow_succ, Complex.I_sq]

/-- **Character orthogonality (trivial vs. the 2-dim irrep).**  The Hermitian
inner product of `χ₂` against the trivial character `1` vanishes:
`∑_g χ₂(g)·conj(1) = 0`.  (Divide by `|Q₈| = 8` for the normalized Schur
relation.) -/
theorem char_orthogonality_triv :
    ∑ g : QuaternionGroup 2, R2.character g * conj (1 : ℂ) = 0 := by
  simp only [map_one, mul_one]
  rw [sum_Q8 (fun g => R2.character g)]
  rw [show (a 0 : QuaternionGroup 2) = 1 from rfl, R2_char_one]
  rw [R2_char_a, R2_char_a, R2_char_a, R2_char_xa, R2_char_xa, R2_char_xa, R2_char_xa]
  rw [cI_one, cIb_one, cI_two, cIb_two, cI_three, cIb_three]
  ring

/-- **Numerical Schur relation** certifying irreducibility of `χ₂`:
`∑_g χ₂(g)·conj(χ₂(g)) = 8 = |Q₈|`. -/
theorem char_norm_sq_eq_card :
    ∑ g : QuaternionGroup 2, R2.character g * conj (R2.character g) = 8 := by
  rw [sum_Q8 (fun g => R2.character g * conj (R2.character g))]
  rw [show (a 0 : QuaternionGroup 2) = 1 from rfl, R2_char_one]
  rw [R2_char_a, R2_char_a, R2_char_a, R2_char_xa, R2_char_xa, R2_char_xa, R2_char_xa]
  rw [cI_one, cIb_one, cI_two, cIb_two, cI_three, cIb_three]
  simp [Complex.ext_iff]
  norm_num

/-! ## Section C. Non-vacuity: `‖χ₂(-1)‖ = 2 > 1` -/

/-- The central element `-1 ∈ Q₈` is `a 2` and differs from `1`. -/
theorem neg_one_ne_one : (a 2 : QuaternionGroup 2) ≠ 1 := by decide

/-- `χ₂(-1) = -2`. -/
theorem R2_char_neg_one : R2.character (a 2) = -2 := by
  rw [R2_char_a, cI_two, cIb_two]; norm_num

/-- **Non-vacuity witness.**  There is a group element (`-1 = a 2`) with
`‖χ₂(g)‖ = 2 > 1`; hence the abelian bound hypothesis `∀ g, ‖χ₂ g‖ ≤ 1` fails. -/
theorem char_norm_gt_one : 1 < ‖R2.character (a 2)‖ := by
  rw [R2_char_neg_one]; rw [show (-2 : ℂ) = ((-2 : ℝ) : ℂ) from by norm_num, Complex.norm_real]
  norm_num

/-! ## Section D. The `charCoeff` machinery (reproduced self-contained) -/

section Machinery

variable {G : Type} [Group G] [Fintype G] {n : ℕ}

/-- Real part of the character (trace) of the Wilson matrix model. -/
noncomputable def reChar (rho : G → Matrix (Fin n) (Fin n) ℂ) (g : G) : ℝ :=
  (Matrix.trace (rho g)).re

/-- The Wilson plaquette weight `w(g) = exp(β · Re χ_ρ(g))`. -/
noncomputable def wilsonWeightFun (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (g : G) : ℝ :=
  Real.exp (beta * reChar rho g)

omit [Group G] [Fintype G] in
theorem wilsonWeightFun_nonneg (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (g : G) :
    0 ≤ wilsonWeightFun beta rho g := (Real.exp_pos _).le

/-- Character coefficient (finite Fourier on the group):
`c_R(β) = (1/|G|) ∑_g w(g)·conj(χ_R(g))`. -/
noncomputable def charCoeff (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G) : ℂ :=
  (Fintype.card G : ℂ)⁻¹ *
    ∑ g : G, (wilsonWeightFun beta rho g : ℂ) * conj (R.character g)

/-- The trivial-representation coefficient `c_triv(β) = (1/|G|) ∑_g w(g)`. -/
noncomputable def trivCoeff (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) : ℝ :=
  (Fintype.card G : ℝ)⁻¹ * ∑ g : G, wilsonWeightFun beta rho g

/-- **Abelian-only strong-coupling dominance** (`|χ| ≤ 1` hypothesis, forcing
`dim R = 1`): `‖c_R(β)‖ ≤ c_triv(β)`. -/
theorem charCoeff_abs_le_trivCoeff (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hbound : ∀ g : G, ‖R.character g‖ ≤ 1) :
    ‖charCoeff beta rho R‖ ≤ trivCoeff beta rho := by
  unfold charCoeff trivCoeff
  norm_num [norm_mul, Complex.norm_exp]
  gcongr
  refine le_trans (norm_sum_le _ _) ?_
  refine Finset.sum_le_sum fun x _ => ?_
  rw [norm_mul, Complex.norm_conj,
    Complex.norm_of_nonneg (wilsonWeightFun_nonneg beta rho x)]
  simpa using mul_le_mul_of_nonneg_left (hbound x) (wilsonWeightFun_nonneg beta rho x)

/-- **Dimension-weighted nonabelian dominance** (the honest nonabelian bound of
`CharacterExpansion.charCoeff_abs_le_dim_mul_trivCoeff`), with the
character-norm bound `‖χ_R g‖ ≤ (χ_R 1).re` supplied as a hypothesis.  In the
full project this hypothesis is the theorem `char_norm_le_char_one` (from the
unitarizability of finite-group representations); Mathlib `v4.28.0` does not
provide it off the shelf, so here it is a hypothesis, discharged below by finite
computation for the concrete `R2`. -/
theorem charCoeff_abs_le_charOne_mul_trivCoeff (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hbd : ∀ g : G, ‖R.character g‖ ≤ (R.character 1).re) :
    ‖charCoeff beta rho R‖ ≤ (R.character 1).re * trivCoeff beta rho := by
  calc ‖charCoeff beta rho R‖
      = (Fintype.card G : ℝ)⁻¹ *
          ‖∑ g : G, (wilsonWeightFun beta rho g : ℂ) * conj (R.character g)‖ := by
        rw [charCoeff, norm_mul, norm_inv, Complex.norm_natCast]
    _ ≤ (Fintype.card G : ℝ)⁻¹ *
          ∑ g : G, wilsonWeightFun beta rho g * (R.character 1).re := by
        gcongr
        refine le_trans (norm_sum_le _ _) ?_
        refine Finset.sum_le_sum fun g _ => ?_
        rw [norm_mul, Complex.norm_conj,
          Complex.norm_of_nonneg (wilsonWeightFun_nonneg beta rho g)]
        exact mul_le_mul_of_nonneg_left (hbd g) (wilsonWeightFun_nonneg beta rho g)
    _ = (R.character 1).re * trivCoeff beta rho := by
        rw [trivCoeff, ← Finset.sum_mul]; ring

end Machinery

/-! ## Section E. The non-vacuous instantiation on `Q₈` -/

/-- **Character-norm bound for the concrete `Q₈` irrep** (`char_norm_le_char_one`
for `R2`, proved by finite computation): `‖χ₂(g)‖ ≤ (χ₂ 1).re = 2` for every
`g ∈ Q₈`. -/
theorem R2_char_norm_le (g : QuaternionGroup 2) :
    ‖R2.character g‖ ≤ (R2.character 1).re := by
  rw [R2_char_one_re]
  obtain (i | i) := g
  · rw [R2_char_a]
    calc ‖cI i + cIb i‖ ≤ ‖cI i‖ + ‖cIb i‖ := norm_add_le _ _
      _ = 2 := by rw [cI_norm, cIb_norm]; norm_num
  · rw [R2_char_xa]; norm_num

/-- **The abelian bound does NOT apply to `R2`.**  Its hypothesis
`∀ g, ‖χ₂ g‖ ≤ 1` is false (witnessed at `-1 = a 2`, where `‖χ₂‖ = 2`). -/
theorem abelian_bound_not_applicable :
    ¬ (∀ g : QuaternionGroup 2, ‖R2.character g‖ ≤ 1) := by
  intro h
  have := h (a 2)
  have h2 := char_norm_gt_one
  linarith

/-- **Non-vacuous nonabelian instantiation.**  The dimension-weighted
strong-coupling bound, with the genuine `dim = 2` factor, applied to the
2-dimensional irrep of the nonabelian group `Q₈`:
`‖charCoeff β MQ8 R2‖ ≤ 2 · trivCoeff β MQ8`.
The abelian-only bound `charCoeff_abs_le_trivCoeff` is inapplicable here
(`abelian_bound_not_applicable`), so this is the applicable bound. -/
theorem q8_charCoeff_abs_le_dim_mul_trivCoeff (beta : ℝ) :
    ‖charCoeff beta MQ8 R2‖ ≤ 2 * trivCoeff beta MQ8 := by
  have h := charCoeff_abs_le_charOne_mul_trivCoeff beta MQ8 R2 R2_char_norm_le
  rwa [R2_char_one_re] at h

end FiniteNonabelianChar
end GateYM
end NullEdge
end Draft
end PhysicsSM
