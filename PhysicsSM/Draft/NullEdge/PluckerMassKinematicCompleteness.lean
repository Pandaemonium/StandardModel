import PhysicsSM.Spinor.PluckerMass
import PhysicsSM.Draft.NullEdge.NullEdgeSpinorSolderingAristotle

/-!
# Kinematic completeness of the null-edge mass representation

Goal of this lane: license the statement *"every mass, defined as the Poincare invariant
`m = sqrt(P . P)`, is the Pluecker wedge-area of a null-edge decomposition of the
four-momentum."* That is a completeness-of-REPRESENTATION claim (mass = the Casimir,
re-expressed in null-edge data), NOT a derivation of the dynamical mechanisms that fix a
four-momentum's value. Keep the two apart: the Yukawa moduli no-go (`PlueckerYukawaModuli`)
shows the dynamical values are *not* determined by this data.

The claim decomposes into pieces. This module proves the complete finite
representation theorem.

## Proved here

* `posSemidef_iff_finBundle` - **matrix-level coverage.** A `2x2` complex matrix is a
  null-edge bundle momentum `sum_i psi_i psi_i^dagger` **iff** it is positive semidefinite.
  This is the exact content of Mathlib's `posSemidef_iff_eq_sum_vecMulVec` in the
  project's `rankOneHermitian` / `finBundleMomentum` conventions.
* `mass_surjective` - **the mass map is onto `[0, infinity)`.** For every `m >= 0` there is
  a two-edge configuration whose determinant mass is `m^2`, via the explicit witness
  `psi = (1,0)`, `phi = (0, m)`. Combined with the trusted
  `two_edge_plucker_mass_identity`, every nonnegative mass value is realized.
* `hermOfVec`, `vecOfHerm_hermOfVec`, `det_hermOfVec`, `hermOfVec_isHermitian` - **the Pauli
  correspondence.** The explicit inverse of the soldering map `vecOfHerm`: for a four-vector
  `p`, `hermOfVec p` is the Hermitian matrix whose soldered vector is `p` again
  (`vecOfVec_hermOfVec`) and whose determinant is exactly the Minkowski square
  (`det_hermOfVec`). This is the bridge between four-momenta and Hermitian matrices.
* `forwardCone_posSemidef` - **unconditional cone positivity.** A future-pointing,
  non-spacelike four-vector has a positive-semidefinite Pauli representative.
* `forwardCone_complete_nullEdge_representation` - **headline completeness.** Every
  forward-cone four-vector is the soldered vector of a finite null-edge bundle, and its
  Minkowski square is exactly the bundle's total pairwise Pluecker mass.
* `forwardCone_complete_futureNullEdge_representation` - the same theorem with
  each constituent's nullness and future-pointing time component stated explicitly.

Provenance: `posSemidef_iff_eq_sum_vecMulVec` is Mathlib; `two_edge_plucker_mass_identity`
and `fin_bundle_plucker_mass_identity` are the trusted `PhysicsSM.Spinor.PluckerMass`;
`vecOfHerm` / `minkowskiSq` are the landed soldering module. Clean-room. Claim grade `M`;
`[comp]` for the mathematics, `[orig]` for the completeness framing. The two-by-two
positive-semidefinite criterion and forward-cone proof were produced in Aristotle project
`fab399da-0f62-4c01-ac3d-61c94365a01a` and independently checked under the pinned local
toolchain before integration.
-/

noncomputable section

open Matrix Complex
open scoped ComplexOrder
open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.NullEdgeSpinorSoldering (vecOfHerm minkowskiSq Vec4)

namespace PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness

/-! ## Matrix-level coverage: PSD is exactly the null-edge bundle momenta -/

/-- **Matrix-level coverage.** A `2x2` complex matrix is positive semidefinite iff it is a
finite sum of rank-one null momenta `sum_i psi_i psi_i^dagger`, i.e. a null-edge bundle
momentum. This is Mathlib's outer-product characterization of positive semidefiniteness in
the project's conventions. -/
theorem posSemidef_iff_finBundle (M : Matrix (Fin 2) (Fin 2) ℂ) :
    M.PosSemidef ↔ ∃ (n : ℕ) (psi : Fin n → CSpinor), M = finBundleMomentum psi := by
  rw [Matrix.posSemidef_iff_eq_sum_vecMulVec]
  simp only [finBundleMomentum, rankOneHermitian]

