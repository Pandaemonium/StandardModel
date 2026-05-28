# CodeLatticeE8 Trust Report

Date: 2026-05-28

This report records the current trust boundary for the polished
`CodeLatticeE8` package.  It is meant to complement the theorem index and the
publication theorem map, and to make the remaining proof-engine dependencies
visible to reviewers.

## Scope

The standalone root is:

```text
CodeLatticeE8.lean
```

The intended invariant is:

- no imports from `PhysicsSM.*`;
- no `sorry`, `admit`, fake axioms, `opaque`, or `unsafe def`;
- all public mathematics reachable from `CodeLatticeE8.lean` is
  kernel-checked under the pinned Lean toolchain;
- no public theorem in the standalone root currently depends on
  `native_decide` or `Lean.trustCompiler`.

## Current Core Status

The following pieces have already been upgraded to non-`native_decide` proofs
in the standalone package:

- `CodeLatticeE8.E8.hammingConstructionA_short_vector_count`;
- `CodeLatticeE8.Theta.sigma3_one` through `CodeLatticeE8.Theta.sigma3_six`;
- `CodeLatticeE8.Theta.e4Coeff_zero` through `CodeLatticeE8.Theta.e4Coeff_six`;
- `CodeLatticeE8.ConstructionA.evenLiftCoeff_zero` through
  `CodeLatticeE8.ConstructionA.evenLiftCoeff_sixteen`;
- `CodeLatticeE8.ConstructionA.oddLiftCoeff_zero` through
  `CodeLatticeE8.ConstructionA.oddLiftCoeff_twentyfive`;
- `CodeLatticeE8.E8.RootBridge.hadamard_sqNorm_scale`;
- `CodeLatticeE8.E8.RootBridge.shortShellVectorList_length`;
- `CodeLatticeE8.E8.RootBridge.shortShell_perm_rootList`;
- `CodeLatticeE8.E8.Roots.rootList_length`;
- `CodeLatticeE8.E8.Roots.rootList_nodup`;
- `CodeLatticeE8.E8.Roots.rootList_all_isE8Root`;
- `CodeLatticeE8.E8.Roots.rootList_complete`;
- `CodeLatticeE8.E8.Roots.mem_rootList_iff_isE8Root`;
- `CodeLatticeE8.ConstructionA.scaledDualInt_eq_lattice_of_selfDual`;
- `CodeLatticeE8.ConstructionA.scaledReal_even_of_doublyEven`;
- `CodeLatticeE8.ConstructionA.scaledRealDual_eq_self_of_selfDual`;
- `CodeLatticeE8.E8.e8CartanMatrix_det`;
- `CodeLatticeE8.E8.e8CartanDoubled_det`;
- `CodeLatticeE8.E8.gramCartan_congruence`;
- `CodeLatticeE8.E8.e8BasisChangeMatrix_det_sq`;
- `CodeLatticeE8.E8.e8SimpleRoots_gram`;
- `CodeLatticeE8.E8.WeylReflections.reflect_preserves_IsE8Root`;
- `CodeLatticeE8.E8.WeylReflections.reflect_mem_rootList`;
- `CodeLatticeE8.E8.WeylReflections.reflect_reflect`;
- `CodeLatticeE8.Octonion.two_dvd_mulInt_of_hammingConstructionA`;
- `CodeLatticeE8.Octonion.octavianUnitMul_mem_hammingConstructionA`;
- `CodeLatticeE8.Octonion.octavianUnitMul_mem_shortShell`;
- `CodeLatticeE8.E8.thetaShellCount_eq_convolution`.

These are now good reviewer-facing theorems: their trust story is ordinary
Lean kernel checking, not bounded native evaluation.

## Native Evaluation Boundary

The standalone root currently has no live `native_decide` boundary.  The final
remaining private checks in `CodeLatticeE8/ConstructionA/ThetaConvolution.lean`
were replaced on 2026-05-21 by ordinary kernel-checked `decide`/structural
proofs.

The short-vector count, root-list characterization, root-bridge permutation,
Weyl reflection closure, octavian order/unit-shell closure, and all-shell
Construction A convolution theorem are therefore outside the
`Lean.trustCompiler` boundary.

Several matrix, root-list, and theta-analysis files locally raise
`maxHeartbeats` or suppress style linters such as long-line, flexible-tactic,
and unused-simp-argument warnings.  These suppressions are reviewability
annotations rather than trust assumptions: they do not disable kernel checking,
do not introduce axioms, and do not invoke `native_decide` or
`Lean.trustCompiler`.

The notable standalone heartbeat increases are:

- `CodeLatticeE8/E8/Roots.lean`: up to `80000000` heartbeats for the
  structural bounded completeness pass over the 240-root list;
- `CodeLatticeE8/E8/Roots.lean`: up to `40000000` heartbeats for the
  finset-cardinality wrapper around the completed root list;
- `CodeLatticeE8/E8/RootBridge.lean`: up to `12800000` heartbeats for the
  short-shell/root-list permutation bridge;
- `CodeLatticeE8/E8/ShortVectors.lean`: up to `1600000` heartbeats for the
  short-vector finite parametrization;
- `CodeLatticeE8/E8/CartanBridge.lean`: `400000` heartbeat local checks for
  the displayed determinant minors and matrix comparisons;
- `CodeLatticeE8/Octonion/Octavian.lean`: up to `3200000` heartbeats for the
  private 8-by-8 basis-product certificates used by the octavian closure
  theorems.

The Lake roots also pass `-s65536` to Lean.  This is a larger stack budget for
large finite reductions and matrix proofs; it is not a trust assumption, but it
is part of the reproducible build configuration.

The monorepo `lakefile.toml` also keeps an explicit `proofwidgets` pin because
the Windows workflow needs the ProofWidgets JavaScript build workaround
documented in `README.md` and `AGENTS.md`.  The standalone wrapper depends only
on mathlib directly, though mathlib may still bring ProofWidgets as a
transitive dependency.  The global weak Mathlib-style linter setting and
`maxSynthPendingDepth = 3` are likewise build-engineering choices, not proof
assumptions.

## Optional SPL Root Status

The optional root is:

```text
CodeLatticeE8SPL.lean
```

It imports `CodeLatticeE8.SPL.TheoremIndex`, which records the unconditional
SPL-facing coefficient facts, shell-transport theorem, and formal
power-series identity.  This root is also sorry-free and has no `PhysicsSM`
import.  Its main `Theta_E8 = E4` statements are closed in the SPL-facing
layer, assuming Sphere-Packing-Lean is available as a dependency.

The monorepo `lakefile.toml` declares Sphere-Packing-Lean because the optional
SPL root imports it.  Reviewers who only want the standalone core can use the
mathlib-only Lake wrapper:

```powershell
cd CodeLatticeE8Standalone
lake build CodeLatticeE8
```

That wrapper points its Lean source directory at the repository root but omits
the Sphere-Packing-Lean dependency.  The ordinary monorepo command
`lake build CodeLatticeE8SPL` remains the check for the SPL-facing layer.

## Axiom Audit Snapshot

On 2026-05-21, the following `#print axioms` audit was run against the current
paper-spine theorems:

```lean
#print axioms CodeLatticeE8.E8.hammingConstructionA_short_vector_count
#print axioms CodeLatticeE8.E8.Roots.mem_rootList_iff_isE8Root
#print axioms CodeLatticeE8.E8.RootBridge.shortShell_perm_rootList
#print axioms CodeLatticeE8.E8.gramCartan_congruence
#print axioms CodeLatticeE8.E8.WeylReflections.reflect_mem_rootList
#print axioms CodeLatticeE8.E8.thetaShellCount_eq_convolution
#print axioms CodeLatticeE8.SPL.splE4_coeff_eq_e4Coeff
#print axioms CodeLatticeE8.SPL.thetaSeries_hammingE8_eq_e4Series
```

Each declaration reported only the standard Lean/mathlib axioms:

```text
[propext, Classical.choice, Quot.sound]
```

Some lower-level table, list, and arithmetic lemmas whose proofs contain
ordinary `decide` reductions may report `Lean.ofReduceBool`; this is Lean's
kernel-checked boolean-reduction certificate and is distinct from
`Lean.trustCompiler`.  No theorem in this audit reported `Lean.trustCompiler`.

