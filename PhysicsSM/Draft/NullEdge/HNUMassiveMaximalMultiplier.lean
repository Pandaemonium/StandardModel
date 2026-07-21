import PhysicsSM.Draft.NullEdge.HNUMassiveL2Resolvent
import PhysicsSM.Draft.NullEdge.VariablePointwiseL2Multiplier

/-!
# The maximal momentum-space Hamiltonian for the massive HNU flow

The massive HNU Dirac symbol is an unbounded matrix-valued function of
momentum. This module packages it as a partially defined linear operator on
spinor-valued `L2`, with the maximal graph domain. It proves that the domain is
dense and that the operator is symmetric. It also packages the two imaginary
spectral shifts on their own maximal domains.

The bounded inverse families were established in `HNUMassiveL2Resolvent`.
Their range identities are kept as a separate gate below: density and symmetry
alone are not called self-adjointness.

Provenance: clean-room specialization of
`VariablePointwiseL2Multiplier.maximalMultiplier` to the live massive HNU
symbol, following the standard direct-integral construction for Dirac
multiplication operators. Lean 4.28.0. Claim grade `M`, `[comp]`.
-/

noncomputable section

open Matrix Complex MeasureTheory
open scoped Matrix.Norms.L2Operator

set_option autoImplicit false

namespace PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier

open ChangingCellFourierL2
open HNUMassiveCompactSupportL2Generator
open HNUMassiveContinuumReduction
open HNUMassiveFibreResolvent
open HNUMassiveL2Resolvent
open Pluecker3Plus1ComplexMass
open VariablePointwiseL2Contraction
open VariablePointwiseL2Isometry
open VariablePointwiseL2Multiplier

abbrev FourierMomentum3 := ChangingCellFourierL2.FourierMomentum3
abbrev Spinor := EuclideanSpace Complex (Fin 4)
abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex
abbrev MomentumL2 := Lp Spinor 2 (volume : Measure FourierMomentum3)

/-- The Hermitian massive HNU Hamiltonian on one momentum fibre. -/
def massiveHamiltonianFamily (z : Complex) (q : FourierMomentum3) :
    Spinor →L[Complex] Spinor :=
  Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex) (massiveGenerator z q)

/-- The fibre family for the negative imaginary shift `H(q) - i I`. -/
def massiveMinusShiftFamily (z : Complex) (q : FourierMomentum3) :
    Spinor →L[Complex] Spinor :=
  Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
    (massiveGenerator z q - (I : Complex) • (1 : Mat4))

/-- The fibre family for the positive imaginary shift `H(q) + i I`. -/
def massivePlusShiftFamily (z : Complex) (q : FourierMomentum3) :
    Spinor →L[Complex] Spinor :=
  Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
    (massiveGenerator z q + (I : Complex) • (1 : Mat4))

/-- The massive HNU Hamiltonian on its maximal momentum-space graph domain. -/
def massiveHamiltonian (z : Complex) : MomentumL2 →ₗ.[Complex] MomentumL2 :=
  maximalMultiplier (volume : Measure FourierMomentum3)
    (massiveHamiltonianFamily z)

/-- The negative imaginary shift on its maximal graph domain. -/
def massiveMinusShift (z : Complex) : MomentumL2 →ₗ.[Complex] MomentumL2 :=
  maximalMultiplier (volume : Measure FourierMomentum3)
    (massiveMinusShiftFamily z)

/-- The positive imaginary shift on its maximal graph domain. -/
def massivePlusShift (z : Complex) : MomentumL2 →ₗ.[Complex] MomentumL2 :=
  maximalMultiplier (volume : Measure FourierMomentum3)
    (massivePlusShiftFamily z)

/-- The unshifted Hamiltonian fibre family is continuous in momentum. -/
theorem massiveHamiltonianFamily_continuous (z : Complex) :
    Continuous (massiveHamiltonianFamily z) := by
  unfold massiveHamiltonianFamily
  have hToCLM : Isometry
      (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)) := by
    apply Isometry.of_dist_eq
    intro A B
    simpa [dist_eq_norm, map_sub] using
      Matrix.l2_opNorm_toEuclideanCLM (A - B)
  apply hToCLM.continuous.comp
  have hcoord : forall i : Fin 3,
      Continuous (fun q : FourierMomentum3 => ((q i : Real) : Complex)) := by
    intro i
    exact Complex.continuous_ofReal.comp
      (PiLp.continuous_apply (p := 2) (β := fun _ : Fin 3 => Real) i)
  simp only [massiveGenerator_eq_H4]
  unfold H4
  exact ((((hcoord 0).smul continuous_const).add
    ((hcoord 1).smul continuous_const)).add
    ((hcoord 2).smul continuous_const)).add continuous_const

