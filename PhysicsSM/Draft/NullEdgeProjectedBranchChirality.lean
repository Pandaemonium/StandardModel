import Mathlib
import PhysicsSM.Draft.NullEdgeSymmetryForcedSpeciesSplit

/-!
# C58: The projected branch / Weyl selector and projection-level chirality alignment

This module discharges the **chirality-alignment** part of the remaining Gate C
obligation isolated by C21
(`PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean`):

> `OperatorForcesAlignmentAfterProjection` — construct an explicit projector that
> cuts each two-dimensional, chirality-balanced branch kernel of the flat
> tetrahedral Clifford symbol down to the desired one-dimensional `g5 a` line,
> and prove the projected chirality statement.

## Relation to C21 and the missing base modules

C21 builds the flat tetrahedral Clifford symbol `c(p)` on the Weyl spinor space
`Spin = Fin 2 ⊕ Fin 2` and proves that, on each high-momentum null branch, the
symbol kernel is **two-dimensional and chirality-balanced**: it contains both a
right-handed (`γ₅ = +1`) and a left-handed (`γ₅ = -1`) zero mode
(`branchKernel_chirality_sign`).  Hence the *bare* operator does **not** assign a
single chirality sign per branch (`no_full_symbol_single_chirality`).

C21 itself imports `PhysicsSM.Draft.NullEdgeFlavoredChirality` and
`PhysicsSM.Draft.TetrahedralNullBranch`, **which are not present in this project
snapshot**, so `NullEdgeActualCliffordSymbol.lean` does not currently compile and
cannot be imported.  To deliver a self-contained, kernel-checked result we
therefore reproduce here exactly the Clifford data C21 uses (the Weyl block
symbol `c(p) = [[0, A(p)],[B(p), 0]]`, the chirality operator `γ₅`, and the
Minkowski square `mink`).  The branch index enters only through the *target
chirality sign* `g5 a`, reused verbatim from the standalone module
`PhysicsSM.Draft.NullEdgeSymmetryForcedSpeciesSplit` (`g5 = (+,+,-,-)`).

All operator statements are proved for an arbitrary null covector `p`
(`mink p = 0`, `p ≠ 0`); each of the four C21 branch covectors `branchP a` is
such a `p`, so the results specialise to every branch.

## The explicit projector

The selector is the **Weyl / chirality projector onto the `g5 a` eigenline**:
`branchProj a v = ½ (v + (g5 a) • γ₅ v)`.  This is the projector onto the
`γ₅`-eigenspace with eigenvalue `g5 a ∈ {±1}`; it is entirely explicit.

## What is proved

* `projectedBranch_chirality_aligned` — for every `v`, the projected vector lies
  in the `g5 a` eigenline of `γ₅`: `γ₅ (branchProj a v) = (g5 a) • branchProj a v`.
* `projectedKernel_finrank_one` — for any nonzero null covector `p`, the
  **projected branch kernel** `ker c(p) ⊓ (γ₅-eigenspace for g5 a)` is exactly
  one-dimensional: the projection cuts the two-dimensional C21 kernel down to a
  single chirality line.
* `operatorForcesAlignmentAfterProjection` — the C21 obligation, restated at
  projection level and discharged by `branchProj`.
* `gateC_projected_chirality_clause` — the bundled chirality-alignment clause.

## Honest scope (Krein and ghost obligations remain separate)

This module closes the **chirality-alignment** clause of Gate C *only*.  It does
**not** assert full Gate C release.  Two further, independent clauses remain, as
recorded by other modules and not implied by anything here:

* **Krein positivity (K2)** — `NullEdgeKreinPositiveReleaseCriterion`: the
  physical sector `Pphys = Pbranch 0 + Pbranch 2` must be the maximal
  Krein-positive sector.
* **Ghost safety (C47/C48)** — `NullEdgeGateCGhostZeroSafety.GhostZeroSafe` /
  `PostGaugeGhostSafe`: a flavored index alone never releases Gate C.

The predicate `RemainingGateCObligations` below makes this separation explicit;
it is a *definition*, asserting nothing, purely documenting the open clauses.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeProjectedBranchChirality

open Matrix Module
open PhysicsSM.Draft.NullEdgeSymmetryForcedSpeciesSplit (g5)

/-! ## Spinor space, the chirality operator `γ₅`, and the Clifford symbol -/

