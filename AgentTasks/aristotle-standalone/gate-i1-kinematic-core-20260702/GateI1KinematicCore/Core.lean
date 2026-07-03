import Mathlib

/-!
# Gate I1 kinematic core

Mathlib-only draft package for the finite algebra at the start of Gate I1.

This file records the `(+---)` Pauli/Hermitian soldering convention and the
finite Pluecker mass identity used by the P2 kinematic dictionary.  It is a
standalone staging file under `AgentTasks/aristotle-standalone`: no project
modules are imported here, so the file is suitable for focused Aristotle
submission if later lemmas need remote proof search.

Conventions:

* `minkHerm p = p0 I + px sigma_x + py sigma_y + pz sigma_z`, concretely
  `!![p0 + pz, px - i py; px + i py, p0 - pz]`.
* The metric signature is mostly-minus: `p^2 = p0^2 - px^2 - py^2 - pz^2`.
* Spinor wedge convention is `eps_12 = +1`:
  `spinorWedge psi phi = psi 0 * phi 1 - psi 1 * phi 0`.
* Squared complex modulus is represented in `Complex` as `z * conj z`, matching
  the determinant codomain of the Hermitian momentum matrix.

Provenance: clean-room consolidation of the existing project finite spinor
algebra in `PhysicsSM.Spinor.PluckerMass` and the spinor-helicity draft
`PhysicsSM.Draft.SpinorHelicityRankOneAristotle`, aligned with
`AgentTasks/nerd-gate-i1-kinematic-core-lean-plan-2026-07-02.md`.
-/

noncomputable section

namespace GateI1KinematicCore

open BigOperators
open Matrix Complex
open scoped ComplexOrder

/-! ## I1.1: Pauli/Hermitian soldering -/

/-- Complex two-component spinors. -/
abbrev CSpinor := Fin 2 -> Complex

/-- Real four-momenta in the `(+---)` convention. -/
abbrev Momentum4 := Fin 4 -> Real

/-- Concrete `2 x 2` complex matrix carrier for Hermitian momenta. -/
abbrev Herm2 := Matrix (Fin 2) (Fin 2) Complex

/-- First Pauli matrix. -/
def pauliX : Herm2 :=
  !![(0 : Complex), 1; 1, 0]

/-- Second Pauli matrix. -/
def pauliY : Herm2 :=
  !![(0 : Complex), -Complex.I; Complex.I, 0]

/-- Third Pauli matrix. -/
def pauliZ : Herm2 :=
  !![(1 : Complex), 0; 0, -1]

/-- The Pauli/Hermitian soldering map `p0 I + p . sigma`. -/
def solderedMomentum (p0 px py pz : Real) : Herm2 :=
  ((p0 : Complex) • (1 : Herm2))
    + ((px : Complex) • pauliX)
    + ((py : Complex) • pauliY)
    + ((pz : Complex) • pauliZ)

/--
The `2 x 2` Hermitian matrix `sigma . p` of a real four-vector in signature
`(+,-,-,-)`.
-/
def minkHerm (p : Momentum4) : Herm2 :=
  !![((p 0 + p 3 : Real) : Complex), ((p 1 : Real) : Complex) - ((p 2 : Real) : Complex) * I;
     ((p 1 : Real) : Complex) + ((p 2 : Real) : Complex) * I, ((p 0 - p 3 : Real) : Complex)]

/-- The coordinate-free Pauli sum is the concrete `minkHerm` matrix. -/
theorem solderedMomentum_eq_minkHerm (p0 px py pz : Real) :
    solderedMomentum p0 px py pz = minkHerm ![p0, px, py, pz] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [solderedMomentum, pauliX, pauliY, pauliZ, minkHerm] <;> ring

/-- I1.1: the soldered determinant is the mostly-minus Minkowski square. -/
theorem i1_1_soldering_det (p0 px py pz : Real) :
    (solderedMomentum p0 px py pz).det =
      (((p0 ^ 2 - (px ^ 2 + py ^ 2 + pz ^ 2) : Real)) : Complex) := by
  unfold solderedMomentum pauliX pauliY pauliZ
  norm_num [Matrix.det_fin_two]
  ring_nf
  rw [Complex.I_sq]
  ring

/-- `minkHerm p` is Hermitian. -/
theorem minkHerm_conjTranspose (p : Momentum4) :
    (minkHerm p)ᴴ = minkHerm p := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp +decide [minkHerm]
  ring

/-- Determinant form of I1.1 for vector-valued four-momenta. -/
theorem det_minkHerm (p : Momentum4) :
    (minkHerm p).det
      = (((p 0) ^ 2 - (p 1) ^ 2 - (p 2) ^ 2 - (p 3) ^ 2 : Real) : Complex) := by
  norm_num [Matrix.det_fin_two, minkHerm]
  ring
  norm_num
  ring

/-- Mostly-minus Minkowski square of a four-momentum. -/
def minkowskiSq (p : Momentum4) : Real :=
  (p 0) ^ 2 - (p 1) ^ 2 - (p 2) ^ 2 - (p 3) ^ 2

/-- Determinant of `minkHerm p`, named through `minkowskiSq`. -/
theorem det_minkHerm_eq_minkowskiSq (p : Momentum4) :
    (minkHerm p).det = (minkowskiSq p : Complex) := by
  simpa [minkowskiSq] using det_minkHerm p

/-- Spatial Euclidean norm squared of a four-momentum. -/
def spatialNormSq (p : Momentum4) : Real :=
  (p 1) ^ 2 + (p 2) ^ 2 + (p 3) ^ 2

/-- The spatial norm squared is nonnegative. -/
theorem spatialNormSq_nonneg (p : Momentum4) : 0 <= spatialNormSq p := by
  unfold spatialNormSq
  nlinarith [sq_nonneg (p 1), sq_nonneg (p 2), sq_nonneg (p 3)]

/-- Upper algebraic spectral root `p0 + |p|`. -/
def spectralPlus (p : Momentum4) : Real :=
  p 0 + Real.sqrt (spatialNormSq p)

/-- Lower algebraic spectral root `p0 - |p|`. -/
def spectralMinus (p : Momentum4) : Real :=
  p 0 - Real.sqrt (spatialNormSq p)

/--
I1.2 algebraic spectral equation: subtracting a real scalar from the soldered
Hermitian block gives determinant `(p0 - lambda)^2 - |p|^2`.
-/
theorem i1_2_det_minkHerm_sub_smul_one (p : Momentum4) (lambda : Real) :
    (minkHerm p - ((lambda : Complex) • (1 : Herm2))).det =
      ((((p 0 - lambda) ^ 2 - spatialNormSq p : Real)) : Complex) := by
  unfold spatialNormSq
  norm_num [Matrix.det_fin_two, minkHerm]
  ring_nf
  rw [Complex.I_sq]
  ring

/-- The upper algebraic spectral root has zero characteristic determinant. -/
theorem i1_2_spectralPlus_det_zero (p : Momentum4) :
    (minkHerm p - ((spectralPlus p : Complex) • (1 : Herm2))).det = 0 := by
  rw [i1_2_det_minkHerm_sub_smul_one]
  unfold spectralPlus
  rw [Complex.ofReal_eq_zero]
  nlinarith [Real.sq_sqrt (spatialNormSq_nonneg p)]

/-- The lower algebraic spectral root has zero characteristic determinant. -/
theorem i1_2_spectralMinus_det_zero (p : Momentum4) :
    (minkHerm p - ((spectralMinus p : Complex) • (1 : Herm2))).det = 0 := by
  rw [i1_2_det_minkHerm_sub_smul_one]
  unfold spectralMinus
  rw [Complex.ofReal_eq_zero]
  nlinarith [Real.sq_sqrt (spatialNormSq_nonneg p)]

/--
I1.2 real future-cone characterization: the lower algebraic spectral root is
nonnegative exactly when the energy is nonnegative and dominates the spatial
norm squared.
-/
theorem i1_2_spectralMinus_nonneg_iff_futureCone (p : Momentum4) :
    0 <= spectralMinus p
      ↔ 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2 := by
  constructor
  · intro h
    have hs : 0 <= Real.sqrt (spatialNormSq p) := Real.sqrt_nonneg _
    have hp : Real.sqrt (spatialNormSq p) <= p 0 := by
      unfold spectralMinus at h
      linarith
    have hp0 : 0 <= p 0 := le_trans hs hp
    have hsq : (Real.sqrt (spatialNormSq p)) ^ 2 <= (p 0) ^ 2 := by
      exact sq_le_sq' (by linarith) hp
    constructor
    · exact hp0
    · simpa [Real.sq_sqrt (spatialNormSq_nonneg p)] using hsq
  · intro h
    unfold spectralMinus
    have hsqrt_le : Real.sqrt (spatialNormSq p) <= p 0 := by
      rw [Real.sqrt_le_iff]
      exact ⟨h.1, h.2⟩
    linarith

