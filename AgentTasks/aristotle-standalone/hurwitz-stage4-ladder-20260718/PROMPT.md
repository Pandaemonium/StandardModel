# Task: Hurwitz stage 4a - the doubled subalgebra ladder step

Project: Lean 4 (v4.28.0) + Mathlib. Kernel-checked Hurwitz theorem campaign
(a finite-dimensional unital composition algebra over R has dimension 1, 2,
4, or 8). Self-contained package: `HurwitzToolkit/Target.lean` (stage 1,
PROVEN: 15 composition-form identities), `HurwitzToolkit/Stage2.lean`
(stage 2: the three doubling theorems PROVEN on the lemma tower; two
documented holes remain in the Moufang pair `associator_mul_right`,
`mul_right_moufang` - a separate job is closing them).

## Target

`HurwitzToolkit/Stage4.lean` - all seven theorems currently ending in a
hole. Mathematical content (Springer-Veldkamp Ch.1 / Baez sec 2.2
lineage, clean-room): the internal Cayley-Dickson double
`doubledSubmodule S a = S + S*a` of a unital subalgebra `S` along an
orthogonal element `a` is again a unital subalgebra; with `Q a /= 0` its two
summands intersect trivially and its dimension is exactly doubled; and every
PROPER submodule of a finite-dimensional composition algebra admits a
nonzero orthogonal element (which is automatically anisotropic).

## Hole-dependence split (IMPORTANT, pre-registered)

- `doubledSubmodule_mem_iff`, `conj_doubled_mem`, `exists_orthogonal_ne_zero`
  must NOT use the two holed Moufang lemmas (their proofs need only stage-1
  identities, `polar_mul_orthogonal`, and linear algebra). The stage-3a
  precedent proved its main theorem with zero holes this way.
- `doubled_isUnitalSubalgebra`, `doubled_inf_map_eq_bot`, `finrank_doubled`,
  `ladder_step` MAY use `doubling_product/closed/norm` (which currently
  inherit the Moufang holes); that inheritance is accepted and tracked.

Proof hints: `conj Q (y*a) = -(y*a)` for `y in S` follows from
`polar_mul_orthogonal` with `x = 1` (trace-zero) - this gives conj-closure
of the double. For `doubled_inf_map_eq_bot`: an element `x = y*a` in the
intersection has `polar Q x x = 2 Q x` but also `polar Q x (y*a) = 0` by
`polar_mul_orthogonal`, forcing `Q x = 0`, then anisotropy kills it. For
`exists_orthogonal_ne_zero`: the polar bilinear form is nondegenerate
(stage-1 `polar_nondegenerate`); a proper submodule of a finite-dimensional
space has a nonzero vector in the orthogonal complement of its polar form.
For `finrank_doubled`: right multiplication by `a` is injective on `S`
(`Q (y*a) = Q y * Q a` and anisotropy), so
`finrank (S.map (mulRight a)) = finrank S`, and the trivial intersection
gives the sum formula.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Keep statements EXACTLY as given; if a statement genuinely needs an extra
  standard hypothesis (e.g. `FiniteDimensional`), add it explicitly and
  record the addition prominently in the docstring - do not silently weaken.
- Standard axioms only, apart from the accepted inheritance of the two
  documented Stage2 holes in the second group.
- Verify with `lake env lean HurwitzToolkit/Stage4.lean` first; avoid a full
  `lake build` until the holes are closed.

## Success criteria

All seven theorems proven (first group with zero-hole proofs; second group
may inherit the documented Stage2 holes only), plus a short completion
report: solved targets, any hypothesis additions, remaining holes, axioms.
