# Collaborator Onboarding

This document is a first-pass onboarding guide for a new collaborator entering
the null-edge / NullStrand project through the standalone package.

It is written for someone who may be strong in physics, Lean, lattice field
theory, causal sets, quantum information, or mathematical physics, but who has
not yet learned this project's internal guardrails. It is not a replacement for
the theorem files. The Lean kernel is the source of truth; this guide explains
what the project is trying to do, where the checked core is, and where the open
problems begin.

## 0. The One-Sentence Project

The null-edge program studies finite algebraic models of relativistic transport
whose primitive support is causal/null edge motion, then asks which pieces of
mass, chirality, gauge transport, and eventually gravity can be reconstructed
from that finite null-causal structure.

The current package is not a completed physical theory. It is a finite Lean
package containing:

- checked algebraic identities;
- checked obstruction/no-go statements;
- draft-facing but kernel-checked scaffolds;
- docs that keep the physical interpretation separated from what has actually
  been proved.

## 1. Reading Stance

Please read every claim with one of these labels in mind:

- **finite identity**: an exact finite algebra theorem proved in Lean;
- **structural theorem**: a finite theorem expressing an obstruction or
  compatibility condition;
- **reconstruction**: a bridge between two finite descriptions or conventions;
- **conditional schema**: a typed API saying what a future construction would
  have to provide;
- **analytic scaffold**: a statement or finite lemma preparing for a continuum
  limit, without proving that limit;
- **conjecture**: a research target, not a result;
- **physics motivation**: an interpretation or source-derived analogy, not a
  Lean theorem.

The project's credibility depends on never letting these labels blur.

## 2. What Is Actually Solid

The load-bearing spine, as of 2026-07-02, is:

1. **Finite Pluecker mass.**
   A finite family of complex two-spinors defines a positive Hermitian momentum
   matrix

   ```text
   P = sum_i psi_i psi_i^dagger.
   ```

   The determinant of `P` equals the total pairwise squared wedge spread. The
   massless locus is the common-projective-direction locus under the stated
   nonzero-base hypothesis. This is finite kinematics, not a mass-spectrum
   prediction.

2. **1+1D checkerboard seed.**
   The checkerboard transfer matrix has a null-preserving channel and a
   direction-reversal channel. The mass parameter is exactly the reversal
   amplitude. Matrix powers expand as finite endpoint-constrained path sums,
   grouped by turn count, with isotropic unitarity and a growing continuum
   scaffold.

3. **Dual-soldered null-edge operator algebra.**
   The primitive edge direction `ell_a` and the Clifford soldering covector
   `alpha^a` are distinct. The active operator architecture is

   ```text
   D_N = sum_a c(alpha^a) nabla_a.
   ```

   The support is null; the symbol is reconstructed from the dual covectors.
   This distinction is one of the project's central ideas.

4. **Graded super-Dirac square.**
   The finite square theorem isolates the kinetic term, diamond/curvature term,
   frame/tetrad defect term, internal `+ Phi^2` term, and derivative/Higgs
   commutator term under explicit hypotheses. The sign of `Phi^2` is
   load-bearing and depends on keeping spacetime chirality separate from the
   internal grading.

5. **Frame-term / finite tetrad-postulate theorem.**
   If the finite transport preserves the Clifford frame in the precise
   commutator sense, the frame term vanishes. If it does not vanish, the defect
   must be classified rather than hidden.

6. **Krein and spectral linear-algebra scaffolds.**
   The Krein double proves a finite self-adjointness hygiene result for
   retarded/advanced doubles. The Schur and spectral modules provide exact
   finite elimination and mass-shell matching identities. These are useful, but
   they do not by themselves prove positivity, stability, or physical
   unitarity.

7. **Gate C bare-symbol no-go.**
   The flat tetrahedral/hyperdiamond bare symbol has high-momentum
   determinant-zero branches. Each nonzero null branch kernel is
   chirality-balanced. The bare symbol cannot release a single chiral physical
   branch.