/-- On the future cone, both algebraic spectral roots are nonnegative. -/
theorem i1_2_spectralRoots_nonneg_of_futureCone (p : Momentum4)
    (h : 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2) :
    0 <= spectralMinus p ∧ 0 <= spectralPlus p := by
  have hminus : 0 <= spectralMinus p :=
    (i1_2_spectralMinus_nonneg_iff_futureCone p).mpr h
  constructor
  · exact hminus
  · unfold spectralMinus at hminus
    unfold spectralPlus
    have hsqrt : 0 <= Real.sqrt (spatialNormSq p) := Real.sqrt_nonneg _
    linarith

/-- `minkHerm p` is Hermitian as a Mathlib `IsHermitian` proposition. -/
theorem minkHerm_isHermitian (p : Momentum4) :
    (minkHerm p).IsHermitian :=
  minkHerm_conjTranspose p

/--
I1.2: positive semidefiniteness of the soldered block is exactly the future
cone condition in mostly-minus signature.
-/
theorem i1_2_minkHerm_posSemidef_iff_futureCone (p : Momentum4) :
    (minkHerm p).PosSemidef
      ↔ 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2 := by
  refine' ⟨fun h => _, fun h => _⟩
  · have hquad := h.2
    constructor
    · have h00 := hquad (Finsupp.single 0 1)
      have h11 := h.2 (Finsupp.single 1 1)
      norm_num [minkHerm] at h00 h11
      norm_cast at *
      linarith
    · have hdet := h.det_nonneg
      rw [det_minkHerm] at hdet
      norm_cast at hdet
      unfold spatialNormSq
      linarith
  · constructor
    · exact minkHerm_isHermitian p
    · intro x
      simp +decide [Finsupp.sum_fintype, minkHerm]
      norm_num [Complex.le_def] at *
      constructor <;> ring
      unfold spatialNormSq at h
      by_cases h2 : p 0 + p 3 = 0
      · norm_num [show p 1 = 0 by nlinarith, show p 2 = 0 by nlinarith]
        nlinarith
      · by_cases h3 : p 0 + p 3 > 0
        · nlinarith
            [sq_nonneg
              (Complex.re (x 0) * (p 0 + p 3)
                + Complex.re (x 1) * p 1 + Complex.im (x 1) * p 2),
              sq_nonneg
              (Complex.im (x 0) * (p 0 + p 3)
                + Complex.im (x 1) * p 1 - Complex.re (x 1) * p 2),
              mul_self_pos.mpr h2]
        · nlinarith [mul_self_pos.mpr h2]

/--
I1.2 eigenvalue form: Mathlib's Hermitian eigenvalues are nonnegative exactly
on the same future cone.
-/
theorem i1_2_minkHerm_eigenvalues_nonneg_iff_futureCone (p : Momentum4) :
    0 <= (minkHerm_isHermitian p).eigenvalues
      ↔ 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2 := by
  rw [← (minkHerm_isHermitian p).posSemidef_iff_eigenvalues_nonneg]
  exact i1_2_minkHerm_posSemidef_iff_futureCone p

/-- The trace recovers twice the energy component. -/
theorem trace_minkHerm (p : Momentum4) :
    Matrix.trace (minkHerm p) = ((2 * p 0 : Real) : Complex) := by
  simp +decide [minkHerm, Matrix.trace]
  ring

/-- The soldering map is injective, so its entries determine the four-vector. -/
theorem minkHerm_injective : Function.Injective minkHerm := by
  intro p q h; ext i; fin_cases i <;>
    (have := congr_fun (congr_fun h 0) 0
     have := congr_fun (congr_fun h 0) 1
     have := congr_fun (congr_fun h 1) 0
     have := congr_fun (congr_fun h 1) 1)
  · unfold minkHerm at *
    norm_num [Complex.ext_iff] at *
    linarith!
  · simp_all +decide [Complex.ext_iff, minkHerm]
  · simp_all +decide [Complex.ext_iff, minkHerm]
  · unfold minkHerm at *
    norm_num [Complex.ext_iff] at *
    linarith!

/-! ## I1.3-I1.4: rank-one null spinors -/

/-- The rank-one bispinor `lambda lambda^dagger` of a two-spinor. -/
def rankOne (lam : CSpinor) : Herm2 :=
  Matrix.vecMulVec lam fun a => starRingEnd Complex (lam a)

/-- Rank-one bispinors are positive semidefinite Hermitian matrices. -/
theorem rankOne_posSemidef (lam : CSpinor) : (rankOne lam).PosSemidef := by
  simpa [rankOne] using Matrix.posSemidef_vecMulVec_self_star lam

/-- A rank-one bispinor has matrix rank at most one. -/
theorem rankOne_rank_le_one (lam : CSpinor) :
    (rankOne lam).rank <= 1 := by
  simpa [rankOne] using
    Matrix.rank_vecMulVec_le lam (fun a => starRingEnd Complex (lam a))

/-- A `2 x 2` complex matrix has rank zero exactly when it is the zero matrix. -/
theorem herm2_rank_eq_zero_iff (A : Herm2) : A.rank = 0 ↔ A = 0 := by
  constructor
  · intro h
    rw [Matrix.rank] at h
    have hrange : LinearMap.range A.mulVecLin = ⊥ := by
      rwa [Submodule.finrank_eq_zero] at h
    exact Matrix.ext fun i j => by
      have hlin : A.mulVecLin (Pi.single j (1 : Complex)) = 0 := by
        have hz : A.mulVecLin (Pi.single j (1 : Complex))
            ∈ LinearMap.range A.mulVecLin := ⟨Pi.single j (1 : Complex), rfl⟩
        simpa [hrange] using hz
      simpa [Matrix.mulVecLin, Matrix.mulVec, dotProduct, Pi.single,
        Function.update, Matrix.zero_apply] using congr_fun hlin i
  · intro h
    simp [h]

/-- Pointwise conjugating a two-spinor detects whether it is zero. -/
theorem star_vector_eq_zero_iff (lam : CSpinor) :
    (fun a => starRingEnd Complex (lam a)) = 0 ↔ lam = 0 := by
  constructor
  · intro h
    ext i
    exact star_eq_zero.mp (congr_fun h i)
  · intro h
    ext i
    simp [h]

/-- The rank-one bispinor vanishes in rank exactly when the spinor vanishes. -/
theorem rankOne_rank_eq_zero_iff (lam : CSpinor) :
    (rankOne lam).rank = 0 ↔ lam = 0 := by
  rw [herm2_rank_eq_zero_iff, rankOne]
  rw [Matrix.vecMulVec_eq_zero]
  rw [star_vector_eq_zero_iff]
  simp

/-- A nonzero rank-one bispinor has rank exactly one. -/
theorem rankOne_rank_eq_one (lam : CSpinor) (h : lam ≠ 0) :
    (rankOne lam).rank = 1 := by
  have hle : (rankOne lam).rank <= 1 := rankOne_rank_le_one lam
  have hne : (rankOne lam).rank ≠ 0 := by
    intro hz
    exact h ((rankOne_rank_eq_zero_iff lam).mp hz)
  omega

/-- I1.3: rank-one spinor momenta have the expected zero/nonzero rank dichotomy. -/
theorem i1_3_rank_one_rank_dichotomy (lam : CSpinor) :
    (lam = 0 ∧ (rankOne lam).rank = 0)
      ∨ (lam ≠ 0 ∧ (rankOne lam).rank = 1) := by
  by_cases h : lam = 0
  · exact Or.inl ⟨h, (rankOne_rank_eq_zero_iff lam).mpr h⟩
  · exact Or.inr ⟨h, rankOne_rank_eq_one lam h⟩

/--
The null future-pointing four-momentum recovered from a two-spinor, with the
normalization folded into components.
-/
def momentumOf (lam : CSpinor) : Momentum4 :=
  ![(Complex.normSq (lam 0) + Complex.normSq (lam 1)) / 2,
    (lam 0 * (starRingEnd Complex) (lam 1)).re,
    -((lam 0 * (starRingEnd Complex) (lam 1)).im),
    (Complex.normSq (lam 0) - Complex.normSq (lam 1)) / 2]

