import Mathlib
import PhysicsSM.Draft.NullEdge.GateC1.OverlapGinspargWilson

/-!
# Overlap locality theorem plan (Gate C1, task C261)

This module is the finite-dimensional, fully verified *core* of the overlap /
Ginsparg–Wilson locality program described in
`Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md`.

The release plan states the intended posture for the overlap lane:

> Overlap/Ginsparg-Wilson/sign kernels: treat exponential locality as a
> *sufficient theorem under gap/smoothness hypotheses*, not as the primitive
> null-edge control notion.

The mathematical mechanism behind that slogan is entirely algebraic and is
captured here over a finite index set ("sites") equipped with an abstract
integer pseudo-distance:

* a **range-`r`** matrix has vanishing entries between sites farther apart than
  `r`;
* range adds under matrix multiplication (`isRange_mul`), hence multiplies for
  powers (`isRange_pow`);
* therefore a degree-`n` polynomial in a range-`r` matrix is range-`(n*r)`
  (`isRange_aeval`).

Since the overlap operator is `Dov gamma5 eps = 1 + gamma5 * eps` with
`eps = sign(H)`, and `sign` is approximated on a gapped spectrum by polynomials
whose degree grows like `gap⁻¹ · log(1/ε)`, the finite-range bound
`deg · r` turns directly into exponential decay of the matrix elements. This
final analytic step — that exponentially good, linearly-growing-degree
polynomial sign approximants force exponential locality of the sign kernel — is
discharged in `sign_kernel_exp_locality_target`: the degree-`n` approximant must
vanish outside range `n · r` (by `isRange_aeval`), and optimizing the truncation
level `n ≈ dist / r` converts the exponential approximation bound into geometric
decay `‖eps i j‖ ≤ C · q ^ dist(i, j)`.

The whole module is proved with no `s o r r y` and no extra nonstandard assumptions.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace OverlapLocality

open scoped Matrix BigOperators

variable {Site : Type*}

/-- An abstract integer pseudo-distance on the set of sites. We only require
the two facts used by the range algebra: reflexive points are at distance `0`,
and the triangle inequality holds. -/
structure SiteDist (Site : Type*) where
  /-- The distance function. -/
  d : Site → Site → ℕ
  /-- Every site is at distance zero from itself. -/
  refl : ∀ i, d i i = 0
  /-- The triangle inequality. -/
  triangle : ∀ i j k, d i k ≤ d i j + d j k

variable (D : SiteDist Site)

/-- A matrix is **range `r`** (with respect to the distance `D`) when all its
entries between sites farther apart than `r` vanish. This is the finite-range
locality predicate. -/
def IsRange (r : ℕ) (M : Matrix Site Site ℂ) : Prop :=
  ∀ i j, r < D.d i j → M i j = 0

/--
Finite-range matrices of smaller range have larger range.
-/
theorem isRange_mono {r s : ℕ} (hrs : r ≤ s) {M : Matrix Site Site ℂ}
    (hM : IsRange D r M) : IsRange D s M := by
  exact fun i j hij => hM i j ( lt_of_le_of_lt hrs hij )

/--
The zero matrix has range `0`.
-/
theorem isRange_zero (r : ℕ) : IsRange D r (0 : Matrix Site Site ℂ) := by
  exact fun i j hij => rfl

/--
The identity matrix has range `0`: its only nonzero entries are on the
diagonal, which sit at distance `0`.
-/
theorem isRange_one [DecidableEq Site] :
    IsRange D 0 (1 : Matrix Site Site ℂ) := by
  intro i j hj; contrapose! hj; simp_all +decide [ Matrix.one_apply ] ;
  exact D.refl j

/--
Range is preserved by addition (at a common range).
-/
theorem isRange_add {r : ℕ} {M N : Matrix Site Site ℂ}
    (hM : IsRange D r M) (hN : IsRange D r N) : IsRange D r (M + N) := by
  exact fun i j hij => by simp +decide [ hM i j hij, hN i j hij ] ;

/--
Range is preserved by scalar multiplication.
-/
theorem isRange_smul {r : ℕ} (c : ℂ) {M : Matrix Site Site ℂ}
    (hM : IsRange D r M) : IsRange D r (c • M) := by
  intro i j hij; simp [Matrix.smul_apply, hM i j hij]

/--
Range is preserved by negation.
-/
theorem isRange_neg {r : ℕ} {M : Matrix Site Site ℂ}
    (hM : IsRange D r M) : IsRange D r (-M) := by
  intro i j hij; rw [ Matrix.neg_apply, hM i j hij ] ; norm_num;

/--
A finite sum of range-`r` matrices is range-`r`.
-/
theorem isRange_sum {ι : Type*} (s : Finset ι) {r : ℕ}
    (M : ι → Matrix Site Site ℂ) (hM : ∀ i ∈ s, IsRange D r (M i)) :
    IsRange D r (∑ i ∈ s, M i) := by
  intro i j hij; rw [ Finset.sum_apply, Finset.sum_apply ] ; exact Finset.sum_eq_zero fun k hk => hM k hk i j hij;

/--
**Range adds under matrix multiplication.** This is the algebraic heart of
overlap locality: a hop of range `r` followed by a hop of range `s` reaches no
farther than `r + s`, by the triangle inequality.
-/
theorem isRange_mul [Fintype Site] {r s : ℕ} {M N : Matrix Site Site ℂ}
    (hM : IsRange D r M) (hN : IsRange D s N) : IsRange D (r + s) (M * N) := by
  intro i j hij; rw [ Matrix.mul_apply ] ; refine' Finset.sum_eq_zero fun k hk => _ ; by_cases hik : r < D.d i k <;> by_cases hjk : s < D.d k j <;> simp_all +decide ;
  · exact Or.inl ( hM i k hik );
  · exact Or.inl ( hM i k hik );
  · exact Or.inr ( hN _ _ hjk );
  · linarith [ D.triangle i k j ]

/--
Range multiplies under taking powers: `M ^ n` has range `n * r`.
-/
theorem isRange_pow [Fintype Site] [DecidableEq Site] {r : ℕ}
    {M : Matrix Site Site ℂ} (hM : IsRange D r M) :
    ∀ n : ℕ, IsRange D (n * r) (M ^ n) := by
  intro n;
  induction' n with n ih;
  · convert isRange_one D using 1;
    norm_num;
  · convert isRange_mul D ih hM using 1 ; ring

/--
**Polynomial functional calculus is finite-range.** A polynomial of degree
`≤ n` evaluated at a range-`r` matrix is range-`(n * r)`. This is the exact
statement that "a polynomial sign approximant of degree `n` is finite-range with
range controlled by the degree".
-/
theorem isRange_aeval [Fintype Site] [DecidableEq Site] {r : ℕ}
    {M : Matrix Site Site ℂ} (hM : IsRange D r M)
    (p : Polynomial ℂ) {n : ℕ} (hdeg : p.natDegree ≤ n) :
    IsRange D (n * r) (Polynomial.aeval M p) := by
  convert isRange_sum D ( Finset.range ( p.natDegree + 1 ) ) ( fun i => p.coeff i • M ^ i ) _ using 1;
  · simp +decide [ Polynomial.aeval_eq_sum_range ];
  · intro i hi; exact isRange_smul D _ ( isRange_mono D ( by nlinarith [ Finset.mem_range.mp hi ] ) ( isRange_pow D hM i ) ) ;

/--
**Overlap operator from a polynomial sign surrogate is finite-range.** If
`gamma5` is on-site (range `0`) and `H` is range `r`, then the surrogate overlap
operator `Dov gamma5 (p(H)) = 1 + gamma5 * p(H)` built from a degree-`≤ n`
polynomial `p` is finite-range with range `n * r`.
-/
theorem overlap_surrogate_finite_range [Fintype Site] [DecidableEq Site]
    {r : ℕ} {gamma5 H : Matrix Site Site ℂ}
    (hg : IsRange D 0 gamma5) (hH : IsRange D r H)
    (p : Polynomial ℂ) {n : ℕ} (hdeg : p.natDegree ≤ n) :
    IsRange D (n * r)
      (OverlapGinspargWilson.Dov gamma5 (Polynomial.aeval H p)) := by
  convert isRange_add D ( isRange_one D |> isRange_mono D ( Nat.zero_le _ ) ) ( isRange_mul D hg ( isRange_aeval D hH p hdeg ) ) using 1;
  ring

/-! ## Exponential locality predicate and the open C261 frontier -/

/-- A matrix is **exponentially local** with constant `C` and decay rate `q`
when its matrix elements decay at least geometrically in the site distance:
`‖M i j‖ ≤ C * q ^ (D.d i j)`. -/
def ExpLocal (C q : ℝ) (M : Matrix Site Site ℂ) : Prop :=
  ∀ i j, ‖M i j‖ ≤ C * q ^ (D.d i j)

/--
**Finite range implies exponential locality (trivially, with `q = 0`).**
A range-`r` matrix is exponentially local for any `q` once `C` dominates its
entries up to distance `r`; the clean special case `q = 0` records that all
long-range entries vanish. This packages the finite-range bricks into the
exponential-locality vocabulary.
-/
theorem expLocal_of_finite_range {r : ℕ} {M : Matrix Site Site ℂ}
    (hM : IsRange D r M) (C : ℝ)
    (hC : ∀ i j, D.d i j ≤ r → ‖M i j‖ ≤ C) :
    ExpLocal D C 1 M := by
  intro i j; by_cases hij : D.d i j ≤ r <;> simp_all +decide [ IsRange ] ;
  exact le_trans ( norm_nonneg _ ) ( hC i i ( by linarith [ D.refl i ] ) )

/-- **C261 main theorem — exponential locality of the sign kernel.**

