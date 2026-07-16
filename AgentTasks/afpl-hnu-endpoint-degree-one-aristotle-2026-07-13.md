# Aristotle strategy/formalization: exact HNU endpoint degree one

We need the central missing theorem for a 3+1 anomalous-Floquet resolution.
The candidate drive is a finite product of projector-conditioned null shifts,
with endpoint map `U : T^3 -> SU(2) ~= S^3`. The desired invariant is the
three-dimensional endpoint degree/winding, not a `pi_4` micromotion invariant.

Find the sharpest exact Lean-ready route to `W(U)=1`. Prefer an explicit
piecewise, trigonometric, Laurent-polynomial, or algebraic map whose degree one
can be proved from available Mathlib APIs. If the required Brouwer-degree or
integration API is absent, return: (1) the maximal kernel-checked algebraic
core, (2) the exact missing topology lemma stated in Lean, (3) identity and
orientation-reversal controls, and (4) a counterexample to any tempting finite
surrogate that is not homotopy invariant. Do not use a finite lookup table as
a substitute for degree.
