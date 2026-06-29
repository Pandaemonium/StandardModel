import Mathlib

open scoped BigOperators
open scoped Real

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

/-!
# Gate C1 — tetrahedral free symbol and branch-mass window (audit + formalization)

This file formalizes the *finite, model-independent* mathematical content of the
proposed 3+1-dimensional Null-Edge Overlap free symbol on a tetrahedral null
coframe.  It deliberately does **not** assert any interacting/gauge theorem, any
anomaly or determinant-line statement, or `GateC1_NU`.

## Setup

Four future-directed null vectors `n_A = (1, v_A)`, `A = 1..4`, with `v_A` the
vertices of a regular tetrahedron normalised so that

* `∑_A v_A = 0`,
* `∑_A v_A^i v_A^j = (4/3) δ^{ij}`  (so `v_A·v_A = 1`, `v_A·v_B = -1/3`).

The Clifford coframe is `B_A = (1/4) γ4 + (3/4) v_A^i γ_i`.

The audited claims are encoded below as named theorems.  We work over an abstract
real module `M` standing for the linear span of the Dirac matrices, so that no
physics repository is needed: `γ4` is `g0 : M` and `γ_i` is `g : Fin 3 → M`.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetrahedralBranchWindow

/-! ## 1. Coframe identities (abstract, from the tetrahedral moment identities)

`tetrahedral_B_sum`        : `∑_A B_A = γ4`
`tetrahedral_B_weighted_sum`: `∑_A v_A^j B_A = γ_j`

Both follow purely linearly from `∑_A v_A = 0` and `∑_A v_A^i v_A^j = (4/3)δ`. -/

section Coframe

variable {M : Type*} [AddCommGroup M] [Module ℝ M]

/-- The Clifford coframe element `B_A = (1/4) γ4 + (3/4) v_A^i γ_i`. -/
noncomputable def Bmat (g0 : M) (g : Fin 3 → M) (v : Fin 4 → Fin 3 → ℝ) (A : Fin 4) : M :=
  (1 / 4 : ℝ) • g0 + (3 / 4 : ℝ) • ∑ i, v A i • g i

variable (g0 : M) (g : Fin 3 → M) (v : Fin 4 → Fin 3 → ℝ)

/-
**Coframe sum identity**: `∑_A B_A = γ4`, using only `∑_A v_A = 0`.
-/
theorem tetrahedral_B_sum (hv0 : ∀ i, ∑ A, v A i = 0) :
    ∑ A, Bmat g0 g v A = g0 := by
  convert Finset.sum_add_distrib using 1;
  simp +decide [ ← Finset.smul_sum ];
  rw [ ← Finset.sum_comm ] ; simp_all +decide [ ← Finset.sum_smul ] ;
  norm_num [ ← smul_assoc ]

/-
**Weighted coframe identity**: `∑_A v_A^j B_A = γ_j`, using the second moment
identity `∑_A v_A^i v_A^j = (4/3) δ^{ij}` (and the first moment).
-/
theorem tetrahedral_B_weighted_sum
    (hv0 : ∀ i, ∑ A, v A i = 0)
    (hmom : ∀ i j, ∑ A, v A i * v A j = (4 / 3) * (if i = j then (1 : ℝ) else 0)) :
    ∀ j, ∑ A, v A j • Bmat g0 g v A = g j := by
  intro j
  unfold Bmat;
  simp +decide only [Finset.smul_sum, smul_smul, mul_comm, smul_add, Finset.sum_add_distrib];
  simp +decide only [← Finset.sum_smul, ← mul_assoc, ← Finset.sum_comm];
  simp +decide [ ← Finset.sum_mul, hv0, hmom ]

end Coframe

/-! ## 2. A concrete realisation of the tetrahedral moments

The explicit vertices `v_A = w_A / √3` with `w_A ∈ {±1}^3` (alternating-sign
pattern) realise the abstract hypotheses above, certifying that the moment
identities are consistent (not vacuous). -/

section Concrete

/-- Unscaled tetrahedron vertices with `±1` coordinates. -/
def wTetra : Fin 4 → Fin 3 → ℝ :=
  ![![1, 1, 1], ![1, -1, -1], ![-1, 1, -1], ![-1, -1, 1]]

/-- Normalised regular-tetrahedron vertices `v_A = w_A / √3`. -/
noncomputable def vTetra (A : Fin 4) (i : Fin 3) : ℝ := wTetra A i / Real.sqrt 3

/-
The first moment `∑_A v_A = 0` holds for the concrete vertices.
-/
theorem vTetra_sum_zero : ∀ i, ∑ A, vTetra A i = 0 := by
  unfold vTetra wTetra;
  norm_num [ Fin.forall_fin_succ, Fin.sum_univ_succ ];
  ring_nf; norm_num;

