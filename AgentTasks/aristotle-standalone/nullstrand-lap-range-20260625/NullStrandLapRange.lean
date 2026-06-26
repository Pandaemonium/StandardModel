import Mathlib

/-!
# NullStrand finite graph Laplacian range target

LA-002: connected graph Laplacian range is the zero-sum subspace.
-/

noncomputable section

namespace NullStrandLapRange

open scoped BigOperators
open Matrix SimpleGraph

/-- The linear functional sending a vector to the sum of its coordinates. -/
def sumLM (V : Type*) [Fintype V] : (V → ℝ) →ₗ[ℝ] ℝ := ∑ i, LinearMap.proj i

lemma sumLM_apply {V : Type*} [Fintype V] (b : V → ℝ) : sumLM V b = ∑ v, b v := by
  simp [sumLM, LinearMap.sum_apply]

/-
The coordinate sum of a Laplacian image is zero (column sums of the Laplacian vanish).
-/
lemma sum_lapMatrix_mulVec {V : Type*} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) [DecidableRel G.Adj] (f : V → ℝ) :
    ∑ v, (G.lapMatrix ℝ *ᵥ f) v = 0 := by
  have h0 : (fun _ => (1:ℝ)) ⬝ᵥ (G.lapMatrix ℝ) *ᵥ f = (G.lapMatrix ℝ)ᵀ *ᵥ (fun _ => (1:ℝ)) ⬝ᵥ f := by
    convert Matrix.dotProduct_mulVec _ _ _ using 2;
    convert Matrix.mulVec_transpose _ _ using 2;
  convert h0 using 1;
  · simp +decide [ dotProduct ];
  · have h1 : (G.lapMatrix ℝ)ᵀ *ᵥ (fun _ => (1:ℝ)) = G.lapMatrix ℝ *ᵥ (fun _ => (1:ℝ)) := by
      rw [ SimpleGraph.isSymm_lapMatrix ];
    rw [ h1, SimpleGraph.lapMatrix_mulVec_const_eq_zero ] ; norm_num

/-
A connected graph has exactly one connected component.
-/
lemma card_connectedComponent_eq_one {V : Type*} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) [DecidableRel G.Adj] (hconn : G.Connected) :
    Fintype.card G.ConnectedComponent = 1 := by
  -- Since the graph is connected, every vertex is reachable from any other vertex.
  have h_reachable : ∀ u v : V, G.Reachable u v := by
    exact fun u v => hconn u v;
  obtain ⟨ v ⟩ := hconn.nonempty;
  exact Fintype.card_eq_one_iff.mpr ⟨ G.connectedComponentMk v, fun c => by obtain ⟨ u, rfl ⟩ := c.exists_rep; exact ( SimpleGraph.ConnectedComponent.eq.mpr <| h_reachable _ _ ) ⟩

/-- The Laplacian kernel of a connected graph is one-dimensional. -/
lemma finrank_ker_lapMatrix_eq_one {V : Type*} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) [DecidableRel G.Adj] (hconn : G.Connected) :
    Module.finrank ℝ (LinearMap.ker (Matrix.toLin' (G.lapMatrix ℝ))) = 1 := by
  rw [← card_connectedComponent_eq_finrank_ker_toLin'_lapMatrix,
    card_connectedComponent_eq_one G hconn]

/-
The zero-sum subspace has dimension `card V - 1`.
-/
lemma finrank_ker_sumLM (V : Type*) [Fintype V] [Nonempty V] :
    Module.finrank ℝ (LinearMap.ker (sumLM V)) = Fintype.card V - 1 := by
  -- The functional sumLM V : (V → ℝ) →ₗ[ℝ] ℝ is surjective when V is nonempty.
  have h_surjective : Function.Surjective (sumLM V) := by
    intro x
    use fun v => x / Fintype.card V;
    simp +decide [ sumLM_apply, mul_div_cancel₀ ];
  have := LinearMap.finrank_range_add_finrank_ker ( sumLM V );
  rw [ show ( sumLM V |> LinearMap.range ) = ⊤ from LinearMap.range_eq_top.mpr h_surjective ] at this ; simp_all +decide [ Module.finrank_self ];
  rw [ ← this, add_tsub_cancel_left ]

/-- LA-002. On a connected finite graph, a vector is in the Laplacian range iff its sum is zero. -/
theorem lapMatrix_range_eq_zeroSum
    {V : Type*} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) [DecidableRel G.Adj] (hconn : G.Connected) (b : V -> Real) :
    (∃ f : V -> Real, Matrix.mulVec (G.lapMatrix Real) f = b) ↔
      (∑ v, b v) = 0 := by
  classical
  haveI : Nonempty V := hconn.nonempty
  -- The range of the Laplacian is contained in the zero-sum subspace.
  have hle : LinearMap.range (Matrix.toLin' (G.lapMatrix ℝ)) ≤ LinearMap.ker (sumLM V) := by
    rintro x ⟨f, rfl⟩
    rw [LinearMap.mem_ker, sumLM_apply, toLin'_apply]
    exact sum_lapMatrix_mulVec G f
  -- Both subspaces have dimension `card V - 1`, so they are equal.
  have hrank_range :
      Module.finrank ℝ (LinearMap.range (Matrix.toLin' (G.lapMatrix ℝ))) = Fintype.card V - 1 := by
    have hadd := LinearMap.finrank_range_add_finrank_ker (Matrix.toLin' (G.lapMatrix ℝ))
    rw [finrank_ker_lapMatrix_eq_one G hconn, Module.finrank_fintype_fun_eq_card] at hadd
    omega
  have heq : LinearMap.range (Matrix.toLin' (G.lapMatrix ℝ)) = LinearMap.ker (sumLM V) :=
    Submodule.eq_of_le_of_finrank_eq hle (by rw [hrank_range, finrank_ker_sumLM V])
  constructor
  · rintro ⟨f, rfl⟩
    have hmem : (G.lapMatrix ℝ *ᵥ f) ∈ LinearMap.range (Matrix.toLin' (G.lapMatrix ℝ)) :=
      ⟨f, toLin'_apply _ _⟩
    rw [heq, LinearMap.mem_ker, sumLM_apply] at hmem
    exact hmem
  · intro hb
    have hmem : b ∈ LinearMap.ker (sumLM V) := by
      rw [LinearMap.mem_ker, sumLM_apply]; exact hb
    rw [← heq] at hmem
    obtain ⟨f, hf⟩ := hmem
    exact ⟨f, by rw [← toLin'_apply]; exact hf⟩

end NullStrandLapRange
