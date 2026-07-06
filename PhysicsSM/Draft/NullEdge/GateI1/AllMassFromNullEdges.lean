import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
import PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass
import PhysicsSM.Draft.NullEdge.GateI1.ChargeGradingMassCompatible
import PhysicsSM.Draft.NullEdge.GateYM.ChiralMassStructure

/-!
# The all-mass-from-null-edges capstone

A single kernel-checked statement bundling FOUR REPRESENTATIVE finite facts -
one per null-edge mass OBSTRUCTION of
`AgentTasks/fourday-ym-run-2026-07-05/NULL_EDGE_MASS_UNIFICATION.md`:
**T**urn (matter), **C**losure (gauge), **A**perture (composite) - together with
the octonion co-location verdict (mass is blind to the `Q_op` charge grading).
Every conjunct is discharged by an already-proved theorem; the capstone asserts
nothing new. It crystallizes the thesis "on a substrate whose primitive
transport is null, physical mass is a RELATIONAL OBSTRUCTION to free null
transport" as one named result.

SCOPE (do not over-read the name): `allMassFromNullEdges` is a shorthand for the
mechanism thesis, NOT a claim that all physical mass is derived. It bundles four
INDEPENDENT finite/kinematic facts, each exhibiting mass as relational with no
primitive-mass input; it does NOT prove a single unified mechanism, and the
universal reading ("every physical mass is now derived from null edges") is
exactly the over-claim to avoid.

## The four bundled facts (one representative theorem per obstruction)

1. **(C) Closure - "mass without mass"** (`MassWithoutMass.massWithoutMass`).
   The pure-gauge `Z2` single-plaquette glueball transfer gap is strictly
   positive (`0 < z2GlueballMass beta` for `beta > 0`) while the primitive
   quark-mass input is exactly zero. Positive composite mass, zero primitive
   mass. NOTE: the "zero primitive mass" half is DEFINITIONAL
   (`quarkMassParameter := 0`, since the pure-gauge model has no fermions) - it
   is honest (no regulator is smuggled in, there being no fermions) but it is a
   definitional zero, not a derived cancellation; the CONTENT is the strictly
   positive gap `0 < log coth beta` with no mass input.
2. **(charge co-location)**
   (`ChargeGradingMassCompatible.charge_grading_mass_compatible`). On the shared
   module `ComplexOctonion (x) CSpinor` the null-edge mass form assigns the same
   mass to the ideal states `v1` and `v4` even though they carry DIFFERENT
   `Q_op` electric charges (`-2/3` vs `-1/3`). The octonion charge does not
   enter the mass: co-location, not coupling. (The charge difference is a real
   `Q_op` eigenvalue fact; the mass equality is a genuine norm coincidence
   `cNormSq v1 = cNormSq v4 = 1/2` - a SOUND negative result.)
3. **(A) Aperture - "massless iff one null edge"**
   (`CompositeApertureMass.compositeMassSq_eq_zero_iff_collinear`). A composite
   of future-pointing null momenta has vanishing invariant mass iff the whole
   bundle points along a single null direction. Mass is exactly the APERTURE of
   the null bundle - the (A) composite obstruction, a frame-invariant kinematic
   identity (the strongest conjunct).
4. **(T) Turn - "mass and transport live in SEPARATE chirality channels".**
   The genuine channel separation, at spin-vertex grade
   (`ChiralMassStructure.chiralOdd_massVertex`,
   `..._chiralEven_massVertex`): the chirality-ODD part of the mass vertex is
   exactly `-γ μ` - the pure null-transport generator, INDEPENDENT of the mass -
   while the chirality-EVEN part is `(m+1) • 1`, carrying the entire mass
   dependence. Transport lives in one channel, mass in the other. The
   operator-grade lift (`ChiralMassStructure.gamma5_mass_diff_comm`) then records
   that the Wilson-Dirac mass DIFFERENCE `D_m - D_{m'}` is chirality-even
   (a corollary of its being the scalar `(m-m') • 1`); the load-bearing "mass =
   turn channel" content is the spin-vertex separation, NOT the near-trivial
   operator-difference identity.

