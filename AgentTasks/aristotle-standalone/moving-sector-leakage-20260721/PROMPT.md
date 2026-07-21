# Aristotle target: moving-sector leakage telescope

Prove every theorem in `MovingSectorLeakage.lean` under the exact displayed
hypotheses. Run `lake env lean MovingSectorLeakage.lean` first.

Scientific role: this is the finite algebra for an adiabatically transported
low-energy band. The selected projector is allowed to change at every substep.
The final leakage should be bounded by the sum of one-step defects
`(1-P_{k+1}) U_k P_k`.

Preserve the generic `NormedRing` setting and the stated time ordering. Do not
add commutativity, star, self-adjointness, matrix, or finite-dimensional
assumptions. You may repair a theorem only if it is genuinely false as stated;
report the exact repair and why. Do not add axioms, opaque definitions, unsafe
code, native_decide, admit, or leave sorry. Small helper lemmas are welcome.

Finish with a concise report listing solved targets, any statement repairs,
and the exact narrow Lean command that passed.
