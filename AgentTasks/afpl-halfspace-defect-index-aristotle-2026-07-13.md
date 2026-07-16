# Aristotle: localized half-space defect index precursor

Prove the exact finite matrix targets in `HalfSpaceDefectIndex/Core.lean`.
Audit the sign convention carefully. The intended lesson is that global finite
trace cancellation coexists with a nonzero localized boundary defect whose
opposite compensator is pushed to the far cutoff. Add a theorem showing the
localized value stabilizes as the cutoff grows, and explain the clean Lean
route from this precursor to a unilateral-shift Fredholm index if the pinned
Mathlib API permits it. Do not claim a bulk-boundary theorem.
