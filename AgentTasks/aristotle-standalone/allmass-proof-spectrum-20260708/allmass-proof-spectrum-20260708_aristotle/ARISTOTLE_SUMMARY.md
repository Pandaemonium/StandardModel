# Summary of changes for run 14102f3d-adf9-4714-bdde-96c20122cf12
Proved `B_spectrum` in `AllMassSpectrum/Core.lean`, replacing the `package_ok` placeholder. `B` and `B_isHermitian` are kept unchanged.

**Result delivered (via `spectrum ℝ`):**
`B_spectrum : spectrum ℝ (B lam kappa) = {lam - kappa, lam, lam + kappa}` — the set of eigenvalues of the 3×3 Hermitian carrier mass block is exactly aperture-minus-closure, aperture, and aperture-plus-closure.

**Approach.** I chose the `spectrum ℝ` formulation from the docstring since Mathlib supports it cleanly for a complex matrix viewed as an ℝ-algebra. A helper lemma `B_det_sub` computes the characteristic determinant `det (algebraMap ℝ _ r - B lam kappa) = (r - lam) * ((r - lam)^2 - kappa^2)` via `Matrix.det_fin_three` and `Complex.I_sq`. The main proof then uses `spectrum.mem_iff`, `Matrix.isUnit_iff_isUnit_det`, and `isUnit_iff_ne_zero` to reduce membership to `det = 0`, factors the determinant as `(r-(lam-kappa))(r-lam)(r-(lam+kappa))` (all real casts, via `push_cast`/`Complex.ofReal_eq_zero`), and reads off the three roots.

**Semantic alignment.** The formalized statement matches the informal target exactly: the physical eigenvalue set `{lam-kappa, lam, lam+kappa}` corresponds to the three mass levels, with the least eigenvalue `lam-kappa` being the squared mass gap (aperture − closure), strengthening the earlier least-eigenvalue result. The determinant helper also matches the stated `det = lam*(lam^2 - kappa^2)` (evaluated at `r = lam` gives the product-of-eigenvalues determinant).

**Verification.** `lake env lean AllMassSpectrum/Core.lean` compiles with no errors and no `sorry`/`admit` (the only textual "sorry" is in the pre-existing docstring). `#print axioms AllMassSpectrum.B_spectrum` reports only `[propext, Classical.choice, Quot.sound]` — kernel-clean, Mathlib-only.

Committed and pushed to `origin/main`.
