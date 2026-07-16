import PhysicsSM.Draft.NullEdge.HNUInfraredTangent
import PhysicsSM.Draft.NullEdge.PluckerMassOperator
import PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

/-!
# An explicit HNU--Pluecker bridge after four-component doubling

This module composes three existing finite results without reproducing their
definitions.  The HNU endpoint has the infrared tangent `-i q.sigma`; the live
four-component Pluecker operator has the usual massless Dirac kinetic block;
and the two Pluecker rest operators are related by one explicit rectangular
intertwiner `W`.

The scope boundary is essential.  The theorem does **not** derive the Pluecker
coordinate from the HNU endpoint, and it does not make one two-component HNU
Weyl point massive.  Indeed, `singleWeyl_mass_noGo` proves that no nonzero
`2 x 2` matrix anticommutes with all three Pauli velocity generators.  The
compatible mass appears only after passing to the live four-component
Clifford representation.  The displayed `W` is an explicit compatible
embedding; no uniqueness or canonicity claim is made.

Conventions: the Pauli matrices are those of `HNUExactCore`; the four-component
Dirac matrices are those of `Pluecker3Plus1ComplexMass`; and the complex rest
operator is `PluckerMassOperator.massOperator`.  These imported modules already
record their metric, basis, and Pluecker conventions.

Provenance: clean-room integration of the mathematically valid subset of
Aristotle project `f0d38cd0-cdec-46ef-800b-b588e3e07740`, task
`c9f31d7f-a8ae-4ade-9d36-e03b2db004a9`.  The returned file duplicated the live
APIs and described `W` as forced; this integration instead reuses the live APIs
and retains only the proved explicit-existence statement.
-/

noncomputable section

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUInfraredTangent
open PhysicsSM.Draft.NullEdge.PluckerMassOperator
open PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

namespace PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner

/-- ASCII local name for the first HNU Pauli generator. -/
def pauli1 : M2 := σ1

/-- ASCII local name for the second HNU Pauli generator. -/
def pauli2 : M2 := σ2

/-- ASCII local name for the third HNU Pauli generator. -/
def pauli3 : M2 := σ3

/-- The Hermitian one-Weyl symbol `q.sigma` selected by the HNU tangent. -/
def weylSymbol (q : Fin 3 -> Real) : M2 :=
  ((q 0 : Real) : Complex) • pauli1 +
    ((q 1 : Real) : Complex) • pauli2 +
    ((q 2 : Real) : Complex) • pauli3

/-- The massless kinetic part of the live four-component Dirac symbol. -/
def kinetic4 (q : Fin 3 -> Real) : Mat4 :=
  (q 0 : Complex) • alpha1 + (q 1 : Complex) • alpha2 +
    (q 2 : Complex) • alpha3

/-- Extract the upper-right `2 x 2` block from a `4 x 4` matrix. -/
def topRight (A : Mat4) : M2 :=
  Matrix.of fun i j => A (Fin.castAdd 2 i) (Fin.natAdd 2 j)

/-- The upper-right block of the live massless `3+1` kinetic operator is the
HNU Weyl symbol in the shared Pauli convention. -/
theorem topRight_kinetic4 (q : Fin 3 -> Real) :
    topRight (kinetic4 q) = weylSymbol q := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [topRight, kinetic4, weylSymbol, alpha1, alpha2, alpha3,
      pauli1, pauli2, pauli3, σ1, σ2, σ3, Fin.castAdd, Fin.natAdd]

/-- The HNU endpoint tangent is `-i` times the upper-right kinetic block of the
live four-component massless Dirac representation. -/
theorem endpoint_kinetic_block_hasDerivAt (q : Fin 3 -> Real) :
    HasDerivAt (fun t : Real => endpoint (fun i => t * q i))
      ((-I) • topRight (kinetic4 q)) 0 := by
  simpa [topRight_kinetic4, weylSymbol, pauli1, pauli2, pauli3] using
    endpoint_ray_hasDerivAt q

/-- One explicit Clifford-compatible embedding of two-component Pluecker rest
data into the live four-component representation.  This definition carries no
uniqueness claim. -/
def W : Matrix (Fin 4) (Fin 2) Complex :=
  !![1, 1; 0, 0; -1, 1; 0, 0]

/-- The first four-component mass generator restricts through `W` to `pauli1`. -/
theorem beta_W : beta * W = W * pauli1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [beta, W, pauli1, σ1, Matrix.mul_apply, Fin.sum_univ_four]

/-- The second four-component mass generator restricts through `W` to
`-pauli2`. -/
theorem beta5_W : beta5 * W = -(W * pauli2) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [beta5, beta, gamma5, W, pauli2, σ2, Matrix.mul_apply,
      Fin.sum_univ_four]

/-- The two columns of `W` are orthogonal and have squared norm two. -/
theorem W_conjTranspose_mul_W : Wᴴ * W = (2 : Complex) • (1 : M2) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [W, Matrix.mul_apply, Fin.sum_univ_four, Matrix.conjTranspose] <;>
      norm_num

/-- The live two-component Pluecker rest operator is the Pauli-plane operator
`Re(z) pauli1 - Im(z) pauli2`. -/
theorem massOperator_pauli (z : Complex) :
    massOperator z = (z.re : Complex) • pauli1 - (z.im : Complex) • pauli2 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [massOperator, pauli1, pauli2, σ1, σ2, Complex.ext_iff]

/-- **Explicit doubled mass bridge.**  The same complex Pluecker coordinate
acts on the two-component rest space and the live four-component mass space,
intertwined by the fixed matrix `W`. -/
theorem mass_intertwiner (z : Complex) :
    mass4 z * W = W * massOperator z := by
  have hexpand :
      mass4 z * W =
        (z.re : Complex) • (beta * W) +
          (z.im : Complex) • (beta5 * W) := by
    simp only [mass4, Matrix.add_mul, Matrix.smul_mul]
  rw [hexpand, beta_W, beta5_W, massOperator_pauli, Matrix.mul_sub,
    Matrix.mul_smul, Matrix.mul_smul, smul_neg, sub_eq_add_neg]

/-- The two-component Pluecker rest operator is the normalized compression of
the live four-component mass operator along the explicit embedding `W`. -/
theorem massOperator_is_compression (z : Complex) :
    (2 : Complex)⁻¹ • (Wᴴ * mass4 z * W) = massOperator z := by
  have hcompressed :
      Wᴴ * mass4 z * W = (2 : Complex) • massOperator z := by
    rw [Matrix.mul_assoc, mass_intertwiner, <- Matrix.mul_assoc,
      W_conjTranspose_mul_W, Matrix.smul_mul, Matrix.one_mul]
  rw [hcompressed, smul_smul]
  norm_num

/-- **Single-Weyl mass no-go.**  A `2 x 2` matrix anticommuting with all three
HNU Pauli velocity generators is zero.  Thus the compatible relativistic mass
bridge above genuinely needs a larger representation. -/
theorem singleWeyl_mass_noGo (M : M2)
    (h1 : M * pauli1 + pauli1 * M = 0)
    (h2 : M * pauli2 + pauli2 * M = 0)
    (h3 : M * pauli3 + pauli3 * M = 0) :
    M = 0 := by
  have g00 := congrFun (congrFun h3 0) 0
  have g11 := congrFun (congrFun h3 1) 1
  have f00 := congrFun (congrFun h1 0) 0
  have s00 := congrFun (congrFun h2 0) 0
  simp only [Matrix.add_apply, Matrix.mul_apply, Fin.sum_univ_two,
    pauli1, pauli2, pauli3, σ1, σ2, σ3, Matrix.zero_apply, Matrix.of_apply,
    Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.empty_val', Matrix.cons_val_fin_one] at g00 g11 f00 s00
  have hM00 : M 0 0 = 0 := by linear_combination g00 / 2
  have hM11 : M 1 1 = 0 := by linear_combination -g11 / 2
  have hM01 : M 0 1 = 0 := by
    have hpair :
        M 0 1 * I + M 1 0 * (-I) = 0 ∧ M 0 1 + M 1 0 = 0 :=
      ⟨by linear_combination s00, by linear_combination f00⟩
    have hx : M 0 1 * (2 * I) = 0 := by
      linear_combination hpair.1 + I * hpair.2
    have hI : (2 * I : Complex) ≠ 0 := by simp [Complex.I_ne_zero]
    exact (mul_eq_zero.mp hx).resolve_right hI
  have hM10 : M 1 0 = 0 := by linear_combination f00 - hM01
  ext i j
  fin_cases i <;> fin_cases j <;> simp_all

/-- The two-component Pluecker rest operator anticommutes with `pauli3`, but
its `pauli1` anticommutator exposes `2 Re(z)`.  It is therefore not itself a
mass for the three-velocity HNU Weyl point. -/
theorem massOperator_not_singleWeyl_mass (z : Complex) :
    massOperator z * pauli3 + pauli3 * massOperator z = 0 ∧
      massOperator z * pauli1 + pauli1 * massOperator z =
        (2 * z.re : Complex) • (1 : M2) := by
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [massOperator, pauli3, σ3]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [massOperator, pauli1, σ1, Complex.ext_iff] <;> ring

/-- A nondegenerate Gaussian-rational control: the same `3 + 4i` coordinate
intertwines exactly, compresses exactly, and gives a nonzero operator with
squared gap `25`. -/
theorem three_four_I_control :
    mass4 (3 + 4 * I) * W = W * massOperator (3 + 4 * I) ∧
      (2 : Complex)⁻¹ • (Wᴴ * mass4 (3 + 4 * I) * W) =
        massOperator (3 + 4 * I) ∧
      massOperator (3 + 4 * I) * massOperator (3 + 4 * I) =
        (25 : Complex) • (1 : M2) ∧
      massOperator (3 + 4 * I) ≠ 0 := by
  refine ⟨mass_intertwiner _, massOperator_is_compression _, ?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [massOperator, Matrix.mul_apply, Fin.sum_univ_two,
        Complex.ext_iff] <;> norm_num
  · intro h
    have h01 := congrFun (congrFun h 0) 1
    simp [massOperator, Complex.ext_iff] at h01

end PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner

/-! Build-enforced axiom-footprint guards for the composition headlines. -/

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.endpoint_kinetic_block_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.endpoint_kinetic_block_hasDerivAt

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.mass_intertwiner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.mass_intertwiner

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.massOperator_is_compression' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.massOperator_is_compression

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.singleWeyl_mass_noGo' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.singleWeyl_mass_noGo

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.three_four_I_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.three_four_I_control
