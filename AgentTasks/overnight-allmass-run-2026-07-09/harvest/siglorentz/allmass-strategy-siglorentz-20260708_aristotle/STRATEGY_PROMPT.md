# Proof: reflection positivity selects Lorentzian (signature rung 2)

Context: a finite null-edge program proved rung 1 (a nonzero null edge forces an
INDEFINITE Gram; both (1,3) and (2,2) are indefinite). Rung 2 -- WHY exactly one time
-- was only stated as a probe, because the (1,3)-vs-(2,2) distinction lives in the
Osterwalder-Schrader lattice/tensor reflection structure, not the quadratic form alone.

Target: build the smallest explicit OS reflection-positivity toy (a finite lattice
with a reflection across a distinguished direction, a Gaussian/Gram reflection form)
in each signature and prove: the (1,3) toy is REFLECTION POSITIVE with a nondegenerate
physical sector, while the (2,2) toy FAILS reflection positivity (its reflection Gram
is not positive semidefinite on the reflected half / the physical sector degenerates).
This converts "exactly one time" from a probe into a finite RP-selection theorem.
Kill: a (2,2) toy passing OS positivity with a nondegenerate physical sector.

Kernel-checked only, no sorry/admit/axiom/native_decide, in-file print axioms guard,
footprint [propext, Classical.choice, Quot.sound], Mathlib only. Deliver Lean + honest
ARISTOTLE_SUMMARY.md (the RP definitions, the (1,3)-passes / (2,2)-fails theorems, or a
precise obstruction if the full result resists).
