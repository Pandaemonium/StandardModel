import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.AllMassFromNullEdges
import PhysicsSM.Draft.NullEdge.GateI1.MassTaxonomyNonDegeneracy
import PhysicsSM.Draft.NullEdge.GateI1.NBodyAperture
import PhysicsSM.Draft.NullEdge.GateI1.MassCommonCarrier

/-!
# The all-mass-from-null-edges super-capstone (v2)

A single kernel-checked statement that folds the four newly-landed null-edge
mass results into ONE honest super-capstone `allMassFromNullEdges_v2`. Every
conjunct is discharged by an already-proved theorem imported from its own
module; this file asserts nothing new — it is a pure assembly.

## The four conjoined results

1. **(four-obstruction bundle + F-YM-CONFLATE distinctness guard)** —
   `AllMassFromNullEdges.allMassFromNullEdges_guarded`. The four representative
   null-edge mass OBSTRUCTIONS (closure "mass without mass", charge
   co-location, aperture "massless iff one null edge", turn "mass and transport
   in separate chirality channels") bundled together WITH the proof that the
   underlying mass functionals are pairwise distinct (no row is another
   relabeled).

2. **(taxonomy NON-DEGENERACY / independent realizability)** —
   `MassTaxonomyNonDegeneracy.massTaxonomy_nondegenerate`. The four taxonomy
   legs are independently realizable on their separate parameter domains: each
   of regulator, closure and aperture can be turned ON while the others sit at
   OFF witnesses, and the turn/bare leg is identically OFF while the other three
   are simultaneously ON — the honest dual for the one pinned-input leg with no
   ON witness. No functional is a shadow of another.

3. **(any-N aperture iff)** —
   `NBodyAperture.nbody_aperture_massless_iff_collinear`. For ANY `N` (any
   `Finset s`) of future-null momenta, the composite has vanishing invariant
   mass iff the whole bundle points along a single null direction — the full
   N-body statement of "mass = aperture of the null bundle", a frame-invariant
   kinematic identity.

4. **(common-carrier NEGATIVE)** —
   `MassCommonCarrier.no_common_carrier_via_turn`. There is NO single carrier
   (one structure with one shared parameter set) making all four null-edge
   masses strictly positive at once. The obstruction is exactly the turn/bare
   leg: `quarkMassParameter` is a detached constant pinned to `0`, so the
   four-way "all ON" predicate is unsatisfiable.

## What this super-capstone SAYS (honest scorecard)

The four null-edge mass obstructions are:

* **distinct** — the mass functionals are pairwise separated (conjunct 1's
  distinctness guard);
* **independently realizable** — each can be turned ON on its own domain while
  the others are OFF (conjunct 2);
* governed by an **any-N kinematic iff** — the composite is massless iff it is
  effectively one null edge, for every `N` (conjunct 3);
* NOT unifiable under a **single physical carrier** — no one model with one
  shared parameter set turns all four masses ON, obstructed by the pinned bare
  leg (conjunct 4).

## What this super-capstone does NOT say

* It is **NOT** the physical `SU(N)` Yang–Mills mass gap. Conjunct 1's closure
  leg is a finite `Z2` single-plaquette toy; the real gap is off-ladder.
* It is **NOT** a continuum statement — every conjunct is finite / kinematic /
  functional-level.
* It is **NOT** a derivation of the physical masses — no numerical mass value is
  produced, and the bare/turn input is definitionally `0`. The universal reading
  "every physical mass is now derived from null edges" is exactly the over-claim
  to avoid.

The super-capstone is a CONJUNCTION of proved finite/kinematic facts sharing a
mechanism SHAPE (relational obstruction to free null transport); it is NOT a
proof of a single unified physical mechanism.

## Claim discipline

Claim label: **program synthesis** (bundling of already-proved results; no new
mathematics). Draft-trust (transitively imports the draft `GateI1` / `GateYM`
modules); `sorry`-free, no new axioms, no `native_decide`.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.AllMassFromNullEdgesV2

open PhysicsSM.Draft.NullEdge.GateI1
open PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
open PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass
open PhysicsSM.Draft.NullEdge.GateI1.ChargeGradingMassCompatible
open PhysicsSM.Draft.NullEdge.GateI1.MassTaxonomySeparation
open PhysicsSM.Draft.NullEdge.GateYM.ChiralMassStructure
open PhysicsSM.Draft.NullEdge.GateYM.Qmf4bWilson
open PhysicsSM.Draft.NullEdge.GateYM.EuclideanGamma
open PhysicsSM.Algebra.Furey.MinimalLeftIdeal
open PhysicsSM.Draft.NullEdge.GateI1.AllMassFromNullEdges
open PhysicsSM.Draft.NullEdge.GateI1.MassTaxonomyNonDegeneracy
open PhysicsSM.Draft.NullEdge.GateI1.NBodyAperture
open PhysicsSM.Draft.NullEdge.GateI1.MassCommonCarrier
open scoped Matrix

/-- **All mass from null edges, v2 (the honest super-capstone).** For any
glueball inverse-temperature `beta > 0`, any Wilson parameter `r > 0`, and any
spacetime spinor `psi`, the four newly-landed null-edge mass results hold
TOGETHER:

* (1) the four-obstruction bundle together with the F-YM-CONFLATE distinctness
  guard (`allMassFromNullEdges_guarded`);
* (2) the taxonomy non-degeneracy / independent realizability
  (`massTaxonomy_nondegenerate`);
* (3) the any-N aperture iff — the composite of future-null momenta is massless
  iff collinear, for every `Finset`
  (`nbody_aperture_massless_iff_collinear`);
* (4) the common-carrier negative — no single carrier turns all four masses ON
  (`no_common_carrier_via_turn`).

Each conjunct is a proved theorem, combined here without re-proof. Together they
say the four null-edge mass obstructions are distinct, independently realizable,
governed by an any-N kinematic iff, and NOT unifiable under a single physical
carrier. They do NOT say: the physical `SU(N)` Yang–Mills gap, a continuum
statement, or a derivation of the physical masses. -/
theorem allMassFromNullEdges_v2 (beta : ℝ) (hbeta : 0 < beta) (r : ℝ)
    (hr : 0 < r) (psi : Fin 2 → ℂ) :
    -- (1) four-obstruction bundle + F-YM-CONFLATE distinctness guard
    ((quarkMassParameter = 0 ∧ 0 < z2GlueballMass beta) ∧
      (Q_op v1 = (-2 / 3 : ℂ) • v1 ∧ Q_op v4 = (-1 / 3 : ℂ) • v4 ∧
        massForm v1 psi = massForm v4 psi) ∧
      (∀ {ι : Type} (s : Finset ι) (p : ι → Momentum4),
          (∀ i ∈ s, IsFutureNull (p i)) →
          (minkowskiSq (∑ i ∈ s, p i) = 0 ↔
            ∀ i ∈ s, ∀ j ∈ s, p i ≠ 0 → ∃ c : ℝ, 0 ≤ c ∧ p j = c • p i)) ∧
      ((∀ (m : ℂ) (μ : Fin 4), chiralOdd (massVertex m μ) = - γ μ) ∧
       (∀ (m : ℂ) (μ : Fin 4),
          chiralEven (massVertex m μ) = (m + 1) • (1 : Matrix (Fin 4) (Fin 4) ℂ)) ∧
       (∀ {L nc : ℕ} [NeZero L] (m m' : ℝ)
          (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ),
          Γ5 L nc * (wilsonDirac m U - wilsonDirac m' U) * Γ5 L nc
            = wilsonDirac m U - wilsonDirac m' U)) ∧
      ((quarkMassParameter = 0 ∧ 0 < z2GlueballMass beta) ∧
        (quarkMassParameter = 0 ∧ 0 < wilsonRegulatorMass r) ∧
        ((0 < z2GlueballMass beta ∧ wilsonRegulatorMass 0 = 0) ∧
          (0 < wilsonRegulatorMass r ∧ quarkMassParameter = 0)) ∧
        ((compositeApertureMassSq nullX nullX = 0 ∧ 0 < z2GlueballMass beta) ∧
          (0 < compositeApertureMassSq nullX nullY ∧ quarkMassParameter = 0)))) ∧
    -- (2) taxonomy NON-DEGENERACY (independent realizability)
    ((0 < wilsonRegulatorMass r ∧
        quarkMassParameter = 0 ∧
        z2GlueballMass 0 = 0 ∧
        compositeApertureMassSq nullX nullX = 0) ∧
      (0 < z2GlueballMass beta ∧
        quarkMassParameter = 0 ∧
        wilsonRegulatorMass 0 = 0 ∧
        compositeApertureMassSq nullX nullX = 0) ∧
      (0 < compositeApertureMassSq nullX nullY ∧
        quarkMassParameter = 0 ∧
        wilsonRegulatorMass 0 = 0 ∧
        z2GlueballMass 0 = 0) ∧
      (quarkMassParameter = 0 ∧
        0 < wilsonRegulatorMass r ∧
        0 < z2GlueballMass beta ∧
        0 < compositeApertureMassSq nullX nullY)) ∧
    -- (3) any-N aperture iff
    (∀ {ι : Type} (s : Finset ι) (p : ι → Momentum4),
        (∀ i ∈ s, IsFutureNull (p i)) →
        (minkowskiSq (∑ i ∈ s, p i) = 0 ↔
          ∀ i ∈ s, ∀ j ∈ s, p i ≠ 0 → ∃ c : ℝ, 0 ≤ c ∧ p j = c • p i)) ∧
    -- (4) common-carrier NEGATIVE
    (¬ ∃ c : CarrierParams, AllFourPositive c) := by
  refine ⟨allMassFromNullEdges_guarded beta hbeta r hr psi,
    massTaxonomy_nondegenerate hr hbeta, ?_, no_common_carrier_via_turn⟩
  intro ι s p hnull
  exact nbody_aperture_massless_iff_collinear s p hnull

/-! ## Build-enforced axiom-footprint guard

Mirrors the guard pattern of the bundled modules: this block FAILS TO BUILD if
the super-capstone's transitive axiom surface changes — e.g. if a `sorry` leaks
in through any of the four folded results, if a `native_decide`
(`Lean.ofReduceBool` / `Lean.trustCompiler`) is introduced underneath, or if a
new `axiom` appears. `(whitespace := lax)` only normalises line-wrapping; it does
not relax the axiom list. -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.AllMassFromNullEdgesV2.allMassFromNullEdges_v2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms allMassFromNullEdges_v2

end PhysicsSM.Draft.NullEdge.GateI1.AllMassFromNullEdgesV2
