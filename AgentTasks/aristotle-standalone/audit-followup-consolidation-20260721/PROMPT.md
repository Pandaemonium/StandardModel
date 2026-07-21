# Adversarial audit: are the CORRECTED readings now accurate?

Mathlib-only adversarial audit. A set of claims was corrected after earlier audits
found the original prose overclaimed. Audit the CORRECTED readings themselves - a
correction can also be wrong, or can over-correct into vacuity.

Corrected readings to test:
1. "internal spectral data do not determine an external readout that is not itself
   determined by that spectral data" - is this now VACUOUS (true by definition of
   'not determined by')? If so, say so and give the sharpest NON-vacuous form.
2. "the transfer witness separates raw two-point values only" - verify the connected
   normalized ratios really are both exactly 1/2, and confirm that no other standard
   readout (e.g. effective mass log(C(n)/C(n+1))) distinguishes them either.
3. "non-accumulation holds for block-diagonal assembly" - is that the SHARPEST true
   form, or does it extend to block-triangular, or to any assembly with orthogonal
   ranges? Give the sharpest.
4. "telescoping needs only contractions" - verify, and check whether it extends
   further (to power-bounded operators with a uniform bound C, giving C^2 n ||U-V||?).
5. "isometry is stronger than needed; ||U|| <= 1 suffices" - is ||U|| <= 1 itself
   sharp, or does the bound degrade gracefully so that no hypothesis is needed beyond
   boundedness? State the sharpest form.
For each: is the corrected reading ACCURATE, VACUOUS, or STILL NOT SHARP? Provide
witnesses. No new axioms/native_decide; standard axioms.
