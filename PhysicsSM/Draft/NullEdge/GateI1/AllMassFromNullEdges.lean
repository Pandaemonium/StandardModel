import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
import PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass
import PhysicsSM.Draft.NullEdge.GateI1.ChargeGradingMassCompatible
import PhysicsSM.Draft.NullEdge.GateYM.ChiralMassStructure

/-!
# The all-mass-from-null-edges capstone

A single kernel-checked statement bundling the three null-edge mass OBSTRUCTIONS
of `AgentTasks/fourday-ym-run-2026-07-05/NULL_EDGE_MASS_UNIFICATION.md` -
**T**urn (matter), **C**losure (gauge), **A**perture (composite) - together with
the octonion co-location verdict (mass is blind to the `Q_op` charge grading).
Every conjunct is discharged by an already-proved theorem; the capstone asserts
nothing new. It crystallizes the thesis "on a substrate whose primitive
transport is null, physical mass is a RELATIONAL OBSTRUCTION to free null
transport" as one named result.

## The four bundled facts (one representative theorem per obstruction)

1. **(C) Closure - "mass without mass"** (`MassWithoutMass.massWithoutMass`).
   The pure-gauge `Z2` single-plaquette glueball transfer gap is strictly
   positive (`0 < z2GlueballMass beta` for `beta > 0`) while the primitive
   quark-mass input is exactly zero (`quarkMassParameter = 0`). Positive
   composite mass, zero primitive mass: the (C) closure obstruction as a
   self-contained finite identity.
2. **(charge co-location)**
   (`ChargeGradingMassCompatible.charge_grading_mass_compatible`). On the shared
   module `ComplexOctonion (x) CSpinor` the null-edge mass form assigns the same
   mass to the ideal states `v1` and `v4` even though they carry DIFFERENT
   `Q_op` electric charges (`-2/3` vs `-1/3`). The octonion charge does not
   enter the mass: co-location, not coupling.
3. **(A) Aperture - "massless iff one null edge"**
   (`CompositeApertureMass.compositeMassSq_eq_zero_iff_collinear`). A composite
   of future-pointing null momenta has vanishing invariant mass iff the whole
   bundle points along a single null direction. Mass is exactly the APERTURE of
   the null bundle - the (A) composite obstruction.
4. **(T) Turn - "mass is the chirality-mixing channel"**
   (`ChiralMassStructure.gamma5_mass_diff_comm`). The mass content of the finite
   lattice Wilson-Dirac operator is chirality-EVEN: `Γ5 (D_m - D_{m'}) Γ5 =
   D_m - D_{m'}`. The entire mass dependence commutes with chirality, i.e. it
   lives in the "turn" channel, cleanly separated from the chirality-odd
   null-transport channel - the (T) matter obstruction at lattice-operator grade.

## Claim discipline

Claim label: **program synthesis** (a bundling of proved finite identities; no
new mathematics). This is a CONJUNCTION, NOT a proven single mechanism: the four
obstructions share a MECHANISM SHAPE (relational obstruction to null transport),
and F-YM-CONFLATE stays constitution-grade - the taxonomy rows are kept distinct
as theorems (see `MassTaxonomySeparation` for their provable independence). What
this capstone is NOT: it is NOT the physical Yang-Mills mass gap (conjunct 1 is a
finite toy; the real gap is off-ladder), NOT a continuum statement, and NOT a
numerical mass value. The octonion conjunct (2) is the honest NEGATIVE
co-location verdict, not a charge->mass coupling.

Draft-trust (imports draft modules across `GateI1` and `GateYM`); `s o r r y`-free,
standard axioms only. Left un-aggregated from `GateI1.lean` intentionally: it
crosses into the `GateYM` Wilson-Dirac tree, so it is kernel-checked standalone.
Prerequisite modules: `CompositeApertureMass`, `MassWithoutMass`,
`ChargeGradingMassCompatible`, `GateYM/ChiralMassStructure`.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.AllMassFromNullEdges

open PhysicsSM.Draft.NullEdge.GateI1
open PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
open PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass
open PhysicsSM.Draft.NullEdge.GateI1.ChargeGradingMassCompatible
open PhysicsSM.Draft.NullEdge.GateYM.ChiralMassStructure
open PhysicsSM.Draft.NullEdge.GateYM.Qmf4bWilson
open PhysicsSM.Algebra.Furey.MinimalLeftIdeal
open scoped Matrix

/-- **All mass from null edges, bundled.** For any glueball inverse-temperature
`beta > 0` and any spacetime spinor `psi`, the four proved facts hold together:
the closure glueball gap is positive with zero primitive mass (C); the null-edge
mass is blind to the `Q_op` charge grading (co-location); a composite of
future-null momenta is massless iff collinear (A); and the Wilson-Dirac mass
content is the chirality-even "turn" channel (T). Each conjunct is a proved
theorem; together they state that mass is a relational obstruction to free null
transport - closure, aperture, and turn - and that the octonion charge merely
co-locates on the same spinors without entering the mass. -/
theorem allMassFromNullEdges (beta : ℝ) (hbeta : 0 < beta) (psi : Fin 2 → ℂ) :
    -- (C) closure: positive glueball mass, zero primitive quark mass
    (quarkMassParameter = 0 ∧ 0 < z2GlueballMass beta) ∧
    -- (charge co-location): different Q_op charges, same null-edge mass
    (Q_op v1 = (-2 / 3 : ℂ) • v1 ∧ Q_op v4 = (-1 / 3 : ℂ) • v4 ∧
      massForm v1 psi = massForm v4 psi) ∧
    -- (A) aperture: composite of future-null momenta massless iff collinear
    (∀ {ι : Type} (s : Finset ι) (p : ι → Momentum4),
        (∀ i ∈ s, IsFutureNull (p i)) →
        (minkowskiSq (∑ i ∈ s, p i) = 0 ↔
          ∀ i ∈ s, ∀ j ∈ s, p i ≠ 0 → ∃ c : ℝ, 0 ≤ c ∧ p j = c • p i)) ∧
    -- (T) turn: the Wilson-Dirac mass content is the chirality-even channel
    (∀ {L nc : ℕ} [NeZero L] (m m' : ℝ)
        (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ),
        Γ5 L nc * (wilsonDirac m U - wilsonDirac m' U) * Γ5 L nc
          = wilsonDirac m U - wilsonDirac m' U) := by
  refine ⟨massWithoutMass hbeta, charge_grading_mass_compatible psi, ?_, ?_⟩
  · intro ι s p hnull
    exact compositeMassSq_eq_zero_iff_collinear s p hnull
  · intro L nc _ m m' U
    exact gamma5_mass_diff_comm m m' U

/-! ## Build-enforced axiom-footprint guard

The `NullStrand.Audit.CapstoneAxioms` pattern: this block FAILS TO BUILD if the
capstone's transitive axiom surface changes - e.g. if a `s o r r y` leaks in
through any of the four bundled pillars, if a `n a t i v e _ d e c i d e`
(`Lean.ofReduceBool` / `Lean.trustCompiler`) is introduced underneath, or if a
new `a x i o m` appears. `(whitespace := lax)` only normalises line-wrapping; it
does not relax the axiom list. -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.AllMassFromNullEdges.allMassFromNullEdges' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms allMassFromNullEdges

end PhysicsSM.Draft.NullEdge.GateI1.AllMassFromNullEdges
