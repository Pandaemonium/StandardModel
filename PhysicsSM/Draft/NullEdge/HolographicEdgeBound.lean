import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000

/-!
# A finite holographic / Bekenstein edge bound

This file builds a **finite linear-algebra avatar** of the holographic principle:
the physical degrees of freedom of a region are bounded by its *boundary* null-edge
count, not by its interior volume.

## The model

* The interior state space is `V = ℚ^4` (interior "volume" `= 4`).
* The boundary carries `B = 3` pierced null edges, modelled as the boundary source
  space `Bnd = ℚ^3`.
* `R : V → Bnd` is the interior-to-boundary restriction (trace) map, an explicit
  rational linear map.
* `Phys ⊆ V` is the physical (positive-sector) subspace, here the range of an
  explicit rational embedding `P : ℚ^2 → V`.

The `holographic_bound` says `dim Phys ≤ B`: the physical degrees of freedom are
bounded by the boundary null-edge count.

## Honest scope

This is a finite linear-algebra statement (rank/finrank bookkeeping over `ℚ`), NOT
the covariant entropy bound of real gravity.  See `ARISTOTLE_SUMMARY.md`.
-/

namespace HolographicEdgeBound

/-- The interior state space `V = ℚ^4` (interior "volume" `= 4`). -/
abbrev V := Fin 4 → ℚ

/-- The boundary source space `Bnd = ℚ^3`; one coordinate per pierced null edge. -/
abbrev Bnd := Fin 3 → ℚ

/-- The number of pierced boundary null edges `B = 3` (the boundary "area"). -/
def edges : ℕ := 3

/-- The interior-to-boundary restriction matrix (trace to the boundary). -/
def Rm : Matrix (Fin 3) (Fin 4) ℚ := !![1,0,0,0; 0,1,0,0; 0,0,1,0]

/-- The physical-embedding matrix (positive-sector states inside `V`). -/
def Pm : Matrix (Fin 4) (Fin 2) ℚ := !![1,0; 0,1; 0,0; 0,0]

/-- A left inverse of `Rm * Pm`, used to certify injectivity on the physical sector. -/
def Lm : Matrix (Fin 2) (Fin 3) ℚ := !![1,0,0; 0,1,0]

/-- The boundary restriction map `R : V → Bnd`. -/
noncomputable def R : V →ₗ[ℚ] Bnd := Matrix.mulVecLin Rm

/-- The physical embedding `P : ℚ^2 → V`. -/
noncomputable def P : (Fin 2 → ℚ) →ₗ[ℚ] V := Matrix.mulVecLin Pm

/-- The physical sector `Phys ⊆ V` (positive-sector subspace). -/
noncomputable def Phys : Submodule ℚ V := LinearMap.range P

/-- The boundary restriction, precomposed with the physical embedding, is injective:
this is the concrete "holographic reconstruction" witness. -/
theorem comp_injective : Function.Injective (R ∘ₗ P) := by
  have h : (R ∘ₗ P) = Matrix.mulVecLin (Rm * Pm) := by
    rw [Matrix.mulVecLin_mul]; rfl
  rw [h]
  have hL : Matrix.mulVecLin Lm ∘ₗ Matrix.mulVecLin (Rm * Pm) = LinearMap.id := by
    rw [← Matrix.mulVecLin_mul]
    have hone : Lm * (Rm * Pm) = 1 := by
      simp only [Rm, Pm, Lm]
      norm_num [Matrix.mul_fin_three, Matrix.mul_fin_two]
      decide
    rw [hone]; ext x i; simp
  refine Function.LeftInverse.injective (g := Matrix.mulVecLin Lm) (fun x => ?_)
  have := congrArg (fun f => f x) hL; simpa using this

/-- The physical embedding `P` is injective (physical states are genuine states). -/
theorem P_injective : Function.Injective P := by
  intro x y hxy
  apply comp_injective
  simp only [LinearMap.comp_apply, hxy]

/-!
## Target 1 — boundary rank bound
-/

