# codex Cayley Hamiltonian generator, 2026-07-09 15:08

aristotle:
  project_id: e8a43f64-23aa-4c84-b201-803a9afea9e4
  target_file: PhysicsSM/Draft/NullEdge/CayleyHamiltonianGenerator.lean
  expected_module: PhysicsSM.Draft.NullEdge.CayleyHamiltonianGenerator
  submission_project: AgentTasks/aristotle-submit/codex-cayley-hamiltonian-generator-focused-1508-20260709-project
  output_dir: AgentTasks/aristotle-output/e8a43f64-23aa-4c84-b201-803a9afea9e4
  status: submitted focused package 2026-07-09 15:12 PDT

You are Aristotle. Close a genuine part of the finite Hamiltonian-generator
boundary by deriving an exact unitary transfer step from a finite Hermitian
generator through the Cayley/Crank-Nicolson equation.

Target:

```text
PhysicsSM/Draft/NullEdge/CayleyHamiltonianGenerator.lean
```

Imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.ContinuumLimit
import PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow
import PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction
import PhysicsSM.Draft.NullEdge.FiniteHamiltonianGeneratorCapstone
```

Context pack:

```text
AgentTasks/context-packs/cayley-hamiltonian-generator-20260709-150756.md
```

## Generic finite theorem

For a finite complex matrix `H` and real step `dt`, define

```text
A = I + i*(dt/2)*H
B = I - i*(dt/2)*H
CayleyStep = A^{-1} B.
```

Prove the strongest clean theorem supported by the pinned Matrix API:

1. If `H` is Hermitian and `A`/`B` are invertible (or with the minimal exact
   hypotheses needed by `Matrix.inv`), then `CayleyStep` is unitary.
2. Prove the exact cleared-denominator Crank-Nicolson equivalence:

```text
psi' = CayleyStep H dt * psi
<->
i*(psi' - psi) = (dt/2) * H*(psi' + psi),
```

   under the same invertibility hypotheses. State this with `mulVec` and vector
   scalar actions precisely.
3. Deduce exact norm preservation for the finite step and its iterates, reusing
   the local finite-unitary infrastructure if helpful.
4. Show the small-step derivative of `dt |-> CayleyStep H dt` at zero is
   `-i H`, if tractable. This connects the transfer step to the same generator
   as the existing exponential flow without identifying an arbitrary mass form
   as a Hamiltonian.

If proving generic invertibility from Hermiticity alone requires an unavailable
spectral API, keep invertibility explicit in the generic theorem and discharge
it in the exact witness below. Do not hide it.

## Mandatory exact turn witness

Use `ContinuumLimit.sigma_x` as a two-level Hermitian generator and `dt=2`.
Prove by exact complex arithmetic:

```text
(I + i sigma_x)^{-1} = (1/2)(I - i sigma_x)
CayleyStep sigma_x 2 = -i sigma_x
```

and therefore the step maps basis state `e0` to `-i e1`. Prove the transition
amplitude is nonzero, the step is unitary, and the Crank-Nicolson equation holds
for this explicit transfer. This is a real generator-to-turn mechanism, not an
existential wrapper.

If convenient, also specialize to the carrier mass block
`MassGapWitness.B lam kappa` under displayed assumptions, but the exact Pauli
witness is mandatory and must remain easy to cite.

Preferred names:

```lean
cayleyA
cayleyB
cayleyStep
cayleyStep_unitary
cayleyStep_iff_crankNicolson
cayleyStep_norm_conserved
cayleyStep_orbit_norm_conserved
cayleyStep_hasDerivAt_generator
sigmax_cayley_inverse
sigmax_cayley_step
sigmax_cayley_turns_basis
cayley_hamiltonian_generator_verdict
```

## Boundary and references

This theorem derives a finite unitary **discretization** from a chosen Hermitian
generator. It does not derive which full null-edge operator is the physical
Hamiltonian, a preferred time coordinate, a continuum Schrödinger equation, or
the Standard Model Higgs/Yukawa sector.

SciLean and PhysLean finite dynamics/variational patterns were consulted as
clean-room references only and must not be imported. Use the local pinned
conventions. Add in-file guard pins for every headline and run the narrow target
before returning.

## Submission note

Two full-repository upload attempts failed before project creation, first with
an HTTP read disconnect and then `SSLV3_ALERT_BAD_RECORD_MAC`. Fleet inspection
showed no duplicate. Codex therefore extracted a Mathlib-only, typechecked
standalone target at
`AgentTasks/aristotle-standalone/cayley-hamiltonian-generator-20260709/` and
submitted that focused package successfully. The returned proofs will be ported
to the project imports and guard-pinned locally.
