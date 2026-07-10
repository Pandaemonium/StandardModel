/-
# S1-CC: the finite balance engine (reconstructed)

This file provides the abstract "balance engine" reused by
`S1CCPhysicalSectorWitness.lean` and by the general-representative reduction
`S1CCGeneralReduction.lean`.

The two exported flagships are:

* `anticonj_charpoly_eq` — if an invertible `S` *anticonjugates* a matrix `B`
  (`⅟S * B * S = -B`), then `(-B).charpoly = B.charpoly`.  Similarity is a
  charpoly invariant, so conjugating `B` to `-B` forces the two characteristic
  polynomials to coincide.

* `hermitian_balanced_count_of_neg_charpoly` — if a Hermitian complex matrix
  `B` satisfies `(-B).charpoly = B.charpoly`, then it has exactly as many
  strictly-positive Hermitian eigenvalues as strictly-negative ones
  (`n₊ = n₋`, "balanced").

The mechanism is entirely structural: `anticonjugation` is a *congruence*
symmetry of the spectrum, and a Hermitian spectrum invariant under negation is
balanced.  Nothing here depends on the particular carrier, `Q_G`, or coordinate
alignment — that is exactly why the witness upgrades to the general reduction.
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia

open Matrix Polynomial

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- **Anticonjugation ⇒ charpoly symmetry.** Charpoly is invariant under
conjugation, so if an invertible `S` conjugates `B` to `-B`, then `-B` and `B`
have equal characteristic polynomials. -/
theorem anticonj_charpoly_eq (B S : Matrix ι ι ℂ) [Invertible S]
    (h : ⅟S * B * S = -B) : (-B).charpoly = B.charpoly := by
  rw [← h]
  simpa using Matrix.charpoly_units_conj' (unitOfInvertible S) B

