# Finding: the §3↔§4 bridge splits, and the discrepancy is a binding energy

**Date:** 2026-07-08 (all-mass overnight run). **Origin:** Fable feedback item 1
(reframe crux 0b). **Status:** numeric-oracle proof-of-concept (MEMO). **Probe:**
`Scripts/oracle/probe_bridge_binding_energy.py`. **Carrier:** the validated
two-edge Cl(4) escape carrier (`probe_multiedge_positive_sector.py`).

## The result

Crux 0b (`min spec(D^#D|P) = det P`) was flagged "may be false" (Aristotle) and
"probably false, and that's interesting" (Fable). Tested on the escape carrier,
the picture is clean and splits exactly as Fable proposed:

1. **Free bridge holds.** With closure off (flat transport), the sector's least
   eigenvalue equals the aperture/kinematic baseline (`= 2` here). This is the
   free-case equality `0b(a)` - an **M-target**, near-automatic from the Clifford
   relation `(slash)^2 = det P`.
2. **Closure binds.** Turning up the closure strength `t` lowers the ground mass
   *linearly*, `Delta := min spec - baseline = -t < 0`. Negative shift = the sign
   of a **binding energy**, not an additive constituent mass.
3. **The binding is off-diagonal.** The closure expectation in the *free* ground
   state is `~0`, yet the true ground state at `t>0` reorganizes onto the
   negative-closure direction. So `Delta` is genuine binding that is **invisible
   to the naive constituent estimate** - which is *exactly why* the naive bridge
   `0b` fails: binding lives off-diagonal in the free basis. This is the finite
   shadow of the physical fact that a bound state's mass is not naively assembled
   from constituents.
4. **A finite critical-coupling phase structure.** `min spec` reaches `0` at
   `t = 2 =` the aperture strength: aperture-dominates -> positive bound mass;
   closure `=` aperture -> a **massless bound state**; closure-dominates ->
   positivity lost. A clean, finite, kernel-adjacent picture of confinement-like
   mass generation and its collapse.

## The upshot: a new invariant, and a repaired conjecture

The bridge should be **re-registered as a split**:

- **0b(a) - free equality (M-target).** Flat transport, zero turn `=>`
  `min spec(D^#D|P) = det P` of the ground bundle. Provable by direct Clifford
  computation; the honest "the operator mass IS the kinematic mass" theorem, in
  the free case.
- **0b(b) - the binding defect (C, new invariant).** For interacting carriers,
  `Delta := min spec(D^#D|P) - det P` is a finite, negative, closure-controlled
  **binding energy** - the program's first. Conjecture: `Delta` is governed by
  the closure/turn expectations (off-diagonally). **Kill:** a carrier where
  `Delta` is positive, or is uncorrelated with the closure sector.

This turns "the bridge is probably false" from a weakness into a *discovery*: the
failure of naive additivity is the binding energy, and the program now has a
finite handle on it. It also newly connects to §9 (mass generation) and §6
(closure as the binding channel) and gives the massless-bound-state point a
concrete meaning.

## Honest scope

Numeric oracle on the escape carrier. The free-case min spec here *is* the
aperture baseline by construction; comparing 0b(a) against a fully **independent**
`det P` needs an enriched carrier with explicit overlapping null momenta (the
`ψ_i` of §3) - the documented follow-up that makes 0b(a) a clean Lean M-target.
The `Delta`-as-binding reading (0b(b)) is a pre-registered conjecture with the
kill condition above.
