Gate C1 spectral-island stability source/API audit, C229

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Current architecture:

```text
Wilson/Neuberger overlap reference
  with CKM as an internal branch/flavor mass texture,
  not as the primary spacetime doubler-resolution operator.
```

The free Gate C1 stack has these current layers:

```text
C193/C201:
  Wilson+CKM mass window and sign stability with margin gamma_free.

C194:
  kappa < gap gives a gapped homotopy.

C202:
  maintained spectral island / projector persistence scaffold.

C175 target:
  branch-line lift using Riesz/Kato-style spectral projectors.
```

Task:

Build a source and API plan for the spectral-island/projector-persistence layer.

Please answer:

1. What exact theorem obligations should be separated between:
   finite-dimensional spectral-island persistence,
   Riesz projection stability,
   Davis-Kahan quantitative subspace bounds,
   and branch-line chiral-index persistence?
2. Which parts should be treated as purely finite Lean algebra first?
3. Which parts require analytic source contracts such as Kato perturbation
   theory or Davis-Kahan?
4. What Lean structures/predicates should Codex add after the current Draft
   leaves compile?
5. What theorem should connect the gapped homotopy result to a stable physical
   branch projector?
6. What must not be claimed from projector persistence alone?

Claim boundaries:

```text
Projector persistence does not prove spacetime no-doubling.
Projector persistence does not prove anomaly or determinant-line control.
Projector persistence does not by itself prove Krein positivity.
The bare null-edge branch kernel remains chirality-balanced unless a separate
polarizing projector is constructed.
```

Requested output:

- source-to-obligation table;
- Lean API sketch;
- theorem stack connecting C194/C202 to C175;
- no-overclaim checklist;
- next focused Aristotle proof jobs.
