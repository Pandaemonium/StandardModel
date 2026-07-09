# claude-jacobson-clausius — the finite gravitational equation of state (Clausius => field equation)

## Context (blind to any repo; self-contained finite rational algebra, Mathlib only)

Jacobson (1995) derived the Einstein equation as an EQUATION OF STATE: demanding the
Clausius relation `delta Q = T delta S` (with `S` proportional to horizon AREA) across every
local causal horizon forces the field equation. Build the FINITE avatar for the null-edge
soldering (gravity) channel: entropy = pierced-edge count, heat = soldering-budget flux,
temperature = a finite Unruh-type constant; prove the Clausius relation holds (for all
soldering variations) IFF a finite field equation relating the soldering curvature to the
budget flux holds. Everything rational and finite.

## The model (explicit rational quantities; a small causal slab)

A finite causal slab has a boundary crossed by `N` null edges (the "area", a nonneg integer/
rational). Soldering decorations `gamma` (a rational parameter vector, e.g. `(g0,g1)`)
deform the slab. Define, as explicit rational functions of `gamma`:
- `area gamma` = the pierced-edge count / boundary measure (an explicit rational, e.g. linear
  in gamma).
- `entropy gamma = alpha * area gamma` (rational coefficient `alpha`, e.g. `1/4`).
- `heat gamma` = the soldering-channel budget flux across the boundary (an explicit rational
  function of gamma — the `E_#` E-slot flux).
- `temp` = a fixed rational Unruh-type temperature `T` (a nonzero rational constant).

## Targets (all ring/norm_num/decide on explicit rationals)

1. `clausius_lhs_rhs`: closed forms for `delta heat` and `T * delta entropy` under a soldering
   variation `gamma -> gamma + t*v` (via `HasDerivAt` or explicit finite differences on the
   rational functions).
2. `equation_of_state` (payload): the Clausius relation `d/dt heat = T * (d/dt entropy)` holds
   for ALL variation directions `v` IFF the finite field equation `FieldEq gamma` holds, where
   `FieldEq` is the explicit linear relation between the soldering-flux gradient and the
   area gradient (`grad heat = T * alpha * grad area`). Prove both directions. THIS is
   "the field equation is the integrability condition of the equation of state."
3. `jacobson_verdict`: package — the finite soldering (gravity) field equation is EQUIVALENT
   to imposing the Clausius law `delta Q = T delta S` with `S ~ area` across the slab. So the
   gravity channel obeys a thermodynamic equation of state, finitely and kernel-checked.

MANDATORY non-degeneracy: exhibit an explicit rational witness where the field equation HOLDS
with all quantities NONZERO (a specific `gamma*`, `v`, with `delta heat = T delta S != 0`), and
a control witness where the Clausius relation FAILS (field equation violated) — so the
equivalence is not vacuous. State both explicit rationals in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print
axioms <thm>` on every headline. Rational/real; ring/norm_num/decide/fin_cases + HasDerivAt for
the finite gradients; NO Complex, NO Real.cos/sin/sqrt, NO nlinarith deg>=3. Build under 3 min.
Deliver RequestProject/Main.lean (namespace JacobsonClausius) + ARISTOTLE_SUMMARY.md with honest
scope (a finite slab avatar of the equation-of-state derivation, not continuum GR).
