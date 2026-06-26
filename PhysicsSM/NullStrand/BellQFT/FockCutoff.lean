import Mathlib

/-!
# NullStrand.BellQFT.FockCutoff

Abstract finite creation/annihilation interfaces for Fock-cutoff models.

This is a conservative scaffold that records the finite API shape needed by the
roadmap while keeping proof obligations explicit in hypotheses.

## Naming audit (2026-06-25, wave 4)

The improved roadmap (§ "Standalone proof jobs integrated but not yet promoted")
flagged a naming drift: the previously public `fockNullLift_equivariant` theorem
is only a *total-mass* identity under per-`q` direction-marginal preservation,
**not** a direction-marginal Born-equivariance theorem. This file repairs that:

* `PreservesDirectionMarginal` is the honest predicate that a finite Fock lift
  preserves, for each configuration `q`, the mass obtained by integrating out the
  direction variable. Total-mass preservation is a *corollary*, not the headline.
* `fockNullLift_total_mass_preserved` is the renamed, honestly-named version of
  the old theorem; `fockNullLift_equivariant` is kept as a deprecated alias so
  downstream references do not break.
* `fockNullLift_configMarginal_equivariant` is a genuine *direction-marginal
  equivariance* theorem: a lift that commutes with a relabeling of the direction
  variable transports the configuration-summed direction marginal equivariantly.
  This is the strongest honest equivariance statement expressible in the current
  abstract (operator-as-a-function) API; it is conditional on the lift's
  equivariance hypothesis, which cannot be derived for a generic lift.
-/

noncomputable section

namespace PhysicsSM.NullStrand.BellQFT

open scoped BigOperators

/-- Finite base data on a configuration × direction family. -/
abbrev FockDensity (Q : Type*) [Fintype Q] (Γ : Type*) [Fintype Γ] := Q → Γ → ℝ

/-- Generic creation lift operator. -/
abbrev CreationLift
    {Q : Type*} [Fintype Q] {Γ : Type*} [Fintype Γ] :=
  (Q → Γ → ℝ) → (Q → Γ → ℝ)

/-- Generic annihilation lift operator. -/
abbrev AnnihilationLift
    {Q : Type*} [Fintype Q] {Γ : Type*} [Fintype Γ] :=
  (Q → Γ → ℝ) → (Q → Γ → ℝ)

/-- The direction marginal of a density at configuration `q`: integrate out the
direction variable `Γ`. This is the per-configuration mass that creation /
annihilation lifts are required to preserve. -/
def directionMarginal {Q : Type*} {Γ : Type*} [Fintype Γ]
    (ρ : Q → Γ → ℝ) (q : Q) : ℝ :=
  ∑ ω, ρ q ω

/-- The configuration marginal of a density at direction `ω`: integrate out the
configuration variable `Q`. This is the object whose equivariance under a
direction relabeling is the genuine "direction-marginal equivariance" statement. -/
def configMarginal {Q : Type*} [Fintype Q] {Γ : Type*}
    (ρ : Q → Γ → ℝ) (ω : Γ) : ℝ :=
  ∑ q, ρ q ω

/-- A finite Fock lift *preserves the direction marginal* if, for every density
and every configuration `q`, the mass obtained by integrating out the direction
variable is unchanged. This is the honest finite-API meaning of "marginal
consistency" for creation / annihilation lifts. -/
def PreservesDirectionMarginal
    {Q : Type*} {Γ : Type*} [Fintype Γ]
    (L : (Q → Γ → ℝ) → (Q → Γ → ℝ)) : Prop :=
  ∀ ρ q, directionMarginal (L ρ) q = directionMarginal ρ q

/- Marginal consistency for a creation lift is an explicit hypothesis in this abstraction. -/
theorem creationLift_targetDirectionMarginal
    {Q : Type*} [Fintype Q] {Γ : Type*} [Fintype Γ]
    (C : CreationLift (Q := Q) (Γ := Γ)) (ρ : Q → Γ → ℝ)
    (hC : ∀ ρ q, ∑ ω, C ρ q ω = ∑ ω, ρ q ω) :
    ∀ q : Q, (∑ ω, C ρ q ω) = ∑ ω, ρ q ω := by
  intro q
  exact hC ρ q

/- Forgetting the destination direction under annihilation is an explicit hypothesis in this abstraction. -/
theorem annihilationLift_forgetsDirection
    {Q : Type*} [Fintype Q] {Γ : Type*} [Fintype Γ]
    (A : AnnihilationLift (Q := Q) (Γ := Γ)) (ρ : Q → Γ → ℝ)
    (hA : ∀ ρ q, ∑ ω, A ρ q ω = ∑ ω, ρ q ω) :
    ∀ q : Q, (∑ ω, A ρ q ω) = ∑ ω, ρ q ω := by
  intro q
  exact hA ρ q

