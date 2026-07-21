import Mathlib

/-!
# A Mathlib-only algebraic rung in the gap-to-pole ladder

This file isolates the nonzero-residue condition.  It deliberately does not
postulate an Osterwalder--Seiler reconstruction or a changing-lattice limit;
those analytic hypotheses and the missing bridge are specified in
`GAP_TO_POLE_LADDER.md`.
-/

open Filter Topology
open scoped ComplexConjugate

namespace GapToPoleLadder

/-- `G` has a simple pole at `edge` with physical residue `weight` when its
punctured-neighbourhood residue exists and is nonzero. -/
def HasNonzeroResidueAt (G : ℂ → ℂ) (edge weight : ℂ) : Prop :=
  Tendsto (fun z => (z - edge) * G z) (𝓝[≠] edge) (𝓝 weight) ∧ weight ≠ 0

/-- The pure one-particle response with spectral edge `edge` and overlap
`weight`.  At `weight = 0` this is identically zero, which is precisely the
propagator-zero obstruction. -/
noncomputable def poleResponse (edge weight z : ℂ) : ℂ := weight / (z - edge)

/-
**Rung 2 (Mathlib-only).**  The pure response has a nonzero residue at the
selected edge exactly when its physical-sector overlap is nonzero.
-/
theorem poleResponse_hasNonzeroResidueAt_iff (edge weight : ℂ) :
    HasNonzeroResidueAt (poleResponse edge weight) edge weight ↔ weight ≠ 0 := by
  constructor <;> intro h;
  · exact h.2;
  · exact ⟨ tendsto_const_nhds.congr' ( by filter_upwards [ self_mem_nhdsWithin ] with z hz using by rw [ poleResponse, mul_div_cancel₀ _ ( sub_ne_zero.2 hz ) ] ), h ⟩

/-
A local regular contribution does not change the residue, provided its
product with `z - edge` tends to zero on the punctured neighbourhood.
-/
theorem add_regular_preserves_nonzero_residue
    {G R : ℂ → ℂ} {edge weight : ℂ}
    (hG : HasNonzeroResidueAt G edge weight)
    (hR : Tendsto (fun z => (z - edge) * R z) (𝓝[≠] edge) (𝓝 0)) :
    HasNonzeroResidueAt (fun z => G z + R z) edge weight := by
  refine' And.intro _ ( hG.2 );
  simpa [ mul_add ] using hG.1.add hR

/-- Relativistic positive-energy dispersion in `d` spatial dimensions. -/
noncomputable def relativisticEnergy (d : ℕ) (m : ℝ) (p : Fin d → ℝ) : ℝ :=
  Real.sqrt (m ^ 2 + ∑ i, (p i) ^ 2)

/-
**Rung 3 (Mathlib-only).**  For nonnegative `m`, the positive relativistic
branch has rest energy `m`, and `m` is its global minimum.
-/
theorem relativisticEnergy_rest_and_minimum (d : ℕ) {m : ℝ} (hm : 0 ≤ m) :
    relativisticEnergy d m 0 = m ∧
      ∀ p : Fin d → ℝ, m ≤ relativisticEnergy d m p := by
  exact ⟨ by simpa [ relativisticEnergy ] using Real.sqrt_sq hm, fun p => Real.le_sqrt_of_sq_le <| by simpa [ relativisticEnergy ] using Finset.sum_nonneg fun i ( hi : i ∈ Finset.univ ) => sq_nonneg _ ⟩

end GapToPoleLadder
