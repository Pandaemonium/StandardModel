# Phenomenologist update - Q_window benchmark RESOLVED for the HNU half-space

- Model/role: claude / Phenomenologist (solo mode)
- Updates the Class-3 boundary-defect observable card (role-20260714-002411,
  00:22) with the now-measured HNU value from the decisive Gate-1 determination.

## Executive update

The Class-3 boundary observable `Q_window` (near-boundary window charge per period)
that I carded at 00:22 as the decisive Gate-1 benchmark HAS NOW BEEN DETERMINED for
the HNU half-space step (Aristotle da29672d):

> **`Q_window(HNU) = 2*(tr P3- - tr P3+) = 0`** - the discriminator lands on the
> DOUBLING branch, not the single-`+1` branch.

The falsifier I pre-registered fired exactly as written: "the HNU held-out
recomputation returns 0 (or a paired +1,-1) ... the single-edge-Weyl route dies
here." It returned 0. So the observable is now a MEASURED value, not a prediction.

## Observable card - resolved values

| Quantity | Predicted (00:22 card) | Determined (Gate-1) |
| --- | --- | --- |
| `Q_window` shift control (`P=1,Q=0`) | `+1`, size-stable | `+1` (`pure_shift_window_trace`, sorry-free) - CONFIRMED |
| `Q_window` periodic control | `0` (unitary) | `0` (`periodic_control`, sorry-free) - CONFIRMED |
| `Q_window` channel additivity | `d(Q)/d(m) = 1` | linear in the projector traces (`Qwindow_formula`) - CONFIRMED |
| **`Q_window` HNU half-space** | single `+1` OR paired/0 (open) | **`0` (balanced projectors) - DOUBLING** |

## Units / sensitivity (unchanged, now with the value)

`Q_window` dimensionless integer per period. The determinant is the projector-trace
BALANCE: `Q_window = 2*(tr p - tr q)`. Exactly `0` for the HNU walk (`tr P3- = tr
P3+`, each rank `L^2`); exactly size-independent (no `1/N` tail). Sensitivity check
passed: deliberately unbalanced projectors (rank 1 vs 3) give `Q_window = -/+4`, so
the benchmark genuinely resolves imbalance - it is not a trivial zero.

## Concrete falsifier - OUTCOME

Pre-registered falsifier #3 (00:22 card) fired: the HNU held-out `Q_window` returned
`0`/paired, not a lone stabilized `+1`. Consequence (as written): the single-edge-
Weyl route is falsified at the HNU half-space boundary. This is now a RESULT, not a
kill of the program - it is the mapped-impossibility answer.

## The new phenomenological handle (mechanism as observable)

The determinant of the observable is now explicit and MEASURABLE: `Q_window != 0`
requires a projector-trace imbalance `tr p != tr q`. This gives a sharp, quantitative
design rule for any future single-Weyl construction: **engineer a boundary with a
chirality/sublattice imbalance** (the domain-wall route, 9eb52ec3, achieves exactly
this: `tr+ != tr-` -> `Q = +1`). The HNU walk, being balanced, cannot. So the
observable doubles as a design criterion.

## Claim ceiling (unchanged, now realized)

`Q_window(HNU) = 0` is a FINITE-lattice determination (M|partial - the headline
still owes 2 mechanical telescope lemmas; the controls/witness/precursor are
sorry-free + guarded). It does NOT license a Fredholm/bulk-edge/continuum/physical/
SM statement. It licenses exactly: "the finite HNU half-space step carries zero net
boundary chiral charge in a stable near-boundary window - doubling."

## Next observable gate

Once the 2 telescope lemmas land (follow-on fired), `Q_window(HNU) = 0` becomes a
fully kernel-checked benchmark. The design-rule corollary (`imbalance <-> nonzero
Q_window`) is the phenomenological deliverable to carry into any successor
single-Weyl construction.
