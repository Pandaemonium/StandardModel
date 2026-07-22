# Summary of changes for run 9d9711db-e2e8-4751-95f2-fafe68ca4b22
Completed the wave-3 adversarial audit.

Deliverables:
- `AUDIT.md`: detailed verdicts for all five landings, including over-claim classification, counterexample analysis, and a strengthening or repair for each.
- `RequestProject/AuditWitnesses.lean`: Mathlib-only formal witnesses and strengthened results.
- Updated the project target so the witness module is built by default.

Key findings:
1. **Yukawa uniqueness:** phase fixing alone does not imply uniqueness; nonzero is also insufficient because magnitude remains free. Fixed magnitude plus phase repairs the claim. A true `finrank = 1` space cannot be `{0}`, while a weaker `finrank ≤ 1` claim may permit vacuity.
2. **Mechanism matrix:** the zero-intersection claim survives the trivial grading. Every map is even and only zero is odd. Surjectivity of `Γ` already suffices; no fixed-vector condition is needed.
3. **Resolvent response:** a `(0,0)` entry formula does not determine the full response matrix or a two-point observable. A formal pair of unequal matrices with the same displayed entry witnesses the over-claim.
4. **Uniform gap:** `[Nonempty K]` is semantically load-bearing. On `Empty`, every gap function admits a positive uniform lower bound vacuously.
5. **Seesaw:** general invertibility suffices for the Schur-complement formula under two-sided elimination, but not for a symmetry-preserving Majorana interpretation. A concrete invertible nonsymmetric `MR` yields a nonsymmetric light block; symmetry of the inverse repairs the shape.

Verification:
- Full project build succeeds.
- No `sorry`, `native_decide`, new axioms, or `@[implemented_by]` occur.
- Every witness theorem reports only `propext`, `Classical.choice`, and `Quot.sound`.
