import PhysicsSM.Draft.NullEdge.HNUInfraredTangent

/-!
# HNU lower/high block chirality balance

This focused target reconstructs the second two-band block of the published
Higashikawa-Nakagawa-Ueda four-band Floquet drive.  The paper defines it by
shifting the third momentum by `2 * pi`.  The key target is the exact global
identity saying that this shifted block is the lower block with the second
momentum reflected.

That identity has two consequences which must be kept distinct:

* the selected lower block has the single positive-orientation Weyl tangent;
* the complete four-band drive contains an opposite-orientation companion, so
  its local chirality ledger is balanced.

The target is finite matrix algebra and genuine one-variable differentiation.
It is not a proof of the endpoint winding integral, a bulk-edge theorem, or an
interacting chiral gauge theory.

Provenance: clean-room theorem design from S. Higashikawa, M. Nakagawa, and
M. Ueda, "Floquet chiral magnetic effect", Phys. Rev. Lett. 123, 066403
(2019), arXiv:1806.06868.  The lower/high convention follows their
`V^wh(k) = U(k) direct-sum U^H(k)` with
`U^H(k) = U(k1,k2,k3-2*pi)`.  A NumPy oracle was used only to discover the
candidate reflection law; Lean proves every statement below exactly.
-/

open Matrix Complex
open scoped Matrix.Norms.Operator

namespace PhysicsSM.Draft.NullEdge.HNUCompanionChirality

open HNUExactCore HNUInfraredTangent

noncomputable section

/-- Reflection of the second momentum coordinate. -/
def reflectSecond (k : Fin 3 -> Real) : Fin 3 -> Real :=
  ![k 0, -k 1, k 2]

/-- The paper's high-block momentum shift. -/
def highShift (k : Fin 3 -> Real) : Fin 3 -> Real :=
  ![k 0, k 1, k 2 - 2 * Real.pi]

/-- The high two-band endpoint in the complete HNU drive. -/
def highEndpoint (k : Fin 3 -> Real) : M2 := endpoint (highShift k)

/-- **Global companion identity.**  The shifted high block is exactly the
lower block after reflecting the second momentum, at every real momentum. -/
theorem highEndpoint_eq_reflectSecond (k : Fin 3 -> Real) :
    highEndpoint k = endpoint (reflectSecond k) := by
  unfold highEndpoint reflectSecond
  unfold endpoint highShift
  simp +decide [sub_div, Uminus, Uplus]
  norm_num [Complex.exp_sub, Complex.exp_neg, mul_sub]
  norm_num [show Complex.exp (I * Real.pi) = -1 by
    rw [mul_comm]
    exact Complex.exp_pi_mul_I]
  norm_num [div_eq_mul_inv, Complex.exp_neg, Complex.exp_ne_zero,
    Pplus, Pminus, σ1, σ2, σ3]
  norm_num [<- Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply,
    Matrix.smul_eq_diagonal_mul] at *
  field_simp
  grind +locals

/-- The high block meets `+I` at the physical origin. -/
theorem highEndpoint_zero : highEndpoint 0 = 1 := by
  have h := highEndpoint_eq_reflectSecond 0
  simp_all +decide [reflectSecond]
  convert HNUExactCore.endpoint_zero
  ext i
  fin_cases i <;> rfl

/-- The high block has the reflected Weyl tangent
`-i (q1 sigma1 - q2 sigma2 + q3 sigma3)` at the physical origin. -/
theorem highEndpoint_ray_hasDerivAt (q : Fin 3 -> Real) :
    HasDerivAt (fun t : Real => highEndpoint (fun i => t * q i))
      ((-I) • (((q 0 : Real) : Complex) • HNUExactCore.σ1 +
        ((-(q 1) : Real) : Complex) • HNUExactCore.σ2 +
        ((q 2 : Real) : Complex) • HNUExactCore.σ3)) 0 := by
  have h1 := HNUInfraredTangent.endpoint_ray_hasDerivAt ![q 0, -q 1, q 2]
  simp_all +decide [highEndpoint_eq_reflectSecond, reflectSecond]
  convert h1 using 3
  ext i
  fin_cases i <;> norm_num

/-- The lower-block infrared Jacobian. -/
def lowerJacobian : Matrix (Fin 3) (Fin 3) Real := 1

/-- The high-block infrared Jacobian forced by the exact reflection law. -/
def highJacobian : Matrix (Fin 3) (Fin 3) Real :=
  !![1, 0, 0; 0, -1, 0; 0, 0, 1]

theorem lowerJacobian_det : lowerJacobian.det = 1 := by
  norm_num [lowerJacobian]

