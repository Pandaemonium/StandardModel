# Adversarial audit: stress-test the remaining Opus mass landings (wave-3)

Mathlib-only adversarial semantic audit (AUDIT.md verdicts + witnesses). Two prior
audits caught 6 docstring/false-shape over-claims in my mass landings (statements
sound, prose overreached). Audit the REMAINING landings for the four over-claim
modes {vacuity, hollow-telescoping, docstring-outruns-kernel, false-shape}:
1. PlueckerYukawaModuli / YukawaConditionalUniqueness: "1-dim intertwiner + phase
   fix => unique". QUESTION: does "phase fix" secretly need the coupling nonzero?
   Is uniqueness vacuous if the intertwiner space is {0} (no admissible coupling)?
2. MechanismMatrixConsistency: "Gamma-odd cap Gamma-even = {0}". QUESTION: does this
   require Gamma to be an involution with no fixed... i.e. is the claim vacuous if
   the grading is trivial (Gamma = 1)? Check the degenerate grading.
3. ResolventResponsePole: the (z+1)^-1 vs (z-1)^-1 entries. QUESTION: are these the
   full physical response or just the (0,0) matrix entry - does the docstring
   conflate a single entry with the observable two-point function?
4. UniformQuasienergyGap: "uniform margin delta>0". QUESTION: is delta>0 vacuous if
   the parameter space K is empty? Check the [Nonempty K] hypothesis is load-bearing.
5. SeesawNGeneration: the light mass -mD MR^-1 mD^T. QUESTION: does the block
   diagonalization silently assume MR symmetric, or hold for general invertible MR?
For each: verdict + Mathlib witness for any over-claim + one strengthening if sound.
No new axioms/native_decide; standard axioms; report axioms.
