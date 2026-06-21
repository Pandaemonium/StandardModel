import Mathlib

/-!
# Spinor.PluckerMass

Trusted finite Pluecker-mass identities for visible complex null spinors.

This module packages the algebraic keystone of the null-edge causal graph
program in a non-draft namespace.  A visible null edge is represented by a
complex two-spinor `psi : Fin 2 -> ℂ` and the rank-one Hermitian momentum
matrix `psi psi^dagger`.  The determinant of a finite sum of such null
momenta is exactly the total pairwise squared Pluecker spread

```text
det(sum_i psi_i psi_i^dagger)
  =
sum_{i<j} |psi_i wedge psi_j|^2.
```

The theorem is purely finite-dimensional linear algebra.  It does not assert
a continuum limit, a quantum-measure construction, or a twistor incidence
theorem.

Sources and provenance:
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `Sources/Null_Edge_Causal_Graph_Research_Plan.md`
- First formalized in the no-s o r r y Aristotle draft
  `PhysicsSM.Draft.NullEdgePluckerGeneralAristotle`, task
  `16146014-3b07-41dd-b56b-ec17a4fc0a08`.

Conventions:
- visible spacetime spinors are complex two-spinors;
- `rankOneHermitian psi = psi psi^dagger`;
- determinant mass is the `2 x 2` determinant over `ℂ`;
- squared modulus is represented as the complex number `z * conj z`.

Status: trusted, no `s o r r y`.
-/

noncomputable section

namespace PhysicsSM.Spinor.PluckerMass

open Matrix Complex

/-! ## Visible spinors and rank-one null momenta -/

/-- A visible complex Weyl spinor attached to a null edge. -/
abbrev CSpinor := Fin 2 -> ℂ

/-- The rank-one Hermitian bispinor `psi psi^dagger`. -/
def rankOneHermitian (psi : CSpinor) : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.vecMulVec psi (star psi)

/-- The spinor wedge / Pluecker coordinate of two complex two-spinors. -/
def spinorWedge (psi phi : CSpinor) : ℂ :=
  psi 0 * phi 1 - psi 1 * phi 0

/-- Complex squared modulus, valued in `ℂ` for direct comparison with a determinant. -/
def complexAbsSq (z : ℂ) : ℂ :=
  z * (starRingEnd ℂ) z

/-- `complexAbsSq` is the complex coercion of the usual real squared norm. -/
theorem complexAbsSq_eq_ofReal_normSq (z : ℂ) :
    complexAbsSq z = (Complex.normSq z : ℂ) := by
  simp [complexAbsSq, Complex.normSq_eq_conj_mul_self, mul_comm]

/-- The Hermitian momentum matrix of a two-edge visible bundle. -/
def twoEdgeMomentum (psi phi : CSpinor) : Matrix (Fin 2) (Fin 2) ℂ :=
  rankOneHermitian psi + rankOneHermitian phi

/--
A single visible null edge is massless: the determinant of `psi psi^dagger`
vanishes.
-/
theorem det_rankOneHermitian_eq_zero (psi : CSpinor) :
    (rankOneHermitian psi).det = 0 := by
  simp [rankOneHermitian, Matrix.det_fin_two, Matrix.vecMulVec]
  ring

/--
Two-edge Pluecker mass identity.  The determinant of the summed null momenta
is the squared modulus of the spinor wedge.
-/
theorem two_edge_plucker_mass_identity (psi phi : CSpinor) :
    (twoEdgeMomentum psi phi).det = complexAbsSq (spinorWedge psi phi) := by
  simp [twoEdgeMomentum, rankOneHermitian, Matrix.det_fin_two, Matrix.vecMulVec,
    spinorWedge, complexAbsSq]
  ring

/-- Squared complex modulus vanishes exactly when the complex number vanishes. -/
theorem complexAbsSq_eq_zero_iff (z : ℂ) :
    complexAbsSq z = 0 ↔ z = 0 := by
  exact mul_eq_zero.trans (or_iff_left_of_imp fun h => by simpa using h)

/--
The two-edge bundle is massless exactly when the two spinor directions have
zero Pluecker spread.
-/
theorem two_edge_mass_zero_iff_wedge_zero (psi phi : CSpinor) :
    (twoEdgeMomentum psi phi).det = 0 ↔ spinorWedge psi phi = 0 := by
  exact two_edge_plucker_mass_identity psi phi ▸ complexAbsSq_eq_zero_iff _

