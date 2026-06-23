# Aristotle prompt: finite super-Dirac block operator (design)

This is a roadmap/scaffold job, not a proof-completion job. Do not build the
whole repo. The deliverable is a minimal Lean module API proposal: definitions,
theorem statements, proof sketches, dependencies, and likely blockers. You may
include Lean-like skeletons, but label every unfinished point as a handoff and do
not claim kernel proof.

## Context

The null-edge program wants a finite odd self-adjoint block operator

```text
D_{U,Phi} = d_U + delta_U + Phi + Phi^dagger
```

on a finite-dimensional graded Hilbert space, with edge transport `U`, a
Higgs/Yukawa block `Phi`, and a curvature block. The existing draft
`PhysicsSM.Draft.NullEdgeSuperDiracBlockCore` and the static Dirac-slash cores
(`NullEdgeDiracSlashCore`, `NullEdgeBundleDiracPluckerCore`,
`NullEdgeDiracTwoSheetCore`) are the trusted-adjacent inputs. The flagship target
is the square decomposition

```text
superDirac_sq_eq_laplacian_plus_curvature_plus_higgs.
```

## Assignment

Propose ONE coherent finite super-Dirac API:

1. the graded finite Hilbert space and the grading/chirality operator;
2. the coboundary `d_U` and adjoint `delta_U` with explicit edge transport and
   anticommutation hypotheses, as finite matrices;
3. the Higgs/Yukawa block `Phi` and its adjoint, and the curvature block;
4. the self-adjointness and oddness conditions that are actually forced;
5. the precise statement of `superDirac_sq_eq_laplacian_plus_curvature_plus_higgs`
   identifying each term of `D^2` (combinatorial Laplacian, curvature, Higgs
   potential, cross terms), with the anticommutation hypotheses needed.

Then give handoff signatures for the next theorems: first-order condition,
inner-fluctuation form of `Phi`, and the low-order spectral-action check.

Please end with this exact summary shape:

```text
overall assessment:
proposed core definitions:
square-decomposition statement:
ranked next theorem signatures:
likely blockers:
integration notes:
```
