import PhysicsSM.Draft.NullEdge.CARAnnihilationLocality
import PhysicsSM.Draft.NullEdge.PlueckerLayerCone

/-!
# Aristotle target: composed free-walk and pair-layer CAR cone

Provenance: Aristotle project `971f3bfd-f2c4-4e42-88f6-5d677d877990`, task
`8bec01f7-4e25-46f9-aec8-e6a51b67c665`, harvested 2026-07-12. Both target
statements were preserved exactly. The proof cleanly composes the project's
determinant-minor second quantization and Pluecker pair-layer APIs.

The target first proves that determinant-minor second quantization of a
finite-range one-particle unitary propagates genuine `CARSupported` support by
one graph neighborhood. It then composes that free Heisenberg step with one
pairwise-disjoint local Pluecker gate layer, yielding two neighborhood steps.

Preserve the exact theorem statements. `FootprintIn` is not an acceptable
replacement for `CARSupported`.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.FreePairQCACombinedCone

open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
open PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization
open PhysicsSM.Draft.NullEdge.CARAnnihilationLocality
open PhysicsSM.Draft.NullEdge.PlueckerCausalCone
open PhysicsSM.Draft.NullEdge.PlueckerLayerCone

variable {ι : Type*} [Fintype ι] [DecidableEq ι] [LinearOrder ι]

/-- Bundled determinant-minor second quantization. -/
def GammaL (U : Matrix ι ι Complex) : Fock ι →ₗ[Complex] Fock ι where
  toFun := Gamma U
  map_add' := Gamma_add U
  map_smul' := Gamma_smul U

omit [DecidableEq ι] in
@[simp] theorem GammaL_apply (U : Matrix ι ι Complex) (psi : Fock ι) :
    GammaL U psi = Gamma U psi := rfl

/-- Heisenberg conjugation by the second-quantized one-particle update. -/
def freeHeisenberg (U : Matrix ι ι Complex)
    (A : Fock ι →ₗ[Complex] Fock ι) : Fock ι →ₗ[Complex] Fock ι :=
  GammaL U ∘ₗ A ∘ₗ GammaL Uᴴ

omit [DecidableEq ι] in
@[simp] theorem freeHeisenberg_apply (U : Matrix ι ι Complex)
    (A : Fock ι →ₗ[Complex] Fock ι) (psi : Fock ι) :
    freeHeisenberg U A psi = Gamma U (A (Gamma Uᴴ psi)) := rfl

/-- A creation generator located outside the one-step neighborhood commutes with
the free Heisenberg update. -/
theorem freeHeisenberg_create_commute
    (N : ι -> Finset ι) (U : Matrix ι ι Complex)
    (hleft : Uᴴ * U = 1) (hright : U * Uᴴ = 1)
    (hlocal : forall j i, j ∉ N i -> U j i = 0)
    {R : Finset ι} {A : Fock ι →ₗ[Complex] Fock ι}
    (hA : CARSupported R A)
    {x : ι} (hx : x ∉ ballStep N R) :
    CommuteOn (createL x) (freeHeisenberg U A) := by
  intro psi
  simp only [createL_apply, freeHeisenberg_apply]
  -- Expand the left-hand side `create x ∘ Γ_U` into a Γ_U-conjugated creation sum.
  have hL : create x (Gamma U (A (Gamma Uᴴ psi)))
      = ∑ j, Uᴴ j x • Gamma U (create j (A (Gamma Uᴴ psi))) := by
    have h := gamma_create_covariance Uᴴ x (Gamma U (A (Gamma Uᴴ psi)))
    apply_fun Gamma U at h
    rw [(Gamma_unitary_inverse U hleft hright _).2] at h
    rw [h, ← GammaL_apply, map_sum]
    refine Finset.sum_congr rfl fun j _ => ?_
    rw [map_smul, GammaL_apply, (Gamma_unitary_inverse U hleft hright _).1]
  -- Expand the right-hand side `Γ_U ∘ A ∘ Γ_Uᴴ ∘ create x` into the same sum shape.
  have hR : Gamma U (A (Gamma Uᴴ (create x psi)))
      = ∑ j, Uᴴ j x • Gamma U (A (create j (Gamma Uᴴ psi))) := by
    rw [gamma_create_covariance Uᴴ x psi, map_sum, ← GammaL_apply, map_sum]
    refine Finset.sum_congr rfl fun j _ => ?_
    rw [map_smul, map_smul, GammaL_apply]
  rw [hL, hR]
  refine Finset.sum_congr rfl fun j _ => ?_
  by_cases hxj : U x j = 0
  · simp [Matrix.conjTranspose_apply, hxj]
  · -- A nonzero coefficient forces the acted mode `j` to be outside `R`.
    have hjR : j ∉ R := fun hj => hx (Finset.mem_biUnion.mpr
      ⟨j, hj, by by_contra hc; exact hxj (hlocal x j hc)⟩)
    have hcomm := (hA j hjR).1 (Gamma Uᴴ psi)
    simp only [createL_apply] at hcomm
    rw [hcomm]