/--
Zero Pluecker spread is projective collinearity, stated without quotients:
if `psi` is nonzero, then `phi` is a scalar multiple of `psi`.
-/
theorem spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero
    (psi phi : CSpinor) (hpsi : psi 0 ≠ 0 ∨ psi 1 ≠ 0) :
    spinorWedge psi phi = 0 ↔ ∃ c : ℂ, phi = c • psi := by
  constructor
  · intro h
    by_cases h0 : psi 0 = 0
    · have h1 : psi 1 ≠ 0 := by
        rcases hpsi with hpsi0 | hpsi1
        · exact False.elim (hpsi0 h0)
        · exact hpsi1
      have hphi0 : phi 0 = 0 := by
        have hmul : psi 1 * phi 0 = 0 := by
          simpa [spinorWedge, h0] using h
        exact (mul_eq_zero.mp hmul).resolve_left h1
      refine ⟨phi 1 / psi 1, ?_⟩
      ext i
      fin_cases i <;> simp [h0, h1, hphi0]
    · refine ⟨phi 0 / psi 0, ?_⟩
      have hmul : psi 0 * phi 1 = psi 1 * phi 0 := by
        exact sub_eq_zero.mp h
      ext i
      fin_cases i
      · simp [h0]
      · calc
          phi 1 = (psi 0 * phi 1) / psi 0 := by field_simp [h0]
          _ = (psi 1 * phi 0) / psi 0 := by rw [hmul]
          _ = (phi 0 / psi 0) * psi 1 := by ring
  · rintro ⟨c, rfl⟩
    simp [spinorWedge, mul_comm]
    ring

/-! ## Finite visible spinor bundles -/

/-- The Hermitian momentum matrix of a finite visible null-spinor bundle. -/
def finBundleMomentum {n : Nat} (psi : Fin n -> CSpinor) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  ∑ i : Fin n, rankOneHermitian (psi i)

/-- Ordered representatives of unordered pairs of indices. -/
def finPairIndexSet (n : Nat) : Finset (Fin n × Fin n) :=
  Finset.univ.filter fun p => (p.1 : Nat) < (p.2 : Nat)

/-- The total pairwise squared Pluecker spread of a finite spinor bundle. -/
def finPairwisePluckerMass {n : Nat} (psi : Fin n -> CSpinor) : ℂ :=
  ∑ p ∈ finPairIndexSet n,
    complexAbsSq (spinorWedge (psi p.1) (psi p.2))

/-- Real-valued version of the total pairwise squared Pluecker spread. -/
def finPairwisePluckerMassReal {n : Nat} (psi : Fin n -> CSpinor) : ℝ :=
  ∑ p ∈ finPairIndexSet n,
    Complex.normSq (spinorWedge (psi p.1) (psi p.2))

/-- The complex-valued Pluecker mass is the coercion of the real-valued one. -/
theorem finPairwisePluckerMass_eq_ofReal {n : Nat}
    (psi : Fin n -> CSpinor) :
    finPairwisePluckerMass psi = (finPairwisePluckerMassReal psi : ℂ) := by
  unfold finPairwisePluckerMass finPairwisePluckerMassReal
  simp [complexAbsSq_eq_ofReal_normSq]

/-- The real Pluecker mass is nonnegative term by term. -/
theorem finPairwisePluckerMassReal_nonneg {n : Nat}
    (psi : Fin n -> CSpinor) :
    0 ≤ finPairwisePluckerMassReal psi := by
  unfold finPairwisePluckerMassReal
  exact Finset.sum_nonneg fun p _ => Complex.normSq_nonneg _

/-! ## Off-diagonal folding helper -/

