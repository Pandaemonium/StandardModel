# SL2 reduced mass reciprocity Aristotle task

## Objective

Prove the exact two-by-two determinant identity underlying spectral pairing in
the doubled-Weyl massive HNU walk.  The target is isolated to Mathlib so proof
search is spent on finite algebra rather than the full PhysicsSM build.

## Mathematical route

Expand the `Fin 2` determinant, matrix product, scalar actions, and trace.
Use `det U = det V = 1` and `trace U = trace V`; the remaining identity is
commutative polynomial algebra after clearing the nonzero `lambda` denominator.
Small helper lemmas are welcome, but preserve both statements exactly.

## Local resolution while the remote audit runs

The target was solved locally and then strengthened.  Entrywise determinant
expansion shows that the equal-trace hypothesis is unnecessary: `det U = 1`
and `det V = 1` alone force reciprocity.  The strengthened theorem and its root
corollary are now integrated in
`PhysicsSM/Draft/NullEdge/HNUMassiveSpectralReciprocity.lean`, together with the
specialized live-HNU characteristic-root theorem.  The remote Aristotle job is
being left in flight as an independent proof and statement audit.

## Harvest

The remote task returned `COMPLETE_WITH_ERRORS`, but its target file was
downloadable, contained no proof holes, preserved both submitted signatures,
and passed a direct pinned-toolchain Lean check.  Its independent proof used the
submitted equal-trace hypothesis.  It was not copied over the stronger local
version, which shows that hypothesis is redundant.  The artifact remains under
`AgentTasks/aristotle-output/cd0e99b3-fea6-4040-bed7-177530eb2736/` for audit.

## Physics use and boundary

The live HNU shifted-determinant reduction has the same two-by-two expression
when the spectral parameter is generalized from `+1/-1` to arbitrary
`lambda`.  This generic theorem would make reciprocal root pairing an algebraic
consequence of determinant-one opposite-chirality blocks with equal trace.

It does not by itself prove the generalized HNU determinant reduction,
unit-circle spectral pairing, Cayley-sign inertia, physical-sector selection,
or companion removal.

## Verification request

Semantic context pack:
`AgentTasks/context-packs/sl2-reduced-mass-reciprocity-20260721-20260721-154650.md`.

Run the narrow target first:

```text
lake env lean SL2ReducedMassReciprocity/Main.lean
```

Return solved targets, any helper declarations, statement changes, and the
exact remaining blocker if the determinant normalization is mismatched.

## Aristotle metadata

```yaml
aristotle:
  project_id: cd0e99b3-fea6-4040-bed7-177530eb2736
  task_id: a958b464-bfa1-4a18-83c0-bad456d82af8
  target_file: AgentTasks/aristotle-standalone/sl2-reduced-mass-reciprocity-20260721/SL2ReducedMassReciprocity/Main.lean
  expected_module: SL2ReducedMassReciprocity.Main
  submission_project: AgentTasks/aristotle-submit/sl2-reduced-mass-reciprocity-20260721-project
  output_dir: AgentTasks/aristotle-output/cd0e99b3-fea6-4040-bed7-177530eb2736
  status: harvested
```
