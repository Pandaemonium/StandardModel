# claude-spectral-action-avatar — one finite functional yields BOTH gravity and matter (Connes-Chamseddine, finite)

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

Connes-Chamseddine: the ENTIRE Standard Model coupled to gravity comes from ONE spectral
action `Tr f(D/Lambda)`, whose heat-kernel expansion gives, at successive orders, a
cosmological term, the Einstein-Hilbert (GRAVITY) term, and the Yang-Mills/Higgs (MATTER)
terms. There is a discrete precedent (spectral action on quivers/Bratteli networks). Build
the FINITE avatar: one rational trace functional of the carrier Dirac operator whose
polynomial expansion SEPARATES into a gravity (soldering) piece and a matter (channel) piece.

## The model (explicit rational 4x4 or 6x6 matrices)

Let `D = Dkin + Dsold + Dmatter` be an explicit rational finite Dirac operator, a sum of a
kinetic part, a SOLDERING (gravity) part `Dsold` (built from the E-slot generators), and a
MATTER part `Dmatter` (built from the aperture/closure/turn channel generators). The finite
spectral action with a polynomial cutoff `f(x) = a0 + a2 x + a4 x^2`:
`S(D) = a0 * tr(1) + a2 * tr(D^2) + a4 * tr(D^4)`.

## Targets (all ring/norm_num on explicit rational matrices)

1. `spectral_action_expansion`: closed form of `S(D)` as an explicit rational polynomial in
   the coefficients `(a0,a2,a4)` and the coupling parameters (soldering `E`, matter couplings).
   Compute `tr(1)`, `tr(D^2)`, `tr(D^4)` in closed form.
2. `gravity_term_isolated` (payload part 1): `tr(D^2)` (the order-2 term) depends on the
   SOLDERING/geometry data — exhibit `tr(D^2) = (volume const) + (gravity coefficient)*E^2 +
   ...`, so the `a2` order is the GRAVITY (Einstein-Hilbert-analog / cosmological) sector.
3. `matter_term_isolated` (payload part 2): `tr(D^4)` (the order-4 term) contains the MATTER
   channel couplings (aperture/closure/turn) as an explicit quadratic form — the Yang-Mills/
   Higgs-analog sector. Exhibit the matter couplings appearing at order 4 and NOT at order 2
   (or with a distinct coefficient), so the two sectors are genuinely separated by order.
4. `one_functional_verdict`: package — the single finite functional `S(D)` yields BOTH a
   gravity (soldering, order 2) term and a matter (channel, order 4) term; varying `S` w.r.t.
   the soldering gives the gravity sector and w.r.t. the matter couplings gives the matter
   sector. "One action, both forces," finitely.

MANDATORY non-degeneracy: fully explicit rational `D` with `Dsold, Dmatter` both NONZERO and
distinct; instantiate `S(D)` at explicit rational `(a0,a2,a4)` and couplings giving specific
nonzero rational gravity and matter contributions (stated in-theorem); show the gravity and
matter terms are NOT proportional (genuinely two sectors).

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print
axioms <thm>` on every headline. REAL rational matrices (traces of powers -- keep dimensions
small, 4x4 or 6x6); ring/norm_num/decide/fin_cases; NO Complex, NO Real.cos/sin/sqrt, NO
nlinarith deg>=3. Build under 3 min. Deliver RequestProject/Main.lean (namespace
SpectralActionAvatar) + ARISTOTLE_SUMMARY.md with honest scope (a finite polynomial-cutoff
avatar of the spectral action, not the heat-kernel asymptotics of a real spectral triple).
