# Aristotle Wave 8 job: B6/B9 Plucker obstruction and SL2C covariance

Type: Lean proof / theorem packaging.

Goal: package the P1 Plucker mass invariant as the first canonical obstruction-map instance and add the strongest realistic covariance wrapper.

Guardrail:

Do not claim all mass is Plucker spread. P1 is the finite kinematic theorem: massless iff the two null directions are collinear, with the Plucker determinant/spread as invariant accounting.

Please do:

1. Inspect the included Plucker/P1 Lean files and identify the strongest existing finite theorem for two-null masslessness and mass product.
2. Propose a small canonical-obstruction wrapper for the Plucker obstruction B_Pl if it can be done without overengineering.
3. Prove or stage an SL(2,C)-style covariance theorem using the existing project abstractions. If full SL(2,C) is too heavy, prove the strongest available covariance/invariance statement and explain the gap.
4. Keep determinant, trace, frame-relative, and invariant mass normalizations distinct.
5. Identify which theorem is publishable for P1 and which remains draft infrastructure.

Deliverables:

- Lean patch or precise theorem statements.
- A P1 theorem-to-Lean crosswalk table.
- A short note saying exactly what novelty P1 can safely claim.