/-! ## The mass map is surjective onto `[0, infinity)` -/

/-- **Mass surjectivity.** Every nonnegative real is realized as a two-edge determinant
mass: for `m >= 0`, the configuration `psi = (1,0)`, `phi = (0,m)` has
`det (psi psi^dagger + phi phi^dagger) = m^2`. Since the determinant mass is nonnegative,
the mass `sqrt(det)` ranges over all of `[0, infinity)`. -/
theorem mass_surjective (m : ℝ) :
    (twoEdgeMomentum (![1, 0] : CSpinor) (![0, (m : ℂ)] : CSpinor)).det = ((m ^ 2 : ℝ) : ℂ) := by
  have hwedge : spinorWedge (![1, 0] : CSpinor) (![0, (m : ℂ)] : CSpinor) = (m : ℂ) := by
    simp [spinorWedge]
  rw [two_edge_plucker_mass_identity, hwedge, complexAbsSq_eq_ofReal_normSq,
    Complex.normSq_ofReal]
  push_cast
  ring

/-! ## The Pauli correspondence: four-vectors and Hermitian matrices -/

/-- The explicit inverse of the soldering map `vecOfHerm`. For a four-vector `p` (signature
`(+,-,-,-)`), `hermOfVec p` is the Hermitian matrix `[[p0+p3, p1 - i p2], [p1 + i p2,
p0 - p3]]` whose soldered four-vector is `p` and whose determinant is the Minkowski
square. -/
def hermOfVec (p : Vec4) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![((p 0 + p 3 : ℝ) : ℂ), ((p 1 : ℝ) : ℂ) - ((p 2 : ℝ) : ℂ) * I;
     ((p 1 : ℝ) : ℂ) + ((p 2 : ℝ) : ℂ) * I, ((p 0 - p 3 : ℝ) : ℂ)]

/-- **Round-trip.** The soldered vector of `hermOfVec p` is `p` itself, so `hermOfVec` is a
genuine section of `vecOfHerm`: every four-vector is the soldered image of a Hermitian
matrix. -/
theorem vecOfHerm_hermOfVec (p : Vec4) : vecOfHerm (hermOfVec p) = p := by
  ext i
  fin_cases i <;>
    simp [vecOfHerm, hermOfVec, Complex.add_re, Complex.sub_re, Complex.mul_re,
      Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im] <;>
    ring_nf

/-- **Determinant is the Minkowski square.** `det (hermOfVec p) = p0^2 - p1^2 - p2^2 - p3^2`.
So the Hermitian representative of a four-vector carries its invariant mass squared as a
determinant - the matrix face of `m^2 = P . P`. -/
theorem det_hermOfVec (p : Vec4) : (hermOfVec p).det = ((minkowskiSq p : ℝ) : ℂ) := by
  simp only [hermOfVec, Matrix.det_fin_two_of, minkowskiSq, pow_two]
  apply Complex.ext <;>
    simp [Complex.add_re, Complex.add_im, Complex.sub_re, Complex.sub_im, Complex.mul_re,
      Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im] <;>
    ring

/-- `hermOfVec p` is Hermitian: the off-diagonal entries are complex conjugates and the
diagonal is real. -/
theorem hermOfVec_isHermitian (p : Vec4) : (hermOfVec p).IsHermitian := by
  show (hermOfVec p)ᴴ = hermOfVec p
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [hermOfVec, Matrix.conjTranspose_apply, Complex.ext_iff, Complex.add_re,
      Complex.add_im, Complex.sub_re, Complex.sub_im, Complex.mul_re, Complex.mul_im,
      Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im, Complex.conj_re,
      Complex.conj_im, Complex.star_def]

/-! ## Forward-cone positivity -/

/-- A future-pointing, non-spacelike four-vector in the `(+,-,-,-)`
convention. -/
def ForwardCone (p : Vec4) : Prop :=
  0 <= p 0 /\ 0 <= minkowskiSq p

