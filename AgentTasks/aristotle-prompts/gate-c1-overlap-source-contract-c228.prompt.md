Gate C1 overlap source-contract audit, C228

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Project context:

Gate C1 now uses this first physical architecture:

```text
Wilson/Neuberger overlap reference
  with CKM inserted as an internal branch/flavor mass texture,
  not as the primary spacetime doubler-resolution operator.
```

The null-edge endpoint can close only if it is transported into the same
gapped sector-signature class as the reference:

```text
H_ne ~_gapped H_ref.
```

Reference formula:

```text
H_ref =
  Gamma_ref [
    D_W^0 tensor I_CKM
    + I tensor r_b(15 I - M_CKM)
    - m0 I
  ].
```

Null-edge endpoint shape:

```text
H_ne =
  Gamma_K [
    D_ne^cov
    + W_NE,space
    + r_b(15 R_ne - M_CKM^ne)
    - m0 R_ne
  ].
```

The free mass window is:

```text
0 < m0 < min(2 r_W, 16 r_b).
```

Relevant source anchors:

```text
Neuberger, "Exactly massless quarks on the lattice", arXiv:hep-lat/9707022.
Neuberger, "More about exactly massless quarks on the lattice",
  arXiv:hep-lat/9801031.
Hernandez-Jansen-Luscher, "Locality properties of Neuberger's lattice Dirac
  operator", arXiv:hep-lat/9808010.
Creutz-Kimura-Misumi, "Index Theorem and Overlap Formalism with Naive and
  Minimally Doubled Fermions", arXiv:1011.0761.
Luscher, "Abelian chiral gauge theories on the lattice with exact gauge
  invariance", arXiv:hep-lat/9811032.
Adams, "Axial anomaly and topological charge in lattice gauge theory with
  Overlap Dirac operator", arXiv:hep-lat/9812003.
Golterman-Shamir, "Propagator zeros and lattice chiral gauge theories",
  arXiv:2311.12790.
```

Task:

Build a precise source-contract map for GateC1_NU.

Please answer:

1. Which source supports each formal theorem obligation?
2. Which obligations are only supported after additional hypotheses such as
   admissible gauge fields, anomaly cancellation, finite volume, or determinant
   line control?
3. Which claims must not be imported from the reference source alone?
4. How should the theorem stack be split between:
   `GateC1_NU_Free`,
   `GateC1_NU_BackgroundGauge`,
   and `GateC1_NU_Quantum`?
5. What exact provenance comments/docstrings should be attached to the future
   Lean structures or source-certificate predicates?
6. What is the smallest next Lean/source-certificate API Codex should implement
   after the operator-freeze API returns?

Claim boundaries to enforce:

```text
CKM/flavored mass terms support internal branch/flavor mass splitting.
They do not prove the actual null-edge endpoint resolves spacetime doublers.

GW algebra does not by itself prove determinant-line control.

HJL locality is conditional on smooth/admissible gauge fields and should not be
silently upgraded to local Gate C1 unless hypotheses are instantiated.

Adams anomaly/index support applies to the overlap reference in the physical
mass window; null-edge import requires the gapped homotopy and sector-signature
match.

Golterman-Shamir forbids using propagator zeros as mirror removal.
```

Requested output:

- source-to-obligation table;
- theorem-level split Free / BackgroundGauge / Quantum;
- Lean API recommendations;
- provenance text suitable for Markdown/Lean comments;
- no-overclaim checklist.
