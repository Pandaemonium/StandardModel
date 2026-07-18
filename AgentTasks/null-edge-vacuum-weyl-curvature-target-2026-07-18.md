# Null-edge vacuum-Weyl curvature target

Date: 2026-07-18
Status: implemented and verified

## Objective

Replace the pair-asymmetric one-face curvature left by the static-square audit
with a concrete nonzero local curvature target satisfying the full algebraic
Riemann symmetries and the vacuum Einstein equation.

## Landed results

`VacuumWeylCurvatureTarget.lean` defines the diagonal two-parameter family
with ordered bivector coordinates `(-x-y,y,x,x,y,-x-y)` and proves:

1. antisymmetry in the spacetime face pair;
2. exchange symmetry after lowering both internal indices with eta;
3. the algebraic first Bianchi identity;
4. zero identity-coframe mixed Ricci tensor;
5. zero identity-coframe scalar curvature;
6. zero mixed vacuum Einstein tensor;
7. nonzero curvature whenever `x` is nonzero.

The `(x,y)=(1,0)` member is packaged as `unitVacuumWeylTarget`, proving the
complete algebraic target structure is nonempty.

## Claim boundary

This closes the compatibility and nonvacuity of the local vacuum-Riemann
target. It does not construct proper eta-Lorentz links realizing the target,
prove exact joint stationarity, derive a varying coframe, or establish a graph
refinement and continuum limit.

## Convention correction

The pair-exchange audit now explicitly lowers both internal bivector indices
with the mostly-minus eta matrix before comparing them to the spacetime face
pair. The earlier square counterexample remains valid because its required
partner entry is zero.

## Aristotle follow-up

Project `a8d83497-34e4-4151-a122-59b821b3e587`, task
`49956b25-fb1b-4877-ac4c-7b25370d1518`, was submitted to construct or rule out
the smallest periodic proper-Lorentz varying-coframe realization.

## Verification

- Direct Lean checks passed for the corrected audit module and new target.
- Targeted builds passed for the corrected audit module (8081 jobs), new target
  (8082 jobs), and GR foundations facade (8137 jobs).
- The strict Lean token scan, `pre-commit run --all-files`, and
  `git diff --check` passed.
- Full `lake build` passed (8319 jobs). Its replayed warnings are pre-existing
  and outside this task's files.
