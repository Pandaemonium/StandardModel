# Aristotle target: finite tetrad Palatini density identity

Prove the exact theorem
`palatiniDensity_eq_neg_det_mul_scalarCurvature` in
`PalatiniDensityEinstein/Target.lean` without changing any definition,
hypothesis, sign, normalization, index order, or target.

The theorem is the algebraic bridge required to identify the repository's
concrete complementary-face holonomy action with an Einstein-Hilbert scalar
density at an invertible coframe. Conventions are locked:

- spacetime and internal index order `(0,1,2,3)`;
- ordered bivector basis `(12,13,23,01,02,03)`;
- mostly-minus bivector Krein signs `(+,+,+,-,-,-)`;
- orientation `epsilon 0 1 2 3 = +1`;
- curvature is antisymmetric in the ordered spacetime face indices;
- both displayed inverse identities must remain hypotheses;
- the final sign is exactly minus.

An independent exact-rational oracle audit on a determinant-one nondiagonal
coframe found `palatiniDensity = -116` and `scalarCurvature = 116`; this fixes
the displayed minus sign but is not a proof. Do not weaken the theorem to
diagonal coframes, a basis witness, nonsingular determinant without the
identity, or an additional cofactor assumption.

A useful proof route is the four-dimensional adjugate/cofactor identity
relating two coframe columns contracted with two alternating symbols to
`det(coframe)` times two inverse-coframe entries. The curvature antisymmetry
then removes the antisymmetrization factor. Explicit finite-index expansion is
acceptable if it remains kernel checked.

Return the complete target file and a short summary of the crucial cofactor
lemma. If the main theorem cannot be closed, return the strongest exact helper
with the remaining Lean goal and do not alter the target.
