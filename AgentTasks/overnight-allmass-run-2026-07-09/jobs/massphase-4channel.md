# claude-massphase-4channel — P-B: the multi-channel mass phase diagram of the 4-parameter block

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

A landed result classifies the 3x3 block `B(lam,kap)` (spectrum `{lam-kap, lam, lam+kap}`) into
three mass phases: massive `|kap|<lam`, critical `|kap|=lam`, over-closure `|kap|>lam`. Extend to
the FULL four-channel block with aperture `lam`, closure `kap`, chiral turn `tau`, soldering `E`,
and classify its mass phases by the eigenvalue signature.

## The model (REAL symmetric / explicit 3x3 or 4x4, rational)

Build an explicit real symmetric block `Bc(lam,kap,tau,E)` combining the four channels (aperture on
the diagonal, closure/turn as the landed off-diagonal `[[lam,kap,0],[kap,lam,0],[0,0,lam]]` plus a
turn contribution and a soldering diagonal shift). Give it concretely so its characteristic
polynomial / eigenvalues are exactly computable in rationals. Define the least eigenvalue = m^2 of
the lightest sector.

## Targets

1. `spectrum_closed_form`: the eigenvalues of `Bc` in closed form (rational/algebraic in the four
   couplings) at a tractable slice (e.g. tau or E turned on one at a time, or a symmetric ansatz).
2. `phase_predicates`: define the phases by the sign of the least eigenvalue m^2:
   MASSIVE (m^2 > 0, PosDef), CRITICAL (m^2 = 0, PSD with kernel), OVER-CLOSURE / GHOST (m^2 < 0,
   indefinite). Prove they are exhaustive and exclusive.
3. `phase_boundaries` (payload): give the explicit critical SURFACE in coupling space where
   m^2 = 0 — e.g. `|kap| = f(lam, tau, E)` for your block — generalizing the landed `|kap|=lam`
   critical line to the multi-channel critical variety. State the closed-form boundary and prove
   crossing it changes the phase (exhibit a massive point and a ghost point on either side).
4. `channel_roles`: show each channel's qualitative role on the phase: aperture raises m^2 (mass
   generator), closure/turn can lower it toward criticality (mass reducers), soldering shifts it —
   as sign statements on the eigenvalue derivatives or explicit comparisons at rational points.

MANDATORY non-degeneracy: explicit rational witnesses — a massive point (e.g. all-aperture),
a critical point, and a ghost point — each with its computed m^2 (specific rationals) in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL symmetric rational matrices; characteristic polynomial via ring +
eigenvalue sign conditions by norm_num/decide/fin_cases; keep the char poly LOW degree (factor it);
NO Complex, NO Real.sqrt (use squared/factored criteria), NO nlinarith deg>=3. Build under 3 min.
Deliver RequestProject/Main.lean (namespace MassPhase4Channel) + ARISTOTLE_SUMMARY.md with honest
scope (a finite block model, the phases of one explicit multi-channel ansatz).
