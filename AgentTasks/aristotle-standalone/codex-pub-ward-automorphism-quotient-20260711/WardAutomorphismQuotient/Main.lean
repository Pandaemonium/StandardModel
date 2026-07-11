import Mathlib

/-!
# Automorphism quotient of the finite Ward witness

This focused target classifies the complex matrices that commute with the
finite Ward charge and preserve its Krein form.  It then computes their action
on the one-dimensional physical line and proves that physical-identity
automorphisms differ from the identity by an explicit constraint-exact term.

The theorem is deliberately scoped to the concrete three-dimensional Ward
witness.  It does not classify automorphisms of the full null-edge carrier or
impose graph locality, soldering, gauge, or Clifford constraints.
-/

noncomputable section

namespace WardAutomorphismQuotient

open Complex

abbrev Mat3 := Matrix (Fin 3) (Fin 3) Complex

def Q : Mat3 := !![0, 1, 0; 0, 0, 0; 0, 0, 0]

def G : Mat3 := !![0, 1, 0; 1, 0, 0; 0, 0, 1]

def physI : Matrix (Fin 3) (Fin 1) Complex := !![0; 0; 1]

def physP : Matrix (Fin 1) (Fin 3) Complex := !![0, 0, 1]

def contractS : Mat3 := !![0, 0, 0; 1, 0, 0; 0, 0, 0]

def wardFamily (a b c d e : Complex) : Mat3 :=
  !![a, b, c; 0, a, 0; 0, d, e]

def IsWardAutomorphism (U : Mat3) : Prop :=
  U * Q = Q * U /\ U.conjTranspose * G * U = 1

/-- Every charge-commuting matrix has exactly the displayed five-parameter
upper-block form. -/
theorem commutes_Q_iff_family (U : Mat3) :
    U * Q = Q * U <->
      Exists fun a : Complex => Exists fun b : Complex =>
        Exists fun c : Complex => Exists fun d : Complex =>
          Exists fun e : Complex => U = wardFamily a b c d e := by
  sorry

/-- Exact Krein-unitary equations inside the charge-commuting family. -/
theorem wardFamily_kreinUnitary_iff (a b c d e : Complex) :
    (wardFamily a b c d e).conjTranspose * G * wardFamily a b c d e = 1 <->
      star a * a = 1 /\
      star e * e = 1 /\
      star a * c + star d * e = 0 /\
      star b * a + star a * b + star d * d = 0 := by
  sorry

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
  sorry

/-- The induced action on the physical line is exactly the final coordinate
`e`; the null-sector shear coordinates are invisible after compression. -/
theorem physical_compression_family (a b c d e : Complex) :
    physP * wardFamily a b c d e * physI = !![e] := by
  sorry

/-- Explicit homotopy for an automorphism whose physical action is the
identity. -/
def identityKernelHomotopy (U : Mat3) : Mat3 :=
  contractS * (U - 1) + (physI * physP) * (U - 1) * contractS

theorem physical_identity_is_exact (U : Mat3)
    (hcomm : U * Q = Q * U) (hphys : physP * U * physI = 1) :
    U - 1 = Q * identityKernelHomotopy U + identityKernelHomotopy U * Q := by
  sorry

/-- Nontrivial kernel witness: an imaginary null-sector shear is a Ward
automorphism, is not the identity matrix, acts identically on the physical
line, and is constraint-exact. -/
theorem nontrivial_exact_shear_witness :
    let U := wardFamily 1 Complex.I 0 0 1
    IsWardAutomorphism U /\
      Ne U 1 /\
      physP * U * physI = 1 /\
      (Exists fun H : Mat3 => U - 1 = Q * H + H * Q) := by
  sorry

/-- Negative control: a genuine physical phase is a Ward automorphism but its
difference from the identity is not constraint-exact. -/
theorem physical_phase_not_exact_control :
    let U := wardFamily 1 0 0 0 Complex.I
    IsWardAutomorphism U /\
      physP * U * physI = !![Complex.I] /\
      Not (Exists fun H : Mat3 => U - 1 = Q * H + H * Q) := by
  sorry

end WardAutomorphismQuotient
