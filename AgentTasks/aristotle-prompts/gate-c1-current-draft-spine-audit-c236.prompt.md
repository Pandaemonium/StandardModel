Gate C1 current Draft spine audit, C236

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

The live Draft Gate C1 spine has accumulated several modules:

```text
CKMWilsonWindow.lean
GappedHomotopy.lean
SignStability.lean
ProjectorPersistence.lean
OperatorFreeze.lean
BranchKernelChiralIndexZero.lean
SpectralProjectorAPI.lean
```

Codex has not run live Lean checks. The goal is not to prove GateC1_NU; it is
to audit the current Draft spine for import-path, namespace, duplicate-name,
and aggregator-readiness issues.

Task:

Audit the included files and answer:

1. What is the correct minimal build/import order?
2. Which files are self-contained and which depend on sibling modules?
3. Are the import paths in `OperatorFreeze.lean` and
   `BranchKernelChiralIndexZero.lean` correct for live repo module names?
4. Does `SpectralProjectorAPI.lean` safely avoid the `GateC1.OperatorFreeze`
   namespace collision?
5. Are there remaining doc-comment/import-order/parser risks?
6. Is it safe to add an import-only aggregator now, or should that wait for
   local live checks?
7. What exact local patch plan should Codex apply before verification?

Constraints:

- Treat all code as Draft.
- Do not claim live repo verification unless actually run in this package.
- Do not weaken theorem statements.
- Do not claim GateC1_NU.

Requested output:

- audit report;
- exact patch plan;
- aggregator recommendation;
- remaining blockers.
