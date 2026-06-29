Project name: gate-c1-assembly-theorem-skeleton-c192

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current status:
We now have many certificate interfaces:
- CKM table and shifted one-sector window.
- Pure parity no-go.
- Wilson/Neuberger first-reference recommendation.
- Sub-gap homotopy and C170/C181 constants.
- Sector-signature match.
- Determinant/ghost certificate.
- Anomaly/index source interface.
- Krein-sign continuity.
- SMActsInternally gauge safety.
- Non-ultralocal control is still pending/running as C184.

Task:
Build a final GateC1_NU assembly theorem skeleton that names every required certificate and proves only the structural implication: if all certificates are supplied, then GateC1_NU holds. This should not claim any certificate is automatically true.

Requested output:
1. A clean record/structure list for all certificate inputs.
2. A theorem `GateC1_NU_of_reference_import` or similar.
3. Explicit separation of finite/table facts, reference facts, homotopy facts, gauge/anomaly/determinant/Krein/locality facts.
4. A dependency graph showing which certificates feed which conclusions.
5. A list of currently proved certificates vs still external obligations.
6. Lean-ready or standalone Lean formalization if feasible.

This is an assembly/interface job. No hidden assumptions; no silent closure of Gate C1.
