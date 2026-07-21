# Non-diagonal perturbation stability for the rank-four spectral sector

Work in `RankFourSelector/GeneralPerturbation.lean`. The exact diagonal
sub-gap stability theorem is proved and axiom-clean. Push to the strongest
finite-dimensional theorem that survives a general self-adjoint perturbation.

Preferred target: for a finite-dimensional real or complex self-adjoint
operator with an isolated four-eigenvalue cluster separated by gap `delta`, an
operator-norm perturbation below an explicit fraction of `delta` has a
four-dimensional perturbed spectral subspace, with an explicit projector or
subspace-distance bound (Davis-Kahan/Riesz-projector shape). Use existing
Mathlib spectral APIs where practical.

First kill-test the false exact claim that the old Lagrange projector remains
unchanged under an arbitrary noncommuting perturbation; land a small rational
counterexample if it is false. Then formalize either the full finite theorem or
the strongest clean predecessor, and state at most three exact missing Mathlib
lemmas. Do not silently restrict back to diagonal perturbations. Add
assumption-footprint guards to every landed headline theorem and run the narrow
file. Read `CONTEXT.md`.
