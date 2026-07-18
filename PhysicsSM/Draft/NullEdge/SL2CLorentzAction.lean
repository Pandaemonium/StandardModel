import PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup
import PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary
import PhysicsSM.Draft.NullEdge.SL2CCentralSign

/-!
# Concrete SL(2,C) action on Minkowski vectors

This module constructs the first group-level spin-cover bridge needed by the
null-edge atlas program.  The project's Pauli lift sends a real Minkowski
four-vector to a two-by-two Hermitian complex matrix.  We define explicit real
coordinates in the reverse direction and prove that the two maps are inverse
on the Hermitian subspace.

For `A` in `SL(2,C)`, congruence `X |-> A X A^dagger` therefore induces a real
linear action on Minkowski vectors.  Determinant preservation proves the
Minkowski quadratic norm, polarization proves the bilinear form, and the
standard-basis matrix is eta-Lorentz.  Matrix composition then packages the
construction as a homomorphism

```text
SL(2,C) -> O(1,3).
```

Every image matrix is proved proper and orthochronous, so the action factors
through `SO+(1,3)`.  Its kernel is proved to be exactly the two central matrices
`{+I,-I}`.  This module does not prove that the factored map is surjective;
that is the remaining finite double-cover gate.

PhysLean's `Lorentz.SL2C.toLorentzGroup` was consulted for architecture and
convention alignment.  The implementation here is a clean-room construction
using this project's Pauli lift and the pinned Mathlib APIs; PhysLean is not
imported.

Claim grade: `M [comp]`, finite linear and matrix algebra only.
-/

open Matrix Complex
open scoped MatrixGroups

noncomputable section

namespace PhysicsSM.Draft.NullEdge.SL2CLorentzAction

open PhysicsSM.NullStrand
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary
open PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup
open PhysicsSM.Draft.NullEdge.SL2CCentralSign

/-- Recover real Minkowski coordinates from a two-by-two complex matrix.  The
formula is the inverse of `pauliHermitianEquiv` on Hermitian matrices. -/
def hermitianCoords
    (X : Matrix (Fin 2) (Fin 2) Complex) : Minkowski4 :=
  ![(X 0 0).re / 2 + (X 1 1).re / 2,
    (X 0 1).re / 2 + (X 1 0).re / 2,
    (X 1 0).im / 2 - (X 0 1).im / 2,
    (X 0 0).re / 2 - (X 1 1).re / 2]

/-- Coordinate extraction is a left inverse of the project Pauli lift. -/
theorem hermitianCoords_pauliHermitianEquiv (p : Minkowski4) :
    hermitianCoords (pauliHermitianEquiv p) = p := by
  funext i
  fin_cases i <;>
    simp [hermitianCoords, pauliHermitianEquiv_apply] <;>
    ring

/-- On Hermitian matrices, the project Pauli lift is also a left inverse of
coordinate extraction. -/
theorem pauliHermitianEquiv_hermitianCoords
    (X : Matrix (Fin 2) (Fin 2) Complex) (hX : X.IsHermitian) :
    pauliHermitianEquiv (hermitianCoords X) = X := by
  unfold Matrix.IsHermitian at hX
  have h00 := congrArg Complex.im (congrFun (congrFun hX 0) 0)
  have h11 := congrArg Complex.im (congrFun (congrFun hX 1) 1)
  have h01re := congrArg Complex.re (congrFun (congrFun hX 0) 1)
  have h01im := congrArg Complex.im (congrFun (congrFun hX 0) 1)
  simp [Matrix.conjTranspose_apply] at h00 h11 h01re h01im
  ext a b
  fin_cases a <;> fin_cases b
  all_goals simp [pauliHermitianEquiv_apply, hermitianCoords]
  all_goals apply Complex.ext <;> simp
  all_goals linarith

/-- The Pauli lift is injective on real Minkowski vectors. -/
theorem pauliHermitianEquiv_injective :
    Function.Injective pauliHermitianEquiv :=
  Function.LeftInverse.injective hermitianCoords_pauliHermitianEquiv

