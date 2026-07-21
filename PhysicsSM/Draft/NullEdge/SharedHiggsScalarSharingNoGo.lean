import Mathlib

/-!
# Shared-Higgs scope of the displayed fermion mass functor

Independent Opus audit result for the origin-of-mass shared-data gate (AFPL
gate A1). The A1 target claims one supplied vacuum datum generates the fermion,
gauge, and radial sectors together. This module proves the STRONG reading -
that the fermion map factors through the vacuum VECTOR - is false under the
repository types, and pins the honest reading for this encoding: the displayed
fermion functor depends on the scalar `v`, with the Yukawa matrix a free
parameter. This statement does not classify or exclude additional mass routes.

The gauge-boson and radial sectors live on the doublet space `Fin 2` (they use
the vacuum vector `H0 = v • e0`); the fermion turn `Y ⊗ 1_spin` lives on
`Fin n × Fin 4` and has NO `Fin 2 → ℂ` argument. Genuine dependence on the
vacuum vector therefore needs an extra cross-space bridge that the carrier types
do not select. Realizes Codex Visionary falsifier #1.

Provenance: statements verified independently at the pinned toolchain from the
Aristotle audit return `cda24762-8b5e-410b-a6cc-e10be2c867f5` (task `154f2979`);
`AUDIT_REPORT.md` in that job carries the full argument. Clean-room Mathlib port;
standard three axioms. Claim grade `M`, `[comp]`.

SCOPE CORRECTION (docstring audit `364a29ac`): one mass functor establishes only the
DISPLAYED factorization; it does not classify or exclude unmodelled routes. Honest
form: dependence does not pass through the displayed vector-valued route IN THAT
FUNCTOR. Avoid the unqualified "shares ONLY the scalar v".

Consequence for A1: state the shared-Higgs theorem as `M_f = v • Y_f` with `Y_f`
free and the cross-space bridge an explicit independent convention - do not claim
the fermion map factors through the vacuum vector.

Scope caveat (self-audit `01de0e45`): the no-go is proved for the specific
`flavorMassTerm` encoding, NOT for every "reasonable" fermion-mass functor (a
phrase with no formal criterion here) - both a constant and a nonconstant
polynomial functor can also identify two distinct Yukawa values, so the robust
content is exactly the `flavorMassTerm` statement above.
-/

namespace PhysicsSM.Draft.NullEdge.SharedHiggsScalarSharingNoGo

abbrev HiggsSpace := Fin 2 → ℂ
abbrev FlavorMatrix (n : ℕ) := Matrix (Fin n) (Fin n) ℂ
abbrev FermionSpace (n : ℕ) := Fin n × Fin 4
abbrev FermionMatrix (n : ℕ) := Matrix (FermionSpace n) (FermionSpace n) ℂ

/-- The convention-fixed doublet vacuum `H0 = v • e0`. -/
def vacuumVector (v : ℝ) : HiggsSpace := Pi.single 0 (v : ℂ)

/-- The repository fermion mass term `Y ⊗ 1_spin` (entrywise). -/
noncomputable def flavorMassTerm {n : ℕ} (Y : FlavorMatrix n) : FermionMatrix n :=
  fun p q => Y p.1 q.1 * if p.2 = q.2 then 1 else 0

/-- Exactly the bosonic data common to the gauge and radial sectors. -/
structure BosonicData (ι : Type) where
  v : ℝ
  generators : ι → Matrix (Fin 2) (Fin 2) ℂ
  lam : ℝ
  couplings : ι → ℝ

/-- A convention-locked model: the Yukawa matrix is a separate field, not a
consequence of the bosonic data. -/
structure LockedModel (ι : Type) (n : ℕ) where
  bosonic : BosonicData ι
  yukawa : FlavorMatrix n

def modelWithZeroYukawa {ι : Type} (b : BosonicData ι) : LockedModel ι 1 := ⟨b, 0⟩
def modelWithUnitYukawa {ι : Type} (b : BosonicData ι) : LockedModel ι 1 := ⟨b, 1⟩

/-- **Underdetermination.**  Identical vacuum, generators, quartic coupling, and
gauge couplings, yet different fermion mass operators: the fermion sector is not
fixed by the shared bosonic vacuum. -/
theorem same_bosonic_data_different_fermion_sector {ι : Type} (b : BosonicData ι) :
    (modelWithZeroYukawa b).bosonic = (modelWithUnitYukawa b).bosonic ∧
      flavorMassTerm (modelWithZeroYukawa b).yukawa ≠
        flavorMassTerm (modelWithUnitYukawa b).yukawa := by
  refine ⟨rfl, ?_⟩
  intro h
  have hEntry := congr_fun (congr_fun h ⟨0, 0⟩) ⟨0, 0⟩
  norm_num [flavorMassTerm, modelWithZeroYukawa, modelWithUnitYukawa] at hEntry

/-- A genuine linear dependence of the fermion operator on the Higgs vector has
this cross-space type; no such term is present in `LockedModel`. -/
abbrev VacuumToFermionBridge (n : ℕ) := HiggsSpace →ₗ[ℂ] FermionMatrix n

noncomputable def zeroBridge (n : ℕ) : VacuumToFermionBridge n := 0

noncomputable def componentZeroBridge (n : ℕ) : VacuumToFermionBridge n where
  toFun H := fun p q => H 0 * if p = q then 1 else 0
  map_add' H K := by ext p q; by_cases h : p = q <;> simp [h]
  map_smul' c H := by ext p q; by_cases h : p = q <;> simp [h]

/-- **Carrier types do not select the bridge.**  Two linear Higgs-to-fermion
bridges disagree on the same vacuum vector, so the cross-space conversion is an
independent convention choice. -/
theorem cross_space_bridge_is_not_unique :
    zeroBridge 1 ≠ componentZeroBridge 1 := by
  intro h
  have hEntry := congr_arg (fun f => f (Pi.single 0 1) ⟨0, 0⟩ ⟨0, 0⟩) h
  norm_num [zeroBridge, componentZeroBridge] at hEntry

/-- The honest weakening: reusing only the scalar `v` gives `(v) • Y`. -/
noncomputable def scalarSharedMass {n : ℕ} (v : ℝ) (Y : FlavorMatrix n) : FlavorMatrix n :=
  (v : ℂ) • Y

/-- **Scalar sharing preserves Yukawa freedom.**  At nonzero vacuum value,
distinct Yukawa matrices remain distinct after scalar multiplication: the shared
scalar `v` does not constrain `Y_f`. -/
theorem scalar_sharing_preserves_yukawa_freedom {n : ℕ} (v : ℝ) (hv : v ≠ 0)
    {Y₁ Y₂ : FlavorMatrix n} (hY : Y₁ ≠ Y₂) :
    scalarSharedMass v Y₁ ≠ scalarSharedMass v Y₂ := by
  contrapose! hY
  unfold scalarSharedMass at *
  simp_all +decide

end PhysicsSM.Draft.NullEdge.SharedHiggsScalarSharingNoGo
