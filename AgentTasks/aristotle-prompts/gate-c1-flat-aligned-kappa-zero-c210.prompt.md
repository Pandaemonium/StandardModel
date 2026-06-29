Project name: gate-c1-flat-aligned-kappa-zero-c210

You are Aristotle, working on the StandardModel Lean/null-edge research project.

C206 decomposes:

```text
kappa =
  kappaBranch + kappaKin + kappaWil + kappaCKM + kappaRm0.
```

In the ideal first theorem, CKM and R transport exactly:

```text
kappaCKM = 0;
kappaRm0 = 0.
```

Task:

1. State the strongest flat/aligned exact-match theorem:

```text
if transport(Gamma_K) = Gamma_ref;
if transport(D_ne^cov + W_NE,space) = D_W^0;
if transport(M_CKM^ne) = M_CKM;
if transport(R_ne) = I;
then kappa = 0.
```

2. If full exact equality is too strong, state the first nonzero-mismatch
   theorem:

```text
kappa <= kappaBranch + kappaKin + kappaWil
```

under CKM/R exact matching.

3. Identify the minimal endpoint data needed to instantiate the theorem.
4. Explain whether a flat aligned seed can realistically make kappa zero or only
   small.
5. Return Lean-style theorem statements suitable for a draft module.

Success criteria:

```text
Make the best-case theorem explicit.
Do not hide mismatch in an opaque kappa assumption.
Clearly separate exact-match from small-mismatch cases.
```

Please finish with:

```text
Exact-match theorem:
Small-mismatch theorem:
Endpoint data required:
Realism assessment:
Lean/API skeleton:
```
