Formalize the OSTERWALDER-SCHRADER / GNS RECONSTRUCTION step on the finite
connected Wilson slab: from a reflection-POSITIVE kernel to a self-adjoint
transfer operator on a genuine Hilbert space with a spectral gap ABOVE the
vacuum. This is the Euclidean->Minkowski step that the recent RP construction of
4D SU(N) YM (arXiv 2606.19362) performs ("the Osterwalder-Schrader reconstruction
turns these Euclidean facts into a Minkowski theory with a self-adjoint
Hamiltonian, the spectral gap lying above the vacuum"), specialized to the
project's finite slab.

Create a NEW module `PhysicsSM/Draft/NullEdge/GateYM/OSReconstruction.lean`.
Check with `lake env lean`. If broader `lake build` stalls, SKIP.

## Build on the existing tree (reuse, do not redefine)

`ReflectionPositivityKernel.IsReflectionPositive`, `rpBlockMatrix` +
`rpBlockMatrix_posSemidef_of_reflectionPositive` (`TransferHilbertBlock`),
`TransferHilbert*` (the transfer-Hilbert-space bookkeeping),
`WilsonSlabConnected.wilsonSlabConnected_reflectionPositive`,
`SlabTransferGap.slabTransferBlock` (+ PSD/Hermitian) and its Z2 center-sector
gap. Mathlib: `Matrix.PosSemidef`, inner-product spaces, self-adjoint operators,
`LinearMap.IsSymmetric`, spectral theory of finite Hermitian matrices.

## Deliverables (in dependency order; prove as far as you get, freeze the rest)

1. **GNS quotient.** From the PSD `rpBlockMatrix` (a finite PSD Gram matrix),
   build the finite-dim inner-product space = (config space) / (null space of the
   RP form), with the RP form inducing a genuine inner product on the quotient.
2. **Self-adjoint transfer operator.** The reflection/time-translation induces a
   SELF-ADJOINT (symmetric) operator `T` on that GNS space (from
   `slabTransferBlock`'s Hermitian PSD structure); state
   `osTransfer_isSelfAdjoint` + `osTransfer_posSemidef`.
3. **Hamiltonian + spectral gap.** Define `H = -log T` on the positive spectrum
   (or work with `T` directly), and state the spectral gap above the vacuum:
   the top eigenvalue (vacuum) is simple/separated from the rest, giving
   `0 < gap`. Tie it to the NE-U4 sector gap `SlabTransferGap.neU4_closure_gap_pos`
   on the Z2 instance (`gap = -log(second/top eigenvalue ratio)`).

## Constraints

- Do NOT claim a physical/continuum mass gap - this is the finite-slab OS
  reconstruction (a self-adjoint transfer operator with a finite spectral gap on
  a concrete RP ensemble), the honest Osterwalder-Seiler-regime statement.
  F-YM-CONFLATE; continuum out.
- No new `a x i o m`, `n a t i v e _ d e c i d e`, weakening. Prove the GNS +
  self-adjointness genuinely; the log-Hamiltonian / gap step may be a documented
  handoff `s o r r y` if heavy, provided the self-adjoint transfer operator + PSD
  are proved. Standard axioms. If `lake build` stalls, SKIP; return source + DAG.
