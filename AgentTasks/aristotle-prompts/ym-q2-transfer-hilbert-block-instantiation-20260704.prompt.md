# Aristotle proof job: Q2 transfer-Hilbert block instantiation

You are acting as a Lean formalization partner.  Please produce a Lean patch,
not only an audit, for a new file:

`PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertBlock.lean`

Formatting: ASCII only, LF line endings.  In prose, spell Lean escape-hatch
tokens with spaces (`s o r r y`, `a x i o m`, `a d m i t`, `o p a q u e`).

## Project context

This is Q2 of a four-day Yang-Mills / mass-gap run.  The generic finite
OS/GNS transfer-Hilbert statement layer has just landed in
`TransferHilbert.lean`:

- `reflectionPairing (K : Matrix I I C) (f g : I -> C) : C`
- `rpHilbertSpace K = range (CFC.sqrt K)`
- `KernelCommutesShifts`, `kernelCommutesShifts_iff`
- shift/`CFC.sqrt` commutation and OS range preservation
- OS-form transfer symmetry/positivity
- auxiliary `compressedTransfer` facts

`ReflectionPositivityKernel.lean` supplies the RP kernel API:

```lean
def reflectionForm (W : A -> C -> A -> Complex) (f : A -> C -> Complex) : Complex
def cutKernel (W : A -> C -> A -> Complex) (c : C) : Matrix A A Complex
def IsReflectionPositive (W : A -> C -> A -> Complex) : Prop

theorem cutKernel_posSemidef_of_reflectionPositive [DecidableEq C]
    (W : A -> C -> A -> Complex) (hW : IsReflectionPositive W) (c : C) :
    (cutKernel W c).PosSemidef
```

The next Q2 blocker is to instantiate the generic matrix layer from the
family of cut kernels.  Keep this finite and algebraic.  Do not claim a
physical transfer matrix, Hamiltonian, continuum Hilbert space, or spectral
gap.

## Target command

Please make this command pass:

```bash
lake env lean PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertBlock.lean
```

Do not start with a full project build.

## Desired API

Use an index type equivalent to `C x A` (or `A x C` if it makes proofs cleaner,
but document the choice).  The preferred names are:

```lean
def rpBlockMatrix (W : A -> C -> A -> Complex) : Matrix (C x A) (C x A) Complex

theorem rpBlockMatrix_sameCut ...
theorem rpBlockMatrix_neCut ...

theorem rpBlockMatrix_posSemidef_of_reflectionPositive
    [DecidableEq C] (W : A -> C -> A -> Complex)
    (hW : IsReflectionPositive W) :
    (rpBlockMatrix W).PosSemidef

def reflectionPairingVec (f : A -> C -> Complex) : C x A -> Complex

theorem reflectionPairing_rpBlockMatrix_eq_reflectionForm
    (W : A -> C -> A -> Complex) (f : A -> C -> Complex) :
    TransferHilbert.reflectionPairing (rpBlockMatrix W)
      (reflectionPairingVec f) (reflectionPairingVec f)
      = reflectionForm W f

theorem rpHilbertSpace_of_reflectionPositive ...
```

If the exact theorem names need adjustment, preserve the intent and explain the
changes in `ARISTOTLE_SUMMARY.md`.

## Proof guidance

- `rpBlockMatrix` should be block diagonal in the cut coordinate.  Inside each
  `c` block it should agree with `cutKernel W c`.
- The PSD theorem should use
  `cutKernel_posSemidef_of_reflectionPositive W hW c` on each block, then prove
  the direct-sum/block-diagonal matrix is PSD.  If Mathlib has a block-diagonal
  matrix API, use it; otherwise prove the quadratic-form decomposition by
  expanding the dot product and summing over `c`.
- The pairing bridge should expand `TransferHilbert.reflectionPairing`,
  `ReflectionPositivityKernel.reflectionForm`, and the block matrix.  Be
  careful about row/column order: `cutKernel W c` is `Matrix.of fun b a =>
  W a c b`, so the block matrix rows should correspond to the mirrored
  negative side.
- If a fully general PSD proof is too large, return a smaller proved lemma DAG
  and leave only a documented draft theorem in the new file.  Do not weaken the
  semantic statement silently.

## Success criteria

- The target file builds.
- No executable proof placeholders in the final returned file if feasible.
  If a hard theorem remains parked, include a precise proof handoff comment and
  explain why.
- No new `a x i o m`, `o p a q u e`, or u n s a f e code.
- Do not edit unrelated reflection/T1 files.
- Return `ARISTOTLE_SUMMARY.md` with theorem names, proof strategy, dependency
  footprint, and remaining blockers.

This is a finite draft GateYM statement/proof package, not a physical
mass-gap claim.