/-- Real-linear coordinate extraction. -/
def hermitianCoordsLinear :
    Matrix (Fin 2) (Fin 2) Complex →ₗ[Real] Minkowski4 where
  toFun := hermitianCoords
  map_add' X Y := by
    funext i
    fin_cases i <;> simp [hermitianCoords] <;> ring
  map_smul' r X := by
    funext i
    fin_cases i <;> simp [hermitianCoords] <;> ring

/-- The project Pauli lift as a real-linear map. -/
def pauliLiftLinear :
    Minkowski4 →ₗ[Real] Matrix (Fin 2) (Fin 2) Complex where
  toFun := pauliHermitianEquiv
  map_add' p q := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [pauliHermitianEquiv_apply] <;> ring
  map_smul' r p := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [pauliHermitianEquiv_apply] <;> ring

/-- Hermitian congruence by an `SL(2,C)` matrix as a real-linear map on all
two-by-two complex matrices. -/
def hermitianCongruenceLinear (A : SL2C) :
    Matrix (Fin 2) (Fin 2) Complex →ₗ[Real]
      Matrix (Fin 2) (Fin 2) Complex where
  toFun X := hermitianLorentzAction A X
  map_add' X Y := by
    unfold hermitianLorentzAction
    noncomm_ring
  map_smul' r X := by
    unfold hermitianLorentzAction
    noncomm_ring [Algebra.mul_smul_comm, Algebra.smul_mul_assoc]

/-- The real-linear action of `SL(2,C)` on Minkowski four-vectors induced by
Hermitian congruence. -/
def sl2LorentzLinear (A : SL2C) : Minkowski4 →ₗ[Real] Minkowski4 :=
  hermitianCoordsLinear.comp
    ((hermitianCongruenceLinear A).comp pauliLiftLinear)

/-- Applying the Pauli lift after the induced vector action recovers literal
Hermitian congruence. -/
theorem pauli_sl2LorentzLinear (A : SL2C) (p : Minkowski4) :
    pauliHermitianEquiv (sl2LorentzLinear A p) =
      hermitianLorentzAction A (pauliHermitianEquiv p) := by
  apply pauliHermitianEquiv_hermitianCoords
  exact hermitianLorentzAction_isHermitian _ _
    (pauliHermitianEquiv_isHermitian p)

/-- The induced action preserves the mostly-minus Minkowski quadratic norm. -/
theorem sl2LorentzLinear_preserves_minkowskiSq
    (A : SL2C) (p : Minkowski4) :
    minkowskiSq (sl2LorentzLinear A p) = minkowskiSq p := by
  have hdet := sl2_congruence_preserves_det
    (A : Matrix (Fin 2) (Fin 2) Complex) (pauliHermitianEquiv p) A.property
  change (hermitianLorentzAction A (pauliHermitianEquiv p)).det =
    (pauliHermitianEquiv p).det at hdet
  rw [<- pauli_sl2LorentzLinear A p] at hdet
  rw [hermitian_det_eq_minkowskiSq,
    hermitian_det_eq_minkowskiSq] at hdet
  exact Complex.ofReal_injective hdet

/-- Quadratic norm preservation polarizes to preservation of the Minkowski
bilinear form. -/
theorem sl2LorentzLinear_preserves_minkowskiInner
    (A : SL2C) (p q : Minkowski4) :
    minkowskiInner (sl2LorentzLinear A p) (sl2LorentzLinear A q) =
      minkowskiInner p q := by
  have hsum := sl2LorentzLinear_preserves_minkowskiSq A (p + q)
  have hp := sl2LorentzLinear_preserves_minkowskiSq A p
  have hq := sl2LorentzLinear_preserves_minkowskiSq A q
  rw [map_add] at hsum
  simp only [minkowskiSq, minkowskiInner, Pi.add_apply] at hsum hp hq ⊢
  linear_combination (hsum - hp - hq) / 2

/-- The induced action of the identity spin matrix is the identity vector
map. -/
theorem sl2LorentzLinear_one :
    sl2LorentzLinear (1 : SL2C) = 1 := by
  apply LinearMap.ext
  intro p
  apply pauliHermitianEquiv_injective
  rw [pauli_sl2LorentzLinear]
  change hermitianLorentzAction (1 : SL2C) (pauliHermitianEquiv p) =
    pauliHermitianEquiv p
  simp [hermitianLorentzAction]

/-- Spin-matrix multiplication becomes composition of the induced Minkowski
linear maps. -/
theorem sl2LorentzLinear_mul (A B : SL2C) :
    sl2LorentzLinear (A * B) =
      sl2LorentzLinear A * sl2LorentzLinear B := by
  apply LinearMap.ext
  intro p
  erw [Module.End.mul_apply]
  apply pauliHermitianEquiv_injective
  rw [pauli_sl2LorentzLinear, pauli_sl2LorentzLinear,
    pauli_sl2LorentzLinear]
  simp [hermitianLorentzAction, Matrix.mul_assoc]

/-- Standard-basis matrix of the induced Minkowski linear map. -/
def sl2LorentzMatrix (A : SL2C) : Matrix (Fin 4) (Fin 4) Real :=
  LinearMap.toMatrix (Pi.basisFun Real (Fin 4))
    (Pi.basisFun Real (Fin 4)) (sl2LorentzLinear A)

/-- Standard coordinate vector, used to expose the induced matrix entrywise. -/
def basisVector (j : Fin 4) : Minkowski4 :=
  Pi.single j 1

/-- Entrywise form of the Lorentz matrix induced by Hermitian congruence.  This
is the finite matrix presentation used by the focused properness proof target. -/
def explicitSL2LorentzMatrix (A : SL2C) :
    Matrix (Fin 4) (Fin 4) Real :=
  fun i j => hermitianCoords
    ((A : Matrix (Fin 2) (Fin 2) Complex) *
      pauliHermitianEquiv (basisVector j) *
      Matrix.conjTranspose (A : Matrix (Fin 2) (Fin 2) Complex)) i

/-- Matrix-vector multiplication agrees with the induced linear action. -/
theorem sl2LorentzMatrix_mulVec (A : SL2C) (p : Minkowski4) :
    sl2LorentzMatrix A *ᵥ p = sl2LorentzLinear A p := by
  rw [sl2LorentzMatrix]
  exact LinearMap.toMatrix_mulVec_repr
    (Pi.basisFun Real (Fin 4)) (Pi.basisFun Real (Fin 4))
    (sl2LorentzLinear A) p

/-- The abstract standard-basis matrix is exactly the direct Pauli-coordinate
matrix used by the finite determinant calculation. -/
theorem explicitSL2LorentzMatrix_eq_sl2LorentzMatrix (A : SL2C) :
    explicitSL2LorentzMatrix A = sl2LorentzMatrix A := by
  ext i j
  have h := congrFun (sl2LorentzMatrix_mulVec A
    ((Pi.basisFun Real (Fin 4)) j)) i
  simp [Matrix.mulVec, Pi.basisFun_apply] at h
  simpa [explicitSL2LorentzMatrix, basisVector, sl2LorentzLinear,
    hermitianCoordsLinear, hermitianCongruenceLinear, pauliLiftLinear,
    hermitianLorentzAction] using h.symm

set_option maxHeartbeats 1000000 in
/-- General determinant identity for the real coordinate matrix of Hermitian
congruence.  The exponent is the square of the complex determinant norm. -/
private lemma det_hermitianCongruence
    (A : Matrix (Fin 2) (Fin 2) Complex) :
    (Matrix.det (fun i j => hermitianCoords
      (A * pauliHermitianEquiv (basisVector j) *
        Matrix.conjTranspose A) i)) =
      (Complex.normSq A.det) ^ 2 := by
  unfold hermitianCoords basisVector pauliHermitianEquiv
    PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum
  simp +decide [Matrix.det_fin_two, Matrix.mul_apply,
    Fin.sum_univ_succ]; ring_nf
  simp +decide [Matrix.det_succ_row_zero, Pi.single_apply] at *
  simp +decide [Fin.sum_univ_succ, Fin.succAbove] at *
  norm_num [Complex.normSq]; ring_nf

/-- The induced real Lorentz matrix is proper: its determinant is exactly one. -/
theorem sl2LorentzMatrix_det_one (A : SL2C) :
    (sl2LorentzMatrix A).det = 1 := by
  rw [<- explicitSL2LorentzMatrix_eq_sl2LorentzMatrix]
  unfold explicitSL2LorentzMatrix
  convert det_hermitianCongruence A.val using 1
  simp +decide [Matrix.SpecialLinearGroup.det_coe A]

/-- The induced four-by-four matrix is eta-Lorentz. -/
theorem sl2LorentzMatrix_isEtaLorentz (A : SL2C) :
    IsEtaLorentz (sl2LorentzMatrix A) := by
  unfold IsEtaLorentz
  ext i j
  have hinner := sl2LorentzLinear_preserves_minkowskiInner A
    ((Pi.basisFun Real (Fin 4)) i) ((Pi.basisFun Real (Fin 4)) j)
  rw [<- sl2LorentzMatrix_mulVec A,
    <- sl2LorentzMatrix_mulVec A] at hinner
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.mulVec, Fin.sum_univ_four,
      MinkowskiConvention.eta, minkowskiInner, Pi.basisFun_apply]
      at hinner ⊢
  all_goals linarith

/-- The identity spin matrix induces the identity Lorentz matrix. -/
theorem sl2LorentzMatrix_one :
    sl2LorentzMatrix (1 : SL2C) = 1 := by
  rw [sl2LorentzMatrix, sl2LorentzLinear_one]
  exact LinearMap.toMatrix_one (Pi.basisFun Real (Fin 4))

/-- Multiplication of spin matrices becomes multiplication of their induced
Lorentz matrices in the atlas convention. -/
theorem sl2LorentzMatrix_mul (A B : SL2C) :
    sl2LorentzMatrix (A * B) =
      sl2LorentzMatrix A * sl2LorentzMatrix B := by
  rw [sl2LorentzMatrix, sl2LorentzLinear_mul]
  exact LinearMap.toMatrix_mul (Pi.basisFun Real (Fin 4))
    (sl2LorentzLinear A) (sl2LorentzLinear B)

/-- The concrete group homomorphism from `SL(2,C)` into the project's bundled
eta-Lorentz structure group. -/
def sl2ToEtaLorentz : MonoidHom SL2C EtaLorentzGroup where
  toFun A := ofMatrix (sl2LorentzMatrix A)
    (sl2LorentzMatrix_isEtaLorentz A)
  map_one' := by
    apply Subtype.ext
    apply Units.ext
    exact sl2LorentzMatrix_one
  map_mul' A B := by
    apply Subtype.ext
    apply Units.ext
    exact sl2LorentzMatrix_mul A B

/-- The time-time entry of every induced Lorentz matrix is nonnegative: it is
one half of the sum of the squared real and imaginary parts of the four spin
matrix entries. -/
theorem sl2LorentzMatrix_isOrthochronous (A : SL2C) :
    IsOrthochronousLorentz (sl2LorentzMatrix A) := by
  have h0 := congrFun (sl2LorentzMatrix_mulVec A
    ((Pi.basisFun Real (Fin 4)) 0)) 0
  simp [Matrix.mulVec, Pi.basisFun_apply] at h0
  change 0 <= sl2LorentzMatrix A 0 0
  rw [h0]
  simp [sl2LorentzLinear, hermitianCoordsLinear, hermitianCoords,
    hermitianCongruenceLinear, pauliLiftLinear, hermitianLorentzAction,
    pauliHermitianEquiv_apply, Matrix.mul_apply, Fin.sum_univ_two]
  nlinarith [sq_nonneg (A 0 0).re, sq_nonneg (A 0 0).im,
    sq_nonneg (A 0 1).re, sq_nonneg (A 0 1).im,
    sq_nonneg (A 1 0).re, sq_nonneg (A 1 0).im,
    sq_nonneg (A 1 1).re, sq_nonneg (A 1 1).im]

/-- In fact eta-orthogonality upgrades the nonnegative time-time entry to at
least one. -/
theorem one_le_sl2LorentzMatrix_timeTime (A : SL2C) :
    1 <= sl2LorentzMatrix A 0 0 := by
  have habs := one_le_abs_timeTime (sl2LorentzMatrix A)
    (sl2LorentzMatrix_isEtaLorentz A)
  simpa [abs_of_nonneg (sl2LorentzMatrix_isOrthochronous A)] using habs

