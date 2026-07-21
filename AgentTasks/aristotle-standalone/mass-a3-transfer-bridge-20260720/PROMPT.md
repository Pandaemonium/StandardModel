# Strategy/design + lemma job: the reflection-positive finite transfer-matrix mass bridge (gate A3/A4)

Type: theorem-design + a self-contained Mathlib-only lemma. AFPL origin-of-mass
gate A3 (composite/binding mass) and A4 (gap-to-pole). Source-grounded in
Osterwalder-Seiler reflection positivity (a self-adjoint STRICTLY POSITIVE
transfer matrix `T = e^{-aH}`, `H >= 0`, so a transfer spectral gap is a genuine
Hamiltonian gap = correlation-decay rate = mass) and the Kallen-Lehmann spectral
representation (the two-point function is an integral over a spectral density
whose support/poles are the physical masses).

## Context: the complementary obstruction (already landed, kernel-checked)

`transfer_gap_does_not_fix_correlation_mass`: one transfer operator with spectral
gap `log 2` gives correlation `C(n) = 2^n + 1` for an observable overlapping the
fast mode but `C(n) = 1` for an observable orthogonal to it - so the transfer gap
alone does NOT fix the physical correlation mass. This job supplies the POSITIVE
direction: WHEN the observable overlaps the first excited state, the connected
correlation decay rate IS the transfer spectral gap.

## Deliverable 1 (the positive bridge lemma - the concrete target)

For a diagonal positive transfer operator `T = diag (lam) : Matrix (Fin m) (Fin m) ℝ`
with `lam 0 > lam j` for all `j != 0` (a spectral gap below the top / ground
mode) and an observable `v : Fin m -> ℝ`, define the two-point function
`C(n) = v ⬝ᵥ (T^n).mulVec v` and the CONNECTED correlation
`Cc(n) = C(n) - (v 0)^2 * (lam 0)^n` (subtracting the ground-mode contribution).
Prove:

1. `C(n) = ∑ j, (v j)^2 * (lam j)^n` (spectral decomposition of the correlation);
2. `Cc(n) = ∑_{j != 0} (v j)^2 * (lam j)^n`;
3. if the observable overlaps the first excited mode (`v 1 != 0` with
   `lam 1 = max_{j != 0} lam j` the second eigenvalue), then `Cc(n)` decays at
   exactly the rate `lam 1`, i.e. `Cc(n) / (lam 1)^n -> (v 1)^2 + ...` a positive
   constant (state the precise limit / bound). This exhibits the transfer
   spectral gap `log (lam 0 / lam 1)` as the physical mass, CONDITIONAL on the
   overlap `v 1 != 0`.

A clean `m = 2` or `m = 3` concrete version is acceptable if the general-`m`
limit is heavy; state exactly what is proved.

## Deliverable 2 (design report)

Design the smallest honest reflection-positive finite transfer-matrix API for a
nonabelian `SU(3)` composite-mass bridge (gate A3): the minimal data
(gauge-invariant Wilson/closure observable, a reflection-positive / positive
finite transfer operator, the correlation-decay <-> transfer-gap <-> composite-
mass relation, one nontrivial glueball-like finite sector, a control separating
constituent-rest inputs from binding energy). State what survives at finite size
and what continuum limit is owed. Consult PhysLean / lean-quantum for an existing
transfer-matrix or spectral-measure API to clean-room adapt rather than reinvent.

## Constraints

Mathlib only; no new `axiom`/`opaque`/`unsafe`; no `native_decide`; standard
axioms. Report axioms for anything proved.

## Success criteria

The positive-bridge lemma proved (concrete `m` acceptable) + the A3 API design
with explicit finite-vs-continuum scope. This completes the A3/A4 gap<->mass
story: obstruction (landed) + positive bridge (this job).
