import Mathlib

/-!
# Gate YM T3: abstract finite flux-sector support API

This draft module is the general, label-agnostic companion to
`FluxSectorZ2.lean`. It does not construct a Yang-Mills transfer matrix,
prove spectral facts, or identify the physical flux labels for a nonabelian
finite group. Instead it freezes the finite support bookkeeping that Q3 will
need once those labels and kernels are supplied:

* a sector label map on a finite configuration space;
* support of a wavefunction in one sector;
* the diagonal projection onto a sector;
* idempotence, orthogonality, and finite decomposition by sector projections;
* a transfer kernel that has zero matrix entries between different sectors;
* the finite identity that such a transfer maps sector-supported
  wavefunctions back into the same sector and commutes with projection.

Provenance: `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md`, section 14
Q3, and `AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md`,
`design:q3-flux-sector`. This file is deliberately abstract so Fable/Aristotle
can review or replace the general finite-G label design without disturbing the
already kernel-checked Z2 torus instance.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite definition / sector bookkeeping**.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace FluxSectorGeneral

/-- A sector label map on a finite configuration space.

For Q3, `Config` will later be a lattice configuration space and `Label`
will encode winding/'t Hooft flux data. -/
structure SectorData (Config Label : Type*) where
  label : Config -> Label

namespace SectorData

variable {Config Label : Type*}

/-- A wavefunction is supported in a sector when every configuration with
nonzero amplitude has the target label. -/
def SupportedInSector (S : SectorData Config Label) (target : Label)
    (psi : Config -> Complex) : Prop :=
  forall x : Config, psi x ≠ 0 -> S.label x = target

/-- The diagonal projection onto one sector. -/
def sectorProjection [DecidableEq Label] (S : SectorData Config Label) (target : Label)
    (psi : Config -> Complex) : Config -> Complex :=
  fun x => if S.label x = target then psi x else 0

/-- The sector projection is supported in its target sector. -/
theorem supportedInSector_sectorProjection [DecidableEq Label] (S : SectorData Config Label)
    (target : Label) (psi : Config -> Complex) :
    SupportedInSector S target (sectorProjection S target psi) := by
  intro x hx
  by_cases hlabel : S.label x = target
  · exact hlabel
  · exfalso
    exact hx (by simp [sectorProjection, hlabel])

/-- If a wavefunction is already supported in a sector, projecting onto that
sector leaves it unchanged. -/
theorem sectorProjection_eq_self_of_supported [DecidableEq Label] (S : SectorData Config Label)
    (target : Label) (psi : Config -> Complex)
    (hpsi : SupportedInSector S target psi) :
    sectorProjection S target psi = psi := by
  funext x
  by_cases hlabel : S.label x = target
  · simp [sectorProjection, hlabel]
  · have hzero : psi x = 0 := by
      by_contra hnonzero
      exact hlabel (hpsi x hnonzero)
    simp [sectorProjection, hlabel, hzero]

/-- Sector projections are idempotent. -/
theorem sectorProjection_idempotent [DecidableEq Label] (S : SectorData Config Label)
    (target : Label) (psi : Config -> Complex) :
    sectorProjection S target (sectorProjection S target psi) =
      sectorProjection S target psi :=
  sectorProjection_eq_self_of_supported S target (sectorProjection S target psi)
    (supportedInSector_sectorProjection S target psi)

/-- Projecting onto two distinct sectors in succession gives zero. -/
theorem sectorProjection_sectorProjection_eq_zero_of_ne [DecidableEq Label]
    (S : SectorData Config Label) {first second : Label}
    (psi : Config -> Complex) (hne : first ≠ second) :
    sectorProjection S second (sectorProjection S first psi) = fun _ => 0 := by
  funext x
  by_cases hfirst : S.label x = first
  · simp [sectorProjection, hfirst, hne]
  · simp [sectorProjection, hfirst]