/-
The second moment `∑_A v_A^i v_A^j = (4/3) δ^{ij}` holds for the concrete
vertices.
-/
theorem vTetra_moment :
    ∀ i j, ∑ A, vTetra A i * vTetra A j = (4 / 3) * (if i = j then (1 : ℝ) else 0) := by
  unfold vTetra;
  norm_num [ Fin.forall_fin_succ, wTetra ];
  norm_num [ Fin.sum_univ_succ, Fin.ext_iff ] ; ring_nf ; norm_num

end Concrete

/-! ## 3–4. Linear independence / branch-counting input (affine independence)

The four homogeneous vectors `(1, v_A)` are linearly independent in `ℝ⁴`.  This is
the *lattice-duality / affine-independence* fact underpinning both

* the Clifford-coframe independence of the `B_A` (Q2), and
* the inference `∑_A B_A sin(k_A) = 0  →  sin(k_A) = 0 ∀ A` (Q3),

since the coefficient column `(1/4, (3/4) v_A)` is just `(1, v_A)` rescaled by the
nonzero factors `1/4, 3/4`.  We phrase it as injectivity of the coefficient map,
which is the form actually used for branch counting. -/

section Independence

/-
**Affine independence of the tetrahedral coframe.**  If a real combination of
the homogeneous rows `(1, w_A)` vanishes componentwise, all coefficients vanish.
The four scalar equations are the `γ4` component and the three `γ_i` components.
-/
theorem tetra_homogeneous_injective (c : Fin 4 → ℝ)
    (h0 : c 0 + c 1 + c 2 + c 3 = 0)
    (h1 : c 0 * wTetra 0 0 + c 1 * wTetra 1 0 + c 2 * wTetra 2 0 + c 3 * wTetra 3 0 = 0)
    (h2 : c 0 * wTetra 0 1 + c 1 * wTetra 1 1 + c 2 * wTetra 2 1 + c 3 * wTetra 3 1 = 0)
    (h3 : c 0 * wTetra 0 2 + c 1 * wTetra 1 2 + c 2 * wTetra 2 2 + c 3 * wTetra 3 2 = 0) :
    c 0 = 0 ∧ c 1 = 0 ∧ c 2 = 0 ∧ c 3 = 0 := by
  simp +decide [ wTetra ] at h1 h2 h3;
  exact ⟨ by linarith, by linarith, by linarith, by linarith ⟩

/-
**Branch inference (Q3).**  Working in the abstract Dirac module, suppose
`g0, g 0, g 1, g 2` are linearly independent and the coefficient columns of the
`B_A` are the homogeneous rows `(1/4, (3/4) v_A)` with `v = vTetra`.  Then a
vanishing `sin`-weighted sum forces every `sin(k_A)` to vanish.  We state the
combinatorial core: vanishing of the four component sums forces each weight to
be zero.
-/
theorem B_sin_branch_inference (k : Fin 4 → ℝ)
    (h0 : Real.sin (k 0) + Real.sin (k 1) + Real.sin (k 2) + Real.sin (k 3) = 0)
    (h1 : Real.sin (k 0) * wTetra 0 0 + Real.sin (k 1) * wTetra 1 0
        + Real.sin (k 2) * wTetra 2 0 + Real.sin (k 3) * wTetra 3 0 = 0)
    (h2 : Real.sin (k 0) * wTetra 0 1 + Real.sin (k 1) * wTetra 1 1
        + Real.sin (k 2) * wTetra 2 1 + Real.sin (k 3) * wTetra 3 1 = 0)
    (h3 : Real.sin (k 0) * wTetra 0 2 + Real.sin (k 1) * wTetra 1 2
        + Real.sin (k 2) * wTetra 2 2 + Real.sin (k 3) * wTetra 3 2 = 0) :
    ∀ A, Real.sin (k A) = 0 := by
  unfold wTetra at *;
  simp_all +decide [ Fin.forall_fin_succ ];
  exact ⟨ by linarith, by linarith, by linarith, by linarith ⟩

end Independence

/-! ## 4. Branch count

On the oblique null-edge Brillouin torus, *assuming the four `k_A` are independent
`2π`-periodic angle coordinates* (the lattice-duality hypothesis, see notes), the
condition `sin(k_A) = 0` has exactly two solutions per coordinate, hence `2⁴ = 16`
naive branches.  We encode the per-coordinate fact analytically and the total
count combinatorially. -/

section BranchCount

