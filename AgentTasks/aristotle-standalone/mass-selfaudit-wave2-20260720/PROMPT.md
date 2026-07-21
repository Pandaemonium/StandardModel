# Adversarial audit: stress-test the Opus mass wave-2 landings for over-claim

Mathlib-only adversarial semantic audit (deliverable: AUDIT.md verdicts + any
counter-witness). A first audit found 3 docstring-outruns-kernel over-claims in
wave-1; repeat for wave-2. For each, verdict SOUND vs one of {vacuity, hollow-
telescoping, docstring-outruns-kernel, false-shape} + a Mathlib witness:
1. TransferPositiveBridge: `Cc(n)/lam1^n -> (v1)^2` claims the transfer gap IS the
   physical mass when overlap nonzero. QUESTION: does the claim secretly assume
   the observable has NO higher-mode contamination, i.e. is the limit really the
   gap or only a bound? Check the exact limit vs a bound.
2. KLAtomFiniteCore / KallenLehmannRepresentation / HermitianKallenLehmann: the
   physical-mass-exceeds-spectral-min witnesses. QUESTION: is `physicalMass` well
   defined when ALL weights vanish (v=0)? Check the degenerate/empty case.
3. NeutrinoMassClassification: `complete_four_branch_classification`. QUESTION: is
   "complete" genuine or does it omit the Dirac+Majorana simultaneous (pseudo-Dirac)
   case? Check whether a fourth mixed branch is missing.
4. InertialEquivalenceCore: `I(v)=Tr(M vv-dag)`. QUESTION: does the equivalence
   hold for non-Hermitian M, or is Hermiticity silently required?
5. A3FiniteGlueballSector: composite mass log 2. QUESTION: is the "reflection
   positivity" proved genuinely (Osterwalder-Seiler sense) or just positive-
   definiteness relabeled? Check what RP actually requires vs what is proved.
Success: 5 verdicts + witnesses for any over-claim + one strengthening. No new
axioms/native_decide; standard axioms; report axioms.
