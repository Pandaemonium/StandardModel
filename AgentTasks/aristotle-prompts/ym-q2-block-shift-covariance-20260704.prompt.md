# Aristotle proof/design job: Q2 block-matrix shift covariance

You are acting as a Lean 4 proof/design agent for a draft Yang-Mills
formalization.  The target is the next Q2/Q3 bridge after
`TransferHilbertBlock.lean`: connect the concrete reflection-positive block
matrix to the existing center-shift/electric-sector API.

Formatting: ASCII only, LF line endings.  In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Context

The focused package includes:

```text
PhysicsSM/Draft/NullEdge/GateYM/CenterFluxSector.lean
PhysicsSM/Draft/NullEdge/GateYM/HermitianFromRealQuadraticForm.lean
PhysicsSM/Draft/NullEdge/GateYM/ReflectionPositivityKernel.lean
PhysicsSM/Draft/NullEdge/GateYM/TransferHilbert.lean
PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertBlock.lean
```

Important existing APIs:

- `CenterFluxSector.ShiftSystem Config Shift`
- `ShiftSystem.KernelInvariantUnderShifts`
- `TransferHilbert.KernelCommutesShifts`
- `TransferHilbert.kernelCommutesShifts_iff`
- `TransferHilbert.shiftOp_preserves_rpHilbertSpace`
- `TransferHilbertBlock.rpBlockMatrix`
- `TransferHilbertBlock.rpBlockMatrix_posSemidef_of_reflectionPositive`

Semantic preflight context pack:

```text
AgentTasks/context-packs/ym-q2-block-shift-covariance-20260704-143656.md
```

Use it as context only; verify everything against the Lean files.

## Candidate Target

Create a new file if appropriate:

```text
PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertBlockShift.lean
```

Suggested definitions/theorems:

```lean
namespace PhysicsSM.Draft.NullEdge.GateYM.TransferHilbertBlockShift

open CenterFluxSector TransferHilbert TransferHilbertBlock

def blockShiftSystem
    (SC : ShiftSystem C Shift) (SA : ShiftSystem A Shift) :
    ShiftSystem (C x A) Shift := ...

def BlockWeightInvariantUnderShifts
    (SC : ShiftSystem C Shift) (SA : ShiftSystem A Shift)
    (W : A -> C -> A -> Complex) : Prop :=
  forall z a c b,
    W (SA.shiftConfig z a) (SC.shiftConfig z c) (SA.shiftConfig z b)
      = W a c b

theorem rpBlockMatrix_kernelInvariantUnderBlockShifts
    [DecidableEq C] ...
    (hW : BlockWeightInvariantUnderShifts SC SA W) :
    ShiftSystem.KernelInvariantUnderShifts
      (blockShiftSystem SC SA)
      (fun x y => rpBlockMatrix W x y) := ...

theorem rpBlockMatrix_commutes_blockShifts
    [DecidableEq C] [DecidableEq A] ...
    (hW : BlockWeightInvariantUnderShifts SC SA W) :
    TransferHilbert.KernelCommutesShifts
      (blockShiftSystem SC SA) (rpBlockMatrix W) := ...

theorem shiftOp_preserves_rpHilbertSpace_rpBlockMatrix
    [DecidableEq C] [DecidableEq A] ...
    (hW : BlockWeightInvariantUnderShifts SC SA W) (z : Shift) :
    forall v in TransferHilbert.rpHilbertSpace (rpBlockMatrix W),
      TransferHilbert.shiftOp (blockShiftSystem SC SA) z v
        in TransferHilbert.rpHilbertSpace (rpBlockMatrix W) := ...
```

You may adjust names or hypotheses if Lean/mathlib requires it, but do not
weaken the mathematical content silently.  The intended content is:

1. the product shift acts on block indices `(c, a)` by shifting the cut
   coordinate and positive/mirror coordinate simultaneously;
2. if the reflection-positive weight `W a c b` is invariant under simultaneous
   shifts of all three coordinates, then the block matrix is invariant under
   simultaneous shifts of row and column;
3. therefore the generic `TransferHilbert` shift-covariance theorem applies to
   `rpHilbertSpace (rpBlockMatrix W)`.

## Scope Boundary

This is still finite algebraic Q2/Q3 infrastructure.  Do not claim:

- a physical transfer matrix;
- a Hamiltonian;
- a spectral gap;
- concrete torus/Z2 center-shift invariance of the Wilson transfer matrix.

The result should be an abstract bridge theorem that the concrete torus/Z2
layer can instantiate later.

## Output Format

Preferred:

1. A Lean file `TransferHilbertBlockShift.lean` with the target bridge proved.
2. Exact check command, ideally:
   `lake env lean PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertBlockShift.lean`
3. Any helper lemmas and a short explanation of index order / invariance
   direction.

Acceptable negative/design output:

1. Explain why the candidate theorem is malformed.
2. Give the corrected theorem surface with exact hypotheses.
3. Include any partial Lean that typechecks.

Do not alter the already integrated public statements in `TransferHilbert.lean`
or `TransferHilbertBlock.lean` unless you find a real semantic bug and explain
it clearly.
