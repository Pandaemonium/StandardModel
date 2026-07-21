import PhysicsSM.Draft.NullEdge.HNUInfraredTangent
import PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

/-!
# Massive doubled HNU walk with a Pluecker-controlled onsite turn

This target doubles the exact two-component HNU Weyl endpoint with its
opposite-momentum partner, rotates the pair into the live Dirac basis, and
composes it with the exact four-component Pluecker mass coin.  It asks for an
exactly unitary finite-depth massive walk and its simultaneous infrared
kinetic-plus-mass derivative.

The onsite mass coin is a local internal event.  The HNU factors retain their
projector-conditioned nearest-neighbor interpretation.  No global zero/pi
census or anomaly-cancellation claim is made by the definitions.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUInfraredTangent
open PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay

/-- Explicit direct sum of the HNU endpoint and its opposite-momentum partner. -/
def doubledChiralEndpoint (k : Fin 3 -> Real) : Mat4 :=
  let up := endpoint k
  let dn := endpoint (fun i => -k i)
  !![up 0 0, up 0 1, 0, 0;
     up 1 0, up 1 1, 0, 0;
     0, 0, dn 0 0, dn 0 1;
     0, 0, dn 1 0, dn 1 1]

/-- Hadamard rotation from the doubled chiral basis to the live Dirac basis. -/
def diracBasis : Mat4 :=
  ((Real.sqrt 2 : Complex)⁻¹) •
    !![1, 0, 1, 0;
       0, 1, 0, 1;
       1, 0, -1, 0;
       0, 1, 0, -1]

def diracHNU (k : Fin 3 -> Real) : Mat4 :=
  diracBasis * doubledChiralEndpoint k * diracBasis.conjTranspose

def massiveHNU (z : Complex) (a : Real) (k : Fin 3 -> Real) : Mat4 :=
  massCoin4 z a * diracHNU k

def kinetic4 (q : Fin 3 -> Real) : Mat4 :=
  (q 0 : Complex) • alpha1 + (q 1 : Complex) • alpha2 +
    (q 2 : Complex) • alpha3

theorem diracBasis_unitary :
    diracBasis ∈ Matrix.unitaryGroup (Fin 4) Complex := by
  simp +decide [ Matrix.mem_unitaryGroup_iff ];
  unfold diracBasis;
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] <;> ring_nf <;> norm_num [ Complex.ext_iff, sq ]; all_goals ring_nf; norm_num;

theorem doubledChiralEndpoint_unitary (k : Fin 3 -> Real) :
    doubledChiralEndpoint k ∈ Matrix.unitaryGroup (Fin 4) Complex := by
  constructor;
  · -- By definition of $doubledChiralEndpoint$, we know that its conjugate transpose is itself.
    ext i j; simp [doubledChiralEndpoint];
    have h_unitary : ∀ k : Fin 3 → ℝ, (endpoint k).conjTranspose * (endpoint k) = 1 := by
      intro k
      have := HNUExactCore.endpoint_unitary k
      simp_all +decide [ Matrix.mem_unitaryGroup_iff ];
      rw [ ← mul_eq_one_comm ] ; aesop;
    simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply ];
    fin_cases i <;> fin_cases j <;> simp +decide [ Fin.sum_univ_succ, h_unitary ];
  · -- Since `up` and `dn` are unitary, we have `up * star up = 1` and `dn * star dn = 1`.
    have h_unitary_up : endpoint k * star (endpoint k) = 1 := by
      exact HNUExactCore.endpoint_unitary k |>.2
    have h_unitary_dn : endpoint (fun i => -k i) * star (endpoint (fun i => -k i)) = 1 := by
      convert HNUExactCore.endpoint_unitary ( fun i => -k i ) |> fun h => h.2 using 1;
    simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ];
    unfold doubledChiralEndpoint; simp_all +decide [ Matrix.mul_apply, Fin.sum_univ_succ ] ;

