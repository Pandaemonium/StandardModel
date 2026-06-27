# Aristotle Wave 8 job: A1 Gate A super-Dirac square closeout

Type: Lean proof / semantic closeout.

Goal: finish the Gate A super-Dirac sign/square bridge before any finite square theorem is promoted.

Use the included Gate A closeout, sign-counterexample reports, and relevant Lean files. The target is a kernel-facing theorem package that makes the safe sign convention explicit:

- Phi_H is chi_E-odd.
- Phi_H commutes with spacetime chirality Gamma_s unless an included file proves a different convention.
- The super-Dirac square has the desired positive internal mass block Phi_H^2 under the locked convention.
- Wrong grading/sign variants should be isolated as counterexamples or rejected assumptions.

Please do:

1. Identify the strongest existing theorem in the included files that already proves the intended square/sign statement.
2. If there is a missing bridge theorem, propose and prove it, preferably in `PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean` or a minimal companion draft file.
3. Preserve existing definitions and signs unless there is a documented mismatch.
4. State the exact imports and convention dependencies.
5. If the requested theorem is false, return the minimal counterexample and the corrected statement.

Deliverables:

- A patch or complete theorem text.
- A short semantic note explaining the sign and grading assumptions.
- A promotion checklist for Gate A.
