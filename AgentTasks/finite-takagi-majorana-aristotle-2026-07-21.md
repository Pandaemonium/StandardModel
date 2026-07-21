# Aristotle task: finite Autonne-Takagi factorization

Date: 2026-07-21
Owner: Codex
Work item: `MASS-ORIGIN-001`
Status: partial return integrated; full existence blocker retained

## Objective

Prove a convention-locked finite Autonne-Takagi factorization for every complex
symmetric `Fin n` matrix:

`A = U * diagonal(sigma) * U.transpose`,

with `U` unitary and every real `sigma i >= 0`. Zero and repeated singular
values must be admitted. Also prove the displayed squared-mass identity for
`A^H A` from a factorization witness.

## Semantic boundary

This theorem classifies the nonnegative physical mass parameters of a supplied
finite complex symmetric matrix. It does not derive the matrix, flavor data,
absolute scales, a continuum propagator, or a pole mass. Do not replace Takagi
unitary congruence with ordinary similarity diagonalization.

If the full theorem is blocked by Mathlib API, preserve the exact statement and
return the strongest helper lemmas plus the precise missing phase-pairing or
degeneracy lemma. Do not add a simple-spectrum, invertibility, or nonzero-mass
hypothesis merely to close the proof.

## Sources and Lean references

- Dieci, Papini, Pugliese, arXiv:2110.15918; Zotero `AX8PHHAI`.
- Borisov and Isaev, arXiv:2312.17714, Appendix C; Zotero `I9NUBC9A`.
- Horn and Zhang, DOI `10.1080/03081087.2011.618838`.
- `LinearMap.singularValues_fin`, `LinearMap.singularValues_nonneg`.
- `Matrix.IsHermitian.conjStarAlgAut_star_eigenvectorUnitary`.
- Context pack:
  `AgentTasks/context-packs/finite-takagi-majorana-20260721-044215.md`.

Run `lake env lean FiniteTakagiMajorana.lean` first. Return the current source
even if a later package build stalls.

## Progress audit

The in-progress snapshot proves the Hermitian spectral-basis step, a conditional
phase-paired Takagi assembly theorem, the corrected squared-mass identity, and
an exact `2 x 2` counterexample to the originally requested identity. The bad
statement used `star U = U^H` where Takagi substitution requires the entrywise
conjugate `U.transpose\u1d34`. Aristotle has been instructed to stop pursuing the
false statement, preserve the corrected theorem and counterexample, and spend
the remaining search only on the full phase-compatible basis construction.

The full existence theorem remains open in this snapshot. Its exact blocker is
the basis-and-phase choice in zero or repeated singular-value eigenspaces, not
the positive Hermitian spectral theorem.

## Integration result

The final return left the full `exists_autonneTakagi` target unresolved. The
hole-bearing file was therefore not copied into the live tree. Instead, its
four complete results were integrated as
`PhysicsSM/Draft/NullEdge/FiniteTakagiMajoranaPartial.lean` and pinned in
`OriginMassAxiomGuard.lean`:

- arbitrary finite squared-singular-basis existence;
- Takagi assembly from an explicit phase-paired basis;
- the correctly oriented squared-mass identity; and
- the exact `2 x 2` counterexample to the false `star U` identity.

Both the module and aggregate guard passed `lake env lean` under the pinned
toolchain. The remaining arbitrary-generation existence theorem is still the
phase-compatible basis construction in zero and repeated singular-value
subspaces.

```yaml
aristotle:
  project_id: 748c3102-79aa-4d7e-abec-a733b3c73b33
  task_id: 6e1d0e02-d137-4e94-a873-d281c7bb5798
  target_file: PhysicsSM/Draft/NullEdge/FiniteTakagiMajoranaPartial.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteTakagiMajoranaPartial
  submission_project: AgentTasks/aristotle-submit/finite-takagi-majorana-20260721
  output_dir: AgentTasks/aristotle-output/748c3102-79aa-4d7e-abec-a733b3c73b33
  status: integrated-partial
```
