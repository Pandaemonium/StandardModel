# Null-edge Stage A44a ideal local-operator moment benchmark

**Status:** pass for the conditional ideal-moment control

## Claim boundary

This benchmark checks the algebra and coordinate-oracle moments of the local
causal-set operator proposed by Boguna and Krioukov, after explicit conversion
from their `(-,+,+,...)` convention to the project's `(+---)` convention. It
does not derive distances or neighborhoods from a causal order, test a random
sprinkling, prove concentration, or establish a curved-space limit.

## Exact formal result

`PhysicsSM/Draft/NullEdge/LocalCausalOperatorMoments.lean` defines the centered
temporal and spatial second differences, the source response

\[
  B_{\rm src}=-(C+d+1)D_t+C D_s,
\]

and the project response `-B_src`. It proves:

- exact annihilation of constants;
- exact cancellation of opposite temporal and spatial first moments;
- project response `2` on the temporal coordinate square;
- project response `-2` on every spatial coordinate square;
- zero response for a vanishing mixed moment; and
- the exact `3+1` corrected-pairing diagonal `(1,-1,-1,-1)`.

The quadratic theorems assume nonzero scale and balance constant and the
paper's displayed temporal/spatial second-moment relations. No graph
construction is hidden in those hypotheses.

## Coordinate-oracle fixture

`Scripts/experiments/causal_local_operator_moments.py` constructs a symmetric
finite hyperboloid stencil. For spatial dimension `d`, each neighborhood point
has proper time `scale`, while the symmetric neighborhood has

\[
  E[t^2]=(d/C+1)\,\text{scale}^2,
  \qquad
  E[x_j^2]=\text{scale}^2/C.
\]

At `C=243/29` and `scale=0.2`, the audit gives:

| spatial dimension | recovered metric diagonal | maximum response error |
|---:|---|---:|
| 1 | `(1,-1)` | `7.11e-15` |
| 2 | `(1,-1,-1)` | `4.44e-16` |
| 3 | `(1,-1,-1,-1)` | `3.55e-15` |

Maximum first-moment, second-moment, and proper-time-shell errors are below
`1.4e-17` in every fixture. Deliberately shifting one future spatial point
produces project affine leakage `-1.745689655...`, so the leakage diagnostic
does not pass a broken neighborhood by symmetry-blind cancellation.

## Verdict

**PASS** for A44 Phase A's local ideal-moment and sign-convention control.
This establishes that the local architecture can carry the intended
principal symbol when its intrinsic neighborhoods realize the required
moments. It does not show that a bare order can realize them accurately.

The next local subgate is therefore a three-level comparison on common
sprinklings:

1. coordinate-oracle neighborhoods;
2. order-derived temporal distance with oracle spatial distance;
3. fully order-derived temporal and spatial neighborhoods.

At each level, report first-moment leakage before quadratic metric error. The
regional nonlocal covariance branch remains open and must be compared on the
same flat polynomial controls.

## Verification

```text
lake env lean PhysicsSM/Draft/NullEdge/LocalCausalOperatorMoments.lean
python -m pytest Scripts/experiments/test_causal_local_operator_moments.py -q
python Scripts/experiments/causal_local_operator_moments.py
```

All commands passed. The Python suite contains 10 tests.

## Provenance

M. Boguna and D. Krioukov, "Local d'Alembertian for causal sets,"
[arXiv:2506.18745](https://arxiv.org/abs/2506.18745), especially equations
(84)--(91). The implementation is a clean-room translation of the displayed
mathematics, not copied source code.