theorem highJacobian_det : highJacobian.det = -1 := by
  simp [highJacobian, Matrix.det_fin_three]

/-- The complete four-band local chirality ledger balances exactly. -/
theorem full_local_chirality_balance :
    lowerJacobian.det + highJacobian.det = 0 := by
  rw [lowerJacobian_det, highJacobian_det]
  norm_num

/-- On the physical Brillouin cube, the high block reaches `+I` only at the
origin, just like the lower block. -/
theorem high_zero_census (k : Fin 3 -> Real)
    (hk : forall i, k i ∈ Set.Icc (-Real.pi) Real.pi) :
    highEndpoint k = 1 <-> forall i, k i = 0 := by
  rw [HNUCompanionChirality.highEndpoint_eq_reflectSecond]
  rw [HNUExactCore.zero_census]
  · simp +decide [Fin.forall_fin_succ, reflectSecond]
  · simp_all +decide [Fin.forall_fin_succ, reflectSecond]
    linarith

/-- The complete four-band endpoint, written on the direct sum of the selected
lower and companion high spin spaces. -/
def fullEndpoint (k : Fin 3 -> Real) :
    Matrix (Fin 2 ⊕ Fin 2) (Fin 2 ⊕ Fin 2) Complex :=
  Matrix.fromBlocks (endpoint k) 0 0 (highEndpoint k)

/-- Embedding into the selected lower two-band sector. -/
def lowerEmbed (v : Fin 2 -> Complex) : (Fin 2 ⊕ Fin 2) -> Complex :=
  Sum.elim v (fun _ => 0)

/-- Embedding into the companion high two-band sector. -/
def highEmbed (v : Fin 2 -> Complex) : (Fin 2 ⊕ Fin 2) -> Complex :=
  Sum.elim (fun _ => 0) v

/-- The complete endpoint preserves the selected lower subspace and restricts
there exactly to `endpoint k`. -/
theorem fullEndpoint_lower_invariant (k : Fin 3 -> Real) (v : Fin 2 -> Complex) :
    fullEndpoint k *ᵥ lowerEmbed v = lowerEmbed (endpoint k *ᵥ v) := by
  ext i
  fin_cases i <;>
    simp +decide [fullEndpoint, lowerEmbed, Matrix.mulVec, dotProduct]

/-- The complete endpoint preserves the high subspace and restricts there
exactly to the reflected companion endpoint. -/
theorem fullEndpoint_high_invariant (k : Fin 3 -> Real) (v : Fin 2 -> Complex) :
    fullEndpoint k *ᵥ highEmbed v = highEmbed (highEndpoint k *ᵥ v) := by
  unfold fullEndpoint
  unfold highEmbed
  simp +decide [Matrix.mulVec, funext_iff]
  simp +decide [dotProduct, Fin.sum_univ_succ]

end

end PhysicsSM.Draft.NullEdge.HNUCompanionChirality

/-!
## Build-enforced assumption-footprint guards

All nine target theorems use only Lean/Mathlib's standard principles
`propext`, `Classical.choice`, and `Quot.sound`.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCompanionChirality.highEndpoint_eq_reflectSecond' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCompanionChirality.highEndpoint_eq_reflectSecond
/-- info: 'PhysicsSM.Draft.NullEdge.HNUCompanionChirality.highEndpoint_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCompanionChirality.highEndpoint_zero
/-- info: 'PhysicsSM.Draft.NullEdge.HNUCompanionChirality.highEndpoint_ray_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCompanionChirality.highEndpoint_ray_hasDerivAt
/-- info: 'PhysicsSM.Draft.NullEdge.HNUCompanionChirality.lowerJacobian_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCompanionChirality.lowerJacobian_det
/-- info: 'PhysicsSM.Draft.NullEdge.HNUCompanionChirality.highJacobian_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCompanionChirality.highJacobian_det
/-- info: 'PhysicsSM.Draft.NullEdge.HNUCompanionChirality.full_local_chirality_balance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCompanionChirality.full_local_chirality_balance
/-- info: 'PhysicsSM.Draft.NullEdge.HNUCompanionChirality.high_zero_census' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCompanionChirality.high_zero_census
/-- info: 'PhysicsSM.Draft.NullEdge.HNUCompanionChirality.fullEndpoint_lower_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCompanionChirality.fullEndpoint_lower_invariant
/-- info: 'PhysicsSM.Draft.NullEdge.HNUCompanionChirality.fullEndpoint_high_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCompanionChirality.fullEndpoint_high_invariant
