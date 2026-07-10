import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# The Pauli four-momentum map `P(p) = pμ σ^μ`, grounded in PhysLean's Pauli convention

Clean-room port grounding the spinor-helicity foundation of the "mass = det P" mechanism in
PhysLean's Pauli-matrix convention (github `HEPLean/PhysLean`, `PauliMatrix.pauliBasis` /
`pauliContrDown`, "Pauli matrices as a Lorentz tensor").  **Reference / provenance only, NOT an
import** (version gap: pinned OFF v4.28.0; Mathlib-only build).

The map from a real four-momentum `(p0,p1,p2,p3)` to a Hermitian `2×2` complex matrix
`P(p) = pμ σ^μ` has determinant equal to the invariant mass squared `m² = p0²-p1²-p2²-p3²` in the
mostly-plus `(+,-,-,-)` signature, and rank dropping to `1` (i.e. `det = 0`) exactly on the null
cone.  This is the little-group spinor matrix underpinning the mass invariant.

Honest scope: the finite σ-map + determinant identity only (not the full Lorentz representation or
spinor decomposition).  Provenance = PhysLean `PauliMatrix`, clean-room.
-/

namespace PauliMomentumPhysLean

open Matrix

/-- Standard self-adjoint Pauli basis (PhysLean `PauliMatrix` convention). -/
def s0 : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, 1]
def s1 : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]
def s2 : Matrix (Fin 2) (Fin 2) ℂ := !![0, -Complex.I; Complex.I, 0]
def s3 : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- The four-momentum → Hermitian `2×2` map `P(p) = p0·σ⁰ + p1·σ¹ + p2·σ² + p3·σ³`. -/
noncomputable def P (p0 p1 p2 p3 : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (p0 : ℂ) • s0 + (p1 : ℂ) • s1 + (p2 : ℂ) • s2 + (p3 : ℂ) • s3

/-- **Target 1.** The explicit Hermitian closed form of `P`. -/
theorem P_closed (p0 p1 p2 p3 : ℝ) :
    P p0 p1 p2 p3 =
      !![(p0 : ℂ) + p3, (p1 : ℂ) - Complex.I * p2;
         (p1 : ℂ) + Complex.I * p2, (p0 : ℂ) - p3] := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [P, s0, s1, s2, s3] <;> ring

/-- **Target 2.** `P(p)` is self-adjoint (Hermitian) for real components. -/
theorem P_selfAdjoint (p0 p1 p2 p3 : ℝ) :
    (P p0 p1 p2 p3).conjTranspose = P p0 p1 p2 p3 := by
  rw [P_closed]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.conjTranspose, Complex.conj_I, sub_eq_add_neg]

/-- **Target 3 (payload).** `det P = p0² - p1² - p2² - p3²`, the invariant mass squared `m²` in the
mostly-plus `(+,-,-,-)` signature. -/
theorem det_P_eq_massSq (p0 p1 p2 p3 : ℝ) :
    (P p0 p1 p2 p3).det = ((p0 ^ 2 - p1 ^ 2 - p2 ^ 2 - p3 ^ 2 : ℝ) : ℂ) := by
  rw [P_closed, Matrix.det_fin_two_of]
  push_cast
  ring_nf
  rw [Complex.I_sq]
  ring

/-- **Target 4 (payload).** The null cone `det P = 0` is exactly the massless condition
`p0² = p1² + p2² + p3²`. -/
theorem null_iff_massless (p0 p1 p2 p3 : ℝ) :
    (P p0 p1 p2 p3).det = 0 ↔ p0 ^ 2 = p1 ^ 2 + p2 ^ 2 + p3 ^ 2 := by
  rw [det_P_eq_massSq,
    show ((p0 ^ 2 - p1 ^ 2 - p2 ^ 2 - p3 ^ 2 : ℝ) : ℂ)
        = ((p0 ^ 2 - (p1 ^ 2 + p2 ^ 2 + p3 ^ 2) : ℝ) : ℂ) by push_cast; ring,
    Complex.ofReal_eq_zero]
  constructor <;> intro h <;> linarith

/-- **Massive witness** `p = (1,0,0,0)`: `det = 1 ≠ 0` (timelike / massive). -/
theorem det_massive_witness : (P 1 0 0 0).det = 1 := by rw [det_P_eq_massSq]; norm_num

/-- **Null witness** `p = (1,0,0,1)`: `det = 0` (on the null cone / massless). -/
theorem det_null_witness : (P 1 0 0 1).det = 0 := by rw [det_P_eq_massSq]; norm_num

/-- **Spacelike witness** `p = (0,1,0,0)`: `det = -1` (spacelike). -/
theorem det_spacelike_witness : (P 0 1 0 0).det = -1 := by rw [det_P_eq_massSq]; norm_num

/-- The off-diagonal `σ²` entry is nonzero. -/
theorem s2_offdiag_ne_zero : (-Complex.I) ≠ 0 := by simp

/-- **Target 5.** Packaged verdict: the PhysLean Pauli matrices give the four-momentum → Hermitian
`2×2` map `P(p) = pμ σ^μ` whose determinant is `m² = p0²-p1²-p2²-p3²`, which is self-adjoint, and
whose determinant vanishes exactly on the null cone, together with the non-degeneracy witnesses. -/
theorem pauli_momentum_verdict :
    (∀ p0 p1 p2 p3 : ℝ,
        (P p0 p1 p2 p3).det = ((p0 ^ 2 - p1 ^ 2 - p2 ^ 2 - p3 ^ 2 : ℝ) : ℂ)) ∧
    (∀ p0 p1 p2 p3 : ℝ, (P p0 p1 p2 p3).conjTranspose = P p0 p1 p2 p3) ∧
    (∀ p0 p1 p2 p3 : ℝ,
        (P p0 p1 p2 p3).det = 0 ↔ p0 ^ 2 = p1 ^ 2 + p2 ^ 2 + p3 ^ 2) ∧
    (P 1 0 0 0).det = 1 ∧ (P 1 0 0 1).det = 0 ∧ (P 0 1 0 0).det = -1 ∧
    (-Complex.I) ≠ 0 :=
  ⟨det_P_eq_massSq, P_selfAdjoint, null_iff_massless,
    det_massive_witness, det_null_witness, det_spacelike_witness, s2_offdiag_ne_zero⟩

-- Axiom footprint: exactly [propext, Classical.choice, Quot.sound] on every headline.
/-- info: 'PauliMomentumPhysLean.P_closed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms P_closed
/-- info: 'PauliMomentumPhysLean.P_selfAdjoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms P_selfAdjoint
/-- info: 'PauliMomentumPhysLean.det_P_eq_massSq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms det_P_eq_massSq
/-- info: 'PauliMomentumPhysLean.null_iff_massless' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms null_iff_massless
/-- info: 'PauliMomentumPhysLean.pauli_momentum_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms pauli_momentum_verdict

end PauliMomentumPhysLean
