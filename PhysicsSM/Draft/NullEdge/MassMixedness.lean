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

Provenance: Sol strategy memo section 1 (2026-07-10; archived in the run
directory); seed statements by Fable, identities self-verified by hand
before submission; proofs by Aristotle project
`2f819742-b3e0-4b4e-9aeb-33fb8a85e78d` (run `f8598103`), statements
unchanged; integrated with local kernel re-check.  Lean 4.28.0.
Integration reconciliation: extends
`NullEdgeQubitConcurrence.trace2_mul_self_eq_trace_sq_sub_two_det` (the
unnormalized trace identity) and complements `MassCoherenceDuality` (the
visibility duality); this module adds the unit-trace purity form, the
Lagrange/trace-distance operational form, the ensemble pairwise form, and
the explicit-convention Pauli corollary.
-/

noncomputable section

open scoped BigOperators
open Matrix

namespace PhysicsSM.Draft.NullEdge.MassMixedness

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

/-
**T1 (purity-determinant bridge).**  For any 2x2 complex matrix of unit
trace, the determinant is half the purity deficit:
`det rho = (1 - tr (rho * rho)) / 2`.  Applied to `rho = P / tr P` this is
the statement "squared mass-to-trace ratio = qubit mixedness".
-/
theorem det_eq_half_one_sub_purity (rho : Matrix (Fin 2) (Fin 2) Complex)
    (htr : rho.trace = 1) :
    rho.det = (1 - (rho * rho).trace) / 2 := by
  norm_num [ Matrix.det_fin_two, Matrix.trace_fin_two ] at *;
  norm_num [ Matrix.mul_apply ] ; rw [ ← eq_sub_iff_add_eq' ] at htr; rw [ htr ] ; ring;

/-
**T2 (normalized mass ratio).**  For a family momentum matrix with
nonzero trace, `det (T⁻¹ • P) = det P / T ^ 2`; combined with T1 the
mass-to-trace ratio is the mixedness of the normalized state.
-/
theorem normalized_det {N : Nat} (psi : Fin N -> Fin 2 -> Complex)
    (T : Complex) (hT : T ≠ 0) (htr : (famMomentum psi).trace = T) :
    (T⁻¹ • famMomentum psi).det = (famMomentum psi).det / T ^ 2 := by
  rw [ Matrix.det_smul, pow_two ] ; ring ; aesop;

/-
**T3 (Lagrange / trace-distance form).**  The squared wedge is the
distinguishability combination:
`|psi /\ phi|^2 = |psi|^2 |phi|^2 - |<psi, phi>|^2`.
For unit spinors the right side is the squared trace distance of the pure
qubit states, so the rest gap is the energy-weighted optimal
distinguishability.
-/
theorem wedge_normSq_eq (psi phi : Fin 2 -> Complex) :
    wedge psi phi * (starRingEnd Complex) (wedge psi phi) =
      snormSq psi * snormSq phi
        - sinner psi phi * (starRingEnd Complex) (sinner psi phi) := by
  unfold wedge snormSq sinner; norm_num [ Fin.sum_univ_two ] ; ring;

/-
**T4 (ensemble pairwise form).**  The family determinant is the sum of
pairwise distinguishability combinations:
`det P = sum_{i<j} (|psi_i|^2 |psi_j|^2 - |<psi_i, psi_j>|^2)`.
Dividing by `T^2` gives mass-squared over trace-squared as an
ensemble-weighted sum of pairwise distinguishabilities.
-/
set_option maxHeartbeats 4000000 in
theorem famMomentum_det_eq_pairwise {N : Nat}
    (psi : Fin N -> Fin 2 -> Complex) :
    (famMomentum psi).det =
      ∑ p ∈ (Finset.univ : Finset (Fin N × Fin N)).filter
          (fun q => q.1 < q.2),
        (snormSq (psi p.1) * snormSq (psi p.2)
          - sinner (psi p.1) (psi p.2)
            * (starRingEnd Complex) (sinner (psi p.1) (psi p.2))) := by
  unfold famMomentum snormSq sinner;
  induction' N with N ih;
  · simp +decide [ Matrix.det_apply' ];
  · simp_all +decide [ Fin.sum_univ_succ, Finset.sum_add_distrib, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Matrix.det_fin_two, rankOne ];
    rw [ show ( Finset.filter ( fun x : Fin ( N + 1 ) × Fin ( N + 1 ) => x.1 < x.2 ) Finset.univ : Finset _ ) = Finset.image ( fun x : Fin N => ( 0, Fin.succ x ) ) Finset.univ ∪ Finset.image ( fun x : Fin N × Fin N => ( Fin.succ x.1, Fin.succ x.2 ) ) ( Finset.filter ( fun x : Fin N × Fin N => x.1 < x.2 ) Finset.univ ) from ?_, Finset.sum_union ] <;> norm_num [ Finset.sum_image, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, ih ];
    · rw [ Finset.sum_union ] <;> norm_num [ Finset.sum_image, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, ih ] ; ring;
      · rw [ Finset.sum_image, Finset.sum_image ] <;> norm_num [ Finset.sum_add_distrib, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, ih ] ; ring;
        · norm_num [ Finset.sum_add_distrib, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Matrix.sum_apply ] ; ring;
        · exact fun x y h => by simpa using h;
        · exact fun x y h => by simpa using h;
      · norm_num [ Finset.disjoint_left ];
    · norm_num [ Finset.disjoint_left ];
    · ext ⟨i, j⟩; simp [Finset.mem_union, Finset.mem_image];
      rcases i with ⟨ _ | i, hi ⟩ <;> rcases j with ⟨ _ | j, hj ⟩ <;> norm_num [ Fin.ext_iff, Fin.val_add ];
      · exact Nat.succ_pos _;
      · exact ⟨ fun h => ⟨ ⟨ i, by linarith ⟩, ⟨ j, by linarith ⟩, h, rfl, rfl ⟩, by rintro ⟨ a, b, h, rfl, rfl ⟩ ; exact h ⟩

/-- The Pauli matrices (explicit convention: this module's `P = E I + p.s`). -/
def sigma1 : Matrix (Fin 2) (Fin 2) Complex := !![0, 1; 1, 0]
def sigma2 : Matrix (Fin 2) (Fin 2) Complex := !![0, -Complex.I; Complex.I, 0]
def sigma3 : Matrix (Fin 2) (Fin 2) Complex := !![1, 0; 0, -1]

/-
**T5 (Pauli mass-energy corollary).**  For
`P = E I + px sigma1 + py sigma2 + pz sigma3` with real entries:
`tr P = 2 E` and `det P = E^2 - (px^2 + py^2 + pz^2)`, so with T1 the
relativistic ratio `m^2 / E^2` equals twice the purity deficit of
`rho = P / (2E)`.
-/
theorem pauli_trace_and_det (E px py pz : Real) :
    ((E : Complex) • (1 : Matrix (Fin 2) (Fin 2) Complex)
        + (px : Complex) • sigma1 + (py : Complex) • sigma2
        + (pz : Complex) • sigma3).trace = 2 * (E : Complex) ∧
    ((E : Complex) • (1 : Matrix (Fin 2) (Fin 2) Complex)
        + (px : Complex) • sigma1 + (py : Complex) • sigma2
        + (pz : Complex) • sigma3).det =
      (E : Complex) ^ 2 - ((px : Complex) ^ 2 + (py : Complex) ^ 2
        + (pz : Complex) ^ 2) := by
  constructor <;> norm_num [ Matrix.det_fin_two, Matrix.trace_fin_two, sigma1, sigma2, sigma3 ] <;> ring;
  norm_num ; ring

/-
**T6 (witness and boundary control).**  The standard-basis pair gives a
maximally mixed normalized state (purity 1/2) and mass-to-trace ratio
squared exactly 1/4; a repeated single direction gives a pure state
(purity 1) and zero determinant.
-/
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
  unfold famMomentum; norm_num [ Matrix.det_fin_two, Matrix.trace_fin_two ] ;
  norm_num [ rankOne, Matrix.mul_apply ]


/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.MassMixedness.det_eq_half_one_sub_purity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_eq_half_one_sub_purity

/-- info: 'PhysicsSM.Draft.NullEdge.MassMixedness.wedge_normSq_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms wedge_normSq_eq

/-- info: 'PhysicsSM.Draft.NullEdge.MassMixedness.famMomentum_det_eq_pairwise' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms famMomentum_det_eq_pairwise

/-- info: 'PhysicsSM.Draft.NullEdge.MassMixedness.pauli_trace_and_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pauli_trace_and_det

/-- info: 'PhysicsSM.Draft.NullEdge.MassMixedness.witness_and_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_and_control

end PhysicsSM.Draft.NullEdge.MassMixedness
