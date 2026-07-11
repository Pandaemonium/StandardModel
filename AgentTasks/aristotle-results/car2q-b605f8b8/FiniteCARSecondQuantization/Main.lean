import PhysicsSM.Draft.NullEdge.FiniteCARFockBasic

/-!
# Determinant-minor second quantization

Focused proof target for the exterior-power lift of a finite one-particle
matrix to the occupation-basis fermionic Fock space.  The key target is
`gamma_create_covariance`; the earlier statements expose its nondegenerate
vacuum and one-particle controls.
-/

noncomputable section

namespace FiniteCARSecondQuantization

open Finset Matrix
open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic

variable {ι : Type*} [Fintype ι] [DecidableEq ι] [LinearOrder ι]

/-- Occupation-basis vector labelled by `S`. -/
def basisVec (S : Finset ι) : Fock ι := fun T => if T = S then 1 else 0

/-- The empty occupation state. -/
def vac : Fock ι := basisVec ∅

/-- The ordered `T`-by-`S` minor of `U`, zero between unequal sectors. -/
def gammaEntry (U : Matrix ι ι Complex) (T S : Finset ι) : Complex :=
  if h : S.card = T.card then
    Matrix.det (Matrix.of fun a b : Fin T.card =>
      U (T.orderEmbOfFin rfl a) (S.orderEmbOfFin h b))
  else 0

/-- The determinant-minor second quantization of `U`. -/
def Gamma (U : Matrix ι ι Complex) (psi : Fock ι) : Fock ι := fun T =>
  ∑ S : Finset ι, gammaEntry U T S * psi S

/-- The empty minor is one. -/
theorem gammaEntry_empty (U : Matrix ι ι Complex) :
    gammaEntry U ∅ ∅ = 1 := by
  unfold gammaEntry; aesop;

/-- Second quantization fixes the vacuum. -/
theorem Gamma_vac (U : Matrix ι ι Complex) :
    Gamma U vac = vac := by
  ext T;
  by_cases hT : T = ∅ <;> simp +decide [ hT, Gamma, vac, basisVec ];
  · exact gammaEntry_empty U
  · unfold gammaEntry
    grind

/-- A one-particle minor is the corresponding matrix element. -/
theorem gammaEntry_singleton (U : Matrix ι ι Complex) (j k : ι) :
    gammaEntry U {j} {k} = U j k := by
  by_cases h : k = j <;> simp +decide [ h, gammaEntry ];
  · convert Matrix.det_fin_one _;
    simp +decide [ Fin.ext_iff, Finset.orderEmbOfFin_apply ];
  · convert Matrix.det_fin_one _;
    congr;
    · simp +decide [ Finset.orderEmbOfFin_apply ];
      rfl;
    · convert Finset.orderEmbOfFin_mem { k } _ _;
      aesop

/-
`Gamma U` is additive in the Fock vector.
-/
theorem Gamma_add (U : Matrix ι ι Complex) (psi phi : Fock ι) :
    Gamma U (psi + phi) = Gamma U psi + Gamma U phi := by
  ext T; exact (by
  simp +decide [ Gamma, mul_add, Finset.sum_add_distrib ])

/-
`Gamma U` commutes with complex scalar multiplication.
-/
theorem Gamma_smul (U : Matrix ι ι Complex) (c : Complex) (psi : Fock ι) :
    Gamma U (c • psi) = c • Gamma U psi := by
  unfold Gamma;
  ext T; simp +decide [ mul_assoc, mul_left_comm, Finset.mul_sum _ _ _ ] ;

/-- Exact agreement with `U` on occupation-basis one-particle states. -/
theorem Gamma_apply_singleton (U : Matrix ι ι Complex) (j k : ι) :
    Gamma U (basisVec {k}) {j} = U j k := by
  simp only [Gamma, basisVec, mul_ite, mul_one, mul_zero,
    Finset.sum_ite_eq', Finset.mem_univ, if_true]
  exact gammaEntry_singleton U j k

/-- Total particle number in the occupation basis. -/
def totalNumber (psi : Fock ι) : Fock ι := fun S =>
  (S.card : Complex) * psi S

/-- Fermion parity in the occupation basis. -/
def parity (psi : Fock ι) : Fock ι := fun S =>
  (-1 : Complex) ^ S.card * psi S

/-
The minor lift preserves particle number for every matrix `U`.
-/
theorem Gamma_number (U : Matrix ι ι Complex) (psi : Fock ι) :
    Gamma U (totalNumber psi) = totalNumber (Gamma U psi) := by
  ext T;
  unfold Gamma totalNumber;
  rw [ Finset.mul_sum _ _ _ ];
  refine' Finset.sum_congr rfl fun S hS => _;
  unfold gammaEntry; split_ifs <;> simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ] ;

/-
The minor lift preserves fermion parity for every matrix `U`.
-/
theorem Gamma_parity (U : Matrix ι ι Complex) (psi : Fock ι) :
    Gamma U (parity psi) = parity (Gamma U psi) := by
  ext T;
  simp +decide [ parity, Gamma ];
  rw [ Finset.mul_sum _ _ _ ];
  grind +locals

/-- The number of elements of `A` strictly below its `a`-th smallest element is
`a`. -/
theorem belowCount_orderEmbOfFin (A : Finset ι) (a : Fin A.card) :
    belowCount (A.orderEmbOfFin rfl a) A = (a : ℕ) := by
  sorry

