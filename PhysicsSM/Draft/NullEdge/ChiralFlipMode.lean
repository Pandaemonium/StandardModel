import Mathlib

/-!
# Protected flip modes from the chiral determinant sign

Provenance: seed statements by Fable (typecheck-verified before submission);
proofs by Aristotle project `ecbe0d8b-202c-4860-98ee-996ad37c4a68`
(run `9ae982bc`), statements unchanged; integrated with local kernel
re-check.  Lean 4.28.0.  This module is the protection engine of the
Paper C race: `Carrier/ChiralZeroModeParity` supplies the determinant
dichotomy, this module upgrades the determinant sign to forced exact
`-1`/`+1` eigenvectors, and the Route-B sectoring (in design) applies it
per reflection sector.


Paper C pillar 2 engine (overnight publication run 2026-07-11, Fable lane).

Context.  The project has a kernel-checked chiral determinant dichotomy: a
unitary `W` carrying a chiral involution (`Gamma * Gamma = 1`,
`Gamma * W * Gamma = Wᴴ`) has `det W = 1` or `det W = -1`
(`ChiralZeroModeParity.chiral_det_eq_pm_one`).  The module's honesty note
records that the eigenvalue-multiplicity reading ("the sign pins protected
`+-1` modes") is stated in prose only.  This job turns that prose into
kernel-checked existence theorems.  The determinant sign is a discrete
invariant of the whole chiral-unitary class, so mode existence proved from
`det = -1` alone is a protection statement: no perturbation that preserves
unitarity, the chiral symmetry, and the determinant sign can remove the
mode.

Mathematical route (suggested, not mandatory).  Over `Complex` the
characteristic polynomial splits; its root multiset is closed under complex
conjugation because `Gamma * W * Gamma = Wᴴ` makes `W` similar to `Wᴴ`,
whose roots are the conjugates of the roots of `W`.  Every root of a
unitary matrix is unimodular (eigenvector norm preservation, or the C*
spectrum-of-unitary lemma).  Nonreal roots therefore pair with their
conjugates, each pair contributing `1` to the determinant, and real
unimodular roots are `1` or `-1`; hence `det W = (-1) ^ mult(-1)`.
`det W = -1` forces `mult(-1)` odd, in particular an exact `-1`
eigenvector; in even dimension it also forces `mult(1)` odd, hence an
exact `+1` eigenvector.

Success = all five theorems below proved with no proof holes
(kernel-checked; expected axioms only `propext`, `Classical.choice`,
`Quot.sound`).

Prohibited weakenings:
- do not add a diagonalizability or Hermitian hypothesis;
- do not replace exact eigenvectors by approximate or numerical statements;
- do not restrict to `Fin 2` except in the witness/control section;
- do not assume `Gamma` is Hermitian or unitary beyond `Gamma * Gamma = 1`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ChiralFlipMode

open Matrix Polynomial

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- A chiral involution for `W` (reproduced from the project; do not
modify): a self-inverse `Gamma` conjugating `W` to its adjoint. -/
structure ChiralInvolution (W Gamma : Matrix n n ℂ) : Prop where
  invol : Gamma * Gamma = 1
  chiral : Gamma * W * Gamma = Wᴴ

/-! ### Helper lemmas -/

/--
The characteristic polynomial of the conjugate transpose is the
conjugate (coefficient-wise) of the characteristic polynomial.
-/
theorem charpoly_conjTranspose_eq_map (W : Matrix n n ℂ) :
    Wᴴ.charpoly = W.charpoly.map (starRingEnd ℂ) := by
  convert Matrix.charpoly_map W ( starRingEnd ℂ ) using 1;
  exact Matrix.charpoly_transpose _

/--
A root of the characteristic polynomial gives an exact eigenvector.
-/
theorem exists_eigenvector_of_mem_roots {W : Matrix n n ℂ} {lam : ℂ}
    (hlam : lam ∈ W.charpoly.roots) :
    ∃ v : n → ℂ, v ≠ 0 ∧ W.mulVec v = lam • v := by
  -- Since `lam ∈ W.charpoly.roots`, the charpoly is nonzero and `lam` is a root, so `W.charpoly.eval lam = 0`.
  have h_charpoly_eval : W.charpoly.eval lam = 0 := by
    exact Polynomial.isRoot_of_mem_roots hlam;
  -- By `Matrix.eval_charpoly`, `W.charpoly.eval lam = (Matrix.scalar n lam - W).det`, hence `(scalar n lam - W).det = 0`.
  have h_det : (Matrix.scalar n lam - W).det = 0 := by
    rw [ ← h_charpoly_eval, Matrix.eval_charpoly ];
  obtain ⟨ v, hv ⟩ := Matrix.exists_mulVec_eq_zero_iff.mpr h_det;
  simp_all +decide [ sub_eq_iff_eq_add, Matrix.sub_mulVec ];
  exact ⟨ v, hv.1, hv.2.symm ⟩

/--
An exact eigenvector of a unitary matrix has unimodular eigenvalue.
-/
theorem unitary_eigenvalue_unimodular {W : Matrix n n ℂ} (hU : Wᴴ * W = 1)
    {lam : ℂ} {v : n → ℂ} (hv : v ≠ 0) (hWv : W.mulVec v = lam • v) :
    lam * (starRingEnd ℂ) lam = 1 := by
  have h_eigenvalue_unitary : lam * star lam * (star v ⬝ᵥ v) = star v ⬝ᵥ v := by
    have h_eigenvalue_unitary : star (W.mulVec v) ⬝ᵥ (W.mulVec v) = star v ⬝ᵥ v := by
      rw [ Matrix.star_mulVec ];
      simp +decide [ Matrix.dotProduct_mulVec, hU ];
    simp_all +decide [ mul_assoc, dotProduct_smul ];
  simp_all +decide [ dotProduct, Complex.ext_iff ];
  simp_all +decide [ mul_comm ];
  exact mul_left_cancel₀ ( show ( ∑ x, ( ( v x |> Complex.re ) * ( v x |> Complex.re ) + ( v x |> Complex.im ) * ( v x |> Complex.im ) ) ) ≠ 0 from fun h => hv <| funext fun x => by norm_num [ Complex.ext_iff ] ; constructor <;> nlinarith only [ h ▸ Finset.single_le_sum ( fun x _ => add_nonneg ( mul_self_nonneg ( v x |> Complex.re ) ) ( mul_self_nonneg ( v x |> Complex.im ) ) ) ( Finset.mem_univ x ) ] ) <| by linarith;

/--
**Multiset bookkeeping (product).**  A multiset of complex numbers
closed under conjugation whose elements are all unimodular has product
`(-1)` to the power of the multiplicity of `-1`.
-/
theorem multiset_prod_eq_neg_one_pow_count (R : Multiset ℂ)
    (hconj : R.map (starRingEnd ℂ) = R)
    (huni : ∀ x ∈ R, x * (starRingEnd ℂ) x = 1) :
    R.prod = (-1 : ℂ) ^ R.count (-1) := by
  revert hconj huni;
  induction' n : Multiset.card R using Nat.strong_induction_on with n ih generalizing R;
  intro hconj huni;
  by_cases hR : R = 0;
  · aesop;
  · -- Pick `a ∈ R` and split into three cases.
    obtain ⟨a, ha⟩ : ∃ a ∈ R, True := by
      exact Exists.elim ( Multiset.exists_mem_of_ne_zero hR ) fun x hx => ⟨ x, hx, trivial ⟩
    by_cases ha1 : a = 1 ∨ a = -1;
    · rcases ha1 with ( rfl | rfl );
      · obtain ⟨R', hR'⟩ : ∃ R', R = 1 ::ₘ R' := by
          exact Multiset.exists_cons_of_mem ha.1;
        specialize ih ( Multiset.card R' ) ; simp_all +decide [ Multiset.count_cons ];
        grind;
      · obtain ⟨R', hR'⟩ : ∃ R', R = R' + {-1} := by
          exact ⟨ R.erase ( -1 ), by rw [ add_comm, Multiset.singleton_add, Multiset.cons_erase ha.1 ] ⟩;
        specialize ih ( Multiset.card R' ) ; simp_all +decide [ pow_succ' ];
        exact ih ( by linarith ) R' rfl hconj fun x hx => huni x ( Or.inl hx );
    · -- Since `a ≠ 1` and `a ≠ -1`, `a` is not real, so `conj a ≠ a`.
      have h_conj_ne_a : starRingEnd ℂ a ≠ a := by
        grind +splitIndPred;
      -- Let `R'' = (R.erase a).erase (conj a)`.
      obtain ⟨R'', hR''⟩ : ∃ R'', R = a ::ₘ starRingEnd ℂ a ::ₘ R'' := by
        obtain ⟨R'', hR''⟩ : ∃ R'', R.erase a = starRingEnd ℂ a ::ₘ R'' := by
          have h_conj_in_R : starRingEnd ℂ a ∈ R := by
            exact hconj ▸ Multiset.mem_map_of_mem _ ha.1;
          exact Multiset.exists_cons_of_mem ( Multiset.mem_erase_of_ne h_conj_ne_a |>.2 h_conj_in_R );
        exact ⟨ R'', by rw [ ← hR'', Multiset.cons_erase ha.1 ] ⟩;
      simp_all +decide [ Multiset.prod_cons ];
      grind +suggestions

set_option maxHeartbeats 4000000 in
/--
**Multiset bookkeeping (parity).**  For the same class of multisets, the
cardinality has the same parity as `count 1 + count (-1)` (nonreal roots
pair up).
-/
theorem multiset_card_modEq_count (R : Multiset ℂ)
    (hconj : R.map (starRingEnd ℂ) = R)
    (huni : ∀ x ∈ R, x * (starRingEnd ℂ) x = 1) :
    R.card ≡ R.count 1 + R.count (-1) [MOD 2] := by
  -- By strong induction on the cardinality of R.
  have h_ind : ∀ k : ℕ, ∀ R : Multiset ℂ, Multiset.card R = k → (Multiset.map (starRingEnd ℂ) R = R) → (∀ x ∈ R, x * (starRingEnd ℂ) x = 1) → R.card ≡ R.count 1 + R.count (-1) [MOD 2] := by
    intro k R hR_card hR_map hR_unimodular
    induction' k using Nat.strong_induction_on with k ih generalizing R;
    by_cases hR_empty : R = 0;
    · simp +decide [ hR_empty ];
    · -- Otherwise there is `a ∈ R`. Three cases.
      obtain ⟨a, ha⟩ : ∃ a, a ∈ R := by
        exact Multiset.exists_mem_of_ne_zero hR_empty;
      by_cases ha1 : a = 1 ∨ a = -1;
      · rcases ha1 with ( rfl | rfl ) <;> simp_all +decide [ Nat.ModEq ];
        · obtain ⟨R', hR'⟩ : ∃ R', R = 1 ::ₘ R' := by
            exact Multiset.exists_cons_of_mem ha;
          simp_all +decide [ Multiset.count_cons ];
          grind;
        · obtain ⟨R', hR'⟩ : ∃ R', R = -1 ::ₘ R' := by
            exact Multiset.exists_cons_of_mem ha;
          simp_all +decide [ Multiset.count_cons ];
          grind;
      · -- Since `a ≠ 1` and `a ≠ -1`, we have `conj a ≠ a` and `conj a ∈ R`.
        have h_conj_a_ne_a : starRingEnd ℂ a ≠ a := by
          grind +qlia
        have h_conj_a_in_R : starRingEnd ℂ a ∈ R := by
          exact hR_map ▸ Multiset.mem_map_of_mem _ ha;
        -- Set `R'' = (R.erase a).erase (conj a)`; since `conj a ≠ a`, `conj a ∈ R.erase a`, so `R = a ::ₘ conj a ::ₘ R''`.
        obtain ⟨R'', hR''⟩ : ∃ R'', R = a ::ₘ starRingEnd ℂ a ::ₘ R'' := by
          obtain ⟨ R', hR' ⟩ := Multiset.exists_cons_of_mem ha;
          obtain ⟨ R'', hR'' ⟩ := Multiset.exists_cons_of_mem ( show starRingEnd ℂ a ∈ R' from by aesop ) ; use R''; aesop;
        specialize ih ( Multiset.card R'' ) ?_ R'' rfl ?_ ?_ <;> simp_all +decide [ Nat.ModEq ];
        · linarith;
        · grind +suggestions;
        · simp_all +decide [ Multiset.count_cons ];
          grind;
  exact h_ind _ _ rfl hconj huni

/-! ### Main theorems -/

/--
**T1 (conjugation-closed spectrum).**  For unitary `W` with a chiral
involution, the root multiset of the characteristic polynomial is fixed by
complex conjugation.  (The unitarity hypothesis `hU` is kept because it is
part of the requested statement, but it turns out to be unnecessary for
this conclusion: closure of the spectrum under conjugation follows from the
chiral similarity `Gamma * W * Gamma = Wᴴ` alone.) -/
theorem chiral_unitary_charpoly_roots_conj
    {W Gamma : Matrix n n ℂ} (h : ChiralInvolution W Gamma)
    (hU : Wᴴ * W = 1) :
    (W.charpoly.roots.map (starRingEnd ℂ)) = W.charpoly.roots := by
  -- From `charpoly_conjTranspose_eq_map W`, `Wᴴ.charpoly = W.charpoly.map (starRingEnd ℂ)`. Also `Wᴴ.charpoly = W.charpoly`: build the unit `U : (Matrix n n ℂ)ˣ := ⟨Gamma, Gamma, h.invol, h.invol⟩`; then `Matrix.charpoly_units_conj' U W : (U⁻¹.val * W * U.val).charpoly = W.charpoly`, where `U.val = Gamma` and `U⁻¹.val = Gamma`, so `(Gamma * W * Gamma).charpoly = W.charpoly`, and `Gamma * W * Gamma = Wᴴ` by `h.chiral`. Combining, `W.charpoly.map (starRingEnd ℂ) = W.charpoly`.
  have h_charpoly_eq : W.charpoly.map (starRingEnd ℂ) = W.charpoly := by
    rw [ ← charpoly_conjTranspose_eq_map ];
    rw [ ← h.chiral ];
    convert Matrix.charpoly_units_conj' ( ⟨ Gamma, Gamma, h.invol, h.invol ⟩ : ( Matrix n n ℂ ) ˣ ) W using 1;
  rw [ ← Polynomial.Splits.roots_map ] ; aesop;
  exact IsAlgClosed.splits _

/--
**T2 (unimodular roots).**  Every characteristic root of a unitary
matrix is unimodular.
-/
theorem unitary_charpoly_root_unimodular
    {W : Matrix n n ℂ} (hU : Wᴴ * W = 1) {lam : ℂ}
    (hlam : lam ∈ W.charpoly.roots) :
    lam * (starRingEnd ℂ) lam = 1 := by
  obtain ⟨ v, hv, hWv ⟩ := exists_eigenvector_of_mem_roots hlam; exact unitary_eigenvalue_unimodular hU hv hWv;

/--
**T3 (determinant parity).**  For unitary `W` with a chiral involution,
the determinant is `(-1)` raised to the multiplicity of the root `-1`.
-/
theorem chiral_unitary_det_eq_neg_one_pow
    {W Gamma : Matrix n n ℂ} (h : ChiralInvolution W Gamma)
    (hU : Wᴴ * W = 1) :
    W.det = (-1 : ℂ) ^ (W.charpoly.roots.count (-1)) := by
  rw [ ← multiset_prod_eq_neg_one_pow_count ];
  · convert Matrix.det_eq_prod_roots_charpoly W;
  · convert chiral_unitary_charpoly_roots_conj h hU using 1;
  · exact fun x a => unitary_charpoly_root_unimodular hU a

/--
**T4 (protected flip mode).**  `det W = -1` forces an exact eigenvector
with eigenvalue `-1`.  Because the hypothesis mentions only the discrete
class data (unitarity, chiral involution, determinant sign), the mode
survives every in-class perturbation.
-/
theorem chiral_det_neg_one_forces_flip_mode
    {W Gamma : Matrix n n ℂ} (h : ChiralInvolution W Gamma)
    (hU : Wᴴ * W = 1) (hdet : W.det = -1) :
    ∃ v : n → ℂ, v ≠ 0 ∧ W.mulVec v = -v := by
  -- By `chiral_unitary_det_eq_neg_one_pow h hU`, `W.det = (-1)^(W.charpoly.roots.count (-1))`.
  have h_det : W.det = (-1 : ℂ) ^ (W.charpoly.roots.count (-1)) :=
    chiral_unitary_det_eq_neg_one_pow h hU
  -- Since `count ≠ 0`, we have `-1 ∈ W.charpoly.roots`.
  have h_root : -1 ∈ W.charpoly.roots := by
    contrapose! hdet; simp_all +decide ;
    norm_num;
  obtain ⟨ v, hv ⟩ := exists_eigenvector_of_mem_roots h_root; use v; aesop;

/-
**T4b (even-dimension partner mode).**  In even dimension,
`det W = -1` additionally forces an exact eigenvector with eigenvalue
`+1`: the walk register (two channels per site) always has even dimension,
so the two pinned modes come together.
-/
theorem chiral_det_neg_one_forces_fixed_mode_of_even
    {W Gamma : Matrix n n ℂ} (h : ChiralInvolution W Gamma)
    (hU : Wᴴ * W = 1) (hdet : W.det = -1)
    (heven : Even (Fintype.card n)) :
    ∃ v : n → ℂ, v ≠ 0 ∧ W.mulVec v = v := by
  obtain ⟨k, hk⟩ : Odd (W.charpoly.roots.count (-1)) := by
    -- By `chiral_unitary_det_eq_neg_one_pow h hU`, `W.det = (-1)^(W.charpoly.roots.count (-1))`.
    have hdet_pow : W.det = (-1 : ℂ) ^ (W.charpoly.roots.count (-1)) := by
      convert chiral_unitary_det_eq_neg_one_pow h hU using 1;
    contrapose! hdet;
    simp_all +decide [ Nat.even_iff ];
    norm_num;
  obtain ⟨l, hl⟩ : Odd (W.charpoly.roots.count 1) := by
    have := multiset_card_modEq_count W.charpoly.roots ( chiral_unitary_charpoly_roots_conj h hU ) ( fun x hx => unitary_charpoly_root_unimodular hU hx );
    simp_all +decide [ Nat.ModEq, Nat.even_iff ];
    rw [ IsAlgClosed.card_roots_eq_natDegree ] at this;
    exact Nat.odd_iff.mpr ( by rw [ Matrix.charpoly_natDegree_eq_dim ] at this; omega );
  obtain ⟨ v, hv ⟩ := exists_eigenvector_of_mem_roots ( show 1 ∈ W.charpoly.roots from by { exact Multiset.count_pos.mp ( by rw [ hl ] ; positivity ) } ) ; use v; aesop;

/--
**T5 (witness and boundary control).**  The flip pair
`W = Gamma = sigma_x` is a genuine chiral-unitary witness with
`det = -1` and the explicit flip mode `(1, -1)`; the identity walk is the
`det = 1` boundary control with no flip mode.
-/
theorem sigma_x_witness_and_identity_control :
    (ChiralInvolution (!![0, 1; 1, 0] : Matrix (Fin 2) (Fin 2) ℂ)
        !![0, 1; 1, 0] ∧
      (!![0, 1; 1, 0] : Matrix (Fin 2) (Fin 2) ℂ).det = -1 ∧
      (!![0, 1; 1, 0] : Matrix (Fin 2) (Fin 2) ℂ).mulVec ![1, -1] =
        -(![1, -1]) ∧ (![1, -1] : Fin 2 → ℂ) ≠ 0) ∧
    ((1 : Matrix (Fin 2) (Fin 2) ℂ).det = 1 ∧
      ∀ v : Fin 2 → ℂ, (1 : Matrix (Fin 2) (Fin 2) ℂ).mulVec v = -v →
        v = 0) := by
  refine' ⟨ _, _, _ ⟩;
  · refine' ⟨ _, _, _, _ ⟩;
    · constructor <;> norm_num [ ← List.ofFn_inj ];
      · exact Matrix.one_fin_two.symm;
      · ext i j ; fin_cases i <;> fin_cases j <;> norm_num;
    · norm_num;
    · ext i ; fin_cases i <;> norm_num [ Matrix.mulVec ];
    · exact ne_of_apply_ne ( fun x => x 0 ) one_ne_zero;
  · exact Matrix.det_one;
  · intro v hv; ext i; fin_cases i <;> norm_num [ ← List.ofFn_inj ] at hv ⊢ <;> norm_num [ Complex.ext_iff ] at hv ⊢ <;> constructor <;> linarith!


/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralFlipMode.chiral_unitary_det_eq_neg_one_pow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chiral_unitary_det_eq_neg_one_pow

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralFlipMode.chiral_det_neg_one_forces_flip_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chiral_det_neg_one_forces_flip_mode

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralFlipMode.chiral_det_neg_one_forces_fixed_mode_of_even' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chiral_det_neg_one_forces_fixed_mode_of_even

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralFlipMode.sigma_x_witness_and_identity_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sigma_x_witness_and_identity_control

end PhysicsSM.Draft.NullEdge.ChiralFlipMode
