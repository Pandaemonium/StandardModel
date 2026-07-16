# Stage A39: mesoscopic-algebra and strong-locality audit

Date: 2026-07-15

Status: preregistered conditional candidate killed; algebraic envelope retained

## Objective

Test whether the degree-two envelope of a rank-four generator subspace can act
as a basis-independent mesoscopic function algebra for the count-normalized
causal operator.

The candidate was

\[
  \mathcal A_L^{(2)}=\operatorname{span}
  \{1,V_L,\operatorname{Sym}^2V_L\}.
\]

The order-derived sector used the simultaneous Johnston interval embedding.
Dimension four, density, endpoints, duration, spatial rank three, and the
four-dimensional operator family remained supplied.

The protocol was frozen in
`AgentTasks/null-edge-causal-mesoscopic-algebra-stage-a39-plan-2026-07-15.md`.

## Development selection

Only oracle coordinate-generator scores were opened during development. The
grid used `N=300,600`, two realizations per density, seed `20261390`,
nonlocality multipliers `{0.45,0.60,0.75}`, and retained order-depth fractions
`{0.15,0.25,0.35}`.

No setting passed the required Lorentzian mean-pairing structural gate. The
preregistered minimax failure was therefore frozen:

```text
cL = 0.60
retained depth fraction = 0.15
```

Its worst development closure/locality median was `1.027`, set by the triple
commutator. Johnston and random-subspace scores remained unopened until this
choice was fixed.

## Held-out result

The held-out run used seed `20261400`, four realizations at each density, and
the frozen setting.

### Exact algebraic structure

The degree-two envelope itself behaved correctly in every oracle and Johnston
sample:

| diagnostic | result |
|---|---:|
| envelope rank | `15/15` in every sample |
| generator-product closure | `4e-15` to `2e-14` |
| affine `GL(4)` envelope-projector error | below `2.5e-14` |

Thus an ordered coordinate basis is unnecessary: the degree-two subspace is
numerically invariant under internal generator gauge changes.

### Closure and strong locality

| sector | N | operator closure | Gamma closure | double defect | triple defect |
|---|---:|---:|---:|---:|---:|
| oracle | 300 | 0.675 | 0.705 | 0.674 | 1.093 |
| oracle | 600 | 0.675 | 0.767 | 0.547 | 1.040 |
| Johnston | 300 | 0.677 | 0.656 | 0.862 | 1.022 |
| Johnston | 600 | 0.712 | 0.692 | 0.625 | 1.024 |
| random | 300 | 0.637 | 0.599 | 0.500 | 1.163 |
| random | 600 | 0.621 | 0.638 | 0.351 | 1.161 |

The double-commutator multiplication defect improves with density in both
geometric sectors. The strong triple-commutator defect does not: it stays near
one. Operator and `Gamma` closure do not improve uniformly, and the random
subspace beats Johnston on three of four high-density medians.

### Lorentz signature and volume

The oracle region-mean pairing is never Lorentzian. The Johnston mean pairing
is Lorentzian in `3/4` low-density samples but only `1/4` high-density samples.
Its eventwise Lorentzian fraction nevertheless rises from median `0.541` to
`0.682`, showing that region aggregation and pointwise signature are distinct
failures. Determinant-volume coefficients of variation are order one or larger
and worsen with density.

The random sector has no Lorentzian mean pairing at either density.

## Verdict

A39 fails every nonstructural pass condition:

```text
oracle control: fail
Johnston signature: fail
Johnston beats random: fail
Johnston refinement: fail
overall held-out gate: fail
```

The **degree-two envelope is retained** as a basis-independent algebraic
container. Its rank, generator-product closure, and `GL(4)` covariance are
strong.

The combination of a global envelope, order-depth region averaging, and
strong eventwise `L2` commutator norm is killed. Because the oracle sector also
fails, the result cannot be attributed to Johnston chart error alone.

## Postmortem and successor

An exploratory convention check after the held-out gate found that, at the
smaller development scale `cL=0.45`, the exact top row and one deepest interior
row of the first oracle sample were individually Lorentzian. This was not a
preregistered result and does not rescue A39. It does show that averaging all
rows in the retained region can erase a row-level Lorentz signal.

The next test should therefore change topology, not polynomial degree:

1. retain the same degree-two projector;
2. project operator, `Gamma`, Hessian, and `Gamma2` outputs back to the algebra;
3. evaluate the resulting weak calculus at an intrinsic deepest-event orbit;
4. compare weak double/triple residuals with the killed strong residuals;
5. require zero weak Ricci on flat nonlinear-coordinate controls before
   opening curvature.

This follows the A38/Pro prescription that weak geometry should precede
pointwise Christoffel or strong eventwise convergence.

## Artifacts

- `Scripts/experiments/causal_mesoscopic_algebra.py`
- `Scripts/experiments/test_causal_mesoscopic_algebra.py`
- `AgentTasks/causal-mesoscopic-algebra-stage-a39-development-2026-07-15.json`
- `AgentTasks/causal-mesoscopic-algebra-stage-a39-heldout-2026-07-15.json`

## Provenance

- User-supplied Pro analysis, 2026-07-15: basis-independent mesoscopic algebra,
  multiplication-commutator locality, and weak-geometry priority.
- Johnston simultaneous interval embedding as implemented and sourced in the
  Stage A9 artifacts.
- Exact finite commutator kernel follows the kernel-checked A38 operator
  identity. Numerical implementation and gate design are original project
  work.
