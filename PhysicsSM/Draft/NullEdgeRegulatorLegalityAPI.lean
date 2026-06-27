import Mathlib

/-!
# C80: abstract Gate C v4 regulator-legality / no-irrelevant-repair API

This is an **abstract legality / failure API**, not a release claim.  It isolates
one structural fact that the Gate C v4 discussion keeps colliding with:

```text
LiftNonOrigin is not enough.
OriginWeylPure for a chosen grading G is a separate legal release clause.
```

A regulator that merely lifts the non-origin (massive) branch — without changing
the *first-order linearization at the origin* — cannot, on its own, turn a
balanced (chirality-mixed) origin branch into a `G`-pure (chiral) one.  We model
the linearization at zero **abstractly as supplied data** living in an `ℝ`-module
`M`, rather than formalizing Fréchet derivatives, exactly as permitted by the
task.

## Modeling choices

* A **grading** `G` is an idempotent `ℝ`-linear endomorphism of `M`
  (`IsGrading`); think of it as the projector onto the chiral / pure subspace
  for a chosen grading.
* `OriginWeylPure G x` means the origin linearization `x` is fixed by `G`
  (`G x = x`), i.e. it lies entirely in the pure (chiral) subspace.
* `OriginBalanced G x` means `x` has **no** pure component (`G x = 0`); a nonzero
  balanced linearization is therefore never pure.
* A **regulator** carries its first-order origin contribution `delta : M`
  together with an abstract `liftsNonOrigin` flag describing its effect away from
  the origin.  The regulated origin linearization is `bare + delta`.
* `IrrelevantAtOrigin` means the first-order origin contribution vanishes;
  `SameOriginLinearization` compares two regulators' regulated origin
  linearizations; `LiftNonOrigin` exposes the non-origin flag; and
  `RegulatorLegal` is the conjunction of `LiftNonOrigin` with origin purity of
  the regulated linearization.

## Scope / honesty

Nothing here asserts that the actual null-edge operator satisfies any of these
predicates, and nothing claims a concrete Gate C release.  The content is the
*negative guardrail*: an irrelevant regulator with the same origin linearization
cannot repair a balanced, non-pure origin branch.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeRegulatorLegalityAPI

variable {M : Type*} [AddCommGroup M] [Module ℝ M]

/-! ## Gradings and purity -/

/-- A **grading** is an idempotent `ℝ`-linear endomorphism of `M`: the projector
onto the chiral / pure subspace for a chosen grading `G`. -/
def IsGrading (G : M →ₗ[ℝ] M) : Prop := G.comp G = G

/-- The origin linearization `x` is **Weyl-pure** for grading `G` when it is
fixed by the grading projector, i.e. it lies in the pure (chiral) subspace. -/
def OriginWeylPure (G : M →ₗ[ℝ] M) (x : M) : Prop := G x = x

/-- The origin linearization `x` is **balanced** for grading `G` when it has no
pure component, i.e. `G x = 0` (a chirality-mixed branch). -/
def OriginBalanced (G : M →ₗ[ℝ] M) (x : M) : Prop := G x = 0

/-- For a grading, purity is membership in the range of the projector. -/
theorem originWeylPure_iff_mem_range {G : M →ₗ[ℝ] M} (hG : IsGrading G) (x : M) :
    OriginWeylPure G x ↔ ∃ y, G y = x := by
  unfold OriginWeylPure
  constructor
  · intro h; exact ⟨x, h⟩
  · rintro ⟨y, rfl⟩
    have := congrArg (fun (f : M →ₗ[ℝ] M) => f y) hG
    simpa [LinearMap.comp_apply] using this

/-- A nonzero balanced origin linearization is never `G`-pure: it has no pure
component, so it cannot equal its own (vanishing) pure projection. -/
theorem balanced_ne_zero_not_pure {G : M →ₗ[ℝ] M} {x : M}
    (hbal : OriginBalanced G x) (hne : x ≠ 0) : ¬ OriginWeylPure G x := by
  unfold OriginBalanced OriginWeylPure at *
  intro hpure
  exact hne (by rw [← hpure, hbal])

/-! ## Regulators and the regulated origin linearization -/

/-- An abstract **regulator**: its first-order contribution to the origin
linearization (`delta`) together with an abstract flag `liftsNonOrigin`
describing whether it lifts the non-origin (massive) branch. -/
structure Regulator (M : Type*) [AddCommGroup M] [Module ℝ M] where
  /-- First-order contribution of the regulator to the linearization at zero. -/
  delta : M
  /-- Abstract clause: the regulator lifts the non-origin (massive) branch. -/
  liftsNonOrigin : Prop