/--
A double sum of a function whose diagonal vanishes equals the sum over
unordered index pairs of the two orderings.
-/
theorem sum_pairs_offdiag {n : Nat} (f : Fin n -> Fin n -> ℂ)
    (hdiag : ∀ i, f i i = 0) :
    ∑ i, ∑ j, f i j = ∑ p ∈ finPairIndexSet n, (f p.1 p.2 + f p.2 p.1) := by
  have h1 : ∑ i, ∑ j, f i j
      = ∑ p ∈ (Finset.univ : Finset (Fin n × Fin n)), f p.1 p.2 := by
    rw [← Finset.univ_product_univ, Finset.sum_product]
  rw [h1, finPairIndexSet, Finset.sum_add_distrib]
  have hswap :
      ∑ p ∈ Finset.univ.filter (fun p : Fin n × Fin n => (p.1 : Nat) < p.2),
          f p.2 p.1
        = ∑ p ∈ Finset.univ.filter (fun p : Fin n × Fin n => (p.2 : Nat) < p.1),
            f p.1 p.2 := by
    apply Finset.sum_nbij' (fun p => (p.2, p.1)) (fun p => (p.2, p.1)) <;> simp_all
  rw [hswap]
  have hpart : ∑ p ∈ (Finset.univ : Finset (Fin n × Fin n)), f p.1 p.2
      = (∑ p ∈ Finset.univ.filter (fun p : Fin n × Fin n => (p.1 : Nat) < p.2),
            f p.1 p.2)
        + ∑ p ∈ Finset.univ.filter
            (fun p : Fin n × Fin n => ¬ (p.1 : Nat) < p.2), f p.1 p.2 := by
    rw [Finset.sum_filter_add_sum_filter_not]
  rw [hpart]
  congr 1
  rw [Finset.sum_filter, Finset.sum_filter]
  apply Finset.sum_congr rfl
  intro p _
  rcases lt_trichotomy (p.1 : Nat) (p.2 : Nat) with h | h | h
  · simp [Nat.not_lt.2 (le_of_lt h)]
    omega
  · have : p.1 = p.2 := Fin.ext h
    simp [this, hdiag]
  · simp [Nat.not_lt.2 (le_of_lt h), h]

/--
General finite Pluecker mass theorem.

