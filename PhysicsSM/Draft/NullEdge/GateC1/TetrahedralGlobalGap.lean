import PhysicsSM.Draft.NullEdge.GateC1.TetrahedralBranchWindow

open scoped BigOperators
open scoped Real

/-!
# Gate C1 tetrahedral global free-gap scaffold

This Draft module isolates the next theorem after the C240 tetrahedral branch
window result.

C240 proves the exact branch table and scalar Wilson branch-mass signs at the
points where every `sin(k_A)` vanishes.  The remaining free-symbol gap theorem
should reduce any possible zero of the full scalar lower-bound expression to
one of those branch points.

This file does not claim `GateC1_NU`, gauge covariance, anomaly closure,
Krein positivity, determinant-line control, or interacting locality.  It is a
finite/free scaffold for the scalar Wilson overlap kernel only.

Proof-status note:

* The scalar Wilson branch-window lemmas below are direct consequences of C240.
* The local finite/free gap proof is now split into two elementary reductions:
  converting period plus vanishing sine into a Boolean branch table, and proving
  that the tetrahedral coefficient norm detects nonzero sine vectors.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetrahedralGlobalGap

/-- Branch angles: `true` means the coordinate is at `pi`, `false` means `0`. -/
noncomputable def branchAngles (s : Fin 4 -> Bool) : Fin 4 -> ℝ :=
  fun A => if s A then Real.pi else 0

/-- Number of `pi` coordinates in a Boolean branch table. -/
def branchCount (s : Fin 4 -> Bool) : ℕ :=
  (Finset.univ.filter (fun A => s A = true)).card

/-- Scalar Wilson coefficient before division by the lattice spacing. -/
noncomputable def wilsonScalar (r rho : ℝ) (k : Fin 4 -> ℝ) : ℝ :=
  r * (∑ A, (1 - Real.cos (k A))) - rho

/--
At a Boolean branch, every sine coordinate vanishes.

This is the branch-point part of C240 in a reusable local notation.
-/
theorem branchAngles_sin_zero (s : Fin 4 -> Bool) (A : Fin 4) :
    Real.sin (branchAngles s A) = 0 := by
  unfold branchAngles
  simpa using TetrahedralBranchWindow.sin_branch_zero s A

/--
At a Boolean branch, the scalar Wilson coefficient is `2*r*n - rho`, where
`n` is the number of `pi` coordinates.
-/
theorem wilsonScalar_branchAngles (r rho : ℝ) (s : Fin 4 -> Bool) :
    wilsonScalar r rho (branchAngles s)
      = 2 * r * (branchCount s : ℝ) - rho := by
  unfold wilsonScalar branchAngles branchCount
  rw [TetrahedralBranchWindow.wilson_sum_branch]
  ring

/--
The overlap branch window makes `2*r*n - rho` nonzero for every natural branch
count `n`: at `n = 0` it is negative, and for `n >= 1` it is positive.
-/
theorem branchMassWindow_nonzero_nat (r rho : ℝ) (n : ℕ)
    (hrho : 0 < rho) (hwin : rho < 2 * r) :
    2 * r * (n : ℝ) - rho ≠ 0 := by
  by_cases hn : n = 0
  · subst n
    intro h
    norm_num at h
    nlinarith
  · have hnposNat : 1 ≤ n := Nat.succ_le_of_lt (Nat.pos_of_ne_zero hn)
    have hnpos : (1 : ℝ) ≤ (n : ℝ) := by
      exact_mod_cast hnposNat
    have hrpos : 0 < r := by
      nlinarith
    have h2r_nonneg : 0 ≤ 2 * r := by
      nlinarith
    have hmul : 2 * r * 1 ≤ 2 * r * (n : ℝ) := by
      simpa using mul_le_mul_of_nonneg_left hnpos h2r_nonneg
    have hpos : 0 < 2 * r * (n : ℝ) - rho := by
      nlinarith
    intro h
    nlinarith

/-- The scalar Wilson coefficient is nonzero at every Boolean branch table. -/
theorem wilsonScalar_branchAngles_nonzero (r rho : ℝ) (s : Fin 4 -> Bool)
    (hrho : 0 < rho) (hwin : rho < 2 * r) :
    wilsonScalar r rho (branchAngles s) ≠ 0 := by
  intro hzero
  have hbranch := wilsonScalar_branchAngles r rho s
  exact branchMassWindow_nonzero_nat r rho (branchCount s) hrho hwin
    (by simpa [hbranch] using hzero)