/-- The regulated origin linearization: the bare origin linearization plus the
regulator's first-order origin contribution. -/
def regOriginLin (bare : M) (r : Regulator M) : M := bare + r.delta

/-- A regulator is **irrelevant at the origin** when its first-order origin
contribution vanishes (zero first-order contribution at the origin). -/
def IrrelevantAtOrigin (r : Regulator M) : Prop := r.delta = 0

/-- Two regulators have the **same origin linearization** (relative to a bare
linearization) when their regulated origin linearizations agree. -/
def SameOriginLinearization (bare : M) (r₁ r₂ : Regulator M) : Prop :=
  regOriginLin bare r₁ = regOriginLin bare r₂

/-- The non-origin lifting clause of a regulator. -/
def LiftNonOrigin (r : Regulator M) : Prop := r.liftsNonOrigin

/-- **Regulator legality** (Gate C v4): the regulator must both lift the
non-origin branch *and* make the regulated origin linearization `G`-pure.  These
are two genuinely separate clauses. -/
def RegulatorLegal (G : M →ₗ[ℝ] M) (bare : M) (r : Regulator M) : Prop :=
  LiftNonOrigin r ∧ OriginWeylPure G (regOriginLin bare r)

/-! ## Negative guardrails -/

/-- An irrelevant regulator does not change the origin linearization. -/
theorem irrelevant_regOriginLin_eq {bare : M} {r : Regulator M}
    (hirr : IrrelevantAtOrigin r) : regOriginLin bare r = bare := by
  unfold regOriginLin IrrelevantAtOrigin at *
  rw [hirr, add_zero]

/-- **Same origin linearization preserves non-purity.**  If two regulators yield
the same regulated origin linearization and one is not `G`-pure, neither is the
other. -/
theorem same_linearization_preserves_origin_not_pure {G : M →ₗ[ℝ] M} {bare : M}
    {r₁ r₂ : Regulator M} (hsame : SameOriginLinearization bare r₁ r₂)
    (hnp : ¬ OriginWeylPure G (regOriginLin bare r₁)) :
    ¬ OriginWeylPure G (regOriginLin bare r₂) := by
  unfold SameOriginLinearization at hsame
  rwa [hsame] at hnp

/-- **No irrelevant regulator repairs a balanced origin.**  If the bare origin
linearization is balanced and nonzero (chirality-mixed, hence not pure), then any
regulator with zero first-order origin contribution leaves the regulated origin
linearization still not `G`-pure. -/
theorem no_irrelevant_regulator_repairs_balanced_origin {G : M →ₗ[ℝ] M} {bare : M}
    {r : Regulator M} (hbal : OriginBalanced G bare) (hne : bare ≠ 0)
    (hirr : IrrelevantAtOrigin r) :
    ¬ OriginWeylPure G (regOriginLin bare r) := by
  rw [irrelevant_regOriginLin_eq hirr]
  exact balanced_ne_zero_not_pure hbal hne

/-- **Wilson-lift ≠ chiral release (schema).**  A regulator that only lifts the
non-origin branch and is irrelevant at the origin is *not* legal when the bare
origin branch is balanced and nonzero: lifting alone cannot supply the missing
origin-purity clause. -/
theorem wilson_lift_not_chiral_release_schema {G : M →ₗ[ℝ] M} {bare : M}
    {r : Regulator M} (hbal : OriginBalanced G bare) (hne : bare ≠ 0)
    (hirr : IrrelevantAtOrigin r) (_hlift : LiftNonOrigin r) :
    ¬ RegulatorLegal G bare r := by
  intro hlegal
  exact no_irrelevant_regulator_repairs_balanced_origin hbal hne hirr hlegal.2

/-- **Legality decomposes into lifting and origin purity.**  Regulator legality
holds iff the regulator lifts the non-origin branch *and* the regulated origin
linearization is `G`-pure; the two clauses are independent and both required. -/
theorem regulatorLegal_requires_lift_and_origin_purity (G : M →ₗ[ℝ] M) (bare : M)
    (r : Regulator M) :
    RegulatorLegal G bare r ↔
      LiftNonOrigin r ∧ OriginWeylPure G (regOriginLin bare r) :=
  Iff.rfl

end PhysicsSM.Draft.NullEdgeRegulatorLegalityAPI