/-- The negative imaginary-shift family is continuous in momentum. -/
theorem massiveMinusShiftFamily_continuous (z : Complex) :
    Continuous (massiveMinusShiftFamily z) := by
  unfold massiveMinusShiftFamily
  have hToCLM : Isometry
      (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)) := by
    apply Isometry.of_dist_eq
    intro A B
    simpa [dist_eq_norm, map_sub] using
      Matrix.l2_opNorm_toEuclideanCLM (A - B)
  apply hToCLM.continuous.comp
  have hcoord : forall i : Fin 3,
      Continuous (fun q : FourierMomentum3 => ((q i : Real) : Complex)) := by
    intro i
    exact Complex.continuous_ofReal.comp
      (PiLp.continuous_apply (p := 2) (β := fun _ : Fin 3 => Real) i)
  have hgen : Continuous
      (fun q : FourierMomentum3 => massiveGenerator z q) := by
    simp only [massiveGenerator_eq_H4]
    unfold H4
    exact ((((hcoord 0).smul continuous_const).add
      ((hcoord 1).smul continuous_const)).add
      ((hcoord 2).smul continuous_const)).add continuous_const
  exact hgen.sub continuous_const

/-- The positive imaginary-shift family is continuous in momentum. -/
theorem massivePlusShiftFamily_continuous (z : Complex) :
    Continuous (massivePlusShiftFamily z) := by
  unfold massivePlusShiftFamily
  have hToCLM : Isometry
      (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)) := by
    apply Isometry.of_dist_eq
    intro A B
    simpa [dist_eq_norm, map_sub] using
      Matrix.l2_opNorm_toEuclideanCLM (A - B)
  apply hToCLM.continuous.comp
  have hcoord : forall i : Fin 3,
      Continuous (fun q : FourierMomentum3 => ((q i : Real) : Complex)) := by
    intro i
    exact Complex.continuous_ofReal.comp
      (PiLp.continuous_apply (p := 2) (β := fun _ : Fin 3 => Real) i)
  have hgen : Continuous
      (fun q : FourierMomentum3 => massiveGenerator z q) := by
    simp only [massiveGenerator_eq_H4]
    unfold H4
    exact ((((hcoord 0).smul continuous_const).add
      ((hcoord 1).smul continuous_const)).add
      ((hcoord 2).smul continuous_const)).add continuous_const
  exact hgen.add continuous_const

/-- Pointwise, the negative-shift family is the Hamiltonian minus `i` times
the identity. -/
theorem massiveMinusShiftFamily_apply (z : Complex) (q : FourierMomentum3)
    (v : Spinor) :
    massiveMinusShiftFamily z q v =
      massiveHamiltonianFamily z q v - I • v := by
  rw [massiveMinusShiftFamily, massiveHamiltonianFamily]
  simp only [map_sub, map_smul, map_one, ContinuousLinearMap.sub_apply,
    ContinuousLinearMap.smul_apply, ContinuousLinearMap.one_apply]

/-- Pointwise, the positive-shift family is the Hamiltonian plus `i` times
the identity. -/
theorem massivePlusShiftFamily_apply (z : Complex) (q : FourierMomentum3)
    (v : Spinor) :
    massivePlusShiftFamily z q v =
      massiveHamiltonianFamily z q v + I • v := by
  rw [massivePlusShiftFamily, massiveHamiltonianFamily]
  simp only [map_add, map_smul, map_one, ContinuousLinearMap.add_apply,
    ContinuousLinearMap.smul_apply, ContinuousLinearMap.one_apply]

/-- The maximal massive HNU Hamiltonian domain is dense in momentum-space
`L2`. -/
theorem massiveHamiltonian_dense_domain (z : Complex) :
    Dense ((massiveHamiltonian z).domain : Set MomentumL2) :=
  maximalMultiplier_dense_domain (volume : Measure FourierMomentum3)
    (massiveHamiltonianFamily z)
    (massiveHamiltonianFamily_continuous z).aestronglyMeasurable

/-- Each massive HNU Hamiltonian fibre is Hermitian in the Euclidean spinor
inner product. -/
theorem massiveHamiltonianFamily_hermitian (z : Complex)
    (q : FourierMomentum3) (v w : Spinor) :
    inner Complex (massiveHamiltonianFamily z q v) w =
      inner Complex v (massiveHamiltonianFamily z q w) := by
  let A := massiveHamiltonianFamily z q
  have hstar : star A = A := by
    change star (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
        (massiveGenerator z q)) =
      Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
        (massiveGenerator z q)
    rw [← map_star, Matrix.star_eq_conjTranspose,
      (massiveGenerator_isHermitian z q).eq]
  exact (ContinuousLinearMap.eq_adjoint_iff A A).mp hstar.symm v w

