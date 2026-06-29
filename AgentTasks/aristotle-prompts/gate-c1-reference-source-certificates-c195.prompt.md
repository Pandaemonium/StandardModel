Project name: gate-c1-reference-source-certificates-c195

You are Aristotle, working on the StandardModel Lean/null-edge research project.

We need to turn the Wilson/Neuberger overlap literature into explicit source
certificates for `GateC1_NU`.

Known source spine:

```text
Neuberger overlap:
  sign-function construction and Wilson-kernel reference.

Luscher/Ginsparg-Wilson:
  exact lattice chiral symmetry and modified chiral projectors.

Hernandez-Jansen-Luscher:
  locality of Neuberger operator under smooth/admissible gauge hypotheses.

Adams:
  overlap axial anomaly and topological charge in the physical mass window.

Golterman-Shamir:
  warning that propagator zeros can behave as ghost states when gauge fields
  are turned on.
```

Task:

1. Define a clean Lean-style interface for a `WilsonNeubergerReferenceCertificate`.
2. Separate algebraic overlap/GW certificates from locality/admissibility and
   anomaly/determinant-line certificates.
3. State what can be imported along a uniformly gapped homotopy and what cannot.
4. State the exact assumptions needed to avoid claiming more than the
   literature supports.
5. Identify the minimum source-backed package needed for `GateC1_NU_Background`
   versus the stronger quantum determinant-line target.

Success criteria:

```text
No overclaiming from the GW algebra alone.
Anomaly and determinant-line accounting remain separate clauses.
Locality is conditional on admissibility or replaced by a declared
non-ultralocal control certificate.
Ghost-zero exclusion is explicit.
```

Please finish with:

```text
Certificate fields:
Theorems to state:
Literature provenance:
Claims allowed:
Claims not yet allowed:
```
