import Mathlib

/-!
# C109a passive origin polarizer API

This standalone Aristotle target packages finite origin-fiber data for the
controlled non-ultralocal Gate C1 branch.

It is deliberately passive.  An `IsOriginPolarizerCertificate` records only that
the finite origin selector has nonzero chiral trace.  It does not assert a
spectral island, a bad-sector inverse gap, a gauge-covariant branch observable,
Krein positivity, anomaly accounting, path-sum/resolvent control, or Gate C1
release.

The selector uses the standard `Algebra Complex (Matrix n n Complex)` instance
for `Polynomial.aeval`.  The candidate origin observable `B0` and selector
polynomial `p` are intentionally unconstrained here: no commutation, degree,
normalization, gauge, gap, or spectral assumptions belong in C109a.
-/

namespace C109aOriginPolarizerAPI

open Matrix

/-- Finite chiral trace/index proxy used in the origin-fiber test. -/
noncomputable def ChiralTrace {n : Type*} [Fintype n] [DecidableEq n]
    (Gamma P : Matrix n n Complex) : Complex :=
  trace (Gamma * P)

/-- The `J`-odd part of a finite matrix. -/
noncomputable def OddPart {n : Type*} [Fintype n] [DecidableEq n]
    (J P : Matrix n n Complex) : Matrix n n Complex :=
  ((1 / 2 : Complex) • (P - J * P * J))

/--
Passive finite origin data for an origin-polarizer certificate.

This structure intentionally contains no gauge field, spectral-island field,
bad-sector gap, Krein field, anomaly field, path-sum field, or release field.
-/
structure NativeOriginBranchData where
  n : Type
  [fintype : Fintype n]
  [decidableEq : DecidableEq n]
  Gamma0 : Matrix n n Complex
  J0 : Matrix n n Complex
  B0 : Matrix n n Complex
  p : Polynomial Complex
  hJ0_sq : J0 * J0 = (1 : Matrix n n Complex)
  hJ0_anti : J0 * Gamma0 = -(Gamma0 * J0)
  hGamma0_sq : Gamma0 * Gamma0 = (1 : Matrix n n Complex)

namespace NativeOriginBranchData

/-- The finite selector matrix `p(B0)` associated to passive origin data. -/
noncomputable def Selector (D : NativeOriginBranchData) :
    Matrix D.n D.n Complex :=
  Polynomial.aeval D.B0 D.p

/--
Passive origin polarizer certificate: the selected finite origin matrix has
nonzero chiral trace.

This is a proposition over a concrete complex trace inequality, not a Boolean
release flag.
-/
def IsOriginPolarizerCertificate (D : NativeOriginBranchData) : Prop :=
  ChiralTrace D.Gamma0 (Selector D) ≠ (0 : Complex)

/-- Unfold-only access to the defining nonzero trace condition. -/
theorem isOriginPolarizerCertificate_chiralTrace_ne_zero
    (D : NativeOriginBranchData)
    (h : IsOriginPolarizerCertificate D) :
    ChiralTrace D.Gamma0 (Selector D) ≠ (0 : Complex) := by
  exact h

end NativeOriginBranchData

end C109aOriginPolarizerAPI
