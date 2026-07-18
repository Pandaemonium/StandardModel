# C3 design: closure-channel circulation vs the landed area law

Author: claude / research_scientist. Date: 2026-07-16.
Status: DESIGN ONLY - no theorem claimed here; this is the gate spec for
conjecture C3 of the spiral-layer program note
(`CLAUDE_SPIRAL_LAYER_PROGRAM_NOTE_2026-07-16.md`). Wave-4 candidate,
contingent on wave-2 landing.

## The question

The four-channel mass budget assigns the gauge/QCD-facing share to the
CLOSURE channel. The spiral layer's reading is that a circulating (closed
spiral) history is a framed loop, and its closure cost should connect to
the program's one landed confinement-shaped result: the YM1 concrete-lattice
Wilson-loop area law. C3 asks for the exact finite bridge.

## The structural discovery that shapes the design

The spin-corner calculus splits a closed history's weight into MAGNITUDE
(product of per-corner overlap factors (1 + cos theta_i)/2) and PHASE
(orientation content; by the wave-1/2/3 ladder, half the enclosed solid
angle). These scale DIFFERENTLY under loop refinement:

- **Kinked (polygonal) loops:** each genuine corner of turning angle theta
  costs a magnitude factor (1 + cos theta)/2 < 1. The total magnitude
  decays with the NUMBER of corners - a perimeter-type cost. For such
  loops the closure share is corner-suppressed independently of area.
- **Smooth loops (refinement limit):** discretize a smooth direction loop
  into n corners of turning angle ~ c/n. Then the magnitude product is
  ~ prod cos^2(pi-ish c/2n) = exp(-O(1/n)) -> 1, while the accumulated
  phase converges to the Berry value (half the enclosed solid angle). In
  the limit the spin factor is a PURE PHASE: it costs nothing in magnitude.

Consequence for the bridge: for smooth loops the spin/corner factor cannot
degrade an area-law bound - the expectation of (Wilson loop) x (spin
factor) inherits the Wilson decay exactly, with an explicit O(1/n)
discretization correction. For kinked loops the spin factor adds a
perimeter-type suppression ON TOP of the area law. Both statements are
finite and kernel-checkable in the right model.

## Proposed finite targets (wave-4 shape, in increasing ambition)

- **T1 (pure corner calculus; no gauge field).** For the regular n-gon on
  a circle of the direction sphere (cap of solid angle Omega): the ordered
  corner product has magnitude m_n with an explicit bound
  exp(-C/n) <= m_n <= 1 and phase phi_n with |phi_n - Omega/2| <= C'/n
  (or the exact closed forms; rational witnesses at n = 4, 6). This is the
  "smooth loops cost nothing but phase" theorem and independently the
  quantitative Berry-limit statement for the corner calculus. Fully
  standalone (Pauli + trig or rational Pythagorean families).
- **T2 (transfer lemma; YM1 lattice).** In the landed YM1 concrete-lattice
  model, define the framed-loop observable W_framed(L) = W(L) * S(L) where
  W is the landed Wilson loop and S the spin-corner factor of the loop's
  direction sequence (a fixed unimodular-bounded scalar, |S| <= 1, exactly
  1 - per-corner-deficit). Then |E[W_framed]| <= |E[W]| <= area bound
  (trivial half), AND the nonvacuity half: for the axis-aligned rectangular
  loops of the landed area law, S is an EXPLICIT computable constant
  (four right-angle corners: S-magnitude = (1/2)^4 exactly, phase from the
  planar +-1 rule), so E[W_framed] = S * E[W] EXACTLY (S deterministic,
  factors out of the expectation) and the area law transfers with the
  explicit corner constant. Kill condition: if S fails to factor out (spin
  factor not independent of the gauge average in the model), the clean
  transfer dies and C3 must be reformulated with correlated framing.
- **T3 (crossover statement).** Quantify perimeter-vs-area: for rectangle
  R(a,b), the framed bound is (corner constant) * exp(-sigma * a * b)
  while a kinked refinement with k extra corners pays (1/2-type)^k;
  exhibit the crossover k*(a,b) beyond which corner cost dominates. This
  is the honest boundary of the "closure share = area" reading.

## What C3 does NOT claim (carried from the program note)

No continuum limit, no physical QCD string tension, no claim that the
program's closure channel IS confinement. T2's Wilson factor is the landed
finite-lattice object; the framing S is a fixed spectator scalar in the
first pass (correlated/dynamical framing is exactly what the kill
condition probes).

## Dependencies and sequencing

T1 needs only the wave-1/2 corner calculus (and profits from wave-3's
VOS-arctan law for the phase half). T2 needs the YM1 lane's area-law
module names and its expectation formalism - coordinate with that lane
before freezing statements; the rectangle corner constant claim ((1/2)^4)
must be checked against the lattice loop's actual direction sequence
(axis-aligned rectangles have four right-angle direction corners in the
plane - planar, so S is real up to sign by wave-2C; sign from the
hairpin/backtrack rules). Freeze exact statements only after wave-2
verdicts land; register as SPIRAL-LAYER-001 rungs if codex opens the item.
