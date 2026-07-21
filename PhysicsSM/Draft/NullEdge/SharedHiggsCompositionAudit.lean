import Mathlib

/-!
# Shared-Higgs composition deep audit (Opus, verified Aristotle a1c0bab1)

Independent kernel-checked scrutiny of the A1 shared-Higgs claim (corroborates the
Opus no-go and the manual audit of Codex SharedHiggsMassData): (1) gauge Gram PSD,
kernel = infinitesimal stabilizer - explicit SU(2)/hypercharge pair at (0,v) gives
v^2[[1,-1],[-1,1]] with kernel the photon line a0=a1 (v!=0); (2) radial Taylor
V(h)=(2 lam v^2)/2 h^2 + lam v h^3 + (lam/4)h^4, V''(0)=2 lam v^2 unique; (3) fixing
(v,generators,lam) fixes both bosonic sectors but leaves Yukawa FREE (zero vs
identity Yukawa -> same bosonic, fermion turns 0 vs v). Legitimate meaning: two
determined bosonic sectors plus one displayed fermion functor whose shown
dependence shares the scalar `v`. This does not classify or exclude unmodelled
fermion-mass routes.
Namespace kept as prover's SharedHiggsAudit. Provenance: verified at pin from task
247b9f0b. Standard three. Grade M, [orig] (independent-review artifact). -/

open scoped BigOperators

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option autoImplicit false

namespace SharedHiggsAudit

abbrev Vec2 := Fin 2 → ℝ
abbrev Generator := Vec2 →ₗ[ℝ] Vec2

/-- The ordinary Euclidean pairing, written explicitly to keep the model concrete. -/
def dot (x y : Vec2) : ℝ := ∑ i, x i * y i

/-- The gauge Gram matrix associated to generators and a vacuum. -/
def gaugeGram (T : Fin 2 → Generator) (phi0 : Vec2) (a b : Fin 2) : ℝ :=
  dot (T a phi0) (T b phi0)

/-- The infinitesimal action of a linear combination of the two generators. -/
def gaugeAction (T : Fin 2 → Generator) (phi0 a : Vec2) : Vec2 :=
  ∑ i, a i • T i phi0

/-
Every concrete gauge Gram quadratic form is positive semidefinite.
-/
theorem gaugeGram_psd (T : Fin 2 → Generator) (phi0 a : Vec2) :
    0 ≤ ∑ i, ∑ j, a i * gaugeGram T phi0 i j * a j := by
  simp +decide [ dot, gaugeGram ];
  nlinarith [ sq_nonneg ( a 0 * ( T 0 ) phi0 0 + a 1 * ( T 1 ) phi0 0 ), sq_nonneg ( a 0 * ( T 0 ) phi0 1 + a 1 * ( T 1 ) phi0 1 ) ]

/-
The nullspace of the Gram matrix is exactly the infinitesimal stabilizer.
-/
theorem gaugeGram_kernel_iff_stabilizer (T : Fin 2 → Generator) (phi0 a : Vec2) :
    (∀ i, ∑ j, gaugeGram T phi0 i j * a j = 0) ↔ gaugeAction T phi0 a = 0 := by
  constructor <;> intro h <;> simp_all +decide [ Fin.forall_fin_two, funext_iff ];
  · -- By definition of gauge action, we have:
    unfold gaugeAction gaugeGram dot at *;
    by_cases h1 : (T 0 phi0) 0 * (T 0 phi0) 0 + (T 0 phi0) 1 * (T 0 phi0) 1 = 0 <;> by_cases h2 : (T 1 phi0) 0 * (T 1 phi0) 0 + (T 1 phi0) 1 * (T 1 phi0) 1 = 0 <;> simp_all +decide [ Fin.sum_univ_two, mul_comm ];
    · norm_num [ show ( T 0 ) phi0 0 = 0 by nlinarith, show ( T 0 ) phi0 1 = 0 by nlinarith, show ( T 1 ) phi0 0 = 0 by nlinarith, show ( T 1 ) phi0 1 = 0 by nlinarith ];
    · norm_num [ show ( T 0 ) phi0 0 = 0 by nlinarith, show ( T 0 ) phi0 1 = 0 by nlinarith ] at * ; aesop;
    · simp_all +decide [ show ( T 1 ) phi0 0 = 0 by nlinarith, show ( T 1 ) phi0 1 = 0 by nlinarith ];
    · grind;
  · simp_all +decide [ Fin.sum_univ_two, gaugeAction, gaugeGram, dot ];
    grind +splitImp

/-- A Pauli-`σ₃`-like neutral generator. -/
def neutralT3 : Generator where
  toFun x i := if i = 0 then x 0 else -x 1
  map_add' := by intros; funext i; fin_cases i <;> simp [add_comm]
  map_smul' := by intros; funext i; fin_cases i <;> simp

/-- The identity hypercharge-like neutral generator. -/
def neutralY : Generator := LinearMap.id

def neutralGenerators : Fin 2 → Generator
  | 0 => neutralT3
  | 1 => neutralY

/-- A concrete doublet vacuum with only its lower component nonzero. -/
def doubletVacuum (v : ℝ) : Vec2
  | 0 => 0
  | 1 => v

/-
In the neutral two-generator model the Gram matrix is `v² [[1,-1],[-1,1]]`.
-/
theorem explicit_gaugeGram (v : ℝ) (i j : Fin 2) :
    gaugeGram neutralGenerators (doubletVacuum v) i j =
      v ^ 2 * (if i = j then 1 else -1) := by
  fin_cases i <;> fin_cases j <;> simp +decide [ gaugeGram, dot, neutralGenerators, neutralT3, neutralY, doubletVacuum ] <;> ring

/-
For nonzero vacuum value, the Gram kernel is precisely the photon line `(t,t)`.
-/
theorem explicit_kernel_is_photon {v : ℝ} (hv : v ≠ 0) (a : Vec2) :
    (∀ i, ∑ j, gaugeGram neutralGenerators (doubletVacuum v) i j * a j = 0) ↔
      a 0 = a 1 := by
  simp_all +decide [ Fin.forall_fin_two, explicit_gaugeGram ];
  grind

/-
Equivalently, the photon line is exactly the stabilizer of the vacuum.
-/
theorem explicit_stabilizer_is_photon {v : ℝ} (hv : v ≠ 0) (a : Vec2) :
    gaugeAction neutralGenerators (doubletVacuum v) a = 0 ↔ a 0 = a 1 := by
  unfold gaugeAction;
  simp_all +decide [ funext_iff, Fin.forall_fin_two ];
  simp_all +decide [ neutralGenerators, neutralT3, neutralY, doubletVacuum ];
  grind

/-- Quartic doublet potential restricted to the radial line `phi=(0,v+h)`. -/
noncomputable def radialPotential (lam v h : ℝ) : ℝ :=
  lam / 4 * (((v + h) ^ 2 - v ^ 2) ^ 2)

/-
Exact Taylor expansion at the vacuum; there is no constant or linear term.
-/
theorem radialPotential_taylor (lam v h : ℝ) :
    radialPotential lam v h =
      (2 * lam * v ^ 2) / 2 * h ^ 2 + lam * v * h ^ 3 + lam / 4 * h ^ 4 := by
  unfold radialPotential; ring;

/-
The radial Hessian at the vacuum is `2 λ v²`.
-/
theorem radialPotential_secondDerivative (lam v : ℝ) :
    deriv (fun h => radialPotential lam v h) (0 : ℝ) = 0 ∧
    deriv (fun h => deriv (fun x => radialPotential lam v x) h) (0 : ℝ) =
      2 * lam * v ^ 2 := by
  unfold radialPotential;
  norm_num [ add_comm v ] ; ring