/--
Reduction lemma: if all coordinates lie in the fundamental period and every sine
vanishes, then the point is one of the Boolean branch tables.

This is the explicit periodicity reduction from C240's `sin_zeros_in_period`.
-/
theorem sin_zero_to_branchAngles (k : Fin 4 -> ℝ)
    (hper : ∀ A, k A ∈ Set.Ico 0 (2 * Real.pi))
    (hsin : ∀ A, Real.sin (k A) = 0) :
    ∃ s : Fin 4 -> Bool, k = branchAngles s := by
  classical
  have hcases : ∀ A, k A = 0 ∨ k A = Real.pi := by
    intro A
    have hx : k A ∈ ({0, Real.pi} : Set ℝ) := by
      rw [← TetrahedralBranchWindow.sin_zeros_in_period]
      exact ⟨hper A, hsin A⟩
    simpa using hx
  refine ⟨fun A => decide (k A = Real.pi), ?_⟩
  funext A
  unfold branchAngles
  by_cases hpi : k A = Real.pi
  · simp [hpi]
  · have hzero : k A = 0 := by
      cases hcases A with
      | inl h => exact h
      | inr h => exact False.elim (hpi h)
    simp [hzero]

/--
If a point in the fundamental period has all sine coordinates zero, then the
scalar Wilson coefficient is nonzero in the overlap branch window.
-/
theorem wilsonScalar_nonzero_of_sin_zero (r rho : ℝ) (k : Fin 4 -> ℝ)
    (hper : ∀ A, k A ∈ Set.Ico 0 (2 * Real.pi))
    (hrho : 0 < rho) (hwin : rho < 2 * r)
    (hsin : ∀ A, Real.sin (k A) = 0) :
    wilsonScalar r rho k ≠ 0 := by
  obtain ⟨s, rfl⟩ := sin_zero_to_branchAngles k hper hsin
  exact wilsonScalar_branchAngles_nonzero r rho s hrho hwin

/--
Abstract kinetic detection certificate.

The global no-zero proof only needs two facts about the kinetic norm proxy:
it is nonnegative, and if it vanishes then all sine coordinates vanish.
-/
structure KineticDetection (K : (Fin 4 -> ℝ) -> ℝ) : Prop where
  nonneg : ∀ k, 0 ≤ K k
  zero_imp_sin_zero : ∀ k, K k = 0 -> ∀ A, Real.sin (k A) = 0

/-- Scalar lower-bound expression for the free overlap kernel. -/
noncomputable def freeGapScalar (K : (Fin 4 -> ℝ) -> ℝ)
    (r rho : ℝ) (k : Fin 4 -> ℝ) : ℝ :=
  K k + (wilsonScalar r rho k) ^ 2

/--
Conditional global free no-zero theorem.

Once the actual tetrahedral kinetic norm is shown to satisfy
`KineticDetection`, the scalar Wilson branch window rules out zeros of the
free scalar lower-bound expression throughout the fundamental period.
-/
theorem freeGapScalar_ne_zero_of_kineticDetection
    (K : (Fin 4 -> ℝ) -> ℝ) (r rho : ℝ) (k : Fin 4 -> ℝ)
    (hK : KineticDetection K)
    (hper : ∀ A, k A ∈ Set.Ico 0 (2 * Real.pi))
    (hrho : 0 < rho) (hwin : rho < 2 * r) :
    freeGapScalar K r rho k ≠ 0 := by
  intro hzero
  have hKnonneg : 0 ≤ K k := hK.nonneg k
  have hsqnonneg : 0 ≤ (wilsonScalar r rho k) ^ 2 := sq_nonneg _
  have hKzero : K k = 0 := by
    unfold freeGapScalar at hzero
    nlinarith
  have hWsqzero : (wilsonScalar r rho k) ^ 2 = 0 := by
    unfold freeGapScalar at hzero
    nlinarith
  have hWzero : wilsonScalar r rho k = 0 := by
    exact sq_eq_zero_iff.mp hWsqzero
  have hsin : ∀ A, Real.sin (k A) = 0 := hK.zero_imp_sin_zero k hKzero
  exact (wilsonScalar_nonzero_of_sin_zero r rho k hper hrho hwin hsin) hWzero

