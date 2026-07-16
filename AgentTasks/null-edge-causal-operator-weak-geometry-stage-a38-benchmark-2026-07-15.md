# Stage A38: one-operator weak-geometry control

Date: 2026-07-15

Status: exact finite algebra plus external flat numerical control; not a graph
convergence theorem

## Question

Can the post-A37 program be organized around one count-normalized scalar
operator, with metric, connection, and curvature read from its multiplication
defects, before fitting more pointwise coordinate derivatives?

## Selected architecture

The primary mesoscopic object is

\[
  (\mathcal A_L,\mu_L,B_L,\prec),
\]

where `A_L` is a basis-independent function algebra, `mu_L` is the count
measure, `B_L` is the normalized causal operator, and `prec` is causal order.
The potential-free operator and corrected product defect are

\[
  \Box_L=B_L-M_{B_L1},
  \qquad
  \Gamma_L(f,h)=\frac12\left(
    B_L(fh)-fB_Lh-hB_Lf+fhB_L1
  \right).
\]

The differential-order diagnostics are

\[
  [[B_L,M_f],M_h]1=2\Gamma_L(f,h),
  \qquad
  [[[B_L,M_f],M_h],M_k]\longrightarrow0.
\]

The second condition is not automatic for a finite matrix. It is a locality
and second-order convergence gate on the selected algebra.

Weak connection and curvature data are read without choosing four preferred
coordinates:

\[
\begin{aligned}
  H_f(g,h)&=\frac12\{\Gamma(g,\Gamma(f,h))
    +\Gamma(h,\Gamma(f,g))-\Gamma(f,\Gamma(g,h))\},\\
  \Gamma_2(f,h)&=\frac12\{\Box\Gamma(f,h)
    -\Gamma(f,\Box h)-\Gamma(h,\Box f)\}.
\end{aligned}
\]

In a smooth flat control, the polarized Bochner identity requires

\[
  \Gamma_2(f,h)=\langle H_f,H_h\rangle
\]

and hence a zero weak Ricci remainder, even in nonlinear coordinates with a
nonzero coordinate connection.

## Kernel-checked identities

`PhysicsSM/Draft/NullEdge/CausalOperatorWeakGeometry.lean` proves:

- the corrected pairing is half the double multiplication commutator applied
  to the constant field;
- subtracting multiplication by `L 1` makes the operator kill constants;
- adding any multiplication potential leaves the corrected pairing, normalized
  operator, double commutator, triple commutator, weak Hessian, and normalized
  `Gamma2` unchanged;
- the weak Hessian is symmetric in its two gradient-direction probes.

The guarded theorems have the standard dependency footprint
`[propext, Classical.choice, Quot.sound]`. No proof holes or compiled-evaluator
proofs are present.

## External flat controls

`Scripts/experiments/causal_operator_weak_geometry.py` implements the same
operator algebra for finite matrices and a centered four-dimensional flat
d'Alembertian with signature `(+---)`. The nonlinear controls use

\[
  y^a=u^a+\frac12Q^a{}_{mn}u^m u^n.
\]

They have a nonzero exact weak-Hessian signal but zero physical curvature.

| chart | spacing | metric error | Hessian error | Hessian signal | weak Ricci error |
|---|---:|---:|---:|---:|---:|
| temporal quadratic | 0.16 | 0.004096 | 0.003277 | 0.8 | `3.66e-15` |
| temporal quadratic | 0.08 | 0.001024 | 0.000819 | 0.8 | `2.59e-14` |
| temporal quadratic | 0.04 | 0.000256 | 0.000205 | 0.8 | `1.93e-14` |
| shear quadratic | 0.16 | 0.014400 | 0.021600 | 1.5 | `4.80e-4` |
| shear quadratic | 0.08 | 0.003600 | 0.005400 | 1.5 | `2.94e-5` |
| shear quadratic | 0.04 | 0.000900 | 0.001350 | 1.5 | `1.83e-6` |

The affine control is exactly Minkowski with zero Hessian, weak Ricci, and
weak scalar curvature at the reported precision. In both nonlinear charts,
metric and Hessian errors decrease by a factor of four when spacing halves.
The shear weak-Ricci error decreases by about a factor of sixteen; the temporal
remainder is at floating-point roundoff.

Full machine-readable results are in
`AgentTasks/causal-operator-weak-geometry-stage-a38-control-2026-07-15.json`.

## Result

A38 passes the **supplied-operator flat weak-geometry control**. It shows that
the weak Bochner subtraction distinguishes coordinate connection from physical
curvature and that the whole readout is insensitive to scalar multiplication
potentials.

This is stronger conceptually than differentiating a noisy pointwise metric,
but weaker empirically than a causal-set curvature benchmark. The numerical
operator is the known flat d'Alembertian, not a reconstructed causal operator.
The probes are supplied coordinate functions, not an intrinsic mesoscopic
algebra. No curved Ricci signal, causal-operator `Gamma2`, concentration bound,
or bare-order convergence theorem has been obtained.

## Program decision

A37 remains a useful conditional connection diagnostic. It is no longer the
primary route to curvature. The next causal gate is to reconstruct a
basis-independent `A_L` and test, on held-out sprinklings:

1. approximate product, operator, and `Gamma` closure;
2. decreasing double-commutator multiplication defect and triple commutator;
3. two-sided support, stable Lorentz rank, and count-volume agreement;
4. projected weak Hessian and `Gamma2` flat cancellation;
5. only then, curved weak Ricci and agreement with `-2 B_L 1`.

Pointwise Christoffel and second-jet estimators remain comparison diagnostics.
They should not select the mesoscopic algebra or define the primary curvature
observable.

## Provenance

- User-supplied Pro analysis, 2026-07-15: one-operator architecture,
  basis-independent mesoscopic algebra, multiplication-commutator locality,
  and weak Hessian/`Gamma2` priority.
- Standard multiplication-commutator characterization of second-order
  differential operators and polarized Bochner calculus.
- Implementation and finite controls are original project work.