/-
Uniqueness of the Hessian parameter in the Taylor convention `c h² / 2`.
-/
theorem radial_quadratic_coefficient_unique (lam v c : ℝ)
    (hTaylor : ∀ h : ℝ, radialPotential lam v h =
      c / 2 * h ^ 2 + lam * v * h ^ 3 + lam / 4 * h ^ 4) :
    c = 2 * lam * v ^ 2 := by
  unfold radialPotential at hTaylor; have := hTaylor 1; have := hTaylor ( -1 ) ; ring_nf at *; linarith;

/-- The fixed Higgs data that genuinely determine the two bosonic outputs. -/
structure BosonicHiggsDatum where
  v : ℝ
  generators : Fin 2 → Generator
  lam : ℝ

/-- Gauge and radial data determined by a bosonic Higgs datum. -/
def bosonicOutput (d : BosonicHiggsDatum) :=
  (gaugeGram d.generators (doubletVacuum d.v), 2 * d.lam * d.v ^ 2)

/-- A Yukawa choice is extra data, not determined by the bosonic datum. -/
structure HiggsWithYukawa extends BosonicHiggsDatum where
  yukawa : ℝ →ₗ[ℝ] ℝ

/-- Extend fixed bosonic data by an independently chosen Yukawa map. -/
def withYukawa (d : BosonicHiggsDatum) (Y : ℝ →ₗ[ℝ] ℝ) : HiggsWithYukawa where
  toBosonicHiggsDatum := d
  yukawa := Y

/-- The fermion observable shares the scalar vacuum value, but also uses arbitrary Yukawa data. -/
def fermionTurn (d : HiggsWithYukawa) : ℝ := d.yukawa d.v

/-
Adding any Yukawa map leaves both bosonic sectors unchanged.
-/
theorem bosonic_sectors_independent_of_yukawa (d : BosonicHiggsDatum)
    (Y₁ Y₂ : ℝ →ₗ[ℝ] ℝ) :
    bosonicOutput (withYukawa d Y₁).toBosonicHiggsDatum =
      bosonicOutput (withYukawa d Y₂).toBosonicHiggsDatum := by
  rfl

/-
At nonzero `v`, two Yukawa choices give different fermion turns while all fixed
bosonic Higgs data, hence both bosonic outputs, remain identical.
-/
theorem fermion_sector_is_free (d : BosonicHiggsDatum) (hv : d.v ≠ 0) :
    ∃ D₀ D₁ : HiggsWithYukawa,
      D₀.toBosonicHiggsDatum = d ∧ D₁.toBosonicHiggsDatum = d ∧
      bosonicOutput D₀.toBosonicHiggsDatum = bosonicOutput D₁.toBosonicHiggsDatum ∧
      fermionTurn D₀ ≠ fermionTurn D₁ := by
  -- Choose the two different Yukawa maps: $Y_0 = 0$ and $Y_1 = \text{LinearMap.id}$.
  use ⟨d, 0⟩, ⟨d, LinearMap.id⟩;
  unfold fermionTurn; aesop;

/-
Precise constructive audit: one bosonic Higgs datum determines the gauge Gram
and radial Hessian; every Yukawa extension has those same outputs, while for
nonzero vacuum value the fermion output is not determined.
-/
theorem one_higgs_datum_three_sectors_legitimate (d : BosonicHiggsDatum) (hv : d.v ≠ 0) :
    (∀ Y : ℝ →ₗ[ℝ] ℝ,
      bosonicOutput (withYukawa d Y).toBosonicHiggsDatum = bosonicOutput d) ∧
    (∃ Y₁ Y₂ : ℝ →ₗ[ℝ] ℝ,
      fermionTurn (withYukawa d Y₁) ≠ fermionTurn (withYukawa d Y₂)) := by
  refine' ⟨ fun Y => _, _ ⟩;
  · rfl;
  · -- Choose the two different Yukawa maps: $Y_0 = 0$ and $Y_1 = \text{LinearMap.id}$, and show that their fermion turns are not equal.
    use 0, LinearMap.id;
    unfold fermionTurn withYukawa; aesop;

end SharedHiggsAudit
