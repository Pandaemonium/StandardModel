import Mathlib
import PhysicsSM.Draft.NullEdgeFMSFiniteComposite

/-!
# Bridge: Furey/Hughes electromagnetic generator vs. the null-edge FMS photon stabilizer

Null-edge unified-mass cross-construction audit (job FUR-E1).

This module relates two independent constructions of the unbroken
electromagnetic direction `U(1)_em`:

* the **Furey/Hughes-style** electromagnetic charge generator, selected inside
  the internal division-algebraic ladder algebra by the Gell-Mann–Nishijima
  relation `Q = T₃ + Y/2` (see `PhysicsSM.Algebra.Furey.ElectroweakBridge` and
  `PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity`); and
* the **null-edge FMS photon stabilizer** `span ℝ {Q}`, the one-dimensional
  kernel of the electroweak orbit-obstruction map that stabilises the Higgs
  reference section (see `PhysicsSM.Draft.NullEdgeElectroweakStabilizer` and
  `PhysicsSM.Draft.NullEdgeFMSFiniteComposite`).

## Provenance / import note

The Furey electroweak modules
(`PhysicsSM.Algebra.Furey.ElectroweakBridge`,
`OperatorElectroweakIdentity`, `QopElectroweakConsistency`,
`ElectroweakCompletePackage`) cannot be imported in this project snapshot:
their upstream dependencies (`PhysicsSM.Algebra.Furey.AnomalyBridge`,
`PhysicsSM.StandardModel.OneGenerationTable`,
`PhysicsSM.Algebra.Furey.QopJbarEigenBridge`,
`PhysicsSM.Algebra.Furey.MinimalLeftIdeal`,
`...ElectroweakPaperPackage`, `...T3OpJbar`, `...WeakIsospinDoublets`,
`...WeakIsospinLadder`) are absent from the snapshot, so those files do not
build.  To make the bridge self-contained and kernel-checked, the small,
dependency-free Furey *content* actually used here — the finite electroweak
charge table and the Gell-Mann–Nishijima relation `Q = T₃ + Y/2` — is
**reproduced verbatim** below (functions `fPhysicalQ`, `fTargetT3`, `fTargetY`
and lemma `furey_gellMannNishijima`, mirroring
`ElectroweakBridge.physicalQ`, `targetT3`, `targetY` and
`gellMannNishijima_all`).  When the Furey upstream modules are restored, these
local copies can be replaced by the original imports without changing any of the
bridge theorems.

## Scope

This is a **stabilizer / orbit-stiffness compatibility** statement: the Furey
electromagnetic generator `Q = T₃ + Y/2` and the null-edge FMS photon stabilizer
`span ℝ {Q}` are the *same* one-dimensional unbroken direction.  It is **not** a
W/Z pole theorem and **not** a mass prediction.  The shared structural fact is
that the Gell-Mann–Nishijima combination `Q = T₃ + Y/2` is exactly the generator
that annihilates the Higgs reference section, hence carries zero orbit-stiffness
mass (the massless photon).

## Main results

* `furey_gellMannNishijima` — reproduced Furey table GMN `Q = T₃ + Y/2`.
* `fureyEMgen_eq_T3_plus_Yhalf` — the EM generator coordinate vector is
  `T₃-generator + (Y/2)-generator`, i.e. GMN at the coordinate level.
* `fureyEMgen_eq_Qgen` — the Furey EM generator equals the null-edge `Qgen`.
* `rho_fureyEMgen` / `Qmat_eq_T3_add_Yhalf` — matrix-level GMN
  `ρ(Q) = Q = T₃ + Y/2 = diag(1,0)`.
* `fureyEMgen_stabilizes_vacuum` — `ρ(Q) H₀ = 0`.
* `fureyEMgen_massless` — `massForm v Q = 0` (zero orbit-stiffness mass).
* `fureyEMgen_span_eq_photon_stabilizer` — `span ℝ {Q} = ker B_EW`, the FMS
  photon stabilizer.
* `furey_EM_generator_is_null_edge_photon_stabilizer` — the assembled bridge.
-/

namespace PhysicsSM
namespace Draft
namespace FureyEWStabilizerComparison

open Matrix Module