/-
The zeros of `sin` in one fundamental period `[0, 2π)` are exactly `{0, π}`:
two solutions per null-edge coordinate.
-/
theorem sin_zeros_in_period :
    {x : ℝ | x ∈ Set.Ico 0 (2 * Real.pi) ∧ Real.sin x = 0} = {0, Real.pi} := by
  ext x;
  constructor;
  · intro hx
    obtain ⟨hx_range, hx_sin⟩ := hx
    have hx_int : ∃ n : ℤ, x = n * Real.pi := by
      rw [ Real.sin_eq_zero_iff ] at hx_sin ; tauto;
    rcases hx_int with ⟨ n, rfl ⟩ ; rcases n with ⟨ _ | _ | n ⟩ <;> norm_num at * <;> nlinarith [ Real.pi_pos ];
  · rintro ( rfl | rfl ) <;> exact ⟨ ⟨ by linarith [ Real.pi_pos ], by linarith [ Real.pi_pos ] ⟩, by norm_num ⟩

/-
**16 naive branches.**  A branch is a choice, per coordinate, of `0` or `π`
(modelled by `Fin 4 → Bool`); there are exactly `2⁴ = 16` of them.
-/
theorem branch_count : Fintype.card (Fin 4 → Bool) = 16 := by
  rfl

end BranchCount

/-! ## 5–6. Branch masses and the Wilson-overlap sign window

At a branch `s : Fin 4 → Bool` (with `k_A = π` iff `s A`), `D_ne⁰ = 0` (all
`sin = 0`) and the scalar Wilson term contributes `2` per `π`-coordinate, giving
the branch mass `m_n = (2 r n − ρ)/a` where `n` is the number of `π`-coordinates.

The window `0 < ρ < 2r` then yields the usual overlap sign pattern:
`m_0 < 0` at the origin and `m_n > 0` for the `n = 1..4` doublers. -/

section BranchMass

/-
`sin` vanishes at every branch coordinate.
-/
theorem sin_branch_zero (s : Fin 4 → Bool) (A : Fin 4) :
    Real.sin (if s A then Real.pi else 0) = 0 := by
  split_ifs <;> norm_num

/-
**Scalar Wilson term at a branch.**  `∑_A (1 − cos k_A) = 2 n`, where
`n = #{A : k_A = π}`.
-/
theorem wilson_sum_branch (s : Fin 4 → Bool) :
    ∑ A, (1 - Real.cos (if s A then Real.pi else 0))
      = 2 * ((Finset.univ.filter (fun A => s A = true)).card : ℝ) := by
  rw [ Finset.card_filter ];
  rw [ Nat.cast_sum, Finset.mul_sum ] ; congr ; ext A ; split_ifs <;> norm_num

/-- The branch mass with `n` doubler directions excited: `m_n = (2 r n − ρ)/a`. -/
noncomputable def branchMass (a r rho : ℝ) (n : ℕ) : ℝ := (2 * r * n - rho) / a

/-
**Mass identity from the Wilson term.**  The scalar coefficient
`(r/a)·∑_A(1−cos k_A) − ρ/a` of `γ5` at a branch with `n` `π`-coordinates equals
`branchMass a r rho n`.
-/
theorem branchMass_from_wilson (a r rho : ℝ) (s : Fin 4 → Bool)
    (n : ℕ) (hn : (Finset.univ.filter (fun A => s A = true)).card = n) :
    (r / a) * (∑ A, (1 - Real.cos (if s A then Real.pi else 0))) - rho / a
      = branchMass a r rho n := by
  rw [ wilson_sum_branch, hn ];
  unfold branchMass; ring;

/-
**`m_0 < 0` (origin branch).**  With `a > 0` and `ρ > 0`.
-/
theorem branch_mass_negative_origin (a r rho : ℝ) (ha : 0 < a) (hrho : 0 < rho) :
    branchMass a r rho 0 < 0 := by
  unfold branchMass; ring_nf; norm_num [ ha, hrho ] ;

/-
**`m_n > 0` for the `n = 1,…,4` doublers.**  With `a > 0`, `0 < ρ` and
`ρ < 2r` (the proposed branch-mass window `0 < ρ < 2r`).
-/
theorem branch_mass_positive_doublers (a r rho : ℝ) (ha : 0 < a)
    (hrho : 0 < rho) (hwin : rho < 2 * r) :
    ∀ n : ℕ, 1 ≤ n → n ≤ 4 → 0 < branchMass a r rho n := by
  intros n hn1 hn4; unfold branchMass; rw [ lt_div_iff₀ ha ] ; nlinarith [ show ( n : ℝ ) ≥ 1 by norm_cast ] ;

end BranchMass

end TetrahedralBranchWindow
end GateC1
end NullEdge
end Draft
end PhysicsSM