/-- If `y ∈ D`, the number of elements of `D` strictly below `y` is `< D.card`. -/
theorem belowCount_lt_card (D : Finset ι) (y : ι) (hy : y ∈ D) :
    belowCount y D < D.card := by
  sorry

/-- The `(belowCount y D)`-th smallest element of `D` is `y`. -/
theorem orderEmbOfFin_belowCount (D : Finset ι) (y : ι) (hy : y ∈ D) :
    D.orderEmbOfFin rfl ⟨belowCount y D, belowCount_lt_card D y hy⟩ = y := by
  sorry

/-- Deleting the `a`-th smallest element of `A` reindexes the remaining ordered
enumeration through `Fin.succAbove`. -/
theorem orderEmbOfFin_erase (A : Finset ι) {n : ℕ} (hA : A.card = n + 1)
    (a : Fin (n + 1)) (b : Fin n) :
    (A.erase (A.orderEmbOfFin hA a)).orderEmbOfFin
        (by rw [Finset.card_erase_of_mem (A.orderEmbOfFin_mem hA a), hA]; omega) b
      = A.orderEmbOfFin hA (a.succAbove b) := by
  sorry

/-- Column Laplace/cofactor expansion of a minor determinant along a chosen
column mode `y ∈ D`: the sign is `(-1) ^ (row position + column position)`. -/
theorem gammaEntry_laplace_col (U : Matrix ι ι Complex) (T D : Finset ι) (y : ι)
    (hy : y ∈ D) (hcard : D.card = T.card) :
    gammaEntry U T D
      = ∑ j ∈ T, (-1 : Complex) ^ (belowCount j T + belowCount y D)
          * U j y * gammaEntry U (T.erase j) (D.erase y) := by
  sorry

/-- Cofactor expansion along an extra column equal to the `i`-th column of `U`:
when `i` already occurs in the column set `S'` the underlying determinant has a
repeated column and the expansion vanishes. -/
theorem gammaEntry_cofactor_zero (U : Matrix ι ι Complex) (i : ι)
    (T S' : Finset ι) (hi : i ∈ S') (hcard : T.card = S'.card + 1) :
    ∑ j ∈ T, (-1 : Complex) ^ belowCount j T * U j i
        * gammaEntry U (T.erase j) S' = 0 := by
  sorry

/-- Column Laplace/cofactor expansion of a minor determinant along a fresh mode
`i` (with `i ∉ S'`): expanding the `(insert i S')`-column of the minor over `U`
by cofactors along the rows `T`. -/
theorem gammaEntry_column_expansion (U : Matrix ι ι Complex) (i : ι)
    (T S' : Finset ι) (hi : i ∉ S') :
    opSign i (insert i S') * gammaEntry U T (insert i S')
      = ∑ j ∈ T, U j i * opSign j T * gammaEntry U (T.erase j) S' := by
  sorry

/-- The repeated-column cofactor sum vanishes: when the fresh mode `i` already
occurs in the column set `S'`, the cofactor sum is the Laplace expansion of a
determinant with two equal columns, hence zero. -/
theorem gammaEntry_column_vanish (U : Matrix ι ι Complex) (i : ι)
    (T S' : Finset ι) (hi : i ∈ S') :
    ∑ j ∈ T, U j i * opSign j T * gammaEntry U (T.erase j) S' = 0 := by
  sorry

/-
Creation covariance.  This is the key finite Laplace-expansion identity:
the lift replaces an input mode by the corresponding column of `U`.
-/
theorem gamma_create_covariance (U : Matrix ι ι Complex) (i : ι)
    (psi : Fock ι) :
    Gamma U (create i psi) =
      ∑ j : ι, U j i • create j (Gamma U psi) := by
  ext T;
  have h_lhs : Gamma U (create i psi) T = ∑ S' ∈ Finset.univ.filter (fun S' => i ∉ S'), (opSign i (insert i S')) * (gammaEntry U T (insert i S')) * psi S' := by
    unfold create Gamma; simp +decide [ Finset.sum_ite ] ;
    refine' Finset.sum_bij ( fun S hS => S.erase i ) _ _ _ _ <;> simp_all +decide [ Finset.mem_erase, Finset.mem_filter ];
    · intro a₁ ha₁ a₂ ha₂ h; rw [ ← Finset.insert_erase ha₁, ← Finset.insert_erase ha₂, h ] ;
    · exact fun b hi => ⟨ Insert.insert i b, Finset.mem_insert_self _ _, Finset.erase_insert hi ⟩;
    · exact fun _ _ => by ring;
  have h_rhs : (∑ j, U j i • create j (Gamma U psi)) T = ∑ S', (∑ j ∈ T, U j i * opSign j T * gammaEntry U (T.erase j) S') * psi S' := by
    simp +decide [ create, Finset.sum_mul _ _ _ ];
    rw [ Finset.sum_comm, Finset.sum_congr rfl ] ; intros ; simp +decide [ Gamma, Finset.mul_sum _ _ _, mul_assoc ];
  rw [ h_lhs, h_rhs, ← Finset.sum_subset ( Finset.subset_univ ( Finset.filter ( fun S' => i ∉ S' ) Finset.univ ) ) ];
  · exact Finset.sum_congr rfl fun S' hS' => by rw [ gammaEntry_column_expansion U i T S' ( Finset.mem_filter.mp hS' |>.2 ) ] ;
  · simp +contextual [ gammaEntry_column_vanish ]

end FiniteCARSecondQuantization