/-! ### Reproduced (dependency-free) Furey electroweak charge table

These mirror `PhysicsSM.Algebra.Furey.ElectroweakBridge.{physicalQ, targetT3,
targetY}` and `gellMannNishijima_all`.  They are reproduced here only because the
original module is not importable in this snapshot (see the provenance note in
the module docstring). -/

/-- Physical electric charge for the eight Furey Jbar states (mirror of
`ElectroweakBridge.physicalQ`). -/
def fPhysicalQ (s : Fin 8) : ℚ :=
  match s.val with
  | 0 => 0
  | 1 => -1 / 3
  | 2 => -1 / 3
  | 3 => -1 / 3
  | 4 => 2 / 3
  | 5 => 2 / 3
  | 6 => 2 / 3
  | _ => -1

/-- Target weak-isospin third component (mirror of `ElectroweakBridge.targetT3`). -/
def fTargetT3 (s : Fin 8) : ℚ :=
  match s.val with
  | 0 => 1 / 2
  | 1 => -1 / 2
  | 2 => -1 / 2
  | 3 => -1 / 2
  | 4 => 1 / 2
  | 5 => 1 / 2
  | 6 => 1 / 2
  | _ => -1 / 2

/-- Target hypercharge computed from `Y = 2 (Q − T₃)` (mirror of
`ElectroweakBridge.targetY`). -/
def fTargetY (s : Fin 8) : ℚ := 2 * (fPhysicalQ s - fTargetT3 s)

/-- **Furey table Gell-Mann–Nishijima** `Q = T₃ + Y/2`, reproduced from
`ElectroweakBridge.gellMannNishijima_all`. -/
theorem furey_gellMannNishijima (s : Fin 8) :
    fPhysicalQ s = fTargetT3 s + fTargetY s / 2 := by
  simp only [fTargetY]; ring

/-! ### The Furey electromagnetic generator in the null-edge coordinate basis

The null-edge orbit-stiffness picture (`NullEdgeElectroweakStabilizer`) uses real
coordinates `(x₀, x₁, x₂, x₃)` along the Hermitian generators
`(T₁, T₂, T₃, Y/2)`.  We express the Furey electromagnetic generator
`Q = T₃ + Y/2` (the Gell-Mann–Nishijima combination) in this basis. -/

/-- The coordinate vector of `T₃` in the basis `(T₁, T₂, T₃, Y/2)`. -/
def T3gen : Fin 4 → ℝ := ![0, 0, 1, 0]

/-- The coordinate vector of `Y/2` in the basis `(T₁, T₂, T₃, Y/2)`. -/
def Yhalfgen : Fin 4 → ℝ := ![0, 0, 0, 1]

/-- The Gell-Mann–Nishijima generator `cT₃·T₃ + cY·(Y/2)` in coordinates. -/
def gmnGenerator (cT3 cY : ℝ) : Fin 4 → ℝ := ![0, 0, cT3, cY]

/-- The **Furey electromagnetic generator** `Q = T₃ + Y/2` in null-edge
coordinates (`cT₃ = cY = 1`). -/
def fureyEMgen : Fin 4 → ℝ := gmnGenerator 1 1

/-- **Gell-Mann–Nishijima at the coordinate level**: the EM generator is the sum
of the `T₃`-generator and the `Y/2`-generator. -/
theorem fureyEMgen_eq_T3_plus_Yhalf : fureyEMgen = T3gen + Yhalfgen := by
  funext i
  fin_cases i <;> simp [fureyEMgen, gmnGenerator, T3gen, Yhalfgen]

/-- The Furey EM generator coordinate vector equals the null-edge `Qgen`
(`= ![0,0,1,1]`), the generator of the FMS photon stabilizer. -/
theorem fureyEMgen_eq_Qgen : fureyEMgen = Qgen := by
  funext i
  fin_cases i <;> rfl

/-! ### Matrix-level Gell-Mann–Nishijima -/

/-- Matrix-level GMN: `Q = T₃ + Y/2 = diag(1, 0)`. -/
theorem Qmat_eq_T3_add_Yhalf : Qmat = T3 + Yhalf := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Qmat, T3, Yhalf, Matrix.add_apply] <;> norm_num

