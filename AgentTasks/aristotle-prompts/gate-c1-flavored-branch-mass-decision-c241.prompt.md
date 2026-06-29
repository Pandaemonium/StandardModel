Gate C1 scalar Wilson versus flavored branch mass decision, C241

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

The proposed Null-Edge Overlap kernel is:

```text
H_ne =
  gamma5 [
    D_ne^0 + W_ne + M_br - rho/a
  ].
```

The current recommendation is to start with:

```text
M_br = 0.
```

Only add a branch/flavored mass term if scalar Wilson fails the branch-mass
test for the actual null-edge graph.

Failure mode:

```text
D_ne^0(p_j) = 0,
D_ne^0(p_k) = 0,
W_ne(p_j) = W_ne(p_k),
```

but one branch should be selected and the other should be lifted.

Candidate flavored branch mass:

```text
M_br(p) =
  (1/a) sum_{I subset {1,...,4}} c_I prod_{A in I} cos(k_A).
```

Gauge-covariant operator replacement:

```text
C_A = (1/2)(T_A + T_A^dagger),
```

with symmetrized products used to maintain Hermiticity and gauge covariance.

Task:

Give a decision framework for when scalar Wilson is enough and when a flavored
or matrix-valued `M_br` is mathematically necessary. We especially need a
Lean/API-friendly way to state this as a branch-mass classification problem.

Please answer:

1. For the clean tetrahedral four-null-edge model, is scalar Wilson enough in
   the free theory? If yes, under what exact assumptions?
2. What branch degeneracy patterns would force `M_br != 0`?
3. Can the Boolean/cos-product basis assign arbitrary branch masses on the
   16 branch points? Give the finite Fourier/Walsh-Hadamard statement.
4. What Hermiticity/gamma5-even/gauge-covariance conditions are needed for
   `M_br`?
5. What source-contract boundaries should be attached to Adams/flavored-overlap
   and Creutz-Kimura-Misumi analogies?
6. How can we prevent `M_br` from becoming an unconstrained fitting function
   that destroys predictivity?
7. What is the minimal theorem ladder:

```text
scalar Wilson suffices for tetrahedral free branches;
if scalar Wilson fails, cos-product branch mass can separate finite branches;
Hermitian/gamma5-even symmetrized operator realization;
no-ghost inverse-gap audit.
```

Requested output:

- scalar-vs-flavored decision tree;
- finite branch-mass interpolation theorem statement;
- gauge-covariant operator caveats;
- prediction/moduli guardrails;
- recommended Lean file/API names.

Constraints:

- Do not claim `M_br` solves gauge/anomaly/Krein questions.
- Do not use propagator zeros as mirror removal.
- Do not turn `M_br` into unconstrained post-hoc fitting without flagging the
  prediction loss.
