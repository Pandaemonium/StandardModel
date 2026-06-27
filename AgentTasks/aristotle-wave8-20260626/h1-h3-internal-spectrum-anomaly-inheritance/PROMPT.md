# Aristotle Wave 8 job: H1/H3 internal spectrum API and anomaly inheritance

Type: Lean proof / API design.

Goal: define a reusable `NullEdgeInternalSpectrum` interface and prove anomaly inheritance from an existing Standard Model one-generation anomaly package.

Context:

Gate H is internal-sector support only. It does not solve null-edge kinetic geometry, Gate C, Gate D, or QCD. The goal is to keep internal charges, gradings, multiplets, and legal Yukawa maps explicit enough that Phi_H is not arbitrary.

Please do:

1. Inspect the included anomaly/Furey files and identify the canonical existing object representing one Standard Model generation.
2. Design a small `NullEdgeInternalSpectrum` record/API with fields sufficient for charge/multiplet/grading bookkeeping, but not overfit to Furey.
3. Prove an inheritance theorem of the form: if a null-edge internal spectrum maps to the existing `standardModelOneGeneration` data, then the relevant anomaly cancellation package is inherited.
4. If the existing anomaly package already has a theorem that can be wrapped, write the wrapper theorem rather than reproving arithmetic.
5. Keep Furey as one realization of the API, not as a mandatory kinetic assumption.

Deliverables:

- Proposed file path, preferably `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean` plus a small anomaly inheritance companion if needed.
- Lean theorem statements and proof patches where feasible.
- A semantic note listing which anomalies are inherited and which are not claimed.
