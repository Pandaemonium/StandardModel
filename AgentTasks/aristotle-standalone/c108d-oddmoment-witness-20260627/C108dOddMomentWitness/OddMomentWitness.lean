import Mathlib

/-!
# C108d odd-moment witness and nonzero trace criterion

This standalone Aristotle target is the finite non-vacuity successor to
C108/C108b/C108c.

C108c proves that the chiral trace only sees the `J`-odd part. This file asks
for two small next steps:

1. package the nonzero version of that identity as an iff;
2. exhibit an explicit 2 by 2 finite witness where `J` flips chirality, the
   selector has nonzero chiral trace, and the odd part is nonzero.

This is finite matrix algebra only. It does not construct a null-edge branch
observable and does not prove Gate C1 release.
-/

namespace C108dOddMomentWitness

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Finite chiral trace/index proxy used in the origin-fiber test. -/
noncomputable def ChiralTrace (Gamma P : Matrix n n Complex) : Complex :=
  trace (Gamma * P)

/-- The `J`-even part of a matrix. -/
noncomputable def EvenPart (J P : Matrix n n Complex) : Matrix n n Complex :=
  ((1 / 2 : Complex) • (P + J * P * J))

/-- The `J`-odd part of a matrix. -/
noncomputable def OddPart (J P : Matrix n n Complex) : Matrix n n Complex :=
  ((1 / 2 : Complex) • (P - J * P * J))

omit [DecidableEq n] in
/-- The even and odd parts add back to the original matrix. -/
theorem evenPart_add_oddPart
    (J P : Matrix n n Complex) :
    EvenPart J P + OddPart J P = P := by
  unfold EvenPart OddPart; ext i j; norm_num; ring;

/--
If `J` is an involution and anti-commutes with `Gamma`, then the chiral trace of
any matrix equals the chiral trace of its `J`-odd part.
-/
theorem chiralTrace_eq_chiralTrace_oddPart
    (Gamma J P : Matrix n n Complex)
    (hJ2 : J * J = 1)
    (hAnti : J * Gamma = -(Gamma * J)) :
    ChiralTrace Gamma P = ChiralTrace Gamma (OddPart J P) := by
  -- Using the anti-commutation relation `J * Gamma = -(Gamma * J)`, we can rewrite the trace.
  have h_tr_comm : trace (Gamma * J * P * J) = -trace (Gamma * P) := by
    rw [ ← Matrix.trace_mul_comm ] ; simp_all +decide [ Matrix.mul_assoc ] ;
    simp +decide [ ← Matrix.mul_assoc, hAnti ];
    simp +decide [ mul_assoc, hJ2 ];
  unfold ChiralTrace OddPart; norm_num [ h_tr_comm, mul_assoc ]
  simp_all +decide [ mul_sub, ← mul_assoc ]; ring

/--
Nonzero version of C108c: a finite selector has nonzero chiral trace iff its
`J`-odd part has nonzero chiral trace.
-/
theorem chiralTrace_ne_zero_iff_oddPart
    (Gamma J P : Matrix n n Complex)
    (hJ2 : J * J = 1)
    (hAnti : J * Gamma = -(Gamma * J)) :
    ChiralTrace Gamma P ≠ 0 ↔
      ChiralTrace Gamma (OddPart J P) ≠ 0 := by
  rw [ chiralTrace_eq_chiralTrace_oddPart Gamma J P hJ2 hAnti ]

/-- The two-state chirality matrix `diag(1,-1)`. -/
noncomputable def Gamma2 : Matrix (Fin 2) (Fin 2) Complex :=
  !![(1 : Complex), 0; 0, (-1 : Complex)]

/-- The two-state balance-flip matrix. -/
noncomputable def Jswap2 : Matrix (Fin 2) (Fin 2) Complex :=
  !![(0 : Complex), 1; 1, (0 : Complex)]

/--
Concrete finite non-vacuity witness: with `B = Gamma2` and selector `p = X`,
the balance symmetry flips chirality, the odd part is nonzero, and the selector
has nonzero chiral trace.
-/
theorem concrete_two_by_two_odd_witness :
    Jswap2 * Jswap2 = 1 ∧
    Jswap2 * Gamma2 = -(Gamma2 * Jswap2) ∧
    OddPart Jswap2 Gamma2 = Gamma2 ∧
    ChiralTrace Gamma2 (Polynomial.aeval Gamma2 (Polynomial.X : Polynomial Complex)) = 2 ∧
    ChiralTrace Gamma2 (Polynomial.aeval Gamma2 (Polynomial.X : Polynomial Complex)) ≠ 0 := by
  refine' ⟨ _, _, _, _ ⟩;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Jswap2 ];
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Jswap2, Gamma2 ];
  · unfold OddPart Gamma2 Jswap2; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply ] ;
  · unfold ChiralTrace Gamma2; norm_num [ Matrix.trace ] ;

/--
Optional hardening: a less trivial selector `p = X ^ 2 + X` still has nonzero
chiral trace for the same `Gamma2`, `Jswap2`, and `B = Gamma2`. Here
`aeval Gamma2 (X ^ 2 + X) = Gamma2 ^ 2 + Gamma2 = diag(2, 0)`, whose chiral
trace is again `2`.
-/
theorem concrete_two_by_two_odd_witness_quadratic :
    ChiralTrace Gamma2
        (Polynomial.aeval Gamma2
          ((Polynomial.X : Polynomial Complex) ^ 2 + Polynomial.X)) = 2 ∧
    ChiralTrace Gamma2
        (Polynomial.aeval Gamma2
          ((Polynomial.X : Polynomial Complex) ^ 2 + Polynomial.X)) ≠ 0 := by
  have h : ChiralTrace Gamma2
      (Polynomial.aeval Gamma2
        ((Polynomial.X : Polynomial Complex) ^ 2 + Polynomial.X)) = 2 := by
    unfold ChiralTrace Gamma2
    simp [Matrix.trace, Fin.sum_univ_two, pow_two, map_add]
    norm_num
  exact ⟨h, by rw [h]; norm_num⟩

end C108dOddMomentWitness