On 2026-05-23, the following clean Type II Construction A declarations were
also audited:

```lean
#print axioms CodeLatticeE8.ConstructionA.typeII_integer_package
#print axioms CodeLatticeE8.ConstructionA.scaledReal_even_of_doublyEven
#print axioms CodeLatticeE8.ConstructionA.scaledRealDual_eq_self_of_selfDual
```

Each reported only the standard Lean/mathlib axioms
`[propext, Classical.choice, Quot.sound]`.

On 2026-05-28, the following octavian closure declarations were audited:

```lean
#print axioms CodeLatticeE8.Octonion.two_dvd_mulInt_of_hammingConstructionA
#print axioms CodeLatticeE8.Octonion.octavianUnitMul_mem_hammingConstructionA
#print axioms CodeLatticeE8.Octonion.octavianUnitMul_mem_shortShell
```

Each reported only the standard Lean/mathlib axioms
`[propext, Classical.choice, Quot.sound]`.

## Aristotle Jobs Tracking This Boundary

The current proof-improvement wave is recorded by the following submitted job
IDs:

- `f2f6f9c3-4ede-48b3-9863-ca97beac07ab`: small theta arithmetic without
  `native_decide`; integrated 2026-05-21;
- `e72b19c0-eec6-4c0f-b661-b6a112c70d49`: structural Construction A theta
  convolution theorem; integrated 2026-05-21;
- `c6bdb730-4af3-4e09-8190-5c2ef4e6c718`: root-list classification without
  `native_decide`; integrated 2026-05-21;
- `b5779bc1-d8be-4777-a4bf-ee444176dffe`: root-bridge permutation without a
  monolithic 240-by-240 `native_decide`; integrated 2026-05-21 and then
  completed by follow-up `56691706-08a0-4637-8aa7-fcc19945abce`;
- `4467eb82-0899-4a42-94ac-432293e21812`: optional SPL-facing
  `Theta_E8 = E4` package; integrated 2026-05-21;
- `56691706-08a0-4637-8aa7-fcc19945abce`: follow-up root-bridge job targeting
  the five remaining local `native_decide` facts in `RootBridge.lean`;
  integrated 2026-05-21;
- `df2b5ccf-23e3-42dc-988b-db4c6f8639b6`: clean-package port of the general
  Type II Construction A theorem, including the integer scaled-dual equality
  and the real scaled evenness/self-duality statements; integrated 2026-05-23;
- `98138111-f6ae-45c7-9bad-3816f8454edc`: structural octavian order and
  unit-shell closure using bilinearity and the Construction A basis;
  integrated 2026-05-28.

## Audit Commands

Useful local checks for this package:

```powershell
rg -n "\bsorry\b|\badmit\b|\baxiom\b|unsafe def|\bopaque\b|^import .*PhysicsSM" CodeLatticeE8 CodeLatticeE8.lean
rg -n "\bnative_decide\b|\btrustCompiler\b" CodeLatticeE8 CodeLatticeE8.lean
lake build CodeLatticeE8
lake build CodeLatticeE8SPL
cd CodeLatticeE8Standalone; lake build CodeLatticeE8; cd ..
pre-commit run --files CodeLatticeE8.lean CodeLatticeE8/Publication/TheoremIndex.lean Sources/Hamming_ConstructionA_E8_Paper.tex Sources/CodeLatticeE8_Publication_Theorem_Map.md Sources/CodeLatticeE8_Trust_Report.md
```

For a final release candidate, run the repository-wide checks from `AGENTS.md`:

```powershell
pre-commit run --all-files
lake build
```

## Publication Acceptance Checklist

- The manuscript cites only `CodeLatticeE8.*` for standalone claims.
- Optional analytic theta claims are clearly marked as SPL-facing.
- The standalone package has no live `native_decide` dependency; any future
  finite-computation boundary must be documented before publication.
- The theorem map and theorem index agree on declaration names.
- The final artifact builds from a clean checkout with no `PhysicsSM` imports
  reachable from `CodeLatticeE8.lean`.
