import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.ElitzurLattice

/-!
# NE-U3: the closure obstruction (no gauge-invariant single-edge state)

Rung NE-U3 of the null-edge mass unification ladder
(`AgentTasks/fourday-ym-run-2026-07-05/NULL_EDGE_MASS_UNIFICATION.md`). This is
a thin, honest wrapper around Codex's quantitative Elitzur theorem
(`ElitzurLattice.elitzur_bound`), extracting its sharpest null-edge reading as a
named corollary. It does NOT re-prove or edit any Elitzur content; it only
specializes the existing bound at zero source.

## The closure pillar, made exact

The null-edge unification's (C) obstruction says: an OPEN gauge transport edge is
gauge-covariant, not gauge-invariant, so there is no physical single-edge gauge
state; the physical gauge spectrum begins at CLOSED flux composites, and the
mass gap is the cost of closure. Elitzur's theorem is the finite kernel-checked
form of "gluon edges are bookkeeping, not particles". Its sharpest corollary is
at ZERO external source: `tanh(0) = 0`, so the quantitative bound collapses to

    <single-link flip-odd observable> = 0   exactly, unnormalized,

for EVERY finite lattice, coupling, and gauge-invariant action term. There is no
single-link order parameter at all - the "gluon edge" has identically zero
gauge-invariant expectation. Mass in this sector cannot be a primitive single-
edge quantity; it must be relational/composite (the closure obstruction).

## Claim discipline

Claim label: **finite identity** (Z2, finite lattice, exact). Convention and
provenance inherited verbatim from `ElitzurLattice` (Codex; PKG-YM1-lattice).
Draft-trust, kernel-checked, `s o r r y`-free. Prerequisites: `ElitzurLattice`.
This is the (C) pillar of the null-edge mass unification; the (T) turn pillar is
`ChiralMassStructure` (NE-U2) and the (A) aperture pillar is
`GateI1/CompositeApertureMass` (NE-U1).
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.GateYM
namespace ClosureObstruction

open PhysicsSM.Draft.NullEdge.GateYM.ElitzurLattice
open PhysicsSM.Draft.NullEdge.GateYM.Z2GaugeCore (LinkField plaqSpins)

variable {V : Type} [Fintype V] [DecidableEq V]

/-- **NE-U3 (closure obstruction / no single-edge order parameter).** At zero
external source, the UNNORMALIZED expectation of any single-link, one-site-flip-
odd, bounded observable in the Z2 Wilson ensemble vanishes EXACTLY. Elitzur's
quantitative bound at `h = 0` gives `|<f>| <= c * tanh(0) * Z = 0`. There is no
gauge-invariant single-edge state: an open gauge edge carries no physical
expectation, so any gauge-sector mass must be a closed-composite (relational)
property, not a primitive edge quantity. -/
theorem no_single_link_order_parameter (E : Finset (V × V)) (x0 : V)
    (hloop : NoSelfLoopAt E x0) (ps : List (V × V × V × V)) (beta : ℝ)
    (f : LinkField V → ℝ) (c : ℝ)
    (hodd : ∀ U, f (flipAt x0 U) = - f U) (hfb : ∀ U, |f U| ≤ c) :
    ∑ U, f U * Real.exp (beta * ((plaqSpins U ps).map (fun b => spin b)).sum) = 0 := by
  have hbound := elitzur_bound E x0 hloop ps beta 0 le_rfl f c hodd hfb
  -- `tanh 0 = 0` kills the bound; the `h = 0` source term drops from the weight
  simp only [Real.tanh_zero, zero_mul, mul_zero, add_zero] at hbound
  exact abs_eq_zero.mp (le_antisymm hbound (abs_nonneg _))

end ClosureObstruction
end PhysicsSM.Draft.NullEdge.GateYM
