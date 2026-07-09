# Summary of changes for run 739f5708-fa03-45e2-9c29-9101c6ee8152
Delivered `RequestProject/Main.lean` (namespace `DiracOperatorMassShellDet`) plus `ARISTOTLE_SUMMARY.md`. The file builds cleanly with no `sorry`/`admit`/`native_decide`/new axioms, over the rational field `Q := ℚ` (real Dirac representation — no `Complex`, no `Real.sqrt`, no transcendentals, no `nlinarith`).

Proved, each with an in-file `#guard_msgs (whitespace := lax) in #print axioms` audit confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`:
- `pslash_sq`: `pslash * pslash = (E²-kz²)•1`.
- `dirac_det` (PAYLOAD): `det(pslash - m·1) = (m² - E² + kz²)²` — expanded via cofactor expansion (`Matrix.det_succ_row_zero`) on the explicit rational 4×4 matrix and closed by `ring` (perfect square, pure polynomial identity).
- `det_zero_iff_massshell` (PAYLOAD): `det D = 0 ↔ E²-kz² = m²` (singular exactly on the mass shell).
- `det_pos_iff_off_shell`: `0 < det D ↔ E²-kz² ≠ m²` (invertible off shell).
- `massless_det`: at `m=0`, `det D = (E²-kz²)²`.
- `dirac_massshell_det_verdict` (VERDICT): packages the three facts for all `E,kz,m`.

Mandatory non-degeneracy witnesses discharged by `norm_num`: on-shell `onshell_witness` (`D 5 3 4`, det 0), off-shell `offshell_witness` (`D 5 3 3`, det 49 and positive), massless `massless_witness` (`D 5 3 0`, det 256).

`ARISTOTLE_SUMMARY.md` records the method, the axiom audit, the PhysLean gamma-convention provenance line (reference only, not imported; Mathlib only), and the honest reading (the 4-spinor Dirac-operator determinant face of mass, the real (t,z) avatar of the Dirac dispersion relation as finite kernel-checked matrix algebra, complementing the separate 2×2 little-group `det P = m²`). All work committed and pushed.

# DiracOperatorMassShellDet — the 4-spinor Dirac-operator determinant face of mass

## What is proved

All results live in `RequestProject/Main.lean`, namespace `DiracOperatorMassShellDet`, over the
rational field `Q := ℚ` (real Dirac representation, so a rational 4×4 problem — **no `Complex`, no
`Real.sqrt`, no transcendentals**).

The Dirac operator on the `(t, z)` plane is `D E kz m = pslash E kz - m • 1`, with the Feynman slash
`pslash E kz = E • g0 - kz • g3`.

Headline theorems (each with an in-file `#guard_msgs (whitespace := lax) in #print axioms` audit):

1. `pslash_sq` : `pslash * pslash = (E² - kz²) • 1` (the operator-level on-shell relation).
2. `dirac_det` (PAYLOAD) : `det (pslash - m·1) = (m² - E² + kz²)²`. The characteristic determinant is
   a **perfect square**, so the whole thing is a rational polynomial identity closed by `ring` — the
   square root cancels, there is nothing transcendental.
3. `det_zero_iff_massshell` (PAYLOAD) : `det D = 0 ↔ E² - kz² = m²`. `D` is singular **exactly** on
   the mass shell — this is the determinant-level mass-shell test `det D(q) = 0`.
4. `det_pos_iff_off_shell` : `0 < det D ↔ E² - kz² ≠ m²`. Off the mass shell the determinant is a
   positive square, so `D` is invertible.
5. `massless_det` : at `m = 0`, `det D = (E² - kz²)²` — the square of the little-group disagreement
   `E² - kz²`.
6. `dirac_massshell_det_verdict` (VERDICT) : packages (2)+(3)+(4) for all `E, kz, m`.

MANDATORY non-degeneracy witnesses (all in-theorem, discharged by `norm_num`):
- on-shell `E=5, kz=3, m=4` (`E²-kz²=16=m²`): `onshell_witness : det (D 5 3 4) = 0`;
- off-shell `E=5, kz=3, m=3`: `offshell_witness : det (D 5 3 3) = 49 ∧ 0 < det (D 5 3 3)` (invertible);
- massless `E=5, kz=3, m=0`: `massless_witness : det (D 5 3 0) = 256`.

## Method

`pslash` and `D` are built from explicit rational 4×4 gamma matrices. `D_eq` rewrites `D` as an
explicit matrix literal via `ext; fin_cases; simp`. `dirac_det` then expands the 4×4 determinant with
cofactor expansion (`Matrix.det_succ_row_zero`, `Fin.sum_univ_succ`, `Fin.succAbove`) and closes the
degree-4 polynomial identity in `E, kz, m` with `ring`. The mass-shell iff results follow from
`dirac_det` by elementary field algebra (`pow_eq_zero_iff`, `sq_nonneg`, `linarith`). No `nlinarith`.

## Axiom footprint

Every headline depends on exactly `[propext, Classical.choice, Quot.sound]`, checked in-file by
`#print axioms`. No `sorry`/`admit`/`native_decide`, no new axioms.

## Provenance and honest reading

**Gamma convention (PhysLean reference, NOT imported):** the real Dirac-representation matrices
`g0 = diag(1,1,-1,-1)` and `g3` follow the same `(t, z)`-plane convention as PhysLean's Dirac-matrix /
projector modules. PhysLean is used only as a reference for the convention; it is **not** a dependency
(Mathlib only).

**Honest reading:** this is the 4-spinor determinant face of mass — the real `(t, z)` avatar of the
Dirac dispersion relation, realized as finite, kernel-checked matrix algebra. Because `pslash² =
(E²-kz²)·1`, the operator `pslash` has characteristic polynomial `(X² - (E²-kz²))²`, making the Dirac
determinant a perfect square; hence the mass-shell test `det D(q) = 0` is a purely rational polynomial
statement. This complements the 2×2 little-group statement `det P = m²` (with `P = p·σ`). The
little-group matrix `P` is a **separate** object; it is referenced only in docstrings for
interpretation and is not claimed equal to anything here.