/-
**Charpoly of `-B`.** `(-B).charpoly (X) = (-1)^(card) · B.charpoly(-X)`.
-/
theorem charpoly_neg (B : Matrix ι ι ℂ) :
    (-B).charpoly = C ((-1) ^ (Fintype.card ι)) * B.charpoly.comp (-X) := by
  by_contra h_contra;
  -- By definition of characteristic polynomial, we know that
  have h_char_poly : ∀ (M : Matrix ι ι ℂ) (x : ℂ), Polynomial.eval x (Matrix.charpoly M) = Matrix.det (x • 1 - M) := by
    intro M x; rw [ Matrix.charpoly ] ; simp +decide [ Matrix.det_apply' ] ;
    simp +decide [ Polynomial.eval_finset_sum, Polynomial.eval_mul, Polynomial.eval_prod, Matrix.one_apply ];
    exact Finset.sum_congr rfl fun _ _ => by congr; ext; aesop;
  refine' h_contra ( Polynomial.funext fun x => _ );
  simp_all +decide;
  rw [ ← neg_neg ( x • 1 + B ), Matrix.det_neg ]
  norm_num [ sub_eq_add_neg, add_comm ]

/-
**Roots of a `-X` reflection.** Over `ℂ`, reflecting a polynomial through
the origin negates its root multiset.
-/
theorem roots_comp_neg_X (p : ℂ[X]) :
    (p.comp (-X)).roots = p.roots.map (Neg.neg) := by
  by_contra h_contra;
  -- By definition of polynomial roots, if $a$ is a root of $p$, then $-a$ is a root of $p.comp (-X)$.
  have h_root : (p.comp (-X)).roots = Multiset.map (fun r => -r) p.roots := by
    have h_factor : p = Polynomial.C (p.leadingCoeff) * Multiset.prod (Multiset.map (fun r => Polynomial.X - Polynomial.C r) p.roots) := by
      convert Polynomial.Splits.eq_prod_roots _;
      exact IsAlgClosed.splits p
    rw [ h_factor ];
    by_cases h : p.leadingCoeff = 0 <;> simp +decide [ h, Polynomial.roots_C_mul ] at h_contra ⊢;
    induction' p.roots using Multiset.induction_on with r s ih <;> norm_num at *;
    rw [ Polynomial.roots_mul ] <;> norm_num [ ih ];
    · rw [ show ( -X - C r ) = - ( X + C r ) by ring, Polynomial.roots_neg ] ; norm_num [ Polynomial.roots_X_add_C ];
    · exact ⟨ by exact ne_of_apply_ne Polynomial.derivative <| by norm_num, fun x hx => Polynomial.X_sub_C_ne_zero x ⟩;
  contradiction

/-
**Eigenvalue multiset of `-B` is the negation of that of `B`.**
-/
theorem neg_eigenvalues_multiset (B : Matrix ι ι ℂ)
    (hB : B.IsHermitian) :
    Finset.univ.val.map (hB.neg).eigenvalues
      = (Finset.univ.val.map hB.eigenvalues).map (Neg.neg) := by
  generalize_proofs at *;
  have := ‹ ( -B ).IsHermitian ›.roots_charpoly_eq_eigenvalues;
  convert congr_arg ( fun s => s.map ( fun x => x |> RCLike.re ) ) ( this.symm.trans ( show ( -B ).charpoly.roots = ( B.charpoly.comp ( -X ) |> Polynomial.roots ) from ?_ ) ) using 1;
  · erw [ Multiset.map_map ] ; aesop;
  · rw [ roots_comp_neg_X, hB.roots_charpoly_eq_eigenvalues ];
    norm_num [ Function.comp ];
  · convert congr_arg ( fun p => p.roots ) ( charpoly_neg B ) using 1;
    rw [ Polynomial.roots_C_mul ] ; norm_num

/-
**Balanced count for a negation-invariant real multiset.** If a finite real
multiset equals its own pointwise negation, it has as many strictly positive as
strictly negative members.
-/
theorem countP_pos_eq_countP_neg_of_map_neg_eq (M : Multiset ℝ)
    (h : M = M.map (Neg.neg)) :
    M.countP (fun x => 0 < x) = M.countP (fun x => x < 0) := by
  conv_lhs => rw [ h, Multiset.countP_map ];
  rw [ Multiset.countP_eq_card_filter ] ; congr ; ext ; simp +decide

/-
**Hermitian balance from charpoly symmetry.** If `B` is Hermitian and
`(-B).charpoly = B.charpoly`, then it has equally many positive and negative
Hermitian eigenvalues.
-/
theorem hermitian_balanced_count_of_neg_charpoly (B : Matrix ι ι ℂ)
    (hB : B.IsHermitian) (h : (-B).charpoly = B.charpoly) :
    (Finset.univ.filter (fun i => 0 < hB.eigenvalues i)).card =
      (Finset.univ.filter (fun i => hB.eigenvalues i < 0)).card := by
  -- From `h : (-B).charpoly = B.charpoly`, apply `(Matrix.IsHermitian.eigenvalues_eq_eigenvalues_iff (hB.neg) hB).mpr h` to get `(hB.neg).eigenvalues = μ`.
  have h_neg_eigenvalues : (hB.neg).eigenvalues = hB.eigenvalues := by
    exact Matrix.IsHermitian.eigenvalues_eq_eigenvalues_iff ( hB.neg ) hB |>.mpr h;
  -- From `h_neg_eigenvalues`, we have `M = M.map Neg.neg`.
  have h_neg_eigenvalues_multiset : (Finset.univ.val.map hB.eigenvalues) = (Finset.univ.val.map hB.eigenvalues).map Neg.neg := by
    convert neg_eigenvalues_multiset B hB using 1;
    rw [ h_neg_eigenvalues ];
  convert countP_pos_eq_countP_neg_of_map_neg_eq _ h_neg_eigenvalues_multiset using 1;
  · rw [ Multiset.countP_map ];
    rfl;
  · rw [ Multiset.countP_map ] ; aesop;

end PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia
