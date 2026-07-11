import PhysicsSM.Draft.NullEdge.FiniteCARFockBasic

/-!
# Determinant-minor finite second quantization

This module defines the occupation-basis exterior-power lift `Gamma(U)` of an
arbitrary finite one-particle matrix.  It proves vacuum preservation, exact
one-particle agreement, linearity, and conservation of particle number and
fermion parity.  Its main composition theorem is creation covariance: applying
`Gamma U` after creating an input mode is exactly the sum of output creations
weighted by the corresponding column of `U`.

The development now also proves exact exterior functoriality, ordered-minor
adjoint compatibility, a two-sided inverse, and preservation of the finite Fock
inner product for unitary `U`.  Annihilation covariance and inherited spatial
locality remain successor theorems.

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

/-! ## Identity and functoriality of the exterior lift -/

/-- Reading off the `T` component of `Gamma U (basisVec S)` gives the ordered
minor `gammaEntry U T S`. -/
theorem gammaEntry_eq_Gamma_basisVec (U : Matrix ι ι Complex)
    (T S : Finset ι) :
    Gamma U (basisVec S) T = gammaEntry U T S := by
  unfold Gamma basisVec
  aesop

/-- Every finite Fock vector is the sum of its occupation-basis components. -/
theorem fock_eq_sum_basisVec (psi : Fock ι) :
    psi = ∑ S : Finset ι, psi S • basisVec S := by
  ext T
  simp +decide [basisVec]

/-- The exterior lift commutes with finite sums of Fock vectors. -/
theorem Gamma_finset_sum {β : Type*} (U : Matrix ι ι Complex)
    (s : Finset β) (g : β → Fock ι) :
    Gamma U (∑ b ∈ s, g b) = ∑ b ∈ s, Gamma U (g b) := by
  by_contra h
  obtain ⟨T, hT⟩ :
      ∃ T : Finset ι,
        (Gamma U (∑ b ∈ s, g b)) T ≠ (∑ b ∈ s, Gamma U (g b)) T := by
    exact Function.ne_iff.mp h
  simp +decide [Gamma, Finset.sum_apply, Finset.mul_sum] at hT
  exact hT Finset.sum_comm

/-- Creation on a basis vector yields, up to its Koszul sign, the basis vector
of the enlarged occupation set. -/
theorem create_basisVec (i : ι) (S' : Finset ι) (hi : i ∉ S') :
    create i (basisVec S') = opSign i (insert i S') • basisVec (insert i S') := by
  ext T
  by_cases hT : i ∈ T <;> simp_all +decide [create, basisVec]
  · grind
  · aesop

/-- An occupied basis vector is signed creation applied to the basis vector
with that mode removed. -/
theorem basisVec_eq_opSign_create (i : ι) (S : Finset ι) (hi : i ∈ S) :
    basisVec S = opSign i S • create i (basisVec (S.erase i)) := by
  rw [create_basisVec i (S.erase i)]
  · simp +decide [← smul_assoc, opSign_mul_self, hi]
  · grind +splitImp

/-- Ordered minors of the identity are occupation-basis Kronecker deltas. -/
theorem gammaEntry_one (T S : Finset ι) :
    gammaEntry (1 : Matrix ι ι Complex) T S = if T = S then 1 else 0 := by
  unfold gammaEntry
  split_ifs <;> simp_all +decide [Matrix.one_apply]
  · erw [Matrix.det_one]
  · obtain ⟨t, htT, htS⟩ : ∃ t ∈ T, t ∉ S := by
      exact Finset.not_subset.mp fun h => ‹¬T = S› <|
        Finset.eq_of_subset_of_card_le h <| by linarith
    obtain ⟨a, ha⟩ : ∃ a : Fin T.card, T.orderEmbOfFin rfl a = t := by
      have h := Finset.range_orderEmbOfFin T rfl
      exact h.symm.subset htT
    rw [Matrix.det_eq_zero_of_row_eq_zero a]
    aesop

/-- The exterior lift sends the one-particle identity to the Fock identity. -/
theorem Gamma_one (psi : Fock ι) :
    Gamma (1 : Matrix ι ι Complex) psi = psi := by
  ext T
  simp +decide [Gamma, gammaEntry_one]

/-- Functoriality on an occupation-basis vector, proved by induction through
creation covariance. -/
theorem Gamma_mul_basisVec (U V : Matrix ι ι Complex) (S : Finset ι) :
    Gamma (U * V) (basisVec S) = Gamma U (Gamma V (basisVec S)) := by
  induction' n : S.card using Nat.strong_induction_on with n ih generalizing S
  cases' S.eq_empty_or_nonempty with hS hS
  · simp +decide [hS, Gamma_vac]
    convert Gamma_vac (U * V) using 1
    convert Gamma_vac U using 1
    convert congr_arg (Gamma U) (Gamma_vac V) using 1
  · obtain ⟨i, hi⟩ : ∃ i, i ∈ S := hS
    have h_ind :
        Gamma (U * V) (basisVec (S.erase i)) =
          Gamma U (Gamma V (basisVec (S.erase i))) := by
      exact ih _ (by
        rw [Finset.card_erase_of_mem hi, n]
        exact Nat.pred_lt (by aesop)) _ rfl
    have h_ind :
        Gamma (U * V) (create i (basisVec (S.erase i))) =
          Gamma U (Gamma V (create i (basisVec (S.erase i)))) := by
      rw [gamma_create_covariance, gamma_create_covariance]
      simp +decide [h_ind, Gamma_finset_sum, Gamma_smul]
      simp +decide [Matrix.mul_apply, Finset.mul_sum _ _ _, Finset.sum_mul,
        smul_smul, mul_comm]
      simp +decide [Finset.sum_smul, Finset.smul_sum, Gamma_finset_sum,
        Gamma_smul, gamma_create_covariance]
      exact Finset.sum_comm.trans
        (Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by
          simp +decide [mul_assoc, mul_comm, mul_left_comm, smul_smul])
    rw [basisVec_eq_opSign_create i S hi, Gamma_smul, Gamma_smul, Gamma_smul,
      h_ind]

/-- Cauchy-Binet in the exact ordered-minor convention used by `Gamma`. -/
theorem gammaEntry_mul (U V : Matrix ι ι Complex) (T S : Finset ι) :
    gammaEntry (U * V) T S =
      ∑ A : Finset ι, gammaEntry U T A * gammaEntry V A S := by
  rw [← gammaEntry_eq_Gamma_basisVec, Gamma_mul_basisVec]
  unfold Gamma
  simp +decide [basisVec]

/-- The determinant-minor second quantization is functorial. -/
theorem Gamma_mul (U V : Matrix ι ι Complex) (psi : Fock ι) :
    Gamma (U * V) psi = Gamma U (Gamma V psi) := by
  have h_lhs :
      Gamma (U * V) psi =
        ∑ S : Finset ι, psi S • Gamma (U * V) (basisVec S) := by
    convert Gamma_finset_sum (U * V) Finset.univ
      (fun S => psi S • basisVec S) using 1
    · exact congr_arg _ (fock_eq_sum_basisVec psi)
    · exact Finset.sum_congr rfl fun _ _ => by rw [Gamma_smul]
  have h_rhs :
      Gamma U (Gamma V psi) =
        ∑ S : Finset ι, psi S • Gamma U (Gamma V (basisVec S)) := by
    have h_expand :
        Gamma V psi = ∑ S : Finset ι, psi S • Gamma V (basisVec S) := by
      conv_lhs => rw [fock_eq_sum_basisVec psi]
      exact Gamma_finset_sum V Finset.univ
        (fun S => psi S • basisVec S) ▸ by simp +decide [Gamma_smul]
    rw [h_expand, Gamma_finset_sum,
      Finset.sum_congr rfl fun _ _ => Gamma_smul _ _ _]
  simp_all +decide only [Gamma_mul_basisVec]

/-- Conjugate transpose reverses the ordered minor and conjugates its value. -/
theorem gammaEntry_conjTranspose (U : Matrix ι ι Complex) (T S : Finset ι) :
    gammaEntry Uᴴ T S = star (gammaEntry U S T) := by
  by_cases h : S.card = T.card <;>
    simp_all +decide [Finset.sum_ite, gammaEntry]
  · rw [← Matrix.det_transpose]
    simp +decide [Matrix.det_apply']
    convert rfl
  · grind

/-- Finite occupation-basis Hermitian inner product. -/
def fockInner (psi phi : Fock ι) : Complex :=
  ∑ S : Finset ι, star (psi S) * phi S

/-- Moving the exterior lift across the occupation-basis inner product replaces
the one-particle matrix by its conjugate transpose. -/
theorem fockInner_Gamma_left (U : Matrix ι ι Complex) (psi phi : Fock ι) :
    fockInner (Gamma U psi) phi = fockInner psi (Gamma Uᴴ phi) := by
  unfold fockInner Gamma
  simp only [star_sum, StarMul.star_mul]
  simp_rw [gammaEntry_conjTranspose]
  simp_rw [Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro S hS
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro T hT
  ring

/-- A unitary one-particle matrix preserves the finite occupation-basis
Hermitian inner product after determinant-minor second quantization. -/
theorem Gamma_preserves_fockInner (U : Matrix ι ι Complex)
    (hleft : Uᴴ * U = 1) (hright : U * Uᴴ = 1)
    (psi phi : Fock ι) :
    fockInner (Gamma U psi) (Gamma U phi) = fockInner psi phi := by
  rw [fockInner_Gamma_left, ← Gamma_mul, hleft, Gamma_one]

/-- If a one-particle matrix has conjugate-transpose inverses on both sides,
then its determinant-minor lift has the corresponding two-sided inverse. -/
theorem Gamma_unitary_inverse (U : Matrix ι ι Complex)
    (hleft : Uᴴ * U = 1) (hright : U * Uᴴ = 1) (psi : Fock ι) :
    Gamma Uᴴ (Gamma U psi) = psi ∧ Gamma U (Gamma Uᴴ psi) = psi := by
  constructor
  · rw [← Gamma_mul, hleft, Gamma_one]
  · rw [← Gamma_mul, hright, Gamma_one]

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

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.Gamma_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Gamma_one

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.gammaEntry_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gammaEntry_mul

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.Gamma_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Gamma_mul

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.gammaEntry_conjTranspose' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gammaEntry_conjTranspose

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.Gamma_unitary_inverse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Gamma_unitary_inverse

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.fockInner_Gamma_left' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fockInner_Gamma_left

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.Gamma_preserves_fockInner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Gamma_preserves_fockInner

end PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization
