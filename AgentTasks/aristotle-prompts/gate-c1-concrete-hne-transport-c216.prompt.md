Project name: gate-c1-concrete-hne-transport-c216

You are Aristotle, working on the StandardModel Lean/null-edge research project.

Goal:

Define the concrete finite-matrix null-edge endpoint `H_ne` and transport `S`
for the first free model.

Endpoint:

```text
H_ne =
  Gamma_K [D_ne^cov + W_NE,space + r_b(15R - M_CKM) - m0 R].
```

Task:

1. Propose explicit finite data for `D_ne^cov`, `W_NE,space`, `R`,
   `M_CKM`, and `Gamma_K`.
2. Define the transport map `S` and inverse `Sinv`.
3. State exact CKM and R transport equations needed to make
   `kappaCKM = 0` and `kappaRm0 = 0`.
4. Identify what remains in `kappaBranch`, `kappaKin`, and `kappaWil`.
5. Return Lean-style definitions and theorem statements.

Success criteria:

```text
Do not assume kappa is small without decomposing it.
Make explicit whether we can get exact transport or only a bound.
No background-gauge or quantum claims.
```

Please finish with:

```text
H_ne finite data:
Transport S/Sinv:
Exact transport equations:
Residual kappa terms:
Lean/API skeleton:
```
