# Adversarial audit: do the MC brick DOCSTRINGS overclaim relative to their statements?

Mathlib-only adversarial audit. Fifteen support bricks were produced for a continuum
ladder. Each is kernel-verified, but a prior audit round found that PROSE, not
statements, is where overclaim enters. Audit these docstring claims against what the
stated theorems can actually support. For each, verdict + a Mathlib witness if the
prose outruns the kernel.

Claims as written in the bricks:
1. "unitary conjugation is a genuine isometry, so the basis change does not enlarge
   the estimate" - is this true for ALL unitaries, or only for conjugation by a FIXED
   unitary independent of the step parameter? Prove or refute the general form.
2. "the four-component constant does NOT accumulate" - true for BLOCK-DIAGONAL
   assembly; is it true for a general 4x4 built from 2x2 blocks INCLUDING off-diagonal
   blocks? Witness the failure if not.
3. "the tail bound is mass-independent" - true because it uses only unitarity; verify
   there is no hidden dependence via the tail SET depending on the mass.
4. "a walk supplies only its one-step constant" (many-step skeleton) - does it also
   implicitly supply the group law and unitarity? State what is actually required.
5. "componentwise reuse is free" - free in the CONSTANT, but is it free in the
   MEASURABILITY hypotheses, or must those be re-established per component?
For each: SOUND or PROSE-OUTRUNS-STATEMENT, with a witness for the latter. This is a
self-check of my own bricks; be adversarial, not charitable.
No new axioms/native_decide; standard axioms; report axioms.