/-- The time-orientation component character vanishes on the concrete
`SL(2,C)` image. -/
theorem timeCharacter_sl2ToEtaLorentz (A : SL2C) :
    timeCharacter (sl2ToEtaLorentz A) = 1 := by
  apply (timeCharacter_eq_one_iff (sl2ToEtaLorentz A)).mpr
  exact sl2LorentzMatrix_isOrthochronous A

/-- The determinant-orientation component character also vanishes on the
concrete `SL(2,C)` image. -/
theorem determinantCharacter_sl2ToEtaLorentz (A : SL2C) :
    determinantCharacter (sl2ToEtaLorentz A) = 1 := by
  apply (determinantCharacter_eq_one_iff (sl2ToEtaLorentz A)).mpr
  change 0 <= (sl2LorentzMatrix A).det
  rw [sl2LorentzMatrix_det_one]
  norm_num

/-- Every image matrix belongs to the proper-orthochronous Lorentz component. -/
theorem sl2LorentzMatrix_isRestricted (A : SL2C) :
    IsRestrictedLorentz (sl2LorentzMatrix A) := by
  exact ⟨sl2LorentzMatrix_isEtaLorentz A,
    sl2LorentzMatrix_det_one A,
    sl2LorentzMatrix_isOrthochronous A⟩

/-- The concrete spin action factored through the bundled
proper-orthochronous Lorentz group. -/
def sl2ToRestrictedLorentz : MonoidHom SL2C RestrictedLorentzGroup where
  toFun A := ⟨sl2ToEtaLorentz A, by
    exact (mem_restrictedLorentzGroup_iff (sl2ToEtaLorentz A)).2
      (sl2LorentzMatrix_isRestricted A)⟩
  map_one' := by
    apply Subtype.ext
    exact map_one sl2ToEtaLorentz
  map_mul' A B := by
    apply Subtype.ext
    exact map_mul sl2ToEtaLorentz A B

/-- If a spin matrix lies in the kernel of the concrete Lorentz action, its
Hermitian congruence fixes every Pauli-lifted Minkowski vector. -/
theorem hermitianLorentzAction_fixed_of_mem_kernel
    (A : SL2C) (hA : sl2ToEtaLorentz A = 1) (p : Minkowski4) :
    hermitianLorentzAction A (pauliHermitianEquiv p) =
      pauliHermitianEquiv p := by
  have hMatrix : sl2LorentzMatrix A = 1 := by
    have h := congrArg toMatrix hA
    simpa [sl2ToEtaLorentz] using h
  have hVector := sl2LorentzMatrix_mulVec A p
  rw [hMatrix] at hVector
  simp only [one_mulVec] at hVector
  rw [<- pauli_sl2LorentzLinear]
  exact congrArg pauliHermitianEquiv hVector.symm