/-- A rank-one spinor momentum has determinant zero. -/
theorem det_rankOne_eq_zero (lam : CSpinor) :
    (rankOne lam).det = 0 := by
  simp [rankOne, Matrix.det_fin_two, Matrix.vecMulVec]
  ring

/-- The rank-one bispinor of a two-spinor is the Hermitian matrix of its momentum. -/
theorem minkHerm_momentumOf (lam : CSpinor) :
    minkHerm (momentumOf lam) = rankOne lam := by
  unfold minkHerm rankOne momentumOf
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [Complex.ext_iff, Matrix.vecMulVec] <;> ring
  · erw [Matrix.cons_val_succ']
    norm_num
    ring
    rw [Complex.normSq_apply, sq, sq]
  · erw [Matrix.cons_val_succ']
    norm_num
    ring
  · exact ⟨trivial, rfl⟩
  · erw [Matrix.cons_val_succ']
    norm_num [Complex.normSq]
    ring

/-- The four-momentum of a two-spinor is null. -/
theorem momentumOf_null (lam : CSpinor) :
    (momentumOf lam 0) ^ 2
      = (momentumOf lam 1) ^ 2 + (momentumOf lam 2) ^ 2
        + (momentumOf lam 3) ^ 2 := by
  unfold momentumOf
  simp +decide [Complex.normSq, Complex.mul_re, Complex.mul_im]
  ring

/-- The four-momentum of a two-spinor is weakly future-pointing. -/
theorem momentumOf_nonneg (lam : CSpinor) : 0 <= momentumOf lam 0 := by
  exact div_nonneg (add_nonneg (Complex.normSq_nonneg _) (Complex.normSq_nonneg _)) zero_le_two

/--
I1.4, concrete rank-one factorization: a real four-vector is null and
weakly future-pointing exactly when its Hermitian matrix is `lambda lambda^dagger`
for some two-spinor `lambda`.
-/
theorem i1_4_rank_one_factorization (p : Momentum4) :
    ((p 0) ^ 2 = (p 1) ^ 2 + (p 2) ^ 2 + (p 3) ^ 2 ∧ 0 <= p 0)
      ↔ ∃ lam : CSpinor, minkHerm p = rankOne lam := by
  constructor <;> intro h
  · by_cases h_case : p 0 + p 3 = 0
    · use ![0, Real.sqrt (2 * p 0)]
      ext i j
      fin_cases i <;> fin_cases j <;> norm_num [minkHerm, rankOne] <;> ring
      · norm_cast
      · norm_num [Complex.ext_iff]
        constructor <;> nlinarith
      · norm_num [Complex.ext_iff]
        constructor <;> nlinarith
      · norm_cast
        norm_num [Real.sq_sqrt h.2]
        nlinarith
    · have hsqrt_ne : (Real.sqrt (p 0 + p 3) : Complex) ≠ 0 :=
        Complex.ofReal_ne_zero.mpr <| ne_of_gt <| Real.sqrt_pos.mpr <|
          lt_of_le_of_ne (by nlinarith) (Ne.symm h_case)
      refine ⟨fun i => if i = 0 then Real.sqrt (p 0 + p 3)
          else (p 1 + p 2 * Complex.I) / Real.sqrt (p 0 + p 3), ?_⟩
      ext i j
      fin_cases i <;> fin_cases j <;> simp +decide [*, minkHerm, rankOne]
      · simp +decide [Matrix.vecMulVec]
        norm_cast
        rw [Real.mul_self_sqrt (by nlinarith)]
      · simp +decide [Matrix.vecMulVec]
        rw [mul_div_cancel₀ _ hsqrt_ne]
        ring
      · simp +decide [Matrix.vecMulVec]
        rw [div_mul_cancel₀ _ hsqrt_ne]
      · simp +decide [Matrix.vecMulVec, Complex.ext_iff]
        ring_nf
        norm_num [h_case, Real.sq_sqrt (show 0 <= p 0 + p 3 by nlinarith)]
        grind
  · obtain ⟨lam, hlam⟩ := h
    have hp : p = momentumOf lam :=
      minkHerm_injective <| hlam.trans <| minkHerm_momentumOf lam ▸ rfl
    exact ⟨hp ▸ momentumOf_null lam, hp ▸ momentumOf_nonneg lam⟩

/-! ## I1.5-I1.6: finite Pluecker/Cauchy-Binet mass identity -/

/-- The spinor wedge / Pluecker coordinate of two complex two-spinors. -/
def spinorWedge (psi phi : CSpinor) : Complex :=
  psi 0 * phi 1 - psi 1 * phi 0

/-- Complex squared modulus, valued in `Complex` for determinant comparison. -/
def complexAbsSq (z : Complex) : Complex :=
  z * (starRingEnd Complex) z

/-- `complexAbsSq` is the complex coercion of the usual real squared norm. -/
theorem complexAbsSq_eq_ofReal_normSq (z : Complex) :
    complexAbsSq z = (Complex.normSq z : Complex) := by
  simp [complexAbsSq, Complex.normSq_eq_conj_mul_self, mul_comm]

/-- The Hermitian momentum matrix of a two-edge visible bundle. -/
def twoEdgeMomentum (psi phi : CSpinor) : Herm2 :=
  rankOne psi + rankOne phi

/-- Two-edge Pluecker mass identity. -/
theorem two_edge_plucker_mass_identity (psi phi : CSpinor) :
    (twoEdgeMomentum psi phi).det = complexAbsSq (spinorWedge psi phi) := by
  simp [twoEdgeMomentum, rankOne, Matrix.det_fin_two, Matrix.vecMulVec,
    spinorWedge, complexAbsSq]
  ring

/-- The Hermitian momentum matrix of a finite visible null-spinor bundle. -/
def finBundleMomentum {n : Nat} (psi : Fin n -> CSpinor) : Herm2 :=
  ∑ i : Fin n, rankOne (psi i)

/-- Finite sums of rank-one bispinors are positive semidefinite. -/
theorem finBundleMomentum_posSemidef {n : Nat} (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).PosSemidef := by
  unfold finBundleMomentum
  exact Matrix.posSemidef_sum Finset.univ
    (fun i _ => rankOne_posSemidef (psi i))

/-- Ordered representatives of unordered pairs of indices. -/
def finPairIndexSet (n : Nat) : Finset (Fin n × Fin n) :=
  Finset.univ.filter fun p => (p.1 : Nat) < (p.2 : Nat)

/-- The total pairwise squared Pluecker spread of a finite spinor bundle. -/
def finPairwisePluckerMass {n : Nat} (psi : Fin n -> CSpinor) : Complex :=
  ∑ p ∈ finPairIndexSet n,
    complexAbsSq (spinorWedge (psi p.1) (psi p.2))

/-- Real-valued version of the total pairwise squared Pluecker spread. -/
def finPairwisePluckerMassReal {n : Nat} (psi : Fin n -> CSpinor) : Real :=
  ∑ p ∈ finPairIndexSet n,
    Complex.normSq (spinorWedge (psi p.1) (psi p.2))

/-- The complex-valued Pluecker mass is the coercion of the real-valued one. -/
theorem finPairwisePluckerMass_eq_ofReal {n : Nat}
    (psi : Fin n -> CSpinor) :
    finPairwisePluckerMass psi = (finPairwisePluckerMassReal psi : Complex) := by
  unfold finPairwisePluckerMass finPairwisePluckerMassReal
  simp [complexAbsSq_eq_ofReal_normSq]

/-- The real Pluecker mass is nonnegative term by term. -/
theorem finPairwisePluckerMassReal_nonneg {n : Nat}
    (psi : Fin n -> CSpinor) :
    0 <= finPairwisePluckerMassReal psi := by
  unfold finPairwisePluckerMassReal
  exact Finset.sum_nonneg fun p _ => Complex.normSq_nonneg _

/-- Off-diagonal folding helper for finite double sums. -/
theorem sum_pairs_offdiag {n : Nat} (f : Fin n -> Fin n -> Complex)
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
I1.5: finite `2 x n` Pluecker/Cauchy-Binet mass identity.

The determinant of the summed null momenta is the total pairwise squared
Pluecker spread of the spinor bundle.
-/
theorem i1_5_cauchy_binet_mass_identity {n : Nat} (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).det = finPairwisePluckerMass psi := by
  have hentry : ∀ a b : Fin 2, finBundleMomentum psi a b
      = ∑ i, psi i a * (starRingEnd Complex) (psi i b) := by
    intro a b
    simp [finBundleMomentum, rankOne, Matrix.sum_apply, Matrix.vecMulVec]
  set f : Fin n -> Fin n -> Complex := fun i j =>
    (psi i 0 * (starRingEnd Complex) (psi i 0)) * (psi j 1 * (starRingEnd Complex) (psi j 1))
      - (psi i 0 * (starRingEnd Complex) (psi i 1))
        * (psi j 1 * (starRingEnd Complex) (psi j 0)) with hf
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
theorem i1_5_det_eq_ofReal_pluckerMassReal {n : Nat}
    (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).det = (finPairwisePluckerMassReal psi : Complex) := by
  rw [i1_5_cauchy_binet_mass_identity, finPairwisePluckerMass_eq_ofReal]

/-- The determinant mass has nonnegative real part. -/
theorem i1_6_det_re_nonneg {n : Nat} (psi : Fin n -> CSpinor) :
    0 <= ((finBundleMomentum psi).det).re := by
  rw [i1_5_det_eq_ofReal_pluckerMassReal]
  exact finPairwisePluckerMassReal_nonneg psi

/-- The determinant mass has zero imaginary part. -/
theorem i1_6_det_im_eq_zero {n : Nat} (psi : Fin n -> CSpinor) :
    ((finBundleMomentum psi).det).im = 0 := by
  rw [i1_5_det_eq_ofReal_pluckerMassReal]
  simp

/--
I1.6 cross-check in determinant form: the invariant mass is exactly the
nonnegative real pairwise Pluecker sum.
-/
theorem i1_6_kinematic_cross_check {n : Nat} (psi : Fin n -> CSpinor) :
    ∃ r : Real, 0 <= r ∧ (finBundleMomentum psi).det = (r : Complex) := by
  exact ⟨finPairwisePluckerMassReal psi,
    finPairwisePluckerMassReal_nonneg psi,
    i1_5_det_eq_ofReal_pluckerMassReal psi⟩

/-! ## I2: finite modular faithfulness shadow -/

/--
Finite-dimensional faithfulness for a `2 x 2` density/momentum block.

This is the support condition used by finite Tomita theory: a faithful state is
positive definite, while singular positive semidefinite blocks have no finite
inverse-density modular Hamiltonian.  This section records only the finite
matrix-support shadow, not a geometric modular-flow theorem.
-/
def faithful2 (rho : Herm2) : Prop :=
  rho.PosDef

/--
Finite matrix-support predicate for the existence of a finite modular
Hamiltonian.  It is definitionally the same as `faithful2`; the separate name
keeps the I2 statement readable without constructing matrix logarithms here.
-/
def finiteModularHamiltonianAvailable (rho : Herm2) : Prop :=
  faithful2 rho

/-- The I2 support predicate is exactly finite-dimensional faithfulness. -/
theorem finiteModularHamiltonianAvailable_iff (rho : Herm2) :
    finiteModularHamiltonianAvailable rho ↔ faithful2 rho := by
  rfl

/-- A faithful finite `2 x 2` block is an invertible matrix. -/
theorem faithful2_isUnit (rho : Herm2) (h : faithful2 rho) :
    IsUnit rho := by
  exact Matrix.PosDef.isUnit h

/-- A faithful finite `2 x 2` block has nonzero determinant. -/
theorem faithful2_det_ne_zero (rho : Herm2) (h : faithful2 rho) :
    rho.det ≠ 0 := by
  have hunit : IsUnit rho := faithful2_isUnit rho h
  rw [Matrix.isUnit_iff_isUnit_det] at hunit
  exact IsUnit.ne_zero hunit

/--
I2 null-edge shadow: a rank-one spinor momentum is singular, so it is not
faithful as a finite density/momentum block.
-/
theorem i2_rankOne_not_faithful (lam : CSpinor) :
    ¬ faithful2 (rankOne lam) := by
  intro h
  exact faithful2_det_ne_zero (rankOne lam) h (det_rankOne_eq_zero lam)

/-- The momentum block of a single spinor is not faithful. -/
theorem i2_momentumOf_not_faithful (lam : CSpinor) :
    ¬ faithful2 (minkHerm (momentumOf lam)) := by
  rw [minkHerm_momentumOf]
  exact i2_rankOne_not_faithful lam

/--
I2 null/factorization shadow: any weakly future-pointing null block is singular
because it factors as a rank-one spinor block.
-/
theorem i2_null_not_faithful (p : Momentum4)
    (hnull : (p 0) ^ 2 = (p 1) ^ 2 + (p 2) ^ 2 + (p 3) ^ 2)
    (hfuture : 0 <= p 0) :
    ¬ faithful2 (minkHerm p) := by
  rcases (i1_4_rank_one_factorization p).mp ⟨hnull, hfuture⟩ with ⟨lam, hlam⟩
  rw [hlam]
  exact i2_rankOne_not_faithful lam

/--
I2 timelike shadow: a strictly future-timelike soldered block is faithful.

The proof uses the already-proved PSD/future-cone characterization and the
Hermitian determinant-as-product-of-eigenvalues formula: nonnegative
eigenvalues with positive product are all strictly positive.
-/
theorem i2_minkHerm_faithful_of_futureTimelike (p : Momentum4)
    (henergy : 0 < p 0) (hmass : 0 < minkowskiSq p) :
    faithful2 (minkHerm p) := by
  have hfuture : 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2 := by
    constructor
    · exact le_of_lt henergy
    · unfold minkowskiSq at hmass
      unfold spatialNormSq
      linarith
  have hpsd : (minkHerm p).PosSemidef :=
    (i1_2_minkHerm_posSemidef_iff_futureCone p).mpr hfuture
  have hnonneg : 0 <= (minkHerm_isHermitian p).eigenvalues := by
    rwa [← (minkHerm_isHermitian p).posSemidef_iff_eigenvalues_nonneg]
  have hprod_eq :
      (∏ i, (minkHerm_isHermitian p).eigenvalues i) = minkowskiSq p := by
    apply Complex.ofReal_injective
    calc
      (((∏ i, (minkHerm_isHermitian p).eigenvalues i) : Real) : Complex)
          = ∏ i, (((minkHerm_isHermitian p).eigenvalues i : Real) : Complex) := by
            simp
      _ = (minkHerm p).det := by
            exact ((minkHerm_isHermitian p).det_eq_prod_eigenvalues).symm
      _ = (minkowskiSq p : Complex) := det_minkHerm_eq_minkowskiSq p
  have hprod_pos :
      0 < ∏ i, (minkHerm_isHermitian p).eigenvalues i := by
    rw [hprod_eq]
    exact hmass
  unfold faithful2
  rw [(minkHerm_isHermitian p).posDef_iff_eigenvalues_pos]
  intro i
  have hprod_two :
      0 < (minkHerm_isHermitian p).eigenvalues 0
          * (minkHerm_isHermitian p).eigenvalues 1 := by
    simpa [Fin.prod_univ_two] using hprod_pos
  have h0_nonneg : 0 <= (minkHerm_isHermitian p).eigenvalues 0 := hnonneg 0
  have h1_nonneg : 0 <= (minkHerm_isHermitian p).eigenvalues 1 := hnonneg 1
  fin_cases i
  · by_contra hnot
    have hz : (minkHerm_isHermitian p).eigenvalues 0 = 0 :=
      le_antisymm (le_of_not_gt hnot) h0_nonneg
    nlinarith
  · by_contra hnot
    have hz : (minkHerm_isHermitian p).eigenvalues 1 = 0 :=
      le_antisymm (le_of_not_gt hnot) h1_nonneg
    nlinarith

/--
I2 finite faithfulness is exactly strict future-timelikeness for soldered
`2 x 2` blocks.

This packages the one-way theorem above with the converse: a positive definite
Hermitian momentum block is positive semidefinite, hence future-causal, and its
positive determinant is exactly the positive mostly-minus mass square.
-/
theorem i2_minkHerm_faithful_iff_futureTimelike (p : Momentum4) :
    faithful2 (minkHerm p) ↔ 0 < p 0 ∧ 0 < minkowskiSq p := by
  constructor
  · intro hfaith
    have hpsd : (minkHerm p).PosSemidef :=
      Matrix.PosDef.posSemidef hfaith
    have hfuture : 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2 :=
      (i1_2_minkHerm_posSemidef_iff_futureCone p).mp hpsd
    have hdet :
        (0 : Complex) < (((minkowskiSq p : Real)) : Complex) := by
      simpa [det_minkHerm_eq_minkowskiSq] using
        (Matrix.PosDef.det_pos hfaith :
          (0 : Complex) < (minkHerm p).det)
    have hmass : 0 < minkowskiSq p :=
      Complex.zero_lt_real.mp hdet
    have henergy_ne : p 0 ≠ 0 := by
      intro hzero
      have hsp : 0 <= spatialNormSq p := spatialNormSq_nonneg p
      unfold minkowskiSq at hmass
      rw [hzero] at hmass
      nlinarith
    exact ⟨lt_of_le_of_ne hfuture.1 (Ne.symm henergy_ne), hmass⟩
  · intro h
    exact i2_minkHerm_faithful_of_futureTimelike p h.1 h.2

/-! ## I1.8: normalized determinant dictionary -/

/-- The normalized Hermitian block `rho = P / tr(P)` in energy coordinates. -/
def normalizedMinkHerm (p : Momentum4) : Herm2 :=
  ((((1 : Real) / (2 * p 0) : Real) : Complex)) • minkHerm p

/-- Squared spatial velocity / Bloch-vector norm `|p|^2 / E^2`. -/
def velocityNormSq (p : Momentum4) : Real :=
  spatialNormSq p / (p 0) ^ 2

/-- Velocity norm squared is nonnegative with Lean's total division convention. -/
theorem velocityNormSq_nonneg (p : Momentum4) : 0 <= velocityNormSq p := by
  unfold velocityNormSq spatialNormSq
  positivity

/--
Normalized characteristic determinant:
`det(rho - lambda I) = (1/2 - lambda)^2 - |v|^2/4`.

The nonzero-energy hypothesis is the point where the total-division matrix
`normalizedMinkHerm` becomes the intended trace-one normalization.
-/
theorem det_normalizedMinkHerm_sub_smul_one (p : Momentum4) (lambda : Real)
    (hp : p 0 ≠ 0) :
    (normalizedMinkHerm p - ((lambda : Complex) • (1 : Herm2))).det =
      ((((1 / 2 - lambda) ^ 2 - velocityNormSq p / 4 : Real)) : Complex) := by
  unfold normalizedMinkHerm minkHerm velocityNormSq spatialNormSq
  norm_num [Matrix.det_fin_two]
  ring_nf
  rw [Complex.I_sq]
  norm_num
  field_simp [hp]
  ring

/-- The upper normalized algebraic spectral root has zero determinant. -/
theorem normalizedMinkHerm_spectralPlus_det_zero
    (p : Momentum4) (hp : p 0 ≠ 0) :
    (normalizedMinkHerm p -
      ((((1 + Real.sqrt (velocityNormSq p)) / 2 : Real)) : Complex) •
        (1 : Herm2)).det = 0 := by
  rw [det_normalizedMinkHerm_sub_smul_one p
    ((1 + Real.sqrt (velocityNormSq p)) / 2) hp]
  rw [Complex.ofReal_eq_zero]
  nlinarith [Real.sq_sqrt (velocityNormSq_nonneg p)]

/-- The lower normalized algebraic spectral root has zero determinant. -/
theorem normalizedMinkHerm_spectralMinus_det_zero
    (p : Momentum4) (hp : p 0 ≠ 0) :
    (normalizedMinkHerm p -
      ((((1 - Real.sqrt (velocityNormSq p)) / 2 : Real)) : Complex) •
        (1 : Herm2)).det = 0 := by
  rw [det_normalizedMinkHerm_sub_smul_one p
    ((1 - Real.sqrt (velocityNormSq p)) / 2) hp]
  rw [Complex.ofReal_eq_zero]
  nlinarith [Real.sq_sqrt (velocityNormSq_nonneg p)]

/-- The normalized block has trace one when the energy is nonzero. -/
theorem trace_normalizedMinkHerm (p : Momentum4) (hp : p 0 ≠ 0) :
    Matrix.trace (normalizedMinkHerm p) = 1 := by
  unfold normalizedMinkHerm
  rw [Matrix.trace_smul, trace_minkHerm]
  norm_num
  field_simp [hp]

/-- Future-causal momenta normalize to positive semidefinite trace-one blocks. -/
theorem normalizedMinkHerm_posSemidef_of_futureCone (p : Momentum4)
    (hp0 : 0 < p 0)
    (hcone : 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2) :
    (normalizedMinkHerm p).PosSemidef := by
  have hpsd : (minkHerm p).PosSemidef :=
    (i1_2_minkHerm_posSemidef_iff_futureCone p).mpr hcone
  have hscale : 0 <= (1 / (2 * p 0) : Real) := by positivity
  have hscaleC : 0 <= (((1 / (2 * p 0) : Real)) : Complex) := by
    exact_mod_cast hscale
  simpa [normalizedMinkHerm] using
    Matrix.PosSemidef.smul (α := Complex) hpsd hscaleC

/-- Strictly future-timelike momenta normalize to faithful finite blocks. -/
theorem normalizedMinkHerm_faithful_of_futureTimelike (p : Momentum4)
    (hp0 : 0 < p 0) (hmass : 0 < minkowskiSq p) :
    faithful2 (normalizedMinkHerm p) := by
  have hfaith : faithful2 (minkHerm p) :=
    i2_minkHerm_faithful_of_futureTimelike p hp0 hmass
  have hscale : 0 < (1 / (2 * p 0) : Real) := by positivity
  have hscaleC : 0 < (((1 / (2 * p 0) : Real)) : Complex) := by
    exact_mod_cast hscale
  simpa [normalizedMinkHerm, faithful2] using
    Matrix.PosDef.smul (α := Complex) hfaith hscaleC

/--
I1.8 determinant bookkeeping: normalization divides the unnormalized invariant
mass square by `4 E^2`.  The formula is written with Lean's total division; the
trace-one density interpretation uses the nonzero-energy theorem above.
-/
theorem det_normalizedMinkHerm (p : Momentum4) :
    (normalizedMinkHerm p).det =
      (((minkowskiSq p / (4 * (p 0) ^ 2) : Real)) : Complex) := by
  unfold normalizedMinkHerm minkHerm minkowskiSq
  norm_num [Matrix.det_fin_two]
  ring_nf
  rw [Complex.I_sq]
  norm_num

/-- The normalized determinant is `(1 - |v|^2) / 4` for `v = p / E`. -/
theorem det_normalizedMinkHerm_eq_one_sub_velocityNormSq
    (p : Momentum4) (hp : p 0 ≠ 0) :
    (normalizedMinkHerm p).det =
      ((((1 - velocityNormSq p) / 4 : Real)) : Complex) := by
  rw [det_normalizedMinkHerm]
  unfold velocityNormSq spatialNormSq minkowskiSq
  norm_num
  field_simp [hp]
  ring

/-- The normalized block has purity trace `(1 + |v|^2) / 2`. -/
theorem trace_normalizedMinkHerm_sq (p : Momentum4) (hp : p 0 ≠ 0) :
    Matrix.trace (normalizedMinkHerm p * normalizedMinkHerm p) =
      ((((1 + velocityNormSq p) / 2 : Real)) : Complex) := by
  unfold normalizedMinkHerm minkHerm velocityNormSq spatialNormSq
  simp +decide [Matrix.trace, Fin.sum_univ_two]
  ring_nf
  rw [Complex.I_sq]
  norm_num
  field_simp [hp]

/--
Normalized linear entropy / mass-ratio identity:
`2 * (1 - tr(rho^2)) = p^2 / E^2`.
-/
theorem linearEntropy_normalizedMinkHerm (p : Momentum4) (hp : p 0 ≠ 0) :
    (2 : Complex) *
      (1 - Matrix.trace (normalizedMinkHerm p * normalizedMinkHerm p)) =
      (((minkowskiSq p / (p 0) ^ 2 : Real)) : Complex) := by
  rw [trace_normalizedMinkHerm_sq p hp]
  unfold velocityNormSq spatialNormSq minkowskiSq
  norm_num
  field_simp [hp]
  ring

/-! ## I1.9: first-order conjugate block bridge -/

/-- The conjugate Weyl block `p0 I - p . sigma`. -/
def minkHermBar (p : Momentum4) : Herm2 :=
  !![((p 0 - p 3 : Real) : Complex),
     -((p 1 : Real) : Complex) + ((p 2 : Real) : Complex) * I;
     -((p 1 : Real) : Complex) - ((p 2 : Real) : Complex) * I,
     ((p 0 + p 3 : Real) : Complex)]

/--
I1.9: the two Weyl blocks compose to the mostly-minus scalar.

This is the `2 x 2` block form of the chiral Dirac-square identity.
-/
theorem i1_9_minkHerm_mul_bar_eq_minkowskiSq (p : Momentum4) :
    minkHerm p * minkHermBar p = (minkowskiSq p : Complex) • (1 : Herm2) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [minkHerm, minkHermBar, minkowskiSq, Matrix.mul_apply,
      Fin.sum_univ_two] <;>
    ring_nf <;>
    rw [Complex.I_sq] <;>
    ring

/-- The reverse Weyl block composition gives the same scalar. -/
theorem i1_9_bar_mul_minkHerm_eq_minkowskiSq (p : Momentum4) :
    minkHermBar p * minkHerm p = (minkowskiSq p : Complex) • (1 : Herm2) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [minkHerm, minkHermBar, minkowskiSq, Matrix.mul_apply,
      Fin.sum_univ_two] <;>
    ring_nf <;>
    rw [Complex.I_sq] <;>
    ring

/-! ## A1: finite boost-Gibbs algebra -/

/-- A spatial unit-direction predicate in concrete coordinates. -/
def spatialUnit (nx ny nz : Real) : Prop :=
  nx ^ 2 + ny ^ 2 + nz ^ 2 = 1

/-- The Pauli slash `n . sigma` of a real spatial direction. -/
def spatialPauli (nx ny nz : Real) : Herm2 :=
  !![((nz : Real) : Complex), ((nx : Real) : Complex) - ((ny : Real) : Complex) * I;
     ((nx : Real) : Complex) + ((ny : Real) : Complex) * I, ((-nz : Real) : Complex)]

/-- A unit spatial Pauli slash squares to the identity. -/
theorem a1_spatialPauli_sq (nx ny nz : Real) (hunit : spatialUnit nx ny nz) :
    spatialPauli nx ny nz * spatialPauli nx ny nz = (1 : Herm2) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [spatialPauli, spatialUnit, Matrix.mul_apply, Fin.sum_univ_two] at hunit ⊢ <;>
    ring_nf <;>
    rw [Complex.I_sq] <;>
    norm_num
  · have hunitC : (((nx ^ 2 + ny ^ 2 + nz ^ 2 : Real)) : Complex) = 1 := by
      exact_mod_cast hunit
    norm_num at hunitC
    simpa [add_assoc, add_comm, add_left_comm] using hunitC
  · have hunitC : (((nx ^ 2 + ny ^ 2 + nz ^ 2 : Real)) : Complex) = 1 := by
      exact_mod_cast hunit
    norm_num at hunitC
    simpa [add_assoc, add_comm, add_left_comm] using hunitC

/-- The massive boosted four-momentum `m (cosh eta, sinh eta * n)`. -/
def boostMomentum (m eta nx ny nz : Real) : Momentum4 :=
  ![m * Real.cosh eta,
    m * Real.sinh eta * nx,
    m * Real.sinh eta * ny,
    m * Real.sinh eta * nz]

/--
A1 finite boost form: the soldered boosted momentum is
`m (cosh eta I + sinh eta n.sigma)`.
-/
theorem a1_boost_minkHerm_form (m eta nx ny nz : Real) :
    minkHerm (boostMomentum m eta nx ny nz) =
      ((m : Real) : Complex) •
        (((Real.cosh eta : Real) : Complex) • (1 : Herm2)
          + (((Real.sinh eta : Real) : Complex) • spatialPauli nx ny nz)) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [minkHerm, boostMomentum, spatialPauli] <;> ring

/-- A unit-direction boost has mostly-minus mass square `m^2`. -/
theorem a1_boost_minkowskiSq (m eta nx ny nz : Real)
    (hunit : spatialUnit nx ny nz) :
    minkowskiSq (boostMomentum m eta nx ny nz) = m ^ 2 := by
  unfold spatialUnit at hunit
  unfold minkowskiSq boostMomentum
  simp +decide
  calc
    (m * Real.cosh eta) ^ 2
        - (m * Real.sinh eta * nx) ^ 2
        - (m * Real.sinh eta * ny) ^ 2
        - (m * Real.sinh eta * nz) ^ 2
        =
          m ^ 2 * (Real.cosh eta ^ 2
            - Real.sinh eta ^ 2 * (nx ^ 2 + ny ^ 2 + nz ^ 2)) := by ring
    _ = m ^ 2 * (Real.cosh eta ^ 2 - Real.sinh eta ^ 2) := by rw [hunit]; ring
    _ = m ^ 2 := by rw [Real.cosh_sq_sub_sinh_sq eta]; ring

/--
A1 detailed-balance scalar identity: the ratio of boosted Pauli eigenvalue
weights is `exp(2 eta)`.
-/
theorem a1_boost_eigenvalue_ratio (eta : Real) :
    (Real.cosh eta + Real.sinh eta) / (Real.cosh eta - Real.sinh eta) =
      Real.exp (2 * eta) := by
  rw [Real.cosh_add_sinh, Real.cosh_sub_sinh]
  field_simp [Real.exp_ne_zero (-eta)]
  rw [← Real.exp_add]
  congr 1
  ring

/-- Positive-mass boosts are faithful finite momentum blocks. -/
theorem a1_boost_faithful (m eta nx ny nz : Real)
    (hm : 0 < m) (hunit : spatialUnit nx ny nz) :
    faithful2 (minkHerm (boostMomentum m eta nx ny nz)) := by
  rw [i2_minkHerm_faithful_iff_futureTimelike]
  constructor
  · unfold boostMomentum
    simp +decide
    positivity
  · rw [a1_boost_minkowskiSq m eta nx ny nz hunit]
    positivity

/-! ## A2: determinant superadditivity algebra -/

/-- Spatial Euclidean dot product of two four-momenta. -/
def spatialDot (p q : Momentum4) : Real :=
  p 1 * q 1 + p 2 * q 2 + p 3 * q 3

/-- Mostly-minus Minkowski bilinear form. -/
def minkowskiInner (p q : Momentum4) : Real :=
  p 0 * q 0 - spatialDot p q

/-- The soldering map is additive on four-momenta. -/
theorem minkHerm_add (p q : Momentum4) :
    minkHerm (p + q) = minkHerm p + minkHerm q := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp +decide [minkHerm] <;> ring

/-- Three-dimensional Cauchy-Schwarz in the concrete spatial coordinates. -/
theorem spatialDot_sq_le (p q : Momentum4) :
    (spatialDot p q) ^ 2 <= spatialNormSq p * spatialNormSq q := by
  unfold spatialDot spatialNormSq
  nlinarith
    [sq_nonneg (p 1 * q 2 - p 2 * q 1),
     sq_nonneg (p 1 * q 3 - p 3 * q 1),
     sq_nonneg (p 2 * q 3 - p 3 * q 2)]

/-- Quadratic expansion of the mostly-minus norm. -/
theorem minkowskiSq_add (p q : Momentum4) :
    minkowskiSq (p + q) =
      minkowskiSq p + minkowskiSq q + 2 * minkowskiInner p q := by
  unfold minkowskiSq minkowskiInner spatialDot
  simp only [Pi.add_apply]
  ring

/-- Determinant expansion for the sum of two soldered momentum blocks. -/
theorem a2_det_minkHerm_add (p q : Momentum4) :
    (minkHerm p + minkHerm q).det =
      (((minkowskiSq p + minkowskiSq q + 2 * minkowskiInner p q : Real)) :
        Complex) := by
  rw [← minkHerm_add, det_minkHerm_eq_minkowskiSq, minkowskiSq_add]

/-- Future-causal four-momenta have nonnegative mostly-minus inner product. -/
theorem minkowskiInner_nonneg_of_futureCone (p q : Momentum4)
    (hp : 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2)
    (hq : 0 <= q 0 ∧ spatialNormSq q <= (q 0) ^ 2) :
    0 <= minkowskiInner p q := by
  have hsp_p : 0 <= spatialNormSq p := spatialNormSq_nonneg p
  have hsp_q : 0 <= spatialNormSq q := spatialNormSq_nonneg q
  have hpq_nonneg : 0 <= p 0 * q 0 := mul_nonneg hp.1 hq.1
  have hsq :
      (spatialDot p q) ^ 2 <= (p 0 * q 0) ^ 2 := by
    have h1 := spatialDot_sq_le p q
    have hmul : spatialNormSq p * spatialNormSq q <= (p 0) ^ 2 * (q 0) ^ 2 := by
      nlinarith [mul_nonneg hsp_p hsp_q, mul_nonneg (sq_nonneg (p 0)) (sq_nonneg (q 0))]
    nlinarith
  have habs : |spatialDot p q| <= |p 0 * q 0| := (sq_le_sq.mp hsq)
  have hdot_le : spatialDot p q <= p 0 * q 0 := by
    have hdot_abs : spatialDot p q <= |spatialDot p q| := le_abs_self _
    have hpq_abs : |p 0 * q 0| = p 0 * q 0 := abs_of_nonneg hpq_nonneg
    linarith
  unfold minkowskiInner
  linarith

/--
Real reverse-Cauchy auxiliary used for the future-cone determinant inequality.

Here `a,b` are nonnegative time components, `X,Y` are nonnegative squared
spatial norms bounded by `a^2,b^2`, and `Z` is a spatial dot product bounded by
ordinary Cauchy-Schwarz.  The conclusion is the squared Lorentzian reverse
Cauchy inequality.
-/
theorem lorentzReverseCauchy_aux (a b X Y Z : Real)
    (ha : 0 <= a) (hb : 0 <= b)
    (hX : 0 <= X) (hY : 0 <= Y)
    (hXle : X <= a ^ 2) (hYle : Y <= b ^ 2)
    (hZ : Z ^ 2 <= X * Y) :
    (a ^ 2 - X) * (b ^ 2 - Y) <= (a * b - Z) ^ 2 := by
  let sx := Real.sqrt X
  let sy := Real.sqrt Y
  let s := sx * sy
  have hsx : sx ^ 2 = X := by simpa [sx] using Real.sq_sqrt hX
  have hsy : sy ^ 2 = Y := by simpa [sy] using Real.sq_sqrt hY
  have hs_nonneg : 0 <= s := by positivity
  have hs_sq : s ^ 2 = X * Y := by
    unfold s
    nlinarith
  have hZ_le_s : Z <= s := by
    have hsq : Z ^ 2 <= s ^ 2 := by rwa [hs_sq]
    have habs := sq_le_sq.mp hsq
    have hz_le_abs : Z <= |Z| := le_abs_self Z
    have hsabs : |s| = s := abs_of_nonneg hs_nonneg
    linarith
  have hs_le_ab : s <= a * b := by
    have hsx_nonneg : 0 <= sx := by positivity
    have hsy_nonneg : 0 <= sy := by positivity
    have hsx_le_a : sx <= a := by
      rw [Real.sqrt_le_iff]
      exact ⟨ha, hXle⟩
    have hsy_le_b : sy <= b := by
      rw [Real.sqrt_le_iff]
      exact ⟨hb, hYle⟩
    exact mul_le_mul hsx_le_a hsy_le_b hsy_nonneg ha
  have hfactor_nonneg : 0 <= (s - Z) * (2 * a * b - s - Z) := by
    have h1 : 0 <= s - Z := by linarith
    have h2 : 0 <= 2 * a * b - s - Z := by nlinarith
    exact mul_nonneg h1 h2
  have hsquare_nonneg : 0 <= (a * sy - b * sx) ^ 2 := sq_nonneg _
  have hdecomp :
      (a * b - Z) ^ 2 - (a ^ 2 - X) * (b ^ 2 - Y) =
        (a * sy - b * sx) ^ 2 + (s - Z) * (2 * a * b - s - Z) := by
    unfold s
    nlinarith
  nlinarith

/-- Future-causal momenta have nonnegative mostly-minus mass square. -/
theorem minkowskiSq_nonneg_of_futureCone (p : Momentum4)
    (hp : 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2) :
    0 <= minkowskiSq p := by
  unfold minkowskiSq spatialNormSq at *
  nlinarith

/-- Lorentzian reverse Cauchy inequality on the future cone, squared form. -/
theorem minkowskiInner_sq_ge_mul_minkowskiSq_of_futureCone (p q : Momentum4)
    (hp : 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2)
    (hq : 0 <= q 0 ∧ spatialNormSq q <= (q 0) ^ 2) :
    minkowskiSq p * minkowskiSq q <= (minkowskiInner p q) ^ 2 := by
  have h := lorentzReverseCauchy_aux (p 0) (q 0)
    (spatialNormSq p) (spatialNormSq q) (spatialDot p q)
    hp.1 hq.1 (spatialNormSq_nonneg p) (spatialNormSq_nonneg q)
    hp.2 hq.2 (spatialDot_sq_le p q)
  have hpEq : (p 0) ^ 2 - spatialNormSq p = minkowskiSq p := by
    unfold spatialNormSq minkowskiSq
    ring
  have hqEq : (q 0) ^ 2 - spatialNormSq q = minkowskiSq q := by
    unfold spatialNormSq minkowskiSq
    ring
  have hiEq : p 0 * q 0 - spatialDot p q = minkowskiInner p q := by rfl
  rw [← hpEq, ← hqEq, ← hiEq]
  exact h

/-- Lorentzian reverse Cauchy inequality on the future cone, square-root form. -/
theorem sqrt_minkowskiSq_mul_le_minkowskiInner_of_futureCone (p q : Momentum4)
    (hp : 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2)
    (hq : 0 <= q 0 ∧ spatialNormSq q <= (q 0) ^ 2) :
    Real.sqrt (minkowskiSq p * minkowskiSq q) <= minkowskiInner p q := by
  have hinner_nonneg : 0 <= minkowskiInner p q :=
    minkowskiInner_nonneg_of_futureCone p q hp hq
  rw [Real.sqrt_le_iff]
  exact ⟨hinner_nonneg,
    minkowskiInner_sq_ge_mul_minkowskiSq_of_futureCone p q hp hq⟩

/--
A2 quadratic superadditivity shadow: on the future cone, the invariant
mass-square of a sum dominates the sum of invariant mass-squares.

This is the determinant-expansion and nonnegative-cross-term spine behind the
full square-root Minkowski determinant inequality; equality cases and the
square-root mass statement are not asserted here.
-/
theorem a2_minkowskiSq_add_ge_of_futureCone (p q : Momentum4)
    (hp : 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2)
    (hq : 0 <= q 0 ∧ spatialNormSq q <= (q 0) ^ 2) :
    minkowskiSq p + minkowskiSq q <= minkowskiSq (p + q) := by
  rw [minkowskiSq_add]
  have hinner : 0 <= minkowskiInner p q :=
    minkowskiInner_nonneg_of_futureCone p q hp hq
  nlinarith

/--
A2 square-root mass superadditivity: on the future cone, the square root of the
invariant mass square is superadditive under momentum addition.

This is the finite Lorentzian/Minkowski determinant inequality specialized to
the concrete soldered `2 x 2` momentum cone.  Equality cases are not asserted
here.
-/
theorem a2_sqrt_minkowskiSq_add_ge_of_futureCone (p q : Momentum4)
    (hp : 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2)
    (hq : 0 <= q 0 ∧ spatialNormSq q <= (q 0) ^ 2) :
    Real.sqrt (minkowskiSq p) + Real.sqrt (minkowskiSq q) <=
      Real.sqrt (minkowskiSq (p + q)) := by
  have hp2 : 0 <= minkowskiSq p := minkowskiSq_nonneg_of_futureCone p hp
  have hq2 : 0 <= minkowskiSq q := minkowskiSq_nonneg_of_futureCone q hq
  have hroot : Real.sqrt (minkowskiSq p) * Real.sqrt (minkowskiSq q) <=
      minkowskiInner p q := by
    rw [← Real.sqrt_mul hp2]
    exact sqrt_minkowskiSq_mul_le_minkowskiInner_of_futureCone p q hp hq
  have hsq :
      (Real.sqrt (minkowskiSq p) + Real.sqrt (minkowskiSq q)) ^ 2 <=
        minkowskiSq (p + q) := by
    rw [minkowskiSq_add]
    nlinarith [Real.sq_sqrt hp2, Real.sq_sqrt hq2]
  exact Real.le_sqrt_of_sq_le hsq

/-! ## I3.5: determinant-line clock algebra -/

/-- The projectivized Hermitian block `L L^dagger` attached to a determinant-line spinor block. -/
def detLineProjector (L : Herm2) : Herm2 :=
  L * Matrix.conjTranspose L

/--
I3.5 algebraic clock core: multiplying a determinant-line block by a unit
complex phase leaves the associated Hermitian projector unchanged.
-/
theorem i3_5_phase_projector_invariant (c : Complex) (L : Herm2)
    (hc : c * star c = 1) :
    detLineProjector (c • L) = detLineProjector L := by
  unfold detLineProjector
  rw [Matrix.conjTranspose_smul]
  rw [Matrix.smul_mul, Matrix.mul_smul]
  rw [smul_smul]
  rw [hc]
  simp

/--
I3.5 determinant-line phase law: scalar phase multiplication squares on the
`2 x 2` determinant line.
-/
theorem i3_5_phase_det (c : Complex) (L : Herm2) :
    (c • L).det = c ^ 2 * L.det := by
  simp

/-- The determinant-line free clock phase `exp(-i m tau)`. -/
def detLineClockPhase (m tau : Real) : Complex :=
  Complex.exp ((-(m * tau) : Real) * Complex.I)

/-- The free clock phase has unit complex norm. -/
theorem detLineClockPhase_unit (m tau : Real) :
    detLineClockPhase m tau * star (detLineClockPhase m tau) = 1 := by
  unfold detLineClockPhase
  change Complex.exp ((-(m * tau) : Real) * Complex.I)
      * (starRingEnd Complex) (Complex.exp ((-(m * tau) : Real) * Complex.I)) = 1
  have hnorm : ‖Complex.exp ((-(m * tau) : Real) * Complex.I)‖ = 1 := by
    simpa using Complex.norm_exp_ofReal_mul_I (-(m * tau))
  rw [Complex.mul_conj]
  rw [Complex.normSq_eq_norm_sq]
  rw [hnorm]
  norm_num

/-- Squaring the free clock phase doubles the angular frequency. -/
theorem detLineClockPhase_sq (m tau : Real) :
    (detLineClockPhase m tau) ^ 2 =
      Complex.exp ((-(2 * (m * tau)) : Real) * Complex.I) := by
  unfold detLineClockPhase
  rw [sq, ← Complex.exp_add]
  congr 1
  norm_num
  ring

/-- Specialization of the I3.5 projector invariance to `exp(-i m tau)`. -/
theorem i3_5_clock_projector_invariant (m tau : Real) (L : Herm2) :
    detLineProjector (detLineClockPhase m tau • L) = detLineProjector L := by
  exact i3_5_phase_projector_invariant (detLineClockPhase m tau) L
    (detLineClockPhase_unit m tau)

/-- Specialization of the I3.5 determinant law to `exp(-i m tau)`. -/
theorem i3_5_clock_det (m tau : Real) (L : Herm2) :
    (detLineClockPhase m tau • L).det =
      Complex.exp ((-(2 * (m * tau)) : Real) * Complex.I) * L.det := by
  rw [i3_5_phase_det, detLineClockPhase_sq]

/-! ## U(2): spin-clock determinant-line split algebra -/

/-- Concrete `U(2)` predicate for the minimal split fiber. -/
def unitary2 (U : Herm2) : Prop :=
  U ∈ Matrix.unitaryGroup (Fin 2) Complex

/-- Concrete `SU(2)` predicate: unitary `2 x 2` matrices with determinant one. -/
def specialUnitary2 (S : Herm2) : Prop :=
  S ∈ Matrix.specialUnitaryGroup (Fin 2) Complex

/-- Concrete `U(1)` phase predicate. -/
def phaseUnit (z : Complex) : Prop :=
  z ∈ unitary Complex

/-- A unit complex phase is nonzero. -/
theorem phaseUnit_ne_zero (z : Complex) (hz : phaseUnit z) : z ≠ 0 := by
  intro hz0
  have hbad : (0 : Complex) = 1 := by
    simpa [phaseUnit, hz0] using hz.2
  exact zero_ne_one hbad

/-- The inverse of a unit complex phase is a unit complex phase. -/
theorem phaseUnit_inv (z : Complex) (hz : phaseUnit z) : phaseUnit z⁻¹ := by
  unfold phaseUnit at hz ⊢
  constructor
  · rw [star_inv₀]
    calc
      (star z)⁻¹ * z⁻¹ = (z * star z)⁻¹ := by rw [_root_.mul_inv_rev]
      _ = 1 := by rw [hz.2]; simp
  · rw [star_inv₀]
    calc
      z⁻¹ * (star z)⁻¹ = (star z * z)⁻¹ := by rw [_root_.mul_inv_rev]
      _ = 1 := by rw [hz.1]; simp

/-- Scalar multiplication by a unit phase preserves concrete `U(2)`. -/
theorem phase_smul_unitary2 (z : Complex) (U : Herm2)
    (hz : phaseUnit z) (hU : unitary2 U) :
    unitary2 (z • U) := by
  unfold unitary2
  rw [Matrix.mem_unitaryGroup_iff]
  have hUmul : U * star U = 1 := (Matrix.mem_unitaryGroup_iff.mp hU)
  rw [star_smul]
  rw [Matrix.smul_mul, Matrix.mul_smul]
  rw [hUmul]
  rw [smul_smul]
  rw [hz.2]
  simp

/-- Determinant of the spin-clock product `z * S`, with `S in SU(2)`. -/
theorem phase_smul_specialUnitary2_det (z : Complex) (S : Herm2)
    (hS : specialUnitary2 S) :
    (z • S).det = z ^ 2 := by
  unfold specialUnitary2 at hS
  have hdet : S.det = 1 := (Matrix.mem_specialUnitaryGroup_iff.mp hS).2
  rw [Matrix.det_smul]
  simp [hdet]

/-- The spin-clock product of a phase and an `SU(2)` matrix lies in `U(2)`. -/
theorem phase_smul_specialUnitary2_unitary (z : Complex) (S : Herm2)
    (hz : phaseUnit z) (hS : specialUnitary2 S) :
    unitary2 (z • S) := by
  have hU : unitary2 S := (Matrix.mem_specialUnitaryGroup_iff.mp hS).1
  exact phase_smul_unitary2 z S hz hU

/--
Conditional finite `U(2) = spin x clock` split.

If a phase `z` has square equal to the determinant of a unitary `2 x 2`
matrix `U`, then `z^{-1} U` is special unitary and `U` is recovered as the
phase times that special-unitary part.  This is the concrete determinant-line
algebra behind the quotient slogan; it does not assert a chosen global square
root or a group quotient isomorphism.
-/
theorem u2_phase_su_decomposition (U : Herm2) (z : Complex)
    (hU : unitary2 U) (hz : phaseUnit z) (hzdet : z ^ 2 = U.det) :
    specialUnitary2 (z⁻¹ • U) ∧ z • (z⁻¹ • U) = U := by
  have hz_ne : z ≠ 0 := phaseUnit_ne_zero z hz
  constructor
  · unfold specialUnitary2
    rw [Matrix.mem_specialUnitaryGroup_iff]
    constructor
    · exact phase_smul_unitary2 z⁻¹ U (phaseUnit_inv z hz) hU
    · calc
        (z⁻¹ • U).det = z⁻¹ ^ 2 * U.det := by
          rw [Matrix.det_smul]
          simp
        _ = z⁻¹ ^ 2 * z ^ 2 := by rw [← hzdet]
        _ = 1 := by field_simp [hz_ne]
  · rw [smul_smul, mul_inv_cancel₀ hz_ne]
    simp

/-- Kernel projection: a phase-spin product equal to identity has phase square one. -/
theorem spinClock_kernel_square_one (z : Complex) (S : Herm2)
    (hS : specialUnitary2 S) (hprod : z • S = 1) :
    z ^ 2 = 1 := by
  have hdet := phase_smul_specialUnitary2_det z S hS
  rw [hprod, Matrix.det_one] at hdet
  exact hdet.symm

/-- Kernel projection: if `z * S = I`, then the spin part is the inverse scalar identity. -/
theorem spinClock_kernel_suPart (z : Complex) (S : Herm2)
    (hz : phaseUnit z) (hprod : z • S = 1) :
    S = z⁻¹ • (1 : Herm2) := by
  have hz_ne : z ≠ 0 := phaseUnit_ne_zero z hz
  calc
    S = (1 : Complex) • S := by simp
    _ = (z⁻¹ * z) • S := by rw [inv_mul_cancel₀ hz_ne]
    _ = z⁻¹ • (z • S) := by rw [smul_smul]
    _ = z⁻¹ • (1 : Herm2) := by rw [hprod]

/-- The two scalar phases with square one are exactly `+1` and `-1`. -/
theorem complex_sq_eq_one_iff (z : Complex) :
    z ^ 2 = 1 ↔ z = 1 ∨ z = -1 := by
  constructor
  · intro h
    have hmul : (z - 1) * (z + 1) = 0 := by
      calc
        (z - 1) * (z + 1) = z ^ 2 - 1 := by ring
        _ = 0 := by rw [h]; ring
    rcases mul_eq_zero.mp hmul with hleft | hright
    · left
      exact sub_eq_zero.mp hleft
    · right
      exact eq_neg_of_add_eq_zero_left hright
  · intro h
    rcases h with h | h <;> simp [h]

end GateI1KinematicCore

end
