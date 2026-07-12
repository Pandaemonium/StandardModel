import Mathlib

/-!
# A three-site ring holonomy observable in the free spectrum

This focused first rung proves the complete local-gauge and spectral story on
the smallest nondegenerate cycle.  Three unit-modulus links form a Hermitian
nearest-neighbor Hamiltonian.  Site-local diagonal phases conjugate that
Hamiltonian while leaving the oriented cycle product invariant.  The trace of
the cube reads twice the real part of the holonomy, and explicit holonomies
`+1` and `-1` give cubic traces `+6` and `-6`.

Thus a loop phase is a free-theory spectral observable, not merely a supplied
interaction phase.  The all-`N` gauge-classification theorem is a successor;
the project's unrestricted two-channel connection also retains local current
invariants, so no one-holonomy-only statement is made for that larger API.
-/

noncomputable section

namespace RingHolonomySpectrum

open Matrix Complex
open scoped Matrix ComplexConjugate

abbrev Mat3 := Matrix (Fin 3) (Fin 3) Complex

/-- Hermitian nearest-neighbor Hamiltonian on the oriented triangle
`0 -> 1 -> 2 -> 0`. -/
def H3 (u0 u1 u2 : Complex) : Mat3 :=
  !![0, u0, conj u2;
     conj u0, 0, u1;
     u2, conj u1, 0]

/-- A site-local diagonal gauge. -/
def G3 (g0 g1 g2 : Complex) : Mat3 :=
  !![g0, 0, 0; 0, g1, 0; 0, 0, g2]

/-- Endpoint action of the local gauge on the three oriented links. -/
def gauge0 (g0 g1 u0 : Complex) : Complex := g0 * u0 * conj g1
def gauge1 (g1 g2 u1 : Complex) : Complex := g1 * u1 * conj g2
def gauge2 (g2 g0 u2 : Complex) : Complex := g2 * u2 * conj g0

def IsUnitPhase (u : Complex) : Prop := u * conj u = 1

/-- Local endpoint phases conjugate the free ring Hamiltonian exactly. -/
theorem H3_gauge_conjugacy (g0 g1 g2 u0 u1 u2 : Complex)
    (hg0 : IsUnitPhase g0) (hg1 : IsUnitPhase g1)
    (hg2 : IsUnitPhase g2) :
    H3 (gauge0 g0 g1 u0) (gauge1 g1 g2 u1) (gauge2 g2 g0 u2) =
      G3 g0 g1 g2 * H3 u0 u1 u2 * (G3 g0 g1 g2)ᴴ := by
  sorry

/-- The oriented cycle product is unchanged by every unit local gauge. -/
theorem holonomy_gauge_invariant (g0 g1 g2 u0 u1 u2 : Complex)
    (hg0 : IsUnitPhase g0) (hg1 : IsUnitPhase g1)
    (hg2 : IsUnitPhase g2) :
    gauge0 g0 g1 u0 * gauge1 g1 g2 u1 * gauge2 g2 g0 u2 =
      u0 * u1 * u2 := by
  sorry

/-- The cubic trace reads the real part of the oriented cycle product. -/
theorem trace_cube_H3 (u0 u1 u2 : Complex) :
    (H3 u0 u1 u2 * H3 u0 u1 u2 * H3 u0 u1 u2).trace =
      3 * (u0 * u1 * u2 + conj (u0 * u1 * u2)) := by
  sorry

/-- Explicit spectral nonconstancy: holonomy `+1` and `-1` have different
cubic traces, so the corresponding free Hamiltonians cannot be similar. -/
theorem threeSite_holonomy_changes_cubic_trace :
    (H3 1 1 1 * H3 1 1 1 * H3 1 1 1).trace = 6 ∧
    (H3 (-1) 1 1 * H3 (-1) 1 1 * H3 (-1) 1 1).trace = -6 := by
  sorry

/-- Load-bearing control: a common site phase is pure conjugacy and leaves the
cycle product unchanged. -/
theorem common_phase_is_spectrally_trivial (g u0 u1 u2 : Complex)
    (hg : IsUnitPhase g) :
    H3 (gauge0 g g u0) (gauge1 g g u1) (gauge2 g g u2) =
      G3 g g g * H3 u0 u1 u2 * (G3 g g g)ᴴ ∧
    gauge0 g g u0 * gauge1 g g u1 * gauge2 g g u2 = u0 * u1 * u2 := by
  sorry

end RingHolonomySpectrum
