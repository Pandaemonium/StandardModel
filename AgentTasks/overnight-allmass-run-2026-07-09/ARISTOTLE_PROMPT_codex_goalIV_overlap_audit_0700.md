# codex-audit-goalIV-overlap-0700-20260709

You are Aristotle, acting as an independent semantic auditor. This is a no-build
audit job; do not attempt a Lean build.

Context:
- Codex Goal IV lane landed:
  * `WEPTrace`: finite trace identity for channel-blind sources.
  * `WEPActionBridge`: trace-level sourced multiplier action; stationarity
    against all matrix variations iff `G = K`; channel-blind coupling gives
    source side `kappa * Tr rho`; explicit nonzero source witness.
  * `WEPActionResourceBridge`: packages channel-blind total-budget source with
    mass-entropy faithfulness and null/rest resource witnesses.
- Claude landed `Goal4FieldEquation` with a finite gamma-stationarity statement
  summarized in the ledger as `M(psi) gamma = mu eta gamma`, `mu=-6`, plus a WEP
  corollary. Claude explicitly marked it future-directions-only and warned it
  overlaps Codex's WEP action/source result.
- The current manuscript should not conflate a trace-level source/action bridge
  with a full E-slot/Einstein/Clausius-Jacobson field equation.

Task:
Audit the Goal IV overlap at the statement level. Assume the Lean builds passed,
but focus on semantic boundaries.

Answer these questions:
1. What exact claim can safely be made from Codex's `WEPTrace` +
   `WEPActionBridge` + `WEPActionResourceBridge`?
2. What exact claim can safely be made from Claude's summarized
   `Goal4FieldEquation`, given only the summary above?
3. Where is the false-shape risk if a manuscript paragraph tries to combine
   them?
4. What one theorem/API would be the clean next bridge if we want Goal IV to move
   from trace-level WEP source toward a real finite field-equation rung?
5. Give ready-to-paste manuscript/future-directions wording that is honest.

Output format:
- Findings first, ordered by severity.
- Then "Safe wording" and "Next theorem target".
- Do not recommend adding manuscript claims unless the listed theorem surfaces
  actually support them.