theorem diracHNU_unitary (k : Fin 3 -> Real) :
    diracHNU k ∈ Matrix.unitaryGroup (Fin 4) Complex := by
  -- DiracBasis, Zero=DoubledChiral, and their conjugate transposes are all unitary, so their product is unitary.
  apply And.intro;
  · simp +decide [ diracHNU, Matrix.mul_assoc, diracBasis_unitary, doubledChiralEndpoint_unitary ];
    simp +decide [ ← mul_assoc, diracBasis_unitary, doubledChiralEndpoint_unitary ];
    convert diracBasis_unitary.2 using 1;
    ext i j ; simp +decide [ Matrix.mul_apply, Matrix.conjTranspose_apply ];
  · -- By definition of diracBasis, we know that diracBasis is unitary.
    have h_diracBasis_unitary : diracBasis.conjTranspose * diracBasis = 1 := by
      have := diracBasis_unitary;
      exact this.1;
    -- By definition of doubledChiralEndpoint, we know that doubledChiralEndpoint k is unitary.
    have h_doubledChiralEndpoint_unitary : doubledChiralEndpoint k * star (doubledChiralEndpoint k) = 1 := by
      apply (doubledChiralEndpoint_unitary k).2;
    simp_all +decide [ diracHNU, Matrix.mul_assoc ];
    simp_all +decide [ ← mul_assoc, star ];
    rw [ ← mul_eq_one_comm, h_diracBasis_unitary ]

theorem diracHNU_zero : diracHNU 0 = 1 := by
  simp [HNUExactCore.endpoint_zero, doubledChiralEndpoint, diracHNU, diracBasis_unitary] at *;
  convert diracBasis_unitary.2 using 1;
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ HNUExactCore.endpoint_zero ] ;
  all_goals simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ, HNUExactCore.endpoint_zero ] ;
  all_goals erw [ HNUExactCore.endpoint_zero ] ; norm_num;

/-
Exact probability preservation of the massive walk.
-/
theorem massiveHNU_unitary (z : Complex) (hz : Ne z 0)
    (a : Real) (k : Fin 3 -> Real) :
    massiveHNU z a k ∈ Matrix.unitaryGroup (Fin 4) Complex := by
  unfold massiveHNU;
  have := Pluecker3Plus1ComplexMass.massCoin4_unitary_group z hz a 0;
  simp_all +decide [ Matrix.mem_unitaryGroup_iff, Matrix.mul_assoc ];
  simp_all +decide [ ← mul_assoc, diracHNU_unitary ]

/-
At zero momentum the complete step is exactly the derived Pluecker mass
coin, so the stay/turn amplitude is not an independent parameter.
-/
theorem massiveHNU_rest (z : Complex) (a : Real) :
    massiveHNU z a 0 = massCoin4 z a := by
  convert congr_arg _ diracHNU_zero using 1;
  rw [ mul_one ]

/-
The exact infinitesimal onsite Pluecker turn.
-/
lemma massCoin4_hasDerivAt_zero (z : Complex) (hz : Ne z 0) :
    HasDerivAt (fun t : Real => massCoin4 z t) ((-I) • mass4 z) 0 := by
  unfold massCoin4;
  have h_deriv : HasDerivAt (fun t : ℝ => Complex.cos (t * ‖z‖)) (‖z‖ * -Complex.sin (0 * ‖z‖)) 0 ∧ HasDerivAt (fun t : ℝ => Complex.sin (t * ‖z‖) / ‖z‖) (‖z‖ * Complex.cos (0 * ‖z‖) / ‖z‖) 0 := by
    constructor;
    · convert HasDerivAt.comp 0 ( Complex.hasDerivAt_cos _ ) ( HasDerivAt.mul ( hasDerivAt_id 0 |> HasDerivAt.ofReal_comp ) ( hasDerivAt_const _ _ ) ) using 1 ; norm_num;
    · convert HasDerivAt.div_const ( HasDerivAt.comp _ ( Complex.hasDerivAt_sin _ ) ( HasDerivAt.mul ( hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) ( hasDerivAt_const _ _ ) ) ) _ using 1 ; norm_num;
  convert HasDerivAt.sub ( h_deriv.1.smul_const ( 1 : Mat4 ) ) ( h_deriv.2.smul_const ( I • mass4 z ) ) using 1;
  any_goals try exact Matrix.normedAddCommGroup;
  any_goals try exact Matrix.normedSpace;
  grind +extAll;
  any_goals try exact Matrix.isBoundedSMul
  any_goals try exact Matrix.isScalarTower;
  · congr;
  · grind +extAll;
  · ext; simp +decide [ div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm, smul_smul ] ;
  · norm_num [ div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm, hz ]