## Claim discipline

Claim label: **program synthesis** (a bundling of proved finite identities; no
new mathematics). This is a CONJUNCTION, NOT a proven single mechanism: the four
obstructions share a MECHANISM SHAPE (relational obstruction to null transport),
and F-YM-CONFLATE stays constitution-grade - the taxonomy rows must be kept
distinct as theorems. That distinctness guard (the four mass functionals proved
provably DISTINCT) is a SEPARATE target of this run (the `MassTaxonomySeparation`
theorem is NOT yet in the tree); until it lands, the honesty of the bundling
rests on the four conjuncts using four INDEPENDENT functionals with no cross-row
inference in the proof (a plain `⟨_,_,_,_⟩`), which is verified here but is
weaker than a proved-distinctness guard. What this capstone is NOT: it is NOT the
physical Yang-Mills mass gap (conjunct 1 is a finite toy; the real gap is
off-ladder), NOT a continuum statement, and NOT a numerical mass value. The
octonion conjunct (2) is the honest NEGATIVE co-location verdict, not a
charge->mass coupling.

Draft-trust (imports draft modules across `GateI1` and `GateYM`); `s o r r y`-free,
standard axioms only. Left un-aggregated from `GateI1.lean` intentionally: it
crosses into the `GateYM` Wilson-Dirac tree, so it is kernel-checked standalone.
Prerequisite modules: `CompositeApertureMass`, `MassWithoutMass`,
`ChargeGradingMassCompatible`, `GateYM/ChiralMassStructure`.

Provenance: claim discipline hardened per the overnight-run capstone audit
(Aristotle `5a7d6910`, findings in
`AgentTasks/overnight-mass-run-2026-07-06/all-mass-capstone-audit-FINDINGS_5a7d6910.md`):
the (T) conjunct was strengthened from the near-trivial operator-difference
identity to the genuine spin-vertex channel separation; the dangling
`MassTaxonomySeparation` citation, the definitional (C) zero, and the universal
"all mass" prose were all corrected.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.AllMassFromNullEdges

open PhysicsSM.Draft.NullEdge.GateI1
open PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
open PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass
open PhysicsSM.Draft.NullEdge.GateI1.ChargeGradingMassCompatible
open PhysicsSM.Draft.NullEdge.GateYM.ChiralMassStructure
open PhysicsSM.Draft.NullEdge.GateYM.Qmf4bWilson
open PhysicsSM.Draft.NullEdge.GateYM.EuclideanGamma
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
    -- (T) turn: mass and transport live in SEPARATE chirality channels -
    -- transport is the chirality-ODD part (= -γ μ, mass-INDEPENDENT), mass is
    -- the chirality-EVEN part (= (m+1)•1); plus the operator-grade corollary
    -- that the Wilson-Dirac mass DIFFERENCE is chirality-even.
    ((∀ (m : ℂ) (μ : Fin 4), chiralOdd (massVertex m μ) = - γ μ) ∧
     (∀ (m : ℂ) (μ : Fin 4),
        chiralEven (massVertex m μ) = (m + 1) • (1 : Matrix (Fin 4) (Fin 4) ℂ)) ∧
     (∀ {L nc : ℕ} [NeZero L] (m m' : ℝ)
        (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ),
        Γ5 L nc * (wilsonDirac m U - wilsonDirac m' U) * Γ5 L nc
          = wilsonDirac m U - wilsonDirac m' U)) := by
  refine ⟨massWithoutMass hbeta, charge_grading_mass_compatible psi, ?_, ?_, ?_, ?_⟩
  · intro ι s p hnull
    exact compositeMassSq_eq_zero_iff_collinear s p hnull
  · intro m μ
    exact chiralOdd_massVertex m μ
  · intro m μ
    exact chiralEven_massVertex m μ
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