8. **Hyperdiamond/fifth-vector obstruction.**
   The first-order stencil scaffold and no-four-edge/fifth-vector obstruction
   show that a true source-side hyperdiamond/Borici-Creutz pole structure needs
   data beyond a naive four-edge nearest stencil. This is a source-independent
   finite obstruction until a fully sourced convention is instantiated.

For theorem names, start with [`THEOREM_MAP.md`](THEOREM_MAP.md).

## 3. What Is Not Proved

The package does not prove:

- a released physical chiral `D_phys`;
- a complete Standard Model sector;
- anomaly cancellation;
- a continuum limit of the 3+1D null-edge operator;
- a full Hilbert-space positivity theorem;
- a numerical particle mass prediction;
- emergent Einstein gravity;
- the Born rule;
- a derivation of the tetrahedral frame from a bare causal graph.

When writing docs or papers, do not imply these are done. The project is strong
precisely where it is honest about what remains open.

## 4. The Main Mental Model

The finite picture can be organized in layers:

```text
finite causal/null support
  -> edge transports and finite difference directions ell_a
  -> dual covector soldering alpha^a
  -> finite Dirac-like operator D_N
  -> square / frame / mass-shell / Krein audits
  -> checkerboard and Pluecker mass mechanisms
  -> Gate C branch-release obstruction
  -> future physical D_phys or no-go
  -> future continuum and scheduler/gravity questions
```

The active physical reading is:

- null edges describe primitive causal channels;
- mass is an obstruction to remaining one free aligned null beam, or, in the
  1+1D checkerboard seed, a direction-reversal amplitude;
- gauge fields should eventually be synchronization/transport data on links;
- chirality is not automatic and is currently the hardest obstruction;
- gravity/scheduler ideas belong to a future coarse-grained layer, not to the
  current finite theorem core.

## 5. Fixed Lattice Versus Relativistic Scheduler

Recent discussions add an important interpretive caution. The flat periodic
tetrahedral lattice used in Gate C should be read as a synchronized chart or
diagnostic model, not automatically as the fundamental substrate.

The broader relativistic framing is:

- the fundamental object should be causal/asynchronous;
- a global clock is a gauge choice or approximation;
- physical outputs should not depend on how a causal partial order is
  serialized into time slices;
- local scheduler/lapse data should control proper-time phase accumulation,
  not serve as a species-dependent trick for removing unwanted branches.

This does not invalidate the fixed-lattice Gate C no-go. It changes its scope.
The no-go is a flat synchronized-chart obstruction for the bare symbol. A future
relativistic Gate C theorem would ask for a chiral release that is stable under
admissible serialization, frame, and scheduler choices.

Do not use the scheduler idea to wave away doubling or chirality. It makes the
required release theorem harder and more physical.

## 6. Core Conventions

The most important conventions are:

- metric signature: mostly minus, `(+---)`;
- four-dimensional tetrahedral edge convention:

  ```text
  ell_A = (1, n_A)
  alpha^A = 1/4 dt + 3/4 n_A . dx
  ```

- `ell_a` is the primitive null edge direction;
- `alpha^a` is the dual Clifford soldering covector;
- do not replace the dual-soldered operator with the diagonal null-soldering
  ansatz;
- keep `Gamma_s`, `chi_E`, form/cochain degree, and Krein symmetry `J`
  separate;
- the internal block `Phi` must commute with spacetime chirality in the
  super-Dirac square if the desired sign is `+ Phi^2`;
- retardedness rules out coefficient-zero doublers only; it does not rule out
  determinant-level null branches;
- a nonzero index is necessary but not sufficient for physical release.

See [`CONVENTIONS.md`](CONVENTIONS.md) and
[`GATE_C.md`](GATE_C.md).

## 7. Repository Map

From `NullEdgeStandalone/`:

- `NullEdgeStandalone.lean`
  imports the standalone package surface.
- `PhysicsSM/Spinor/`
  contains the Pluecker mass and twistor-chart material.
- `PhysicsSM/NullStrand/DualSolder/`
  contains trusted dual-soldered, graded square, Krein, Schur, and spectral
  modules.
