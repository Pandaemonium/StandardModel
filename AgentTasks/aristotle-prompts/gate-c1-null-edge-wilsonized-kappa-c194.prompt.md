Project name: gate-c1-null-edge-wilsonized-kappa-c194

You are Aristotle, working on the StandardModel Lean/null-edge research project.

Current Gate C1 direction:

```text
Use Wilson/Neuberger overlap as the first physical reference.
Insert CKM only as an internal branch/flavor mass texture.
Prove the actual null-edge endpoint is gapped-homotopic to that reference.
```

Reference architecture:

```text
H_ref(U) =
  Gamma_ref [
    D_W^0(U) tensor I_CKM
    + I tensor r_b(15 I - M_CKM)
    - m0 I
  ].

D_W^0(p) =
  i sum_mu gamma_mu sin(p_mu)
  + r_W sum_mu (1 - cos(p_mu)).
```

Null-edge endpoint:

```text
H_ne(U) =
  Gamma_K [
    D_ne^cov(U)
    + W_NE,space(U)
    + r_b(15 R_ne - M_CKM^ne)
    - m0 R_ne
  ].
```

Task:

1. Propose the cleanest mathematically explicit definition of `W_NE,space` for
   the null-edge endpoint, compatible with the Wilson/Neuberger reference.
2. Define the kappa mismatch certificate after transport by a sector/frame map
   `S`.
3. Give the strongest theorem statement you can for bounding kappa in the flat
   free case.
4. If exact kappa zero is unrealistic, give a concrete small-kappa sufficient
   condition and the proof outline.
5. If useful, provide Lean-style predicate and theorem skeletons suitable for a
   draft module.

Success criteria:

```text
Do not ask CKM to solve spacetime doublers.
Keep omega = 0 and rho = 0 in the first theorem.
Make explicit what must be proved about D_ne^cov + W_NE,space.
Return failure conditions if the null-edge kinetic cannot be close enough.
```

Please finish with a concise report:

```text
Solved or proposed definitions:
Main theorem statements:
Proof dependencies:
Likely Lean formalization targets:
Failure modes:
```
