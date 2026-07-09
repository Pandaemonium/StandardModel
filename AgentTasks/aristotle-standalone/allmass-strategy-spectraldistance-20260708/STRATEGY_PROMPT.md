# Strategy + proof: background independence via the spectral distance (Conjecture P)

## Context (blind to the wider repo)

A finite null-edge carrier `(algebra A, Dirac D, Krein J, grading Gamma)` currently takes
its finite 2-complex as background scaffolding. But the **Connes spectral distance**
`d(x,y) = sup{ |f(x) - f(y)| : f in A, ||[D,f]|| <= 1 }` is DEFINED for the finite carrier
right now, and Lorentzian versions exist (Franco–Eckstein causal spectral triples,
[import]). If it reproduces the complex's metric data, the complex was never input —
vertices, order, and distances are all RECOVERED from `(A, D, J, Gamma)` (a finite
Malament theorem: order => topology; decorations => the conformal factor = mass scale;
the E-channel = the mismatch between order-derived geometry and decoration-derived scale).

## Targets
1. **`spectral_distance_def` + compute on a small carrier.** Formalize `d(x,y)` for the
   finite carrier (A = functions on the vertex set, `[D,f]` the commutator, sup over the
   unit-Lipschitz ball). Compute it explicitly on a small witness (e.g. a 2-vertex / T2
   carrier) and PROVE it equals the expected edge-count / decoration-scale metric.
2. **`spectral_distance_recovers_edges` (the prize).** Prove that on the witness the
   spectral distance recovers the graph metric (adjacency => distance 1, decoration scale
   sets the units) — so the vertex set and its distances are recovered from `(A, D)`, not
   assumed.
3. **(If tractable) causal order recovery.** State (prove or pre-register) that
   Krein-positive propagation support determines the causal order — the finite Malament
   step.

Kill: the distance formula degenerates (`0` or `infinity`) on the witness.

## Constraints
Kernel-checked only for proofs: no `sorry`/`admit`/`native_decide`/new `axiom`;
footprint `[propext, Classical.choice, Quot.sound]`, in-file `#print axioms`. Mathlib
only; a small explicit carrier where the sup is a finite optimization. Deliver Lean +
`ARISTOTLE_SUMMARY.md`: the spectral-distance computation, the edge-recovery theorem, the
causal-order status, and an honest boundary (background independence on a finite witness,
not a continuum reconstruction theorem).