- `PhysicsSM/Draft/Checkerboard*.lean`
  contains the 1+1D checkerboard path-sum and continuum scaffold.
- `PhysicsSM/Draft/NullEdge*.lean`
  contains draft-facing finite operator scaffolds and Gate C guardrails.
- `docs/`
  contains the human-facing theorem map, next theorem plan, Gate C status, and
  trust ledger.

From the full monorepo root:

- `AGENTS.md`
  is the always-on policy for agents.
- `docs/NULLSTRAND.md`
  is the living orientation note for the broader NullStrand program.
- `docs/BUILD.md`
  is the full-repo build guide.
- `docs/ARISTOTLE.md`
  is the proof-agent submission/integration guide.
- `AgentTasks/`
  records Aristotle jobs, literature logs, proof plans, and integration notes.
- `Sources/`
  contains longer research notes and program documents.

## 8. Recommended Reading Path

For a new collaborator, read in this order:

1. This document.
2. [`TRUST_AND_SCOPE.md`](TRUST_AND_SCOPE.md).
3. [`PHYSICS_CONTEXT.md`](PHYSICS_CONTEXT.md).
4. [`CONVENTIONS.md`](CONVENTIONS.md).
5. [`THEOREM_MAP.md`](THEOREM_MAP.md).
6. [`GATE_C.md`](GATE_C.md).
7. [`NEXT_THEOREMS.md`](NEXT_THEOREMS.md).
8. The relevant Lean module for the task you plan to touch.

For Gate C work, also read:

- [`GATE_C_ASSUMPTION_LEDGER.md`](GATE_C_ASSUMPTION_LEDGER.md);
- [`HYPERDIAMOND_CROSSWALK.md`](HYPERDIAMOND_CROSSWALK.md);
- [`HYPERDIAMOND_OPERATOR_SCAFFOLD.md`](HYPERDIAMOND_OPERATOR_SCAFFOLD.md);
- [`NO_FOUR_EDGE_POLE_STRUCTURE_REPORT.md`](NO_FOUR_EDGE_POLE_STRUCTURE_REPORT.md).

For checkerboard work, also read:

- [`CHECKERBOARD_1D.md`](CHECKERBOARD_1D.md);
- [`CHECKERBOARD_CONTINUUM_NEXT_REPORT.md`](CHECKERBOARD_CONTINUUM_NEXT_REPORT.md);
- [`CHECKERBOARD_CONTINUUM_QUOTIENT_ESTIMATES.md`](CHECKERBOARD_CONTINUUM_QUOTIENT_ESTIMATES.md).

## 9. Build And Verification

From `NullEdgeStandalone/`:

```powershell
lake build NullEdgeStandalone
```

For a focused file:

```powershell
lake env lean PhysicsSM/Draft/CheckerboardContinuumScaffold.lean
```

From the full repo root, follow [`../../docs/BUILD.md`](../../docs/BUILD.md).
Before claiming trusted code is complete, run the appropriate targeted checks
and a broader build. For docs-only changes, run the repo's pre-commit checks.

Never claim a command passed unless you actually ran it.

## 10. Lean Contribution Rules

Preferred workflow:

1. Read nearby definitions and theorem statements.
2. Search existing Mathlib and project declarations before inventing new APIs.
3. State the smallest useful theorem.
4. Keep definitions local and conservative.
5. Prove the theorem, or leave a documented handoff only in draft/handoff
   context.
6. Run a targeted Lean check.
7. Update docs/provenance if the change affects physical interpretation.

Do not:

- weaken theorem statements silently;
- change signs, basis order, normalization, or parenthesization to make a proof
  easier;
- move draft-facing results into trusted status without reviewing semantic
  alignment;
- add fake assumptions to make a proof pass;
- use placeholder or escape-hatch declarations in trusted code.

