import Mathlib

/-!
# A three-site ring holonomy observable in the free spectrum

Three unit-modulus links form a Hermitian nearest-neighbor Hamiltonian on the
smallest nondegenerate cycle. Site-local diagonal phases conjugate the
Hamiltonian while leaving the oriented cycle product invariant. The trace of
the cube reads `3 * (holonomy + conjugate holonomy)`, i.e. six times the real
part of that holonomy (`trace_cube_H3`), and explicit holonomies
`+1` and `-1` give cubic traces `+6` and `-6`. A final corollary turns that
trace witness into a formal obstruction to unitary conjugacy.

This is the exact reduced transport-sector theorem. The unrestricted
two-channel connection in `GaugeClassification` also retains local current
invariants, so this module does not assert that its full spectrum depends on a
single holonomy.

Provenance: the first five theorems were completed by Aristotle project
`deed60d0-1436-43d1-99ca-3fb4aca5ed0c`, task
`f02f93fb-cb32-4fa4-896d-3c9b0f51c9c0`, from a target prepared after the
2026-07-12 Fable impact review. The nonconjugacy corollary is a clean-room
composition with Mathlib's cyclicity of matrix trace. Lean 4.28.0.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.RingHolonomySpectrum

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

/-- A complex number is represented in the unit phase group. -/
def IsUnitPhase (u : Complex) : Prop := u * conj u = 1

/-- Local endpoint phases conjugate the free ring Hamiltonian exactly. -/
theorem H3_gauge_conjugacy (g0 g1 g2 u0 u1 u2 : Complex)
    (hg0 : IsUnitPhase g0) (hg1 : IsUnitPhase g1)
    (hg2 : IsUnitPhase g2) :
    H3 (gauge0 g0 g1 u0) (gauge1 g1 g2 u1) (gauge2 g2 g0 u2) =
      G3 g0 g1 g2 * H3 u0 u1 u2 * (G3 g0 g1 g2)ᴴ := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [H3, G3, gauge0, gauge1, gauge2, Matrix.mul_apply, Fin.sum_univ_succ,
      conjTranspose_apply, mul_comm, mul_left_comm, mul_assoc]

/-- The oriented cycle product is unchanged by every unit local gauge. -/
theorem holonomy_gauge_invariant (g0 g1 g2 u0 u1 u2 : Complex)
    (hg0 : IsUnitPhase g0) (hg1 : IsUnitPhase g1)
    (hg2 : IsUnitPhase g2) :
    gauge0 g0 g1 u0 * gauge1 g1 g2 u1 * gauge2 g2 g0 u2 =
      u0 * u1 * u2 := by
  unfold IsUnitPhase at hg0 hg1 hg2
  have key : gauge0 g0 g1 u0 * gauge1 g1 g2 u1 * gauge2 g2 g0 u2 =
      (g0 * conj g0) * (g1 * conj g1) * (g2 * conj g2) * (u0 * u1 * u2) := by
    unfold gauge0 gauge1 gauge2
    ring
  rw [key, hg0, hg1, hg2]
  ring

/-- The cubic trace reads the real part of the oriented cycle product. -/
theorem trace_cube_H3 (u0 u1 u2 : Complex) :
    (H3 u0 u1 u2 * H3 u0 u1 u2 * H3 u0 u1 u2).trace =
      3 * (u0 * u1 * u2 + conj (u0 * u1 * u2)) := by
  simp [H3, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.diag,
    map_mul, mul_comm, mul_left_comm]
  ring

/-- Holonomies `+1` and `-1` have different cubic traces. -/
theorem threeSite_holonomy_changes_cubic_trace :
    (H3 1 1 1 * H3 1 1 1 * H3 1 1 1).trace = 6 ∧
    (H3 (-1) 1 1 * H3 (-1) 1 1 * H3 (-1) 1 1).trace = -6 := by
  constructor <;>
    simp [H3, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.diag] <;>
    norm_num

/-- A common site phase is pure conjugacy and leaves the cycle product
unchanged. -/
theorem common_phase_is_spectrally_trivial (g u0 u1 u2 : Complex)
    (hg : IsUnitPhase g) :
    H3 (gauge0 g g u0) (gauge1 g g u1) (gauge2 g g u2) =
      G3 g g g * H3 u0 u1 u2 * (G3 g g g)ᴴ ∧
    gauge0 g g u0 * gauge1 g g u1 * gauge2 g g u2 = u0 * u1 * u2 := by
  exact ⟨H3_gauge_conjugacy g g g u0 u1 u2 hg hg hg,
    holonomy_gauge_invariant g g g u0 u1 u2 hg hg hg⟩

/-- Any matrix whose cubic trace differs from the `+1`-holonomy fixture cannot
be related to that fixture by a unitary basis change. -/
theorem not_unitarily_conjugate_to_plus_of_trace_cube_ne (A : Mat3)
    (htrace_ne : (A * A * A).trace ≠
      (H3 1 1 1 * H3 1 1 1 * H3 1 1 1).trace) :
    ¬ ∃ W : Mat3, Wᴴ * W = 1 ∧ A = W * H3 1 1 1 * Wᴴ := by
  rintro ⟨W, hW, hconj⟩
  have hcube :
      A * A * A =
        W * (H3 1 1 1 * H3 1 1 1 * H3 1 1 1) * Wᴴ := by
    rw [hconj]
    simp only [Matrix.mul_assoc]
    rw [← Matrix.mul_assoc Wᴴ W, hW, Matrix.one_mul]
    rw [← Matrix.mul_assoc Wᴴ W, hW, Matrix.one_mul]
  have htrace_eq :
      (A * A * A).trace =
        (H3 1 1 1 * H3 1 1 1 * H3 1 1 1).trace := by
    rw [hcube, Matrix.trace_mul_cycle]
    rw [hW, Matrix.one_mul]
  exact htrace_ne htrace_eq

/-- The `+1`- and `-1`-holonomy fixtures are not related by a unitary basis
change. This is the formal free-spectrum discriminator: unitary conjugacy
would preserve the trace of the cube, but the exact traces are `+6` and `-6`.
-/
theorem plus_minus_not_unitarily_conjugate :
    ¬ ∃ W : Mat3, Wᴴ * W = 1 ∧
      H3 (-1) 1 1 = W * H3 1 1 1 * Wᴴ := by
  apply not_unitarily_conjugate_to_plus_of_trace_cube_ne
  have hfixtures := threeSite_holonomy_changes_cubic_trace
  rw [hfixtures.1, hfixtures.2]
  norm_num

end PhysicsSM.Draft.NullEdge.RingHolonomySpectrum