/-- The densely defined maximal massive HNU Hamiltonian is symmetric. -/
theorem massiveHamiltonian_isFormalAdjoint_self (z : Complex) :
    (massiveHamiltonian z).IsFormalAdjoint (massiveHamiltonian z) :=
  maximalMultiplier_isFormalAdjoint_self
    (volume : Measure FourierMomentum3) (massiveHamiltonianFamily z)
    (massiveHamiltonianFamily_hermitian z)

/-- The packaged Hamiltonian acts by its matrix symbol almost everywhere. -/
theorem massiveHamiltonian_apply_ae (z : Complex)
    (f : (massiveHamiltonian z).domain) :
    massiveHamiltonian z f =ᵐ[volume]
      fun q => massiveHamiltonianFamily z q (f.1 q) := by
  exact maximalMultiplier_apply_ae
    (volume : Measure FourierMomentum3) (massiveHamiltonianFamily z) f

/-- The packaged negative shift acts by its matrix symbol almost everywhere. -/
theorem massiveMinusShift_apply_ae (z : Complex)
    (f : (massiveMinusShift z).domain) :
    massiveMinusShift z f =ᵐ[volume]
      fun q => massiveMinusShiftFamily z q (f.1 q) := by
  exact maximalMultiplier_apply_ae
    (volume : Measure FourierMomentum3) (massiveMinusShiftFamily z) f

/-- The packaged positive shift acts by its matrix symbol almost everywhere. -/
theorem massivePlusShift_apply_ae (z : Complex)
    (f : (massivePlusShift z).domain) :
    massivePlusShift z f =ᵐ[volume]
      fun q => massivePlusShiftFamily z q (f.1 q) := by
  exact maximalMultiplier_apply_ae
    (volume : Measure FourierMomentum3) (massivePlusShiftFamily z) f

/-- The bounded negative-shift resolvent maps every `L2` vector into the
maximal domain of `H - i`. -/
theorem minusResolventL2_mem_domain (z : Complex) (f : MomentumL2) :
    minusResolventL2 z f ∈ (massiveMinusShift z).domain := by
  rw [massiveMinusShift, mem_maximalMultiplier_domain_iff]
  refine (Lp.memLp f).ae_eq ?_
  filter_upwards [minusResolventL2_coeFn z f] with q hres
  rw [show appliedRepresentative
      (volume : Measure FourierMomentum3) (massiveMinusShiftFamily z)
        (minusResolventL2 z f) q =
      massiveMinusShiftFamily z q ((minusResolventL2 z f) q) by rfl,
    hres]
  rw [massiveMinusShiftFamily, minusResolventFamily]
  rw [← ContinuousLinearMap.mul_apply, ← map_mul,
    shifted_minus_mul_inverse]
  simp

/-- The bounded positive-shift resolvent maps every `L2` vector into the
maximal domain of `H + i`. -/
theorem plusResolventL2_mem_domain (z : Complex) (f : MomentumL2) :
    plusResolventL2 z f ∈ (massivePlusShift z).domain := by
  rw [massivePlusShift, mem_maximalMultiplier_domain_iff]
  refine (Lp.memLp f).ae_eq ?_
  filter_upwards [plusResolventL2_coeFn z f] with q hres
  rw [show appliedRepresentative
      (volume : Measure FourierMomentum3) (massivePlusShiftFamily z)
        (plusResolventL2 z f) q =
      massivePlusShiftFamily z q ((plusResolventL2 z f) q) by rfl,
    hres]
  rw [massivePlusShiftFamily, plusResolventFamily]
  rw [← ContinuousLinearMap.mul_apply, ← map_mul,
    shifted_plus_mul_inverse]
  simp