/-- A finite label set decomposes every wavefunction as the sum of its
sector projections. -/
theorem sum_sectorProjection_eq_self [Fintype Label] [DecidableEq Label]
    (S : SectorData Config Label) (psi : Config -> Complex) :
    (fun x : Config => ∑ target : Label, sectorProjection S target psi x) =
      psi := by
  funext x
  simp [sectorProjection]

/-- A finite transfer kernel acts by summing over the source configuration.

The convention is `K x y`: amplitude from source `y` to target `x`. -/
def applyTransfer [Fintype Config] (K : Config -> Config -> Complex)
    (psi : Config -> Complex) : Config -> Complex :=
  fun x => ∑ y : Config, K x y * psi y

/-- A transfer kernel preserves sector labels when it has no matrix entry
between configurations with different labels. -/
def KernelPreservesLabels (S : SectorData Config Label)
    (K : Config -> Config -> Complex) : Prop :=
  forall x y : Config, S.label x ≠ S.label y -> K x y = 0

/-- A label-preserving finite transfer kernel maps sector-supported
wavefunctions back into the same sector. -/
theorem supportedInSector_applyTransfer [Fintype Config]
    (S : SectorData Config Label) (K : Config -> Config -> Complex)
    (target : Label) (psi : Config -> Complex)
    (hK : KernelPreservesLabels S K)
    (hpsi : SupportedInSector S target psi) :
    SupportedInSector S target (applyTransfer K psi) := by
  intro x hx
  by_contra hlabel
  have hsum : applyTransfer K psi x = 0 := by
    unfold applyTransfer
    apply Finset.sum_eq_zero
    intro y _hy
    by_cases hyzero : psi y = 0
    · simp [hyzero]
    · have hylabel : S.label y = target := hpsi y hyzero
      have hdiff : S.label x ≠ S.label y := by
        intro heq
        exact hlabel (heq.trans hylabel)
      simp [hK x y hdiff]
  exact hx hsum

/-- Equivalently, after a label-preserving finite transfer acts on a
sector-supported wavefunction, projecting back to that sector does nothing. -/
theorem sectorProjection_applyTransfer_eq_self [DecidableEq Label] [Fintype Config]
    (S : SectorData Config Label) (K : Config -> Config -> Complex)
    (target : Label) (psi : Config -> Complex)
    (hK : KernelPreservesLabels S K)
    (hpsi : SupportedInSector S target psi) :
    sectorProjection S target (applyTransfer K psi) =
      applyTransfer K psi :=
  sectorProjection_eq_self_of_supported S target (applyTransfer K psi)
    (supportedInSector_applyTransfer S K target psi hK hpsi)

/-- A label-preserving finite transfer kernel commutes with the diagonal
projection onto each sector. -/
theorem sectorProjection_applyTransfer_commute [DecidableEq Label] [Fintype Config]
    (S : SectorData Config Label) (K : Config -> Config -> Complex)
    (target : Label) (psi : Config -> Complex)
    (hK : KernelPreservesLabels S K) :
    sectorProjection S target (applyTransfer K psi) =
      applyTransfer K (sectorProjection S target psi) := by
  funext x
  unfold sectorProjection applyTransfer
  by_cases hx : S.label x = target
  · simp only [hx, ↓reduceIte]
    apply Finset.sum_congr rfl
    intro y _hy
    by_cases hy : S.label y = target
    · simp [hy]
    · have hdiff : S.label x ≠ S.label y := by
        intro hxy
        exact hy (hxy.symm.trans hx)
      simp [hy, hK x y hdiff]
  · simp only [hx, ↓reduceIte]
    symm
    apply Finset.sum_eq_zero
    intro y _hy
    by_cases hy : S.label y = target
    · have hdiff : S.label x ≠ S.label y := by
        intro hxy
        exact hx (hxy.trans hy)
      simp [hy, hK x y hdiff]
    · simp [hy]

end SectorData

end FluxSectorGeneral
end GateYM
end NullEdge
end Draft
end PhysicsSM
