# Claude adversarial cross-family review: ScalarKleinEqualityCore (be3e675b)

- Reviewer: interactive Claude Code (claude family), adversarial pass
- Builder: Codex (Aristotle be3e675b)
- Work item: `DYN-MODULAR-001`
- Source: `PhysicsSM/Draft/NullEdge/ScalarKleinEqualityCore.lean` (126 lines)
- Date: 2026-07-13

## Verdict: ACCEPT

The scalar strictness core for the quantum-Klein EQUALITY case (uniqueness),
honestly scoped as the scalar lemma, not the full `rho = sigma`.

## The three required checks

1. **Single global zero entropy gap yields termwise zero, via nonnegativity.**
   `g i j = lam_i p_ij (log lam_i - log mu_j) - p_ij (lam_i - mu_j)`.
   `hsum` proves `sum_i sum_j g i j = (sum lam_i log lam_i) -
   (sum sum lam_i p_ij log mu_j) - (sum sum p_ij lam_i) + (sum_j mu_j sum_i p_ij)`.
   The last two terms are `sum_i lam_i * 1 = 1` (hrow, hlamsum) and
   `sum_j mu_j * 1 = 1` (hcol, hmusum), so they cancel and the total gap equals
   exactly the entropy expression in `heq`, which is `0`. Then `hzero` uses
   `Finset.single_le_sum` (each nonneg term is <= the zero total) plus
   `le_antisymm` with `hnonneg` to force every `g i j = 0`. Genuine derivation of
   termwise zero from the single global zero -- no per-term assumption smuggled.

2. **`lam = 0` / nonzero-overlap branch excluded correctly.**
   `klein_term_nonneg` deliberately ALLOWS `a = 0` (the gap becomes
   `q * b >= 0`). `klein_term_eq` then EXCLUDES `a = 0`: with `q > 0` and
   `b > 0`, `a = 0` forces the gap to `q * b > 0`, contradicting the zero
   hypothesis, so only `a > 0` survives and `term_eq` applies. Correct handling
   of the zero-eigenvalue case.

3. **Concludes exactly `mu j = lam i` with no hidden termwise assumption.** For
   `p i j != 0` (hence `> 0`), `klein_term_eq (lam i) (mu j) (p i j) ... (hzero i j)`
   yields `lam i = mu j`, returned as `mu j = lam i` (`.symm`). The `p i j > 0`
   weight is exactly what excludes the degenerate branch; the termwise zero came
   from the global hypothesis, not an assumption.

## Supporting lemmas

- `term_bound`: `a - b <= a (log a - log b)` for `a, b > 0`, from
  `Real.log_le_sub_one_of_pos`. Correct scalar Klein/Gibbs term inequality.
- `term_eq`: equality forces `a = b`, from the STRICT `Real.log_lt_sub_one_of_pos`
  (strict unless `b/a = 1`). Correct.

## Overclaim tests

- Vacuity: none -- `scalar_klein_eq_subsingleton_control` (Fin 1: `lam 0 = mu 0 = 1`)
  is a non-vacuity control; the main theorem has genuine doubly-stochastic content.
- Hollow telescoping: none -- the `hsum` normalization cancellation, the
  `single_le_sum` termwise-zero argument, and the `a = 0` exclusion are real work.
- Docstring overreach: none -- explicitly "the scalar doubly-stochastic equality
  lemma ... the strictness core needed BEFORE the separate eigenvector-overlap
  reconstruction can prove `rho = sigma`." It does not claim the matrix equality.
- False shape: none -- doubly-stochastic Jensen equality forcing equal eigenvalues
  on the support is the correct strictness shape.

## Independent verification

- `lake build PhysicsSM.Draft.NullEdge.ScalarKleinEqualityCore`: Build completed
  successfully (8026 jobs), exit 0. Both `#guard_msgs` blocks
  (`scalar_klein_eq`, `scalar_klein_eq_subsingleton_control`) fired and passed;
  axiom footprint `[propext, Classical.choice, Quot.sound]`, build-enforced.

## Narrowest defensible claim

For probability vectors `lam` (nonnegative, zeros allowed) and `mu` (strictly
positive) and a doubly-stochastic `p`, if the scalar relative-entropy expression
`sum lam_i log lam_i - sum_i sum_j lam_i p_ij log mu_j` vanishes, then every
nonzero overlap `p i j` forces `mu j = lam i`. This is the SCALAR strictness core
of the quantum-Klein equality case; it is not, by itself, the matrix statement
`rho = sigma`, which still requires the separate eigenvector-overlap
reconstruction.
