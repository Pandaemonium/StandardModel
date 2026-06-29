import Mathlib

/-!
# C108 path-sum control for non-ultralocal Gate C1

Standalone finite theorem target for Aristotle.

This module is a small analytic/combinatorial proxy for the C1_NL path-sum
policy. The primitive non-ultralocal control is not "exponential locality" by
definition. Instead, a path class has a counting bound and each path amplitude
has a damping bound. Exponential or summable tails should then be derived as a
corollary when path entropy is subcritical.

Project reading:

* `pathCount n` bounds the number/weight of allowed paths of length `n`.
* `ampBound n` bounds the absolute amplitude of an allowed length-`n` path.
* `term n = pathCount n * ampBound n` bounds the total absolute contribution
  from paths of length `n`.
* If `pathCount n <= C * b^n`, `ampBound n <= A * a^n`, and `a*b < 1`, then
  the total path-length contribution is summable.
-/

namespace C108PathSumControl

open scoped BigOperators

/-- Length-by-length absolute contribution bound for a path-sum kernel. -/
def PathLengthContribution
    (pathCount ampBound : Nat -> Real) : Nat -> Real :=
  fun n => pathCount n * ampBound n

/--
Subcritical path entropy/damping implies summability of the length-by-length
absolute path contribution.

This is the finite/combinatorial heart of the path-sum locality policy:
exponential tail control appears as a theorem from path-count growth and
per-path damping, not as a primitive assumption.
-/
theorem summable_pathLengthContribution_of_geometric_bounds
    (pathCount ampBound : Nat -> Real)
    (C A a b : Real)
    (hC : 0 <= C)
    (hA : 0 <= A)
    (ha : 0 <= a)
    (hb : 0 <= b)
    (hab : a * b < 1)
    (hcount_nonneg : forall n, 0 <= pathCount n)
    (hamp_nonneg : forall n, 0 <= ampBound n)
    (hcount : forall n, pathCount n <= C * b ^ n)
    (hamp : forall n, ampBound n <= A * a ^ n) :
    Summable (PathLengthContribution pathCount ampBound) := by
  sorry

/--
A tail version suitable for future Gate C1_NL APIs: under the same hypotheses,
the contribution from lengths at or beyond any base length is summable.
-/
theorem summable_shifted_pathLengthContribution_of_geometric_bounds
    (pathCount ampBound : Nat -> Real)
    (C A a b : Real)
    (N : Nat)
    (hC : 0 <= C)
    (hA : 0 <= A)
    (ha : 0 <= a)
    (hb : 0 <= b)
    (hab : a * b < 1)
    (hcount_nonneg : forall n, 0 <= pathCount n)
    (hamp_nonneg : forall n, 0 <= ampBound n)
    (hcount : forall n, pathCount n <= C * b ^ n)
    (hamp : forall n, ampBound n <= A * a ^ n) :
    Summable (fun k => PathLengthContribution pathCount ampBound (N + k)) := by
  sorry

end C108PathSumControl
