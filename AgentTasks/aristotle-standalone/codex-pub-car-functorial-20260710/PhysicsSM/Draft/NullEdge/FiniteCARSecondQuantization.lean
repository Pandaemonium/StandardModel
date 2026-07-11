import PhysicsSM.Draft.NullEdge.FiniteCARFockBasic

/-!
# Determinant-minor finite second quantization

This module defines the occupation-basis exterior-power lift `Gamma(U)` of an
arbitrary finite one-particle matrix.  It proves vacuum preservation, exact
one-particle agreement, linearity, and conservation of particle number and
fermion parity.  Its main composition theorem is creation covariance: applying
`Gamma U` after creating an input mode is exactly the sum of output creations
weighted by the corresponding column of `U`.

Functoriality, unitarity for unitary `U`, annihilation covariance, and inherited
spatial locality remain successor theorems.  No such stronger claim is inferred
from creation covariance alone.

Provenance: harvested proof-complete snapshot of Aristotle project
`b605f8b8-a75d-46b5-92b8-62fc57e82d79`; determinant-minor architecture from
project `4d62041f-b9c0-4530-975e-2fa440d9bc5b`.  Lean 4.28.0.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization

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

omit [Fintype ι] [DecidableEq ι] in
/-- The empty minor is one. -/
theorem gammaEntry_empty
    (U : Matrix ι ι Complex) :
    gammaEntry U ∅ ∅ = 1 := by
  unfold gammaEntry
  aesop

/-- Second quantization fixes the vacuum. -/
theorem Gamma_vac (U : Matrix ι ι Complex) : Gamma U vac = vac := by
  ext T
  by_cases hT : T = ∅ <;> simp +decide [hT, Gamma, vac, basisVec]
  · exact gammaEntry_empty U
  · unfold gammaEntry
    grind

omit [Fintype ι] in
/-- A one-particle minor is the corresponding matrix element. -/
theorem gammaEntry_singleton
    (U : Matrix ι ι Complex) (j k : ι) :
    gammaEntry U {j} {k} = U j k := by
  by_cases h : k = j <;> simp +decide [h, gammaEntry]
  · convert Matrix.det_fin_one _
    simp +decide [Finset.orderEmbOfFin_apply]
  · convert Matrix.det_fin_one _
    congr
    · simp +decide [Finset.orderEmbOfFin_apply]
      rfl
    · convert Finset.orderEmbOfFin_mem {k} _ _
      aesop

omit [DecidableEq ι] in
/-- `Gamma U` is additive in the Fock vector. -/
theorem Gamma_add
    (U : Matrix ι ι Complex) (psi phi : Fock ι) :
    Gamma U (psi + phi) = Gamma U psi + Gamma U phi := by
  ext T
  simp +decide [Gamma, mul_add, Finset.sum_add_distrib]

omit [DecidableEq ι] in
/-- `Gamma U` commutes with complex scalar multiplication. -/
theorem Gamma_smul
    (U : Matrix ι ι Complex) (c : Complex) (psi : Fock ι) :
    Gamma U (c • psi) = c • Gamma U psi := by
  unfold Gamma
  ext T
  simp +decide [mul_left_comm, Finset.mul_sum]

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

omit [DecidableEq ι] in
/-- The minor lift preserves particle number for every matrix `U`. -/
theorem Gamma_number
    (U : Matrix ι ι Complex) (psi : Fock ι) :
    Gamma U (totalNumber psi) = totalNumber (Gamma U psi) := by
  ext T
  unfold Gamma totalNumber
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl fun S _ => ?_
  unfold gammaEntry
  split_ifs <;> simp_all +decide [mul_assoc, mul_comm, mul_left_comm]

omit [DecidableEq ι] in
/-- The minor lift preserves fermion parity for every matrix `U`. -/
theorem Gamma_parity
    (U : Matrix ι ι Complex) (psi : Fock ι) :
    Gamma U (parity psi) = parity (Gamma U psi) := by
  ext T
  simp +decide [parity, Gamma]
  rw [Finset.mul_sum]
  grind +locals

/-- The number of elements of `A` strictly below its `a`-th smallest element
is `a`. -/
theorem belowCount_orderEmbOfFin (A : Finset ι) (a : Fin A.card) :
    belowCount (A.orderEmbOfFin rfl a) A = (a : Nat) := by
  have hmem : ∀ i : Fin A.card, A.orderEmbOfFin rfl i ∈ A :=
    fun i => Finset.orderEmbOfFin_mem _ _ _
  have hfilter :
      A.filter (fun j => j < A.orderEmbOfFin rfl a) =
        (Finset.univ.filter (fun i : Fin A.card => i.val < a.val)).image
          (fun i => A.orderEmbOfFin rfl i) := by
    ext j
    simp +decide [Finset.mem_image, Finset.mem_filter]
    constructor
    · intro hj
      have himage :
          Finset.univ.image (fun i : Fin A.card => A.orderEmbOfFin rfl i) = A := by
        exact Finset.eq_of_subset_of_card_le
          (Finset.image_subset_iff.mpr fun i _ => hmem i)
          (by
            rw [Finset.card_image_of_injective _ fun i j hij => by
              simpa [Fin.ext_iff] using hij]
            simp +decide)
      obtain ⟨i, hi⟩ := Finset.mem_image.mp (himage.symm ▸ hj.1)
      exact ⟨i, by aesop⟩
    · rintro ⟨i, hi, rfl⟩
      exact ⟨hmem i, by simpa using hi⟩
  convert congrArg Finset.card hfilter using 1
  rw [Finset.card_image_of_injective _ fun i j hij => by
    simpa [Fin.ext_iff] using hij]
  simp +decide [Finset.filter_lt_eq_Ioi]
  rw [show Finset.univ.filter (fun i : Fin A.card => i < a) = Finset.Iio a by
    ext
    simp +decide]
  simp +decide [Finset.card_univ]

/-- If `y` belongs to `D`, its ordered position is strictly below `D.card`. -/
theorem belowCount_lt_card (D : Finset ι) (y : ι) (hy : y ∈ D) :
    belowCount y D < D.card := by
  exact Finset.card_lt_card
    (Finset.filter_ssubset.mpr ⟨y, hy, by simp +decide⟩)

/-- The element of `D` at the ordered position `belowCount y D` is `y`. -/
theorem orderEmbOfFin_belowCount (D : Finset ι) (y : ι) (hy : y ∈ D) :
    D.orderEmbOfFin rfl ⟨belowCount y D, belowCount_lt_card D y hy⟩ = y := by
  by_contra h
  generalize_proofs at *
  obtain ⟨c, hc⟩ : ∃ c : Fin D.card, D.orderEmbOfFin rfl c = y := by
    have hrange := Finset.range_orderEmbOfFin D rfl
    generalize_proofs at *
    exact hrange.symm.subset hy
  generalize_proofs at *
  convert belowCount_orderEmbOfFin D c using 1
  grind

/-- Removing the `a`-th ordered element reindexes the remainder through
`Fin.succAbove`. -/
theorem orderEmbOfFin_erase (A : Finset ι) {n : Nat} (hA : A.card = n + 1)
    (a : Fin (n + 1)) (b : Fin n) :
    (A.erase (A.orderEmbOfFin hA a)).orderEmbOfFin
        (by
          rw [Finset.card_erase_of_mem (A.orderEmbOfFin_mem hA a), hA]
          omega) b =
      A.orderEmbOfFin hA (a.succAbove b) := by
  set x := A.orderEmbOfFin hA a
  set A' := A.erase x
  set hA' : A'.card = n := by
    rw [Finset.card_erase_of_mem (Finset.orderEmbOfFin_mem _ _ _), hA,
      Nat.add_sub_cancel]
  all_goals generalize_proofs at *
  convert Finset.orderEmbOfFin_unique hA' _ _
  rotate_left
  exact fun b => A.orderEmbOfFin hA (a.succAbove b)
  · aesop
  · exact fun i j hij => by simpa using hij
  · constructor <;> intro h
    · convert Finset.orderEmbOfFin_unique hA' _ _
      · aesop
      · exact fun i j hij => by simpa using hij
    · exact congrFun h.symm b