/-
The doubled chiral endpoint has opposite Weyl tangents in its two blocks.
-/
lemma doubledChiralEndpoint_ray_hasDerivAt (q : Fin 3 -> Real) :
    HasDerivAt (fun t : Real => doubledChiralEndpoint (fun i => t * q i))
      (let w := (q 0 : Complex) • σ1 + (q 1 : Complex) • σ2 +
          (q 2 : Complex) • σ3
       !![((-I) • w) 0 0, ((-I) • w) 0 1, 0, 0;
          ((-I) • w) 1 0, ((-I) • w) 1 1, 0, 0;
          0, 0, (I • w) 0 0, (I • w) 0 1;
          0, 0, (I • w) 1 0, (I • w) 1 1]) 0 := by
  simp +decide [ doubledChiralEndpoint ];
  rw [ hasDerivAt_pi ];
  intro i;
  fin_cases i <;> simp +decide [ Fin.forall_fin_succ, hasDerivAt_pi ];
  · have := HNUInfraredTangent.endpoint_ray_hasDerivAt q;
    rw [ hasDerivAt_pi ] at this;
    simp_all +decide [ Fin.forall_fin_succ, hasDerivAt_pi ];
    exact ⟨ by convert this.1.1 using 1; ring, by convert this.1.2 using 1; ring, hasDerivAt_const _ _ ⟩;
  · have := HNUInfraredTangent.endpoint_ray_hasDerivAt q;
    rw [ hasDerivAt_pi ] at this;
    simp_all +decide [ Fin.forall_fin_two, hasDerivAt_pi ];
    exact ⟨ by convert this.2.1 using 1; ring, by convert this.2.2 using 1; ring, hasDerivAt_const _ _ ⟩;
  · have := HNUInfraredTangent.endpoint_ray_hasDerivAt ( fun i => -q i );
    rw [ hasDerivAt_pi ] at this;
    simp_all +decide [ Fin.forall_fin_succ, hasDerivAt_pi ];
    exact ⟨ hasDerivAt_const _ _, by simpa only [ mul_add ] using this.1.1, by simpa only [ mul_add ] using this.1.2 ⟩;
  · have := HNUInfraredTangent.endpoint_ray_hasDerivAt ( fun i => -q i );
    rw [ hasDerivAt_pi ] at this;
    simp_all +decide [ Fin.forall_fin_two, hasDerivAt_pi ];
    exact ⟨ hasDerivAt_const _ _, by simpa only [ mul_add ] using this.2.1, by simpa only [ mul_add ] using this.2.2 ⟩

