import Mathlib

open scoped BigOperators

/-!
# Gate C1: scalar Wilson vs. flavored branch mass — the branch-mass classification problem

This file formalizes the *mathematical core* of the Gate C1 decision: the
finite branch-mass interpolation theorem (a Walsh–Hadamard statement) together
with the scalar-Wilson degeneracy obstruction it resolves.

Physical dictionary.

* A **branch point** of the `n`-axis null-edge graph is, for each axis `a`, the
  choice of whether `cos k_a = +1` or `cos k_a = -1`.  These are exactly the
  `2 ^ n` corners of the Brillouin zone; for `n = 4` there are `16` of them.
* The candidate flavored branch mass is
  `a · M_br(p) = ∑_{I ⊆ {1..n}} c_I ∏_{A ∈ I} cos k_A`.  Restricted to branch
  points this is the **Walsh transform** `walsh` of the coefficient vector `c`.
* "Scalar Wilson is enough" means a single profile `W_ne` (plus a constant mass
  shift) already lifts every unwanted branch.  It *fails* precisely when two
  branches carry equal Wilson value, which no constant shift can separate.

The headline results are:

* `chi_orthogonality` — orthogonality of the cos-product (Walsh) basis on the
  `2^n` branch points;
* `walsh_bijective` / `branch_mass_interpolation` — the cos-product basis can
  realize *arbitrary* branch-mass profiles on the branch points (finite Fourier
  inversion); specialized to `n = 4` (`16` points) in
  `branch_mass_interpolation_four`;
* `scalar_shift_preserves_degeneracy` — the scalar-Wilson obstruction: a
  constant shift never separates a Wilson-degenerate pair;
* `walsh_can_separate` — the cos-product mass *does* separate any distinct pair,
  with prescribed values.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1

/-- A branch point of the `n`-axis null-edge graph: for each axis a Boolean,
`false ↦ cos k = +1`, `true ↦ cos k = -1`.  There are `2 ^ n` of them. -/
abbrev Branch (n : ℕ) := Fin n → Bool

/-- A cos-product monomial `∏_{A ∈ I} cos k_A`, encoded by its index set `I`
as a Boolean indicator on axes. -/
abbrev Mono (n : ℕ) := Fin n → Bool

/-- Value of `cos k_a` at a branch point. -/
noncomputable def cosval {n : ℕ} (s : Branch n) (a : Fin n) : ℝ :=
  if s a then -1 else 1

/-- The cos-product basis function `χ_I(s) = ∏_{A ∈ I} cos k_A` at branch point `s`. -/
noncomputable def chi {n : ℕ} (I : Mono n) (s : Branch n) : ℝ :=
  ∏ a, if I a then cosval s a else 1

/-- Branch-mass synthesis: monomial coefficients `c` ↦ branch-mass profile
`a·M_br(s) = ∑_I c_I χ_I(s)`. -/
noncomputable def walsh {n : ℕ} (c : Mono n → ℝ) (s : Branch n) : ℝ :=
  ∑ I, c I * chi I s

/-- Branch-mass analysis (inverse transform). -/
noncomputable def walshInv {n : ℕ} (f : Branch n → ℝ) (I : Mono n) : ℝ :=
  (1 / (2 ^ n : ℝ)) * ∑ s, f s * chi I s

/-- The cos-product kernel is symmetric in its monomial and branch-point
arguments: `χ_I(s) = ∏_a [I_a ∧ s_a ↦ -1]` only depends on the conjunction. -/
theorem chi_symm {n : ℕ} (I s : Mono n) : chi I s = chi s I := by
  exact Finset.prod_congr rfl fun x _ => by unfold cosval; aesop;

/-- Orthogonality of the cos-product (Walsh) basis over the `2^n` branch points. -/
theorem chi_orthogonality {n : ℕ} (I J : Mono n) :
    ∑ s : Branch n, chi I s * chi J s = if I = J then (2 ^ n : ℝ) else 0 := by
  split_ifs with h;
  · -- Since $I = J$, we have $\chi_I(s) = \chi_J(s)$ for all $s$, and thus $\chi_I(s) \chi_J(s) = \chi_I(s)^2$.
    simp [h, chi];
    simp +decide [ ← Finset.prod_mul_distrib, cosval ];
    rw [ Finset.sum_eq_card_nsmul ] <;> aesop;
  · -- Since $I \neq J$, there exists an axis $a$ such that $I a \neq J a$.
    obtain ⟨a, ha⟩ : ∃ a, I a ≠ J a := by
      exact Function.ne_iff.mp h;
    -- By Fubini's theorem, we can interchange the order of summation.
    have h_fubini : ∑ s : Fin n → Bool, chi I s * chi J s = (∏ a : Fin n, (∑ b : Bool, (if I a then (if b then -1 else 1) else 1) * (if J a then (if b then -1 else 1) else 1))) := by
      rw [ Finset.prod_sum ];
      refine' Finset.sum_bij ( fun s _ => fun i _ => s i ) _ _ _ _ <;> simp +decide [ chi ];
      · simp +decide [ funext_iff ];
      · exact fun b => ⟨ fun i => b i ( Finset.mem_univ i ), rfl ⟩;
      · intro s; rw [ ← Finset.prod_mul_distrib ] ; congr; ext x; unfold cosval; aesop;
    rw [ h_fubini, Finset.prod_eq_zero ( Finset.mem_univ a ) ] ; aesop

/-- `walshInv` is a right inverse of `walsh`: every branch-mass profile is
realized by a cos-product coefficient vector. -/
theorem walsh_walshInv {n : ℕ} (f : Branch n → ℝ) : walsh (walshInv f) = f := by
  -- By definition of Walsh transform and its inverse, we have:
  have h_walsh_inv : ∀ s : Branch n, (walsh (walshInv f)) s = ∑ t : Branch n, f t * (1 / (2 ^ n : ℝ)) * (∑ I :Mono n, (chi I t) * (chi I s)) := by
    unfold walsh walshInv; simp +decide [ mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _ ] ;
    exact fun s => Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by ring );
  -- By orthogonality of the cos-product basis, we have:
  have h_orthogonality : ∀ t s : Branch n, (∑ I : Mono n, (chi I t) * (chi I s)) = if t = s then (2 ^ n : ℝ) else 0 := by
    intro t s; rw [ ← chi_orthogonality ] ;
    simp +decide only [chi_symm];
  ext s; specialize h_walsh_inv s; aesop;

/-- `walshInv` is a left inverse of `walsh`: coefficients are uniquely
recovered from the branch-mass profile. -/
theorem walshInv_walsh {n : ℕ} (c : Mono n → ℝ) : walshInv (walsh c) = c := by
  ext I;
  unfold walshInv walsh;
  simp +decide only [Finset.sum_mul _ _ _];
  rw [ Finset.sum_comm, Finset.mul_sum ];
  simp +decide [ ← Finset.mul_sum _ _ _, mul_comm, mul_left_comm, chi_orthogonality ]

/-- **Branch-mass interpolation (Walsh–Hadamard).** The cos-product synthesis
map is a bijection: arbitrary branch masses can be assigned on the branch
points, and the coefficients are uniquely determined. -/
theorem walsh_bijective {n : ℕ} : Function.Bijective (walsh (n := n)) :=
  Function.bijective_iff_has_inverse.2
    ⟨walshInv, walshInv_walsh, walsh_walshInv⟩

/-- **Branch-mass interpolation, existence-and-uniqueness form.** For every
target branch-mass profile `f` there is a unique cos-product coefficient
vector realizing it. -/
theorem branch_mass_interpolation {n : ℕ} (f : Branch n → ℝ) :
    ∃! c : Mono n → ℝ, walsh c = f := by
  refine ⟨walshInv f, walsh_walshInv f, ?_⟩
  intro c hc
  have := walsh_bijective.1 (a₁ := c) (a₂ := walshInv f)
  exact this (by rw [hc, walsh_walshInv])

/-- There are exactly `16` branch points for the four-null-edge (tetrahedral)
model. -/
theorem card_branch_four : Fintype.card (Branch 4) = 16 := by decide

/-- **Branch-mass interpolation on the 16 branch points** (the four-null-edge
case): arbitrary branch masses are realizable and the coefficients are unique. -/
theorem branch_mass_interpolation_four (f : Branch 4 → ℝ) :
    ∃! c : Mono 4 → ℝ, walsh c = f :=
  branch_mass_interpolation f

/-- **Scalar-Wilson obstruction.** If a Wilson profile `W` is already degenerate
on two branch points (`W pj = W pk`), then adding any *constant* (scalar) mass
shift `m` leaves them degenerate.  A scalar term cannot separate a
Wilson-degenerate branch pair. -/
theorem scalar_shift_preserves_degeneracy {n : ℕ} (W : Branch n → ℝ) (m : ℝ)
    {pj pk : Branch n} (h : W pj = W pk) :
    (fun s => W s + m) pj = (fun s => W s + m) pk := by
  simp only [h]

/-- **Scalar-shift no-go form.** If two branch points are already degenerate
under a Wilson profile `W`, then there is no constant scalar shift that makes
their shifted values distinct. -/
theorem no_scalar_shift_separates_degenerate_pair {n : ℕ} (W : Branch n → ℝ)
    {pj pk : Branch n} (h : W pj = W pk) :
    ¬ ∃ m : ℝ, (fun s => W s + m) pj ≠ (fun s => W s + m) pk := by
  rintro ⟨m, hm⟩
  exact hm (scalar_shift_preserves_degeneracy W m h)

/-- **Cos-product separation.** For any two *distinct* branch points and any
prescribed target values, there is a cos-product branch mass realizing those
values — so a flavored `M_br` lifts the degeneracy that scalar Wilson cannot. -/
theorem walsh_can_separate {n : ℕ} {pj pk : Branch n} (h : pj ≠ pk) (u v : ℝ) :
    ∃ c : Mono n → ℝ, walsh c pj = u ∧ walsh c pk = v := by
  refine ⟨walshInv (fun s => if s = pj then u else if s = pk then v else 0), ?_, ?_⟩
  · rw [walsh_walshInv]; simp
  · rw [walsh_walshInv]; simp [Ne.symm h]

end GateC1
end NullEdge
end Draft
end PhysicsSM