The determinant of the summed null momenta is the total pairwise squared
Pluecker spread of the spinor bundle.
-/
theorem fin_bundle_plucker_mass_identity {n : Nat} (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).det = finPairwisePluckerMass psi := by
  have hentry : ∀ a b : Fin 2, finBundleMomentum psi a b
      = ∑ i, psi i a * (starRingEnd ℂ) (psi i b) := by
    intro a b
    simp [finBundleMomentum, rankOneHermitian, Matrix.sum_apply, Matrix.vecMulVec]
  set f : Fin n -> Fin n -> ℂ := fun i j =>
    (psi i 0 * (starRingEnd ℂ) (psi i 0)) * (psi j 1 * (starRingEnd ℂ) (psi j 1))
      - (psi i 0 * (starRingEnd ℂ) (psi i 1))
        * (psi j 1 * (starRingEnd ℂ) (psi j 0)) with hf
  have hdet : (finBundleMomentum psi).det = ∑ i, ∑ j, f i j := by
    rw [Matrix.det_fin_two, hentry, hentry, hentry, hentry]
    rw [Finset.sum_mul_sum, Finset.sum_mul_sum, ← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro i _
    rw [← Finset.sum_sub_distrib]
  rw [hdet, sum_pairs_offdiag f (by intro i; simp [hf]; ring)]
  rw [finPairwisePluckerMass]
  apply Finset.sum_congr rfl
  intro p _
  simp only [hf, complexAbsSq, spinorWedge, map_sub, map_mul]
  ring

/-- Determinant mass as the coercion of the real pairwise squared spread. -/
theorem fin_bundle_det_eq_ofReal_pluckerMassReal {n : Nat}
    (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).det = (finPairwisePluckerMassReal psi : ℂ) := by
  rw [fin_bundle_plucker_mass_identity, finPairwisePluckerMass_eq_ofReal]

/-- The real part of the determinant mass is nonnegative. -/
theorem fin_bundle_det_re_nonneg {n : Nat} (psi : Fin n -> CSpinor) :
    0 ≤ ((finBundleMomentum psi).det).re := by
  rw [fin_bundle_det_eq_ofReal_pluckerMassReal]
  exact finPairwisePluckerMassReal_nonneg psi

/-! ## Equality and collinearity criteria -/

/-- All members of a spinor family have zero pairwise Pluecker wedge. -/
def PairwiseWedgeZero {n : Nat} (psi : Fin n -> CSpinor) : Prop :=
  ∀ i j : Fin n, spinorWedge (psi i) (psi j) = 0

/--
If one spinor in the family is nonzero, then vanishing wedges against that
base spinor are equivalent to every spinor being a scalar multiple of it.
-/
theorem wedges_against_base_zero_iff_all_smul
    {n : Nat} (psi : Fin n -> CSpinor) (base : Fin n)
    (hbase : psi base 0 ≠ 0 ∨ psi base 1 ≠ 0) :
    (∀ i : Fin n, spinorWedge (psi base) (psi i) = 0) ↔
      ∃ c : Fin n -> ℂ, ∀ i : Fin n, psi i = c i • psi base := by
  constructor
  · intro h
    have hex : ∀ i, ∃ c : ℂ, psi i = c • psi base := by
      intro i
      exact (spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero
        (psi base) (psi i) hbase).1 (h i)
    exact Classical.skolem.1 hex
  · rintro ⟨c, hc⟩ i
    rw [hc i]
    simp [spinorWedge, mul_comm, mul_left_comm]
    ring

/-- A common nonzero projective direction implies all pairwise wedges vanish. -/
theorem all_smul_implies_pairwise_wedge_zero
    {n : Nat} (psi : Fin n -> CSpinor) (base : Fin n)
    (c : Fin n -> ℂ) (h : ∀ i : Fin n, psi i = c i • psi base) :
    PairwiseWedgeZero psi := by
  intro i j
  rw [h i, h j]
  simp [spinorWedge]
  ring

/--
Pairwise vanishing wedges are equivalent to a common projective direction,
provided the chosen base spinor is nonzero.
-/
theorem pairwise_wedge_zero_iff_common_direction
    {n : Nat} (psi : Fin n -> CSpinor) (base : Fin n)
    (hbase : psi base 0 ≠ 0 ∨ psi base 1 ≠ 0) :
    PairwiseWedgeZero psi ↔
      ∃ c : Fin n -> ℂ, ∀ i : Fin n, psi i = c i • psi base := by
  constructor
  · intro h
    exact (wedges_against_base_zero_iff_all_smul psi base hbase).1
      (fun i => h base i)
  · rintro ⟨c, hc⟩
    exact all_smul_implies_pairwise_wedge_zero psi base c hc

/--
The pairwise Pluecker mass vanishes exactly when every indexed pair in the
finite pair set has zero wedge.
-/
theorem finPairwisePluckerMass_eq_zero_iff_pair_terms_zero
    {n : Nat} (psi : Fin n -> CSpinor) :
    finPairwisePluckerMass psi = 0 ↔
      ∀ p ∈ finPairIndexSet n,
        spinorWedge (psi p.1) (psi p.2) = 0 := by
  rw [finPairwisePluckerMass]
  have hre : ∀ p ∈ finPairIndexSet n,
      complexAbsSq (spinorWedge (psi p.1) (psi p.2))
        = ((Complex.normSq (spinorWedge (psi p.1) (psi p.2)) : ℝ) : ℂ) := by
    intro p _
    simp [complexAbsSq, Complex.normSq_eq_conj_mul_self, mul_comm]
  rw [Finset.sum_congr rfl hre, ← Complex.ofReal_sum, Complex.ofReal_eq_zero]
  rw [Finset.sum_eq_zero_iff_of_nonneg (fun p _ => Complex.normSq_nonneg _)]
  constructor
  · intro h p hp
    exact Complex.normSq_eq_zero.1 (h p hp)
  · intro h p hp
    rw [h p hp]
    simp

/--
On the unordered pair index set, all terms vanish iff every pair, in either
order, has zero wedge.
-/
theorem pair_terms_zero_iff_pairwise
    {n : Nat} (psi : Fin n -> CSpinor) :
    (∀ p ∈ finPairIndexSet n, spinorWedge (psi p.1) (psi p.2) = 0) ↔
      PairwiseWedgeZero psi := by
  constructor
  · intro h i j
    rcases lt_trichotomy (i : Nat) (j : Nat) with hlt | heq | hgt
    · refine h (i, j) ?_
      simp only [finPairIndexSet, Finset.mem_filter, Finset.mem_univ, true_and]
      exact hlt
    · have : i = j := Fin.ext heq
      rw [this]
      simp [spinorWedge]
      ring
    · have hp : spinorWedge (psi j) (psi i) = 0 := by
        refine h (j, i) ?_
        simp only [finPairIndexSet, Finset.mem_filter, Finset.mem_univ, true_and]
        exact hgt
      simp only [spinorWedge] at hp ⊢
      linear_combination -hp
  · intro h p _
    exact h p.1 p.2

/--
Finite massless-collinearity criterion for a nontrivial bundle with a chosen
nonzero base spinor.
-/
theorem fin_bundle_mass_zero_iff_common_direction
    {n : Nat} (psi : Fin n -> CSpinor) (base : Fin n)
    (hbase : psi base 0 ≠ 0 ∨ psi base 1 ≠ 0) :
    (finBundleMomentum psi).det = 0 ↔
      ∃ c : Fin n -> ℂ, ∀ i : Fin n, psi i = c i • psi base := by
  rw [fin_bundle_plucker_mass_identity,
    finPairwisePluckerMass_eq_zero_iff_pair_terms_zero,
    pair_terms_zero_iff_pairwise]
  exact pairwise_wedge_zero_iff_common_direction psi base hbase

end PhysicsSM.Spinor.PluckerMass

end