In prose, use spaced forms for placeholder/escape-hatch tokens, such as
`s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, `u n s a f e`, and
`n a t i v e _ d e c i d e`, so text scans stay focused on executable Lean.

## 11. Aristotle Workflow

Use Aristotle early for hard Lean proofs. The best task for Aristotle has:

- a small standalone Lean package or focused file;
- exact imports;
- exact theorem statement;
- nearby definitions;
- convention notes;
- known failed attempts or current Lean errors;
- permission to add small helper lemmas, but not to weaken the target.

After Aristotle returns:

1. Fetch and inspect the result.
2. Check that theorem statements did not drift.
3. Scan executable Lean for forbidden placeholders or escape hatches.
4. Run targeted `lake env lean`.
5. Run the broader package build when appropriate.
6. Update the task note and docs.

Full mechanics are in [`../../docs/ARISTOTLE.md`](../../docs/ARISTOTLE.md).

## 12. Current High-Value Problems

### A. Checkerboard Continuum Spine

Goal: turn the finite 1+1D checkerboard seed into a clean analytic bridge
toward the Dirac equation.

Near targets:

- normed finite matrix product bounds for the isotropic generator expansion;
- exact statement of the scaling assumptions for a continuum Dirac limit;
- reversal-clock theorem candidate: turn/reversal count as a proper-time
  observable in the scaling limit.

Claim boundary: this is currently finite algebra and analytic scaffold, not a
proved continuum theorem.

### B. Gate C Physical Release Or No-Go

Goal: decide whether a physical chiral branch can be released from the null-edge
architecture.

Near targets:

- sharper no-go theorems for bare, scalar-regulated, or taste-only release
  routes;
- concrete projected-operator data rather than free release bookkeeping;
- locality, gauge covariance, Krein positivity, and ghost-zero audits for any
  candidate `D_phys`;
- serialization/frame/scheduler covariance requirements for a relativistic
  Gate C release.

Claim boundary: the current result is a no-go for the bare symbol, not a
released chiral operator.

### C. Hyperdiamond / Borici-Creutz Crosswalk

Goal: compare the project operator data with named minimally doubled lattice
fermion conventions.

Near targets:

- instantiate source conventions exactly;
- prove a source-specific crosswalk or mismatch theorem;
- prove explicit pole/excitation data for the source full symbol;
- preserve the no-four-edge/fifth-vector obstruction.

Claim boundary: no named operator equivalence should be claimed until source
normalizations, gamma conventions, phases, shifts, and pole locations are fixed.

### D. Causal Scheduler Layer

Goal: make the computational-scheduler idea finite and testable before any
gravity claims.

Good first formal targets:

- finite causal logs or DAGs;
- linear extensions/topological sorts;
- serialization invariance of a toy update process;
- path phase accumulation with local lapse/scheduler weights;
- redshift as a ratio of accumulated proper-time ticks in a finite model;
- compatibility between scheduler changes and the null-edge operator chart.

Claim boundary: this layer is currently a research program. It does not prove
emergent general relativity.

### E. Literature And Provenance

Goal: keep every nontrivial physics claim tied to sources and conventions.

Useful source families:

- Feynman checkerboard and relativistic quantum walks;
- causal-set order/volume reconstruction and causal-set wave operators;
- hyperdiamond and minimally doubled fermion literature;
- Nielsen-Ninomiya and chiral fermion no-go results;
- symmetric mass generation;
- Jacobson/entanglement equilibrium and black-hole entropy bounds;
- quantum speed limits and finite information bounds.

Use literature to shape theorem statements, not to bypass proof.

## 13. Good First Contributions By Background

### Lean / Mathlib

- Simplify proofs in checkerboard or Pluecker modules.
- Add small helper lemmas with docstrings.
- Improve theorem names and theorem map entries.
- Prove focused finite matrix/list/finset lemmas needed by the next theorem
  queue.

### Lattice Fermions

- Audit Gate C against exact Nielsen-Ninomiya assumptions.
- Compare the hyperdiamond scaffold with Borici-Creutz conventions.
- Identify which release hypotheses correspond to locality, chiral symmetry,
  Hermiticity/Krein structure, and gauge covariance.

### Causal Sets / Quantum Gravity

- Design finite causal-log and scheduler definitions.
- Separate causal-set claims from null-edge decorated-frame claims.
- Propose finite serialization-invariance theorems.
- Help formulate honest continuum and entropy-balance conjectures.

### Quantum Information

- Clarify the Pluecker/wedge spread versus concurrence analogy.
- Formalize finite information monotones only where the statement is exact.
- Help define commit/record/decoherence APIs as finite structures, with no
  Born-rule overclaim.

### Mathematical Physics

- Check signs, normalizations, and convention bridges.
- Review super-Dirac square hypotheses.
- Help move from finite identities to controlled analytic statements.

### Documentation / Review

- Improve claim labels.
- Add provenance notes.
- Audit docs for overclaims.
- Keep theorem maps and next-step files synchronized with Lean.

## 14. First Week Plan For A New Collaborator

Day 1:

- Build the standalone package.
- Read `TRUST_AND_SCOPE.md`, `CONVENTIONS.md`, and `THEOREM_MAP.md`.
- Pick one lane: checkerboard, Gate C, scheduler, or docs/provenance.

Day 2:

- Read the relevant Lean module and docs.
- Run `lake env lean` on the target file.
- Identify one small theorem, proof cleanup, or doc correction.

Day 3:

- Make a minimal change.
- Run the targeted Lean check or pre-commit check.
- Write down the claim label of the change.

Day 4:

- Review semantic alignment: does the theorem say what the physics prose says?
- Update the theorem map or task note if needed.

Day 5:

- Either open a small reviewable patch or prepare a focused Aristotle handoff.

The project rewards small exact wins more than sweeping synthesis.

## 15. Review Checklist

Before merging or relying on a result:

- Does the theorem statement match the intended math?
- Are all conventions explicit?
- Are `ell_a` and `alpha^a` kept distinct?
- Are `Gamma_s`, `chi_E`, form degree, and `J` kept distinct?
- Does any Gate C claim distinguish bare-symbol no-go from physical release?
- Does any continuum or gravity statement carry the right conjecture label?
- Are imported source claims cited and convention-checked?
- Did the relevant Lean command actually pass?
- Did docs change if the physical interpretation changed?

## 16. Common Failure Modes

Watch for:

- treating a fixed lattice as the fundamental causal substrate;
- treating scheduler/lapse variation as a chirality fix;
- assuming retardedness proves no-doubling;
- assuming Krein self-adjointness proves positivity;
- treating a sufficient projector as a local gauge-safe physical operator;
- claiming a named Borici-Creutz equivalence without exact source conventions;
- using the Pluecker identity as a particle mass prediction;
- using Jacobson-style gravity language as if this package had derived
  Einstein's equations;
- confusing finite identities with continuum limits.

## 17. Glossary

`ell_a`:
Primitive null edge direction. This is where the finite transport lives.

`alpha^a`:
Dual covector used in the Clifford symbol. This reconstructs covector data from
edge evaluations.

`D_N`:
Finite dual-soldered null-edge Dirac-like operator.

`Gamma_s`:
Spacetime chirality operator.

`chi_E`:
Internal finite grading. Keep it separate from spacetime chirality.

`Phi`:
Internal mass/Yukawa block in the finite super-Dirac square.

`J`:
Krein fundamental symmetry.

Gate C:
The branch-release problem for obtaining a physical chiral sector from the
3+1D null-edge symbol.

`D_phys`:
Future projected/regulated physical operator, not yet constructed by the
current standalone package.

Serialization invariance:
The requirement that physical output not depend on the chosen linear extension
or time-slicing of a causal partial order.

Scheduler:
A proposed future layer where local proper-time phase accumulation is
represented by lapse-like weights on causal histories. This is currently a
research direction, not a proved gravity theorem.

## 18. Bottom Line

The project is worth joining if you are comfortable with a sharp split between
ambitious physics motivation and conservative theorem proving. The finite core
already contains real structure: Pluecker mass obstruction, checkerboard
reversal dynamics, dual-soldered operator algebra, and a serious chirality
no-go. The next publishable advances will likely come from making one of those
threads exact enough that the broader interpretation is earned rather than
advertised.