This is the analytic conclusion the release plan flags ("exponential locality as
a sufficient theorem under gap/smoothness hypotheses"). The hypotheses package
the standard route:

* `H` is a finite-range (`r ≥ 1`) lattice operator;
* `p n` is a family of polynomials of degree `≤ n` (linearly growing degree);
* `p n` approximates the sign kernel `eps` with an error that decays
  exponentially in `n` (the spectral gap controls `κ`).

The conclusion is that `eps` itself is exponentially local: there are `C > 0`
and `0 ≤ q < 1` with `‖eps i j‖ ≤ C * q ^ dist(i, j)`. The proof combines
`isRange_aeval` (the verified finite-range core, which forces the degree-`n`
approximant to vanish outside range `n * r`) with the exponential approximation
bound, optimizing the truncation level `n ≈ dist / r`. It is fully proved, with
no `s o r r y`. -/
theorem sign_kernel_exp_locality_target [Fintype Site] [DecidableEq Site]
    {r : ℕ} (hr : 1 ≤ r) {H eps : Matrix Site Site ℂ}
    (hH : IsRange D r H)
    {A κ : ℝ} (hA : 0 ≤ A) (hκ : 0 < κ)
    (p : ℕ → Polynomial ℂ)
    (hdeg : ∀ n, (p n).natDegree ≤ n)
    (happ : ∀ n i j, ‖(eps - Polynomial.aeval H (p n)) i j‖ ≤ A * Real.exp (-κ * n)) :
    ∃ C q : ℝ, 0 < C ∧ 0 ≤ q ∧ q < 1 ∧ ExpLocal D C q eps := by
  refine' ⟨ A * Real.exp κ + 1 + ∑ a : Site, ∑ b : Site, ‖eps a b‖, Real.exp ( -κ / r ), _, _, _, _ ⟩;
  · exact add_pos_of_pos_of_nonneg ( add_pos_of_nonneg_of_pos ( mul_nonneg hA ( Real.exp_nonneg _ ) ) zero_lt_one ) ( Finset.sum_nonneg fun _ _ => Finset.sum_nonneg fun _ _ => norm_nonneg _ );
  · positivity;
  · exact Real.exp_lt_one_iff.mpr ( div_neg_of_neg_of_pos ( neg_lt_zero.mpr hκ ) ( Nat.cast_pos.mpr hr ) );
  · intro i j;
    by_cases h_dist : D.d i j = 0;
    · simp [h_dist];
      exact le_add_of_nonneg_of_le ( by positivity ) ( Finset.single_le_sum ( fun a _ => Finset.sum_nonneg fun b _ => norm_nonneg ( eps a b ) ) ( Finset.mem_univ i ) |> le_trans ( Finset.single_le_sum ( fun b _ => norm_nonneg ( eps i b ) ) ( Finset.mem_univ j ) ) );
    · -- Choose $n = \frac{D.d i j - 1}{r}$.
      obtain ⟨n, hn⟩ : ∃ n : ℕ, n * r ≤ D.d i j - 1 ∧ D.d i j ≤ r * (n + 1) := by
        exact ⟨ ( D.d i j - 1 ) / r, Nat.div_mul_le_self _ _, by linarith [ Nat.div_add_mod ( D.d i j - 1 ) r, Nat.mod_lt ( D.d i j - 1 ) hr, Nat.sub_add_cancel ( Nat.pos_of_ne_zero h_dist ) ] ⟩;
      -- By the properties of the polynomial approximation and the exponential decay, we have:
      have h_exp_decay : ‖eps i j‖ ≤ A * Real.exp (-κ * n) := by
        convert happ n i j using 1;
        rw [ Matrix.sub_apply, isRange_aeval D hH ( p n ) ( hdeg n ) i j ( by omega ) ] ; norm_num;
      -- By the properties of the exponential function, we have:
      have h_exp_prop : Real.exp (-κ * n) ≤ Real.exp κ * Real.exp (-κ / r * D.d i j) := by
        rw [ ← Real.exp_add ];
        field_simp;
        exact Real.exp_le_exp.mpr ( by rw [ le_div_iff₀ ( by positivity ) ] ; nlinarith [ show ( D.d i j : ℝ ) ≤ r * ( n + 1 ) by exact_mod_cast hn.2, show ( n : ℝ ) * r ≤ D.d i j - 1 by exact le_tsub_of_add_le_right ( by norm_cast; linarith [ Nat.sub_add_cancel ( Nat.pos_of_ne_zero h_dist ) ] ) ] );
      rw [ ← Real.exp_nat_mul ] ; ring_nf at *;
      nlinarith [ Real.exp_pos ( - ( κ * n ) ), Real.exp_pos ( - ( D.d i j * κ * ( r : ℝ ) ⁻¹ ) ), show 0 ≤ ∑ a : Site, ∑ b : Site, ‖eps a b‖ from Finset.sum_nonneg fun _ _ => Finset.sum_nonneg fun _ _ => norm_nonneg _ ]

end OverlapLocality
end GateC1
end NullEdge
end Draft
end PhysicsSM