/-! ### Composition and iteration of direction-marginal preservation -/

/-- The identity lift preserves the direction marginal. -/
theorem preservesDirectionMarginal_id
    {Q : Type*} {Γ : Type*} [Fintype Γ] :
    PreservesDirectionMarginal (Q := Q) (Γ := Γ) (id) := by
  intro ρ q
  rfl

/-- Direction-marginal preservation is closed under composition: if `L` and `M`
each preserve the direction marginal, so does `M ∘ L`. -/
theorem PreservesDirectionMarginal.comp
    {Q : Type*} {Γ : Type*} [Fintype Γ]
    {L M : (Q → Γ → ℝ) → (Q → Γ → ℝ)}
    (hL : PreservesDirectionMarginal L) (hM : PreservesDirectionMarginal M) :
    PreservesDirectionMarginal (M ∘ L) := by
  intro ρ q
  simp only [Function.comp_apply]
  rw [hM (L ρ) q, hL ρ q]

/-- Direction-marginal preservation is closed under iteration: if `L` preserves
the direction marginal, so does every iterate `L^[n]`. -/
theorem PreservesDirectionMarginal.iterate
    {Q : Type*} {Γ : Type*} [Fintype Γ]
    {L : (Q → Γ → ℝ) → (Q → Γ → ℝ)}
    (hL : PreservesDirectionMarginal L) (n : ℕ) :
    PreservesDirectionMarginal (L^[n]) := by
  induction n with
  | zero =>
      simpa [Function.iterate_zero] using
        (preservesDirectionMarginal_id (Q := Q) (Γ := Γ))
  | succ k ih =>
      intro ρ q
      rw [Function.iterate_succ', Function.comp_apply, hL (L^[k] ρ) q, ih ρ q]

/-- Total-mass preservation is a corollary of direction-marginal preservation:
summing the preserved per-configuration marginals over all configurations gives
the global mass identity. -/
theorem PreservesDirectionMarginal.total_mass_preserved
    {Q : Type*} [Fintype Q] {Γ : Type*} [Fintype Γ]
    {L : (Q → Γ → ℝ) → (Q → Γ → ℝ)}
    (hL : PreservesDirectionMarginal L) (ρ : Q → Γ → ℝ) :
    (∑ q, ∑ ω, L ρ q ω) = ∑ q, ∑ ω, ρ q ω := by
  refine Finset.sum_congr rfl ?_
  intro q _
  exact hL ρ q

/-! ### Total-mass identity (renamed from `fockNullLift_equivariant`) -/

/-- Total-mass preservation for a finite Fock lift. Given per-`q` direction-marginal
preservation, the global mass `∑_q ∑_ω L ρ q ω` equals `∑_q ∑_ω ρ q ω`.

This is the honestly-named replacement of the old `fockNullLift_equivariant`: it
is a *total-mass identity*, not a direction-marginal Born-equivariance theorem.
For the genuine equivariance statement see
`fockNullLift_configMarginal_equivariant`. -/
theorem fockNullLift_total_mass_preserved
    {Q : Type*} [Fintype Q] {Γ : Type*} [Fintype Γ]
    (L : (Q → Γ → ℝ) → (Q → Γ → ℝ)) (ρ : Q → Γ → ℝ)
    (hMarg : ∀ ρ q, (∑ ω, L ρ q ω) = ∑ ω, ρ q ω) :
    (∑ q, ∑ ω, L ρ q ω) = ∑ q, ∑ ω, ρ q ω := by
  refine Finset.sum_congr rfl ?_
  intro q _
  exact hMarg ρ q

@[deprecated fockNullLift_total_mass_preserved (since := "2026-06-25")]
alias fockNullLift_equivariant := fockNullLift_total_mass_preserved

/-- Per-configuration direction-marginal preservation for a finite Fock lift.
Given per-`q` marginal preservation, the direction marginal `∑_ω L ρ q ω` at each
configuration `q` equals `∑_ω ρ q ω`.

This is the *direction-law* statement, deliberately kept semantically distinct
from `fockNullLift_total_mass_preserved`: this theorem records the preserved mass
for each individual configuration `q` (no sum over `Q`, so `Q` need not even be
finite), whereas `fockNullLift_total_mass_preserved` is the *total-mass*
corollary obtained by summing these identities over all configurations. The
bundled, reusable predicate form is `PreservesDirectionMarginal`. -/
theorem fockNullLift_preserves_direction_marginal
    {Q : Type*} {Γ : Type*} [Fintype Γ]
    (L : (Q → Γ → ℝ) → (Q → Γ → ℝ)) (ρ : Q → Γ → ℝ) (q : Q)
    (hMarg : ∀ ρ q, (∑ ω, L ρ q ω) = ∑ ω, ρ q ω) :
    directionMarginal (L ρ) q = directionMarginal ρ q :=
  hMarg ρ q

/-! ### Genuine direction-marginal equivariance -/

/-- Relabel the direction variable of a density by a permutation `e : Γ ≃ Γ`. -/
def relabelDirection {Q : Type*} {Γ : Type*}
    (e : Γ ≃ Γ) (ρ : Q → Γ → ℝ) : Q → Γ → ℝ :=
  fun q ω => ρ q (e ω)

/-- A lift is *direction equivariant* with respect to a permutation `e : Γ ≃ Γ`
if relabeling the direction variable before and after applying the lift agree.
This is the abstract operator-API form of "commutes with the direction symmetry". -/
def DirectionEquivariant {Q : Type*} {Γ : Type*}
    (e : Γ ≃ Γ) (L : (Q → Γ → ℝ) → (Q → Γ → ℝ)) : Prop :=
  ∀ ρ, L (relabelDirection e ρ) = relabelDirection e (L ρ)

/-- Relabeling the direction variable does not change the direction marginal
(the total mass over directions is permutation invariant). -/
theorem directionMarginal_relabelDirection
    {Q : Type*} {Γ : Type*} [Fintype Γ]
    (e : Γ ≃ Γ) (ρ : Q → Γ → ℝ) (q : Q) :
    directionMarginal (relabelDirection e ρ) q = directionMarginal ρ q := by
  unfold directionMarginal relabelDirection
  exact e.sum_comp (fun ω => ρ q ω)

/-- Direction equivariance is closed under composition. -/
theorem DirectionEquivariant.comp
    {Q : Type*} {Γ : Type*}
    {e : Γ ≃ Γ} {L M : (Q → Γ → ℝ) → (Q → Γ → ℝ)}
    (hL : DirectionEquivariant e L) (hM : DirectionEquivariant e M) :
    DirectionEquivariant e (M ∘ L) := by
  intro ρ
  simp only [Function.comp_apply, hL ρ, hM (L ρ)]

/-- Direction equivariance is closed under iteration. -/
theorem DirectionEquivariant.iterate
    {Q : Type*} {Γ : Type*}
    {e : Γ ≃ Γ} {L : (Q → Γ → ℝ) → (Q → Γ → ℝ)}
    (hL : DirectionEquivariant e L) (n : ℕ) :
    DirectionEquivariant e (L^[n]) := by
  induction n with
  | zero => intro ρ; rfl
  | succ k ih =>
      intro ρ
      rw [Function.iterate_succ_apply', Function.iterate_succ_apply', ih ρ,
        hL (L^[k] ρ)]

/-- **Direction-marginal equivariance.** If a finite Fock lift `L` commutes with a
direction relabeling `e : Γ ≃ Γ`, then the configuration-summed direction marginal
of the lifted, relabeled density is the `e`-transported marginal of the lifted
density:
`configMarginal (L (relabelDirection e ρ)) ω = configMarginal (L ρ) (e ω)`.

This is the honest equivariance theorem the lane name `fockNullLift_equivariant`
promised: a symmetry of the direction variable is transported by the lift onto
its direction marginal. It is conditional on the lift's equivariance hypothesis,
which is genuine structure and cannot be derived for an arbitrary lift. -/
theorem fockNullLift_configMarginal_equivariant
    {Q : Type*} [Fintype Q] {Γ : Type*}
    (L : (Q → Γ → ℝ) → (Q → Γ → ℝ)) (e : Γ ≃ Γ)
    (hL : DirectionEquivariant e L) (ρ : Q → Γ → ℝ) (ω : Γ) :
    configMarginal (L (relabelDirection e ρ)) ω = configMarginal (L ρ) (e ω) := by
  unfold configMarginal
  rw [hL ρ]
  rfl

/-- A direction-marginal preserving lift also preserves the direction marginal of
*relabeled* densities (the relabeling is itself marginal invariant). This records
that marginal preservation is compatible with the direction symmetry; no
equivariance hypothesis is needed. -/
theorem fockNullLift_directionMarginal_relabel_preserved
    {Q : Type*} {Γ : Type*} [Fintype Γ]
    {L : (Q → Γ → ℝ) → (Q → Γ → ℝ)} {e : Γ ≃ Γ}
    (hpres : PreservesDirectionMarginal L)
    (ρ : Q → Γ → ℝ) (q : Q) :
    directionMarginal (L (relabelDirection e ρ)) q = directionMarginal ρ q := by
  rw [hpres (relabelDirection e ρ) q, directionMarginal_relabelDirection]

end PhysicsSM.NullStrand.BellQFT
