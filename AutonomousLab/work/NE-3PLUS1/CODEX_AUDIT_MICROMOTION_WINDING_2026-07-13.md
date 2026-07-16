# Audit: finite micromotion-winding Aristotle result

Date: 2026-07-13
Work item: `QCA-3PLUS1-001`
Aristotle project: `ba61cbed-a25d-4cad-88d8-f350a3b7a194`
Disposition: **design harvested; Lean payload rejected for integration**

## Useful result

The job correctly rejects a putative integer invariant of a four-dimensional
`T^3 x S^1 -> U(N)` map and redirects AF3 toward a three-dimensional
`pi_3`-type degree defined relative to a quasienergy-gap tag. It also identifies
the missing schedule-to-field and sector-balance bridges as separate work.

## Why the Lean payload does not land

1. `simpDeg` is defined to be the sum of `crossingCharge`, so `balance` is
   `rfl`. This is a naming identity, not a finite Nielsen-Ninomiya theorem.
2. The input is an arbitrary function `Fin 5 -> Fin 5`. It contains no
   simplicial-map condition, no unitary schedule, no quasienergy gap tag, no
   zero/pi sector, and no map from the HNU endpoint or micromotion.
3. `Fin 5` is described as a finite model of `SU(2) ~= S^3`, but no geometric,
   simplicial, or homotopy equivalence is represented in Lean. Consequently
   `simpDeg_id = 1` is a finite combinatorial calculation, not yet an `SU(2)`
   winding theorem.
4. The major structural laws use compiled evaluation and therefore depend on
   `Lean.ofReduceBool` and `Lean.trustCompiler`. They are draft-trust, not
   kernel-only flagship results.
5. “Gauge transformations” are global permutations of five labels. No theorem
   connects these to continuous or vertexwise `SU(2)` gauge changes.
6. `determinant_insufficient` only proves that two values of the newly defined
   finite function differ. It does not include determinants or unitary matrices
   in its statement.

## Replacement theorem ladder

1. Prove the finite combinatorial degree laws without compiled evaluation and
   call them only combinatorial-degree lemmas.
2. Add an admissible oriented simplicial-map structure and prove regular-value
   independence or subdivision invariance.
3. Construct an explicit map from a gap-tagged HNU schedule or endpoint to the
   admissible finite field.
4. Prove that the combinatorial local degree equals the determinant-sign charge
   and, separately, the enclosing-sphere Chern charge.
5. Only then prove a zero/pi sector balance that is not definitional.

Until rungs 3-5 land, the result is a useful finite analogy and proof-design
document, not evidence that the physical winding or balance has been
formalized.