/-- Weyl spinor index `Fin 2 ⊕ Fin 2` (right-handed `inl`, left-handed `inr`). -/
abbrev Spin := Fin 2 ⊕ Fin 2

/-- 4×4 complex matrices on the spinor space. -/
abbrev CMat4 := Matrix Spin Spin ℂ

/-- Spacetime chirality `γ₅ = [[I,0],[0,-I]]` (eigenvalue `+1` on `inl`,
`-1` on `inr`). -/
def gamma5 : CMat4 := Matrix.fromBlocks 1 0 0 (-1)

/-- The Minkowski square `mink p = p₀² - p₁² - p₂² - p₃²` (mostly-minus). -/
def mink (p : Fin 4 → ℂ) : ℂ := p 0 ^ 2 - p 1 ^ 2 - p 2 ^ 2 - p 3 ^ 2

/-- Upper-right Weyl block `A(p) = p₀ I + pⁱσⁱ`. -/
def blockA (p : Fin 4 → ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![p 0 + p 3, p 1 - Complex.I * p 2; p 1 + Complex.I * p 2, p 0 - p 3]

/-- Lower-left Weyl block `B(p) = p₀ I - pⁱσⁱ`. -/
def blockB (p : Fin 4 → ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![p 0 - p 3, -(p 1) + Complex.I * p 2; -(p 1) - Complex.I * p 2, p 0 + p 3]

/-- The flat tetrahedral Clifford symbol `c(p) = [[0, A(p)],[B(p), 0]]`. -/
def cliffordSymbol (p : Fin 4 → ℂ) : CMat4 :=
  Matrix.fromBlocks 0 (blockA p) (blockB p) 0

/-! ## Basic algebra of `γ₅` and the blocks -/

theorem gamma5_sq : gamma5 * gamma5 = 1 := by
  unfold gamma5; rw [Matrix.fromBlocks_multiply]
  ext i j; rcases i with i | i <;> rcases j with j | j <;> simp [Matrix.one_apply]

theorem gamma5_mulVec_sq (v : Spin → ℂ) : gamma5 *ᵥ (gamma5 *ᵥ v) = v := by
  rw [Matrix.mulVec_mulVec, gamma5_sq, Matrix.one_mulVec]

theorem blockA_det (p : Fin 4 → ℂ) : (blockA p).det = mink p := by
  simp only [blockA, mink, Matrix.det_fin_two_of]
  ring_nf; rw [show Complex.I ^ 2 = -1 from Complex.I_sq]; ring

theorem blockB_det (p : Fin 4 → ℂ) : (blockB p).det = mink p := by
  simp only [blockB, mink, Matrix.det_fin_two_of]
  ring_nf; rw [show Complex.I ^ 2 = -1 from Complex.I_sq]; ring

/-- `c(p)` acts on a Weyl-split vector by the off-diagonal blocks. -/
theorem clifford_mulVec (p : Fin 4 → ℂ) (v : Spin → ℂ) :
    cliffordSymbol p *ᵥ v =
      Sum.elim (blockA p *ᵥ (v ∘ Sum.inr)) (blockB p *ᵥ (v ∘ Sum.inl)) := by
  rw [cliffordSymbol, fromBlocks_mulVec]; simp

/-- `γ₅` acts on a Weyl-split vector by `(x, y) ↦ (x, -y)`. -/
theorem gamma5_mulVec (v : Spin → ℂ) :
    gamma5 *ᵥ v = Sum.elim (v ∘ Sum.inl) (-(v ∘ Sum.inr)) := by
  rw [gamma5, fromBlocks_mulVec]
  ext i; cases i <;> simp [Matrix.neg_mulVec]

/-- `A(p) = 0` forces `p = 0`. -/
theorem blockA_ne_zero (p : Fin 4 → ℂ) (hp : p ≠ 0) : blockA p ≠ 0 := by
  intro H
  apply hp
  have h00 := congrFun (congrFun H 0) 0
  have h01 := congrFun (congrFun H 0) 1
  have h10 := congrFun (congrFun H 1) 0
  have h11 := congrFun (congrFun H 1) 1
  simp [blockA] at h00 h01 h10 h11
  funext i
  fin_cases i <;> simp_all <;>
    (rw [Complex.ext_iff] at *; constructor <;>
      simp_all [Complex.add_re, Complex.add_im, Complex.sub_re, Complex.sub_im,
        Complex.mul_re, Complex.mul_im] <;> linarith)

/-- `B(p) = 0` forces `p = 0`. -/
theorem blockB_ne_zero (p : Fin 4 → ℂ) (hp : p ≠ 0) : blockB p ≠ 0 := by
  intro H
  apply hp
  have h00 := congrFun (congrFun H 0) 0
  have h01 := congrFun (congrFun H 0) 1
  have h10 := congrFun (congrFun H 1) 0
  have h11 := congrFun (congrFun H 1) 1
  simp [blockB] at h00 h01 h10 h11
  funext i
  fin_cases i <;> simp_all <;>
    (rw [Complex.ext_iff] at *; constructor <;>
      simp_all [Complex.add_re, Complex.add_im, Complex.sub_re, Complex.sub_im,
        Complex.mul_re, Complex.mul_im] <;> linarith)

/-! ## A 2×2 nilpotent-block kernel is one-dimensional -/

/-- A nonzero singular `2×2` complex matrix has a one-dimensional kernel. -/
theorem ker2x2_finrank_one (M : Matrix (Fin 2) (Fin 2) ℂ) (hM : M ≠ 0)
    (hdet : M.det = 0) :
    Module.finrank ℂ (LinearMap.ker M.mulVecLin) = 1 := by
  have hsum := LinearMap.finrank_range_add_finrank_ker (M.mulVecLin)
  rw [finrank_pi] at hsum
  simp only [Fintype.card_fin] at hsum
  have hrange_pos : 0 < finrank ℂ (LinearMap.range M.mulVecLin) := by
    rw [Module.finrank_pos_iff, Submodule.nontrivial_iff_ne_bot, ne_eq, LinearMap.range_eq_bot]
    intro hz
    apply hM
    ext i j
    have := LinearMap.congr_fun hz (Pi.single j 1)
    simpa [Matrix.mulVecLin, Matrix.mulVec_single] using congrFun this i
  have hker_pos : 0 < finrank ℂ (LinearMap.ker M.mulVecLin) := by
    rw [Module.finrank_pos_iff, Submodule.nontrivial_iff_ne_bot, ne_eq, LinearMap.ker_eq_bot]
    obtain ⟨v, hv, hvz⟩ := Matrix.exists_mulVec_eq_zero_iff.mpr hdet
    intro hinj
    apply hv
    apply hinj
    simpa [Matrix.mulVecLin] using hvz
  omega

/-! ## The Weyl embeddings of the two chirality blocks -/

/-- Right-handed embedding `x ↦ (x, 0)` into the Weyl spinor space. -/
def inlMap : (Fin 2 → ℂ) →ₗ[ℂ] (Spin → ℂ) where
  toFun x := Sum.elim x 0
  map_add' x y := by ext i; cases i <;> simp
  map_smul' c x := by ext i; cases i <;> simp

/-- Left-handed embedding `y ↦ (0, y)` into the Weyl spinor space. -/
def inrMap : (Fin 2 → ℂ) →ₗ[ℂ] (Spin → ℂ) where
  toFun y := Sum.elim 0 y
  map_add' x y := by ext i; cases i <;> simp
  map_smul' c x := by ext i; cases i <;> simp

theorem inlMap_injective : Function.Injective inlMap := by
  intro x y h
  have : (Sum.elim x (0 : Fin 2 → ℂ)) = Sum.elim y 0 := h
  funext i; have := congrFun this (Sum.inl i); simpa using this

theorem inrMap_injective : Function.Injective inrMap := by
  intro x y h
  have : (Sum.elim (0 : Fin 2 → ℂ) x) = Sum.elim (0 : Fin 2 → ℂ) y := h
  funext i; have := congrFun this (Sum.inr i); simpa using this

/-! ## The `γ₅`-eigenspaces and the projected branch kernel -/

/-- The `γ₅`-eigenspace with eigenvalue `s`. -/
def gamma5Eigenspace (s : ℂ) : Submodule ℂ (Spin → ℂ) :=
  LinearMap.ker (gamma5.mulVecLin - s • LinearMap.id)

theorem mem_gamma5Eigenspace {s : ℂ} {v : Spin → ℂ} :
    v ∈ gamma5Eigenspace s ↔ gamma5 *ᵥ v = s • v := by
  unfold gamma5Eigenspace
  rw [LinearMap.mem_ker]
  simp only [LinearMap.sub_apply, LinearMap.smul_apply, LinearMap.id_apply,
    Matrix.mulVecLin_apply, sub_eq_zero]

/-- The **projected branch kernel**: the part of the Clifford-symbol kernel on
which `γ₅` acts by the target chirality sign `g5 a`. -/
def projectedKernel (a : Fin 4) (p : Fin 4 → ℂ) : Submodule ℂ (Spin → ℂ) :=
  LinearMap.ker (cliffordSymbol p).mulVecLin ⊓ gamma5Eigenspace (g5 a : ℂ)

/-- Right-handed (`+1`) projected kernel is the right-handed embedding of
`ker B(p)`. -/
theorem projectedKernel_plus (p : Fin 4 → ℂ) :
    LinearMap.ker (cliffordSymbol p).mulVecLin ⊓ gamma5Eigenspace 1 =
      Submodule.map inlMap (LinearMap.ker (blockB p).mulVecLin) := by
  ext v
  simp only [Submodule.mem_inf, LinearMap.mem_ker, Matrix.mulVecLin_apply,
    mem_gamma5Eigenspace, one_smul, Submodule.mem_map]
  constructor
  · rintro ⟨hker, heig⟩
    rw [gamma5_mulVec] at heig
    have hinr : ∀ j, v (Sum.inr j) = 0 := by
      intro j; have hj := congrFun heig (Sum.inr j)
      simp only [Sum.elim_inr, Pi.neg_apply, Function.comp_apply] at hj
      linear_combination (-(1/2 : ℂ)) * hj
    rw [clifford_mulVec] at hker
    refine ⟨v ∘ Sum.inl, ?_, ?_⟩
    · funext j; have hj := congrFun hker (Sum.inr j); simpa using hj
    · show Sum.elim (v ∘ Sum.inl) 0 = v
      funext i; cases i with
      | inl i => simp
      | inr j => simp [hinr j]
  · rintro ⟨x, hx, rfl⟩
    have h1 : (inlMap x) ∘ Sum.inr = 0 := by funext j; simp [inlMap]
    have h2 : (inlMap x) ∘ Sum.inl = x := by funext j; simp [inlMap]
    refine ⟨?_, ?_⟩
    · rw [clifford_mulVec, h1, h2, hx]
      ext i; cases i <;> simp
    · rw [gamma5_mulVec, h1, h2]; simp [inlMap]

/-- Left-handed (`-1`) projected kernel is the left-handed embedding of
`ker A(p)`. -/
theorem projectedKernel_minus (p : Fin 4 → ℂ) :
    LinearMap.ker (cliffordSymbol p).mulVecLin ⊓ gamma5Eigenspace (-1) =
      Submodule.map inrMap (LinearMap.ker (blockA p).mulVecLin) := by
  ext v
  simp only [Submodule.mem_inf, LinearMap.mem_ker, Matrix.mulVecLin_apply,
    mem_gamma5Eigenspace, Submodule.mem_map]
  constructor
  · rintro ⟨hker, heig⟩
    rw [gamma5_mulVec] at heig
    have hinl : ∀ i, v (Sum.inl i) = 0 := by
      intro i; have hi := congrFun heig (Sum.inl i)
      simp only [Sum.elim_inl, Function.comp_apply, Pi.smul_apply, smul_eq_mul] at hi
      linear_combination (1/2 : ℂ) * hi
    rw [clifford_mulVec] at hker
    refine ⟨v ∘ Sum.inr, ?_, ?_⟩
    · funext i; have hi := congrFun hker (Sum.inl i); simpa using hi
    · show Sum.elim (0 : Fin 2 → ℂ) (v ∘ Sum.inr) = v
      funext i; rcases i with j | k
      · simp [hinl j]
      · simp
  · rintro ⟨y, hy, rfl⟩
    have h1 : (inrMap y) ∘ Sum.inr = y := by funext j; simp [inrMap]
    have h2 : (inrMap y) ∘ Sum.inl = 0 := by funext j; simp [inrMap]
    refine ⟨?_, ?_⟩
    · rw [clifford_mulVec, h1, h2, hy]
      ext i; rcases i with j | k <;> simp
    · rw [gamma5_mulVec, h1, h2]; ext i; rcases i with j | k <;> simp [inrMap]

/-! ## The projected branch kernel is one-dimensional -/

/-- **Projected kernel is one-dimensional.**  For any nonzero null covector `p`
the projected branch kernel is exactly one-dimensional: the Weyl projection cuts
the two-dimensional, chirality-balanced C21 kernel down to the single `g5 a`
chirality line. -/
theorem projectedKernel_finrank_one (a : Fin 4) (p : Fin 4 → ℂ)
    (hnull : mink p = 0) (hp : p ≠ 0) :
    Module.finrank ℂ (projectedKernel a p) = 1 := by
  have hBdet : (blockB p).det = 0 := by rw [blockB_det, hnull]
  have hAdet : (blockA p).det = 0 := by rw [blockA_det, hnull]
  have hsign : (g5 a : ℂ) = 1 ∨ (g5 a : ℂ) = -1 := by fin_cases a <;> simp [g5]
  rcases hsign with h | h
  · rw [projectedKernel, h, projectedKernel_plus,
      ← (Submodule.equivMapOfInjective inlMap inlMap_injective _).finrank_eq]
    exact ker2x2_finrank_one _ (blockB_ne_zero p hp) hBdet
  · rw [projectedKernel, h, projectedKernel_minus,
      ← (Submodule.equivMapOfInjective inrMap inrMap_injective _).finrank_eq]
    exact ker2x2_finrank_one _ (blockA_ne_zero p hp) hAdet

/-! ## Projection-level chirality alignment -/

theorem g5_sq (a : Fin 4) : (g5 a : ℂ) * (g5 a : ℂ) = 1 := by
  fin_cases a <;> simp [g5]

/-- The explicit Weyl / chirality projector onto the `g5 a` eigenline. -/
def branchProj (a : Fin 4) (v : Spin → ℂ) : Spin → ℂ :=
  (2⁻¹ : ℂ) • (v + (g5 a : ℂ) • (gamma5 *ᵥ v))

/-- **Projection-level chirality alignment.**  After applying the branch
projector, `γ₅` acts by the single chirality sign `g5 a`. -/
theorem projectedBranch_chirality_aligned (a : Fin 4) (v : Spin → ℂ) :
    gamma5 *ᵥ (branchProj a v) = (g5 a : ℂ) • (branchProj a v) := by
  unfold branchProj
  rw [Matrix.mulVec_smul, Matrix.mulVec_add, Matrix.mulVec_smul, gamma5_mulVec_sq]
  have h := g5_sq a
  ext i
  simp only [Pi.smul_apply, Pi.add_apply, smul_eq_mul]
  linear_combination (-(2⁻¹) * (gamma5 *ᵥ v) i) * h

/-- The C21 obligation, restated at projection level for a family of branch
projectors `P`. -/
def OperatorForcesAlignmentAfterProjection
    (P : Fin 4 → (Spin → ℂ) → (Spin → ℂ)) : Prop :=
  ∀ a, ∀ p : Fin 4 → ℂ, mink p = 0 → ∀ v : Spin → ℂ, v ≠ 0 →
    cliffordSymbol p *ᵥ v = 0 → P a v ≠ 0 →
    gamma5 *ᵥ (P a v) = ((g5 a : ℂ)) • (P a v)

/-- **The operator forces alignment after projection.**  The explicit Weyl
projector `branchProj` discharges the C21 projection-level obligation. -/
theorem operatorForcesAlignmentAfterProjection :
    OperatorForcesAlignmentAfterProjection branchProj := by
  intro a p _ v _ _ _
  exact projectedBranch_chirality_aligned a v

/-! ## The Gate C chirality clause (chirality only) -/

/-- The bundled **chirality-alignment** clause closed by this module: the Weyl
projector forces a single chirality `g5 a` after projection, and the projected
branch kernel is one-dimensional on every nonzero null covector. -/
def GateCProjectedChiralityClause : Prop :=
  OperatorForcesAlignmentAfterProjection branchProj ∧
    (∀ a (p : Fin 4 → ℂ), mink p = 0 → p ≠ 0 →
      Module.finrank ℂ (projectedKernel a p) = 1)

theorem gateC_projected_chirality_clause : GateCProjectedChiralityClause :=
  ⟨operatorForcesAlignmentAfterProjection,
    fun a p h hp => projectedKernel_finrank_one a p h hp⟩

/-- **Honest scope marker.**  Full Gate C release requires, *in addition* to the
chirality clause proved here, the two independent clauses that remain open:
Krein positivity (K2) and ghost safety (C47/C48).  This is a definition only; it
asserts nothing and proves nothing about those clauses. -/
def RemainingGateCObligations (kreinPositive ghostSafe : Prop) : Prop :=
  kreinPositive ∧ ghostSafe

end PhysicsSM.Draft.NullEdgeProjectedBranchChirality
