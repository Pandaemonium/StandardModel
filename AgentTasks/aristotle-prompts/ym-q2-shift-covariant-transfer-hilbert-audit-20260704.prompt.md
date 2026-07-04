# Aristotle audit job: Q2 shift-covariant transfer Hilbert statement

You are acting as a Lean/math formalization strategist for a finite
Osterwalder-Seiler / GNS-style transfer-Hilbert construction.  A small Lean
artifact is welcome, but the primary deliverable is an exact statement design
and lemma DAG.

Formatting: ASCII only, LF line endings.  In prose, spell Lean escape-hatch
tokens with spaces (`s o r r y`, `a x i o m`, `a d m i t`).

## Project context

This Lean 4 / Mathlib repository is formalizing finite lattice gauge theory
building blocks for a Yang-Mills ladder.  The relevant draft modules are under
`PhysicsSM/Draft/NullEdge/GateYM/`.

Q2 goal: from finite reflection positivity, build the finite OS/GNS transfer
Hilbert-space layer and make it compatible with the Q3 electric/center-shift
sector decomposition.

Already integrated:

1. `ReflectionPositivityKernel.lean` defines
   `IsReflectionPositive W`, `reflectionForm W f`, `cutKernel W c`, and proves
   `reflectionForm_nonneg` from per-cut PSD kernels.
2. Aristotle project `72cccd22` delivered and the repo integrated the converse:

   ```lean
   theorem cutKernel_posSemidef_of_reflectionPositive [DecidableEq C]
       (W : A -> C -> A -> Complex) (hW : IsReflectionPositive W) (c : C) :
       (cutKernel W c).PosSemidef
   ```

   Thus the Hermitian/polarization bridge is closed: public Q2 can use
   `IsReflectionPositive W`, not a stronger per-cut PSD hypothesis.
3. `CenterFluxSector.lean` defines an abstract finite shift system:

   ```lean
   structure ShiftSystem (Config Shift : Type*) where
     shift : Shift -> Equiv.Perm Config

   def ShiftSystem.InElectricSector
       (S : ShiftSystem Config Shift)
       (character : Shift -> Complex) (psi : Config -> Complex) : Prop :=
     forall z x, psi (S.shiftConfig z x) = character z * psi x

   def ShiftSystem.KernelInvariantUnderShifts
       (S : ShiftSystem Config Shift)
       (K : Config -> Config -> Complex) : Prop :=
     forall z x y, K (S.shiftConfig z x) (S.shiftConfig z y) = K x y

   theorem ShiftSystem.inElectricSector_applyKernel ...
   ```

4. `FluxSectorZ2.lean` gives a concrete Z2 electric-sector API:

   ```lean
   def ElectricKernelInvariant (hLx : 0 < Lx) (hLy : 0 < Ly)
       (K : TorusLinkField Lx Ly -> TorusLinkField Lx Ly -> Complex) : Prop :=
     (forall U V, K (xShift (baseX hLx) U) (xShift (baseX hLx) V) = K U V) /\
     (forall U V, K (yShift (baseY hLy) U) (yShift (baseY hLy) V) = K U V)

   theorem inElectricFluxSector_applyElectricTransfer ...
   theorem trivialElectricFlux_applyElectricTransfer ...
   ```

Q3 is therefore ready to consume a Q2 transfer kernel/operator that commutes
with center shifts.  What is missing is the Q2 statement file:
`TransferHilbert.lean`.

## Current design decision

The accepted Q2 design before the Hermitian bridge returned:

- define `reflectionPairing W f g` with the first argument in the antilinear
  slot and diagonal equal to `reflectionForm W f`;
- use the finite matrix route, not quotient plumbing:
  the OS space is `range (CFC.sqrt K)` for the block matrix/direct sum of cut
  kernels;
- define an abstract compressed transfer operator from an ambient finite matrix
  or linear map `T`;
- prove compressed transfer self-adjointness/PSD under finite matrix
  hypotheses;
- do not claim a physical Hamiltonian or continuum Hilbert space.

The day-1 strategy audit then added an essential missing requirement:
Q2's transfer-Hilbert statement must include center-shift covariance so Q3's
electric sectors survive the OS/GNS construction.  The earlier `72cccd22` job
did NOT cover this; it only covered the Hermitian/polarization bridge.

## Questions

1. What is the right abstract Lean interface for shift covariance at Q2?
   Should `TransferHilbert.lean` be abstract over:
   - a finite configuration/index type `I`,
   - a `ShiftSystem I Shift`,
   - a PSD kernel/matrix `K : Matrix I I Complex` or `K : I -> I -> Complex`,
   - an ambient transfer matrix/operator `T`,
   - hypotheses that both `K` and `T` commute with the shift permutations?

2. How should the finite OS space `range (CFC.sqrt K)` carry the center-shift
   action?  The likely route is:
   - define the permutation/unitary operator `U_z` on the ambient function space;
   - prove `U_z` commutes with `K`;
   - infer `U_z` commutes with `CFC.sqrt K` (is this easy in Mathlib? does it
     need a functional-calculus commutation lemma, or should the first statement
     expose preservation of `range (CFC.sqrt K)` as an explicit hypothesis?);
   - restrict `U_z` to the range;
   - prove compressed transfer commutes with restricted shifts if ambient `T`
     commutes with shifts and preserves the range.

   Please tell us whether this is a tractable proof package now or whether the
   first statement freeze should keep range-preservation / commutation as
   hypotheses.

3. How should this interface connect to `CenterFluxSector.ShiftSystem` and the
   concrete `FluxSectorZ2.ElectricKernelInvariant` theorem?  Should Q2 reuse
   `ShiftSystem.KernelInvariantUnderShifts` directly, or define a matrix-level
   commutation predicate and then prove a bridge to the function-kernel API?

4. What are the exact theorem names and statement shapes to freeze?  Candidate
   names:

   ```lean
   reflectionPairing
   rpBlockMatrix
   rpHilbertSpace
   shiftOp
   shiftOp_preserves_rpHilbertSpace
   compressedTransfer
   compressedTransfer_isSelfAdjoint
   compressedTransfer_posSemidef
   compressedTransfer_commutes_shift
   compressedTransfer_preserves_electricSector
   ```

   Please revise this list.  Include which statements should be proved now and
   which should be documented handoffs.

5. Are there Mathlib APIs we should use or avoid?  In particular:
   - `Matrix.PosSemidef.sqrt`/`CFC.sqrt`;
   - `LinearMap.range`;
   - matrices vs `Module.End`;
   - commutation with functional calculus / square roots;
   - finite-dimensional submodules and restricted operators.

6. What sanity checks or counterexamples should we run before freezing the file?
   For example: if `T` does not commute with shifts, electric sectors should not
   be preserved; if `K` commutes but `T` does not preserve the sqrt range, the
   compressed operator may not be well-defined.

## Output format

1. Verdict: statement-freeze route accepted / accepted with changes / redesign.
2. Exact Lean-facing API proposal, with theorem names and statement sketches.
3. Which hypotheses are public vs internal proof obligations.
4. Mathlib API notes, especially for `CFC.sqrt` commutation.
5. Minimal next proof package: what to prove first after the statement file.
6. How the Q2 file should state its scope so it does not overclaim a physical
   Hilbert space, Hamiltonian, or spectral gap.

## Guardrails

Do not claim the existence of a physical transfer matrix, Hamiltonian, or
continuum Hilbert space.  Keep this finite and algebraic.  Do not silently drop
the center-shift covariance condition: Q3 depends on it.  If `CFC.sqrt`
commutation is too hard for the first proof package, recommend an honest
hypothesis rather than pretending it is automatic.
