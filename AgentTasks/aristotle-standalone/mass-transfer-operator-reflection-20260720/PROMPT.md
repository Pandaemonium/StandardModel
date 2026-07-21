# Aristotle prompt: transfer operator to reflection-positive pole

Complete every proof in `TransferOperatorReflection/Main.lean` without changing
the theorem statements. Run the narrow target first:

```text
lake env lean TransferOperatorReflection/Main.lean
```

The scientific target is a finite operator-level bridge. A real symmetric
transfer matrix should generate a reflected two-point kernel as an orbit Gram
matrix, hence reflection positivity. A visible eigenmode should then have exact
exponential correlation decay and a positive simple resolvent residue at
energy `-log lambda`. The final `diag(1,1/2)` fixture is mandatory and prevents
vacuity.

Do not claim full field-algebra reflection positivity, infinite-volume OS
reconstruction, a continuum pole, confinement, or a measured mass. Do not
weaken equalities to inequalities. Small helper lemmas are welcome. If a
statement is false because of an inner-product convention, report the exact
minimal convention correction and prove the strongest corrected version in an
additional theorem while preserving the original theorem for diagnosis.

Return the completed source and a short semantic report naming every hypothesis
that is load-bearing.
