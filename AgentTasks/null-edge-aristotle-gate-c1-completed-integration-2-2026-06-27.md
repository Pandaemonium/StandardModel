# Gate C1 Aristotle Completed Results Integration 2

Date: 2026-06-27

Status: summary-integrated into the Gate C1 planning docs; standalone Aristotle
Lean artifacts are not promoted to trusted `PhysicsSM` modules in this pass.

## Scope

This note integrates the newly completed C116, C117, and C125 jobs:

- C116 combinatorial path-sum non-ultralocal control.
- C117 minimal non-scalar chiral-escape theorem package.
- C125 modified chirality origin bridge.

## C116: combinatorial path-sum control

Aristotle produced a finite path-sum control theory with a machine-checked Lean
core.

Important conclusions:

```text
path sum = Neumann series;
walkSum M i j n = (M^n) i j;
operator control can be based on an arbitrary summable per-shell bound;
exponential decay is only one sufficient case;
finite-volume and limit statements must remain separate;
selection/projector attachment preserves control but does not supply a gap.
```

This supports the project's preferred non-ultralocal stance:

```text
Use summable combinatorial shell control as the primitive notion.
Treat exponential decay as a sufficient corollary, not as the definition.
```

The notable technical caveat is that some row-sum/operator-norm bounds require a
nonempty vertex set.

## C117: minimal non-scalar escape

Aristotle produced a standalone finite matrix theorem package proving:

```text
scalar/central corrections have zero chiral trace;
balance-even selectors have zero chiral trace;
the chiral trace sees only the J-odd part;
nonzero chiral trace requires nonzero J-odd content;
an explicit 2 x 2 Pauli witness shows the obstruction is the only finite
origin obstruction.
```

The single load-bearing structural hypothesis is the anticommutation
compatibility between chirality and balance:

```text
Gamma J + J Gamma = 0.
```

This confirms that any breakthrough attempt must produce nonzero J-odd content;
there is no hidden scalar or central escape hatch at finite origin.

## C125: modified chirality origin bridge

Aristotle clarified the relation between the finite-origin diagnostic chirality
`Gamma` and the released Ginsparg-Wilson chirality `Gamma_hat`.

Key identity:

```text
Tr(Gamma_hat P) =
  Tr(Gamma P) - a Tr(Gamma R D P).
```

Consequences:

```text
origin Gamma-trace is an entry ticket, not a released chirality theorem;
Gamma_hat is a genuine grading only under the GW hypotheses;
unconditional transfer from nonzero Tr(Gamma P0) to nonzero
Tr(Gamma_hat P0) is false;
machine-checked 2 x 2 witnesses show diagnostic trace can be cancelled by the
GW defect, even nondegenerately.
```

The bridge requires extra hypotheses:

```text
spectral gap for the sign kernel;
stable branch projector;
compatibility of P0 with the overlap projector;
no singular crossing;
correct Weyl tangent symbol;
GW relation and Hermitian/good R data.
```

## Impact on next breakthrough jobs

The next highest-value jobs should not merely add more finite no-go theorems.
They should try to build or refute a complete finite overlap seed:

```text
H_ne = Gamma_K (D_ne + W_branch - m0 R)
```

with:

```text
W_branch J-odd at origin;
sign(H_ne) J-odd at origin;
Gamma_hat trace protected against GW-defect cancellation;
path-sum/sign control at least at the finite Neumann-series level;
true bad-sector gap kept separate from zero removal.
```

## Trust status

The Aristotle outputs report clean standalone builds and no proof holes. This
integration pass did not download or promote returned Lean files into trusted
`PhysicsSM` modules and did not run local Lean or pre-commit.
