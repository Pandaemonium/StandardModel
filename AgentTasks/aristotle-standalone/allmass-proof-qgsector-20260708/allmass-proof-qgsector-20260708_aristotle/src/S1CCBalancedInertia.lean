/-
# S1-CC: closure is balanced (not positive) on the physical sector

DRAFT (kernel-clean; no `s o r r y`). The kernel core of the Fable call-01
resolution of the central positivity crux (S1-CC), overnight all-mass run
2026-07-08. The full analysis is in the call log
(`AgentTasks/model-calls/claude/2026-07-07-231939-fable-call-01.md`,
Part B) and summarized in the QCD roadmap.

## The finding (grade MEMO for the physics, M for this file)

The nonabelian closure channel is an exact Krein square `Q_C = L^# L`
(kernel-checked elsewhere), but Krein squares carry no positivity. The
crux "is closure positive on the physical sector `V'/N`?" is resolved:
**no - it is exactly BALANCED (Krein signature zero), structurally.** The
mechanism is a grading anticonjugation: the closure bivector
`b = sigma_z (x) 1` satisfies `b^{-1} (J Q_C) b = -(J Q_C)` and preserves
every gauge-defined constraint sector (gauge acts on the color/site factor
alone, commuting with `b`). A matrix congruent to its own negative has
balanced inertia (`n_+ = n_-`). So closure positivity holds only vacuously
(flat Gauss sector); otherwise the channel is honestly signed - which is
exactly what chiral symmetry breaking needs (§8 of the manuscript).

## What this file proves (the house-style rung)

`anticonj_odd_pow_trace_zero`: if an invertible `S` anticonjugates `B`
(`S^{-1} B S = -B`), then every ODD power of `B` is traceless. This is the
odd-power trace identity behind the balanced-inertia route. By itself it is
not an eigenvalue-pairing theorem and uses no Hermitian hypothesis. The
polynomial symmetry is recorded by `anticonj_charpoly_eq`; the inertia
reading itself and the concrete `V'` construction are next rungs (see the
roadmap).

## Claim boundary

`anticonj_odd_pow_trace_zero` is kernel-checked (M). The identification of
`B = J Q_C` and `S = b` on the concrete carrier physical sector, and the
step from odd-moment-vanishing to balanced inertia, are MEMO (Fable Part
B), pending their own Lean rungs. No positivity is claimed; the point is
precisely that closure is NOT positive on the sector.

## Provenance

Fable-5 call-01 (2026-07-08), Part B - the crux resolution and the
recommended house-style rung - [orig]/[interp]; the trace-conjugation and
odd-power algebra is standard - [import].
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Trace is invariant under conjugation by an invertible matrix:
`Tr(S⁻¹ X S) = Tr X`. -/
theorem trace_invOf_conj (S X : Matrix n n ℂ) [Invertible S] :
    (⅟S * X * S).trace = X.trace := by
  rw [Matrix.trace_mul_comm, ← mul_assoc, mul_invOf_self, one_mul]

/-- Conjugation distributes over powers: `(S⁻¹ B S)^m = S⁻¹ B^m S`. -/
theorem conj_pow (S B : Matrix n n ℂ) [Invertible S] (m : ℕ) :
    (⅟S * B * S) ^ m = ⅟S * B ^ m * S := by
  induction m with
  | zero => simp
  | succ m ih =>
    rw [pow_succ, ih, pow_succ]
    have hreassoc : (⅟S * B ^ m * S) * (⅟S * B * S)
        = ⅟S * B ^ m * (S * ⅟S) * B * S := by noncomm_ring
    rw [hreassoc, mul_invOf_self, mul_one]
    noncomm_ring

/-- **Anticonjugation kills odd-power traces (S1-CC flagship).** If an
invertible `S` anticonjugates `B` (`S⁻¹ * B * S = -B`), then every odd
power of `B` is traceless: `Tr(B^(2k+1)) = 0`.

This is a finite trace identity only. It is compatible with the later
balanced-inertia route, but it does not by itself prove eigenvalue pairing,
Hermitian inertia, or positivity/negativity of the closure channel. -/
theorem anticonj_odd_pow_trace_zero (B S : Matrix n n ℂ) [Invertible S]
    (h : ⅟S * B * S = -B) (k : ℕ) :
    (B ^ (2 * k + 1)).trace = 0 := by
  have h1 : ((-B) ^ (2 * k + 1)).trace = (B ^ (2 * k + 1)).trace := by
    rw [← h, conj_pow, trace_invOf_conj]
  have h2 : ((-B) ^ (2 * k + 1)).trace = -(B ^ (2 * k + 1)).trace := by
    rw [Odd.neg_pow ⟨k, rfl⟩, Matrix.trace_neg]
  have key : -(B ^ (2 * k + 1)).trace = (B ^ (2 * k + 1)).trace := h2 ▸ h1
  linear_combination (-(1 : ℂ) / 2) * key

/-- Trace-zero corollary of `anticonj_odd_pow_trace_zero` (the `k = 0`
case). No Hermitian or spectral conclusion is included in this statement. -/
theorem anticonj_trace_zero (B S : Matrix n n ℂ) [Invertible S]
    (h : ⅟S * B * S = -B) : B.trace = 0 := by
  have := anticonj_odd_pow_trace_zero B S h 0
  simpa using this

/-- **Spectrum symmetric under negation (the balanced-inertia essence).**
Anticonjugation `⅟S * B * S = -B` makes `B` similar to `-B`, so their
characteristic polynomials agree: `(-B).charpoly = B.charpoly`. Hence the
eigenvalue multiset of `B` is invariant under `lambda -> -lambda` - the
polynomial-level statement that the spectrum is symmetric about zero, from
which `n_+ = n_-` (balanced Krein inertia) follows for Hermitian `B` by
counting. This is the charpoly rung of the balanced-inertia theorem. -/
theorem anticonj_charpoly_eq (B S : Matrix n n ℂ) [Invertible S]
    (h : ⅟S * B * S = -B) : (-B).charpoly = B.charpoly := by
  rw [← h]
  exact Matrix.charpoly_units_conj' (unitOfInvertible S) B

/-! ## Count helper for the balanced-inertia capstone -/

/-- A real multiset invariant under negation has as many positive entries as
negative entries, counted with multiplicity.

This is the finite combinatorial half of the balanced-inertia capstone. The
remaining spectral bridge is to prove that the Hermitian eigenvalue multiset is
negation-invariant from the characteristic-polynomial symmetry. -/
theorem countP_pos_eq_countP_neg_of_map_neg_eq (s : Multiset ℝ)
    (h : s.map Neg.neg = s) :
    s.countP (fun x => 0 < x) = s.countP (fun x => x < 0) := by
  calc
    s.countP (fun x => 0 < x) = (s.map Neg.neg).countP (fun x => 0 < x) := by
      rw [h]
    _ = s.countP (fun x => 0 < -x) := by
      rw [Multiset.countP_map]
      simp [Multiset.countP_eq_card_filter]
    _ = s.countP (fun x => x < 0) := by
      apply Multiset.countP_congr rfl
      intro x _
      simp

/-- Index-count form of `countP_pos_eq_countP_neg_of_map_neg_eq`.

If the multiset of real values indexed by a finite type is invariant under
negation, the number of positive indexed values equals the number of negative
indexed values. This matches the count shape needed for Hermitian eigenvalues. -/
theorem card_pos_eq_card_neg_of_multiset_map_neg_eq {m : Type*} [Fintype m]
    (f : m → ℝ)
    (h : (Finset.univ.val.map f).map Neg.neg = Finset.univ.val.map f) :
    (Finset.univ.filter (fun i => 0 < f i)).card =
      (Finset.univ.filter (fun i => f i < 0)).card := by
  have hm := countP_pos_eq_countP_neg_of_map_neg_eq (Finset.univ.val.map f) h
  have hpos : (Finset.univ.filter (fun i => 0 < f i)).card =
      (Finset.univ.val.map f).countP (fun x => 0 < x) := by
    rw [Multiset.countP_eq_card_filter, Multiset.filter_map]
    change (Finset.univ.filter (fun i => 0 < f i)).val.card = _
    rw [Finset.filter_val]
    simp
  have hneg : (Finset.univ.filter (fun i => f i < 0)).card =
      (Finset.univ.val.map f).countP (fun x => x < 0) := by
    rw [Multiset.countP_eq_card_filter, Multiset.filter_map]
    change (Finset.univ.filter (fun i => f i < 0)).val.card = _
    rw [Finset.filter_val]
    simp
  rw [hpos, hneg]
  exact hm

/-- Roots of the characteristic polynomial of `-B`, expressed using the
negated Hermitian eigenvalues of `B`.

This is a Mathlib-functional-calculus bridge: `-B` is `cfc (fun x => -x) B`,
so its characteristic polynomial factors with roots `- eigenvalues(B)`. -/
theorem neg_charpoly_roots_eq_map_neg_eigenvalues
    (B : Matrix n n ℂ) (hB : B.IsHermitian) :
    (-B).charpoly.roots =
      Multiset.map (fun x : ℝ => ((-x : ℝ) : ℂ))
        (Finset.univ.val.map hB.eigenvalues) := by
  have hchar :
      (-B).charpoly =
        ∏ i, (Polynomial.X - Polynomial.C ((-hB.eigenvalues i : ℝ) : ℂ)) := by
    have h := Matrix.IsHermitian.charpoly_cfc_eq (A := B) hB (fun x : ℝ => -x)
    have hcfc : cfc (fun x : ℝ => -x) B = -B := cfc_neg_id (R := ℝ) B hB
    rw [hcfc] at h
    simpa using h
  rw [hchar, Polynomial.roots_prod]
  · simp
  · apply Finset.prod_ne_zero_iff.mpr
    intro i _
    exact Polynomial.X_sub_C_ne_zero ((-hB.eigenvalues i : ℝ) : ℂ)

/-- If a Hermitian matrix has the same characteristic polynomial as its
negative, then its real eigenvalue multiset is invariant under negation.

This is the spectral bridge from the polynomial rung
`anticonj_charpoly_eq` to the finite count helper above. -/
theorem hermitian_eigenvalue_multiset_map_neg_eq_of_neg_charpoly
    (B : Matrix n n ℂ) (hB : B.IsHermitian)
    (hsym : (-B).charpoly = B.charpoly) :
    (Finset.univ.val.map hB.eigenvalues).map Neg.neg =
      Finset.univ.val.map hB.eigenvalues := by
  apply Multiset.map_injective (Complex.ofReal_injective)
  simpa [Function.comp_def, Multiset.map_map] using
    calc
      Multiset.map (fun x : ℝ => ((-x : ℝ) : ℂ))
          (Finset.univ.val.map hB.eigenvalues)
          = (-B).charpoly.roots := by
            rw [neg_charpoly_roots_eq_map_neg_eigenvalues]
      _ = B.charpoly.roots := by rw [hsym]
      _ = Multiset.map (RCLike.ofReal ∘ hB.eigenvalues) Finset.univ.val := by
            rw [hB.roots_charpoly_eq_eigenvalues]

/-- Hermitian balanced-count capstone.

If a Hermitian complex matrix has characteristic polynomial invariant under
negation, then the number of positive Hermitian eigenvalues equals the number
of negative Hermitian eigenvalues. This is a finite matrix/eigenvalue count
statement only; it does not identify `B` with a closure operator or prove that a
physical quotient descends. -/
theorem hermitian_balanced_count_of_neg_charpoly
    (B : Matrix n n ℂ) (hB : B.IsHermitian)
    (hsym : (-B).charpoly = B.charpoly) :
    (Finset.univ.filter (fun i => 0 < hB.eigenvalues i)).card =
      (Finset.univ.filter (fun i => hB.eigenvalues i < 0)).card :=
  card_pos_eq_card_neg_of_multiset_map_neg_eq hB.eigenvalues
    (hermitian_eigenvalue_multiset_map_neg_eq_of_neg_charpoly B hB hsym)

/-! ## Lemma 1: the half-constraint rigidity (Gupta-Bleuler is forced) -/

/-- **Half-constraint rigidity (Fable call-01, Part B, Lemma 1).** For the
null pair `c₁ = E₀₁`, `c₂ = E₁₀` on the Clifford factor, a two-covector
constraint charge `Q = c₁ ⊗ G₁ + c₂ ⊗ G₂` (here the `2x2`-over-`B` matrix
`!![0, G₁; G₂, 0]`) is nilpotent iff `G₁ G₂ = 0` AND `G₂ G₁ = 0`. So a
NILPOTENT (BRST-type) Gauss charge on the hyperbolic pair cannot use both
null covectors nontrivially: the Gupta-Bleuler "impose only half the
constraint" is not a modeling choice - it is FORCED by nilpotency.
(`Q² = !![G₁G₂, 0; 0, G₂G₁]`.) -/
theorem half_constraint_rigidity {B : Type*} [Ring B] (G₁ G₂ : B) :
    (!![0, G₁; G₂, 0] : Matrix (Fin 2) (Fin 2) B) ^ 2 = 0
      ↔ G₁ * G₂ = 0 ∧ G₂ * G₁ = 0 := by
  have hsq : (!![0, G₁; G₂, 0] : Matrix (Fin 2) (Fin 2) B)
      * !![0, G₁; G₂, 0] = !![G₁ * G₂, 0; 0, G₂ * G₁] := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two]
  rw [sq, hsq]
  constructor
  · intro hQ
    refine ⟨?_, ?_⟩
    · have := congrFun (congrFun hQ 0) 0; simpa using this
    · have := congrFun (congrFun hQ 1) 1; simpa using this
  · rintro ⟨h1, h2⟩
    ext i j
    fin_cases i <;> fin_cases j <;> simp [h1, h2]

end PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia
