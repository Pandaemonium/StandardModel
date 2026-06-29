Gate C1 NullEdgeOverlapReferenceImport theorem design, C242

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

The current proposed C1 route is:

```text
H_ref = known Wilson/Neuberger overlap reference kernel;
H_ne  = null-edge-derived Hermitian Wilson kernel;
D_ov,ne = (rho/a)(1 + Gamma_NE sign(H_ne)).
```

The key proof idea is not to solve overlap theory from scratch. Instead prove
that `H_ne` is in the same gapped sign/index sector as `H_ref`.

Reference-import target:

```text
H_ref^S = S H_ref S^-1,
H_t = (1 - t) H_ref^S + t H_ne,
sigma_min(H_t) >= delta > 0.
```

A sufficient first condition is:

```text
||H_ne - H_ref^S|| <= epsilon < gap(H_ref).
```

Existing Draft modules that may be relevant:

```text
CKMWilsonWindow.lean:
  mass-window and gamma_free style lemmas.

GappedHomotopy.lean:
  abstract kappa-to-gapped-homotopy result.

SignStability.lean:
  sign stability under below-margin perturbations.

OperatorFreeze.lean:
  FrozenOverlap and BudgetDecomposition API.

SpectralProjectorAPI.lean:
  stronger spectral projector range/kernel API and source contracts.
```

Task:

Design the next Lean/API layer:

```text
NullEdgeOverlapReferenceImport
```

that connects the new Hermitian kernel proposal to the existing Draft spine.

Please answer:

1. What fields should `NullEdgeOverlapReferenceImport` contain?
2. Should it extend or wrap `OperatorFreeze.FrozenOverlap` and
   `BudgetDecomposition`, or be independent?
3. What theorem should state that the norm bound gives a gapped homotopy?
4. What theorem should state that the sign/index/sector signature is imported
   along the gapped homotopy?
5. Which parts should remain source contracts rather than proved Lean facts:
   Neuberger overlap, GW algebra, HJL locality, Lüscher determinant measure,
   anomaly accounting?
6. How should the API distinguish:

```text
GateC1_formal;
GateC1_NU_Free;
GateC1_NU_BackgroundGauge;
GateC1_NU_Quantum?
```

7. What exact next theorem statement would be the highest-value Aristotle proof
   target once Codex writes the file?

Constraints:

- Do not claim the Standard Model chiral gauge theory is solved.
- Keep free/background/quantum layers separate.
- Do not let source contracts masquerade as proved Lean theorems.
- Preserve the no-ghost inverse-gap requirement.
- Do not claim local repo verification.

Requested output:

- proposed Lean structures;
- theorem statements;
- relation to existing Draft modules;
- source-contract boundary;
- next proof targets.