/-- Express `gammaEntry` as a determinant indexed by any propositionally equal
finite cardinal. -/
theorem gammaEntry_eq_det (U : Matrix ι ι Complex) (T D : Finset ι) {n : Nat}
    (hT : T.card = n) (hD : D.card = n) :
    gammaEntry U T D =
      Matrix.det (Matrix.of fun a b : Fin n =>
        U (T.orderEmbOfFin hT a) (D.orderEmbOfFin hD b)) := by
  unfold gammaEntry
  split_ifs <;> aesop

/-- Laplace expansion of a minor along the column selected by `y`. -/
theorem gammaEntry_laplace_col (U : Matrix ι ι Complex) (T D : Finset ι)
    (y : ι) (hy : y ∈ D) (hcard : D.card = T.card) :
    gammaEntry U T D =
      ∑ j ∈ T, (-1 : Complex) ^ (belowCount j T + belowCount y D) *
        U j y * gammaEntry U (T.erase j) (D.erase y) := by
  have hpos : T.card > 0 := by
    exact hcard ▸ Finset.card_pos.mpr ⟨y, hy⟩
  obtain ⟨n, hnT, hnD⟩ : ∃ n, T.card = n + 1 ∧ D.card = n + 1 := by
    exact ⟨T.card - 1, by rw [Nat.sub_add_cancel hpos],
      by rw [hcard, Nat.sub_add_cancel hpos]⟩
  have hlaplace :
      gammaEntry U T D =
        ∑ a : Fin (n + 1),
          (-1 : Complex) ^ (a.val + belowCount y D) *
            U (T.orderEmbOfFin hnT a) y *
              gammaEntry U (T.erase (T.orderEmbOfFin hnT a)) (D.erase y) := by
    convert Matrix.det_succ_column
      (fun a b : Fin (n + 1) =>
        U (T.orderEmbOfFin hnT a) (D.orderEmbOfFin hnD b))
      (⟨belowCount y D, by linarith [belowCount_lt_card D y hy]⟩ :
        Fin (n + 1)) using 1
    · exact gammaEntry_eq_det U T D hnT hnD
    · congr! 2
      · convert rfl
        convert orderEmbOfFin_belowCount D y hy
        · rw [hnD]
        · exact hnD.symm
        · rw [hnD]
        · linarith
        · linarith
      · convert gammaEntry_eq_det U _ _ _ _ using 2
        rotate_left
        all_goals norm_num [Finset.card_erase_of_mem, hnT, hnD]
        grind +qlia
        ext i j
        simp +decide [Matrix.submatrix, orderEmbOfFin_erase]
        congr! 1
        convert (orderEmbOfFin_erase D hnD
          ⟨belowCount y D, by linarith [belowCount_lt_card D y hy]⟩ j).symm
          using 1
        convert rfl
        exact orderEmbOfFin_belowCount D y hy
  rw [hlaplace,
    Finset.sum_bij (fun a _ => T.orderEmbOfFin hnT a)]
  · exact fun a _ => Finset.orderEmbOfFin_mem _ _ _
  · aesop
  · intro b hb
    obtain ⟨a, ha⟩ : ∃ a : Fin (n + 1), T.orderEmbOfFin hnT a = b := by
      have himage :
          Finset.univ.image (fun a : Fin (n + 1) =>
            T.orderEmbOfFin hnT a) = T := by
        exact Finset.eq_of_subset_of_card_le
          (Finset.image_subset_iff.mpr fun a _ =>
            Finset.orderEmbOfFin_mem _ _ _)
          (by
            rw [Finset.card_image_of_injective _ fun a b hab => by
              simpa [Fin.ext_iff] using hab, Finset.card_fin, hnT])
      exact Finset.mem_image.mp (himage.symm ▸ hb) |>.imp fun x hx => hx.2
    use a
    simp [ha]
  · intro a _
    have hbelow : belowCount (T.orderEmbOfFin hnT a) T = a.val := by
      convert belowCount_orderEmbOfFin T
        ⟨a, by linarith [Fin.is_lt a]⟩
      · exact hnT.symm
      · linarith
      · rw [hnT]
      · grind +splitImp
      · grind +splitIndPred
    rw [hbelow]

/-- Reindex a sum over `T` through its ordered enumeration. -/
theorem sum_orderEmb (T : Finset ι) {n : Nat} (hT : T.card = n)
    (f : ι → Complex) :
    ∑ j ∈ T, f j = ∑ a : Fin n, f (T.orderEmbOfFin hT a) := by
  convert Finset.sum_image (fun x _ y _ hxy => ?_)
  all_goals try infer_instance
  · rw [Finset.eq_of_subset_of_card_le
      (Finset.image_subset_iff.mpr fun i _ =>
        Finset.orderEmbOfFin_mem _ _ _)
      (by
        rw [Finset.card_image_of_injective _ fun i j hij => by
          simpa [hT] using hij, Finset.card_fin, hT])]
  · simpa [Fin.ext_iff] using hxy

/-- The cofactor sum vanishes when the inserted column is already present. -/
theorem gammaEntry_cofactor_zero (U : Matrix ι ι Complex) (i : ι)
    (T S' : Finset ι) (hi : i ∈ S') (hcard : T.card = S'.card + 1) :
    ∑ j ∈ T, (-1 : Complex) ^ belowCount j T * U j i *
      gammaEntry U (T.erase j) S' = 0 := by
  have hreindex :
      ∑ j ∈ T, (-1 : Complex) ^ belowCount j T * U j i *
          gammaEntry U (T.erase j) S' =
        ∑ a : Fin (S'.card + 1), (-1 : Complex) ^ (a : Nat) *
          U (T.orderEmbOfFin hcard a) i *
            gammaEntry U (T.erase (T.orderEmbOfFin hcard a)) S' := by
    refine Finset.sum_bij (fun j _ =>
      ⟨belowCount j T, ?_⟩) ?_ ?_ ?_ ?_ <;>
      simp_all +decide [Finset.mem_erase, Finset.mem_filter]
    exact Nat.le_of_lt_succ ((belowCount_lt_card T j ‹_›).trans_le
      (by simp +decide [hcard]))
    · intro a₁ ha₁ a₂ ha₂ h
      have h1 := orderEmbOfFin_belowCount T a₁ ha₁
      have h2 := orderEmbOfFin_belowCount T a₂ ha₂
      aesop
    · intro b
      use T.orderEmbOfFin hcard b
      have h := belowCount_orderEmbOfFin T
        ⟨b, by linarith [Fin.is_lt b]⟩
      aesop
    · intro a ha
      have heq : a = T.orderEmbOfFin hcard
          ⟨belowCount a T, by exact hcard ▸ belowCount_lt_card T a ha⟩ :=
        (orderEmbOfFin_belowCount T a ha).symm
      generalize_proofs at *
      rw [← heq]
  obtain ⟨d0, hd0⟩ :
      ∃ d0 : Fin S'.card, S'.orderEmbOfFin (by omega) d0 = i := by
    have himage :
        Finset.univ.image (fun d : Fin S'.card =>
          S'.orderEmbOfFin (by omega) d) = S' := by
      exact Finset.eq_of_subset_of_card_le
        (Finset.image_subset_iff.mpr fun _ _ =>
          Finset.orderEmbOfFin_mem _ _ _)
        (by
          rw [Finset.card_image_of_injective _ fun x y hxy => by
            simpa [Fin.ext_iff] using hxy]
          simp +decide)
    exact Finset.mem_image.mp (himage.symm ▸ hi) |>.imp fun x hx => hx.2
  have hdet : Matrix.det (Matrix.of
      (fun a : Fin (S'.card + 1) =>
        Fin.cons (U (T.orderEmbOfFin hcard a) i)
          (fun d : Fin S'.card =>
            U (T.orderEmbOfFin hcard a)
              (S'.orderEmbOfFin (by omega) d)))) = 0 := by
    convert Matrix.det_zero_of_column_eq
      (show (0 : Fin (S'.card + 1)) ≠ Fin.succ d0 from
        ne_of_lt (Fin.succ_pos _)) _ using 1
    aesop
  rw [← hdet, Matrix.det_succ_column_zero]
  convert hreindex using 2
  rw [gammaEntry_eq_det]
  congr! 2
  ext a b
  simp +decide [orderEmbOfFin_erase]
  · rw [Finset.card_erase_of_mem (Finset.orderEmbOfFin_mem _ _ _),
      hcard, Nat.add_sub_cancel]
  · rfl

/-- Laplace expansion along a fresh inserted column, with the fermionic signs
made explicit. -/
theorem gammaEntry_column_expansion (U : Matrix ι ι Complex) (i : ι)
    (T S' : Finset ι) (hi : i ∉ S') :
    opSign i (insert i S') * gammaEntry U T (insert i S') =
      ∑ j ∈ T, U j i * opSign j T * gammaEntry U (T.erase j) S' := by
  by_cases hcard : (insert i S').card = T.card <;>
    simp_all +decide [Finset.mem_erase, Finset.mem_insert]
  · have hlaplace :
        gammaEntry U T (insert i S') =
          ∑ j ∈ T,
            (-1 : Complex) ^
              (belowCount j T + belowCount i (insert i S')) *
              U j i * gammaEntry U (T.erase j) S' := by
      convert gammaEntry_laplace_col U T (insert i S') i
        (Finset.mem_insert_self i S') _ using 1
      aesop
      rw [Finset.card_insert_of_notMem hi, hcard]
    generalize_proofs at *
    simp +decide only [opSign, hlaplace, mul_sum]
    refine Finset.sum_congr rfl fun j _ => ?_
    ring
    simp +decide [pow_add, pow_mul, hi]
    ring
    norm_num [pow_mul']
  · rw [gammaEntry]
    simp +decide [Finset.card_insert_of_notMem hi, hcard]
    refine (Finset.sum_eq_zero fun j hj => ?_).symm
    rw [gammaEntry]
    grind

/-- The repeated-column cofactor expansion vanishes. -/
theorem gammaEntry_column_vanish (U : Matrix ι ι Complex) (i : ι)
    (T S' : Finset ι) (hi : i ∈ S') :
    ∑ j ∈ T, U j i * opSign j T * gammaEntry U (T.erase j) S' = 0 := by
  by_cases hcard : T.card = S'.card + 1
  · convert gammaEntry_cofactor_zero U i T S' hi hcard using 2
    ring!
    unfold opSign
    ring
  · refine Finset.sum_eq_zero fun j hj => ?_
    simp_all +decide [gammaEntry]
    grind

/-- **Creation covariance.** The determinant-minor lift sends creation in an
input mode to the `U`-weighted sum of output-mode creations. -/
theorem gamma_create_covariance (U : Matrix ι ι Complex) (i : ι)
    (psi : Fock ι) :
    Gamma U (create i psi) =
      ∑ j : ι, U j i • create j (Gamma U psi) := by
  ext T
  have hlhs :
      Gamma U (create i psi) T =
        ∑ S' ∈ Finset.univ.filter (fun S' => i ∉ S'),
          opSign i (insert i S') * gammaEntry U T (insert i S') * psi S' := by
    unfold create Gamma
    simp +decide [Finset.sum_ite]
    refine Finset.sum_bij (fun S _ => S.erase i) ?_ ?_ ?_ ?_ <;>
      simp_all +decide [Finset.mem_erase, Finset.mem_filter]
    · intro a₁ ha₁ a₂ ha₂ h
      rw [← Finset.insert_erase ha₁, ← Finset.insert_erase ha₂, h]
    · exact fun b hi =>
        ⟨insert i b, Finset.mem_insert_self _ _, Finset.erase_insert hi⟩
    · exact fun _ _ => by ring
  have hrhs :
      (∑ j, U j i • create j (Gamma U psi)) T =
        ∑ S',
          (∑ j ∈ T,
            U j i * opSign j T * gammaEntry U (T.erase j) S') * psi S' := by
    simp +decide [create, Finset.sum_mul]
    rw [Finset.sum_comm, Finset.sum_congr rfl]
    intros
    simp +decide [Gamma, Finset.mul_sum, mul_assoc]
  rw [hlhs, hrhs,
    ← Finset.sum_subset
      (Finset.subset_univ (Finset.univ.filter (fun S' => i ∉ S')))]
  · exact Finset.sum_congr rfl fun S' hS' => by
      rw [gammaEntry_column_expansion U i T S'
        (Finset.mem_filter.mp hS' |>.2)]
  · simp +contextual [gammaEntry_column_vanish]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.Gamma_vac' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Gamma_vac

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.Gamma_apply_singleton' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Gamma_apply_singleton

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.Gamma_number' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Gamma_number

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.Gamma_parity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Gamma_parity

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.gamma_create_covariance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gamma_create_covariance

end PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization
