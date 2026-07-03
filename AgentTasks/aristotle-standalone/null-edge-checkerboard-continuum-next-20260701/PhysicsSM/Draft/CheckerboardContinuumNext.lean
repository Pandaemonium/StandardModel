import PhysicsSM.Draft.CheckerboardContinuumScaffold

/-!
# Checkerboard continuum-next Aristotle targets

This focused file is for Aristotle. It intentionally lives under
`AgentTasks/aristotle-standalone`, not the live standalone package.

The first targets are finite and should be provable from the existing
checkerboard API:

* turn-count parity determines final direction;
* fixed start/end velocity and fixed turn count have binomial count
  `Nat.choose n k` when parity matches and zero otherwise;
* the unitary isotropic step is a one-parameter group.

After these, Aristotle should audit the outgoing-edge convention against the
Earle/Jacobson-Schulman endpoint-count formulas and recommend the best next
analytic theorem statement.
-/

noncomputable section

namespace PhysicsSM.Draft.CheckerboardContinuumNext

open Matrix
open scoped BigOperators

open PhysicsSM.Draft.Checkerboard1D
open PhysicsSM.Draft.CheckerboardContinuumScaffold

/-- Count fixed-length velocity paths with fixed initial direction, final
direction, and exact turn count. This deliberately ignores spacetime endpoint
counts; it is the velocity-sequence count. -/
def velocityEndpointTurnClassCount (n k : Nat) (inc out : Direction) : Nat :=
  Fintype.card {v : Fin (n + 1) -> Direction //
    v 0 = inc /\ v (Fin.last n) = out /\ turnCountVec v = k}

/-
Aristotle handoff:
Prove the parity invariant for binary direction paths. A clean route may be to
encode directions as `Nat` values modulo 2, or to induct on `n` using
`turnCountVec_cons`.
-/
theorem turnCountVec_mod_two_eq_endpoint (n : Nat)
    (v : Fin (n + 1) -> Direction) :
    turnCountVec v % 2 =
      (if v 0 = v (Fin.last n) then 0 else 1) := by
  sorry

/-
Aristotle handoff:
This is the immediate endpoint direction corollary of
`turnCountVec_mod_two_eq_endpoint`.
-/
theorem endpoint_eq_iff_turnCountVec_even (n : Nat)
    (v : Fin (n + 1) -> Direction) :
    v 0 = v (Fin.last n) <-> turnCountVec v % 2 = 0 := by
  sorry

/-
Aristotle handoff:
There should be a bijection between choosing the `k` transition positions among
the `n` adjacent pairs and binary direction paths with `k` turns and fixed
initial direction. The final direction is forced by parity.
-/
theorem velocityEndpointTurnClassCount_eq_choose (n k : Nat)
    (inc out : Direction) :
    velocityEndpointTurnClassCount n k inc out =
      if k % 2 = (if inc = out then 0 else 1) then Nat.choose n k else 0 := by
  sorry

/-
Aristotle handoff:
The isotropic step is `cos theta * 1 + i sin theta * reversal`, and
`reversal_sq` is already proved. Use trigonometric addition identities to prove
this exact finite one-parameter group law.
-/
theorem isotropicStep_mul (theta phi : Real) :
    isotropicStep theta * isotropicStep phi = isotropicStep (theta + phi) := by
  sorry

/-
Aristotle handoff:
This should follow by induction from `isotropicStep_mul` and
`isotropicStep_zero`. It is the finite algebraic precursor to generator
expansion.
-/
theorem isotropicStep_pow_eq (theta : Real) (n : Nat) :
    isotropicStep theta ^ n = isotropicStep ((n : Real) * theta) := by
  sorry

end PhysicsSM.Draft.CheckerboardContinuumNext
