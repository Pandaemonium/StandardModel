import PhysicsSM.Draft.NullEdge.CARAnnihilationLocality
import PhysicsSM.Draft.NullEdge.PlueckerLayerCone

/-!
# Aristotle target: composed free-walk and pair-layer CAR cone

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

/-- Heisenberg conjugation by the second-quantized one-particle update. -/
def freeHeisenberg (U : Matrix ι ι Complex)
    (A : Fock ι →ₗ[Complex] Fock ι) : Fock ι →ₗ[Complex] Fock ι :=
  GammaL U ∘ₗ A ∘ₗ GammaL Uᴴ

/-- A finite-range unitary one-particle update expands genuine CAR support by
at most one displayed graph neighborhood under second quantization. -/
theorem freeHeisenberg_geometric_cone
    (N : ι -> Finset ι) (U : Matrix ι ι Complex)
    (hleft : Uᴴ * U = 1) (hright : U * Uᴴ = 1)
    (hlocal : forall j i, j ∉ N i -> U j i = 0)
    {R : Finset ι} {A : Fock ι →ₗ[Complex] Fock ι}
    (hA : CARSupported R A) :
    CARSupported (ballStep N R) (freeHeisenberg U A) := by
  sorry

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
  sorry

end PhysicsSM.Draft.NullEdge.FreePairQCACombinedCone