/-- The Hermitian congruence action has no kernel elements beyond the two
central signs. -/
theorem hermitianLorentzAction_kernel (A : SL2C)
    (hfix : forall p : Minkowski4,
      hermitianLorentzAction A (pauliHermitianEquiv p) =
        pauliHermitianEquiv p) :
    Or (A = 1) (A = minusIdentity) := by
  simp_all +decide [hermitianLorentzAction, pauliHermitianEquiv,
    minusIdentity]
  have h_scalar : exists c : Complex, A = Matrix.diagonal ![c, c] := by
    have := hfix (fun i => if i = 0 then 1 else 0)
    have := hfix (fun i => if i = 1 then 1 else 0)
    have := hfix (fun i => if i = 2 then 1 else 0)
    have := hfix (fun i => if i = 3 then 1 else 0)
    simp_all +decide [
      PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum,
      <- Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply]
    grind +ring
  obtain ⟨c, hc⟩ := h_scalar
  have hdet := A.2
  simp_all +decide
  rcases eq_or_eq_neg_of_sq_eq_sq c 1
      (by linear_combination' hdet) with (rfl | rfl) <;>
      [left; right] <;>
    ext i j <;> fin_cases i <;> fin_cases j <;> aesop

/-- Multiplying a spin lift by the central sign does not change the induced
Minkowski linear map. -/
theorem sl2LorentzLinear_neg (A : SL2C) :
    sl2LorentzLinear (-A) = sl2LorentzLinear A := by
  apply LinearMap.ext
  intro p
  apply pauliHermitianEquiv_injective
  rw [pauli_sl2LorentzLinear, pauli_sl2LorentzLinear]
  exact hermitianLorentzAction_neg
    (A : Matrix (Fin 2) (Fin 2) Complex) (pauliHermitianEquiv p)

/-- Therefore the two central signs have the same eta-Lorentz image. -/
theorem sl2ToEtaLorentz_neg (A : SL2C) :
    sl2ToEtaLorentz (-A) = sl2ToEtaLorentz A := by
  apply Subtype.ext
  apply Units.ext
  change sl2LorentzMatrix (-A) = sl2LorentzMatrix A
  rw [sl2LorentzMatrix, sl2LorentzMatrix, sl2LorentzLinear_neg]

/-- The concrete nontrivial central element `-I` lies in the kernel. -/
theorem minusIdentity_mem_kernel :
    sl2ToEtaLorentz minusIdentity = 1 := by
  rw [show minusIdentity = -(1 : SL2C) by rfl,
    sl2ToEtaLorentz_neg]
  exact map_one sl2ToEtaLorentz

/-- **Exact central kernel.** The concrete `SL(2,C)` Lorentz homomorphism maps
precisely the two central signs to the identity. -/
theorem sl2ToEtaLorentz_eq_one_iff (A : SL2C) :
    sl2ToEtaLorentz A = 1 <-> Or (A = 1) (A = minusIdentity) := by
  constructor
  · intro hA
    apply hermitianLorentzAction_kernel A
    exact hermitianLorentzAction_fixed_of_mem_kernel A hA
  · rintro (rfl | rfl)
    · exact map_one sl2ToEtaLorentz
    · exact minusIdentity_mem_kernel

/-- The factored map into `SO+(1,3)` has the same exact central kernel. -/
theorem sl2ToRestrictedLorentz_eq_one_iff (A : SL2C) :
    sl2ToRestrictedLorentz A = 1 <->
      Or (A = 1) (A = minusIdentity) := by
  rw [<- sl2ToEtaLorentz_eq_one_iff]
  constructor
  · intro h
    exact congrArg Subtype.val h
  · intro h
    apply Subtype.ext
    exact h

end PhysicsSM.Draft.NullEdge.SL2CLorentzAction

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CLorentzAction.pauliHermitianEquiv_hermitianCoords' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SL2CLorentzAction.pauliHermitianEquiv_hermitianCoords

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CLorentzAction.sl2LorentzMatrix_isEtaLorentz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SL2CLorentzAction.sl2LorentzMatrix_isEtaLorentz

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CLorentzAction.explicitSL2LorentzMatrix_eq_sl2LorentzMatrix' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SL2CLorentzAction.explicitSL2LorentzMatrix_eq_sl2LorentzMatrix

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CLorentzAction.timeCharacter_sl2ToEtaLorentz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SL2CLorentzAction.timeCharacter_sl2ToEtaLorentz

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CLorentzAction.hermitianLorentzAction_fixed_of_mem_kernel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SL2CLorentzAction.hermitianLorentzAction_fixed_of_mem_kernel

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CLorentzAction.hermitianLorentzAction_kernel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SL2CLorentzAction.hermitianLorentzAction_kernel

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CLorentzAction.minusIdentity_mem_kernel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SL2CLorentzAction.minusIdentity_mem_kernel

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CLorentzAction.sl2ToEtaLorentz_eq_one_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SL2CLorentzAction.sl2ToEtaLorentz_eq_one_iff

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CLorentzAction.sl2LorentzMatrix_det_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SL2CLorentzAction.sl2LorentzMatrix_det_one

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CLorentzAction.sl2LorentzMatrix_isRestricted' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SL2CLorentzAction.sl2LorentzMatrix_isRestricted

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CLorentzAction.sl2ToRestrictedLorentz_eq_one_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SL2CLorentzAction.sl2ToRestrictedLorentz_eq_one_iff
