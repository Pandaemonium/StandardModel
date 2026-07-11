import Mathlib

/-!
# Invariant mass as qubit mixedness and null-direction distinguishability

Sol-memo section 1 package (overnight publication run 2026-07-11, Fable
lane).  The identities below give the null-edge program's information
reading its exact form: normalizing the momentum matrix of a family of null
spinors yields a qubit density matrix whose MIXEDNESS is the squared
mass-to-trace ratio, and for two spinors the rest gap is the
energy-weighted TRACE DISTANCE (optimal one-shot distinguishability) of the
normalized directions.  Everything is finite 2x2 algebra; no analysis.

Relation to the existing corpus (integration note): the project already
holds the Cayley-Hamilton trace identity
(`NullEdgeQubitConcurrence.trace2_mul_self_eq_trace_sq_sub_two_det`), the
visibility duality (`MassCoherenceDuality`), and the family Cauchy-Binet
mass identity (trusted core).  This module supplies the normalized purity
bridge, the Lagrange/trace-distance operational form, the energy-weighted
form, the ensemble pairwise form, and the Pauli mass-energy corollary.

Success = all six theorems kernel-checked, axioms only
propext / Classical.choice / Quot.sound.

Prohibited weakenings:
- do not add positivity or normalization hypotheses beyond those displayed;
- do not replace the trace-distance combination
  `normSq psi * normSq phi - normSq (inner)` by an abstract distinguished
  quantity;
- keep T5's Pauli convention exactly as displayed (P = E I + p . sigma).
-/

noncomputable section

open scoped BigOperators
open Matrix

namespace MassMixedness

/-- Rank-one momentum matrix of a spinor. -/
def rankOne (psi : Fin 2 -> Complex) : Matrix (Fin 2) (Fin 2) Complex :=
  Matrix.of fun i j => psi i * (starRingEnd Complex) (psi j)

/-- Momentum matrix of a finite family of spinors. -/
def famMomentum {N : Nat} (psi : Fin N -> Fin 2 -> Complex) :
    Matrix (Fin 2) (Fin 2) Complex :=
  ∑ k : Fin N, rankOne (psi k)

/-- Hermitian squared norm of a spinor. -/
def snormSq (psi : Fin 2 -> Complex) : Complex :=
  ∑ i : Fin 2, psi i * (starRingEnd Complex) (psi i)

/-- Hermitian inner product (conjugate-linear in the first slot). -/
def sinner (psi phi : Fin 2 -> Complex) : Complex :=
  ∑ i : Fin 2, (starRingEnd Complex) (psi i) * phi i

/-- The Pluecker wedge. -/
def wedge (psi phi : Fin 2 -> Complex) : Complex :=
  psi 0 * phi 1 - psi 1 * phi 0

/-- **T1 (purity-determinant bridge).**  For any 2x2 complex matrix of unit
trace, the determinant is half the purity deficit:
`det rho = (1 - tr (rho * rho)) / 2`.  Applied to `rho = P / tr P` this is
the statement "squared mass-to-trace ratio = qubit mixedness". -/
theorem det_eq_half_one_sub_purity (rho : Matrix (Fin 2) (Fin 2) Complex)
    (htr : rho.trace = 1) :
    rho.det = (1 - (rho * rho).trace) / 2 := by
  sorry

/-- **T2 (normalized mass ratio).**  For a family momentum matrix with
nonzero trace, `det (T⁻¹ • P) = det P / T ^ 2`; combined with T1 the
mass-to-trace ratio is the mixedness of the normalized state. -/
theorem normalized_det {N : Nat} (psi : Fin N -> Fin 2 -> Complex)
    (T : Complex) (hT : T ≠ 0) (htr : (famMomentum psi).trace = T) :
    (T⁻¹ • famMomentum psi).det = (famMomentum psi).det / T ^ 2 := by
  sorry

