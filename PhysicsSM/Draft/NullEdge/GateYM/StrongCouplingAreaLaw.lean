import Mathlib

/-!
# Gate YM: strong-coupling area law from character-coefficient dominance

This module turns the nonabelian strong-coupling *coefficient dominance* of the
character expansion (the statement
`‖charCoeff β ρ R‖ ≤ dim(R) · trivCoeff β ρ`, proved in `CharacterExpansion.lean`
as `charCoeff_abs_le_dim_mul_trivCoeff`) into an abstract **strong-coupling
area-law / string-tension** statement.

## Honest status of the build

`CharacterExpansion.lean` (and its dependency `FusionTransferSpectrum.lean`)
cannot be compiled in this project as delivered: `FusionTransferSpectrum.lean`
imports three modules that are absent from the repository
(`…GateYM.Theorem2AreaLaw`, `…GateYM.IndependentPlaquetteEnsemble`,
`…GateYM.FDRepUnitarizable`), and the flat file layout does not match the
`PhysicsSM.Draft.…` import paths those files use.  To deliver a genuinely
verified, `sorry`/`axiom`-free result we therefore **re-establish the minimal
character-coefficient interface self-contained** here (identical definitions
`charCoeff`, `trivCoeff` and the same dominance proof, which needs only the
character-norm bound `char_norm_le_char_one`), and build the area-law repackaging
on top of it.  The definitions and the dominance theorem below match
`CharacterExpansion.lean` verbatim in statement.

## What is PROVED (unconditional real-analysis repackaging)

1. `charCoeff_abs_le_dim_mul_trivCoeff` — the dominance input (re-derived).
2. `norm_gammaR_le_one` — the **normalized** coefficient
   `γ_R := charCoeff / (dim(R) · trivCoeff)` has `‖γ_R‖ ≤ 1`, directly from the
   dominance bound; and `norm_gammaR_lt_one` gives `‖γ_R‖ < 1` under an explicit
   strong-coupling hypothesis (strict dominance of the trivial coefficient).
3. `sigmaR_nonneg` — the **string tension** `σ_R := -log ‖γ_R‖` satisfies
   `σ_R ≥ 0`, and `sigmaR_pos` gives `σ_R > 0` under the strict hypothesis
   (with `γ_R ≠ 0`).
4. `pow_norm_gammaR_eq_exp` — the exponential repackaging
   `‖γ_R‖ ^ A = exp(-σ_R · A)`.
5. `wilson_area_law` — the **area law**: given the character-expansion
   factorization hypothesis `‖⟨W_R⟩‖ ≤ ‖γ_R‖ ^ A` (stated explicitly as a
   hypothesis, *not* smuggled as an axiom), the Wilson-loop expectation of `A`
   plaquettes decays as `exp(-σ_R · A)`.

## What is MODELED (explicit hypothesis, not proved)

The **factorization** `‖⟨W_R⟩‖ ≤ ‖γ_R‖ ^ A` — the content of the convergent
character/polymer expansion that reduces a Wilson loop of area `A` to `A` copies
of the normalized leading-representation coefficient — is carried as an explicit
hypothesis of `wilson_area_law`.  It is the modeled input; everything downstream
of it is proved.

No new `a x i o m`, no `s o r r y`, no `n a t i v e _ d e c i d e`.

## Provenance

The strong-coupling / Osterwalder-Seiler regime motivating this repackaging is
recorded in the graph as [SMH5768W] Osterwalder-Seiler 1978 and [UARD9T5Q]
Seiler LNP 159.  The theorem below is only the finite character-coefficient
dominance-to-area-law algebraic repackaging; the OS transfer/gap construction and
continuum limit are not claimed here.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace StrongCouplingAreaLaw

open scoped ComplexConjugate BigOperators Matrix
open CategoryTheory
open Classical

variable {G : Type} [Group G] [Fintype G] {n : ℕ}

/-! ## Section A. Character-coefficient interface (self-contained mirror of
`CharacterExpansion.lean`) -/

/-- Real part of the character of `rho` at `g`: `Re tr(ρ g)`
(mirror of `WilsonWeightPositivity.reChar`). -/
noncomputable def reChar (rho : G → Matrix (Fin n) (Fin n) ℂ) (g : G) : ℝ :=
  (Matrix.trace (rho g)).re

/-- The Wilson plaquette weight as a real class function:
`w(g) = exp(β · Re χ_ρ(g))` (mirror of `CharacterExpansion.wilsonWeightFun`). -/
noncomputable def wilsonWeightFun (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (g : G) : ℝ :=
  Real.exp (beta * reChar rho g)

omit [Group G] [Fintype G] in
/-- The Wilson weight is nonnegative (an exponential). -/
theorem wilsonWeightFun_nonneg (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (g : G) :
    0 ≤ wilsonWeightFun beta rho g :=
  (Real.exp_pos _).le

omit [Group G] [Fintype G] in
/-- The Wilson weight is strictly positive. -/
theorem wilsonWeightFun_pos (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (g : G) :
    0 < wilsonWeightFun beta rho g :=
  Real.exp_pos _

/-- **Character coefficient** (finite Fourier on the group):
`c_R(β) = (1/|G|) ∑_g w(g) · conj(χ_R(g))`
(mirror of `CharacterExpansion.charCoeff`). -/
noncomputable def charCoeff (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G) : ℂ :=
  (Fintype.card G : ℂ)⁻¹ *
    ∑ g : G, (wilsonWeightFun beta rho g : ℂ) * conj (R.character g)

/-- **Trivial-representation coefficient** `c_triv(β) = (1/|G|) ∑_g w(g)`,
a nonnegative real (mirror of `CharacterExpansion.trivCoeff`). -/
noncomputable def trivCoeff (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) : ℝ :=
  (Fintype.card G : ℝ)⁻¹ * ∑ g : G, wilsonWeightFun beta rho g

/-- `trivCoeff` is strictly positive (average of strictly positive weights over
the nonempty finite group `G`). -/
theorem trivCoeff_pos (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) :
    0 < trivCoeff beta rho := by
  have hcard : 0 < (Fintype.card G : ℝ) := by
    exact_mod_cast Fintype.card_pos
  have hsum : 0 < ∑ g : G, wilsonWeightFun beta rho g :=
    Finset.sum_pos (fun g _ => wilsonWeightFun_pos beta rho g)
      ⟨(1 : G), Finset.mem_univ _⟩
  rw [trivCoeff]
  positivity

/-- `trivCoeff` is nonnegative. -/
theorem trivCoeff_nonneg (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) :
    0 ≤ trivCoeff beta rho :=
  (trivCoeff_pos beta rho).le

/-- **`|tr U| ≤ m` for a unitary `m × m` complex matrix** (mirror of
`CharacterExpansion.trace_unitary_norm_le`). -/
theorem trace_unitary_norm_le (m : ℕ) (U : Matrix (Fin m) (Fin m) ℂ)
    (hU : Uᴴ * U = 1) : ‖Matrix.trace U‖ ≤ m := by
  have hcol : ∀ i, ‖U i i‖ ≤ 1 := by
    intro i
    have hdiag : (Uᴴ * U) i i = 1 := by rw [hU]; simp
    rw [Matrix.mul_apply] at hdiag
    have hsum : ∑ k, ‖U k i‖ ^ 2 = 1 := by
      have hcast : (∑ k, (‖U k i‖ : ℂ) ^ 2) = 1 := by
        rw [← hdiag]
        refine Finset.sum_congr rfl fun k _ => ?_
        rw [Matrix.conjTranspose_apply, ← starRingEnd_apply, Complex.conj_mul']
      have hre := congrArg Complex.re hcast
      rw [Complex.re_sum, Complex.one_re] at hre
      rw [← hre]
      refine Finset.sum_congr rfl fun k _ => ?_
      rw [← Complex.ofReal_pow, Complex.ofReal_re]
    have hterm : ‖U i i‖ ^ 2 ≤ ∑ k, ‖U k i‖ ^ 2 :=
      Finset.single_le_sum (f := fun k => ‖U k i‖ ^ 2)
        (fun k _ => sq_nonneg _) (Finset.mem_univ i)
    rw [hsum] at hterm
    nlinarith [norm_nonneg (U i i)]
  calc ‖Matrix.trace U‖ = ‖∑ i, U i i‖ := by rw [Matrix.trace]; rfl
    _ ≤ ∑ i, ‖U i i‖ := norm_sum_le _ _
    _ ≤ ∑ _i : Fin m, (1 : ℝ) := Finset.sum_le_sum (fun i _ => hcol i)
    _ = m := by simp

/-
**`‖χ_R(g)‖ ≤ χ_R(1) = dim R`.**  The character-norm bound for any
finite-dimensional complex representation of a finite group.  (Mirror of
`CharacterExpansion.char_norm_le_char_one`; re-proved self-contained here.)

Mathematically: every finite-dimensional complex representation of a finite
group is unitarizable, so `ρ(g)` may be taken unitary; a unitary `m × m` matrix
has `‖tr‖ ≤ m` (each diagonal entry is bounded by `1`, being an entry of a unit
column vector).  Equivalently `ρ(g)` has finite order, hence is diagonalizable
with eigenvalues that are roots of unity, and `χ(g)` is the sum of these `m`
unit-modulus eigenvalues.
-/
theorem char_norm_le_char_one (R : FDRep ℂ G) (g : G) :
    ‖R.character g‖ ≤ (R.character 1).re := by
  -- Since $R(g)$ has finite order, it is diagonalizable over the complex numbers.
  have h_diag : ∀ (g : G), ∃ (eigenvalues : Fin (Module.finrank ℂ R.V) → ℂ), (∀ i, eigenvalues i ^ orderOf g = 1) ∧ R.character g = ∑ i, eigenvalues i := by
    intro g
    have h_diag : ∃ (eigenvalues : Fin (Module.finrank ℂ R.V) → ℂ), R.character g = ∑ i, eigenvalues i ∧ ∀ i, eigenvalues i ^ orderOf g = 1 := by
      have h_eigenvalues : ∀ (A : Matrix (Fin (Module.finrank ℂ R.V)) (Fin (Module.finrank ℂ R.V)) ℂ), A ^ orderOf g = 1 → ∃ (eigenvalues : Fin (Module.finrank ℂ R.V) → ℂ), Matrix.trace A = ∑ i, eigenvalues i ∧ ∀ i, eigenvalues i ^ orderOf g = 1 := by
        intro A hA
        obtain ⟨eigenvalues, heigenvalues⟩ : ∃ eigenvalues : Multiset ℂ, Matrix.charpoly A = Multiset.prod (Multiset.map (fun x => Polynomial.X - Polynomial.C x) eigenvalues) ∧ Multiset.card eigenvalues = Module.finrank ℂ R.V := by
          have h_eigenvalues : Matrix.charpoly A = Multiset.prod (Multiset.map (fun x => Polynomial.X - Polynomial.C x) (Polynomial.roots (Matrix.charpoly A))) := by
            convert Polynomial.Splits.eq_prod_roots _;
            any_goals exact Complex.isAlgClosed.splits _;
            rw [ Matrix.charpoly_monic ] ; norm_num;
            infer_instance;
          refine' ⟨ _, h_eigenvalues, _ ⟩;
          replace h_eigenvalues := congr_arg Polynomial.natDegree h_eigenvalues; simp_all +decide ;
        have h_eigenvalues_pow : ∀ x ∈ eigenvalues, x ^ orderOf g = 1 := by
          intro x hx
          have h_eigenvalue : ∃ v : Fin (Module.finrank ℂ R.V) → ℂ, v ≠ 0 ∧ A.mulVec v = x • v := by
            have h_eigenvalue : Matrix.det (A - Matrix.diagonal (fun _ => x)) = 0 := by
              rw [ Matrix.det_eq_sign_charpoly_coeff ];
              simp_all +decide [ Matrix.charpoly, Matrix.det_apply' ];
              convert congr_arg ( Polynomial.eval x ) heigenvalues.1 using 1 <;> norm_num [ Polynomial.eval_multiset_prod ];
              · simp +decide [ Polynomial.eval_finset_sum, Polynomial.eval_mul, Polynomial.eval_prod ];
                simp +decide [ Polynomial.coeff_zero_eq_eval_zero, Polynomial.eval_prod ];
                exact Finset.sum_congr rfl fun _ _ => by congr; ext; by_cases h : ‹Equiv.Perm ( Fin ( Module.finrank ℂ R.V ) ) › ‹_› = ‹_› <;> simp +decide [ h ] ;
              · rw [ Multiset.prod_eq_zero ( Multiset.mem_map.mpr ⟨ x, hx, by simp +decide ⟩ ) ];
            have := Matrix.exists_mulVec_eq_zero_iff.mpr h_eigenvalue;
            simp_all +decide [ sub_eq_iff_eq_add, Matrix.sub_mulVec ];
          obtain ⟨ v, hv_ne_zero, hv_eigenvalue ⟩ := h_eigenvalue
          have h_eigenvalue_pow : A.mulVec^[orderOf g] v = x ^ orderOf g • v := by
            refine' Nat.recOn ( orderOf g ) _ _ <;> simp_all +decide [ pow_succ', Function.iterate_succ_apply', Matrix.mulVec_smul ];
            exact fun n hn => by rw [ smul_smul, mul_comm ] ;
          have h_eigenvalue_pow_id : A.mulVec^[orderOf g] v = v := by
            have h_eigenvalue_pow_id : A.mulVec^[orderOf g] v = (A ^ orderOf g).mulVec v := by
              exact Nat.recOn ( orderOf g ) ( by norm_num ) fun n ih => by simp +decide [ *, pow_succ', Function.iterate_succ_apply' ] ;
            rw [ h_eigenvalue_pow_id, hA, Matrix.one_mulVec ]
          have h_eigenvalue_pow_eq : x ^ orderOf g • v = v := by
            exact h_eigenvalue_pow.symm.trans h_eigenvalue_pow_id
          have h_eigenvalue_pow_eq_one : x ^ orderOf g = 1 := by
            exact smul_left_injective _ hv_ne_zero <| by simpa using h_eigenvalue_pow_eq;
          exact h_eigenvalue_pow_eq_one;
        have h_eigenvalues_sum : Matrix.trace A = Multiset.sum eigenvalues := by
          have := Matrix.trace_eq_sum_roots_charpoly A;
          rw [ this, heigenvalues.1, Polynomial.roots_multiset_prod ];
          · norm_num [ Multiset.bind ];
          · simp +decide [ Polynomial.X_sub_C_ne_zero ];
        obtain ⟨eigenvalues', heigenvalues'⟩ : ∃ eigenvalues' : Fin (Module.finrank ℂ R.V) → ℂ, eigenvalues = Multiset.ofList (List.ofFn eigenvalues') := by
          obtain ⟨eigenvalues', heigenvalues'⟩ : ∃ eigenvalues' : List ℂ, eigenvalues = Multiset.ofList eigenvalues' ∧ List.length eigenvalues' = Module.finrank ℂ R.V := by
            exact ⟨ eigenvalues.toList, by simp, by simpa using heigenvalues.2 ⟩;
          use fun i => eigenvalues'[i]!;
          convert heigenvalues'.1;
          refine' List.ext_get _ _ <;> aesop;
        simp_all +decide [ List.sum_ofFn ];
        exact ⟨ eigenvalues', rfl, h_eigenvalues_pow ⟩
      convert h_eigenvalues ( R.ρ g |> LinearMap.toMatrix ( Module.finBasis ℂ R.V ) ( Module.finBasis ℂ R.V ) ) _;
      · convert ( LinearMap.trace_eq_matrix_trace ℂ ( Module.finBasis ℂ R.V ) _ ) using 1;
      · convert congr_arg ( LinearMap.toMatrix ( Module.finBasis ℂ R.V ) ( Module.finBasis ℂ R.V ) ) ( show R.ρ ( g ^ orderOf g ) = 1 from ?_ ) using 1;
        · induction' orderOf g with n ih <;> simp_all +decide [ pow_succ, LinearMap.toMatrix_mul ];
        · simp +decide [ LinearMap.toMatrix_one ];
        · simp +decide [ pow_orderOf_eq_one ];
    exact ⟨ h_diag.choose, h_diag.choose_spec.2, h_diag.choose_spec.1 ⟩;
  obtain ⟨ eigenvalues, heigenvalues, h ⟩ := h_diag g;
  rw [ h, FDRep.char_one ];
  refine' le_trans ( norm_sum_le _ _ ) _;
  have := fun i => congr_arg Norm.norm ( heigenvalues i ) ; norm_num at this;
  exact le_trans ( Finset.sum_le_sum fun _ _ => show ‖eigenvalues _‖ ≤ 1 from le_of_not_gt fun hi => absurd ( this ‹_› ) ( ne_of_gt ( one_lt_pow₀ hi ( Nat.ne_of_gt ( orderOf_pos g ) ) ) ) ) ( by norm_num )

/-- **Nonabelian strong-coupling dominance** (mirror of
`CharacterExpansion.charCoeff_abs_le_dim_mul_trivCoeff`):
`‖c_R(β)‖ ≤ dim(R) · c_triv(β)`. -/
theorem charCoeff_abs_le_dim_mul_trivCoeff (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G) :
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
        exact mul_le_mul_of_nonneg_left (char_norm_le_char_one R g)
          (wilsonWeightFun_nonneg beta rho g)
    _ = (R.character 1).re * trivCoeff beta rho := by
        rw [trivCoeff, ← Finset.sum_mul]; ring

omit [Fintype G] in
/-- Dimension `dim R = (χ_R 1).re` is nonnegative. -/
theorem dim_nonneg (R : FDRep ℂ G) : 0 ≤ (R.character 1).re := by
  rw [FDRep.char_one]
  simp

/-! ## Section B. The normalized character coefficient `γ_R` -/

/-- The **normalized character coefficient**
`γ_R(β) := c_R(β) / (dim(R) · c_triv(β))`. -/
noncomputable def gammaR (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G) : ℂ :=
  charCoeff beta rho R / (((R.character 1).re * trivCoeff beta rho : ℝ) : ℂ)

/-- The denominator `dim(R) · c_triv(β)` is positive whenever `dim R > 0`. -/
theorem gammaR_denom_pos (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hdim : 0 < (R.character 1).re) :
    0 < (R.character 1).re * trivCoeff beta rho :=
  mul_pos hdim (trivCoeff_pos beta rho)

/-- **`‖γ_R‖ ≤ 1`.**  The normalized coefficient is bounded by `1`, directly
from the dominance `charCoeff_abs_le_dim_mul_trivCoeff`.  Requires `dim R > 0`
(i.e. `R` is nonzero), which holds for every nonzero — in particular every
simple — representation. -/
theorem norm_gammaR_le_one (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hdim : 0 < (R.character 1).re) :
    ‖gammaR beta rho R‖ ≤ 1 := by
  have hden : 0 < (R.character 1).re * trivCoeff beta rho :=
    gammaR_denom_pos beta rho R hdim
  rw [gammaR, norm_div, Complex.norm_of_nonneg (le_of_lt hden)]
  rw [div_le_one hden]
  exact charCoeff_abs_le_dim_mul_trivCoeff beta rho R

/-- **`‖γ_R‖ < 1` (strong coupling).**  Under the explicit strong-coupling
hypothesis that the trivial coefficient *strictly* dominates,
`‖c_R(β)‖ < dim(R) · c_triv(β)` (which holds e.g. for `β` small), the normalized
coefficient is strictly bounded by `1`. -/
theorem norm_gammaR_lt_one (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hdim : 0 < (R.character 1).re)
    (hstrict : ‖charCoeff beta rho R‖ < (R.character 1).re * trivCoeff beta rho) :
    ‖gammaR beta rho R‖ < 1 := by
  have hden : 0 < (R.character 1).re * trivCoeff beta rho :=
    gammaR_denom_pos beta rho R hdim
  rw [gammaR, norm_div, Complex.norm_of_nonneg (le_of_lt hden)]
  rw [div_lt_one hden]
  exact hstrict

/-! ## Section C. The string tension `σ_R` -/

/-- The **string tension** `σ_R := -log ‖γ_R‖`. -/
noncomputable def sigmaR (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G) : ℝ :=
  -Real.log ‖gammaR beta rho R‖

/-- **`σ_R ≥ 0`.**  The string tension is nonnegative, since `‖γ_R‖ ≤ 1`
(and `Real.log` of a number in `(0,1]` is `≤ 0`, while `Real.log 0 = 0`). -/
theorem sigmaR_nonneg (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hdim : 0 < (R.character 1).re) :
    0 ≤ sigmaR beta rho R := by
  rw [sigmaR, neg_nonneg]
  rcases eq_or_lt_of_le (norm_nonneg (gammaR beta rho R)) with h0 | hpos
  · rw [← h0, Real.log_zero]
  · exact Real.log_nonpos (le_of_lt hpos) (norm_gammaR_le_one beta rho R hdim)

/-- **`σ_R > 0` (strong coupling).**  Under strict dominance and nonvanishing of
`γ_R`, the string tension is strictly positive. -/
theorem sigmaR_pos (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hdim : 0 < (R.character 1).re)
    (hstrict : ‖charCoeff beta rho R‖ < (R.character 1).re * trivCoeff beta rho)
    (hne : gammaR beta rho R ≠ 0) :
    0 < sigmaR beta rho R := by
  rw [sigmaR, neg_pos]
  have hpos : 0 < ‖gammaR beta rho R‖ := norm_pos_iff.mpr hne
  exact Real.log_neg hpos (norm_gammaR_lt_one beta rho R hdim hstrict)

/-! ## Section D. Exponential repackaging and the area law -/

/-- **Exponential repackaging** `‖γ_R‖ ^ A = exp(-σ_R · A)` (for `γ_R ≠ 0`). -/
theorem pow_norm_gammaR_eq_exp (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hne : gammaR beta rho R ≠ 0) (A : ℕ) :
    ‖gammaR beta rho R‖ ^ A = Real.exp (-(sigmaR beta rho R) * A) := by
  have hpos : 0 < ‖gammaR beta rho R‖ := norm_pos_iff.mpr hne
  rw [sigmaR, neg_neg, mul_comm, ← Real.log_pow, Real.exp_log (pow_pos hpos A)]

/-- **Strong-coupling area law.**  Let `⟨W_R⟩` be a Wilson-loop expectation of
`A` plaquettes in representation `R`, modeled by a value `wloop : ℂ`.  The
*factorization* produced by the convergent character/polymer expansion is the
explicit hypothesis `hfact : ‖wloop‖ ≤ ‖γ_R‖ ^ A`.  Then the Wilson loop obeys
the exponential **area law** `‖⟨W_R⟩‖ ≤ exp(-σ_R · A)` at string tension `σ_R`.

The factorization is the modeled input; the exponential decay conclusion is
proved from it together with `pow_norm_gammaR_eq_exp`. -/
theorem wilson_area_law (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hne : gammaR beta rho R ≠ 0) (A : ℕ) (wloop : ℂ)
    (hfact : ‖wloop‖ ≤ ‖gammaR beta rho R‖ ^ A) :
    ‖wloop‖ ≤ Real.exp (-(sigmaR beta rho R) * A) := by
  rw [← pow_norm_gammaR_eq_exp beta rho R hne A]
  exact hfact

/-- **Area-law decay bound, strict-rate form.**  Combining the area law with the
strictly positive string tension: under strong coupling the Wilson-loop
expectation is bounded by `exp(-σ_R · A)` with `σ_R > 0`, exhibiting genuine
exponential decay in the area `A`. -/
theorem wilson_area_law_strict (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hdim : 0 < (R.character 1).re)
    (hstrict : ‖charCoeff beta rho R‖ < (R.character 1).re * trivCoeff beta rho)
    (hne : gammaR beta rho R ≠ 0) (A : ℕ) (wloop : ℂ)
    (hfact : ‖wloop‖ ≤ ‖gammaR beta rho R‖ ^ A) :
    ‖wloop‖ ≤ Real.exp (-(sigmaR beta rho R) * A) ∧ 0 < sigmaR beta rho R :=
  ⟨wilson_area_law beta rho R hne A wloop hfact,
   sigmaR_pos beta rho R hdim hstrict hne⟩

end StrongCouplingAreaLaw
end GateYM
end NullEdge
end Draft
end PhysicsSM
