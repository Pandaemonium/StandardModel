Project name: gate-c1-concrete-href-matrix-c215

You are Aristotle, working on the StandardModel Lean/null-edge research project.

Goal:

Define the concrete finite-matrix `H_ref` for the first free
Wilson+CKM reference model.

Relevant source:

```text
Yumoto-Misumi, "Lattice fermions as spectral graphs", arXiv:2112.13501,
for finite Dirac/Wilson matrices and DFT-style species/eigenvalue checks.
```

Reference:

```text
H_ref =
  Gamma_ref [
    D_W^0 tensor I_CKM
    + I tensor r_b(15I - M_CKM)
    - m0 I
  ].
```

Task:

1. Propose exact matrix entries for the smallest finite free reference model.
2. Decide whether to work in momentum-corner diagonal basis or position-space
   finite lattice basis.
3. State the theorem connecting the matrix entries to C193's sector mass
   formula.
4. Identify the DFT/spectral-graph proof route if position-space is chosen.
5. Return Lean-style definitions and theorem statements.

Success criteria:

```text
H_ref must be explicit.
The theorem must connect H_ref sectors to mu(n,ell).
Do not use CKM as kinetic doubler resolver.
```

Please finish with:

```text
Recommended representation:
Matrix entries:
Sector theorem:
DFT/spectral-graph route:
Lean/API skeleton:
```
