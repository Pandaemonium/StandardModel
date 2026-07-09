# claude-teleparallel-soldering-connection — the soldering E-slot is a finite teleparallel connection (torsion = gravity)

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

Teleparallel gravity re-expresses gravity via a FLAT connection with nonzero TORSION (not
curvature). The framework's soldering (E-slot) channel is the gravity channel. Prove the finite
statement: the soldering decoration defines a finite connection that is FLAT (zero curvature) but
has nonzero TORSION, and the torsion is the gravitational field strength; the E-slot splits into
torsion + nonmetricity (pure-torsion is the teleparallel choice).

## The model (explicit rational matrices; a small edge/vertex complex)

A tiny graph (2-3 vertices, a few oriented edges). Each edge `e` carries a soldering `gamma_e`
(a rational matrix / GL element = the null-frame comparison across `e`). Define:
- Connection: parallel transport along an edge = `gamma_e`.
- Curvature `F(loop) = product of gamma_e around a loop` -- FLATNESS = `F = 1` for every loop
  (transport is path-independent up to the teleparallel gauge).
- Torsion `T(e) = gamma_e - gamma_e^{sym}` / the antisymmetric part (the failure of the soldering
  to close), and nonmetricity `Q(e) =` the symmetric/metric-changing part.

## Targets

1. `curvature_flat`: for the chosen soldering, `F(loop) = 1` around every basic loop (the
   connection is FLAT -- teleparallel) -- an explicit product-of-matrices identity by `ring`.
2. `torsion_nonzero` (payload): the torsion `T(e)` is NONZERO for a generic soldering (exhibit an
   explicit rational `gamma_e` with `T(e) != 0`), so gravity is carried by TORSION, not curvature.
3. `eslot_torsion_nonmetricity_split`: `E_# = torsion (+) nonmetricity` -- the soldering channel
   decomposes into an antisymmetric (torsion) and a symmetric (nonmetricity) part, exactly (a
   `ring` identity); the pure-torsion (teleparallel) choice sets nonmetricity to zero -- exhibit
   both a pure-torsion soldering and a mixed one.
4. `teleparallel_verdict`: package -- the soldering/E-slot IS a finite teleparallel connection:
   flat curvature, nonzero torsion, torsion = the gravitational field strength, E_# = T (+) Q.
   Honest scope: a finite one-complex avatar of teleparallel geometry, not continuum gravity.

MANDATORY non-degeneracy: fully explicit rational solderings; `F = 1` verified on a concrete loop,
`T != 0` at a specific nonzero rational value, both stated in-theorem; a control soldering with
`T = 0` (trivial/no-gravity) to show torsion genuinely distinguishes.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL rational matrices (small); ring/norm_num/decide/fin_cases; NO
Complex, NO Real.sqrt/cos/sin, NO nlinarith deg>=3. Build under 3 min. Deliver
RequestProject/Main.lean (namespace TeleparallelSoldering) + ARISTOTLE_SUMMARY.md.
