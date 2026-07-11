import Mathlib

/-!
# Automorphism quotient of the finite Ward witness

This module classifies the complex matrices that commute with the finite Ward
charge and preserve its Krein form.  It computes their action on the
one-dimensional physical line and proves that physical-identity automorphisms
differ from the identity by an explicit constraint-exact term.

The initially proposed condition `U.conjTranspose * G * U = 1` was false: the
Krein Gram `G` is not the identity.  The exact imaginary-shear counterexample
has all proposed coordinate properties but satisfies `U.conjTranspose * G * U
= G`.  The theorem therefore uses the standard and minimal form-preservation
condition `U.conjTranspose * G * U = G`.

Scope: the concrete three-dimensional Ward witness.  This is not a
classification of full null-edge carrier automorphisms and does not impose
graph locality, soldering, gauge, grading, or Clifford constraints.

Provenance: corrected theorem and proofs from Aristotle project
`7399f4a8-60eb-4f69-a373-fbcda8367007`.  The false frozen condition was also
found independently in `WARD_AUTOMORPHISM_AUDIT_2026-07-11.md`.  The returned
source was independently compiled against the pinned toolchain.

Lean 4.28.0.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient

open Complex

abbrev Mat3 := Matrix (Fin 3) (Fin 3) Complex

def Q : Mat3 := !![0, 1, 0; 0, 0, 0; 0, 0, 0]

def G : Mat3 := !![0, 1, 0; 1, 0, 0; 0, 0, 1]

def physI : Matrix (Fin 3) (Fin 1) Complex := !![0; 0; 1]

def physP : Matrix (Fin 1) (Fin 3) Complex := !![0, 0, 1]

def contractS : Mat3 := !![0, 0, 0; 1, 0, 0; 0, 0, 0]

def wardFamily (a b c d e : Complex) : Mat3 :=
  !![a, b, c; 0, a, 0; 0, d, e]

/-- A Ward automorphism commutes with `Q` and preserves the Krein Gram `G`. -/
def IsWardAutomorphism (U : Mat3) : Prop :=
  U * Q = Q * U /\ U.conjTranspose * G * U = G

/-- Every charge-commuting matrix has exactly the displayed five-parameter
upper-block form. -/
theorem commutes_Q_iff_family (U : Mat3) :
    U * Q = Q * U <->
      Exists fun a : Complex => Exists fun b : Complex =>
        Exists fun c : Complex => Exists fun d : Complex =>
          Exists fun e : Complex => U = wardFamily a b c d e := by
  constructor
  · intro h
    unfold Q at h
    simp_all +decide [← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply]
    simp_all +decide [Fin.sum_univ_succ, Matrix.vecMul]
    unfold wardFamily
    simp +decide [Matrix.vecHead, Matrix.vecTail] at *
    grind
  · rintro ⟨a, b, c, d, e, rfl⟩
    ext i j
    fin_cases i <;> fin_cases j <;> simp +decide [Q, wardFamily]

/-- Exact Krein-form-preservation equations inside the charge-commuting
family.  The conjugate mixed equation is derived from the displayed third
equation inside the proof. -/
theorem wardFamily_kreinUnitary_iff (a b c d e : Complex) :
    (wardFamily a b c d e).conjTranspose * G * wardFamily a b c d e = G <->
      star a * a = 1 /\
      star e * e = 1 /\
      star a * c + star d * e = 0 /\
      star b * a + star a * b + star d * d = 0 := by
  constructor <;> intro h
  · unfold wardFamily G at h
    norm_num [← Matrix.ext_iff, Fin.forall_fin_succ] at h
    norm_num [Matrix.mul_apply, Fin.sum_univ_succ] at h
    simp_all +decide [add_comm, add_assoc]
  · obtain ⟨h1, h2, h3, h4⟩ := h
    have h3' : star c * a + star e * d = 0 := by
      simpa [mul_comm] using congrArg Star.star h3
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [G, wardFamily, Matrix.mul_apply, Fin.sum_univ_succ] <;>
      simp_all [add_comm, add_assoc]

