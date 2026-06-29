import Mathlib

/-!
# C108b nontrivial branch-observable component

This standalone Aristotle target is the constructive complement to the C108
origin rejection certificate.

C108 says: if a branch observable `B` commutes with the balance symmetry `J`,
then polynomial selectors `p(B)` have zero chiral trace.  C108b asks for the
algebraic contrapositive in a useful decomposed form: if a polynomial selector
has nonzero chiral trace, then `B` must have a nonzero component that is odd
under `J`.

This is finite matrix algebra only. It does not construct a physical branch
observable or prove Gate C1 release.
-/

namespace C108bNontrivialBranchObservable

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Finite chiral trace/index proxy used in the origin-fiber test. -/
noncomputable def ChiralTrace (Gamma P : Matrix n n Complex) : Complex :=
  trace (Gamma * P)

/-- The `J`-even part of a matrix. -/
noncomputable def EvenPart (J B : Matrix n n Complex) : Matrix n n Complex :=
  ((1 / 2 : Complex) • (B + J * B * J))

/-- The `J`-odd part of a matrix. -/
noncomputable def OddPart (J B : Matrix n n Complex) : Matrix n n Complex :=
  ((1 / 2 : Complex) • (B - J * B * J))

/--
If `J` is an involution, `J` anti-commutes with `Gamma`, and `P` commutes with
`J`, then the chiral trace of `P` is zero.
-/
theorem chiralTrace_zero_of_balance_commuting_projector
    (Gamma J P : Matrix n n Complex)
    (hJ2 : J * J = 1)
    (hAnti : J * Gamma = -(Gamma * J))
    (hCommP : J * P = P * J) :
    ChiralTrace Gamma P = 0 := by
  unfold ChiralTrace
  have h_trace_cyclic : trace (J * Gamma * P * J) = trace (Gamma * P * J * J) := by
    convert Matrix.trace_mul_comm _ _ using 2
    · simp +decide [mul_assoc, hJ2]
    · simp +decide [← mul_assoc, hJ2]
  simp_all +decide [mul_assoc, trace_mul_comm Gamma]
  linear_combination' -h_trace_cyclic / 2

/-- If `B` commutes with `J`, then every polynomial in `B` commutes with `J`. -/
theorem polynomial_aeval_commutes_of_commutes
    (B J : Matrix n n Complex) (p : Polynomial Complex)
    (hCommB : J * B = B * J) :
    J * Polynomial.aeval B p = Polynomial.aeval B p * J := by
  induction' p using Polynomial.induction_on' with p q hp hq
  · simp +decide [*, mul_add, add_mul]
  · induction' ‹ℕ› with n ih <;> simp_all +decide [pow_succ, ← mul_assoc]
    · simp +decide [Algebra.commutes]
    · simp +decide [mul_assoc, hCommB]

/--
If a candidate branch observable has a polynomial selector with nonzero chiral
trace, then its `J`-odd component is nonzero.
-/
theorem nonzero_chiralTrace_requires_nonzero_odd_component
    (Gamma J B : Matrix n n Complex) (p : Polynomial Complex)
    (hJ2 : J * J = 1)
    (hAnti : J * Gamma = -(Gamma * J))
    (hNonzero : ChiralTrace Gamma (Polynomial.aeval B p) ≠ 0) :
    B = EvenPart J B + OddPart J B ∧
    J * EvenPart J B = EvenPart J B * J ∧
    J * OddPart J B = -(OddPart J B * J) ∧
    OddPart J B ≠ 0 := by
  refine' ⟨_, _, _, _⟩
  · unfold EvenPart OddPart
    ext i j
    norm_num
    ring
  · unfold EvenPart
    simp +decide [mul_add, add_mul, mul_assoc]
    simp +decide [← mul_assoc, hJ2]
    abel_nf
  · unfold OddPart
    simp +decide [mul_sub, sub_mul, ← mul_assoc, hJ2]
    simp +decide [mul_assoc, hJ2]
    rw [← smul_neg, neg_sub]
  · contrapose! hNonzero
    have hB_eq : B = J * B * J := by
      unfold OddPart at hNonzero
      simpa [sub_eq_zero] using hNonzero
    have h_comm : J * B = B * J := by
      convert congr_arg (fun x => J * x) hB_eq using 1
      · simp +decide [mul_assoc, hJ2]
      · simp +decide [← mul_assoc, hJ2]
    exact chiralTrace_zero_of_balance_commuting_projector Gamma J _
      hJ2 hAnti (polynomial_aeval_commutes_of_commutes B J p h_comm)

end C108bNontrivialBranchObservable