/--
Positive scalar lower-bound theorem.

This strengthens the no-zero statement: if the kinetic proxy is nonnegative and
detects all sine coordinates, then the scalar lower bound is strictly positive
throughout the branch window.  This is the finite/free statement closest to a
gap audit before introducing the full Hermitian overlap kernel.
-/
theorem freeGapScalar_pos_of_kineticDetection
    (K : (Fin 4 -> ℝ) -> ℝ) (r rho : ℝ) (k : Fin 4 -> ℝ)
    (hK : KineticDetection K)
    (hper : ∀ A, k A ∈ Set.Ico 0 (2 * Real.pi))
    (hrho : 0 < rho) (hwin : rho < 2 * r) :
    0 < freeGapScalar K r rho k := by
  by_cases hKzero : K k = 0
  · have hsin : ∀ A, Real.sin (k A) = 0 := hK.zero_imp_sin_zero k hKzero
    have hWne : wilsonScalar r rho k ≠ 0 :=
      wilsonScalar_nonzero_of_sin_zero r rho k hper hrho hwin hsin
    have hWsqpos : 0 < (wilsonScalar r rho k) ^ 2 := sq_pos_of_ne_zero hWne
    unfold freeGapScalar
    rw [hKzero]
    nlinarith
  · have hKnonneg : 0 ≤ K k := hK.nonneg k
    have hKpos : 0 < K k := lt_of_le_of_ne hKnonneg (Ne.symm hKzero)
    have hWsqnonneg : 0 ≤ (wilsonScalar r rho k) ^ 2 := sq_nonneg _
    unfold freeGapScalar
    nlinarith

/--
Coefficient-norm proxy for the tetrahedral kinetic term.

This is the Euclidean square norm of the coefficient vector of

`sum_A B_A sin(k_A)`

in the abstract basis `(gamma4, gamma_0, gamma_1, gamma_2)` used by C240.  It is
the right finite algebraic target before choosing a full Clifford/Hilbert norm.
-/
noncomputable def tetraKineticCoeff (k : Fin 4 -> ℝ) : Fin 4 -> ℝ
  | 0 => (1 / 4 : ℝ) * ∑ A, Real.sin (k A)
  | 1 => (3 / 4 : ℝ) * ∑ A, TetrahedralBranchWindow.vTetra A 0 * Real.sin (k A)
  | 2 => (3 / 4 : ℝ) * ∑ A, TetrahedralBranchWindow.vTetra A 1 * Real.sin (k A)
  | 3 => (3 / 4 : ℝ) * ∑ A, TetrahedralBranchWindow.vTetra A 2 * Real.sin (k A)

noncomputable def tetraKineticCoeffNormSq (k : Fin 4 -> ℝ) : ℝ :=
  ∑ j : Fin 4, (tetraKineticCoeff k j) ^ 2

/--
Detection theorem: the tetrahedral coefficient norm detects nonzero sine vectors.

Proof route:
1. A sum of squares can vanish only if each coefficient vanishes.
2. The four coefficient equations are exactly the homogeneous tetrahedral
   equations for the weights `sin(k_A)`, up to nonzero scalar factors and the
   harmless normalization by `sqrt 3`.
