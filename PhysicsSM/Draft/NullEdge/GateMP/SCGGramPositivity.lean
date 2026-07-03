import Mathlib

/-!
# Gate MP: SCG measure candidate - Gram positivity and the back-reaction criterion

Harvested from Aristotle job 970e20fe (package
`AgentTasks/aristotle-standalone/measure-scg-gram-positivity-20260703`); all
four statements were authored in-repo, hand-verified in review, and proved by
Aristotle with NO statement changed.  This is the first Lean content for the
Measure Problem sector
(`Sources/Null_Edge_Measure_Problem.md`, candidate class 4(e), SCG =
skeleton-conditioned checkerboard growth): a factorized decoherence
functional `D(g,g') = sum_s P(s) A_s(g) conj(A_s(g'))` over a classical
"skeleton" layer (probabilities `P`) and skeleton-conditional quantum
"decoration" amplitudes `A`.

**The theorems.**

* `gramDecoherence_posSemidef` / `gramDecoherence_event_posSemidef`: the
  factorized decoherence matrix is positive semidefinite, and so is every
  finite-event aggregation `B D B^H` - i.e. STRONG POSITIVITY (entrance
  requirement R4 of the Measure Problem checklist) holds FOR FREE for any
  quantum-measure candidate built this way, with no numerical probe needed.
* `deformed_posSemidef_of_posSemidef` / `deformed_posSemidef_iff`: **the
  back-reaction criterion.**  Deforming the factorization so the skeleton
  weight depends on the decoration pair,
  `D(g,g') = A(g) W(g,g') conj(A(g'))`, the deformed matrix is PSD iff the
  weight kernel `W` is PSD (full-support case).  So coupling geometry to
  matter preserves quantum-measure structure exactly when the
  geometry-dependence enters as a PSD ("record-overlap") kernel - a standing
  DESIGN CONSTRAINT on every future interacting extension of the growth
  measure, derived before any such extension exists.

Proof notes on the harvested mechanism (reviewed): Lemma 1 evaluates the
quadratic form directly to `sum_s P(s) * normSq(sum_i conj(x i) * A s i)`,
manifestly nonnegative.  Lemma 2 sufficiency is the matrix identity
`deformed W A = (diagonal A)^H * W * (diagonal A)` plus congruence
(`Matrix.PosSemidef.conjTranspose_mul_mul_same`).  Necessity is elegant: since
`deformed (deformed W A) (fun g => (A g)^{-1}) = W` exactly under `A g != 0`
(the `A^{-1} * A` and `conj(A) * conj(A)^{-1}` factors cancel), applying the
sufficiency lemma TWICE recovers `W`'s positivity from `(deformed W A)`'s -
no direct quadratic-form argument on `W` needed.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **finite identity** (Gram positivity + congruence criterion).
Prerequisites: Mathlib only.  Successors: the decoration-layer instantiation
on the verified null-step walk (`GateI1.MassCoinBridge`); the BC-Q freeze
(gate MP4); the MP1' concentration pilot (`Scripts/mp1_concentration.py`).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateMP
namespace SCGGramPositivity

open Matrix
open scoped ComplexOrder

variable {S H E : Type*} [Fintype S] [Fintype H] [Fintype E] [DecidableEq H]

/-- The skeleton-factorized (Gram) decoherence matrix:
`D gamma gamma' = sum_s P s * A s gamma * conj (A s gamma')`. -/
def gramDecoherence (P : S → ℝ) (A : S → H → ℂ) : Matrix H H ℂ :=
  Matrix.of fun γ γ' => ∑ s, (P s : ℂ) * A s γ * (starRingEnd ℂ) (A s γ')

/-
**Lemma 1 (Gram positivity).**  The skeleton-factorized decoherence
matrix of nonnegative skeleton weights is positive semidefinite.
-/
omit [DecidableEq H] in
theorem gramDecoherence_posSemidef (P : S → ℝ) (hP : ∀ s, 0 ≤ P s)
    (A : S → H → ℂ) :
    (gramDecoherence P A).PosSemidef := by
  refine' ⟨ _, _ ⟩;
  · ext γ γ'; simp +decide [ gramDecoherence, mul_assoc, mul_comm ] ;
  · intro x
    have h_sum : ∑ i, ∑ j, star (x i) * gramDecoherence P A i j * x j = ∑ s, (P s : ℂ) * (∑ i, star (x i) * A s i) * (∑ j, x j * star (A s j)) := by
      simp +decide only [gramDecoherence, mul_comm, starRingEnd_apply, mul_assoc, Finset.mul_sum _ _ _,
          mul_left_comm];
      simp +decide only [of_apply];
      simp +decide only [Finset.mul_sum _ _ _, mul_left_comm];
      exact Eq.symm ( Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by ring ) ) )
    generalize_proofs at *; (
    -- Recognize that the expression inside the sum is a squared norm, which is nonnegative.
    have h_norm : ∀ s, (∑ i, star (x i) * A s i) * (∑ j, x j * star (A s j)) = Complex.normSq (∑ i, star (x i) * A s i) := by
      simp +decide [ Complex.ext_iff, Complex.normSq ];
      simp +decide [ Finset.sum_add_distrib, mul_comm ] ; ring_nf ; aesop;
    generalize_proofs at *; (
    simp_all +decide [ mul_assoc, Finsupp.sum_fintype ];
    exact mod_cast Finset.sum_nonneg fun s _ => mul_nonneg ( hP s ) ( Complex.normSq_nonneg _ )))

/-
**Lemma 1, event level.**  Every aggregation `B * D * B^H` of a
skeleton-factorized decoherence matrix is positive semidefinite - i.e.
strong positivity on every finite event partition holds for free.
-/
omit [DecidableEq H] in
theorem gramDecoherence_event_posSemidef (P : S → ℝ) (hP : ∀ s, 0 ≤ P s)
    (A : S → H → ℂ) (B : Matrix E H ℂ) :
    (B * gramDecoherence P A * Bᴴ).PosSemidef := by
  convert Matrix.PosSemidef.mul_mul_conjTranspose_same _ _ using 1;
  · infer_instance;
  · convert gramDecoherence_posSemidef P hP A using 1

/-- The back-reaction deformation: skeleton weights depending on the
decoration pair through a kernel `W`,
`D gamma gamma' = A gamma * W gamma gamma' * conj (A gamma')`. -/
def deformed (W : Matrix H H ℂ) (A : H → ℂ) : Matrix H H ℂ :=
  Matrix.of fun γ γ' => A γ * W γ γ' * (starRingEnd ℂ) (A γ')

/-
**Lemma 2, sufficiency.**  A PSD weight kernel yields a PSD deformed
decoherence matrix (congruence by `diagonal A`, or Schur with the rank-one
PSD Hadamard factor).
-/
theorem deformed_posSemidef_of_posSemidef (W : Matrix H H ℂ) (A : H → ℂ)
    (hW : W.PosSemidef) :
    (deformed W A).PosSemidef := by
  convert hW.conjTranspose_mul_mul_same _;
  rotate_right;
  exact Matrix.diagonal fun i => star ( A i );
  · ext i j; simp +decide [ deformed, Matrix.mul_apply, Matrix.diagonal ] ;
    rw [ Finset.sum_eq_single i ] <;> aesop;
  · infer_instance

/-
**Lemma 2, criterion (full support).**  With `A` nowhere zero, the
deformed decoherence matrix is PSD IFF the weight kernel is PSD: coupling
the skeleton to decorations preserves quantum-measure positivity exactly
when the coupling is a PSD (record-overlap) kernel.
-/
theorem deformed_posSemidef_iff (W : Matrix H H ℂ) (A : H → ℂ)
    (hA : ∀ γ, A γ ≠ 0) :
    (deformed W A).PosSemidef ↔ W.PosSemidef := by
  refine' ⟨ fun h => _, fun h => deformed_posSemidef_of_posSemidef W A h ⟩;
  convert deformed_posSemidef_of_posSemidef ( deformed W A ) ( fun γ => ( A γ ) ⁻¹ ) h using 1;
  ext γ γ'; simp +decide [ deformed, hA, mul_assoc, mul_left_comm, mul_comm ] ;

end SCGGramPositivity
end GateMP
end NullEdge
end Draft
end PhysicsSM