/-- A concrete two-by-two Hermitian positive-semidefiniteness criterion. -/
lemma posSemidef_fin_two_of_normSq_le_mul
    (a d : Real) (z : Complex) (ha : 0 <= a) (hd : 0 <= d)
    (hz : normSq z <= a * d) :
    (!![(a : Complex), z; star z, (d : Complex)] :
      Matrix (Fin 2) (Fin 2) Complex).PosSemidef := by
  have hi :
      (Matrix.of ![![a, z], ![star z, d]] :
        Matrix (Fin 2) (Fin 2) Complex).IsHermitian := by
    ext i j
    fin_cases i <;> fin_cases j <;> simp
  unfold Matrix.PosSemidef
  refine ⟨hi, ?_⟩
  intro x
  simp only [Finsupp.sum]
  have h1 : forall i : Fin 2,
      ∑ x_2 ∈ x.support,
          star (x i) * !![↑a, z; star z, ↑d] i x_2 * x x_2 =
        ∑ j : Fin 2, star (x i) * !![↑a, z; star z, ↑d] i j * x j := by
    intro i
    refine Finset.sum_subset (Finset.subset_univ _) ?_
    intro j hj hnj
    simp [Finsupp.mem_support_iff] at hnj
    simp [hnj]
  rw [Finset.sum_congr rfl fun i hi => h1 i]
  rw [Finset.sum_subset (h := Finset.subset_univ x.support)
    (f := fun i => ∑ j : Fin 2,
      star (x i) * !![↑a, z; star z, ↑d] i j * x j) (hf := ?_)]
  · simp_rw [Fin.sum_univ_two]
    simp [Matrix.cons_val_zero, Matrix.cons_val_one]
    set x0 := x 0 with hx0
    set x1 := x 1 with hx1
    have eq1 : star x0 * (a : Complex) * x0 = a * Complex.normSq x0 := by
      simp [Complex.normSq, Complex.ext_iff]
      constructor <;> ring
    have eq2 : star x1 * (d : Complex) * x1 = d * Complex.normSq x1 := by
      simp [Complex.normSq, Complex.ext_iff]
      constructor <;> ring
    have cross_eq :
        star x0 * z * x1 + star x1 * star z * x0 =
          2 * (star x0 * z * x1).re := by
      simp [Complex.ext_iff]
      constructor <;> ring
    simp only [starRingEnd_apply] at eq1 eq2 cross_eq ⊢
    rw [eq1, eq2]
    have goal_eq :
        ↑a * ↑(normSq x0) + star x0 * z * x1 +
            (star x1 * star z * x0 + ↑d * ↑(normSq x1)) =
          ↑a * ↑(normSq x0) + ↑d * ↑(normSq x1) +
            2 * ((star x0 * z * x1).re : Complex) := by
      linear_combination cross_eq
    rw [goal_eq]
    set u := Real.sqrt (normSq x0) with hu_def
    set v := Real.sqrt (normSq x1) with hv_def
    have hu_sq : u ^ 2 = normSq x0 :=
      Real.sq_sqrt (Complex.normSq_nonneg x0)
    have hv_sq : v ^ 2 = normSq x1 :=
      Real.sq_sqrt (Complex.normSq_nonneg x1)
    have hz_sqrt_sq : Real.sqrt (normSq z) ^ 2 = normSq z :=
      Real.sq_sqrt (Complex.normSq_nonneg z)
    have hprod :
        normSq (star x0 * z * x1) =
          normSq x0 * normSq z * normSq x1 := by
      simp [Complex.normSq_mul, Complex.normSq_conj]
    have hre_bound :
        (star x0 * z * x1).re >=
          -Real.sqrt (normSq (star x0 * z * x1)) := by
      have hre_sq_le :
          ((star x0 * z * x1).re) ^ 2 <=
            normSq (star x0 * z * x1) := by
        simp only [Complex.normSq_apply]
        nlinarith [sq_nonneg ((star x0 * z * x1).im)]
      have habs_re_le :
          |((star x0 * z * x1).re)| <=
            Real.sqrt (normSq (star x0 * z * x1)) := by
        rw [← Real.sqrt_sq_eq_abs]
        exact Real.sqrt_le_sqrt hre_sq_le
      linarith [neg_abs_le ((star x0 * z * x1).re)]
    have hsqrt_prod :
        Real.sqrt (normSq (star x0 * z * x1)) =
          u * Real.sqrt (normSq z) * v := by
      rw [hprod]
      have hnonneg : 0 <= normSq x0 * normSq z :=
        mul_nonneg (Complex.normSq_nonneg x0) (Complex.normSq_nonneg z)
      rw [Real.sqrt_mul hnonneg,
        Real.sqrt_mul (Complex.normSq_nonneg x0), hu_def, hv_def]
    have hre_lower :
        (star x0 * z * x1).re >=
          -(u * Real.sqrt (normSq z) * v) := by
      rw [hsqrt_prod] at hre_bound
      exact hre_bound
    suffices hsuff :
        (a : Real) * u ^ 2 + (d : Real) * v ^ 2 -
            2 * u * Real.sqrt (normSq z) * v >= 0 by
      have hbound :
          (a : Real) * normSq x0 + (d : Real) * normSq x1 +
              2 * (star x0 * z * x1).re >=
            a * u ^ 2 + d * v ^ 2 -
              2 * u * Real.sqrt (normSq z) * v := by
        rw [hu_sq, hv_sq]
        linarith
      exact_mod_cast hbound.trans' hsuff
    have hdiscrim :
        (2 * Real.sqrt (normSq z) * v) ^ 2 - 4 * a * d * v ^ 2 <= 0 := by
      have hnonneg_v : 0 <= v ^ 2 := sq_nonneg v
      nlinarith
    by_cases ha0 : a = 0
    · simp only [ha0, zero_mul] at hz ⊢
      have hzero : normSq z = 0 := by
        nlinarith [Complex.normSq_nonneg z]
      simp [hzero]
      positivity
    · have ha_pos : 0 < a := lt_of_le_of_ne ha (Ne.symm ha0)
      nlinarith [sq_nonneg (a * u - Real.sqrt (normSq z) * v),
        sq_nonneg (a * u + Real.sqrt (normSq z) * v)]
  · intro i _ hni
    simp [Finsupp.mem_support_iff] at hni
    simp [hni]

/-- The component inequalities used by the two-by-two PSD criterion. -/
lemma forwardCone_component_inequalities (p : Vec4) (hp : ForwardCone p) :
    0 <= p 0 + p 3 /\ 0 <= p 0 - p 3 /\
      (p 1)^2 + (p 2)^2 <= (p 0 + p 3) * (p 0 - p 3) := by
  obtain ⟨hp0, hpms⟩ := hp
  simp only [minkowskiSq] at hpms
  have hp3_sq : (p 3)^2 <= (p 0)^2 := by
    nlinarith [sq_nonneg (p 1), sq_nonneg (p 2)]
  have hp3_le : p 3 <= p 0 := by
    nlinarith [sq_nonneg (p 0 - p 3)]
  have hp3_ge : p 3 >= -p 0 := by
    nlinarith [sq_nonneg (p 0 - p 3)]
  exact ⟨by linarith, by linarith, by ring_nf; nlinarith⟩

/-- Every future-pointing non-spacelike vector has a positive-semidefinite
Pauli representative. -/
theorem forwardCone_posSemidef (p : Vec4) (hp : ForwardCone p) :
    (hermOfVec p).PosSemidef := by
  obtain ⟨ha, hd, hz⟩ := forwardCone_component_inequalities p hp
  let z : Complex := (p 1 : Real) - (p 2 : Real) * I
  have hnorm : normSq z = (p 1)^2 + (p 2)^2 := by
    simp [normSq, z]
    ring
  have hz_ineq : normSq z <= (p 0 + p 3) * (p 0 - p 3) := by
    linarith
  have heq :
      hermOfVec p =
        !![(p 0 + p 3 : Complex), z;
           star z, (p 0 - p 3 : Complex)] := by
    simp [hermOfVec, z]
  rw [heq]
  convert posSemidef_fin_two_of_normSq_le_mul
    (p 0 + p 3) (p 0 - p 3) z ha hd hz_ineq using 1
  ext i j
  fin_cases i <;> fin_cases j <;> simp

/-! ## Cone coverage, conditional on positivity -/

/-- **Cone coverage given positivity.** If the Hermitian representative `hermOfVec p` is
positive semidefinite, then `p` is the soldered four-vector of a null-edge bundle
`sum_i psi_i psi_i^dagger`. Composed with the (dispatched) fact that every forward-cone
vector has positive-semidefinite representative, this is the surjectivity half of kinematic
completeness. -/
theorem bundle_of_posSemidef (p : Vec4) (hp : (hermOfVec p).PosSemidef) :
    ∃ (n : ℕ) (psi : Fin n → CSpinor), p = vecOfHerm (finBundleMomentum psi) := by
  obtain ⟨n, psi, hpsi⟩ := (posSemidef_iff_finBundle (hermOfVec p)).1 hp
  exact ⟨n, psi, by rw [← hpsi, vecOfHerm_hermOfVec]⟩

/-- **Unconditional kinematic completeness.** Every future-causal
four-momentum is the soldered vector of a finite null-edge bundle, and its
Minkowski square is exactly the bundle's real pairwise Pluecker mass. This is a
representation theorem; it does not select the momentum or its numerical mass
by dynamics. -/
theorem forwardCone_complete_nullEdge_representation
    (p : Vec4) (hp : ForwardCone p) :
    ∃ (n : Nat) (psi : Fin n -> CSpinor),
      p = vecOfHerm (finBundleMomentum psi) /\
      minkowskiSq p = finPairwisePluckerMassReal psi := by
  have hpsd := forwardCone_posSemidef p hp
  obtain ⟨n, psi, hmatrix⟩ :=
    (posSemidef_iff_finBundle (hermOfVec p)).1 hpsd
  refine ⟨n, psi, ?_, ?_⟩
  · rw [← hmatrix, vecOfHerm_hermOfVec]
  · have hdet :
        ((minkowskiSq p : Real) : Complex) =
          (finBundleMomentum psi).det := by
      rw [← hmatrix]
      exact (det_hermOfVec p).symm
    rw [fin_bundle_det_eq_ofReal_pluckerMassReal] at hdet
    exact_mod_cast hdet

/-- **Explicit future-null completeness.** Every future-causal four-momentum is
the soldered sum of finitely many spinor edges; every constituent edge is
future-pointing and null; and the total invariant mass squared is exactly the
pairwise Pluecker mass of those edges.

This is still a representation theorem. It neither selects `p` nor identifies
the dynamics that produced it. -/
theorem forwardCone_complete_futureNullEdge_representation
    (p : Vec4) (hp : ForwardCone p) :
    ∃ (n : Nat) (psi : Fin n -> CSpinor),
      p = vecOfHerm (finBundleMomentum psi) /\
      (forall i,
        minkowskiSq
            (PhysicsSM.Draft.NullEdge.NullEdgeSpinorSoldering.nullEdgeVector (psi i)) = 0 /\
          0 <=
            (PhysicsSM.Draft.NullEdge.NullEdgeSpinorSoldering.nullEdgeVector (psi i)) 0) /\
      minkowskiSq p = finPairwisePluckerMassReal psi := by
  obtain ⟨n, psi, hpvec, hmass⟩ :=
    forwardCone_complete_nullEdge_representation p hp
  refine ⟨n, psi, hpvec, ?_, hmass⟩
  intro i
  exact ⟨
    PhysicsSM.Draft.NullEdge.NullEdgeSpinorSoldering.nullEdgeVector_minkowskiSq (psi i),
    (PhysicsSM.Draft.NullEdge.NullEdgeSpinorSoldering.nullEdgeVector_time_nonneg (psi i)).1⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness.posSemidef_iff_finBundle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms posSemidef_iff_finBundle

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness.mass_surjective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_surjective

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness.vecOfHerm_hermOfVec' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms vecOfHerm_hermOfVec

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness.det_hermOfVec' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_hermOfVec

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness.bundle_of_posSemidef' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bundle_of_posSemidef

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness.forwardCone_posSemidef' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms forwardCone_posSemidef

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness.forwardCone_complete_nullEdge_representation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms forwardCone_complete_nullEdge_representation

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness.forwardCone_complete_futureNullEdge_representation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms forwardCone_complete_futureNullEdge_representation

end PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness
