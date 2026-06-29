# Gate C1 Aristotle integration 19: C204-C208

Date: 2026-06-27

Integrated completed Aristotle jobs:

```text
C204: real artifact draft-promotion layout.
C205: ReferenceIsGapped for Wilson+CKM.
C206: concrete H_ne kappa inputs.
C207: GateC1_NU_Free abstract assembly.
C208: missing-source audit.
```

## Main result

`GateC1_NU_Free` now has an abstract external Lean assembly theorem.

This theorem consumes:

```text
C193 mass window and gamma_free;
C205 ReferenceIsGapped;
C194 kappa < gap -> gapped homotopy;
C206 NullEdgeKineticCloseEnough;
C196 sector-signature match;
C201 sign-stability;
C202 maintained spectral island.
```

and excludes:

```text
background-gauge;
determinant-line;
anomaly;
ghost-sector;
quantum/loop claims.
```

## Critical remaining inequality

C206 reduces the first-pass null-edge endpoint estimate to:

```text
kappaBranch + kappaKin + kappaWil < gamma_free
```

provided CKM and R transport exactly.

## Source plan

C208 prioritizes:

```text
Kato;
Davis-Kahan;
Hasenfratz-Laliena-Niedermayer;
Narayanan-Neuberger;
Fujikawa as secondary support.
```

## Warning

C204 confirms the correct path:

```text
promote the real C193/C194/C201/C202 artifacts;
do not use the C200 reconstruction.
```

## Verification

No local Lean checks were run during this integration. Aristotle reports its
standalone packages build in their request projects. Treat returned Lean as
external artifacts until locally promoted and checked.
