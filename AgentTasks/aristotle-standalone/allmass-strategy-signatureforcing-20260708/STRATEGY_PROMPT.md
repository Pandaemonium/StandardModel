# Proof + probe: the signature is forced, not chosen (Conjecture M)

## Context (blind to the wider repo)

A finite null-edge program takes null soldering `c(a)^2 = 0` with `c(a) != 0` as
primitive. In a real Clifford algebra `c(v)^2 = Q(v).1`. A definite quadratic form has NO
nonzero isotropic vector. So the existence of a single null edge FORCES the soldering
Gram to be indefinite — the Krein/indefinite structure is a one-line consequence of the
null primitive, not an axiom. This inverts the standard story: not "spacetime is
Lorentzian => null cones" but "null is primitive => any metric it generates is
indefinite."

## Targets
1. **`null_forces_indefinite` (rung 1, trivial M).** For a real quadratic form `Q`
   (`QuadraticForm R V`) with a nonzero isotropic vector (`exists v != 0, Q v = 0`), `Q`
   is NOT positive-definite (`not Q.PosDef`) and not negative-definite — i.e. `Q` is
   indefinite (or degenerate). One line from the definition of `PosDef`. Also state the
   Clifford wrapper: `c(v)^2 = 0`, `c(v) != 0` => the Clifford quadratic form is indefinite.
2. **`lorentzian_selector` (rung 2, harder — the "exactly one time" selector).** The
   natural selector for Lorentzian (one time, not two) is reflection positivity: an
   Osterwalder–Schrader / slab RP structure has a distinguished reflection direction,
   and multi-time signatures should fail it. Pre-register and, if tractable, prove a
   finite statement: a `(2,2)`-signature toy carrier FAILS reflection positivity (no
   nondegenerate RP physical sector) while `(1,3)` passes. (Independent cross-check to
   note: the projective null quadric in signature `(p,q)` is `(S^{p-1} x S^{q-1})/Z2`,
   a single connected celestial sphere iff `p=1` or `q=1` — a second selector converging
   on Lorentzian.) If the full RP proof is out of reach, deliver rung 1 + the precise
   `(2,2)`-vs-`(1,3)` RP statement as a pre-registered probe.

Kill: a `(2,2)` carrier passing OS positivity with a nondegenerate physical sector.

## Constraints
Kernel-checked only for proofs: no `sorry`/`admit`/`native_decide`/new `axiom`;
footprint `[propext, Classical.choice, Quot.sound]`, in-file `#print axioms`. Mathlib
only. Deliver Lean + `ARISTOTLE_SUMMARY.md`: rung 1 proved, the celestial-quadric
connectedness cross-check if clean, and rung 2 proved or stated as a precise probe.
