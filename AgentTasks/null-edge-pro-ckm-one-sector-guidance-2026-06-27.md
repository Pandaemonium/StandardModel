# Null-edge Gate C1 CKM one-sector guidance

Date: 2026-06-27

Purpose: record the latest Pro guidance and convert it into concrete Gate C1
theorem obligations.

## Executive summary

The cleanest near-term Gate C1 path is now:

```text
known one-sector flavored-overlap reference
  -> CKM-style null-edge branch mass table
  -> shifted one-sector mass window
  -> sector-signature match
  -> uniformly gapped homotopy
  -> imported overlap/GW/index/anomaly/control certificates
  -> GateC1_NU
```

The finite branch seed remains important, but it is not itself the release. It
is the finite input to a reference-kernel import theorem.

## Main correction

The pure product/parity point-split mass

```text
M_P(corner) = (-1)^level
```

is useful but insufficient in four branch directions. It selects an eight-sector
parity multiplet, not a single physical sector.

The preferred mass is the Creutz-Kimura-Misumi style one-sector
naive flavored-overlap mass:

```text
M_CKM = M_P + M_V + M_T + M_A
```

with intended corner values:

```text
M_CKM(level 0) = 15
M_CKM(level > 0) = -1
```

Then test:

```text
W_branch^(1) = r (15 R - M_CKM).
```

In the `R = I` diagnostic case:

```text
W_branch^(1)(level 0) = 0
W_branch^(1)(level > 0) = 16r
0 < m0 < 16r selects exactly one light sector.
```

## Reference priority

Use references in this order:

```text
1. CKM one-flavor naive flavored-overlap kernel.
2. Wilson overlap as a sanity comparison.
3. Adams staggered overlap only if the branch factor is taste-like.
4. Domain-wall or boundary import as fallback and anomaly/gap cross-check.
```

## Homotopy criterion

The central import move is:

```text
H_t = H_ref + t (H_ne - H_ref)
```

with:

```text
||H_ne - H_ref|| < gamma_ref
```

so the gap remains open with residual margin:

```text
gamma_ref - ||H_ne - H_ref||.
```

The error budget should be decomposed into:

```text
E_D, E_W, E_R, E_Gamma, E_gauge.
```

## Next theorem obligations

```text
PureProductParity_NoGo_4D:
  pure product/parity mass gives an eight-plus-eight split, not one sector.

CKM_MassTable_OneSector_4D:
  prove the CKM mass table 15 at level zero and -1 at every nonzero corner.

ShiftedCKM_OneSector_Window:
  prove W_branch^(1) gives the one-sector window 0 < m0 < 16r for R = I,
  and state the general R-version as certificate assumptions.

GappedHomotopy_To_CKM_Reference:
  prove the sub-gap norm criterion from CKM reference to null-edge kernel.

SMActsInternally_GaugeSafety_Wbranch:
  prove or audit that the branch mass commutes with the SM internal action.

IndexImport_OverlapHomotopy:
  package index/anomaly/GW/projector import along a gauge-safe gapped homotopy,
  with ghost, Krein, and non-ultralocal control certificates explicit.
```

## Claim boundary

Do not claim:

```text
pure parity solves one-sector C1;
finite seed is the release;
CKM resemblance proves Gate C1;
overlap algebra alone proves anomaly accounting or locality/control;
bad sectors may be removed by propagator zeros.
```

Do claim:

```text
The CKM one-sector flavored-overlap route gives the most concrete current
operator family and turns Gate C1 into finite mass-table, mass-window,
sector-signature, gapped-homotopy, and audit-certificate obligations.
```