/-- The negative-shift resolvent belongs to the unshifted Hamiltonian domain.
This is the first graph-domain half of the algebraic resolvent identity. -/
theorem minusResolventL2_mem_hamiltonian_domain
    (z : Complex) (f : MomentumL2) :
    minusResolventL2 z f ∈ (massiveHamiltonian z).domain := by
  rw [massiveHamiltonian, mem_maximalMultiplier_domain_iff]
  refine (Lp.memLp (f + I • minusResolventL2 z f)).ae_eq ?_
  filter_upwards [minusResolventL2_coeFn z f,
    Lp.coeFn_add f (I • minusResolventL2 z f),
    Lp.coeFn_smul I (minusResolventL2 z f)] with q hres hadd hsmul
  rw [show appliedRepresentative
      (volume : Measure FourierMomentum3) (massiveHamiltonianFamily z)
        (minusResolventL2 z f) q =
      massiveHamiltonianFamily z q ((minusResolventL2 z f) q) by rfl,
    hadd, Pi.add_apply, hsmul, Pi.smul_apply, hres]
  have hshift :
      massiveMinusShiftFamily z q (minusResolventFamily z q (f q)) = f q := by
    rw [massiveMinusShiftFamily, minusResolventFamily]
    rw [← ContinuousLinearMap.mul_apply, ← map_mul,
      shifted_minus_mul_inverse]
    simp
  rw [massiveMinusShiftFamily_apply] at hshift
  exact (sub_eq_iff_eq_add.mp hshift).symm

/-- The positive-shift resolvent belongs to the unshifted Hamiltonian domain. -/
theorem plusResolventL2_mem_hamiltonian_domain
    (z : Complex) (f : MomentumL2) :
    plusResolventL2 z f ∈ (massiveHamiltonian z).domain := by
  rw [massiveHamiltonian, mem_maximalMultiplier_domain_iff]
  refine (Lp.memLp (f - I • plusResolventL2 z f)).ae_eq ?_
  filter_upwards [plusResolventL2_coeFn z f,
    Lp.coeFn_sub f (I • plusResolventL2 z f),
    Lp.coeFn_smul I (plusResolventL2 z f)] with q hres hsub hsmul
  rw [show appliedRepresentative
      (volume : Measure FourierMomentum3) (massiveHamiltonianFamily z)
        (plusResolventL2 z f) q =
      massiveHamiltonianFamily z q ((plusResolventL2 z f) q) by rfl,
    hsub, Pi.sub_apply, hsmul, Pi.smul_apply, hres]
  have hshift :
      massivePlusShiftFamily z q (plusResolventFamily z q (f q)) = f q := by
    rw [massivePlusShiftFamily, plusResolventFamily]
    rw [← ContinuousLinearMap.mul_apply, ← map_mul,
      shifted_plus_mul_inverse]
    simp
  rw [massivePlusShiftFamily_apply] at hshift
  exact sub_eq_iff_eq_add.mpr hshift.symm

/-- The bounded negative-shift resolvent is a global right inverse for the
algebraic shift of the unshifted maximal Hamiltonian. -/
theorem massiveHamiltonian_minus_I_surjective (z : Complex) (f : MomentumL2) :
    let g : (massiveHamiltonian z).domain :=
      ⟨minusResolventL2 z f,
        minusResolventL2_mem_hamiltonian_domain z f⟩
    massiveHamiltonian z g - I • (g.1 : MomentumL2) = f := by
  dsimp
  apply Lp.ext
  filter_upwards
    [massiveHamiltonian_apply_ae z
      (⟨minusResolventL2 z f,
        minusResolventL2_mem_hamiltonian_domain z f⟩ :
          (massiveHamiltonian z).domain),
      minusResolventL2_coeFn z f,
      Lp.coeFn_sub
        (massiveHamiltonian z
          (⟨minusResolventL2 z f,
            minusResolventL2_mem_hamiltonian_domain z f⟩ :
              (massiveHamiltonian z).domain))
        (I • minusResolventL2 z f),
      Lp.coeFn_smul I (minusResolventL2 z f)]
    with q hH hres hsub hsmul
  rw [hsub, Pi.sub_apply, hsmul, Pi.smul_apply, hH, hres]
  rw [← massiveMinusShiftFamily_apply]
  rw [massiveMinusShiftFamily, minusResolventFamily]
  rw [← ContinuousLinearMap.mul_apply, ← map_mul,
    shifted_minus_mul_inverse]
  simp

/-- The bounded positive-shift resolvent is a global right inverse for the
other algebraic imaginary shift. -/
theorem massiveHamiltonian_plus_I_surjective (z : Complex) (f : MomentumL2) :
    let g : (massiveHamiltonian z).domain :=
      ⟨plusResolventL2 z f,
        plusResolventL2_mem_hamiltonian_domain z f⟩
    massiveHamiltonian z g + I • (g.1 : MomentumL2) = f := by
  dsimp
  apply Lp.ext
  filter_upwards
    [massiveHamiltonian_apply_ae z
      (⟨plusResolventL2 z f,
        plusResolventL2_mem_hamiltonian_domain z f⟩ :
          (massiveHamiltonian z).domain),
      plusResolventL2_coeFn z f,
      Lp.coeFn_add
        (massiveHamiltonian z
          (⟨plusResolventL2 z f,
            plusResolventL2_mem_hamiltonian_domain z f⟩ :
              (massiveHamiltonian z).domain))
        (I • plusResolventL2 z f),
      Lp.coeFn_smul I (plusResolventL2 z f)]
    with q hH hres hadd hsmul
  rw [hadd, Pi.add_apply, hsmul, Pi.smul_apply, hH, hres]
  rw [← massivePlusShiftFamily_apply]
  rw [massivePlusShiftFamily, plusResolventFamily]
  rw [← ContinuousLinearMap.mul_apply, ← map_mul,
    shifted_plus_mul_inverse]
  simp

/-- The maximal negative imaginary shift is onto. -/
theorem massiveMinusShift_surjective (z : Complex) :
    Function.Surjective (massiveMinusShift z) := by
  intro f
  let g : (massiveMinusShift z).domain :=
    ⟨minusResolventL2 z f, minusResolventL2_mem_domain z f⟩
  use g
  apply Lp.ext
  filter_upwards [massiveMinusShift_apply_ae z g,
    minusResolventL2_coeFn z f] with q hshift hres
  rw [hshift, hres, massiveMinusShiftFamily, minusResolventFamily]
  rw [← ContinuousLinearMap.mul_apply, ← map_mul,
    shifted_minus_mul_inverse]
  simp

/-- The maximal positive imaginary shift is onto. -/
theorem massivePlusShift_surjective (z : Complex) :
    Function.Surjective (massivePlusShift z) := by
  intro f
  let g : (massivePlusShift z).domain :=
    ⟨plusResolventL2 z f, plusResolventL2_mem_domain z f⟩
  use g
  apply Lp.ext
  filter_upwards [massivePlusShift_apply_ae z g,
    plusResolventL2_coeFn z f] with q hshift hres
  rw [hshift, hres, massivePlusShiftFamily, plusResolventFamily]
  rw [← ContinuousLinearMap.mul_apply, ← map_mul,
    shifted_plus_mul_inverse]
  simp

/-- **Maximal-domain self-adjointness of the massive HNU Hamiltonian.**

The proof combines the dense maximal graph domain, fibrewise Hermiticity, and
the two explicit global imaginary resolvents. It is a momentum-space operator
theorem; identifying its Fourier conjugate with a position-space differential
operator is a separate reconstruction statement. -/
theorem massiveHamiltonian_isSelfAdjoint (z : Complex) :
    IsSelfAdjoint (massiveHamiltonian z) := by
  apply isSelfAdjoint_of_isFormalAdjoint_of_surjective_shifts
  · exact massiveHamiltonian_dense_domain z
  · exact massiveHamiltonian_isFormalAdjoint_self z
  · intro f
    refine ⟨⟨plusResolventL2 z f,
      plusResolventL2_mem_hamiltonian_domain z f⟩, ?_⟩
    exact massiveHamiltonian_plus_I_surjective z f
  · intro f
    refine ⟨⟨minusResolventL2 z f,
      minusResolventL2_mem_hamiltonian_domain z f⟩, ?_⟩
    exact massiveHamiltonian_minus_I_surjective z f

/-- The adjoint of the maximal massive HNU Hamiltonian is exactly itself. -/
theorem massiveHamiltonian_adjoint_eq (z : Complex) :
    (massiveHamiltonian z).adjoint = massiveHamiltonian z := by
  rw [← LinearPMap.isSelfAdjoint_def]
  exact massiveHamiltonian_isSelfAdjoint z

/-- The maximal massive HNU Hamiltonian has a closed graph. -/
theorem massiveHamiltonian_isClosed (z : Complex) :
    (massiveHamiltonian z).IsClosed :=
  (massiveHamiltonian_isSelfAdjoint z).isClosed

end PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveHamiltonian_dense_domain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveHamiltonian_dense_domain

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveHamiltonian_isFormalAdjoint_self' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveHamiltonian_isFormalAdjoint_self

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveMinusShift_surjective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveMinusShift_surjective

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massivePlusShift_surjective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massivePlusShift_surjective

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveHamiltonian_minus_I_surjective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveHamiltonian_minus_I_surjective

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveHamiltonian_plus_I_surjective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveHamiltonian_plus_I_surjective

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveHamiltonian_isSelfAdjoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveHamiltonian_isSelfAdjoint

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveHamiltonian_adjoint_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveHamiltonian_adjoint_eq

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveHamiltonian_isClosed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier.massiveHamiltonian_isClosed
