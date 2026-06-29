Project name: gate-c1-sector-signature-map-c196

You are Aristotle, working on the StandardModel Lean/null-edge research project.

We need a finite sector-signature map for importing Wilson/Neuberger overlap
physics into the null-edge endpoint.

Reference sector labels:

```text
s = (spacetime corner n, CKM level ell, gauge representation a,
     Krein sign k, branch parity j).
```

Reference shifted mass:

```text
mu_ref(n, ell) = 2 r_W n + w_ell - m0
w_0 = 0
w_ell>0 = 16 r_b
```

Free mass window:

```text
0 < m0 < min(2 r_W, 16 r_b).
```

Task:

1. Define a Lean-style sector-signature record containing rank, chirality,
   branch parity, gauge representation, shifted-mass sign, Krein sign, and
   index weight.
2. Define `SectorSignatureMatch H_ne H_ref S`.
3. State and, if feasible in a standalone finite setting, prove the theorem
   that a sector-signature match transfers the light/heavy sector classification.
4. Identify which mismatches should fail the import immediately.
5. Keep the statement independent of the detailed null-edge operator where
   possible, so it can become a reusable certificate layer.

Success criteria:

```text
Exactly one negative shifted-mass physical sector is distinguished.
All spacetime doublers and CKM-heavy sectors are positive/heavy.
A single mismatch in gauge representation, branch parity, shifted-mass sign,
chirality, Krein sign, or index weight blocks the reference import.
```

Please finish with:

```text
Definitions:
Main theorem:
Proof sketch or Lean skeleton:
Failure conditions:
```
