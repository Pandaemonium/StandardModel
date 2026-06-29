# Aristotle strategy job C260: Full physical Gate C1 strategy audit

You are Aristotle, working as a high-level Lean/formalization/physics strategy reviewer for the `PhysicsSM` repository. This is a strategy job, not a request to fill one small proof hole.

## Project context

The long-term goal is to build a model that reproduces the Standard Model while interpreting its kinematics in terms of discrete lightlike/null-edge steps, inspired partly by Feynman's checkerboard. The current hard gate is Gate C1: obtain a chiral physical release mechanism from a null-edge finite/free kernel without cheating by removing gauge-charged mirrors through propagator zeros, losing the physical anomaly structure, or hiding bad states in an indefinite/Krein sector.

The current architecture has moved away from trying to make a finite ultralocal seed itself be the chiral release. The active architecture is:

```text
finite null-edge / tetrahedral free kernel
  -> Hermitian Wilson/Neuberger-style kernel H_ne
  -> prove finite/free spectral gap and symbol matching
  -> use sign(H_ne) / overlap or related release mechanism
  -> then audit locality/quasi-locality, gauge covariance, anomaly, positivity/Krein, and mirror/ghost sectors
```

We are willing to abandon ultralocality if that is necessary. Nonlocal or quasi-local overlap/domain-wall structure is acceptable if it is the physically correct way to solve the doubling/release problem.

## Current Lean/formal status

Recent kernel-checked progress in `PhysicsSM/Draft/NullEdge/GateC1`:

- `TetraQSquareExact.lean`: exact tetrahedral scalar square and positivity/nonzero lemmas.
- `TetraQMatrixSquareExact.lean`: abstract Euclidean tetrahedral slash layer, `Q_square_exact`, `Q_star_mul_exact`, inverse/determinant consequences.
- `TetraScalarWilsonSymbol.lean`: scalar Wilson free symbol, first Wilson band, exact and uniform symbol gap.
- `FiniteBlockDiagonalGap.lean`: generic theorem converting a unitary block diagonalization plus pointwise symbol gap into a finite operator gap.
- `TetraFiniteTorusEqual.lean`: equal-side finite rank-4 torus, commuting shifts, finite field L2 norm preservation.
- `FiniteFourierParseval.lean`: generic finite character-table Parseval bridge from column orthogonality.
- `TetraCharactersEqual.lean`: concrete `SiteN/MomN` character bijection, raw Parseval, normalized/unitary Fourier, unitary diagonalization of shifts, centered transport differences, and Wilson laplacian pieces. Phase convention is pinned: canonical transport uses `phasePlus`, old pullback shift uses `phasePlus^{-1}`.

Targeted checks already passed locally:

```text
lake build PhysicsSM.Draft.NullEdge.GateC1.FiniteFourierParseval
lake build PhysicsSM.Draft.NullEdge.GateC1.TetraCharactersEqual
```

The finite/free theorem is now close. Remaining finite/free tasks are mainly:

1. Prove phase-to-trig adapters from `phasePlus N m A = AddChar.zmodAddEquiv (m A) 1` to the existing `sinCoeffs` and scalar Wilson `1 - cos` symbol convention.
2. Assemble the full finite/free `Hfree` operator from the diagonalized pieces.
3. Prove `fourierUnitary (Hfree Psi) m = H_symbol(m) (fourierUnitary Psi m)`.
4. Apply `FiniteBlockDiagonalGap.operator_gap_of_unitary_block_diagonalization` plus the existing scalar Wilson symbol gap.

## Existing anomaly-cancellation work

The repo already has Standard Model and Furey/Hughes-adjacent anomaly work. Relevant included files include:

