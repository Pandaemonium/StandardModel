Project name: gate-c1-concrete-hne-kappa-inputs-c206

You are Aristotle, working on the StandardModel Lean/null-edge research project.

Goal:

Turn the abstract C194 `NullEdgeKineticCloseEnough` obligation into concrete
input data for the actual null-edge endpoint.

Current endpoint:

```text
H_ne =
  Gamma_K [
    D_ne^cov
    + W_NE,space
    + r_b(15 R_ne - M_CKM^ne)
    - m0 R_ne
  ].
```

C194 recommends:

```text
W_NE,space(p) = r_b sum_j spatial (1 - cos p_j)
```

Task:

1. Specify the minimal concrete data needed to define `H_ne` in Lean.
2. Define the transport map `S` and what must be true of `S` and `Sinv`.
3. Decompose kappa into computable pieces:

```text
kinetic symbol mismatch;
Wilson spatial profile mismatch;
CKM table mismatch;
R/m0 mismatch;
branch-frame/soldering mismatch.
```

4. State sufficient conditions making CKM and R mismatch zero in the first
   theorem.
5. Return a theorem skeleton for proving

```text
NullEdgeKineticCloseEnough H_ne H_ref kappa
```

with `kappa < gamma_free`.

Success criteria:

```text
Be concrete about what remains undefined.
Do not bury kappa in an opaque assumption without decomposing it.
Do not claim the bound is proved unless the endpoint data are supplied.
```

Please finish with:

```text
Required H_ne data:
Transport requirements:
Kappa decomposition:
Zero-mismatch simplifications:
Lean/API skeleton:
Next proof jobs:
```
