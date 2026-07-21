# Lemma job: a finite gauge-invariant SU(3) observable with a transfer gap (A3)

Mathlib-only. The hardest open origin-of-mass gate needs the smallest honest
nonabelian finite bridge. Build the gauge-invariance half concretely.

Work with `SU(3)` as `Matrix.specialUnitaryGroup (Fin 3) C` (or unitary with det 1).
On a tiny finite lattice (a single plaquette is fine: four links `U1..U4`), define:
- the plaquette variable `P = U1 * U2 * star U3 * star U4`;
- the Wilson observable `W = (P.trace).re`.
Prove:
1. **Gauge invariance**: under a gauge transformation `Ui -> g_x Ui (g_y)^*` with the
   standard endpoint assignment, `P` transforms by conjugation `P -> g P g^*`, hence
   `W` is INVARIANT. State the endpoint convention explicitly.
2. **Nonvacuity**: exhibit link configurations with `W` taking at least two DIFFERENT
   values (so the observable is not constant), and compute both.
3. **Bounds**: `|W| <= 3`, with equality iff `P = 1` (up to the trace bound).
4. **Center behaviour**: under `Ui -> z Ui` with `z` a cube root of unity times the
   identity (the SU(3) center), show how `P` and `W` transform - i.e. whether `W` is
   center-blind for the plaquette.
This is the gauge-invariant OBSERVABLE half only; the transfer-operator positivity and
the gap are separate and NOT to be claimed here. No new axioms/native_decide;
standard axioms; report axioms.