3. Apply C240's `tetra_homogeneous_injective` or `B_sin_branch_inference`.
-/
theorem tetraKineticCoeffNormSq_detection :
    KineticDetection tetraKineticCoeffNormSq := by
  constructor
  · intro k
    unfold tetraKineticCoeffNormSq
    exact Finset.sum_nonneg (by intro j _hj; exact sq_nonneg _)
  · intro k hzero A
    have hterm : ∀ j ∈ Finset.univ, (tetraKineticCoeff k j) ^ 2 = 0 := by
      exact (Finset.sum_eq_zero_iff_of_nonneg
        (s := Finset.univ)
        (f := fun j : Fin 4 => (tetraKineticCoeff k j) ^ 2)
        (by intro j _hj; exact sq_nonneg _)).mp (by
          simpa [tetraKineticCoeffNormSq] using hzero)
    have hcoeff : ∀ j : Fin 4, tetraKineticCoeff k j = 0 := by
      intro j
      exact sq_eq_zero_iff.mp (hterm j (Finset.mem_univ j))
    have hc0 := hcoeff 0
    have hc1 := hcoeff 1
    have hc2 := hcoeff 2
    have hc3 := hcoeff 3
    have h0 : Real.sin (k 0) + Real.sin (k 1)
        + Real.sin (k 2) + Real.sin (k 3) = 0 := by
      simp [tetraKineticCoeff, Fin.sum_univ_four] at hc0
      nlinarith
    have hv1 : ∑ B, TetrahedralBranchWindow.vTetra B 0 * Real.sin (k B) = 0 := by
      simp [tetraKineticCoeff] at hc1
      nlinarith
    have hv2 : ∑ B, TetrahedralBranchWindow.vTetra B 1 * Real.sin (k B) = 0 := by
      simp [tetraKineticCoeff] at hc2
      nlinarith
    have hv3 : ∑ B, TetrahedralBranchWindow.vTetra B 2 * Real.sin (k B) = 0 := by
      simp [tetraKineticCoeff] at hc3
      nlinarith
    have hsqrt_ne : Real.sqrt 3 ≠ 0 := by positivity
    have h1 : Real.sin (k 0) + Real.sin (k 1)
        - Real.sin (k 2) - Real.sin (k 3) = 0 := by
      have hv := hv1
      simp [TetrahedralBranchWindow.vTetra, TetrahedralBranchWindow.wTetra, Fin.sum_univ_four] at hv
      field_simp [hsqrt_ne] at hv
      nlinarith
    have h2 : Real.sin (k 0) - Real.sin (k 1)
        + Real.sin (k 2) - Real.sin (k 3) = 0 := by
      have hv := hv2
      simp [TetrahedralBranchWindow.vTetra, TetrahedralBranchWindow.wTetra, Fin.sum_univ_four] at hv
      field_simp [hsqrt_ne] at hv
      nlinarith
    have h3 : Real.sin (k 0) - Real.sin (k 1)
        - Real.sin (k 2) + Real.sin (k 3) = 0 := by
      have hv := hv3
      simp [TetrahedralBranchWindow.vTetra, TetrahedralBranchWindow.wTetra, Fin.sum_univ_four] at hv
      field_simp [hsqrt_ne] at hv
      nlinarith
    have hs0 : Real.sin (k 0) = 0 := by nlinarith
    have hs1 : Real.sin (k 1) = 0 := by nlinarith
    have hs2 : Real.sin (k 2) = 0 := by nlinarith
    have hs3 : Real.sin (k 3) = 0 := by nlinarith
    fin_cases A
    · exact hs0
    · exact hs1
    · exact hs2
    · exact hs3

/--
Concrete conditional no-zero theorem for the tetrahedral coefficient-norm
proxy.

After `tetraKineticCoeffNormSq_detection` is discharged, this proves that the
free scalar lower-bound expression has no zeros in the fundamental branch
window.
-/
theorem tetrahedral_freeGapScalar_ne_zero (r rho : ℝ) (k : Fin 4 -> ℝ)
    (hper : ∀ A, k A ∈ Set.Ico 0 (2 * Real.pi))
    (hrho : 0 < rho) (hwin : rho < 2 * r) :
    freeGapScalar tetraKineticCoeffNormSq r rho k ≠ 0 :=
  freeGapScalar_ne_zero_of_kineticDetection
    tetraKineticCoeffNormSq r rho k
    tetraKineticCoeffNormSq_detection hper hrho hwin

/--
Concrete positive free lower bound for the tetrahedral coefficient-norm proxy.

This is the branch-window positivity form of the C243 finite/free global-gap
audit.
-/
theorem tetrahedral_freeGapScalar_pos (r rho : ℝ) (k : Fin 4 -> ℝ)
    (hper : ∀ A, k A ∈ Set.Ico 0 (2 * Real.pi))
    (hrho : 0 < rho) (hwin : rho < 2 * r) :
    0 < freeGapScalar tetraKineticCoeffNormSq r rho k :=
  freeGapScalar_pos_of_kineticDetection
    tetraKineticCoeffNormSq r rho k
    tetraKineticCoeffNormSq_detection hper hrho hwin

end TetrahedralGlobalGap
end GateC1
end NullEdge
end Draft
end PhysicsSM