- `PhysicsSM/StandardModel/AnomalyCancellation.lean`
- `PhysicsSM/StandardModel/AnomalyPackage.lean`
- `PhysicsSM/StandardModel/FamilyAnomalyAppendTriality.lean`
- `PhysicsSM/StandardModel/FamilyAnomalyListFold.lean`
- `PhysicsSM/StandardModel/FamilyAnomalyNaturality.lean`
- `PhysicsSM/StandardModel/FamilyAnomalyPermutation.lean`
- `PhysicsSM/Algebra/Furey/AnomalyBridge.lean`
- `PhysicsSM/Algebra/Furey/ElectroweakAnomalyBridge.lean`
- `PhysicsSM/Algebra/Furey/FureyAnomalyDecomposition.lean`
- `PhysicsSM/Algebra/Furey/JbarElectroweakAnomaly.lean`
- null-edge anomaly audit/integration task notes included in this packet.

Please determine whether this work is actually helpful for full physical C1. In particular, distinguish:

- algebraic cancellation of Standard Model gauge anomalies for the desired chiral content;
- overlap/Ginsparg-Wilson anomaly realization and index theorem obligations;
- absence of spurious mirror/ghost anomaly contribution;
- whether the existing Lean anomaly modules can be imported as a certificate, or whether they only certify particle-content bookkeeping.

## Known warnings/guardrails

- Do not solve C1 by a propagator zero for a gauge-charged mirror branch. That is a ghost-risk trap.
- Do not revive the diagonal null operator as the continuum Dirac-symbol operator; the active architecture uses dual-soldered finite null-edge Dirac structure.
- Do not assume scalar Wilson at the origin polarizes the balanced kernel. Earlier work treated scalar Wilson as a no-go for direct chiral selection; scalar Wilson is now being used as part of a Hermitian overlap kernel, not as the release by itself.
- Do not treat D4 as a replacement for the current rank-4 translation torus unless you can show it improves the C1 operator. Current guidance is that D4 may be a useful indexing/covering or symmetry audit, but not the primary release mechanism.
- Do not add stay/coin terms to the current finite/free proof unless you argue they are necessary and compatible with the null-edge primitive transport story.
- Keep finite/free gap, overlap release, gauge coupling, anomaly, locality/quasi-locality, and Krein/positivity audits as separate theorem obligations.

## What I need from you

Please produce an overarching strategy report for all of Gate C1, including full physical C1, not just the finite/free theorem.

Answer these questions decisively:

1. What is the precise C1 closure criterion? Give a checklist of theorem obligations, from finite/free gap through physical chiral release.
2. What operator should we actually try to prove? Should it be Wilson/Neuberger overlap built from the current tetrahedral null-edge kernel, a matrix-valued Wilson variant, a branch-mass operator, a domain-wall construction, or something else?
3. Given the new finite Fourier/unitary Parseval progress, what is the shortest Lean path to the finite/free operator-gap theorem?
4. What remains after the finite/free gap theorem before we can honestly claim physical C1?
5. How should existing anomaly-cancellation work in the repo be used? Is it sufficient for any C1 anomaly audit subgoal, or only a prerequisite? What additional anomaly/index theorem statements are needed?
6. Which assumptions should we discard or relax? In particular, should we explicitly stop requiring ultralocality, exact finite chirality at the seed level, D4 replacement, scalar Wilson as direct release, or forced movement at every step?
7. What are the top 5 next Lean theorem targets, in exact or near-exact theorem-statement form, and which files should they live in?
8. What are the top 5 next literature/physics audit targets?
9. If you think the current path is wrong, say so bluntly and propose the replacement architecture.
10. If you think the current path is right, say what single theorem or construction is the critical path to closing C1.

## Requested output format

Create a Markdown report named:

```text
GateC1_FullPhysical_StrategyAudit.md
```

Use sections:

1. Executive verdict
2. Exact C1 closure contract
3. Recommended operator architecture
4. Finite/free Lean proof path
5. Full physical C1 remaining obligations
6. Anomaly-cancellation reuse audit
7. Assumptions to keep vs discard
8. Top Lean theorem targets
9. Top literature/physics audit targets
10. Risks, no-go traps, and decision points
11. Concrete next-week plan

Be candid. Prefer a workable, literature-aligned model over novelty. If the answer is “use standard overlap/domain-wall machinery and reinterpret it in null-edge terms,” say that. If a null-edge-native operator is still plausible, identify the exact additional structure required.