/-- **T3 (Lagrange / trace-distance form).**  The squared wedge is the
distinguishability combination:
`|psi /\ phi|^2 = |psi|^2 |phi|^2 - |<psi, phi>|^2`.
For unit spinors the right side is the squared trace distance of the pure
qubit states, so the rest gap is the energy-weighted optimal
distinguishability. -/
theorem wedge_normSq_eq (psi phi : Fin 2 -> Complex) :
    wedge psi phi * (starRingEnd Complex) (wedge psi phi) =
      snormSq psi * snormSq phi
        - sinner psi phi * (starRingEnd Complex) (sinner psi phi) := by
  sorry

/-- **T4 (ensemble pairwise form).**  The family determinant is the sum of
pairwise distinguishability combinations:
`det P = sum_{i<j} (|psi_i|^2 |psi_j|^2 - |<psi_i, psi_j>|^2)`.
Dividing by `T^2` gives mass-squared over trace-squared as an
ensemble-weighted sum of pairwise distinguishabilities. -/
theorem famMomentum_det_eq_pairwise {N : Nat}
    (psi : Fin N -> Fin 2 -> Complex) :
    (famMomentum psi).det =
      ∑ p ∈ (Finset.univ : Finset (Fin N × Fin N)).filter
          (fun q => q.1 < q.2),
        (snormSq (psi p.1) * snormSq (psi p.2)
          - sinner (psi p.1) (psi p.2)
            * (starRingEnd Complex) (sinner (psi p.1) (psi p.2))) := by
  sorry

/-- The Pauli matrices (explicit convention: this module's `P = E I + p.s`). -/
def sigma1 : Matrix (Fin 2) (Fin 2) Complex := !![0, 1; 1, 0]
def sigma2 : Matrix (Fin 2) (Fin 2) Complex := !![0, -Complex.I; Complex.I, 0]
def sigma3 : Matrix (Fin 2) (Fin 2) Complex := !![1, 0; 0, -1]

/-- **T5 (Pauli mass-energy corollary).**  For
`P = E I + px sigma1 + py sigma2 + pz sigma3` with real entries:
`tr P = 2 E` and `det P = E^2 - (px^2 + py^2 + pz^2)`, so with T1 the
relativistic ratio `m^2 / E^2` equals twice the purity deficit of
`rho = P / (2E)`. -/
theorem pauli_trace_and_det (E px py pz : Real) :
    ((E : Complex) • (1 : Matrix (Fin 2) (Fin 2) Complex)
        + (px : Complex) • sigma1 + (py : Complex) • sigma2
        + (pz : Complex) • sigma3).trace = 2 * (E : Complex) ∧
    ((E : Complex) • (1 : Matrix (Fin 2) (Fin 2) Complex)
        + (px : Complex) • sigma1 + (py : Complex) • sigma2
        + (pz : Complex) • sigma3).det =
      (E : Complex) ^ 2 - ((px : Complex) ^ 2 + (py : Complex) ^ 2
        + (pz : Complex) ^ 2) := by
  sorry

/-- **T6 (witness and boundary control).**  The standard-basis pair gives a
maximally mixed normalized state (purity 1/2) and mass-to-trace ratio
squared exactly 1/4; a repeated single direction gives a pure state
(purity 1) and zero determinant. -/
theorem witness_and_control :
    ((famMomentum ![![1, 0], ![0, 1]]).det = 1 ∧
      (famMomentum ![![1, 0], ![0, 1]]).trace = 2 ∧
      ((((2 : Complex))⁻¹ • famMomentum ![![1, 0], ![0, 1]]) *
        (((2 : Complex))⁻¹ • famMomentum ![![1, 0], ![0, 1]])).trace
          = 1 / 2) ∧
    ((famMomentum ![![1, 0], ![1, 0]]).det = 0 ∧
      (famMomentum ![![1, 0], ![1, 0]]).trace = 2 ∧
      ((((2 : Complex))⁻¹ • famMomentum ![![1, 0], ![1, 0]]) *
        (((2 : Complex))⁻¹ • famMomentum ![![1, 0], ![1, 0]])).trace
          = 1) := by
  sorry

end MassMixedness