/-- Full coordinate classification of the finite Ward automorphism group. -/
theorem wardAutomorphism_classification (U : Mat3) :
    IsWardAutomorphism U <->
      Exists fun a : Complex => Exists fun b : Complex =>
        Exists fun c : Complex => Exists fun d : Complex =>
          Exists fun e : Complex =>
            U = wardFamily a b c d e /\
            star a * a = 1 /\
            star e * e = 1 /\
            star a * c + star d * e = 0 /\
            star b * a + star a * b + star d * d = 0 := by
  simp +decide only [IsWardAutomorphism]
  grind +suggestions

/-- The induced action on the physical line is exactly the final coordinate
`e`; the null-sector shear coordinates are invisible after compression. -/
theorem physical_compression_family (a b c d e : Complex) :
    physP * wardFamily a b c d e * physI = !![e] := by
  ext i j
  unfold physP wardFamily physI
  fin_cases i
  fin_cases j
  norm_num [Matrix.mul_apply, Fin.sum_univ_succ]

/-- Explicit homotopy for an automorphism whose physical action is the
identity. -/
def identityKernelHomotopy (U : Mat3) : Mat3 :=
  contractS * (U - 1) + (physI * physP) * (U - 1) * contractS

theorem physical_identity_is_exact (U : Mat3)
    (hcomm : U * Q = Q * U) (hphys : physP * U * physI = 1) :
    U - 1 = Q * identityKernelHomotopy U + identityKernelHomotopy U * Q := by
  unfold identityKernelHomotopy
  simp +decide [← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply] at *
  simp +decide [Fin.sum_univ_succ, Q, contractS, physI, physP] at *
  exact ⟨⟨hcomm.2.1, hcomm.1.2.1.symm, hcomm.1.2.2.symm⟩,
    hcomm.2.2, sub_eq_zero.mpr hphys⟩

/-- Nontrivial kernel witness: an imaginary null-sector shear is a Ward
automorphism, is not the identity, acts identically on the physical line, and
is constraint-exact. -/
theorem nontrivial_exact_shear_witness :
    let U := wardFamily 1 Complex.I 0 0 1
    IsWardAutomorphism U /\
      Ne U 1 /\
      physP * U * physI = 1 /\
      (Exists fun H : Mat3 => U - 1 = Q * H + H * Q) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · constructor <;>
      norm_num [← List.ofFn_inj, IsWardAutomorphism, Q, G, physI, physP, wardFamily]
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_succ]
  · intro h
    have := congrFun (congrFun h 0) 1
    norm_num [wardFamily] at this
  · convert physical_compression_family 1 Complex.I 0 0 1 using 1
    ext i j
    fin_cases i
    fin_cases j
    rfl
  · use !![Complex.I, 0, 0; 0, 0, 0; 0, 0, 0]
    ext i j
    fin_cases i <;> fin_cases j <;> norm_num [Q, wardFamily]

/-- Negative control: a genuine physical phase is a Ward automorphism but its
difference from the identity is not constraint-exact. -/
theorem physical_phase_not_exact_control :
    let U := wardFamily 1 0 0 0 Complex.I
    IsWardAutomorphism U /\
      physP * U * physI = !![Complex.I] /\
      Not (Exists fun H : Mat3 => U - 1 = Q * H + H * Q) := by
  refine ⟨?_, ?_, ?_⟩
  · constructor <;> norm_num [wardFamily, Q, G]
    · ext i
      fin_cases i
    · ext i j
      fin_cases i <;> fin_cases j <;>
        norm_num [Matrix.mul_apply, Fin.sum_univ_succ]
  · convert physical_compression_family 1 0 0 0 Complex.I using 1
  · simp +decide [← Matrix.ext_iff]
    intro x
    use 2, 2
    simp +decide [Q, wardFamily, Matrix.mul_apply]
    norm_num [Fin.sum_univ_succ, Complex.ext_iff]

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient.wardAutomorphism_classification' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms wardAutomorphism_classification

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient.physical_identity_is_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physical_identity_is_exact

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient.nontrivial_exact_shear_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nontrivial_exact_shear_witness

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient.physical_phase_not_exact_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physical_phase_not_exact_control

end PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient
