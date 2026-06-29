Project name: gate-c1-free-assembly-after-c203-c207

You are Aristotle, working on the StandardModel Lean/null-edge research project.

Goal:

Assemble a precise `GateC1_NU_Free` theorem from the completed certificate
pieces:

```text
C193: free Wilson+CKM mass window and gamma_free.
C194: kappa < gap -> gapped homotopy.
C196: sector-signature match.
C201: sign stability below gamma_free.
C202: maintained spectral-island/projector persistence.
C195/C203: source-contract boundaries.
```

Task:

1. Define the minimal `GateC1_NU_Free` record or predicate.
2. State the exact theorem:

```text
C193 mass window
+ ReferenceIsGapped
+ NullEdgeKineticCloseEnough with kappa < gamma_free
+ sector-signature match
+ maintained physical spectral island
-> GateC1_NU_Free.
```

3. Explicitly exclude background-gauge, determinant-line, anomaly, ghost, and
   quantum claims from this free theorem.
4. Identify which fields must be added to upgrade to
   `GateC1_NU_BackgroundGauge`.
5. Return Lean-style record and theorem skeletons.

Success criteria:

```text
The free theorem should be honest and minimal.
No quantum/determinant overclaiming.
The remaining assumptions should be named exactly.
```

Please finish with:

```text
GateC1_NU_Free record:
Assembly theorem:
Inputs consumed from C193/C194/C196/C201/C202:
Excluded claims:
Upgrade path:
```
