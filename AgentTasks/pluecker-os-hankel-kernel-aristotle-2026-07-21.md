# Aristotle task: Pluecker exponential reflection kernel

## Objective

Prove the focused Lean targets in
`PlueckerOSHankelKernel.lean`.  The mathematical purpose is to connect a
selected positive-energy Pluecker transfer mode with the finite
Osterwalder--Schrader Hankel positivity test:

`K(i,j) = exp(-a |z| (i+j))`.

The proof must also retain the explicit nonzero null vector at two times.  This
prevents a rank-one one-mode reconstruction from being misread as strict
positive-definiteness, an interacting transfer gap, or a full field-theory
reconstruction.

## Required semantic reading

- Positive result: the single selected decaying mode supplies a finite
  reflection-positive Hankel kernel and one positive spectral atom.
- Boundary: the kernel is rank one for two or more time samples, so this alone
  does not produce an interacting Hilbert space, a vacuum-plus-excitation
  spectrum, infinite volume, or LSZ.
- The positive-energy selection is external to this focused file.  In the live
  repository it is supplied by
  `PlueckerPositiveEnergyTransfer.pluecker_positive_mode_chain`; the negative
  Pluecker eigenline grows under Euclidean transfer and must not be folded into
  this positive kernel.

## Sources and context

- M. Luescher, *Construction of a selfadjoint, strictly positive transfer
  matrix for Euclidean lattice gauge theories*, CMP 54 (1977),
  DOI 10.1007/BF01614090.
- K. Osterwalder and E. Seiler, *Gauge Field Theories on a Lattice*, Annals of
  Physics 110 (1978), DOI 10.1016/0003-4916(78)90039-8.
- K. Usui, *A Note on Reflection Positivity and the
  Umezawa-Kamefuchi-Kallen-Lehmann Representation of Two Point Correlation
  Functions*, arXiv:1201.3415.  Usui's Hermiticity, translation invariance,
  reflection positivity, and boundedness assumptions are deliberately not
  replaced by generic matrix positivity here.
- Semantic context pack:
  `AgentTasks/context-packs/pluecker-os-hankel-kernel-20260721-20260721-040418.md`.

## Verification

Run the narrow target first:

```text
lake env lean PlueckerOSHankelKernel.lean
```

Do not weaken theorem statements.  Helper lemmas are welcome.  Return the
completed source even if a later package-wide build stalls.

## Aristotle metadata

```yaml
aristotle:
  project_id: de164bed-3ccc-4934-8263-6e511988015e
  task_id: db5911a3-266e-4da3-9594-7cb797601c0f
  target_file: PhysicsSM/Draft/NullEdge/PlueckerOSHankelKernel.lean
  expected_module: PhysicsSM.Draft.NullEdge.PlueckerOSHankelKernel
  submission_project: AgentTasks/aristotle-submit/pluecker-os-hankel-kernel-20260721
  output_dir: AgentTasks/aristotle-output/de164bed-3ccc-4934-8263-6e511988015e
  status: integrated
```

## Integration result

The returned proof landed at
`PhysicsSM/Draft/NullEdge/PlueckerOSHankelKernel.lean`. It proves the exact
outer-product identity, square quadratic form, positive semidefiniteness,
strict Pluecker decay at nonzero gap and positive spacing, the explicit
nonzero two-time null vector, and the `3-4-5` witness.

The null vector is part of the accepted result: the one-mode kernel is rank one
and must not be described as a strictly positive interacting reconstruction.

Verification:

- `lake env lean PhysicsSM/Draft/NullEdge/PlueckerOSHankelKernel.lean`
- `lake build PhysicsSM.Draft.NullEdge.OriginMassAxiomGuard`

Both passed under the pinned toolchain; the guarded declarations have only the
standard `propext`, `Classical.choice`, and `Quot.sound` footprint.