/-
The Hadamard basis rotation turns the opposite chiral tangents into the
live off-diagonal Dirac kinetic generators.
-/
set_option maxHeartbeats 800000 in
lemma diracHNU_ray_hasDerivAt (q : Fin 3 -> Real) :
    HasDerivAt (fun t : Real => diracHNU (fun i => t * q i))
      ((-I) • kinetic4 q) 0 := by
  unfold diracHNU kinetic4 alpha1 alpha2 alpha3;
  have h_deriv : HasDerivAt (fun t => doubledChiralEndpoint (fun i => t * q i)) (let w := (q 0 : Complex) • σ1 + (q 1 : Complex) • σ2 + (q 2 : Complex) • σ3; !![((-I) • w) 0 0, ((-I) • w) 0 1, 0, 0; ((-I) • w) 1 0, ((-I) • w) 1 1, 0, 0; 0, 0, (I • w) 0 0, (I • w) 0 1; 0, 0, (I • w) 1 0, (I • w) 1 1]) 0 := by
    convert doubledChiralEndpoint_ray_hasDerivAt q using 1;
  have h_deriv : HasDerivAt (fun t => diracBasis * doubledChiralEndpoint (fun i => t * q i) * diracBasisᴴ) (diracBasis * (let w := (q 0 : Complex) • σ1 + (q 1 : Complex) • σ2 + (q 2 : Complex) • σ3; !![((-I) • w) 0 0, ((-I) • w) 0 1, 0, 0; ((-I) • w) 1 0, ((-I) • w) 1 1, 0, 0; 0, 0, (I • w) 0 0, (I • w) 0 1; 0, 0, (I • w) 1 0, (I • w) 1 1]) * diracBasisᴴ) 0 := by
    rw [ hasDerivAt_pi ] at *;
    intro i; simp_all +decide [ Matrix.mul_apply, hasDerivAt_pi ] ;
    intro j; simp_all +decide [ Fin.sum_univ_four, hasDerivAt_pi ] ;
    apply_rules [ HasDerivAt.add, HasDerivAt.mul, hasDerivAt_const ];
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.add ( HasDerivAt.add ( HasDerivAt.const_mul ( diracBasis i 0 ) ( h_deriv 0 0 ) ) ( HasDerivAt.const_mul ( diracBasis i 1 ) ( h_deriv 1 0 ) ) ) ( HasDerivAt.const_mul ( diracBasis i 2 ) ( h_deriv 2 0 ) ) ) ( HasDerivAt.const_mul ( diracBasis i 3 ) ( h_deriv 3 0 ) ) ) ( hasDerivAt_const _ _ ) using 1 ; norm_num;
      simp +decide [ diracBasis ];
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.add ( HasDerivAt.add ( HasDerivAt.const_mul ( diracBasis i 0 ) ( h_deriv 0 1 ) ) ( HasDerivAt.const_mul ( diracBasis i 1 ) ( h_deriv 1 1 ) ) ) ( HasDerivAt.const_mul ( diracBasis i 2 ) ( h_deriv 2 1 ) ) ) ( HasDerivAt.const_mul ( diracBasis i 3 ) ( h_deriv 3 1 ) ) ) ( hasDerivAt_const _ _ ) using 1 ; ring;
      simp +decide [ Fin.sum_univ_succ, Fin.sum_univ_zero, Matrix.mul_apply, dotProduct, diracBasis ] ; ring;
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.add ( HasDerivAt.add ( HasDerivAt.const_mul _ ( h_deriv 0 2 ) ) ( HasDerivAt.const_mul _ ( h_deriv 1 2 ) ) ) ( HasDerivAt.const_mul _ ( h_deriv 2 2 ) ) ) ( HasDerivAt.const_mul _ ( h_deriv 3 2 ) ) ) ( hasDerivAt_const _ _ ) using 1 ; norm_num;
      simp +decide [ diracBasis ];
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.add ( HasDerivAt.add ( HasDerivAt.const_mul _ ( h_deriv 0 3 ) ) ( HasDerivAt.const_mul _ ( h_deriv 1 3 ) ) ) ( HasDerivAt.const_mul _ ( h_deriv 2 3 ) ) ) ( HasDerivAt.const_mul _ ( h_deriv 3 3 ) ) ) ( hasDerivAt_const _ _ ) using 1 ; norm_num;
      simp +decide [ diracBasis ];
  convert h_deriv using 1;
  ext i j ; simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ ] ; ring;
  fin_cases i <;> fin_cases j <;> simp +decide [ diracBasis, σ1, σ2, σ3 ] <;> ring;
  all_goals norm_num [ ← Complex.ofReal_pow ] ; ring;

/-
Main infrared composition target.  Kinetic and onsite Pluecker turning
appear in the derivative of one exact unitary step.
-/
theorem massiveHNU_ray_hasDerivAt (z : Complex) (hz : Ne z 0)
    (q : Fin 3 -> Real) :
    HasDerivAt
      (fun t : Real => massiveHNU z t (fun i => t * q i))
      ((-I) • (kinetic4 q + mass4 z)) 0 := by
  have h_deriv : HasDerivAt (fun t : ℝ => massCoin4 z t * diracHNU (fun i => t * q i)) ((-I) • (mass4 z + kinetic4 q)) 0 := by
    have h_deriv : HasDerivAt (fun t : ℝ => massCoin4 z t) ((-I) • mass4 z) 0 ∧ HasDerivAt (fun t : ℝ => diracHNU (fun i => t * q i)) ((-I) • kinetic4 q) 0 := by
      exact ⟨ massCoin4_hasDerivAt_zero z hz, diracHNU_ray_hasDerivAt q ⟩;
    have h_deriv : HasDerivAt (fun t : ℝ => massCoin4 z t * diracHNU (fun i => t * q i)) ((-I) • mass4 z * diracHNU (fun i => 0 * q i) + massCoin4 z 0 * (-I) • kinetic4 q) 0 := by
      rw [ hasDerivAt_pi ] at *;
      simp_all +decide [ Fin.sum_univ_succ, Matrix.mul_apply, hasDerivAt_pi ];
      intro i j; have := h_deriv.1 i 0; have := h_deriv.1 i 1; have := h_deriv.1 i 2; have := h_deriv.1 i 3; have := h_deriv.2; simp_all +decide [ hasDerivAt_pi ] ;
      have := this; rw [ hasDerivAt_pi ] at this; simp_all +decide [ hasDerivAt_pi ] ;
      convert HasDerivAt.add ( HasDerivAt.mul ( h_deriv i 0 ) ( this 0 j ) ) ( HasDerivAt.add ( HasDerivAt.mul ( h_deriv i 1 ) ( this 1 j ) ) ( HasDerivAt.add ( HasDerivAt.mul ( h_deriv i 2 ) ( this 2 j ) ) ( HasDerivAt.mul ( h_deriv i 3 ) ( this 3 j ) ) ) ) using 1 ; ring;
    convert h_deriv using 1 ; norm_num [ diracHNU_zero ] ; ring;
    rw [ show diracHNU ( fun _ => 0 ) = 1 from diracHNU_zero ] ; norm_num [ massCoin4 ] ;
  simpa only [ add_comm, massiveHNU ] using h_deriv

/-
Nondegenerate control with both Pluecker mass directions active.
-/
theorem three_four_I_massive_control :
    massiveHNU (3 + 4 * I) 0 0 = 1 ∧
      Ne (mass4 (3 + 4 * I)) 0 := by
  constructor;
  · -- By definition of `massiveHNU`, we have `massiveHNU (3 + 4 * I) 0 0 = massCoin4 (3 + 4 * I) 0`.
    simp [massiveHNU, massCoin4];
    exact diracHNU_zero;
  · convert Pluecker3Plus1ComplexMass.control_three_four_I.2 using 1

end PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay

/-! ## Assumption-footprint inventory -/

#print axioms PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay.diracBasis_unitary
#print axioms PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay.doubledChiralEndpoint_unitary
#print axioms PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay.diracHNU_unitary
#print axioms PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay.diracHNU_zero
#print axioms PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay.massiveHNU_unitary
#print axioms PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay.massiveHNU_rest
#print axioms PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay.massiveHNU_ray_hasDerivAt
#print axioms PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay.three_four_I_massive_control