/-- The representation of the Furey EM generator is the charge matrix
`ρ(Q) = diag(1, 0)`. -/
theorem rho_fureyEMgen : rho fureyEMgen = Qmat := by
  rw [fureyEMgen_eq_Qgen, rho_Qgen]

/-! ### The Furey EM generator is the null-edge FMS photon stabilizer -/

/-- The Furey EM generator stabilises the Higgs reference section:
`ρ(Q) H₀ = 0`. -/
theorem fureyEMgen_stabilizes_vacuum (v : ℝ) :
    (rho fureyEMgen) *ᵥ (H0 v) = 0 := by
  rw [rho_fureyEMgen]; exact Qmat_mulVec_H0 v

/-- The Furey EM generator carries **zero orbit-stiffness mass**: it is the
massless photon direction. -/
theorem fureyEMgen_massless (v : ℝ) : massForm v fureyEMgen = 0 := by
  rw [massForm, fureyEMgen_stabilizes_vacuum v]
  simp [cnorm2]

/-- **Stabilizer bridge.**  The line spanned by the Furey electromagnetic
generator `Q = T₃ + Y/2` is exactly the null-edge FMS photon stabilizer
`ker B_EW` (the `u(1)_em` direction that fixes the Higgs reference section). -/
theorem fureyEMgen_span_eq_photon_stabilizer {v : ℝ} (hv : v ≠ 0) :
    Submodule.span ℝ {fureyEMgen} = LinearMap.ker (B_EW v) := by
  rw [fureyEMgen_eq_Qgen, ew_stabilizer_kernel hv]

/-- The Furey EM line is exactly the zero set of the orbit-stiffness mass form. -/
theorem fureyEMgen_span_eq_massForm_kernel {v : ℝ} (hv : v ≠ 0) :
    {x : Fin 4 → ℝ | massForm v x = 0} = (Submodule.span ℝ {fureyEMgen} : Set (Fin 4 → ℝ)) := by
  rw [massForm_kernel hv, fureyEMgen_eq_Qgen]

/-! ### Assembled bridge theorem -/

/--
**Furey ↔ null-edge electromagnetic-stabilizer bridge.**

The Furey/Hughes electromagnetic generator `Q = T₃ + Y/2`, selected by the
internal-algebra Gell-Mann–Nishijima relation, and the null-edge FMS photon
stabilizer `span ℝ {Q}` are the *same* one-dimensional unbroken direction.
Concretely, for any nonzero Higgs scale `v`:

1. the Furey charge table obeys GMN `Q = T₃ + Y/2`
   (`furey_gellMannNishijima`);
2. the EM generator is the GMN combination of the `T₃`- and `Y/2`-generators,
   and equals the null-edge `Qgen`;
3. its matrix is `ρ(Q) = T₃ + Y/2 = diag(1,0)`, which stabilises the Higgs
   reference section `H₀`;
4. the spanned line is exactly the FMS photon stabilizer `ker B_EW`, on which
   the orbit-stiffness mass form vanishes (massless photon).

This is a stabilizer / orbit-stiffness compatibility statement only: no W/Z pole
or mass prediction is claimed.
-/
theorem furey_EM_generator_is_null_edge_photon_stabilizer {v : ℝ} (hv : v ≠ 0) :
    (∀ s : Fin 8, fPhysicalQ s = fTargetT3 s + fTargetY s / 2) ∧
    fureyEMgen = T3gen + Yhalfgen ∧
    rho fureyEMgen = Qmat ∧
    Qmat = T3 + Yhalf ∧
    (rho fureyEMgen) *ᵥ (H0 v) = 0 ∧
    massForm v fureyEMgen = 0 ∧
    Submodule.span ℝ {fureyEMgen} = LinearMap.ker (B_EW v) := by
  refine ⟨furey_gellMannNishijima, fureyEMgen_eq_T3_plus_Yhalf, rho_fureyEMgen,
    Qmat_eq_T3_add_Yhalf, fureyEMgen_stabilizes_vacuum v, fureyEMgen_massless v,
    fureyEMgen_span_eq_photon_stabilizer hv⟩

end FureyEWStabilizerComparison
end Draft
end PhysicsSM