/-- **`boundary_rank_le_edges`.** The boundary restriction map has rank at most the
boundary edge count `B`: its target has dimension `B = 3`. -/
theorem boundary_rank_le_edges :
    Module.finrank ℚ (LinearMap.range R) ≤ edges := by
  have h : Module.finrank ℚ (LinearMap.range R) ≤ Module.finrank ℚ Bnd :=
    Submodule.finrank_le _
  simpa [edges, Module.finrank_fintype_fun_eq_card] using h

/-!
## Target 2 — the physical sector injects into the boundary
-/

/-- **`phys_injects_to_boundary`.** On the physical sector, the boundary restriction is
injective: a physical state is determined by its boundary data.  (Realized on the
concrete witness where `R` restricted to `Phys` has trivial kernel.) -/
theorem phys_injects_to_boundary :
    Set.InjOn R (Phys : Set V) := by
  intro x hx y hy hxy
  obtain ⟨a, rfl⟩ := hx
  obtain ⟨b, rfl⟩ := hy
  have : (R ∘ₗ P) a = (R ∘ₗ P) b := by
    simpa [LinearMap.comp_apply] using hxy
  rw [comp_injective this]

/-- Trivial-kernel form of `phys_injects_to_boundary`: the kernel of `R` restricted to
`Phys` is trivial. -/
theorem phys_ker_restrict_eq_bot :
    LinearMap.ker (R.domRestrict Phys) = ⊥ := by
  rw [LinearMap.ker_eq_bot]
  intro x y hxy
  apply Subtype.ext
  obtain ⟨a, ha⟩ := x.2
  obtain ⟨b, hb⟩ := y.2
  have hx : (x : V) = P a := ha.symm
  have hy : (y : V) = P b := hb.symm
  have : R (x : V) = R (y : V) := by
    simpa [LinearMap.domRestrict_apply] using hxy
  have hcomp : (R ∘ₗ P) a = (R ∘ₗ P) b := by
    simp only [LinearMap.comp_apply]; rw [← hx, ← hy]; exact this
  have := comp_injective hcomp
  rw [hx, hy, this]

/-!
## Dimension of the physical sector
-/

/-- The physical sector has dimension `2` (two physical degrees of freedom). -/
theorem dim_phys_eq : Module.finrank ℚ Phys = 2 := by
  rw [Phys, LinearMap.finrank_range_of_inj P_injective]
  simp [Module.finrank_fintype_fun_eq_card]

/-!
## Target 3 — the holographic bound (payload)
-/

/-- **`holographic_bound`.** The physical degrees of freedom are bounded by the boundary
null-edge count:
`dim Phys = rank (R|_Phys) ≤ rank R ≤ B`. -/
theorem holographic_bound :
    Module.finrank ℚ Phys ≤ edges := by
  -- `R` maps `Phys` isomorphically onto `range (R ∘ₗ P) ≤ range R`.
  have hmap : LinearMap.range (R ∘ₗ P) = Submodule.map R Phys :=
    LinearMap.range_comp P R
  have hdim_map : Module.finrank ℚ (Submodule.map R Phys) = 2 := by
    rw [← hmap, LinearMap.finrank_range_of_inj comp_injective]
    simp [Module.finrank_fintype_fun_eq_card]
  have hle : Submodule.map R Phys ≤ LinearMap.range R := LinearMap.map_le_range
  have h1 : Module.finrank ℚ (Submodule.map R Phys)
      ≤ Module.finrank ℚ (LinearMap.range R) := Submodule.finrank_mono hle
  calc Module.finrank ℚ Phys = 2 := dim_phys_eq
    _ = Module.finrank ℚ (Submodule.map R Phys) := hdim_map.symm
    _ ≤ Module.finrank ℚ (LinearMap.range R) := h1
    _ ≤ edges := boundary_rank_le_edges

/-!
## Target 4 — entropy/area form (area law)
-/

/-- The region entropy `S`, read off as the dimension of the physical sector. -/
noncomputable def entropy : ℕ := Module.finrank ℚ Phys

/-- The boundary area `A`, read off as the pierced null-edge count `B`. -/
def area : ℕ := edges

/-- **`entropy_area_form`.** The area law `S ≤ A`: region entropy is bounded by the
boundary area (edge count).  Carrying an explicit Bekenstein coefficient `c ≥ 1` gives
the `S ≤ c · A` family; here `c = 1`. -/
theorem entropy_area_form : entropy ≤ area := by
  simpa [entropy, area] using holographic_bound

/-- Bekenstein-style coefficient form: for any coefficient `c ≥ 1`, `S ≤ c · A`.  (With
`c = 4` this is the `S ≤ A`, hence a fortiori `S ≤ 4A`, statement; the coefficient is
carried explicitly.) -/
theorem entropy_area_coeff (c : ℕ) (hc : 1 ≤ c) : entropy ≤ c * area := by
  calc entropy ≤ area := entropy_area_form
    _ = 1 * area := (one_mul _).symm
    _ ≤ c * area := Nat.mul_le_mul_right _ hc

/-!
## Mandatory non-degeneracy and controls
-/

/-- The physical sector is non-trivial: `dim Phys = 2 > 0`. -/
theorem phys_pos : 0 < Module.finrank ℚ Phys := by rw [dim_phys_eq]; norm_num

/-- The boundary edge count is positive: `B = 3 > 0`. -/
theorem edges_pos : 0 < edges := by norm_num [edges]

/-- **Concrete numeric saturation-style witness.** All facts in one statement:
the physical sector has dimension exactly `2`, the boundary has exactly `3` edges,
`2 > 0`, `3 > 0`, and the concrete inequality `dim Phys = 2 ≤ 3 = B` holds. -/
theorem holographic_bound_numeric :
    Module.finrank ℚ Phys = 2 ∧ edges = 3 ∧ 0 < Module.finrank ℚ Phys ∧
      0 < edges ∧ Module.finrank ℚ Phys ≤ edges := by
  refine ⟨dim_phys_eq, rfl, phys_pos, edges_pos, ?_⟩
  rw [dim_phys_eq]; norm_num [edges]

/-- The interior-only control vector `e₄ = (0,0,0,1) ∈ V`. -/
def interiorState : V := ![0,0,0,1]

/-- **Control: injectivity is a genuine hypothesis on `Phys`.** There is a non-zero
*interior-only* state (`e₄`) that is NOT boundary-determined — it lies in the kernel of
`R` yet is non-zero — and it is NOT in the physical sector.  Hence the boundary
restriction is not globally injective; the reconstruction property is a real property of
`Phys`, not of all of `V`. -/
theorem interior_not_boundary_determined :
    interiorState ≠ 0 ∧ R interiorState = 0 ∧ interiorState ∉ Phys := by
  refine ⟨?_, ?_, ?_⟩
  · intro h
    have := congrFun h 3
    simp [interiorState] at this
  · rw [R, Matrix.mulVecLin_apply]
    funext i
    fin_cases i <;>
      simp [interiorState, Rm, Matrix.mulVec, dotProduct, Fin.sum_univ_four]
  · rintro ⟨w, hw⟩
    have h3 := congrFun hw 3
    rw [P, Matrix.mulVecLin_apply] at h3
    simp [interiorState, Pm, Matrix.mulVec, dotProduct] at h3

/-!
## Axiom audits (kernel-checked footprint)
-/

/-- info: 'HolographicEdgeBound.boundary_rank_le_edges' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms boundary_rank_le_edges

/-- info: 'HolographicEdgeBound.phys_injects_to_boundary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms phys_injects_to_boundary

/-- info: 'HolographicEdgeBound.holographic_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms holographic_bound

/-- info: 'HolographicEdgeBound.entropy_area_form' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms entropy_area_form

/-- info: 'HolographicEdgeBound.holographic_bound_numeric' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms holographic_bound_numeric

/-- info: 'HolographicEdgeBound.interior_not_boundary_determined' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms interior_not_boundary_determined

end HolographicEdgeBound