/-- An annihilation generator located outside the one-step neighborhood commutes
with the free Heisenberg update. -/
theorem freeHeisenberg_annihilate_commute
    (N : ι -> Finset ι) (U : Matrix ι ι Complex)
    (hleft : Uᴴ * U = 1) (hright : U * Uᴴ = 1)
    (hlocal : forall j i, j ∉ N i -> U j i = 0)
    {R : Finset ι} {A : Fock ι →ₗ[Complex] Fock ι}
    (hA : CARSupported R A)
    {x : ι} (hx : x ∉ ballStep N R) :
    CommuteOn (annihilateL x) (freeHeisenberg U A) := by
  intro psi
  simp only [annihilateL_apply, freeHeisenberg_apply]
  -- Left-hand side: annihilation covariance applied outside `Γ_U`.
  have hL : annihilate x (Gamma U (A (Gamma Uᴴ psi)))
      = ∑ i, U x i • Gamma U (annihilate i (A (Gamma Uᴴ psi))) :=
    gamma_annihilate_covariance U x (A (Gamma Uᴴ psi))
  -- Right-hand side: conjugate the annihilation through `A ∘ Γ_Uᴴ`.
  have hR : Gamma U (A (Gamma Uᴴ (annihilate x psi)))
      = ∑ i, U x i • Gamma U (A (annihilate i (Gamma Uᴴ psi))) := by
    have hInner : Gamma Uᴴ (annihilate x psi)
        = ∑ i, U x i • annihilate i (Gamma Uᴴ psi) := by
      have h := gamma_annihilate_covariance U x (Gamma Uᴴ psi)
      rw [(Gamma_unitary_inverse U hleft hright psi).2] at h
      apply_fun Gamma Uᴴ at h
      rw [h, ← GammaL_apply, map_sum]
      refine Finset.sum_congr rfl fun i _ => ?_
      rw [map_smul, GammaL_apply, (Gamma_unitary_inverse U hleft hright _).1]
    rw [hInner, map_sum, ← GammaL_apply, map_sum]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [map_smul, map_smul, GammaL_apply]
  rw [hL, hR]
  refine Finset.sum_congr rfl fun i _ => ?_
  by_cases hxi : U x i = 0
  · simp [hxi]
  · -- A nonzero coefficient forces the acted mode `i` to be outside `R`.
    have hiR : i ∉ R := fun hi => hx (Finset.mem_biUnion.mpr
      ⟨i, hi, by by_contra hc; exact hxi (hlocal x i hc)⟩)
    have hcomm := (hA i hiR).2 (Gamma Uᴴ psi)
    simp only [annihilateL_apply] at hcomm
    rw [hcomm]

/-- A finite-range unitary one-particle update expands genuine CAR support by
at most one displayed graph neighborhood under second quantization. -/
theorem freeHeisenberg_geometric_cone
    (N : ι -> Finset ι) (U : Matrix ι ι Complex)
    (hleft : Uᴴ * U = 1) (hright : U * Uᴴ = 1)
    (hlocal : forall j i, j ∉ N i -> U j i = 0)
    {R : Finset ι} {A : Fock ι →ₗ[Complex] Fock ι}
    (hA : CARSupported R A) :
    CARSupported (ballStep N R) (freeHeisenberg U A) := by
  intro x hx
  exact ⟨freeHeisenberg_create_commute N U hleft hright hlocal hA hx,
         freeHeisenberg_annihilate_commute N U hleft hright hlocal hA hx⟩

/-- One finite-range free layer followed by one pairwise-disjoint local
Pluecker layer expands support by at most two graph-neighborhood steps. -/
theorem free_then_pairLayer_geometric_cone
    (N : ι -> Finset ι) (hN : forall i, i ∈ N i)
    (U : Matrix ι ι Complex)
    (hleft : Uᴴ * U = 1) (hright : U * Uᴴ = 1)
    (hlocalU : forall j i, j ∉ N i -> U j i = 0)
    {u : Complex} (hu : u * (starRingEnd Complex) u = 1)
    (layer : Layer ι) (hdisj : LayerDisjoint layer)
    (hlocLayer : forall m, m ∈ layer -> BlockLocal N m)
    {R : Finset ι} {A : Fock ι →ₗ[Complex] Fock ι}
    (hA : CARSupported R A) :
    CARSupported (ballIter N 2 R)
      (heisenFoldBlocks u layer (freeHeisenberg U A)) := by
  -- Step 1: the free layer grows the support by one neighborhood step.
  have h1 : CARSupported (ballStep N R) (freeHeisenberg U A) :=
    freeHeisenberg_geometric_cone N U hleft hright hlocalU hA
  -- Step 2: the pairwise-disjoint interaction layer grows it by one more.
  have h2 : CARSupported (ballStep N (ballStep N R))
      (heisenFoldBlocks u layer (freeHeisenberg U A)) :=
    heisenLayer_geometric_cone N hN hu layer hdisj hlocLayer h1
  simpa [ballIter] using h2

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FreePairQCACombinedCone.freeHeisenberg_geometric_cone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms freeHeisenberg_geometric_cone

/-- info: 'PhysicsSM.Draft.NullEdge.FreePairQCACombinedCone.free_then_pairLayer_geometric_cone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms free_then_pairLayer_geometric_cone

end PhysicsSM.Draft.NullEdge.FreePairQCACombinedCone
