# claude-unified-action-variation — one spectral action, both field equations (the §7 unification capstone)

## Context (blind to any repo; self-contained finite matrix calculus, Mathlib only)

The unification capstone: ONE finite spectral action `S(D)`, varied in the SOLDERING (geometry)
gives the gravity field equation, and varied in the MATTER couplings gives the matter equation --
both from the same functional, at different orders. Composes the landed SpectralActionAvatar
(order split), EinsteinHilbertTerm (order-2 = curvature), GravitySourceMatter (G=kappaT).

## The model (explicit rational matrices)

`D(E, g) = Dkin + E * Dsold + g * Dmatter` -- an explicit rational Dirac operator with soldering
decoration `E` and matter coupling `g`. Spectral action `S = a0 tr(1) + a2 tr(D^2) + a4 tr(D^4)`
(rational polynomial in `E, g`).

## Targets

1. `action_closed_form`: `S(E,g)` as an explicit rational polynomial in `(E, g)` (via
   `tr(D^2), tr(D^4)` closed forms), with the order-0 (`a0 tr(1)`, constant), order-2 (E-dependent,
   gravity) and order-4 (g-dependent, matter) parts identified.
2. `gravity_equation` (payload 1): `d S / d E = 0` (soldering stationarity, via HasDerivAt) gives
   the finite GRAVITY field equation -- an explicit rational relation `E* = f(g, ...)` (the geometry
   responding to the matter coupling). Both directions.
3. `matter_equation` (payload 2): `d S / d g = 0` (matter stationarity) gives the finite MATTER
   field equation `g* = h(E, ...)`. Both directions.
4. `coupled_stationary_point`: the JOINT stationary point `(E*, g*)` solving both simultaneously --
   exhibit it as an explicit rational pair; the geometry and matter co-determine each other through
   the single action. `one_action_verdict`: package -- one functional `S(D)`, two field equations
   (gravity from `dS/dE`, matter from `dS/dg`), coupled at a joint stationary point; matter mass,
   gravity, and Lambda (order 0) are all rungs of `S`. The finite "one action, both forces."
   Honest scope: a finite polynomial-action avatar, not the continuum spectral action.

MANDATORY non-degeneracy: fully explicit rational `Dkin, Dsold, Dmatter` (all nonzero, distinct);
the joint `(E*, g*)` a specific nonzero rational pair; a control `(E,g)` where neither equation
holds; the gravity and matter equations genuinely DISTINCT (different derivatives). All in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL rational matrices (small); ring/norm_num/decide/fin_cases +
HasDerivAt column-by-column; NO Complex, NO Real.sqrt/cos/sin, NO nlinarith deg>=3. Build under 3
min. Deliver RequestProject/Main.lean (namespace UnifiedActionVariation) + ARISTOTLE_SUMMARY.md.
